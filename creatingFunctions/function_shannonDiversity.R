##  This code calculates the Shannon-Wiener diversity index (H') for a dataframe with the first column labeled as "Treatment / plotID", and subsequent columns representing the abundance (in counts) of each species present in a given treatment. Column entries for a given species may be zero if that species was not found in a given plot / treatment.

##  Required function inputs are:
# inputFileName - name of the .csv containing the data to be analyzed. Must reside in active working directory.


shannon = function(inputFileName) {
	
  # Use the inputFileName value provided by the user to read the data into a dataframe, with the first column used to designate the row names
  data = read.csv(inputFileName, header=T, row.names=1)
  
  # Create a dataframe to hold the calculated Shannon diversity indices for each treatment/plot, and add plotIDs to it
  shannon = data.frame(matrix(data=NA, nrow=nrow(data), ncol=3))
  cnames = c("plotID","Hprime","Richness")
  colnames(shannon) = cnames
  shannon$plotID = rownames(data)
  
  
# Use a 'for' loop to calculate Hprime for each treatment / plot. 
for (i in 1:nrow(data)){
	
  # Create empty vectors for containing scaled proportional abundances for each species, and species presence/absence
  H = 0
  R = 0
  
  # Calculate total number of counts for all species within the treatment / plot
  Tot.obs = sum(data[i,])
  
  # Use a nested 'for' loop to calculate scaled proportional abundances for each species within a treatment / plot.
	for (j in 1:ncol(data)){
		if (data[i,j] > 0){
      H[j] = ((data[i,j])/Tot.obs)*log((data[i,j])/Tot.obs)
      R[j] = 1
		} else {
      H[j] = 0
      R[j] = 0
		}
		
	# End 'for' loop for columns within row
	}

	# Add sum of scaled proportional abundances to calculate Hprime, and store in 'shannon' dataframe created above.
  shannon$Hprime[i] = -sum(H)
  shannon$Richness[i] = sum(R)
	
# End 'for' loop for rows
}
	
	write.csv(shannon, "shannonOutput.csv", row.names=FALSE)

# End function
}