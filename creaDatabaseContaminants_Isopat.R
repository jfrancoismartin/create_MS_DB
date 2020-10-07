#########################################################################
## 
## Perform creation of a theoretical list of ions using package enviPat 
## using the function ----creaDBtoMatch--- in the ---DB_box.R--- script
## in order to match with a peaklist of extrated ions via xcms or other software
## Entry : a file with at least
##  - 1 column of entry 
##  - 1 column of formulas
## 
## Parameters :
##  - subscript of entry and formula in the initial file
##  - Vector of adducts and fragments
##  - name of spectro or resolution
##  - 
## output : the initial files + m/z + relative intensities for all adducts and fragments and isotopes 
##
#########################################################################
library(gdata)
library(xlsx)
library(enviPat)
data(isotopes)
data(adducts)
library(dplyr)
#########################################################################
## share directory to access to the different function of matching

## repPar="//tls-tox-nas/TOXALIM/E20/Partage de Fichiers/PROG"
## repPar <- "C:/Users/jfmartin/OneDrive Entreprise 1/Developpements"
repPar <- "//tls-tox-nas/HOME$/jfmartin/Mes documents/PROJETS/"
### ou
repPar  <- "O:/E20/Partage de Fichiers/"
### ou
repPar <- "C:/MesDocuments/PROJETS/"

#O:\E20\Partage de Fichiers\PROG\tools_DB
source(paste(repPar,"PROG/tools_DB/DB_box.R",sep=""))


#########################################################################
####
####     initial DB with Formula : contaminants & pesticides & PVC & 
####           V E R S I O N   13/09/2019
####  adduct are included in the DB and doesn't need to be computed by enviPat
#########################################################################

contaminants <- "(transféré sharepoint) DB Screening_Contaminant_v200619.xlsx"

iniDB <- read.xlsx2(paste(repPar,"DB/ContaminantPesticides/",contaminants,sep=""),
                    sheetIndex=1,
                    header=TRUE,
                    stringsAsFactors = FALSE)


## subscripts of formula and entry (unique ID of molecules) in initial compounds database
colFormula <- 12
## subscript of monoisotopic mass
colDBmass <- 13
## subscrip of mole id
colID <- 1
## label used to describe the isotopes
labIso <- c("[M]","[M+1]","[M+2]","[M+3]","[M+4]","[M+5]","[M+6]","[M+7]","[M+8]","[M+9]","[M+10]","[M+11]","[M+12]","[M+13]","[M+14]","[M+15]","[M+16]","[M+17]","[M+18]")

massH <- 1.0078250321
electron <- 0.0005486
# depending on the ionisation, an isotopic mass colum is added to the peaklist to be matched with the MASS db
#mzneg <- as.numeric(iniDB[[colDBmass]]) - massH + electron
#mzpos <- as.numeric(iniDB[[colDBmass]]) + massH - electron

## outfile date version
datver <- Sys.time()
datver <- paste(substr(datver,3,4),substr(datver,6,7),substr(datver,9,10),sep="")

## limitation du calcul isotopiques à C et S
## isotopes <- isotopes[isotopes$element=="C" , ]

## Possibly create a subset of iniDB
iniDBl <-iniDB

# molecules with at least 1 H
iniDBl <- iniDBl[regexpr("H",iniDB[[colFormula]])>0,]

############################################ processing positive ioni ######################################################

## vector containing the different adducts fragments to take into account 

adducts <- rbind(adducts, data.frame(Name="M-H2O+H", calc=paste('M', -17.00273965-0.00054858, sep=''),
 	Charge=1, Mult=1, Mass=-17.00273965-0.00054858, Ion_mode="positive", Formula_add="H1", Formula_ded="H2O1", Multi=1))

adductsPos=c('M+H','M+Na','M+NH4','M-H2O+H')

dbcontaminantsPOS <- creaDBtoMatch(iniDBl=iniDBl, colFormula=colFormula, colID=colID, ioni="positive",
                           adduct=adductsPos,
                           labIso=labIso,
                           spectro=NULL,
                           reso=20000)

# lines below to computed difference between envipat and mz computed with mass monoiso of the database EJA
# ppmDiff <- rep(NA, nrow(dbcontaminantsPOS))
# colmzpos <- 23
# colmzneg <- 22
# colmzEnvipat <- 27
# colIso <- 26
# 
# for (i in 1:nrow(dbcontaminantsPOS)) if (!is.na(dbcontaminantsPOS[i,colIso]) & dbcontaminantsPOS[i,colIso]=="[M]") 
#    ppmDiff[i] <- 1e6*abs(dbcontaminantsPOS[i,colmzEnvipat] - 
#                             dbcontaminantsPOS[i,colmzpos])/
#    dbcontaminantsPOS[i,colmzEnvipat]
# 
# dbcontaminantsPOS <- data.frame(dbcontaminantsPOS,ppmDiff)

save(dbcontaminantsPOS,file=paste(repPar,"DB/dbcontaminantsPOS_",datver,".Rdata",sep=""))
write.table(dbcontaminantsPOS,file=paste(repPar,"DB/dbcontaminantsPOS_",datver,".txt",sep=""), row.names = FALSE, sep="\t")

############################################ processing negative ioni ######################################################

adductsNeg=c('M-H','M-H2O-H','M+Cl')  

dbcontaminantsNEG <- creaDBtoMatch(iniDBl=iniDBl, colFormula=colFormula, colID=colID, ioni="negative",
                                   adduct=adductsNeg,
                                   labIso=labIso, 
                                   spectro=NULL,
                                   reso=20000)

# lines below to computed difference between envipat and mz computed with mass monoiso of the database EJA
# ppmDiff <- rep(NA, nrow(dbcontaminantsNEG))
# colmzpos <- 23
# colmzneg <- 22
# colmzEnvipat <- 27
# colIso <- 26
# 
# for (i in 1:nrow(dbcontaminantsNEG)) if (!is.na(dbcontaminantsNEG[i,colIso]) & dbcontaminantsNEG[i,colIso]=="[M]") 
#       ppmDiff[i] <- 1e6*abs(dbcontaminantsNEG[i,colmzEnvipat] - 
#                             dbcontaminantsNEG[i,colmzneg])/
#                             dbcontaminantsNEG[i,colmzEnvipat]
# dbcontaminantsNEG <- data.frame(dbcontaminantsNEG,ppmDiff)

save(dbcontaminantsNEG,file=paste(repPar,"DB/dbcontaminantsNEG_",datver,".Rdata",sep=""))
write.table(dbcontaminantsNEG,file=paste(repPar,"DB/dbcontaminantsNEG_",datver,".txt",sep=""), row.names = FALSE, sep="\t")
#######################################################  END compest ########################################################################

