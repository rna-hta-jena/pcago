library("matrixStats")
library("ggplot2")
library("scatterplot3d")

# read in dummy read counts
read_file <- function(file) {
  if(is.null(file)) {
    return(NULL)
  } else {
    
    #TODO write different file handlers for TSV, CSV, ... with header, without first column, ... 
    
    counts.frame <- data.frame(read.table(file, header=TRUE, sep=","))
    counts.matrix <- data.matrix(counts.frame)
    return(counts.matrix)
  }
}

pca <- function(counts.matrix, dimensions, ntop, pc) {
  
  print(dimensions)
  print(length(counts.matrix[,1]))
  print(ntop)
  print(pc)

  ## Extracting transformed values, MAYBE just log2 transform and finish?
  # TODO: build a DESeqDataSet object out of the matrix
  #rld <- rlog(dds)

  Pvars <- rowVars(counts.matrix)

  select <- order(Pvars, decreasing = TRUE)[seq_len(min(ntop, length(Pvars)))]

  PCA <- prcomp(t(counts.matrix[select, ]), scale = F)
  percentVar <- round(100*PCA$sdev^2/sum(PCA$sdev^2),1)

  dataGG = data.frame(PC1 = PCA$x[,1], PC2 = PCA$x[,2], 
                    PC3 = PCA$x[,3], PC4 = PCA$x[,4])

  if(length(pc) == 2) {
    #simple PCA plot
    return(plot.2d(dataGG, PCA, pc, percentVar))
  } else {
    #3d pca
    return(plot.3d(dataGG, PCA, pc, percentVar))
  }
  
  
}



plot.3d <- function(dataGG, PCA, pc, percentVar) {
  name <- 'TEST'
  
  nr1 <- strtoi(pc[1])
  nr2 <- strtoi(pc[2])
  nr3 <- strtoi(pc[3])
  
  # define colors
  color1 <- "#ff8a00"
  color2 <- "#0bc800"
  color3 <- "#0000ff"
  color4 <- "#ff00ff"

  dataGG$color <- "#000000" 
  dataGG$color[grepl('_ctr',rownames(dataGG))]  <- color1
  dataGG$color[grepl('_atra',rownames(dataGG))]  <- color2

  with(dataGG, {
    s3d <- scatterplot3d(PCA$x[,nr1], PCA$x[,nr2], PCA$x[,nr3],
                         main = paste(name, ", top variant genes",sep=""),
                         color=color,
#                         bg=vitamincolor,
                         cex.symbols=1,
                         lwd=1.5,
                         ##pch=patientshape,
                         pch=21,
                         type="h", lty.hplot=2, scale.y=.75, grid=TRUE, box=FALSE,
                         xlab=paste0("PC",pc[1],": ",percentVar[nr1],"% variance"),
                         ylab=paste0("PC",pc[2],": ",percentVar[nr2],"% variance"),
                         zlab=paste0("PC",pc[3],": ",percentVar[nr3],"% variance"))
    s3d.coords <- s3d$xyz.convert(PCA$x[,nr1], PCA$x[,nr2], PCA$x[,nr3]) # convert 3D coords to 2D projection
    #legend("topleft",legend = c('ctr','can','asp','eco'), title = "infections",
    #       col =  c(infection.ctr.orange,infection.can.green,infection.asp.blue,infection.eco.purple),
    #       pch = 21, pt.cex=1, pt.lwd=1.5, cex=0.8,xpd = TRUE, horiz = TRUE)
    #legend("top", legend = c('ctr','atra','vitd'), title = "vitamins",
    #       col = "black", pt.bg = c(vitamin.ctr.white,vitamin.atra.grey,vitamin.vitd.black),
    #       pch = 21, pt.cex=1, pt.lwd=1.5, cex=0.8,xpd = TRUE, horiz = TRUE)
  })
  
}



plot.2d <- function(dataGG, PCA, pc, percentVar) {
  nr1 <- strtoi(pc[1])
  nr2 <- strtoi(pc[2])
  pca.plot <- ggplot(dataGG, aes(PCA$x[,nr1], PCA$x[,nr2])) +
    geom_point(size=3) +
    xlab(paste0("PC",pc[1],": ",percentVar[nr1],"% variance")) +
    ylab(paste0("PC",pc[2],": ",percentVar[nr2],"% variance"))
 return(pca.plot) 
}