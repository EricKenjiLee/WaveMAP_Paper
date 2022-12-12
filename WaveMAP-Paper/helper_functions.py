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
