### calculates SUMMARY SCORES for WOLF-SATTERTHWAITE Project (REDCAP monster) ###
# updated for Wolf Satterthwaite Reposity on Selkie Sever Redcap
# most updated as of 1/1/16

library("bitops")
library("RCurl")
library("REDCapR")
library("httr")
set_config(config(ssl_verifypeer = 0L))
set_config(config(sslversion = 1))
source("/import/speedy/scripts/hopsonr/R_utilities/redcap_read_rdh.R")

#Create a redcap.cfg file in Users directory with ALL User-Projects and User-specific Tokens
redcap_uri <- "https://selkie.uphs.upenn.edu/API/"
ALL_Projects<-read.csv("~/.redcap.cfg")

#List of projects needed for full data import 
projects<-ALL_Projects[which(ALL_Projects[,1] == "Wolf Satterthwaite Repository"),]

####Importing selected Selkie Redcap Project and Dictionary####
i<-1
p.token<-projects[i,2]
name<-projects[i,1]
#print(p.token)
#print(name)
project_data<-redcap_read_rdh(
  redcap_uri = redcap_uri,
  token = p.token,
  #config_options = list(ssl.verifypeer=FALSE), commented out for this version of R but may be required in future
  batch=1000
)$data
project_dictionary<-redcap_metadata_read(redcap_uri=redcap_uri, token=p.token)$data
#####

