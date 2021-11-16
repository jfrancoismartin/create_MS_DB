################################################################################################
## R script that parse CHEBI tsv download files and create a Rdata file 
## to match with a peaklist
################################################################################################

library(XML)
library(methods)
library(openxlsx)


repPar  <- "O:/E20/Partage de Fichiers/"
#repPar="C:/Users/jfmartin/Documents/PROJETS/"

source(paste(repPar,"PROG/tools_DB/DB_box.R",sep=""))
setwd(paste(repPar,"DB/CHEBI/lastVersion/",sep=""))

## subscript of db info of chemical data iEntry : ID of molecule 
iEntry <- 2
# iType : type of data  "MONOISOTOPIC MASS" or "FORMULA"
iType  <- 4
# ichemdata columns containing the data itself corresponding to iType   
iChemData  <- 5

##################################  CHEBI ALL METABOLITES ######################################
## after saving status C and status E in 2 different files
## for compounds, convert compound downloaded and unzip TSV files by a xlsx file 
## in order to keep exact chemical name (with "'" or ",")
infile <- "compounds.xlsx"
inChem <- "chemical_data.tsv"
inchi  <- "chebiId_inchi.tsv"
################################################################################################

## def of date of db creation
dateUp <- dateVersion()

outfil <- paste("CHEBI",dateUp,sep="")

c <- openxlsx::read.xlsx(infile)

## filtering
#compound <- c[c$STATUS=="C" | c$STATUS=="E", c(1,2,3,4,6)]
compound <- c[c$STATUS=="C" | c$STATUS=="E", c(1,2,4,6)]

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
CHEBI <- CHEBI[,c(1,3,4,6,8)]

CHEBI <- merge(x = CHEBI, y=inchi, by.x=1, by.y = 1, all.x = TRUE, all.y = FALSE)

colnames(CHEBI) <- c("COMPOUND_ID","SOURCE","NAME","FORMULA","MONOISOMASS","Inchi")

doublon <- duplicated(CHEBI$ENTRY)
if (length(doublon) > 0) CHEBI <- CHEBI[!doublon,]

save(CHEBI,file=paste(outfil,".Rdata",sep=""))
write.table(CHEBI,file=paste(outfil,".txt",sep=""),sep="\t",quote = FALSE, row.names=FALSE)

