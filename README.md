# PCA in spectroscopy
### Visualization tool for spectroscopy.

check https://jorobledo.github.io/PCA-in-spectroscopy/

This code is written in R.

It is an example of the visualization presented in the work Robledo and Cuestas (2020) [1].

Auxiliary files are included to be able to run the  program.
Different parameters may be chosen at the beginning of the code to explore how it works.

To run your own data, clone this repository and change the input data from *input_files* folder
to your own data, keeping the file formats. An example of a manganese dataset is presented.

The *output_files* folder contains four files.

- *PCA_RRS.dat*: contains all principal component loadings in columns from the PCA applied to the given data.

- *contribution_firstnPC_RRS.dat*: contains the contribution of each of the first  n  principal components selected to the resulting spectrum.

- *energy_means.dat*: contains the mean value of each energy channel (averaging over all spectra in the dataset).

- *spectra_RRS.dat*: contains the spectra resulting from the contribution of the first  n  components chosen.

For any question, please refer to jose.robledo@cab.cnea.gov.ar

### References
[1] Robledo, J. I., & Cuestas, E. (2020).
   "Selecting and visualizing the spectra variability relevant for sample
    classification using Principal Component Analysis. Journal
     of Analytical Atomic Spectrometry",
     [https://doi.org/10.1039/D0JA00148A](https://pubs.rsc.org/en/content/articlelanding/2020/ja/d0ja00148a/unauth#!divAbstract")
