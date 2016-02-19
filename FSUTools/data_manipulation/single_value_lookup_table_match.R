### another vectorized example (from same link):
input = c(2,3,6)

lookup = data.frame(start = c(1, 5, 10), stops = c(4,9,15), gene = c("AA", "BB", "CC"))

sapply(input, function(v.element) lookup[v.element >= lookup["start"] & v.element <= lookup["stops"],"gene"])


