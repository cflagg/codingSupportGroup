phe <- data.frame(taxonID = c("ABBA", "ABLA", "ACPA"), siteID = c("STEI", "TREE", "GRSM"))

masterTax <- data.frame(syName = c("ABBA", "ABRP", "ADRO", "ACPA", "ACRA"), 
                        acceptedName = c("ABBA", "ABBA", "ABBA", "ACPA", "ACPA"),
                        sciName = c("Abra", "Abro", "Abreu", "Accipas", "Akkra"))

phe

masterTax

# unique join to produce 1 scientific name
left_join(phe, masterTax, by = c("taxonID" = "syName"))

# many to one join to append all synonyms
left_join(phe, masterTax, by = c("taxonID" = "acceptedName"))
