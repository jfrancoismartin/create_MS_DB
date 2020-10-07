## R script that parse an HMDB txt download file and create a Rdata file 
## to match with a peaklist

library(XML)
library(methods)

setwd("C:/dataProjets/HMDB")

##################################  H M D B   ALL METABOLITES ######################################

infil <- "hmdb_metabolites.xml"
outfil <- "HMDB_200901"

#### try to parse new version of HMDB database

rH1 <- xmlTreeParse(file=infil)

## init variable receiving HMDB data
xmltop = xmlRoot(rH1)
nbm <- xmlSize(xmltop)
entry <- character(length = nbm)
name <- character(length = nbm)
formula <- character(length = nbm)
mass <- rep(NA,nbm)

for (i in 1:nbm) {
   tryCatch({
      entry[i]   <- xmlValue(xmltop[[i]][[4]])
      name[i]    <- xmlValue(xmltop[[i]][[7]])
      formula[i] <- xmlValue(xmltop[[i]][[11]])
      mass[i]    <- xmlValue(xmltop[[i]][[13]])
 #    inchi[i]   <- xmlValue(xmltop[[i]][[18]]) 
      }
      ,error=function(e) {cat("Error with metabolite:",i,"\n")})
}
mass <-as.numeric(mass)
xHMDB <- data.frame(entry,name,formula,mass)

## suppress all metabolite without mass
xHMDB <- xHMDB[!is.na(xHMDB$mass),]
xHMDB <- xHMDB[(xHMDB$mass > 65 & xHMDB$mass<1000),]
save(xHMDB,file=paste(outfil,".Rdata",sep=""))
write.table(xHMDB,file=paste(outfil,".txt",sep=""),sep="\t", row.names=F,quote=F)

# i <-28; for (j in 1:100) cat(j,xmlValue(xmltop[[i]][[j]]),"\n")

##################################  H M D B    U R I N E ######################################

infil <- "urine_metabolites.xml"
outfil <- "HMDBurine_200901"

#### try to parse new version of HMDB database

rH1 <- xmlTreeParse(file=infil)

## init variable receiving HMDB data
xmltop = xmlRoot(rH1)
nbm <- xmlSize(xmltop)
entry <- character(length = nbm)
name <- character(length = nbm)
formula <- character(length = nbm)
mass <- rep(NA,nbm)

for (i in 1:nbm) {
   tryCatch({
   entry[i]   <- xmlValue(xmltop[[i]][[4]])
   name[i]    <- xmlValue(xmltop[[i]][[7]])
   formula[i] <- xmlValue(xmltop[[i]][[11]])
   mass[i]    <- xmlValue(xmltop[[i]][[13]])
 #  inchi[i]   <- xmlValue(xmltop[[i]][[18]]) 
   }
    ,error=function(e) {cat("Error with metabolite:",i,"\n")})
}

mass <-as.numeric(mass)
xHMDB <- data.frame(entry,name,formula,mass)

## suppress all metabolite without mass
xHMDB <- xHMDB[!is.na(xHMDB$mass),]
xHMDB <- xHMDB[(xHMDB$mass > 65 & xHMDB$mass<1000),]

save(xHMDB,file=paste(outfil,".Rdata",sep=""))
write.table(xHMDB,file=paste(outfil,".txt",sep=""),sep="\t", row.names=F,quote=F)

##################################  H M D B   S E R U M ######################################

infil <- "serum_metabolites.xml"
outfil <- "HMDBserum_200901"

#### try to parse new version of HMDB database

rH1 <- xmlTreeParse(file=infil)

## init variable receiving HMDB data
xmltop = xmlRoot(rH1)
nbm <- xmlSize(xmltop)
entry <- character(length = nbm)
name <- character(length = nbm)
formula <- character(length = nbm)
mass <- rep(NA,nbm)

for (i in 1:nbm) {
   tryCatch({
   entry[i]   <- xmlValue(xmltop[[i]][[4]])
   name[i]    <- xmlValue(xmltop[[i]][[7]])
   formula[i] <- xmlValue(xmltop[[i]][[11]])
   mass[i]    <- xmlValue(xmltop[[i]][[13]])
#   inchi[i]   <- xmlValue(xmltop[[i]][[18]]) 
   }
    ,error=function(e) {cat("Error with metabolite:",i,"\n")})
}

mass <-as.numeric(mass)
xHMDB <- data.frame(entry,name,formula,mass)

## suppress all metabolite without mass
xHMDB <- xHMDB[!is.na(xHMDB$mass),]
xHMDB <- xHMDB[(xHMDB$mass > 65 & xHMDB$mass<1000),]

save(xHMDB,file=paste(outfil,".Rdata",sep=""))
write.table(xHMDB,file=paste(outfil,".txt",sep=""),sep="\t", row.names=F,quote=F)

##################################  H M D B   F E C E S  ######################################

infil <- "feces_metabolites.xml"
outfil <- "HMDBfeces_200901"

#### try to parse new version of HMDB database
#repRes=paste(repPar,"DB/",sep="")
#setwd(repRes)

rH1 <- xmlTreeParse(file=infil)

## init variable receiving HMDB data
xmltop = xmlRoot(rH1)
nbm <- xmlSize(xmltop)
entry <- character(length = nbm)
name <- character(length = nbm)
formula <- character(length = nbm)
mass <- rep(NA,nbm)

for (i in 1:nbm) {
   tryCatch({
   entry[i]   <- xmlValue(xmltop[[i]][[4]])
   name[i]    <- xmlValue(xmltop[[i]][[7]])
   formula[i] <- xmlValue(xmltop[[i]][[11]])
   mass[i]    <- xmlValue(xmltop[[i]][[13]])
#   inchi[i]   <- xmlValue(xmltop[[i]][[18]]) 
   }
    ,error=function(e) {cat("Error with metabolite:",i,"\n")})
}

mass <-as.numeric(mass)
xHMDB <- data.frame(entry,name,formula,mass)

## suppress all metabolite without mass
xHMDB <- xHMDB[!is.na(xHMDB$mass),]
xHMDB <- xHMDB[(xHMDB$mass > 65 & xHMDB$mass<1000),]

save(xHMDB,file=paste(outfil,".Rdata",sep=""))
write.table(xHMDB,file=paste(outfil,".txt",sep=""),sep="\t", row.names=F,quote=F)



