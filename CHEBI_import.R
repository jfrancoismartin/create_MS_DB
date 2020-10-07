## R script that parse an CHEBI txt download file and create a Rdata file 
## to match with a peaklist

library(XML)
library(methods)
library(openxlsx)

repPar="C:/MesDocuments/PROJETS/"
source(paste(repPar,"PROG/tools_DB/DB_box.R",sep=""))
setwd(paste(repPar,"DB/CHEBI/",sep=""))
## subscript of db info of chemical data
iEntry <- 2
iType <- 4
iChemData  <- 5

## def of date of db creation
dateUp <- dateVersion()

##################################  CHEBI ALL METABOLITES ######################################


## after saving status C and status E in 2 different files
infile <- "compounds.xlsx"
inChem <- "chemical_data.tsv"
inchi <- "chebiId_inchi.tsv"

outfil <- paste("CHEBI",dateUp,sep="")

c <- openxlsx::read.xlsx(infile)

## filtering
compound <- c[c$STATUS=="C" | c$STATUS=="E", c(1,2,3,4,6)]

chemdata <- read.table(file = inChem, header=TRUE, sep="\t", stringsAsFactor=FALSE)

chemMassmono <- chemdata[chemdata[[iType]]=="MONOISOTOPIC MASS",c(iEntry,iType,iChemData)]
chemMassmono <- chemMassmono[as.numeric(chemMassmono$CHEMICAL_DATA)>65 &
                             as.numeric(chemMassmono$CHEMICAL_DATA)<1000 &
                                is.numeric(as.numeric(chemMassmono$CHEMICAL_DATA)),]
chemMassmono$CHEMICAL_DATA <- as.numeric(chemMassmono$CHEMICAL_DATA)

chemFormula  <- chemdata[chemdata[[iType]]=="FORMULA",c(iEntry,iType,iChemData)]

inchi <- read.table(file = inchi, header=TRUE, sep="\t", stringsAsFactor=FALSE)

CHEBI <- compound
CHEBI <- merge(x=CHEBI, y=chemFormula, by.x=1, by.y=1, all.x=FALSE, all.y=FALSE)
CHEBI <- merge(x=CHEBI, y=chemMassmono, by.x=1, by.y=1, all.x=FALSE, all.y=FALSE)
CHEBI <- CHEBI[,c(1,3,4,5,7,9)]

CHEBI <- merge(x = CHEBI, y=inchi, by.x=1, by.y = 1, all.x = TRUE, all.y = FALSE)

colnames(CHEBI) <- c("ENTRY","CHEBI_ACCESSION","SOURCE","NAME","FORMULA","MONOISOMASS","Inchi")

doublon <- duplicated(CHEBI$ENTRY)
CHEBI <- CHEBI[!doublon,]

save(CHEBI,file=paste(outfil,".Rdata",sep=""))
write.table(CHEBI,file=paste(outfil,".txt",sep=""),sep="\t",quote = FALSE, row.names=FALSE)

