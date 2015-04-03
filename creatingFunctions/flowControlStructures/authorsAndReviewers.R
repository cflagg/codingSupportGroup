##  For a given author, randomly assign two reviewers from a pool of reviewers that may include the author

# Define the list of authors
authors = c("Springer","Hoekman","Hinckley","Elmendorf")

# Define the list of reviewers
reviewers = c("Springer","Hinckley","Stanish","Meier","LeVan","Thibault","Elmendorf","Jones")

# Use a 'for' loop to randomly assign two reviewers from the 'reviewers' list to each element of 'authors'
for (i in 1:length(authors)){
  x = NA
  repeat {
    x = sample(reviewers, 2, replace=FALSE);
    if (!authors[i] %in% x) 
    break;
  }
  
  # Display output on the screen: author first, then two selected reviewers
  print(paste(authors[i], x, sep=","))
  
  # Update the list of reviewers so that reviewers do not get assigned to multiple authors
  reviewers = reviewers[!reviewers %in% x]
}
