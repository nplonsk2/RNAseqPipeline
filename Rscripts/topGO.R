##These next steps were the ones used to generate the index file that is stored in the Pipelines folder included in the vm
##wget http://geneontology.org/gene-associations/goa_human.gaf.gz
##unzip /home/user/Downloads/goa_human.gaf.gz
##library(plyr)
##X2 <- ddply(data, .(gene_name), summarize, Xc=paste(GOTerms,collapse=","))
##GO <- read.csv("annotations2.csv")
library("topGO")
library("grid")
library("Rgraphviz")
upreg <- read.csv("Upreg.csv")
upreg2 <- upreg$baseMean <- NULL
upreg2 <- upreg$lfcSE <- NULL
upreg2 <- upreg$stat <- NULL
upreg2 <- upreg$pvalue <- NULL
upreg2 <- upreg$padj <- NULL
upreg2 <- upreg[!(upreg$log2FoldChange < 1),]
upreg3 <- upreg2$log2FoldChange <- NULL
upreg3 <- colnames(upreg2)[1] <- "gene_name"
write.table(upreg2, "upreggenes.txt", sep="\t", row.names=FALSE)
geneID2GO <- readMappings(file = "annotations2.csv", sep = ",")
geneUniverse <- names(geneID2GO)
genesOfInterest <- read.table("upreggenes.txt", header=FALSE)
genesOfInterest <- as.character(genesOfInterest$V1)
geneList <- factor(as.integer(geneUniverse %in% genesOfInterest))
names(geneList) <- geneUniverse
geneUniverse <- gsub("\\\"", "", geneUniverse)
myGOdata <- new("topGOdata", description="My AML project", ontology="BP", allGenes=geneList, annot = annFUN.gene2GO, gene2GO = geneID2GO)
myGOdata
sg <- sigGenes(myGOdata)
str(sg)
numSigGenes(myGOdata)
resultFisher <- runTest(myGOdata, algorithm="classic",statistic="fisher")
resultKS <- runTest(myGOdata, algorithm = "classic", statistic = "ks")
resultFisher2 <- runTest(myGOdata, algorithm = "weight01", statistic="fisher")
allRes <- GenTable(myGOdata,classicFisher=resultFisher,orderBy=resultFisher,ranksOf="classicFisher",topNodes=10)
write.csv(allRes, "upregtopGO.csv", row.names=FALSE)
showSigOfNodes(myGOdata, score(resultFisher),firstSigNodes=10,useInfo='all')
printGraph(myGOdata, resultFisher, firstSigNodes=10,fn.prefix="tGO",useInfo="all",pdfSW=TRUE)
dev.off()
length(usedGO(myGOdata))
downreg <- read.csv("Downreg.csv")
downreg2 <- downreg$baseMean <- NULL
downreg2 <- downreg$lfcSE <- NULL
downreg2 <- downreg$stat <- NULL
downreg2 <- downreg$pvalue <- NULL
downreg2 <- downreg$padj <- NULL
downreg2 <- downreg[!(downreg$log2FoldChange < 1),]
downreg3 <- downreg2$log2FoldChange <- NULL
downreg3 <- colnames(downreg2)[1] <- "gene_name"
write.table(downreg2, "downreggenes.txt", sep="\t", row.names=FALSE)
geneID2GO <- readMappings(file = "annotations2.csv", sep = ",")
geneUniverse <- names(geneID2GO)
genesOfInterest <- read.table("downreggenes.txt", header=FALSE)
genesOfInterest <- as.character(genesOfInterest$V1)
geneList <- factor(as.integer(geneUniverse %in% genesOfInterest))
names(geneList) <- geneUniverse
geneUniverse <- gsub("\\\"", "", geneUniverse)
myGOdata <- new("topGOdata", description="My AML project", ontology="BP", allGenes=geneList, annot = annFUN.gene2GO, gene2GO = geneID2GO)
myGOdata
sg <- sigGenes(myGOdata)
str(sg)
numSigGenes(myGOdata)
resultFisher <- runTest(myGOdata, algorithm="classic",statistic="fisher")
resultKS <- runTest(myGOdata, algorithm = "classic", statistic = "ks")
resultFisher2 <- runTest(myGOdata, algorithm = "weight01", statistic="fisher")
allRes <- GenTable(myGOdata,classicFisher=resultFisher,orderBy="resultFisher",ranksOf="classicFisher",topNodes=10)
write.csv(allRes, "downregtopGO.csv", row.names=FALSE)
showSigOfNodes(myGOdata, score(resultFisher),firstSigNodes=10,useInfo='all')
printGraph(myGOdata, resultFisher, firstSigNodes=10,fn.prefix="tGOdown",useInfo="all",pdfSW=TRUE)
dev.off()
sessionInfo()


