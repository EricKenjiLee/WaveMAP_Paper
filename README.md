# WaveMAP Paper Figure Replication

*WARNING*: If you are reviewing this paper as a manuscript __DO NOT__ star or fork the repo containing this file as it is deanonymizing. You are welcome to clone the repo as written in the .ipynb as this is anonymized. 

[![PyPI version](https://badge.fury.io/py/wavemap_paper.svg)](https://badge.fury.io/py/wavemap_paper)

Hosted at [![DOI](https://zenodo.org/badge/342459533.svg)](https://zenodo.org/badge/latestdoi/342459533)

---

To fully replicate and explore the figures used in Lee **et al.** (2021), MATLAB (2020a) and Python (3.7+) with Jupyter or access to Google Colab are required. The colors and format of many figures will appear differently because they were edited after generation in Adobe Illustrator. Running the notebook outside of Colab is not guaranteed to produce the same figures as this has not been tested on other OS's.

Figure 1: To generate the psychometric curves in the first figure of the manuscript, open the Figure_1.mlx file in MATLAB and add the file folder including subfolders to path and then you can generate the psychometric curves. 

Figures 3 to 9 and all supp. figures except 9:

To generate the rest of the figures (not including diagrams in Figure 2) there are two options:

Option 1: This is the easiest. Load the Waveform_Figures_Data.ipynb file into Google Colab. This can be easily done using a google account. You are then all set to use the cells. Obviously you can choose to either manually load all the files into the runtime or alternatively just use the git clone command which will clone it into the correct path. We have found the git clone aspect to be far easier and less painful than slowly adding files in Google Colab.

Option 2: If you decide you would rather run this in your local computer, create and activate an environment folder, clone this repo into it, and install all packages imported in the .ipynb plus the specific versions of other packages shown by `!pip install [package]` in the notebook. Launch the notebook in Jupyter notebook/JupyterLab and run the first few cells with the now redundant cloning and installation cells commented out. Note it will be necessary to add the environment kernel to Jupyter using the [ipykernel program](https://stackoverflow.com/questions/47295871/is-there-a-way-to-use-pipenv-with-jupyter-notebook).

---

Lee, E. K. et al. Non-linear Dimensionality Reduction on Extracellular Waveforms Reveals Physiological, Functional, and Laminar Diversity in Premotor Cortex. bioRxiv (2021) doi:10.1101/2021.02.07.430135.

---
  
MIT License

Copyright (c) 2021 Eric Kenji Lee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
