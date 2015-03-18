## This code calculates the Shannon-Wiener diversity index (H') for a dataframe with the first column labeled as "Treatment/Plot ID", and subsequent columns representing the abundance (in counts) of each species present in a given treatment.  
## Column entries for a given species may be zero if that species was not found in a given plot/treatment.
## To obtain a dataframe suitable for the "shannon" function below, use the following syntax:
## example.data = read.csv("Shannon_Wiener_example.csv", header=T, row.names="Treatment")
## "output" needs to be a csv file, entered in quotations: e.g. "test_output.csv"

shannon = function(data, output) {
	S = ncol(data) ## Total number of plant species observed across all plots/treatments
	R = nrow(data) ## Total number of treatments or plots for which species data were collected
	Treatment = row.names(data)
	H = 0 ## Prepare empty vector for containing single H' calculated for a given treatment
	Hprime = 0 ## Prepare empty vector for containing all H' calculated for all i rows of data

for (i in 1:R){
	Tot.obs = sum(data[i,])

	for (j in 1:S){
		if (data[i,j] > 0) H[j] = ((data[i,j])/Tot.obs)*log((data[i,j])/Tot.obs)
		else H[j] = 0
		}

	Hprime[i] = -sum(H)
	}
	
	shan = cbind(Treatment, Hprime)
	write.csv(shan, output)
}