library(corrplot)

pdf("~/Desktop/sumscoreplot.pdf")

data<-read.csv("~/Desktop/sumscore_corrplot.csv")
datacorr<-cor(data, use="pairwise.complete.obs")
sumscoreplot<-corrplot(datacorr, tl.cex = 0.3, tl.col = 'black')
dev.off()
