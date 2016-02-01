# loop through two files simultaneously
# http://stackoverflow.com/questions/7771547/with-r-loop-over-two-files-at-a-time?rq=1
files <- list(
  c("fileA","fileB"),
  c("fileC","fileD")
)

for(f in files) {
  cat("~~~~~~~~\n")
  cat("f[1] is",f[1],"~ f[2] is",f[2],"\n")
}