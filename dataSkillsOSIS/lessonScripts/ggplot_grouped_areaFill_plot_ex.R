df= data.frame(Time=as.numeric(strsplit('1939 1949 1959 1969 1979 1989 1999 2009 2019 2029 2039 2049 1939 1949 1959 1969 1979 1989 1999 2009 2019 2029 2039 2049', split=' ')[[1]] ),
               Acres=as.numeric(strsplit('139504.2 233529.0 392105.3 502983.9 685159.9 835594.7 882945.1 1212671.4 1475211.9 1717971.7 1862505.7 1934308.0 308261.4 502460.8 834303.1 1115150.7 1430797.8 1712085.8 1973366.1 1694907.7 1480506.0 1280047.6 1164200.5 1118045.3', split=' ')[[1]] ),
               WUClass= strsplit('DenseUrban DenseUrban DenseUrban DenseUrban DenseUrban DenseUrban DenseUrban DenseUrban DenseUrban DenseUrban DenseUrban DenseUrban Urban Urban Urban Urban Urban Urban Urban Urban Urban Urban Urban Urban', split=' ')[[1]]   
)

ggplot(df, aes(x = Time, y = Acres, group = WUClass, fill=WUClass)) + geom_area()

ggplot(df,aes(x = Time,y = Acres,fill=WUClass)) +
  geom_area( position = 'stack') +
  geom_area( position = 'stack', colour="black", show_guide=FALSE)

pheData2 %>% 
  filter() %>% 
ggplot(aes(x = dayOfYear, y = prop)) + 
  geom_area(aes(group = phenophaseStatus, fill = phenophaseStatus), position = "dodge", alpha=0.5)


