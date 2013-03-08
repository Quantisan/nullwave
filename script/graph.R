require(seewave)
require(tuneR)
require(audio)

a.all <- readWave("./data/ambience.wav")

f <- 44100
a <- cutw(a.all,f,from=1.08,to=1.55,plot=FALSE)
a.inv <- rmam(a,f)

layout(matrix(1:4,nc=2,byrow=TRUE),height=c(3,1))
par(mar=c(0,5,2,1))
spectro(a, f, palette=temp.colors, collevels=seq(-124,0,2), ovlp=75, scale=FALSE,  axisX=FALSE, main = "original", tlab = "", flab = "Frequency (kHz)")
par(mar=c(0,5,2,1))
spectro(a.inv, f, palette=temp.colors, collevels=seq(-60,0,2), ovlp=75, scale=FALSE, axisX=FALSE, main = "inverse", tlab = "", flab = "Frequency (kHz)")
par(mar=c(5,5,0,1))
oscillo(a, f, bty="o")
par(mar=c(5,5,0,1))
oscillo(a.inv, f, bty="o")