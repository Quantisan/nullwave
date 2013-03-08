# library(seewave)
# library(tuneR)
# library(rgl)

library(audio)

a <- load.wave("../data/ambience.wav")

write(a, file="../data/as_timeseries.rdata")
# library(audio)

