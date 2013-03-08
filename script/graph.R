# load files
PW<-read.table("http://rug.mnhn.fr/seewave/ASCII/C20W_109.txt", skip=1)
NW<-read.table("http://rug.mnhn.fr/seewave/ASCII/C6WH_58.txt", skip=1)
H<-read.table("http://rug.mnhn.fr/seewave/ASCII/C6H_110.txt", skip=1)
# layout
layout(matrix(c(rep(1,3),0,2:8,0), nr = 3, byrow=TRUE), widths=c(4,4,4,1), heights=c(2,3,1))
par(mar=c(6,2,1,0), oma=c(3,3,0,3))
# spectrum
f <- 44100
wl <- 256
ovlp <- 75
zp <- 64
collevels <- seq(-30,0,0.5)
palette <- rev.terrain.colors
spec(PW, f=f, at=0.2, wl=512, alim=c(0,1.1), font.lab=2, type="l", flab="", alab="")
text(c(2.1,4.1,6.1,8.2,10.5,12.3,14.4,16.5,18.5,20.5), c(0.1,0.13,0.5,0.16,0.26,0.43,0.32,0.43,0.05,0.06), paste(1:10,"f0",sep=""))
text(c(3.3,6.6,9.9,13.1,16.5,19.7), c(0.06,0.95,0.44,1.05,0.5,0.1), paste(1:6,"g0",sep=""), font=2);
mtext("Frequency (kHz)", side=1, font=2, line=3.5, at=11.25,las=0)
# First spectrogram
par(mar=c(0,2,3,0))
spectro(PW, f=f, wl=wl, ovlp=ovlp, zp=zp,  collevels=collevels, osc=F, scale=F, axisX=F, palette=palette,
        tlab = "", flab = "", alab = "")
abline(v=0.20, lty=2)
mtext("PW",side=3,line=1,at=0.21)
# Second spectrogram
spectro(NW, f=f , wl=wl, ovlp=ovlp, zp=zp, collevels=collevels, osc=F, scale=F, axisX=F, axisY=F, palette=palette,
        tlab = "", flab = "", alab = "")
mtext("NW", side=3, line=1, at=0.29)
# Third spectrogram
spectro(H, f=f ,wl=wl, ovlp=ovlp, zp=zp, collevels=collevels, osc=F, scale=F,  axisX=F, axisY=F, palette=palette,
        tlab = "", flab = "", alab = "")
mtext("H", side=3, line=1, at=0.29)
# dB colour scale
dBscale(collevels=collevels, palette=palette)
par(mar=c(2,2,0,0))
# oscillograms
oscillo(PW, f=f, labels=FALSE, bty="o")
oscillo(NW, f=f, labels=FALSE, bty="o")
oscillo(H, f=f, labels=FALSE, bty="o")
# labels
mtext("Time (s)", side=1, font=2, line=1.5, outer=T)
mtext("Frequency (kHz)", side=2, font=2, line=1.25, at=0.35, outer=T,las=0)
mtext("Amplitude", side=2, font=2, line=1.25, at=0.85, outer=T,las=0)
mtext("Amplitude", side=2, font=2, line=1.25, at=0.09, outer=T,las=0)
mtext("(a)",side=2,font=3,line=0.5, at=0.98, outer= TRUE, las=1, cex=1.6)
mtext("(b)",side=2,font=3,line=0.5, at=0.66, outer= TRUE, las=1, cex=1.6)