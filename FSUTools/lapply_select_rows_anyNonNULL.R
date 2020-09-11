ingFid_map <- data.frame('ingest' = c('a','b','c','d'), 'repKey' = c(NA,NA,NA,NA), 'loadDelay' = c(NA,NA,'test',NA),'namedLocName' = c(NA,NA,NA,NA))


# Final function
ingFid_map$ingest[unlist(lapply(1:nrow(ingFid_map),
                                function(x){all(is.na(unique(c(ingFid_map$repKey[x],ingFid_map$loadDelay[x],ingFid_map$namedLocationName[x]))))}))]

# Why unlist? Without it, R returns ugly list
lapply(1:nrow(ingFid_map),function(x){all(is.na(unique(c(ingFid_map$repKey[x],ingFid_map$loadDelay[x],ingFid_map$namedLocationName[x]))))})

# Final function broken down into for loop
for (x in 1:nrow(ingFid_map)){
  if (all(is.na(unique(c(ingFid_map$repKey[x],ingFid_map$loadDelay[x],ingFid_map$namedLocationName[x]))))){
    print(ingFid_map$ingest[x])
  }
}
