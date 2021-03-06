library(gdata)
library(topGO)
library(VennDiagram)
library(ggplot2)

genes <- read.table("SRR1575102.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR1575102.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR1575102HIGH.csv", row.names=FALSE)

genes <- read.table("SRR1575103.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR1575103.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR1575103HIGH.csv", row.names=FALSE)

genes <- read.table("SRR1575104.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR1575104.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR1575104HIGH.csv", row.names=FALSE)

genes <- read.table("SRR1575105.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR1575105.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR1575105HIGH.csv", row.names=FALSE)
data1 <- read.csv("SRR1575102HIGH.csv")
data2 <- read.csv("SRR1575103HIGH.csv")
data3 <- read.csv("SRR1575104HIGH.csv")
data4 <- read.csv("SRR1575105HIGH.csv")
final1 <- rbind(data1, data2)
final2 <- rbind(final1, data3)
final3 <- rbind(final2, data4)
final4 <- aggregate(final3[, 2], list(final3$gene_name), sum)
colnames(final4)[1] <- "gene_name"
final4$x <- NULL
write.csv(final4, "NormalHIGH.csv", row.names=FALSE)

genes <- read.table("SRR3895734.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR3895734.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR3895734HIGH.csv", row.names=FALSE)

genes <- read.table("SRR3895735.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR3895735.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR3895735HIGH.csv", row.names=FALSE)

genes <- read.table("SRR3895736.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR3895736.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR3895736HIGH.csv", row.names=FALSE)

genes <- read.table("SRR3895737.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR3895737.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR3895737HIGH.csv", row.names=FALSE)

genes <- read.table("SRR3895738.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR3895738.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR3895738HIGH.csv", row.names=FALSE)

genes <- read.table("SRR3895739.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR3895739.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR3895739HIGH.csv", row.names=FALSE)

genes <- read.table("SRR3895741.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR3895741.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR3895741HIGH.csv", row.names=FALSE)

genes <- read.table("SRR3895742.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR3895742.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR3895742HIGH.csv", row.names=FALSE)

genes <- read.table("SRR3895743.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR3895743.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR3895743HIGH.csv", row.names=FALSE)

genes <- read.table("SRR3895744.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR3895744.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR3895744HIGH.csv", row.names=FALSE)

genes <- read.table("SRR3895746.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR3895746.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR3895746HIGH.csv", row.names=FALSE)

genes <- read.table("SRR3895748.genes.txt")
colnames <- read.csv("VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "SRR3895748.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "SRR3895748HIGH.csv", row.names=FALSE)

data1 <- read.csv("SRR3895734HIGH.csv")
data2 <- read.csv("SRR3895735HIGH.csv")
data3 <- read.csv("SRR3895736HIGH.csv")
data4 <- read.csv("SRR3895737HIGH.csv")
data5 <- read.csv("SRR3895738HIGH.csv")
data6 <- read.csv("SRR3895739HIGH.csv")
data7 <- read.csv("SRR3895741HIGH.csv")
data8 <- read.csv("SRR3895742HIGH.csv")
data9 <- read.csv("SRR3895743HIGH.csv")
data10 <- read.csv("SRR3895744HIGH.csv")
data11 <- read.csv("SRR3895746HIGH.csv")
data12 <- read.csv("SRR3895748HIGH.csv")
final1 <- rbind(data1, data2)
final2 <- rbind(final1, data3)
final3 <- rbind(final2, data4)
final4 <- rbind(final3, data5)
final5 <- rbind(final4, data6)
final6 <- rbind(final5, data7)
final7 <- rbind(final6, data8)
final8 <- rbind(final7, data9)
final9 <- rbind(final8, data10)
final10 <- rbind(final9, data11)
final11 <- rbind(final10, data12)
final12 <- aggregate(final12[, 2], list(final12$gene_name), sum)
colnames(final12)[1] <- "gene_name"
final12$x <- NULL
write.csv(final12, "AMLHIGH.csv", row.names=FALSE)

##try to combine Normal and AML in same table.
Normal <- read.csv("NormalHIGH.csv")
colnames(Normal)[1] <- "Normal_HIGH"
AML <- read.csv("AMLHIGH.csv")
colnames(AML)[1] <- "AML_HIGH"
head(Normal)
head(AML)
final <- cbind(Normal, AML)

