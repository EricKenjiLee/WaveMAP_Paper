import numpy as np
from matplotlib.gridspec import GridSpec
from matplotlib import pyplot as plt
from matplotlib.colors import ListedColormap
from umap import umap_ as umap
import networkx as nx
import cylouvain
from matplotlib import cm
import os
import random
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.metrics import confusion_matrix
import xgboost as xgb
import shap

RAND_STATE = 42

def set_rand_state(RAND_STATE):
    np.random.seed(RAND_STATE)
    os.environ['PYTHONHASHSEED'] = str(RAND_STATE)
    random.seed(RAND_STATE)
    return None
    
def train_gridsearch_classifier(umap_df,test_size=0.3,num_CV=5,verbose=0):
    UMAP_X = np.stack(umap_df['waveform'].to_numpy().tolist(), axis=0)
    UMAP_y = umap_df['cluster_id'].to_numpy()
    UMAP_X_train, UMAP_X_test, UMAP_y_train, UMAP_y_test = train_test_split(UMAP_X,     UMAP_y, test_size=test_size, random_state=RAND_STATE)

    UMAP_model = xgb.XGBClassifier(objective='multi:softmax',verbosity=verbose)
    UMAP_param_dist = {"max_depth": [3,5,10],
                  "min_child_weight" : [1.0,2.5,5.0],
                  "n_estimators": [10,25,50,100,200],
                  "learning_rate": [0.1,0.3,0.5],
                  "seed": [RAND_STATE]}
    UMAP_grid_search = GridSearchCV(UMAP_model, param_grid=UMAP_param_dist,
                           cv = num_CV,
                           verbose=verbose, n_jobs=-1)
    UMAP_grid_search.fit(UMAP_X_train, UMAP_y_train)
    conf_mat = confusion_matrix(UMAP_y_test,UMAP_grid_search.predict(UMAP_X_test))
    return UMAP_grid_search, conf_mat
    
def plot_confusion_matrix(conf_mat,umap_df):
    n_clust = len(set(umap_df['cluster_id'].tolist()))

    confusion_mat_counts = conf_mat

    conf_mat_row_list = []

    for row in confusion_mat_counts:
        row_sum = np.sum(row)

        row_percent = []

        for val in row:
            row_percent.append(val/row_sum)

        conf_mat_row_list.append(row_percent)

    conf_mat = np.array(conf_mat_row_list)

    colormap = cm.YlGnBu
    colormap.set_under('white')

    eps = np.spacing(0.0)
    f, arr = plt.subplots(1,figsize=[4,3])
    mappable = arr.imshow(conf_mat,cmap=colormap,vmin=eps,vmax=1.)
    color_bar = f.colorbar(mappable, ax=arr, extend='min')
    color_bar.set_label('P (Predicted | True)',fontsize=12,labelpad=15,fontname="Arial")
    color_bar.ax.tick_params(size=3,labelsize=12)

    #Specify label behavior of the main diagonal
    for i in range(0,n_clust):
        if int(conf_mat[i,i]*100) == 100:
            arr.text(i-0.38,i+0.17,int(round(conf_mat[i,i]*100)),fontsize=10,c='white',fontname="Arial")
        else:
            arr.text(i-0.34,i+0.16,int(round(conf_mat[i,i]*100)),fontsize=10,c='white',fontname="Arial")

    #Specify label behavior of the off-diagonals
    for i in range(0,n_clust):
        for j in range(0,n_clust):
            if conf_mat[i,j] < 0.1 and conf_mat[i,j] != 0:
                arr.text(j-0.2,i+0.15,int(round(conf_mat[i,j]*100)),fontsize=10,c='k',fontname="Arial")
            elif conf_mat[i,j] >= 0.1 and conf_mat[i,j] < 0.5 and conf_mat[i,j] != 0:
                arr.text(j-0.4, i+0.15,int(round(conf_mat[i,j]*100)),fontsize=10,c='k',fontname="Arial")

    arr.set_xticks(range(0,n_clust))
    arr.set_xticklabels(range(1,n_clust+1),fontsize=12);
    arr.set_yticks(range(0,n_clust))
    arr.set_yticklabels(range(1,n_clust+1),fontsize=12);
    arr.set_xlabel('Predicted Class',fontsize=12);
    arr.set_ylabel('True Class',fontsize=12);
    plt.tight_layout()
    
    return None
    
