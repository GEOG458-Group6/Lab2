##Setting up table and cleaning up

w = read.csv("wa_wac_S000_JT00_2015.csv")
w$w_geocode<-as.character(w$w_geocode)
w$w_geocode[which(length(w$w_geocode) == 14)]<-paste0("0",w$w_geocode[which(length(w$w_geocode) == 14)])


##Making Columns for worktract and hometract
w$wt<-substr(w$w_geocode,1,11)


##Aggregating

wtuwac=aggregate(. ~ w$wt,data=w[,c(2,11,13,14,16)],FUN=sum)
colnames(wtuwac)[colnames(wtuwac)=="w$wt"] <- "GEOID"

##Merge w/ MSA

msa=read.csv("WA_census_2015.csv")
names(msa)[1]=paste("wt")

wacmsa=merge(msa,wtuwac,by="GEOID")


##Adding Combined WTU and Share Values

wacmsa["WTU"]=wacmsa$CNS03+wacmsa$CNS06+wacmsa$CNS08
wacmsa["WTUshare"]=wacmsa$WTU/wacmsa$C000
wacmsa["MANshare"]=wacmsa$CNS05/wacmsa$C000

write.csv(wacmsa,"wac2015_Alljobs.csv")
