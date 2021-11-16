
#############    Creation des bases des fichiers de standards AXIOM pour QTOF et ORBITRAP
## Pour l'Orbi, calcul des ions adduits fragments isotopes sur la base des règles de CAMERA
## répertoire partagé pour prog et bases de données Standard + HMDB

library(openxlsx)

repPar="O:/E20/Partage de Fichiers/"
#repPar <- "C:/Users/jfmartin/Documents/PROJETS/"
#source(paste(repPar,"PROG/match_mass/match_mass_script_new.R",sep=""))
#source(paste(repPar,"PROG/tools_R/toolbox.R",sep=""))
source(paste(repPar,"PROG/tools_DB/DB_box.R",sep=""))

###############################################################
###  L A S T    B  A S E   S T A N D A R T S    A X I O M
INdb <- "copieAXIOM_PoolCompounds_v200130.xlsx"
###
###
###############################################################

dateUp <- dateVersion()

std <- read.xlsx(xlsxFile= paste(repPar,"DB/AXIOMstandards/",INdb,sep=""),sheet = 1)

std$monoistopic_molecular_weigth <- as.numeric(std$monoistopic_molecular_weigth)
std$rt <- as.numeric(std$rt)
std$mz <- as.numeric(std$mz)

##############################################################################################
##############################################################################################
##################                   traitement orbitrap                  ####################
##############################################################################################
##############################################################################################

std <- std[std$spectro =="ORBI-C18",]

#stdmzpos <- std[!is.na(std$mzpos),c(1,4:10,12)]
#stdmzneg <- std[!is.na(std$mzneg),c(1,4:9,11,13)]

stdmzpos <- std[(std$ionisation == "pos" & !is.na(std$mz)),c(1,4,8,9,12:17)]
stdmzneg <- std[(std$ionisation == "neg" & !is.na(std$mz)),c(1,4,8,9,12:17)]

## rules for CAMERA adduct and neutral loss
rules <- read.csv(file=paste(repPar,"DB/rulesCAMERA/rulesPosNegLigth.csv",sep=""),sep=";", stringsAsFactors = FALSE)
rulespos <- rules[rules$ionisation=="pos" | rules$ionisation=="two",]
rulesneg <- rules[rules$ionisation=="neg" | rules$ionisation=="two",]

# massH <- 1.0078250321
# electron <- 0.0005486

### boucle : pour chaque standart pos puis neg on genère l'ensemble des ions dérivés sur la base 
### de la table des règles EJA des adduits fragments CAMERA
### pour générer une nouvelle table d'annotation des ions sur base de m/z + rt

#################################### P O S I T I F #######################################
nst <- nrow(stdmzpos)
nsr <- nrow(rulespos)
nmax <- nst*nsr
DBSpos <- stdmzpos

## initialisation of variables for final dataframe
ENTRY <- rep(" ", nmax)
compound <- rep(" ", nmax)
Inchi <- rep(" ", nmax)
formula <- rep(" ", nmax)
exact.mass <- rep(NA, nmax)
mz <- rep(NA, nmax)
RT <- rep(NA, nmax)
intensity <- rep(NA, nmax)
attribution <- rep(" ", nmax)

for (i in 1:nst) {
   cat(DBSpos$name[i]," mz=",DBSpos$mz[i],"\n")
   ENTRYref  <- DBSpos$axiom_id[i]
   compoundref <- DBSpos$name[i]
   Inchiref <- DBSpos$Inchi[i]
   formularef <- DBSpos$formula_neutral[i]
   exactmassref <- DBSpos$monoistopic_molecular_weigth[i]
   mzref <- DBSpos$mz[i]
   rtref <- DBSpos$rt[i]
   intensityref <- DBSpos$intensity[i]
   k <- 0
   for (j in 1:nsr) {
      k <- (i-1) * nsr +j
      ENTRY[k] <- ENTRYref
      compound[k] <- compoundref
      Inchi[k] <- Inchiref
      formula[k] <- formularef
      exact.mass[k] <- exactmassref
      mz[k] <- mzref+ rulespos$massdiff[j]
      RT[k] <- rtref
      intensity[k] <- intensityref
      attribution[k] <- rulespos$name[j]
      #cat("mz calc =",mz[k]," adduct name : ",rulespos$name[j],"\n")
   }
}
DBORBIPOS <- data.frame(ENTRY,compound,Inchi,formula,exact.mass,RT,mz,intensity,attribution, stringsAsFactors = FALSE)

