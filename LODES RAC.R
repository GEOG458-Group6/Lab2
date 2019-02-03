##Setting up table and cleaning up

r = read.csv("wa_rac_S000_JT00_2015.csv")
r$h_geocode<-as.character(r$h_geocode)
r$h_geocode[which(length(r$h_geocode) == 14)]<-paste0("0",r$h_geocode[which(length(r$h_geocode) == 14)])


##Making Columns for worktract and hometract
r$rt<-substr(r$h_geocode,1,11)


##Aggregating

rturac=aggregate(. ~ r$rt,data=r[,c(2,11,13,14,16)],FUN=sum)
colnames(rturac)[colnames(rturac)=="r$rt"] <- "GEOID"

##Merge w/ MSA

msa=read.csv("WA_census_2015.csv")
names(msa)[1]=paste("rt")

racmsa=merge(msa,rturac,by="GEOID")

##Adding Combined WTU and Share Values

racmsa["RTU"]=racmsa$CNS03+racmsa$CNS06+racmsa$CNS08
racmsa["RTUshare"]=racmsa$WTU/racmsa$C000
racmsa["MANshare"]=racmsa$CNS05/racmsa$C000

write.csv(racmsa,"rac2015_Alljobs.csv")
