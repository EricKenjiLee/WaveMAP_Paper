# WaveMAP Paper Figure Replication

*WARNING*: If you are reviewing this paper as a manuscript __DO NOT__ star or fork the repo containing this file as it is deanonymizing. You are welcome to clone the repo as written in the .ipynb as this is anonymized. 

---

To fully replicate and explore the figures used in Lee **et al.** (2021), MATLAB (2020a) and Python (3.7+) with Jupyter or access to Google Colab are required. The colors and format of many figures will appear differently because they were edited after generation in Adobe Illustrator. Running the notebook outside of Colab is not guaranteed to produce the same figures as this has not been tested on other OS's.

Figure 1: To generate the psychometric curves in the first figure of the manuscript, open the Figure_1.mlx file in MATLAB and add the file folder including subfolders to path and then you can generate the psychometric curves. 

Figures 3 to 9 and all supp. figures except 9:

To generate the rest of the figures (not including diagrams in Figure 2) there are two options:

Option 1: This is the easiest. Load the Waveform_Figures_Data.ipynb file into Google Colab. This can be easily done using a google account. You are then all set to use the cells. Obviously you can choose to either manually load all the files into the runtime or alternatively just use the git clone command which will clone it into the correct path. We have found the git clone aspect to be far easier and less painful than slowly adding files in google colab.

Option 2: If you decide you would rather run this in your local computer, create a clean environment folder with only Jupyter installed and place the .ipynb in it. Launch the notebook in Jupyter notebook and run the first few cells. From here, the user has the option of generating the folders stand-alone or launching in Google Colab. This notebook was written with Colab in mind but if one wishes to run it locally, the `pip install` commands should be changed to `pip3 install` on some OS's so that Python 2.7 versions of packages are not installed. Note that using pip will need to be done within an environment. This was tested using pipenv by changing the commands to `pipenv install` for packages not already installed. It will be necessary to add the pipenv kernel to Jupyter using the [ipykernel program](https://stackoverflow.com/questions/47295871/is-there-a-way-to-use-pipenv-with-jupyter-notebook).

---

Lee, E. K. et al. Non-linear Dimensionality Reduction on Extracellular Waveforms Reveals Physiological, Functional, and Laminar Diversity in Premotor Cortex. bioRxiv (2021) doi:10.1101/2021.02.07.430135.
  
Copyright 2021 Eric Kenji Lee

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

