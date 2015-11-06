

chicken = rpois(10, 5)

area = list()
for (i in 1:length(chicken)){
  area[i] = chicken[i]^2 * pi
}


area = vector()
for (i in 1:length(chicken)){
  area = c(area, pi*chicken[i]^2)
}


x1 = seq(1,10,1)
y1 = seq(5,10,1)

x1 %in% y1

# While loops
num = 1:10
i = 1
med = median(num)
while (i < med){
  num[i] = num[i] + 5
  print(paste0("num",num[i]))
  i = i + 1 
  print(paste0("i",i))
}