#def plot_SHAP_values(UMAP_grid_search,umap_df):
#
#    return None

def plot_inverse_mapping(reducer,umap_df):
    def find_nearest_color(embedding, test_coord, umap_df, threshold_dist=0.8):
        x_array, y_array = embedding[:,0], embedding[:,1]
        
        # Take coordinates of test point to calculate an array of each point's distance to test then return index
        # where the minimum value is found
        dist_array = np.array(np.abs(x_array-test_coord[0])+np.abs(y_array-test_coord[1]))
        idx = dist_array.argmin()
        
        if dist_array[idx] <= threshold_dist:
            return umap_df['cluster_color'][idx]
        
        else:
            return (0.8,0.8,0.8)
    
    corners = np.array([
    [reducer.embedding_[:,0].min(), reducer.embedding_[:,1].max()],  # top-left
    [reducer.embedding_[:,0].max(), reducer.embedding_[:,1].max()],  # top-right
    [reducer.embedding_[:,0].min(), reducer.embedding_[:,1].min()],  # bottom-left
    [reducer.embedding_[:,0].max(), reducer.embedding_[:,1].min()],  # bottom-right
    ])
    
    test_pts = np.array([
    (corners[0]*(1-x) + corners[1]*x)*(1-y) +
    (corners[2]*(1-x) + corners[3]*x)*y
    for y in np.linspace(0, 1, 10)
    for x in np.linspace(0, 1, 10)])
    
    fig = plt.figure(figsize=(4.5,7))
    gs = GridSpec(20, 10, fig)
    gs.update(wspace=0.05, hspace=0.05)
    scatter_ax = fig.add_subplot(gs[:10, :10])
    waveform_axes = np.zeros((10, 10), dtype=object)
    inv_transformed_points = reducer.inverse_transform(test_pts)
    for i in range(10):
        for j in range(10):
            waveform_axes[i, j] = fig.add_subplot(gs[10+ i,j])

    scatter_ax.scatter(reducer.embedding_[:, 0], reducer.embedding_[:, 1],
                    c=umap_df['cluster_color'], s=30,linewidth=0.25,edgecolor='white',zorder=1)
    scatter_ax.scatter(test_pts[:, 0], test_pts[:, 1], marker='x',
                       c='k',
                       s=30, zorder=2, alpha=1)

    # Plot each of the generated waveforms
    for i in range(10):
        for j in range(10):
            waveform_axes[i, j].plot(inv_transformed_points[i*10 + j],
                                         c = find_nearest_color(reducer.embedding_,
                                                                test_pts[i*10 + j],umap_df),
                                    linewidth=1.0)

            waveform_axes[i, j].set(xticks=[], yticks=[])
            waveform_axes[i, j].spines['right'].set_visible(False)
            waveform_axes[i, j].spines['top'].set_visible(False)
            waveform_axes[i, j].spines['left'].set_visible(False)
            waveform_axes[i, j].spines['bottom'].set_visible(False)

    scatter_ax.set(xticks=[], yticks=[])
    scatter_ax.spines['right'].set_visible(False)
    scatter_ax.spines['top'].set_visible(False)
    scatter_ax.spines['left'].set_visible(False)
    scatter_ax.spines['bottom'].set_visible(False)
    
    return None

def plot_shap_summary(explainer,umap_df,colors):
    shap_values = explainer.shap_values(umap_df['waveform'].tolist())
    class_inds = np.argsort([-np.abs(shap_values[i]).mean() for i in range(len(shap_values))])
    shap_cmap = ListedColormap(np.array(colors)[class_inds])
    shap.summary_plot(shap_values,color=shap_cmap)

    return None
