##these load all the programs used
library("DESeq2")
library("vsn")
library("dplyr")
library("ggplot2")
library("pheatmap")
library("RColorBrewer")
library("PoiClaClu")
library("ggbeeswarm")
library("genefilter")
library("sva")

table1 <- read.csv("transcript_count_matrix.csv")
colnames(table1)[1] <- "t_id"
table2 <- read.csv("t_names.csv")
Data <- read.csv("PHENO_DATAZika.csv", row.names=1)
table3 <- merge(table2, table1, by="t_id")
table4 <- table3$t_id <- NULL
table5 <- colnames(table3)[c(2:19)] <- rownames(Data)[c(1:18)]
write.csv(table3, "transcript_count_matrixedited.csv", row.names=FALSE)
countData <- as.matrix(read.csv("transcript_count_matrixedited.csv", row.names="t_name"))
colData <- read.csv("PHENO_DATAZika.csv", row.names=1)
print("Do the row and columns names match in your files?")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("After renaming do the row and columns names still match?")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition)
print("Number of rows in new Matrix")
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
print("Number of rows in new Matrix that are greater then 1 count")
nrow(dds)
tiff("rlogandvariance_trans.tiff")
lambda <- 10^seq(from = -1, to = 2, length = 1000)
cts <- matrix(rpois(1000*100, lambda), ncol = 100)
meanSdPlot(cts, ranks = FALSE)
dev.off()
tiff("logtranscounts_trans.tiff")
log.cts.one <- log2(cts + 1)
meanSdPlot(log.cts.one, ranks = FALSE)
dev.off()
print("Taking rlog of new matrix counts")
rld <- rlog(dds, blind = FALSE)
print("top three rows in new rlog matrix")
head(assay(rld), 3)
vsd <- vst(dds, blind = FALSE)
print("top three rows in new vst rlog matrix")
head(assay(vsd), 3)
dds <- estimateSizeFactors(dds)
df <- bind_rows(as_data_frame(log2(counts(dds, normalized=TRUE)[, 1:2]+1)) %>% mutate(transformation = "log2(x + 1)"), as_data_frame(assay(rld)[, 1:2]) %>% mutate(transformation = "rlog"), as_data_frame(assay(vsd)[, 1:2]) %>% mutate(transformation = "vst"))
colnames(df)[1:2] <- c("x", "y")
tiff("transcounts2sam_trans.tiff")
ggplot(df, aes(x = x, y = y)) + geom_hex(bins = 80) + coord_fixed() + facet_grid( . ~ transformation)
dev.off()
sampleDists <- dist(t(assay(rld)))
sampleDists
sampleDistMatrix <- as.matrix( sampleDists )
rownames(sampleDistMatrix) <- paste( rld$condition)
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
poisd <- PoissonDistance(t(counts(dds)))
samplePoisDistMatrix <- as.matrix( poisd$dd )
rownames(samplePoisDistMatrix) <- paste( rld$condition)
colnames(samplePoisDistMatrix) <- NULL
tiff("PoisHeatmap_trans.tiff")
pheatmap(samplePoisDistMatrix, clustering_distance_rows = poisd$dd, clustering_distance_cols = poisd$dd, col = colors)
dev.off()
tiff("PCAplot_trans.tiff")
plotPCA(rld, intgroup = c("condition", "cell"))
dev.off()
pcaData <- plotPCA(rld, intgroup = c( "condition", "cell"), returnData = TRUE)
pcaData
percentVar <- round(100 * attr(pcaData, "percentVar"))
tiff("PCAplot2_trans.tiff")
ggplot(pcaData, aes(x = PC1, y = PC2, color = cell, group = cell, label=rownames(pcaData))) + geom_point(size = 3) + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) + coord_fixed() + geom_line()
dev.off()
mds <- as.data.frame(colData(rld))  %>% cbind(cmdscale(sampleDistMatrix))
tiff("MDSplot_trans.tiff")
ggplot(mds, aes(x = `1`, y = `2`, color = condition)) + geom_point(size = 3) + coord_fixed()
dev.off()
mdsPois <- as.data.frame(colData(dds)) %>% cbind(cmdscale(samplePoisDistMatrix))
tiff("MDSpois_trans.tiff")
ggplot(mdsPois, aes(x = `1`, y = `2`, color = condition)) + geom_point(size = 3) + coord_fixed()
dev.off()
dds <- DESeq(dds)
topVarGenes <- head(order(rowVars(assay(rld)), decreasing = TRUE), 60)
mat  <- assay(rld)[ topVarGenes, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,5]
colnames(anno) <- "t_name"
tiff("top60heatmap_trans.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, fontsize_row=6)
dev.off()
dat  <- counts(dds, normalized = TRUE)
idx  <- rowMeans(dat) > 1
dat  <- dat[idx, ]
mod  <- model.matrix(~ condition, colData(dds))
mod0 <- model.matrix(~   1, colData(dds))
svseq <- svaseq(dat, mod, mod0, n.sv = 2)
svseq$sv
res <- results(dds)
res <- results(dds, contrast=c("condition","A","B"))
mcols(res, use.names = TRUE)
print("summary of newly calculated results")
summary(res)
res.05 <- results(dds, alpha = 0.05)
print("Table of new results with padj less then 0.05")
table(res.05$padj < 0.05)
resLFC1 <- results(dds, lfcThreshold=1)
print("Table of new results with log fold change greater then 1 and padj less then 0.1")
table(resLFC1$padj < 0.1) 
results <- results(dds, contrast = c("condition", "A", "B"))
write.csv(results, "resultsall_trans.csv")
print("Number of transcripts with pvalue less then 0.05")
sum(res$pvalue < 0.05, na.rm=TRUE)
print("number of transcripts with pvalue sorted")
sum(!is.na(res$pvalue))
print("number of transcripts with padj less then 0.1")
sum(res$padj < 0.1, na.rm=TRUE)
resSig <- subset(res, padj < 0.1)
print("top transcripts based on log2 fold changes")
head(resSig[ order(resSig$log2FoldChange), ])
resSigdown <- resSig[ order(resSig$log2FoldChange), ]
write.csv(resSigdown, "Downreg_trans.csv")
resSigup <- resSig[ order(resSig$log2FoldChange, decreasing = TRUE), ]
write.csv(resSigup, "Upreg_trans.csv")
res <- lfcShrink(dds, contrast=c("condition","A","B"), res=res)
tiff("MAplot_trans.tiff")
plotMA(res, ylim = c(-5, 5))
dev.off()
tiff("Histopvalue_trans")
hist(res$pvalue[res$baseMean > 1], breaks = 0:20/20, col = "grey50", border = "white")
dev.off()
##this is for K048
table3 <- read.csv("transcript_count_matrixedited.csv")
table4 <- table3$K054M1 <- NULL
table5 <- table3$K054M2 <- NULL
table6 <- table3$K054M3 <- NULL
table7 <- table3$K054Z1 <- NULL
table8 <- table3$K054Z2 <- NULL
table9 <- table3$K054Z3 <- NULL
tablea <- table3$G010M1 <- NULL
tableb <- table3$G010M2 <- NULL
tablec <- table3$G010M3 <- NULL
tabled <- table3$G010Z1 <- NULL
tablee <- table3$G010Z2 <- NULL
tablef <- table3$G010Z3 <- NULL
write.csv(table3, "K048transcript_count_matrix.csv", row.names=FALSE)
countData <- as.matrix(read.csv("K048transcript_count_matrix.csv", row.names="t_name"))
colData <- read.csv("PHENO_DATAZika.csv", row.names=1)
print("Do the row and columns names match in your files?")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("After renaming do the row and columns names still match?")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition)
print("Number of rows in new Matrix")
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
print("Number of rows in new Matrix that are greater then 1 count")
nrow(dds)
print("Taking rlog of new matrix counts")
rld <- rlog(dds, blind = FALSE)
print("top three rows in new rlog matrix")
head(assay(rld), 3)
vsd <- vst(dds, blind = FALSE)
print("top three rows in new vst rlog matrix")
head(assay(vsd), 3)
dds <- estimateSizeFactors(dds)
dds <- DESeq(dds)
topVarGenes <- head(order(rowVars(assay(rld)), decreasing = TRUE), 60)
mat  <- assay(rld)[ topVarGenes, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,5]
colnames(anno) <- "t_name"
tiff("K048top60heatmap_trans.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, fontsize_row=6)
dev.off()
dat  <- counts(dds, normalized = TRUE)
idx  <- rowMeans(dat) > 1
dat  <- dat[idx, ]
mod  <- model.matrix(~ condition, colData(dds))
mod0 <- model.matrix(~   1, colData(dds))
svseq <- svaseq(dat, mod, mod0, n.sv = 2)
svseq$sv
res <- results(dds)
res <- results(dds, contrast=c("condition","A","B"))
mcols(res, use.names = TRUE)
print("summary of newly calculated results")
summary(res)
res.05 <- results(dds, alpha = 0.05)
print("Table of new results with padj less then 0.05")
table(res.05$padj < 0.05)
resLFC1 <- results(dds, lfcThreshold=1)
print("Table of new results with log fold change greater then 1 and padj less then 0.1")
table(resLFC1$padj < 0.1) 
results <- results(dds, contrast = c("condition", "A", "B"))
write.csv(results, "K048results_trans.csv")
print("Number of transcripts with pvalue less then 0.05")
sum(res$pvalue < 0.05, na.rm=TRUE)
print("number of transcripts with pvalue sorted")
sum(!is.na(res$pvalue))
print("number of transcripts with padj less then 0.1")
sum(res$padj < 0.1, na.rm=TRUE)
resSig <- subset(res, padj < 0.1)
print("top transcripts based on log2 fold changes")
head(resSig[ order(resSig$log2FoldChange), ])
resSigdown <- resSig[ order(resSig$log2FoldChange), ]
write.csv(resSigdown, "K048Downreg_trans.csv")
resSigup <- resSig[ order(resSig$log2FoldChange, decreasing = TRUE), ]
write.csv(resSigup, "K048Upreg_trans.csv")
res <- lfcShrink(dds, contrast=c("condition","A","B"), res=res)
##This is for K054
countData <- read.csv("transcript_count_matrixedited.csv")
table4 <- countData$K048M1 <- NULL
table5 <- countData$K048M2 <- NULL
table6 <- countData$K048M3 <- NULL
table7 <- countData$K048Z1 <- NULL
table8 <- countData$K048Z2 <- NULL
table9 <- countData$K048Z3 <- NULL
tablea <- countData$G010M1 <- NULL
tableb <- countData$G010M2 <- NULL
tablec <- countData$G010M3 <- NULL
tabled <- countData$G010Z1 <- NULL
tablee <- countData$G010Z2 <- NULL
tablef <- countData$G010Z3 <- NULL
write.csv(countData, "K054transcript_count_matrix.csv", row.names=FALSE)
countData <- as.matrix(read.csv("K054transcript_count_matrix.csv", row.names="t_name"))
colData <- read.csv("PHENO_DATAZika.csv", row.names=1)
print("Do the row and columns names match in your files?")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("After renaming do the row and columns names still match?")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition)
print("Number of rows in new Matrix")
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
print("Number of rows in new Matrix that are greater then 1 count")
nrow(dds)
print("Taking rlog of new matrix counts")
rld <- rlog(dds, blind = FALSE)
print("top three rows in new rlog matrix")
head(assay(rld), 3)
vsd <- vst(dds, blind = FALSE)
print("top three rows in new vst rlog matrix")
head(assay(vsd), 3)
dds <- estimateSizeFactors(dds)
dds <- DESeq(dds)
topVarGenes <- head(order(rowVars(assay(rld)), decreasing = TRUE), 60)
mat  <- assay(rld)[ topVarGenes, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,5]
colnames(anno) <- "t_name"
tiff("K054top60heatmap_trans.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, fontsize_row=6)
dev.off()
dat  <- counts(dds, normalized = TRUE)
idx  <- rowMeans(dat) > 1
dat  <- dat[idx, ]
mod  <- model.matrix(~ condition, colData(dds))
mod0 <- model.matrix(~   1, colData(dds))
svseq <- svaseq(dat, mod, mod0, n.sv = 2)
svseq$sv
res <- results(dds)
res <- results(dds, contrast=c("condition","A","B"))
mcols(res, use.names = TRUE)
print("summary of newly calculated results")
summary(res)
res.05 <- results(dds, alpha = 0.05)
print("Table of new results with padj less then 0.05")
table(res.05$padj < 0.05)
resLFC1 <- results(dds, lfcThreshold=1)
print("Table of new results with log fold change greater then 1 and padj less then 0.1")
table(resLFC1$padj < 0.1) 
results <- results(dds, contrast = c("condition", "A", "B"))
write.csv(results, "K054results_trans.csv")
print("Number of transcripts with pvalue less then 0.05")
sum(res$pvalue < 0.05, na.rm=TRUE)
print("number of transcripts with pvalue sorted")
sum(!is.na(res$pvalue))
print("number of transcripts with padj less then 0.1")
sum(res$padj < 0.1, na.rm=TRUE)
resSig <- subset(res, padj < 0.1)
print("top transcripts based on log2 fold changes")
head(resSig[ order(resSig$log2FoldChange), ])
resSigdown <- resSig[ order(resSig$log2FoldChange), ]
write.csv(resSigdown, "K054Downreg_trans.csv")
resSigup <- resSig[ order(resSig$log2FoldChange, decreasing = TRUE), ]
write.csv(resSigup, "K054Upreg_trans.csv")
##this is for G010
table3 <- as.matrix(read.csv("transcript_count_matrixedited.csv"))
table4 <- table3$K048M1 <- NULL
table5 <- table3$K048M2 <- NULL
table6 <- table3$K048M3 <- NULL
table7 <- table3$K048Z1 <- NULL
table8 <- table3$K048Z2 <- NULL
table9 <- table3$K048Z3 <- NULL
tablea <- table3$K054M1 <- NULL
tableb <- table3$K054M2 <- NULL
tablec <- table3$K054M3 <- NULL
tabled <- table3$K054Z1 <- NULL
tablee <- table3$K054Z2 <- NULL
tablef <- table3$K054Z3 <- NULL
write.csv(countData, "G010transcript_count_matrix.csv", row.names=FALSE)
countData <- as.matrix(read.csv("G010transcript_count_matrix.csv", row.names="t_name"))
colData <- read.csv("PHENO_DATAZika.csv", row.names=1)
print("Do the row and columns names match in your files?")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("After renaming do the row and columns names still match?")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition)
print("Number of rows in new Matrix")
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
print("Number of rows in new Matrix that are greater then 1 count")
nrow(dds)
print("Taking rlog of new matrix counts")
rld <- rlog(dds, blind = FALSE)
print("top three rows in new rlog matrix")
head(assay(rld), 3)
vsd <- vst(dds, blind = FALSE)
print("top three rows in new vst rlog matrix")
head(assay(vsd), 3)
dds <- estimateSizeFactors(dds)
dds <- DESeq(dds)
topVarGenes <- head(order(rowVars(assay(rld)), decreasing = TRUE), 60)
mat  <- assay(rld)[ topVarGenes, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,5]
colnames(anno) <- "t_name"
tiff("G010top60heatmap_trans.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, fontsize_row=6)
dev.off()
dat  <- counts(dds, normalized = TRUE)
idx  <- rowMeans(dat) > 1
dat  <- dat[idx, ]
mod  <- model.matrix(~ condition, colData(dds))
mod0 <- model.matrix(~   1, colData(dds))
svseq <- svaseq(dat, mod, mod0, n.sv = 2)
svseq$sv
res <- results(dds)
res <- results(dds, contrast=c("condition","A","B"))
mcols(res, use.names = TRUE)
print("summary of newly calculated results")
summary(res)
res.05 <- results(dds, alpha = 0.05)
print("Table of new results with padj less then 0.05")
table(res.05$padj < 0.05)
resLFC1 <- results(dds, lfcThreshold=1)
print("Table of new results with log fold change greater then 1 and padj less then 0.1")
table(resLFC1$padj < 0.1) 
results <- results(dds, contrast = c("condition", "A", "B"))
write.csv(results, "G010results_trans.csv")
print("Number of transcripts with pvalue less then 0.05")
sum(res$pvalue < 0.05, na.rm=TRUE)
print("number of transcripts with pvalue sorted")
sum(!is.na(res$pvalue))
print("number of transcripts with padj less then 0.1")
sum(res$padj < 0.1, na.rm=TRUE)
resSig <- subset(res, padj < 0.1)
print("top transcripts based on log2 fold changes")
head(resSig[ order(resSig$log2FoldChange), ])
resSigdown <- resSig[ order(resSig$log2FoldChange), ]
write.csv(resSigdown, "G010Downreg_trans.csv")
resSigup <- resSig[ order(resSig$log2FoldChange, decreasing = TRUE), ]
write.csv(resSigup, "G010Upreg_trans.csv")
res <- lfcShrink(dds, contrast=c("condition","A","B"), res=res)
##these make final tables for VEGF and ADAR transcripts
table1 <- read.csv("transcript_count_matrix.csv")
table2 <- read.csv("t_names.csv")
table3 <- merge(table2, table1, by="t_id")
table4 <- table3$t_id <- NULL
table5 <- colnames(table3)[c(2:19)] <- rownames(Data)[c(1:18)]
write.csv(table3, "transcript_count_matrixedited.csv", row.names=FALSE)
table1 <- read.csv("transcript_count_matrixedited.csv")
table2 <- read.csv("ADAR1transcript.csv")
table3 <- merge(table2, table1, by="t_name")
table4 <- table3$t_id <- NULL
table5 <- colnames(table3)[c(2:19)] <- rownames(Data)[c(1:18)]
tableB1 <- read.csv("resultsall_trans.csv")
table5 <- colnames(tableB1)[c(1)] <- c("t_name")
head(tableB1)
tableC3 <- merge(table3, tableB1, by="t_name")
write.csv(tableC3, "resultsADAR1_trans_counts.csv", row.names=FALSE)
Data <- read.csv("bargraphindex.csv")
Data2 <- colnames(Data)[2] <- "t_name"
tablebargraph <- t(tableC3)
colnames(tablebargraph) <- tableC3[,1]
tablebargraph2 <- tablebargraph[-c(1,20, 21, 22, 23, 24, 25), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "t_name"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="t_name")
tablebargraph4 <- aggregate(tablebargraph3[, 4:11], list(tablebargraph3$sample), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
tablebargraphF <- colnames(tablebargraph5)[1] <- "t_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
tablebargraph6 <- read.csv("6.csv")
tablebargraphE <- colnames(tablebargraph6)[1] <- "t_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
tablebargraphI <- colnames(tablebargraph6)[2] <- "V1"
tablebargraph5["condition"] <- "A"
tablebargraph6["condition"] <- "B"
final <- rbind(tablebargraph5, tablebargraph6)
tiff("ADAR1isoformbar1.tiff")
ggplot(final, aes(x=t_name, y=V1, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()

table11 <- read.csv("transcript_count_matrixedited.csv")
table21 <- read.csv("ADARB1transcript.csv")
table31 <- merge(table21, table11, by="t_name")
table41 <- table31$t_id <- NULL
table51 <- colnames(table31)[c(2:19)] <- rownames(Data)[c(1:18)]
tableC31 <- merge(table31, tableB1, by="t_name")
write.csv(tableC31, "resultsADARB1_trans_counts.csv", row.names=FALSE)
tablebargraph <- t(tableC31)
colnames(tablebargraph) <- tableC31[,1]
tablebargraph2 <- tablebargraph[-c(1,20, 21, 22, 23, 24, 25), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "t_name"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="t_name")
tablebargraph4 <- aggregate(tablebargraph3[, 3:11], list(tablebargraph3$sample), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
tablebargraphF <- colnames(tablebargraph5)[1] <- "t_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
tablebargraph6 <- read.csv("6.csv")
tablebargraphE <- colnames(tablebargraph6)[1] <- "t_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
tablebargraphI <- colnames(tablebargraph6)[2] <- "V1"
tablebargraph5["condition"] <- "A"
tablebargraph6["condition"] <- "B"
final <- rbind(tablebargraph5, tablebargraph6)
tiff("ADARB1isoformbar1.tiff")
ggplot(final, aes(x=t_name, y=V1, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()


table12 <- read.csv("transcript_count_matrixedited.csv")
table22 <- read.csv("ADARB2transcript.csv")
table32 <- merge(table22, table12, by="t_name")
table42 <- table32$t_id <- NULL
table52 <- colnames(table32)[c(2:19)] <- rownames(Data)[c(1:18)]
tableC32 <- merge(table32, tableB1, by="t_name")
write.csv(tableC32, "resultsADARB2_trans_counts.csv", row.names=FALSE)
tablebargraph <- t(tableC32)
colnames(tablebargraph) <- tableC32[,1]
tablebargraph2 <- tablebargraph[-c(1,20, 21, 22, 23, 24, 25), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "t_name"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="t_name")
tablebargraph4 <- aggregate(tablebargraph3[, 3:5], list(tablebargraph3$sample), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
tablebargraphF <- colnames(tablebargraph5)[1] <- "t_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
tablebargraph6 <- read.csv("6.csv")
tablebargraphE <- colnames(tablebargraph6)[1] <- "t_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
tablebargraphI <- colnames(tablebargraph6)[2] <- "V1"
tablebargraph5["condition"] <- "A"
tablebargraph6["condition"] <- "B"
final <- rbind(tablebargraph5, tablebargraph6)
tiff("ADARB2isoformbar1.tiff")
ggplot(final, aes(x=t_name, y=V1, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()

table13 <- read.csv("transcript_count_matrixedited.csv")
table23 <- read.csv("VEGFAtranscript.csv")
table33 <- merge(table23, table13, by="t_name")
table43 <- table33$t_id <- NULL
table53 <- colnames(table33)[c(2:19)] <- rownames(Data)[c(1:18)]
tableC33 <- merge(table33, tableB1, by="t_name")
write.csv(tableC33, "resultsVEGFA_trans_counts.csv", row.names=FALSE)
tablebargraph <- t(tableC33)
colnames(tablebargraph) <- tableC33[,1]
tablebargraph2 <- tablebargraph[-c(1,20, 21, 22, 23, 24, 25), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "t_name"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="t_name")
tablebargraph4 <- aggregate(tablebargraph3[, 3:23], list(tablebargraph3$sample), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
tablebargraphF <- colnames(tablebargraph5)[1] <- "t_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
tablebargraph6 <- read.csv("6.csv")
tablebargraphE <- colnames(tablebargraph6)[1] <- "t_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
tablebargraphI <- colnames(tablebargraph6)[2] <- "V1"
tablebargraph5["condition"] <- "A"
tablebargraph6["condition"] <- "B"
final <- rbind(tablebargraph5, tablebargraph6)
tiff("VEGFAisoformbar1.tiff")
ggplot(final, aes(x=t_name, y=V1, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()

table14 <- read.csv("transcript_count_matrixedited.csv")
table24 <- read.csv("VEGFBtranscript.csv")
table34 <- merge(table24, table1, by="t_name")
table44 <- table34$t_id <- NULL
table54 <- colnames(table34)[c(2:19)] <- rownames(Data)[c(1:18)]
tableC34 <- merge(table34, tableB1, by="t_name")
write.csv(tableC34, "resultsVEGFB_trans_counts.csv", row.names=FALSE)
tablebargraph <- t(tableC34)
colnames(tablebargraph) <- tableC34[,1]
tablebargraph2 <- tablebargraph[-c(1,20, 21, 22, 23, 24, 25), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "t_name"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="t_name")
tablebargraph4 <- aggregate(tablebargraph3[, 3:6], list(tablebargraph3$sample), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
tablebargraphF <- colnames(tablebargraph5)[1] <- "t_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
tablebargraph6 <- read.csv("6.csv")
tablebargraphE <- colnames(tablebargraph6)[1] <- "t_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
tablebargraphI <- colnames(tablebargraph6)[2] <- "V1"
tablebargraph5["condition"] <- "A"
tablebargraph6["condition"] <- "B"
final <- rbind(tablebargraph5, tablebargraph6)
tiff("VEGFBisoformbar1.tiff")
ggplot(final, aes(x=t_name, y=V1, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()
