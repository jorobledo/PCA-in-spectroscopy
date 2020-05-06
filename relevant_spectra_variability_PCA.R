##################################################################
#
# Selecting and visualizing the spectra variability relevant for
# sample classification using Principal Component Analysis
#
##################################################################

##################################################################
# Code written by J. I. Robledo and Eloisa Cuestas
# Published in --
# Please cite as
# doi: --
##################################################################

##################################################################

##################################################################

# This library is needed in order to perform the analysis
# library dependencies

library(stats)

##################################################################
# The code uses the following variables:

# dataset: a .txt file with the dataset to be used
#          the data must be arranged in columns with spaces or tabs as separators

# Energy: a .txt file with the names of the calibrated energy channels.

# CPx: number of the PC that is plotted on the X axis.

# CPy: number of the PC that is plotted on the Y axis.

# spectrum_number: number of spectrum to observe.

# amount_PCs: amount of PC's to sum up over.

# which_contribution_PC_min/max: which individual contribution are plotted, from min to max
# when min and max are equal a single contribution os plotted


dataset <- as.matrix(read.table("input_files/Mn_Data.txt", header = F, sep = "\t"))

energy <- as.matrix(read.table("input_files/Mn_energy_channels.txt", header = F, sep = "\t"))

# Transpose the data
X <- t(dataset)

# Define p and n and print them as to verify
p <- dim(X)[2]
n <- dim(X)[1]

CPx <-  1

CPy <-  2

spectrum_number <- 1 # number from 1 to n (total number of datasets, spectrum)

amount_PCs <-  5 # numer from 1 to p (total number of variables, channels), referred to as k in paper.

which_contribution_PC_min <-  1

which_contribution_PC_max <-  1

##################################################################



# Perform the PCA analysis, see https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/prcomp

X_pca <- prcomp(X, center = TRUE, scale = TRUE)

autovals_RRS <- as.data.frame(X_pca[1])

# Amount of the total variance explained by CP1
autovals_RRS[[1]][1]*100/sum(autovals_RRS)

# PCs as a matrix (each column is a PC, ordered from 1 to p)
PCS <- X_pca[[2]]

# Calculate the means for each column (original rows)
means <- apply(X, 2, mean)

# Plot means using energy as x-axis
plot(energy[,1], means, ylab = 'means' , xlab = 'energy')

# Write energy and means as an output
write.table(t(rbind(energy[,1], means)), file = 'output_files/energy_means.dat')

# Calculate the standard deviation for each column (original rows)
sd <- apply(X, 2, sd)

# Standardization of the dataset
Xstd <- X

for (i in 1:n){
               Xstd[i,] <- X[i,] - means
              }

Xstd <- Xstd/sd

# Perform the projection of the data onto PCs (calculating the PCs of the data)
proj_PCS <- Xstd%*%PCS

# Plottimg the PCx - PCy plane
z <- rep(c(1:4), rep(50,4))

df <- data.frame(proj_PCS[,CPx], proj_PCS[,CPy], z)

plot(proj_PCS[,CPx], proj_PCS[,CPy], sub = 'Results from the PCA',
     xlab = "PC1", ylab = "PC2", col = c(1,2,3,4,5,6,7,8,9,10,11,12,13)[z])

# Exporting PCplot and verifying dimensions
dim(proj_PCS)

z1 <- as.matrix(z)

dim(z1)

write.table(cbind(as.matrix(z),proj_PCS), file = 'output_files/PCA_RRS.dat', row.names = FALSE )

##################################################################

# Reconstruction of the data and verifying dimensions
mydata <- list()

for (i in 1:p){
               mydata[[i]] <- (proj_PCS[,i]%*%t(PCS[,i])*sd)
              }

dim(mydata[[1]])

##################################################################

# Retrieving the relevant variability as to reconstruct the data (filtering)
n1=dim(mydata[[1]])[1]
n2=dim(mydata[[1]])[2]

for (i in 1:amount_PCs){
                        if (i==1){sum <- matrix(0L, nrow = n1, ncol = n2)}
                        sum <- sum + mydata[[i]]
                      }

for (i in 1:n){
               sum[i,] <- sum[i,] + means
              }

# Exporting the data of the previous plot
write.table(t(rbind(energy[,1],sum)), file = 'output_files/contribution_firstnPC_RRS.dat', col.names = FALSE, row.names = FALSE )
write.table(t(rbind(energy[,1],X)), file = 'output_files/spectra_RRS.dat', col.names = FALSE, row.names = FALSE)

# Plotting the obtained single contributions
for (j in which_contribution_PC_min:which_contribution_PC_max){
  if (j == which_contribution_PC_min){plot(energy[,1], X[spectrum_number,], col = 1, type = "o",
                        main = 'Individual contribution of the selected PC', ylab = 'Intensity (a.u.)', xlab = 'Energy (eV)',
                        sub = 'Comparision is made with respect to the original spectrum')
                        lines(energy[,1],sum[spectrum_number,],col='blue')
                        legend("topleft",c("Data","Chosen PC","Sum of first k"),fill=c("black",'red','blue'))}
  cont_indiv <- mydata[[j]]
  for (i in 1:n){
    cont_indiv[i,] <- cont_indiv[i,] + means
  }
  lines(energy, cont_indiv[spectrum_number,], col = j+1, type = "l")
}

##################################################################