##creates shared gene list file between HIGH AML and Normal
Normal <- read.csv("NormalHIGH.csv")
colnames(Normal)[1] <- "shared"
nrow(Normal)
AML <- read.csv("AMLHIGH.csv")
colnames(AML)[1] <- "shared"
nrow(AML)
head(Normal)
head(AML)
final <- merge(Normal, AML, by="shared")
nrow(final)
write.csv(final, "sharedHIGH.csv", row.names=FALSE)

##This creates unique AMLHIGH
shared <- read.csv("sharedHIGH.csv")
AML <- read.csv("AMLHIGH.csv")
colnames(AML)[1] <- "shared"
head(Normal)
head(AML)
final <- rbind(shared, AML)
final["number"] <- "1"
write.csv(final, "final.csv", row.names=FALSE)
final <- read.csv("final.csv")
final <- aggregate(final[, 2], list(final$shared), sum)
nrow(final)
final[final == 2] <- NA
final2 <- na.omit(final)
nrow(final2)
write.csv(final2, "AMLHIGHunique.csv", row.names=FALSE)

##This creates unique NormalHIGH
shared <- read.csv("sharedHIGH.csv")
AML <- read.csv("NormalHIGH.csv")
colnames(AML)[1] <- "shared"
head(Normal)
head(AML)
final <- rbind(shared, AML)
final["number"] <- "1"
write.csv(final, "final.csv", row.names=FALSE)
final <- read.csv("final.csv")
final <- aggregate(final[, 2], list(final$shared), sum)
nrow(final)
final[final == 2] <- NA
final2 <- na.omit(final)
nrow(final2)
write.csv(final2, "NormalHIGHunique.csv", row.names=FALSE)

##create venn diagram comparing HIGH Normal to HIGH AML
geneLists <- read.csv("HIGH.csv")
head(geneLists)
tail(geneLists)
geneLS <- lapply(as.list(geneLists), function(x) x[x != ""])
lapply(geneLS, tail)
names(geneLS) <- c("ConditionA", "ConditionB")
require("VennDiagram")
VENN.LIST <- geneLS
jpeg("HIGH.jpeg")
venn.plot <- venn.diagram(VENN.LIST, NULL, category.names=c("Normal", "AML"), fill=c("lightgreen", "yellow"), alpha=c(0.5,0.5), cex = 2, cat.fontface=4, main="High impact RNAediting sites in Normal verse AML")
grid.draw(venn.plot)
dev.off()
require("gplots")
a <- venn(VENN.LIST, show.plot=TRUE)
str(a)
inters <- attr(a,"intersections")
lapply(inters, head)


geneID2GO <- readMappings(file = "annotations2.csv", sep = ",")
geneUniverse <- names(geneID2GO)
genesOfInterest <- read.table("NormalHIGHunique.csv", header=FALSE)
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
resultKS.elim <- runTest(myGOdata, algorithm = "elim", satistic = "ks")
allRes <- GenTable(myGOdata,classicFisher=resultFisher,orderBy="resultFisher",ranksOf="classicFisher",topNodes=10)
write.csv(allRes, "upregtopGO.csv", row.names=FALSE)
showSigOfNodes(myGOdata,score(resultFisher),firstSigNodes=10,useInfo='all')
printGraph(myGOdata,resultFisher,firstSigNodes=5,fn.prefix="VCNormal",useInfo="all",pdfSW=TRUE)
dev.off()
length(usedGO(myGOdata))

geneID2GO <- readMappings(file = "annotations2.csv", sep = ",")
geneUniverse <- names(geneID2GO)
genesOfInterest <- read.table("AMLHIGHunique.csv", header=FALSE)
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
resultKS.elim <- runTest(myGOdata, algorithm = "elim", satistic = "ks")
allRes <- GenTable(myGOdata,classicFisher=resultFisher,orderBy="resultFisher",ranksOf="classicFisher",topNodes=10)
write.csv(allRes, "upregtopGO.csv", row.names=FALSE)
showSigOfNodes(myGOdata,score(resultFisher),firstSigNodes=10,useInfo='all')
printGraph(myGOdata,resultFisher,firstSigNodes=5,fn.prefix="VCAML",useInfo="all",pdfSW=TRUE)
dev.off()
length(usedGO(myGOdata))