#################################### N E G A T I F #######################################
nst <- nrow(stdmzneg)
nsr <- nrow(rulesneg)
nmax <- nst*nsr
DBSneg <- stdmzneg 

ENTRY <- rep(" ", nmax)
compound <- rep(" ", nmax)
Inchi <- rep(" ", nmax)
formula <- rep(" ", nmax)
exact.mass <- rep(NA, nmax)
mz <- rep(NA, nmax)
RT <- rep(NA, nmax)
intensity <- rep(NA, nmax)
attribution <- rep(" ", nmax)

for (i in 1:nst) {
   cat(DBSneg$name[i]," mz=",DBSneg$mz[i],"\n")
   ENTRYref  <- DBSneg$axiom_id[i]
   compoundref <- DBSneg$name[i]
   Inchiref <- DBSneg$Inchi[i]
   formularef <- DBSneg$formula_neutral[i]
   exactmassref <- DBSneg$monoistopic_molecular_weigth[i]
   mzref <- DBSneg$mz[i]
   rtref <- DBSneg$rt[i]
   intensityref <- DBSneg$intensity[i]
   k <- 0
   for (j in 1:nsr) {
      k <- (i-1) * nsr +j
      ENTRY[k] <- ENTRYref
      compound[k] <- compoundref
      Inchi[k] <- Inchiref
      formula[k] <- formularef
      exact.mass[k] <- exactmassref
      mz[k] <- mzref+ rulesneg$massdiff[j]
      RT[k] <- rtref
      intensity[k] <- intensityref
      attribution[k] <- rulesneg$name[j]
      #cat("mz calc =",mz[k]," adduct name : ",rulesneg$name[j],"\n")
   }
}

DBORBINEG <- data.frame(ENTRY,compound,Inchi,formula,exact.mass,RT,mz,intensity,attribution, stringsAsFactors = FALSE)

########################  SAVE DATABASES STD WITH ADDUCT FRAGMENT ####################################

setwd(paste(repPar,"DB/",sep=""))
filposname <- paste("DBORBIPOS",dateUp,sep="")
filnegname <- paste("DBORBINEG",dateUp,sep="")
save(DBORBIPOS, file=paste(filposname,".Rdata",sep=""))
save(DBORBINEG, file=paste(filnegname,".Rdata",sep=""))
## write.table(DBORBIPOS,file=paste(filposname,".txt",sep=""),sep="\t", row.names=F,quote=F)
## write.table(DBORBINEG,file=paste(filnegname,".txt",sep=""),sep="\t", row.names=F,quote=F)


##############################################################################################
##############################################################################################
###########################          traitement QTOF                      ####################
##############################################################################################
##############################################################################################

std <- read.xlsx2(file= paste(repPar,INdb,sep=""),sheetIndex = 1,stringsAsFactors = FALSE)

std$monoistopic_molecular_weigth <- as.numeric(std$monoistopic_molecular_weigth)
std$rt <- as.numeric(std$rt)
std$mz <- as.numeric(std$mz)

std <- std[std$spectro =="QTOF-C18",]


#################################### P O S I T I F #######################################


DBQTOFPOS <- std[(std$ionisation == "pos" & !is.na(std$mz)),c(1,4,9,13,14:17,5)]
colnames(DBQTOFPOS) <- c("ENTRY","compound","Inchi","formula","exact.mass","RT","mz","intensity","attribution")


#################################### N E G A T I F #######################################

DBQTOFNEG <- std[(std$ionisation == "neg" & !is.na(std$mz)),c(1,4,9,13,14:17,5)]
colnames(DBQTOFNEG) <- c("ENTRY","compound","Inchi","formula","exact.mass","RT","mz","intensity","attribution")

setwd(paste(repPar,"DB/",sep=""))
filposname <- paste("DBQTOFPOS",dateUp,sep="")
filnegname <- paste("DBQTOFNEG",dateUp,sep="")
save(DBQTOFPOS, file=paste(filposname,".Rdata",sep=""))
save(DBQTOFNEG, file=paste(filnegname,".Rdata",sep=""))
## write.table(DBQTOFPOS,file=paste(filposname,".txt",sep=""),sep="\t", row.names=F,quote=F)
## write.table(DBQTOFNEG,file=paste(filnegname,".txt",sep=""),sep="\t", row.names=F,quote=F)