### cdss ###
measure="cdss"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"cdsssummary",partid3, sep="_") #combine into new string for labeled for summaryscores
giant$procedure="cdsssummary" #creates procedure column
giant$dovisit<-partid3 #assigns date to dovisit column
CDSS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
cdss<-giant[,c(grep('cdss[0-9]$', names(giant), value=T))]
cdss_int<-t(apply(cdss, 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x))) #applies mean of present items to any missing items
CDSS_SummaryScores$cdss_total<-rowSums(cdss_int)
CDSS_SummaryScores$cdss_mean<-rowMeans(cdss_int)
CDSS_SummaryScores$cdss_naflag<-ifelse(complete.cases(cdss),0,1) #flags subjects that have NAs and have estimated or missing totals
currentDate<-Sys.Date()
write.csv(CDSS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/CDSS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### panas ###
measure="panas"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"panassummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="panassummary" #creates procedure columnm
giant$dovisit<-partid3 #assigns date to dovisit column
PANAS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
panas<-giant[,c(grep('panas_(.+)', colnames(giant)))]

panas_pos<-panas[,c('panas_interested','panas_excited','panas_strong','panas_enthusiastic','panas_proud','panas_alert','panas_inspired','panas_determined','panas_attentive','panas_active')]
panas_pos$pos_NAflag<-ifelse(complete.cases(panas_pos),0,1) #flags subjects that have NAs and have estimated or missing totals
panas_pos2<-t(apply(panas_pos[,c(1:10)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
PANAS_SummaryScores$panas_pos_total<-rowSums(panas_pos2)
PANAS_SummaryScores$panas_pos_naflag<-panas_pos[,c('pos_NAflag')]
PANAS_SummaryScores$panas_pos_mean<-rowMeans(panas_pos2)

panas_neg<-panas[,c('panas_distressed','panas_upset','panas_guilty','panas_scared','panas_hostile','panas_irritable','panas_ashamed','panas_nervous','panas_jittery','panas_afraid')]
panas_neg$neg_NAflag<-ifelse(complete.cases(panas_neg),0,1) #flags subjects that have NAs and have estimated or missing totals
panas_neg2<-t(apply(panas_neg[,c(1:10)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
PANAS_SummaryScores$panas_neg_total<-rowSums(panas_neg2)
PANAS_SummaryScores$panas_neg_naflag<-panas_neg[,c('neg_NAflag')]
PANAS_SummaryScores$panas_neg_mean<-rowMeans(panas_neg2)

panas_intense<-panas[,c('panas_interested','panas_excited','panas_strong','panas_enthusiastic','panas_proud','panas_alert','panas_inspired','panas_determined','panas_attentive','panas_active','panas_distressed','panas_upset','panas_guilty','panas_scared','panas_hostile','panas_irritable','panas_ashamed','panas_nervous','panas_jittery','panas_afraid')]
panas_intense$intense_NAflag<-ifelse(complete.cases(panas_intense),0,1) #flags subjects that have NAs and have estimated or missing totals
panas_intense<-t(apply(panas_intense, 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
PANAS_SummaryScores$panas_intensity<-rowMeans(panas_intense)
PANAS_SummaryScores$panas_intense_naflag<-panas_intense[,c('intense_NAflag')]

panas_averse1<-panas[,c('panas_interested','panas_excited','panas_strong','panas_enthusiastic','panas_proud','panas_alert','panas_inspired','panas_determined','panas_attentive','panas_active')]
panas_averse1.1<-t(apply(panas_averse1[,c(1:10)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
panas_averse2<-panas[,c('panas_distressed','panas_upset','panas_guilty','panas_scared','panas_hostile','panas_irritable','panas_ashamed','panas_nervous','panas_jittery','panas_afraid')]
panas_averse2.2<-t(apply(panas_averse2[,c(1:10)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
panas_averse1mean<-rowMeans(panas_averse1.1)
panas_averse2mean<-rowMeans(panas_averse2.2)
PANAS_SummaryScores$panas_posminusneg<-panas_averse1mean-panas_averse2mean

currentDate<-Sys.Date()
write.csv(PANAS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/PANAS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### GRIT ###
measure="grit"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant[giant =="<NA>"] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"gritsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="gritsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
GRIT_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
grit<-giant[,c(grep('grit[0-9]', colnames(giant)))]
grit$NAflag<-ifelse(complete.cases(grit),0,1) #flags subjects that have NAs and have estimated or missing totals
grit_int<-t(apply(grit[,c(1:14)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
grittiness<-grit_int[,c('grit2','grit4','grit5','grit7','grit8','grit10')]
openness<-grit_int[,c('grit1','grit3','grit6','grit9','grit11','grit12')]
GRIT_SummaryScores$grit_grittiness<-rowMeans(grittiness)
GRIT_SummaryScores$grit_openness<-rowMeans(openness)
GRIT_SummaryScores$grit_naflag<-grit[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(GRIT_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/GRIT_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### STAI TRAIT ###
measure="staitrait"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"staitraitsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="staitraitsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
STAITRAIT_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
stai<-giant[,c(grep('stai_trait(.+)', colnames(giant)))]
stai$NAflag<-ifelse(complete.cases(stai),0,1) #flags subjects that have NAs and have estimated or missing totals
stai_int<-t(apply(stai[,c(1:20)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
stai1<-stai_int[,c('stai_trait22','stai_trait24','stai_trait25','stai_trait28','stai_trait29','stai_trait31','stai_trait32','stai_trait35','stai_trait37','stai_trait38','stai_trait40')]
stai2<-stai_int[,c('stai_trait21','stai_trait23','stai_trait26','stai_trait27','stai_trait30','stai_trait33','stai_trait34','stai_trait36','stai_trait39')]
stai2<-(4-stai2)+1 #reverse code items in stai2
stai3<-cbind(stai1,stai2) 
STAITRAIT_SummaryScores$staitrait_total<-rowSums(stai3)
STAITRAIT_SummaryScores$staitrait_naflag<-stai[,c('NAflag')]
STAITRAIT_SummaryScores$staitrait_avg<-rowMeans(stai3)
currentDate<-Sys.Date()
write.csv(STAITRAIT_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/STAITRAIT_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### WOLF TRAIT ###
measure="wolftrait"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"wolftraitsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="wolftraitsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
WOLFTRAIT_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
wolftrait<-giant[,c(grep('wolftrait[0-9]', colnames(giant)))]
wolftrait$NAflag<-ifelse(complete.cases(wolftrait),0,1) #flags subjects that have NAs and have estimated or missing totals
wolftrait_int<-t(apply(wolftrait[,c(1:9)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
wolftrait_effort<-wolftrait_int[,c('wolftrait1','wolftrait2','wolftrait3')]
WOLFTRAIT_SummaryScores$wolftrait_mean<-rowMeans(wolftrait_effort)
wolf_pl<-wolftrait_int[,c('wolftrait4','wolftrait6','wolftrait8')]
WOLFTRAIT_SummaryScores$wolftrait_pleasure<-rowMeans(wolf_pl)
wolf_pa<-wolftrait_int[,c('wolftrait5','wolftrait7','wolftrait9')]
WOLFTRAIT_SummaryScores$wolftrait_pain<-rowMeans(wolf_pa)
wolf_t<-wolftrait_int[,c('wolftrait1','wolftrait4')]
WOLFTRAIT_SummaryScores$wolftrait_test<-rowMeans(wolf_t)
WOLFTRAIT_SummaryScores$wolftrait_naflag<-wolftrait[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(WOLFTRAIT_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/WOLFTRAIT_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### BAI ###
measure="bai"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"baisummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="baisummary"
giant$dovisit<-partid3 #assigns date to dovisit column
BAI_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
bai<-giant[,c(grep('^bai_[0-9]', names(giant), value=T))]
bai$NAflag<-ifelse(complete.cases(bai),0,1) #flags subjects that have NAs and have estimated or missing totals
bai_int<-t(apply(bai[,c(1:21)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
BAI_SummaryScores$bai_total<-rowSums(bai_int)
BAI_SummaryScores$bai_naflag<-bai[,c('NAflag')]
BAI_SummaryScores$bai_mean<-rowMeans(bai_int)
currentDate<-Sys.Date()
write.csv(BAI_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/BAI_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### FTND ###
measure="ftnd"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"ftndsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="ftndsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
FTND_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
ftnd<-giant[,c(grep('ftnd[0-9]', colnames(giant)))]
ftnd$NAflag<-ifelse(complete.cases(ftnd),0,1) #flags subjects that have NAs and have estimated or missing totals
ftnd$ftnd1[ftnd$ftnd1 <= 10] <-0
ftnd$ftnd1[ftnd$ftnd1 >30] <-3
ftnd$ftnd1[ftnd$ftnd1 >20] <-2
ftnd$ftnd1[ftnd$ftnd1 >10] <-1
ftnd$ftnd_cigs<-(ftnd$ftnd1)
FTND_SummaryScores$ftnd_cigs<-(ftnd$ftnd_cigs)
FTND_SummaryScores$ftnd_total<- ifelse((ftnd$ftnd_cigs > 0),(ftnd$ftnd_cigs+ftnd$ftnd2+ftnd$ftnd3+ftnd$ftnd4+ftnd$ftnd5+ftnd$ftnd6),0)
FTND_SummaryScores$ftnd_naflag<-ftnd[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(FTND_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/FTND_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### SIS ###
measure="sis"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"sissummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="sissummary"
giant$dovisit<-partid3 #assigns date to dovisit column
SIS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
sis_anything<-giant[,c(grep('sis_(.+)', colnames(giant)))]
sis_scores<-sis_anything[,(1:19)]
sis_scores$NAflag<-ifelse(complete.cases(sis_scores),0,1) #flags subjects that have NAs and have estimated or missing totals
sis_anything_int<-t(apply(sis_scores[,c(1:19)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
SIS_SummaryScores$sis_avg<-rowMeans(sis_anything_int, na.rm=TRUE)
SIS_SummaryScores$sis_naflag<-sis_scores[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(SIS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/SIS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

#### DOSPERT1 ###
measure="dospert1"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"dospert1summary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="dospert1summary"
giant$dovisit<-partid3 #assigns date to dovisit column
DOSPERT1_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
dospert1<-giant[,c(grep('dospert[0-9]_[0-9]', colnames(giant)))]
dospert1$NAflag<-ifelse(complete.cases(dospert1),0,1) #flags subjects that have NAs and have estimated or missing totals
dospert_int<-t(apply(dospert1[,c(1:40)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
dospert1_eth<-dospert_int[,c('dospert1_7','dospert1_10','dospert1_11','dospert1_21','dospert1_28','dospert1_29','dospert1_39','dospert1_40')]
DOSPERT1_SummaryScores$dospert1_risktaking_ethical<-rowMeans(dospert1_eth)
dospert1_fin<-dospert_int[,c('dospert1_3','dospert1_5','dospert1_9','dospert1_15','dospert1_18','dospert1_19','dospert1_23','dospert1_26')]
DOSPERT1_SummaryScores$dospert1_risktaking_financial<-rowMeans(dospert1_fin)
dospert1_fin_inv<-dospert_int[,c('dospert1_5','dospert1_15','dospert1_19','dospert1_23')]
DOSPERT1_SummaryScores$dospert1_risktaking_fin_invest<-rowMeans(dospert1_fin_inv)
dospert1_fin_gam<-dospert_int[,c('dospert1_3','dospert1_9','dospert1_18','dospert1_26')]
DOSPERT1_SummaryScores$dospert1_risktaking_fin_gambling<-rowMeans(dospert1_fin_gam)
dospert1_heal<-dospert_int[,c('dospert1_6','dospert1_20','dospert1_22','dospert1_25','dospert1_31','dospert1_34','dospert1_35','dospert1_36')]
DOSPERT1_SummaryScores$dospert1_risktaking_healthsafety<-rowMeans(dospert1_heal)
dospert1_rec<-dospert_int[,c('dospert1_2','dospert1_4','dospert1_12','dospert1_14','dospert1_17','dospert1_24','dospert1_32','dospert1_33')]
DOSPERT1_SummaryScores$dospert1_risktaking_recreational<-rowMeans(dospert1_rec)
dospert1_soc<-dospert_int[,c('dospert1_1','dospert1_8','dospert1_13','dospert1_16','dospert1_27','dospert1_30','dospert1_37','dospert1_38')]
DOSPERT1_SummaryScores$dospert1_risktaking_social<-rowMeans(dospert1_soc)
DOSPERT1_SummaryScores$dospert1_risktaking_avg<-rowMeans(dospert1)
DOSPERT1_SummaryScores$dospert1_naflag<-dospert1[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(DOSPERT1_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/DOSPERT1_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### DOSPERT2 ###
measure="dospert2"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"dospert2summary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="dospert2summary"
giant$dovisit<-partid3 #assigns date to dovisit column
DOSPERT2_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
dospert2<-giant[,c(grep('dospert[0-9]_[0-9]', colnames(giant)))]
dospert2$NAflag<-ifelse(complete.cases(dospert2),0,1) #flags subjects that have NAs and have estimated or missing totals
dospert_int<-t(apply(dospert2[,c(1:40)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
dospert2_eth<-dospert_int[,c('dospert2_7','dospert2_10','dospert2_11','dospert2_21','dospert2_28','dospert2_29','dospert2_39','dospert2_40')]
DOSPERT2_SummaryScores$dospert2_riskpercept_ethical<-rowMeans(dospert2_eth)
dospert2_fin<-dospert_int[,c('dospert2_3','dospert2_5','dospert2_9','dospert2_15','dospert2_18','dospert2_19','dospert2_23','dospert2_26')]
DOSPERT2_SummaryScores$dospert2_riskpercept_financial<-rowMeans(dospert2_fin)
dospert2_fin_inv<-dospert_int[,c('dospert2_5','dospert2_15','dospert2_19','dospert2_23')]
DOSPERT2_SummaryScores$dospert2_riskpercept_fin_invest<-rowMeans(dospert2_fin_inv)
dospert2_fin_gam<-dospert_int[,c('dospert2_3','dospert2_9','dospert2_18','dospert2_26')]
DOSPERT2_SummaryScores$dospert2_riskpercept_fin_gambling<-rowMeans(dospert2_fin_gam)
dospert2_heal<-dospert_int[,c('dospert2_6','dospert2_20','dospert2_22','dospert2_25','dospert2_31','dospert2_34','dospert2_35','dospert2_36')]
DOSPERT2_SummaryScores$dospert2_riskpercept_healthsafety<-rowMeans(dospert2_heal)
dospert2_rec<-dospert_int[,c('dospert2_2','dospert2_4','dospert2_12','dospert2_14','dospert2_17','dospert2_24','dospert2_32','dospert2_33')]
DOSPERT2_SummaryScores$dospert2_riskpercept_recreational<-rowMeans(dospert2_rec)
dospert2_soc<-dospert_int[,c('dospert2_1','dospert2_8','dospert2_13','dospert2_16','dospert2_27','dospert2_30','dospert2_37','dospert2_38')]
DOSPERT2_SummaryScores$dospert2_riskpercept_social<-rowMeans(dospert2_soc)
DOSPERT2_SummaryScores$dospert2_riskpercept_avg<-rowMeans(dospert2)
DOSPERT2_SummaryScores$dospert2_naflag<-dospert2[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(DOSPERT2_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/DOSPERT2_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### FET ###
measure="fet"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"fetsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="fetsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
FET_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
fetscores<-giant[,c(grep('fet_[0-9]', colnames(giant)))]
fetscores_summary<-fetscores
fetscores_summary$NAflag<-ifelse(complete.cases(fetscores_summary),0,1) #flags subjects that have NAs and have estimated or missing totals
fetscores_summary$fet1_summary <- ifelse((fetscores_summary$fet_1 == 1 & fetscores_summary$fet_1a== 5),1,0)
fetscores_summary$fet2_summary <- ifelse((fetscores_summary$fet_2 == 2 & fetscores_summary$fet_2a== 5),1,0)
fetscores_summary$fet3_summary <- ifelse((fetscores_summary$fet_3 == 2 & fetscores_summary$fet_3a== 5),1,0)
fetscores_summary$fet4_summary <- ifelse((fetscores_summary$fet_4 == 1 & fetscores_summary$fet_4a== 5),1,0)
fetscores_summary$fet5_summary <- ifelse((fetscores_summary$fet_5 == 1 & fetscores_summary$fet_5a== 5),1,0)
fetscores_summary$fet6_summary <- ifelse((fetscores_summary$fet_6 == 1 & fetscores_summary$fet_6a== 5),1,0)
fetscores_summary$fet7_summary <- ifelse((fetscores_summary$fet_7 == 2 & fetscores_summary$fet_7a== 5),1,0)
fetscores_summary$fet8_summary <- ifelse((fetscores_summary$fet_8 == 2 & fetscores_summary$fet_8a== 5),1,0)
fetscores_summary$fet9_summary <- ifelse((fetscores_summary$fet_9 == 1 & fetscores_summary$fet_9a== 5),1,0)
fetscores_summary$fet10_summary <- ifelse((fetscores_summary$fet_10 == 2 & fetscores_summary$fet_10a== 5),1,0)
fetscores_summary$fet11_summary <- ifelse((fetscores_summary$fet_11 == 1 & fetscores_summary$fet_11a== 5),1,0)
fetscores_summary$fet12_summary <- ifelse((fetscores_summary$fet_12 == 1 & fetscores_summary$fet_12a== 5),1,0)
fetscores_summary$fet13_summary <- ifelse((fetscores_summary$fet_13 == 1 & fetscores_summary$fet_13a== 5),1,0)
fetscores_summary$fet14_summary <- ifelse((fetscores_summary$fet_14 == 1 & fetscores_summary$fet_14a== 5),1,0)
fetscores_summary$fet15_summary <- ifelse((fetscores_summary$fet_15 == 2 & fetscores_summary$fet_15a== 5),1,0)
fetscores_summary$fet16_summary <- ifelse((fetscores_summary$fet_16 == 2 & fetscores_summary$fet_16a== 5),1,0)
fetscores_summary$fet17_summary <- ifelse((fetscores_summary$fet_17 == 2 & fetscores_summary$fet_17a== 5),1,0)
fetscores_summary$fet18_summary <- ifelse((fetscores_summary$fet_18 == 2 & fetscores_summary$fet_18a== 5),1,0)
fetscores_summary$fet19_summary <- ifelse((fetscores_summary$fet_19 == 1 & fetscores_summary$fet_19a== 5),1,0)
fetscores_summary$fet20_summary <- ifelse((fetscores_summary$fet_20 == 2 & fetscores_summary$fet_20a== 5),1,0)
fetscores_summary$fet21_summary <- ifelse((fetscores_summary$fet_21 == 2 & fetscores_summary$fet_21a== 5),1,0)
fetscores_summary$fet22_summary <- ifelse((fetscores_summary$fet_22 == 1 & fetscores_summary$fet_22a== 5),1,0)
fetscores_summary$fet23_summary <- ifelse((fetscores_summary$fet_23 == 1 & fetscores_summary$fet_23a== 5),1,0)
fetscores_summary$fet24_summary <- ifelse((fetscores_summary$fet_24 == 2 & fetscores_summary$fet_24a== 5),1,0)
fetscores_summary$fet25_summary <- ifelse((fetscores_summary$fet_25 == 1 & fetscores_summary$fet_25a== 5),1,0)
fetscores_summary$fet26_summary <- ifelse((fetscores_summary$fet_26 == 1 & fetscores_summary$fet_26a== 5),1,0)
fetscores_summary$fet27_summary <- ifelse((fetscores_summary$fet_27 == 2 & fetscores_summary$fet_27a== 5),1,0)
fetscores_summary$fet28_summary <- ifelse((fetscores_summary$fet_28 == 1 & fetscores_summary$fet_28a== 5),1,0)
fetscores_summary$fet29_summary <- ifelse((fetscores_summary$fet_29 == 2 & fetscores_summary$fet_29a== 5),1,0)
fetscores_summary$fet30_summary <- ifelse((fetscores_summary$fet_30 == 1 & fetscores_summary$fet_30a== 5),1,0)
fetscores_summary$fet31_summary <- ifelse((fetscores_summary$fet_31 == 2 & fetscores_summary$fet_31a== 5),1,0)
fetscores_summary$fet32_summary <- ifelse((fetscores_summary$fet_32 == 1 & fetscores_summary$fet_32a== 5),1,0)
fetscores_summary$fet33_summary <- ifelse((fetscores_summary$fet_33 == 2 & fetscores_summary$fet_33a== 5),1,0)
fetscores_summary$fet34_summary <- ifelse((fetscores_summary$fet_34 == 2 & fetscores_summary$fet_34a== 5),1,0)
FET_SummaryScores$fet_negative<-(fetscores_summary$fet1_summary+fetscores_summary$fet4_summary+fetscores_summary$fet5_summary+fetscores_summary$fet6_summary+fetscores_summary$fet9_summary+fetscores_summary$fet11_summary+fetscores_summary$fet12_summary+fetscores_summary$fet13_summary+fetscores_summary$fet14_summary+fetscores_summary$fet19_summary+fetscores_summary$fet22_summary+fetscores_summary$fet23_summary+fetscores_summary$fet25_summary+fetscores_summary$fet26_summary+fetscores_summary$fet28_summary+fetscores_summary$fet30_summary+fetscores_summary$fet32_summary)
FET_SummaryScores$fet_certainnotpositive<-(fetscores_summary$fet2_summary+fetscores_summary$fet3_summary+fetscores_summary$fet7_summary+fetscores_summary$fet8_summary+fetscores_summary$fet10_summary+fetscores_summary$fet15_summary+fetscores_summary$fet16_summary+fetscores_summary$fet17_summary+fetscores_summary$fet18_summary+fetscores_summary$fet20_summary+fetscores_summary$fet21_summary+fetscores_summary$fet24_summary+fetscores_summary$fet27_summary+fetscores_summary$fet29_summary+fetscores_summary$fet31_summary+fetscores_summary$fet33_summary+fetscores_summary$fet34_summary)
FET_SummaryScores$fet_negativetotal<-(fetscores_summary$fet1_summary+fetscores_summary$fet4_summary+fetscores_summary$fet5_summary+fetscores_summary$fet6_summary+fetscores_summary$fet9_summary+fetscores_summary$fet11_summary+fetscores_summary$fet12_summary+fetscores_summary$fet13_summary+fetscores_summary$fet14_summary+fetscores_summary$fet19_summary+fetscores_summary$fet22_summary+fetscores_summary$fet23_summary+fetscores_summary$fet25_summary+fetscores_summary$fet26_summary+fetscores_summary$fet28_summary+fetscores_summary$fet30_summary+fetscores_summary$fet32_summary+fetscores_summary$fet2_summary+fetscores_summary$fet3_summary+fetscores_summary$fet7_summary+fetscores_summary$fet8_summary+fetscores_summary$fet10_summary+fetscores_summary$fet15_summary+fetscores_summary$fet16_summary+fetscores_summary$fet17_summary+fetscores_summary$fet18_summary+fetscores_summary$fet20_summary+fetscores_summary$fet21_summary+fetscores_summary$fet24_summary+fetscores_summary$fet27_summary+fetscores_summary$fet29_summary+fetscores_summary$fet31_summary+fetscores_summary$fet33_summary+fetscores_summary$fet34_summary)
FET_SummaryScores$fet_naflag<-fetscores_summary[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(FET_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/FET_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### BSS ###
measure="bss"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant[giant == -99999] <-NA #remove five digits as well
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"bsssummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="bsssummary"
giant$dovisit<-partid3 #assigns date to dovisit column
BSS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
bss<-giant[,c(grep('bss[0-9]', colnames(giant)))]
bss$NAflag<-ifelse(complete.cases(bss),0,1) #flags subjects that have NAs and have estimated or missing totals
bss_int<-t(apply(bss[,c(1:8)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
BSS_SummaryScores$bss_mean<-rowMeans(bss_int)
bss_exp<-bss_int[,c('bss1','bss5')]
bss_experience<-rowMeans(bss_exp)
BSS_SummaryScores$bss_experience<-bss_experience
bss_bore<-bss_int[,c('bss2','bss6')]
bss_boredom<-rowMeans(bss_bore)
BSS_SummaryScores$bss_boredom<-bss_boredom
bss_thrl<-bss_int[,c('bss3','bss7')]
bss_thrill<-rowMeans(bss_thrl)
BSS_SummaryScores$bss_thrill<-bss_thrill
bss_disinhib<-bss_int[,c('bss4','bss8')]
bss_disinhibition<-rowMeans(bss_disinhib)
BSS_SummaryScores$bss_disinhibition<-bss_disinhibition
BSS_SummaryScores$bss_naflag<-bss[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(BSS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/BSS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### DAI-SRA ###
measure="dai"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"daisummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="daisummary"
giant$dovisit<-partid3 #assigns date to dovisit column
DAI_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
dai<-giant[,c(grep('dai[0-9]', colnames(giant)))]
dai$NAflag<-ifelse(complete.cases(dai),0,1) #flags subjects that have NAs and have estimated or missing totals
dai_int<-t(apply(dai[,c(1:33)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
DAI_SummaryScores$daisra_avg<-rowMeans(dai_int)
dai_mean<-dai_int[,c('dai1','dai2','dai3','dai4','dai5','dai6','dai7','dai8','dai9','dai10')]
DAI_SummaryScores$dai_avg<-rowMeans(dai_mean)
sra_mean<-dai_int[,c('dai11','dai12','dai13','dai14','dai15','dai16','dai17','dai18','dai19','dai20','dai21','dai22','dai23','dai24','dai25','dai26','dai27','dai28','dai29','dai30','dai31','dai32','dai33')]
DAI_SummaryScores$sra_avg<-rowMeans(sra_mean)
DAI_SummaryScores$daisra_naflag<-dai[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(DAI_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/DAI_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### MDQ ###
measure="mdq"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"mdqsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="mdqsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
MDQ_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
mdq<-giant[,c(grep('mdq[0-9]', colnames(giant)))]
mdq$NAflag<-ifelse(complete.cases(mdq),0,1) #flags subjects that have NAs and have estimated or missing totals
mdq_int<-t(apply(mdq[,c(1:17)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
MDQ_SummaryScores$mdq_total<-rowSums(mdq_int)
mdq_crit1_sum<-rowSums(mdq[,c('mdq1_a','mdq1_b','mdq1_c','mdq1_d','mdq1_e','mdq1_f','mdq1_g','mdq1_h','mdq1_i','mdq1_j','mdq1_k','mdq1_l','mdq1_m')])
mdq_crit2 <- (mdq[,c('mdq2')])
mdq_crit3 <- (mdq[,c('mdq3')])
crit1 <- ifelse((mdq_crit1_sum > 6),1,0)
crit2 <- ifelse((mdq_crit2 == 1),1,0)
crit3 <- ifelse((mdq_crit3 > 1),1,0)
#uncomment these three lines, if each criteria needs to be seen
#SummaryScores$mdq_criteria1<-mdq$crit1  
#SummaryScores$mdq_criteria2<-mdq$crit2
#SummaryScores$mdq_criteria3<-mdq$crit3
mdq$crit_all <- ifelse((crit1 == 1) & (crit2 == 1) & (crit3 ==1),1,0)
MDQ_SummaryScores$mdq_allcrit<-mdq$crit_all
MDQ_SummaryScores$mdq_naflag<-mdq[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(MDQ_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/MDQ_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### BISBAS ###
measure="bisbas"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"bisbassummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="bisbassummary"
giant$dovisit<-partid3 #assigns date to dovisit column
BISBAS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
bisbas<-giant[,c(grep('bisbas_[0-9]', colnames(giant)))]
bis1<-bisbas[,c('bisbas_8','bisbas_13','bisbas_16','bisbas_19','bisbas_24')]
bis2<-bisbas[,c('bisbas_2','bisbas_22')]
bis1<-(4-bis1)+1 #reverse code scores in bis1 (not bis2) so that 4=1, 3=2, 2=3, 1=4
bis3<-cbind(bis1,bis2)
BISBAS_SummaryScores$bistotal<-rowSums(bis3) #sum scores after reverse coding
bas_drive<-bisbas[,c('bisbas_3','bisbas_9','bisbas_12','bisbas_21')]
bas_drive<-(4-bas_drive)+1 #reverse code scores in bas_drive
BISBAS_SummaryScores$basdrive_total<-rowSums(bas_drive) 
bas_fun<-bisbas[,c('bisbas_5','bisbas_10','bisbas_15','bisbas_20')]
bas_fun<-(4-bas_fun)+1 #reverse code scores in bas_fun
bas_fun_sum<-(bas_fun)
BISBAS_SummaryScores$basfun_total<-rowSums(bas_fun_sum)
bas_reward<-bisbas[,c('bisbas_4','bisbas_7','bisbas_14','bisbas_18','bisbas_23')]
bas_reward<-(4-bas_reward)+1 #reverse code scores in bas_reward
BISBAS_SummaryScores$basreward_total<-rowSums(bas_reward)
currentDate<-Sys.Date()
write.csv(BISBAS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/BISBAS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### WOLF POST SCAN ###
measure="post"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"wolfpostsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="wolfpostsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
WOLFPOST_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
wolf_post<-giant[,c(grep('post[0-9]', colnames(giant)))]
wolf_post$NAflag<-ifelse(complete.cases(wolf_post),0,1) #flags subjects that have NAs and have estimated or missing totals
wolf_post_int<-t(apply(wolf_post[,c(1:10)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
wolf_post_total<-wolf_post_int[,c('post1','post2','post3','post5','post6','post7','post9','post10')]
WOLFPOST_SummaryScores$wolf_post_total<-rowSums(wolf_post_total)
wolf_post_card<-wolf_post_int[,c('post1','post2','post3')]
WOLFPOST_SummaryScores$wolf_post_card<-rowSums(wolf_post_card)
wolf_post_face<-wolf_post_int[,c('post5','post6','post7')]
WOLFPOST_SummaryScores$wolf_post_face<-rowSums(wolf_post_face)
wolf_post_likeable<-wolf_post_int[,c('post9','post10')]
WOLFPOST_SummaryScores$wolf_post_likeable<-rowSums(wolf_post_likeable)
wolf_post_interest<-wolf_post_int[,c('post1','post5')]
WOLFPOST_SummaryScores$wolf_post_interest<-rowSums(wolf_post_interest)
wolf_post_effort<-wolf_post_int[,c('post2','post6')]
WOLFPOST_SummaryScores$wolf_post_effort<-rowSums(wolf_post_effort)
wolf_post_pleasure<-wolf_post_int[,c('post3','post7')]
WOLFPOST_SummaryScores$wolf_post_pleasure<-rowSums(wolf_post_pleasure)
wolf_post_cardface<-wolf_post_int[,c('post1','post2','post3','post5','post6','post7')]
WOLFPOST_SummaryScores$wolf_post_cardface<-rowSums(wolf_post_cardface)
WOLFPOST_SummaryScores$cardminface<-(WOLFPOST_SummaryScores$wolf_post_card)-(WOLFPOST_SummaryScores$wolf_post_face)
WOLFPOST_SummaryScores$wolfpost_naflag<-wolf_post[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(WOLFPOST_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/WOLFPOST_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### TEPS ###
measure="teps"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"tepssummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="tepssummary"
giant$dovisit<-partid3 #assigns date to dovisit column
TEPS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
teps<-giant[,c(grep('teps[0-9]', colnames(giant)))]
teps_antica<-teps[,c('teps1','teps4','teps6','teps8','teps10','teps11','teps15','teps16','teps18')]
teps_antica$antica_NAflag<-ifelse(complete.cases(teps_antica),0,1) #flags subjects that have NAs and have estimated or missing totals
teps_int<-t(apply(teps_antica[,c(1:9)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
teps13<-giant[,c('teps13')]
teps13<-(6-teps13)+1 #reverse code teps item13
teps2<-cbind(teps_int,teps13)
TEPS_SummaryScores$teps_antica<-rowMeans(teps2)
TEPS_SummaryScores$teps_antica_naflag<-teps_antica[,c('antica_NAflag')]
teps_consummatory<-giant[,c('teps2','teps3','teps5','teps7','teps9','teps12','teps14','teps17')]
teps_consummatory$consummatory_NAflag<-ifelse(complete.cases(teps_consummatory),0,1) #flags subjects that have NAs and have estimated or missing totals
teps_consummatory2<-t(apply(teps_consummatory[,c(1:8)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
TEPS_SummaryScores$teps_consummatory<-rowMeans(teps_consummatory2)
TEPS_SummaryScores$teps_consummatory_naflag<-teps_consummatory[,c('consummatory_NAflag')]
currentDate<-Sys.Date()
write.csv(TEPS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/TEPS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### BISS ###
measure="biss"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"bisssummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="bisssummary"
giant$dovisit<-partid3 #assigns date to dovisit column
BISS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
biss<-giant[,c(grep('biss_[0-9]', names(giant), value=T))]
biss$NAflag<-ifelse(complete.cases(biss),0,1) #flags subjects that have NAs and have estimated or missing totals
BISS_SummaryScores$biss_depstate<-rowSums(biss[,1:22])
BISS_SummaryScores$biss_manstate<-rowSums(biss[,23:44])
BISS_SummaryScores$biss_naflag<-biss[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(BISS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/BISS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### SANS ###
measure="sans"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"sanssummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="sanssummary"
giant$dovisit<-partid3 #assigns date to dovisit column
SANS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
sans<-giant[,c(grep('sans[0-9]', names(giant)))]
sans$NAflag<-ifelse(complete.cases(sans),0,1) #flags subjects that have NAs and have estimated or missing totals
sans_int<-t(apply(sans[,c(1:25)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
SANS_SummaryScores$sans_global_affect<-sans_int[,c(grep('sans8', names(sans)))]
SANS_SummaryScores$sans_global_alogia<-sans_int[,c(grep('sans13', names(sans)))]
SANS_SummaryScores$sans_global_avolition<-sans_int[,c(grep('sans17', names(sans)))]
SANS_SummaryScores$sans_global_asociality<-sans_int[,c(grep('sans22', names(sans)))]
SANS_SummaryScores$sans_global_attention<-sans_int[,c(grep('sans25', names(sans)))]
sans_scores<-sans_int[,c('sans8','sans13','sans17','sans22')]
SANS_SummaryScores$sans_global<-rowSums(sans_scores)
SANS_SummaryScores$sans_naflag<-sans[,c('NAflag')]
SANS_SummaryScores$sans_globalavg<-rowMeans(sans_scores)
currentDate<-Sys.Date()
write.csv(SANS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/SANS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### SAPS ###
measure="saps"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"sapssummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="sapssummary"
giant$dovisit<-partid3 #assigns date to dovisit column
SAPS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
saps<-giant[,c(grep('saps[0-9]', colnames(giant)))]
saps$NAflag<-ifelse(complete.cases(saps),0,1) #flags subjects that have NAs and have estimated or missing totals
saps_int<-t(apply(saps[,c(1:34)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
SAPS_SummaryScores$saps_global_hallucin<-saps_int[,c(grep('saps7', names(saps)))]
SAPS_SummaryScores$saps_global_del<-saps_int[,c(grep('saps20', names(saps)))]
SAPS_SummaryScores$saps_global_bizarre<-saps_int[,c(grep('saps25', names(saps)))]
SAPS_SummaryScores$saps_global_thought<-saps_int[,c(grep('saps34', names(saps)))]
saps_scores<-saps_int[,c('saps7','saps20','saps25','saps34')]
SAPS_SummaryScores$saps_global<-rowSums(saps_scores)
SAPS_SummaryScores$saps_naflag<-saps[,c('NAflag')]
SAPS_SummaryScores$saps_globalavg<-rowMeans(saps_scores)
currentDate<-Sys.Date()
write.csv(SAPS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/SAPS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### BPRSV3 ###
measure="bprsv3"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"bprsv3summary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="bprsv3summary"
giant$dovisit<-partid3 #assigns date to dovisit column
BPRSV3_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
bprsv3<-giant[,c(grep('bprs[0-9]', colnames(giant)))]
bprsv3$NAflag<-ifelse(complete.cases(bprsv3),0,1) #flags subjects that have NAs and have estimated or missing totals
bprsv3_int<-t(apply(bprsv3[,c(1:18)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
BPRSV3_SummaryScores$bprsv3_total<-rowSums(bprsv3_int)
BPRSV3_SummaryScores$bprsv3_naflag<-bprsv3[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(BPRSV3_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/BPRSV3_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### BPRSV4 ###
measure="bprsv4"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"bprsv4summary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="bprsv4summary"
giant$dovisit<-partid3 #assigns date to dovisit column
BPRSV4_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
bprsv4<-giant[,c(grep('bprsv4_[0-9]', colnames(giant)))]
bprsv3equiv<-giant[,c('bprsv4_1','bprsv4_2','bprsv4_17','bprsv4_15','bprsv4_5',
                      'bprsv4_19','bprsv4_24','bprsv4_8','bprsv4_3','bprsv4_6','bprsv4_9',
                      'bprsv4_10','bprsv4_18','bprsv4_20','bprsv4_11','bprsv4_16','bprsv4_21',
                      'bprsv4_14')]
bprsv4$NAflag<-ifelse(complete.cases(bprsv4),0,1) #flags subjects that have NAs and have estimated or missing totals
bprsv4_int<-t(apply(bprsv4[,c(1:24)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
bprsv3equiv_int<-t(apply(bprsv3equiv, 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
BPRSV4_SummaryScores$bprsv4_total<-rowSums(bprsv4_int)
BPRSV4_SummaryScores$bprsv3equiv_total<-rowSums(bprsv3equiv_int)
BPRSV4_SummaryScores$bprsv4_naflag<-bprsv4[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(BPRSV4_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/BPRSV4_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### BPRSV3 AND BPRSV3 EQUIVALENT COMBINED ###

bprsv3equiv_comb<-BPRSV4_SummaryScores[,c('participant_id','bblid','procedure','dovisit','bprsv3equiv_total')]
bprsv3_comb<-BPRSV3_SummaryScores[,c('participant_id','bblid','procedure','dovisit','bprsv3_total')]
bprsv3comb<-merge(bprsv3equiv_comb,bprsv3_comb, by.x = "participant_id", by.y="participant_id", all.x= T, all.y=T)
bprsv3comb$bblid<-ifelse(is.na(bprsv3comb[,c("bblid.x")]), bprsv3comb[,c("bblid.y")], bprsv3comb[,c("bblid.x")]) #if brpsv3comb$bblid.x is na, then use brpsv3comb$bblid.y, else use brpsv3comb$bblid.x
bprsv3comb$procedure<-ifelse(is.na(bprsv3comb[,c("procedure.x")]), bprsv3comb[,c("procedure.y")], bprsv3comb[,c("procedure.x")]) #do same as above for procedure
bprsv3comb$dovisit<-ifelse(is.na(bprsv3comb[,c("dovisit.x")]), bprsv3comb[,c("dovisit.y")], bprsv3comb[,c("dovisit.x")]) #do the same as above for dovisit
bprsv3comb$bprsv3comb_total<-ifelse(is.na(bprsv3comb[,c("bprsv3equiv_total")]), bprsv3comb[,c("bprsv3_total")], bprsv3comb[,c("bprsv3equiv_total")]) #do same as above for totals
bprsv3comb<-bprsv3comb[order(bprsv3comb$bblid),]

bprsv3comb$bprsv3comb_source[bprsv3comb$procedure == "bprsv3summary"] <- "bprsv3" #replace procedure with more descriptive verbiage of source of score
bprsv3comb$bprsv3comb_source[bprsv3comb$procedure == "bprsv4summary"] <- "bprsv3_equivalent" #replace procedure with more descriptive verbiage of source of score
bprsv3comb$procedure<-"bprsv3combsummary"
partid<-bprsv3comb$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
bprsv3comb$participant_id=paste(partid1,"bprsv3combsummary",partid3, sep="_") #combine into new string for summaryscores
bprsv3comb_SummaryScores<-bprsv3comb[,c('participant_id','bblid','procedure','dovisit','bprsv3comb_total','bprsv3comb_source')] #pull combined columns and add to new data frame

temp<-bprsv3comb_SummaryScores[which(is.na(bprsv3comb_SummaryScores$bprsv3comb_total)),] # to catch duplicates with NAs in each record
bprsv3comb_SummaryScores<-bprsv3comb_SummaryScores[which(!is.na(bprsv3comb_SummaryScores$bprsv3comb_total)),] # to catch duplicates with one value and at least one NA in record
temp_unique<-temp[temp$participant_id %in% setdiff(temp$participant_id,bprsv3comb_SummaryScores$participant_id),] # get ones that are unique in temp that are not in bprsv3comb_SummaryScores
temp_unique<-temp[which(temp$bprsv3comb_source == "bprsv3_equivalent"),] #choose only records with source of bprsv3_equivalent

bprsv3comb_SummaryScores2<-rbind(bprsv3comb_SummaryScores,temp_unique) #bind the two together
bprsv3comb_SummaryScores2<-bprsv3comb_SummaryScores2[order(bprsv3comb_SummaryScores2$bblid),] #order them by bblid
bprsv3comb_SummaryScores2<-bprsv3comb_SummaryScores2[which(!duplicated(bprsv3comb_SummaryScores2$participant_id)),] #remove duplicates across participant_ids
currentDate<-Sys.Date()
write.csv(bprsv3comb_SummaryScores2, paste('/import/monstrum/Users/adaldal/SummaryScores/BPRSV3COMB_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### LOT-R ###
measure="lotr"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"lotrsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="lotrsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
LOTR_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
lotr<-giant[,c(grep('lotr[0-9]', colnames(giant)))]
lotr$NAflag<-ifelse(complete.cases(lotr),0,1) #flags subjects that have NAs and have estimated or missing totals
lotr2<-lotr
#reverse score lotr3
lotr2$lotr3[lotr$lotr3==0] <-4
lotr2$lotr3[lotr$lotr3==1] <-3
lotr2$lotr3[lotr$lotr3==2] <-2
lotr2$lotr3[lotr$lotr3==3] <-1
lotr2$lotr3[lotr$lotr3==4] <-0
#reverse score lotr7
lotr2$lotr7[lotr$lotr7==0] <-4
lotr2$lotr7[lotr$lotr7==1] <-3
lotr2$lotr7[lotr$lotr7==2] <-2
lotr2$lotr7[lotr$lotr7==3] <-1
lotr2$lotr7[lotr$lotr7==4] <-0
#reverse score lotr9
lotr2$lotr9[lotr$lotr9==0] <-4
lotr2$lotr9[lotr$lotr9==1] <-3
lotr2$lotr9[lotr$lotr9==2] <-2
lotr2$lotr9[lotr$lotr9==3] <-1
lotr2$lotr9[lotr$lotr9==4] <-0
lotr3<-lotr2[,c(1,3,4,7,9,10)]
LOTR_SummaryScores$lotr_total<-rowSums(lotr3)
LOTR_SummaryScores$lotr_naflag<-lotr[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(LOTR_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/LOTR_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### ASRM ###
measure="asrm"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"asrmsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="asrmsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
ASRM_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
asrm<-giant[,c(grep('asrm[0-9]', colnames(giant)))]
asrm$NAflag<-ifelse(complete.cases(asrm),0,1) #flags subjects that have NAs and have estimated or missing totals
asrm_int<-t(apply(asrm[,c(1:5)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
ASRM_SummaryScores$asrm_total<-rowSums(asrm_int)
ASRM_SummaryScores$asrm_naflag<-asrm[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(ASRM_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/ASRM_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### SWLS ###
measure="swls"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"swlssummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="swlssummary"
giant$dovisit<-partid3 #assigns date to dovisit column
SWLS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
swls<-giant[,c(grep('swls[0-9]', colnames(giant)))]
swls$NAflag<-ifelse(complete.cases(swls),0,1) #flags subjects that have NAs and have estimated or missing totals
swls_int<-t(apply(swls[,c(1:18)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
SWLS_SummaryScores$swls_total<-rowSums(swls_int)
SWLS_SummaryScores$swls_naflag<-swls[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(SWLS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/SWLS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### PANAS-C ###
measure="panasc"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"panascsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="panascsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
PANASC_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
panasc<-giant[,c(grep('panas_[0-9]', colnames(giant)))]
panascpa<-panasc[,c('panas_1','panas_5','panas_8','panas_9','panas_12','panas_14','panas_17','panas_18','panas_19','panas_21','panas_26','panas_30')]
panascpa$panascpa_NAflag<-ifelse(complete.cases(panascpa),0,1) #flags subjects that have NAs and have estimated or missing totals
panascpa<-t(apply(panascpa, 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
panascna<-panasc[,c('panas_2','panas_3','panas_6','panas_7','panas_10','panas_11','panas_13','panas_15','panas_16','panas_20','panas_22','panas_23','panas_25','panas_27','panas_29')]
panascna$panascna_NAflag<-ifelse(complete.cases(panascna),0,1) #flags subjects that have NAs and have estimated or missing totals
panascna<-t(apply(panascna, 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
PANASC_SummaryScores$panascpa_total<-rowSums(panascpa)
PANASC_SummaryScores$panascpa_naflag<-panascpa[,c('panascpa_NAflag')]
PANASC_SummaryScores$panascna_total<-rowSums(panascna)
PANASC_SummaryScores$panascna_naflag<-panascna[,c('panascna_NAflag')]
currentDate<-Sys.Date()
write.csv(PANASC_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/PANASC_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### ARI ###
measure="ari"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"arisummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="arisummary"
giant$dovisit<-partid3 #assigns date to dovisit column
ARI_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
ari<-giant[,c(grep('ari[0-9]', colnames(giant)))]
ari_int<-ari[,c('ari1','ari2','ari3','ari4','ari5','ari6')]
ari_int$NAflag<-ifelse(complete.cases(ari_int),0,1) #flags subjects that have NAs and have estimated or missing totals
ari_int2<-t(apply(ari_int[,c(1:6)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
ARI_SummaryScores$ari_total<-rowSums(ari_int2)
ARI_SummaryScores$ari_naflag<-ari_int[,c('NAflag')]
ARI_SummaryScores$ari_avg<-rowMeans(ari_int2)
currentDate<-Sys.Date()
write.csv(ARI_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/ARI_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

## QLS FULL ##
measure="qls"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"qlsfullsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="qlsfullsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
QLS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
qls_full<-giant[,c(grep('qls[0-9]', colnames(giant)))]
qls_full$NAflag<-ifelse(complete.cases(qls_full),0,1) #flags subjects that have NAs and have estimated or missing totals
qls_full_int<-t(apply(qls_full[,c(1:21)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
QLS_SummaryScores$qlsfull_total<-rowSums(qls_full_int)
QLS_SummaryScores$qlsfull_naflag<-qls_full[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(QLS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/QLS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

## QLS SHORT ##
measure="qolabb"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"qlsshortsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="qlsshortsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
QOLABB_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
qolabb<-giant[,c(grep('qol_abb_[0-9]', colnames(giant)))]
qolabb$NAflag<-ifelse(complete.cases(qolabb),0,1) #flags subjects that have NAs and have estimated or missing totals
qolabb_int<-t(apply(qolabb[,c(1:7)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
QOLABB_SummaryScores$qlsshort_total<-rowSums(qolabb_int)
QOLABB_SummaryScores$qlsshort_naflag<-qolabb[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(QOLABB_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/QOLABB_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

## PAS ##
measure="pas"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"passummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="passummary"
giant$dovisit<-partid3 #assigns date to dovisit column
PAS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
pas_childhood<-giant[,c(grep('pas_c[0-9]', colnames(giant)))]
pas_earlyadol<-giant[,c(grep('pas_ea[0-9]', colnames(giant)))]
pas_childhood_int<-t(apply(pas_childhood, 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
pas_earlyadol_int<-t(apply(pas_earlyadol, 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))

PAS_SummaryScores$pas_childavg<-rowMeans(pas_childhood_int)
PAS_SummaryScores$pas_earlya_avg<-rowMeans(pas_earlyadol_int)
PAS_SummaryScores$pas_premorb_score<-((PAS_SummaryScores$pas_childavg+PAS_SummaryScores$pas_earlya_avg)/2)

PAS_SummaryScores$child_naflag<-ifelse(complete.cases(pas_childhood),0,1) #flags subjects that have NAs and have estimated or missing totals
PAS_SummaryScores$earlyadol_naflag<-ifelse(complete.cases(pas_earlyadol),0,1) #flags subjects that have NAs and have estimated or missing totals

pas_lateadol<-giant[,c(grep('pas_la[0-9]', colnames(giant)))]
pas_lateadol_int<-t(apply(pas_lateadol, 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
PAS_SummaryScores$pas_latea_avg<-rowMeans(pas_lateadol_int)
PAS_SummaryScores$lateadol_naflag<-ifelse(complete.cases(pas_lateadol),0,1) #flags subjects that have NAs and have estimated or missing totals

pas_adult<-giant[,c(grep('pas_a[0-9]', colnames(giant)))]
pas_adult_int<-t(apply(pas_adult, 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
PAS_SummaryScores$pas_adult_avg<-rowMeans(pas_adult_int)
PAS_SummaryScores$adult_naflag<-ifelse(complete.cases(pas_adult),0,1) #flags subjects that have NAs and have estimated or missing totals

pas_general<-giant[,c(grep('pas_gen[0-9]', colnames(giant)))]
pas_general_int<-t(apply(pas_general, 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
PAS_SummaryScores$pas_general_avg<-rowMeans(pas_general_int)
PAS_SummaryScores$general_naflag<-ifelse(complete.cases(pas_general),0,1) #flags subjects that have NAs and have estimated or missing totals
currentDate<-Sys.Date()
write.csv(PAS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/PAS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### BDI (REDCAP-checkboxes) ###
measure="bdi"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"bdisummary",partid3, sep="_") #combine into new string for summaryscores
giant$dovisit<-partid3 #assigns date to dovisit column

bdi_response<-data.frame()
bdi.3<-c(grep('^bdi[0-9](.*)_3', names(giant)))
bblidindex<-1:nrow(giant)
for (i in bblidindex){
  for (j in bdi.3){
    if (!is.na(giant[i,j]) & (giant[i,j]==1)) {
      bdi_response[i,paste(unlist(strsplit(colnames(giant[j]), split="_"))[1],"response",sep="_")]<-3
    } else if (!is.na(giant[i,j-1]) & giant[i,j-1]==1) {
      bdi_response[i,paste(unlist(strsplit(colnames(giant[j]), split="_"))[1],"response",sep="_")]<-2
    } else if (!is.na(giant[i,j-2]) & giant[i,j-2]==1) {
      bdi_response[i,paste(unlist(strsplit(colnames(giant[j]), split="_"))[1],"response",sep="_")]<-1
    } else if  (!is.na(giant[i,j-3]) & giant[i,j-3]==1) {
      bdi_response[i,paste(unlist(strsplit(colnames(giant[j]), split="_"))[1],"response",sep="_")]<-0
    } else {
      bdi_response[i,paste(unlist(strsplit(colnames(giant[j]), split="_"))[1],"response",sep="_")]<-NA
    }
  }
}
bdi_response_int<-t(apply(bdi_response, 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
bdinew.sum<-rowSums(bdi_response_int)
BDI_SummaryScores<-giant[,c(1,2,3,4)]
BDI_SummaryScores$bdi_total<-bdinew.sum
BDI_SummaryScores$bdi_NAflag<-ifelse(complete.cases(bdi_response),0,1)
BDI_SummaryScores$bdiversion<-"bdinew(redcap)" #version that the bdi score comes from
#do not write out until it is combined with BDIold output as well

### BDIold ###
measure="bdiold"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"bdisummary",partid3, sep="_") #combine into new string for summaryscores
giant$dovisit<-partid3 #assigns date to dovisit column
BDIOLD_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
bdiold<-giant[,c(grep('bdi_old[0-9]', colnames(giant)))]
bdiold<-bdiold[, !colnames(bdiold) %in% c('bdi_old19a')] #remove question 19a from scoring

BDIOLD_SummaryScores$bdi_NAflag<-ifelse(complete.cases(bdiold),0,1)
bdiold_int<-t(apply(bdiold, 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
BDIOLD_SummaryScores$bdi_total<-rowSums(bdiold_int)
BDIOLD_SummaryScores$bdiversion<-"bdiold" #version that the bdi score comes from
BDIALL_SummaryScores<-rbind(BDI_SummaryScores,BDIOLD_SummaryScores) #combine bdi redcap output with bdi old (paper version) output
BDIALL_SummaryScores$procedure="bdisummary"

nodupbdi<-as.data.frame(matrix(nrow=0,ncol=7))   #make empty df  #the loop below is removing duplicates from combined bdiold and bdinew (if same, keeping bdiold)
colnames(nodupbdi)<-colnames(BDIALL_SummaryScores) #name columns
for (id in BDIALL_SummaryScores$participant_id){
  if(! id %in% nodupbdi$participant_id){ #check if not in nodupbdi
    temp<-BDIALL_SummaryScores[which(BDIALL_SummaryScores$participant_id==id),] #temp gets all
    if(nrow(temp[which(! is.na(temp$bdi_total)),])==1){
      temp<-temp[which(! is.na(temp$bdi_total)),] #if only one has total, use that
    } else if(nrow(temp[which(! is.na(temp$bdi_total)),])==2){
      temp<-temp[which(temp$bdiversion=="bdiold"),] #if 2 not na, use bdi old
    } else if(nrow(temp[which(is.na(temp$bdi_total)),])==2){
      temp<-temp[which(temp$bdiversion=="bdiold"),] #if 2 and both na, use bdi old
    } else if(nrow(temp)==1){
      temp<-temp  #if only one, use that
    } else {
      print(paste("Error: don't know what to do with bdi summary for ",id,sep=""))
    }
    if(nrow(temp)!=1){print("ERROR")} #if nrow in temp is not 1, print error
    nodupbdi<-rbind(nodupbdi,temp) #add row to data frame
  }
}

currentDate<-Sys.Date()
write.csv(nodupbdi, paste('/import/monstrum/Users/adaldal/SummaryScores/BDIALL_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### MFQ ###
measure="mfq"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"mfqsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="mfqsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
MFQ_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
mfq<-giant[,c(grep('mfq_c_[0-9]', colnames(giant)))]
mfq$NAflag<-ifelse(complete.cases(mfq),0,1) #flags subjects that have NAs and have estimated or missing totals
mfq_int<-t(apply(mfq[,c(1:13)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
MFQ_SummaryScores$mfq_total<-rowSums(mfq_int)
MFQ_SummaryScores$mfq_naflag<-mfq[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(MFQ_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/MFQ_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### MADRS ###
measure="madrs"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"madrssummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="madrssummary"
giant$dovisit<-partid3 #assigns date to dovisit column
MADRS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
madrs<-giant[,c(grep('madrs_[0-9]', colnames(giant)))]
madrs$NAflag<-ifelse(complete.cases(madrs),0,1) #flags subjects that have NAs and have estimated or missing totals
mfq_int<-t(apply(madrs[,c(1:10)], 1, function(x) ifelse(is.na(x), mean(x, na.rm=T), x)))
MADRS_SummaryScores$madrs_total<-rowSums(madrs)
MADRS_SummaryScores$madrs_naflag<-madrs[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(MADRS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/MADRS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### RPAS SHORT ###
measure="rpasshort"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"rpasshortsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="rpasshortsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
RPASSHORT_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
rpasshort<-giant[,c(grep('phys_anhed_[0-9]', colnames(giant)))]
rpasshort1<-rpasshort[,c('phys_anhed_5','phys_anhed_6','phys_anhed_8','phys_anhed_10')]
rpasshort2<-rpasshort[,c('phys_anhed_1','phys_anhed_2','phys_anhed_3','phys_anhed_4','phys_anhed_7','phys_anhed_9', "phys_anhed_11", "phys_anhed_12", "phys_anhed_13", "phys_anhed_14", "phys_anhed_15")]
rpasshort2<-(1-rpasshort2) #reverse code items in rpasshort2
rpasshort3<-cbind(rpasshort1,rpasshort2)
RPASSHORT_SummaryScores$rpasshort_total<-rowSums(rpasshort3[,c(1:15)])
RPASSHORT_SummaryScores$rpasshort_avg<-(RPASSHORT_SummaryScores$rpasshort_total/15)
rpasshort3$NAflag<-ifelse(complete.cases(rpasshort3),0,1) #flags subjects that have NAs and have estimated or missing totals
RPASSHORT_SummaryScores$rpasshort_naflag<-rpasshort3[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(RPASSHORT_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/RpasSHORT_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### RSAS SHORT ###
measure="rsasshort"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"rsasshortsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="rsasshortsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
RSASSHORT_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
rsasshort<-giant[,c(grep('soc_anhed_[0-9]', colnames(giant)))]
rsasshort1<-rsasshort[,c('soc_anhed_1','soc_anhed_2','soc_anhed_3','soc_anhed_5','soc_anhed_6','soc_anhed_7','soc_anhed_8','soc_anhed_10','soc_anhed_15')]
rsasshort2<-rsasshort[,c('soc_anhed_4','soc_anhed_9','soc_anhed_11','soc_anhed_12','soc_anhed_13','soc_anhed_14')]
rsasshort2<-(1-rsasshort2) #reverse code items in rsasshort2
rsasshort3<-cbind(rsasshort1,rsasshort2)
RSASSHORT_SummaryScores$rsasshort_total<-rowSums(rsasshort3[,c(1:15)])
RSASSHORT_SummaryScores$rsasshort_avg<-(RSASSHORT_SummaryScores$rsasshort_total/15)
rsasshort3$NAflag<-ifelse(complete.cases(rsasshort3),0,1) #flags subjects that have NAs and have estimated or missing totals
RSASSHORT_SummaryScores$rsasshort_naflag<-rsasshort3[,c('NAflag')]
currentDate<-Sys.Date()
write.csv(RSASSHORT_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/RsasSHORT_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### RPAS LONG ###
measure="rpas"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"rpassummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="rpassummary"
giant$dovisit<-partid3 #assigns date to dovisit column
RPAS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
rpas<-giant[,c(grep('rpas[0-9]', names(giant), value=T))]
rpassub1<-rpas[,c('rpas5','rpas6','rpas8','rpas9','rpas10','rpas11','rpas12','rpas13','rpas14','rpas15','rpas16',
                  'rpas17','rpas19','rpas21','rpas22','rpas25','rpas26','rpas27','rpas28','rpas31','rpas32','rpas40',
                  'rpas42','rpas43','rpas47','rpas49','rpas50','rpas51','rpas54','rpas55','rpas56')] #31 questions TRUE=1=anhedonic
rpassub2<-rpas[,c('rpas1','rpas2','rpas3','rpas4','rpas7','rpas18','rpas20','rpas23','rpas24','rpas29','rpas30','rpas33',
                  'rpas34','rpas35','rpas36','rpas37','rpas38','rpas39','rpas41','rpas44','rpas45','rpas46','rpas48','rpas52',
                  'rpas53','rpas57','rpas58','rpas59','rpas60','rpas61')] #30 questions TRUE=1=nonanhedonic
rpassub2<- 1 - rpassub2 #(1 - response to reverse code these items)
rpas1<-cbind(rpassub2,rpassub1)
rpas1$NAflag<-ifelse(complete.cases(rpas),0,1) #flags subjects that have NAs and have estimated or missing totals
rpasavg<-rowMeans(rpas1[,c(1:61)],na.rm=T) #calculate avg without NAs

rpasshortequiv1<-rpas[,c('rpas47','rpas13','rpas17','rpas25')]
rpasshortequiv2<-rpas[,c('rpas34','rpas60','rpas35','rpas45','rpas57','rpas36','rpas58','rpas38','rpas39','rpas59','rpas33')]
rpasshortequiv2<- 1 - rpasshortequiv2 #(1-response to reverse code these items)
rpasshortequiv<-cbind(rpasshortequiv1,rpasshortequiv2)
rpasshortequivavg<-rowMeans(rpasshortequiv, na.rm=T)

RPAS_SummaryScores$rpas_avg<-rpasavg
RPAS_SummaryScores$rpas_total<-(rpasavg*61) #multiply avg by 61 (total number of questions) for estimated total
RPAS_SummaryScores$rpas_naflag<-rpas1[,c('NAflag')]
RPAS_SummaryScores$rpasshortequiv_total<-rpasshortequivavg*15
RPAS_SummaryScores$rpasshortequiv_avg<-rpasshortequivavg
currentDate<-Sys.Date()
write.csv(RPAS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/RPAS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### RSAS LONG ###
measure="rsas"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant == -9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"rsassummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="rsassummary"
giant$dovisit<-partid3 #assigns date to dovisit column
RSAS_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=FALSE]
rsas<-giant[,c(grep('rsas[0-9]', names(giant), value=T))]

rsassub1<-rsas[,c('rsas1','rsas2','rsas3','rsas6','rsas10','rsas13','rsas14','rsas17','rsas21',
                  'rsas22','rsas23','rsas26','rsas27','rsas28','rsas29','rsas32','rsas34',
                  'rsas35','rsas37','rsas38','rsas39','rsas40')] #22 TRUE=1=anhedonic
rsassub2<-rsas[,c('rsas4','rsas5','rsas7','rsas8','rsas9','rsas11','rsas12','rsas15','rsas16','rsas18',
                  'rsas19','rsas20','rsas24','rsas25','rsas30','rsas31','rsas33','rsas36')] #18 TRUE=1=nonanhedonic

rsassub2<- 1 - rsassub2 #(1-response to reverse code these items)
rsas1<-cbind(rsassub2,rsassub1)
rsas1$NAflag<-ifelse(complete.cases(rsas1),0,1) #flags subjects that have NAs and have estimated or missing totals
rsasavg<-rowMeans(rsas1[,c(1:40)], na.rm=T)

rsasshortequiv1<-rsas[,c('rsas1','rsas26','rsas3','rsas28','rsas17','rsas38','rsas34','rsas21','rsas32')]
rsasshortequiv2<-rsas[,c('rsas15','rsas19','rsas36','rsas8','rsas24','rsas11')]
rsasshortequiv2<- 1 - rsasshortequiv2 #(1-response to reverse code these items)
rsasshortequiv<-cbind(rsasshortequiv1,rsasshortequiv2)
rsasshortequivavg<-rowMeans(rsasshortequiv, na.rm=T)

RSAS_SummaryScores$rsas_avg<-rsasavg
RSAS_SummaryScores$rsas_total<-(rsasavg*40) #multiply avg by 40 (total number of questions) for estimated total
RSAS_SummaryScores$rsas_naflag<-rsas1[,c('NAflag')]
RSAS_SummaryScores$rsasshortequiv_avg<-rsasshortequivavg
RSAS_SummaryScores$rsasshortequiv_total<-rsasshortequivavg*15
currentDate<-Sys.Date()
write.csv(RSAS_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/RSAS_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### RPAS SHORT & RPAS SHORT EQUIVALENT COMBINED ###

rpasshortequiv_comb<-RPAS_SummaryScores[,c('participant_id','bblid','procedure','dovisit','rpasshortequiv_avg','rpasshortequiv_total')]
rpasshort_comb<-RPASSHORT_SummaryScores[,c('participant_id','bblid','procedure','dovisit','rpasshort_avg','rpasshort_total')]
rpasshortcomb<-merge(rpasshortequiv_comb,rpasshort_comb, by.x = "participant_id", by.y="participant_id", all.x= T, all.y=T)
rpasshortcomb$bblid<-ifelse(is.na(rpasshortcomb[,c("bblid.x")]), rpasshortcomb[,c("bblid.y")], rpasshortcomb[,c("bblid.x")]) #if rpasshortcomb$bblid.x is na, then use rpasshortcomb$bblid.y, else use rpasshortcomb$bblid.x
rpasshortcomb$procedure<-ifelse(is.na(rpasshortcomb[,c("procedure.x")]), rpasshortcomb[,c("procedure.y")], rpasshortcomb[,c("procedure.x")]) #do same as above for procedure
rpasshortcomb$dovisit<-ifelse(is.na(rpasshortcomb[,c("dovisit.x")]), rpasshortcomb[,c("dovisit.y")], rpasshortcomb[,c("dovisit.x")]) #do the same as above for dovisit
rpasshortcomb$rpasshortcomb_avg<-ifelse(is.na(rpasshortcomb[,c("rpasshortequiv_avg")]), rpasshortcomb[,c("rpasshort_avg")], rpasshortcomb[,c("rpasshortequiv_avg")]) #do same as above for averages
rpasshortcomb$rpasshortcomb_total<-ifelse(is.na(rpasshortcomb[,c("rpasshortequiv_total")]), rpasshortcomb[,c("rpasshort_total")], rpasshortcomb[,c("rpasshortequiv_total")]) #do same as above for totals
rpasshortcomb<-rpasshortcomb[order(rpasshortcomb$bblid),]
rpasshortcomb$rpasshortcomb_source[rpasshortcomb$procedure == "rpassummary"] <- "rpasshort_equivalent" #create version column with more descriptive verbiage of source of score
rpasshortcomb$rpasshortcomb_source[rpasshortcomb$procedure == "rpasshortsummary"] <- "rpasshort" #create version column with more descriptive verbiage of source of score
rpasshortcomb$procedure <- "rpasshortcombsummary"

partid<-rpasshortcomb$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
rpasshortcomb$participant_id=paste(partid1,"rpasshortcombsummary",partid3, sep="_")

rpasshortcomb_SummaryScores<-rpasshortcomb[,c('participant_id','bblid','procedure','dovisit','rpasshortcomb_avg','rpasshortcomb_total','rpasshortcomb_source')] #pull combined columns and add to new data frame
currentDate<-Sys.Date()
write.csv(rpasshortcomb_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/RPASSHORTCOMB_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### RSAS SHORT & RSAS SHORT EQUIVALENT COMBINED ###

rsasshortequiv_comb<-RSAS_SummaryScores[,c('participant_id','bblid','procedure','dovisit','rsasshortequiv_avg','rsasshortequiv_total')]
rsasshort_comb<-RSASSHORT_SummaryScores[,c('participant_id','bblid','procedure','dovisit','rsasshort_avg','rsasshort_total')]
rsasshortcomb<-merge(rsasshortequiv_comb,rsasshort_comb, by.x = "participant_id", by.y="participant_id", all.x= T, all.y=T)
rsasshortcomb$bblid<-ifelse(is.na(rsasshortcomb[,c("bblid.x")]), rsasshortcomb[,c("bblid.y")], rsasshortcomb[,c("bblid.x")]) #if rsasshortcomb$bblid.x is na, then use rsasshortcomb$bblid.y, else use rsasshortcomb$bblid.x
rsasshortcomb$procedure<-ifelse(is.na(rsasshortcomb[,c("procedure.x")]), rsasshortcomb[,c("procedure.y")], rsasshortcomb[,c("procedure.x")]) #do same as above for procedure
rsasshortcomb$dovisit<-ifelse(is.na(rsasshortcomb[,c("dovisit.x")]), rsasshortcomb[,c("dovisit.y")], rsasshortcomb[,c("dovisit.x")]) #do the same as above for dovisit
rsasshortcomb$rsasshortcomb_avg<-ifelse(is.na(rsasshortcomb[,c("rsasshortequiv_avg")]), rsasshortcomb[,c("rsasshort_avg")], rsasshortcomb[,c("rsasshortequiv_avg")]) #do same as above for averages
rsasshortcomb$rsasshortcomb_total<-ifelse(is.na(rsasshortcomb[,c("rsasshortequiv_total")]), rsasshortcomb[,c("rsasshort_total")], rsasshortcomb[,c("rsasshortequiv_total")]) #do same as above for totals
rsasshortcomb<-rsasshortcomb[order(rsasshortcomb$bblid),]
rsasshortcomb$rsasshortcomb_source[rsasshortcomb$procedure == "rsassummary"] <- "rsasshort_equivalent" #create version column with more descriptive verbiage of source of score
rsasshortcomb$rsasshortcomb_source[rsasshortcomb$procedure == "rsasshortsummary"] <- "rsasshort" #create version column with more descriptive verbiage of source of score
rsasshortcomb$procedure <- "rsasshortcombsummary"

partid<-rsasshortcomb$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
rsasshortcomb$participant_id=paste(partid1,"rsasshortcombsummary",partid3, sep="_")

rsasshortcomb_SummaryScores<-rsasshortcomb[,c('participant_id','bblid','procedure','dovisit','rsasshortcomb_avg','rsasshortcomb_total','rsasshortcomb_source')] #pull combined columns and add to new data frame
currentDate<-Sys.Date()
write.csv(rsasshortcomb_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/RSASSHORTCOMB_SummaryScores_', currentDate, '.csv', sep=''), row.names=F)

### HCL ###
measure="hcl"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant<-measure_data
giant[giant ==-9999] <- NA
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"hclsummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="hclsummary"
giant$dovisit<-partid3 #assigns date to dovisit column
HCL_SummaryScores<-giant[,c('participant_id','bblid','procedure','dovisit'), drop=F]
hcl<-giant[,c(grep('hcl16_3_[0-9]', names(giant), value=T))]
HCL_SummaryScores$hcl_total<-rowSums(hcl)
currentDate<-Sys.Date()
write.csv(HCL_SummaryScores, paste('/import/monstrum/Users/adaldal/SummaryScores/HCL_SummaryScores-', currentDate, '.csv', sep=''), row.names=F)

### NSRS, FRANKEN, FRANKEN ADOL. ###
# sources script for franken space first so that most current franken space output can be read in here
source("/import/monstrum/Users/adaldal/Franken_SPACE_5-4-15.R")
currentDate<-Sys.Date()

giant<-read.csv(paste("/import/monstrum/Users/adaldal/Newfrank_", currentDate, ".csv", sep=''), na.strings=c('-9999', 'NA'), stringsAsFactors=F)
giant<-giant[order(giant$bblid),]
partid<-giant$participant_id
partid1<-do.call(rbind,strsplit(partid, "_"))[,1] #get bblids from string
partid3<-do.call(rbind,strsplit(partid, "_"))[,3] #get dates from string
giant$participant_id=paste(partid1,"newfranksummary",partid3, sep="_") #combine into new string for summaryscores
giant$procedure="newfranksummary"
giant$dovisit<-partid3 #assigns date to dovisit column

NEWFRANK_SummaryScores<-giant[,c('participant_id','bblid','procedure','frankenversion','dovisit'), drop=FALSE]
NEWFRANK_SummaryScores$fr_newcainsfamspo<-rowMeans(giant[,c('newfrank1', 'newfrank2')], na.rm=T)
NEWFRANK_SummaryScores$fr_newcainsromfr<-rowMeans(giant[,c('newfrank2', 'newfrank3')], na.rm=T)
NEWFRANK_SummaryScores$fr_newcainssocial<-rowMeans(giant[,c('newfrank1', 'newfrank2', 'newfrank3')], na.rm=T)
NEWFRANK_SummaryScores$fr_newcainsexperience_dw<-rowMeans(cbind(giant[,c('newfrank4', 'newfrank7', 'newfrank9', 'newfrank11', 'newfrank12', 'newfrank13', 'newfrank14')],NEWFRANK_SummaryScores$fr_newcainssocial,NEWFRANK_SummaryScores$fr_newcainssocial), na.rm=T) #NEWFRANK_SummaryScores$fr_newCAINSsocial is repeated twice to weight the average bc scale versions went from 3 items to 2 items
NEWFRANK_SummaryScores$fr_newcainsaffect<-rowMeans(giant[,c('newfrank21','newfrank22','newfrank24','newfrank25')], na.rm=T)

############ MOTIVATION ##################
NEWFRANK_SummaryScores$fr_soc_mot<-rowMeans(giant[,c('newfrank1','newfrank2','newfrank3')], na.rm=T)
NEWFRANK_SummaryScores$fr_recvoc_mot<-rowMeans(giant[,c('newfrank9','newfrank12')], na.rm=T)
NEWFRANK_SummaryScores$fr_global_mot<-rowMeans(cbind(giant[,c('newfrank9','newfrank12')],NEWFRANK_SummaryScores$fr_soc_mot), na.rm=T)

############ AFFECT ######################
NEWFRANK_SummaryScores$fr_flat_affect<-rowMeans(giant[,c('newfrank21','newfrank22')], na.rm=T)
NEWFRANK_SummaryScores$fr_psymotor_slow<-rowMeans(giant[,c('newfrank24','newfrank25')], na.rm=T)

########### HEDONICS #####################
NEWFRANK_SummaryScores$fr_soc_anh_past<-rowMeans(giant[,c('newfrank5','newfrank6')], na.rm=T)
NEWFRANK_SummaryScores$fr_soc_anh_int<-rowMeans(giant[,c('newfrank6','newfrank8')], na.rm=T)
NEWFRANK_SummaryScores$fr_soc_anh<-rowMeans(giant[,c('newfrank5','newfrank6','newfrank8')], na.rm=T)
NEWFRANK_SummaryScores$fr_soc_anh_amot<-rowMeans(NEWFRANK_SummaryScores[,c('fr_soc_mot','fr_soc_anh')], na.rm=T)
NEWFRANK_SummaryScores$fr_soc_all<-rowMeans(giant[,c('newfrank1','newfrank2','newfrank3','newfrank5','newfrank6','newfrank8')], na.rm=T)
NEWFRANK_SummaryScores$fr_recvoc_anh_past<-rowMeans(giant[,c('newfrank15','newfrank20')], na.rm=T)
NEWFRANK_SummaryScores$fr_recvoc_anh_int<-rowMeans(giant[,c('newfrank15','newfrank16')], na.rm=T)
NEWFRANK_SummaryScores$fr_recvoc_anh<-rowMeans(cbind(giant[,c('newfrank20')],NEWFRANK_SummaryScores$fr_recvoc_anh_int), na.rm=T)  
NEWFRANK_SummaryScores$fr_recvoc_anh_amot<-rowMeans(NEWFRANK_SummaryScores[,c('fr_recvoc_mot','fr_recvoc_anh')], na.rm=T)	
NEWFRANK_SummaryScores$fr_recvoc_all<-rowMeans(giant[,c('newfrank9','newfrank12','newfrank15','newfrank16','newfrank20')], na.rm=T)
NEWFRANK_SummaryScores$fr_phys_anh_past<-rowMeans(giant[,c('newfrank17','newfrank18')], na.rm=T)
NEWFRANK_SummaryScores$fr_phys_anh_int<-rowMeans(giant[,c('newfrank18','newfrank19')], na.rm=T)
NEWFRANK_SummaryScores$fr_phys_anh<-rowMeans(cbind(giant[,c('newfrank17')],NEWFRANK_SummaryScores$fr_phys_anh_int), na.rm=T)	
NEWFRANK_SummaryScores$fr_phys_all<-rowMeans(giant[,c('newfrank17','newfrank18','newfrank19')], na.rm=T)

################### GLOBAL/COMBINED #########################
NEWFRANK_SummaryScores$fr_anh_amot_all<-rowMeans(giant[,c('newfrank1','newfrank2','newfrank3','newfrank5','newfrank6','newfrank8','newfrank9','newfrank12','newfrank15','newfrank16','newfrank17','newfrank18','newfrank19','newfrank20')], na.rm=T)
NEWFRANK_SummaryScores$fr_anh_int_past_all<-rowMeans(giant[,c('newfrank6','newfrank15','newfrank18')], na.rm=T)
NEWFRANK_SummaryScores$fr_anh_int_fut_all<-rowMeans(giant[,c('newfrank8','newfrank16','newfrank19')], na.rm=T)
NEWFRANK_SummaryScores$fr_anh_freq_past_all<-rowMeans(giant[,c('newfrank5','newfrank17','newfrank20')], na.rm=T)
NEWFRANK_SummaryScores$fr_anh_past_all<-rowMeans(giant[,c('newfrank5','newfrank6','newfrank17','newfrank18','newfrank20')], na.rm=T)
NEWFRANK_SummaryScores$fr_anh_global<-rowMeans(giant[,c('newfrank5','newfrank6','newfrank8','newfrank15','newfrank16','newfrank17','newfrank18','newfrank19','newfrank20')], na.rm=T)
NEWFRANK_SummaryScores$fr_mot_anticip_anh<-rowMeans(NEWFRANK_SummaryScores[,c('fr_global_mot','fr_anh_int_fut_all')], na.rm=T)
NEWFRANK_SummaryScores$fr_total_scale_avg<-rowMeans(giant[,c('newfrank1','newfrank2','newfrank3','newfrank5','newfrank6','newfrank8','newfrank9','newfrank12','newfrank15','newfrank16','newfrank17','newfrank18','newfrank19','newfrank20','newfrank21','newfrank22','newfrank24','newfrank25')], na.rm=T)
NEWFRANK_SummaryScores$fr_global_avg_psych<-rowMeans(NEWFRANK_SummaryScores[,c('fr_global_mot','fr_anh_global','fr_newcainsaffect')], na.rm=T)
NEWFRANK_SummaryScores$fr_anh_avol_global_exp<-rowMeans(NEWFRANK_SummaryScores[,c('fr_soc_all','fr_phys_all','fr_recvoc_all')], na.rm=T)

#correctly assign franken versions to see which interview version item level data comes from
test<-NEWFRANK_SummaryScores[which(! is.na(NEWFRANK_SummaryScores$frankenversion)),]
na_test<-NEWFRANK_SummaryScores[which(is.na(NEWFRANK_SummaryScores$frankenversion)),]
na_test<-na_test[which(! duplicated(na_test)),]
test2<-rbind(test,na_test[which(! na_test$participant_id %in% test$participant_id),])

currentDate<-Sys.Date()
write.csv(test2, paste("/import/monstrum/Users/adaldal/NEWFRANK_SummaryScores", currentDate, ".csv", sep=""), row.names=F)


