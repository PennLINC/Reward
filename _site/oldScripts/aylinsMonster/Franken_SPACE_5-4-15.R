### converts NSRS, FRANKEN & FRANKEN ADOL. item-level data from giant redcap project (Wolf Satterthwaite Repository) into New Franken Space ###
# updated on 2/1/16 to run from Selkie server instead of Banshee
# records must be updated on selkie from banshee for active projects (like effort) before it is run otherwise the output won't be the most up-to-date

library("bitops")
library("RCurl")
library("REDCapR")
set_config(config(ssl_verifypeer = 0L))
set_config(config(sslversion = 1))

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
measure="nsrs"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant1<-measure_data
giant1[giant1 ==-9999] <- NA

measure="franken"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant2<-measure_data
giant2[giant2 ==-9999] <- NA

measure="frankenadol"
measure_data<-project_data[which(project_data$procedure==measure),
                           c(project_dictionary$field_name[which(project_dictionary$form_name %in% c("general",measure))])]
giant3<-measure_data
giant3[giant3 ==-9999] <- NA

giant1<-giant1[order(giant1$bblid),]
giant2<-giant2[order(giant2$bblid),]
giant3<-giant3[order(giant3$bblid),]

nsrs<-giant1[,c('participant_id','bblid', grep('nsrs[1-9]', names(giant1), value=T)),drop=F]
franken<-giant2[,c('participant_id','bblid', grep('franken_[1-9]', names(giant2), value=T)),drop=F]
frankenadol<-giant3[,c('participant_id','bblid', grep('franken_a_[1-9]', names(giant3), value=T)),drop=F]

#merge all three data frames together
df1<-merge(nsrs,franken, by=c("participant_id","bblid"), all.x=T, all.y=T)
NEW_frank<-merge(df1,frankenadol, by=c("participant_id","bblid"), all.x=T, all.y=T)

NEW_frank$frankenversion<-ifelse(is.na(NEW_frank[,c("franken_1")] & is.na(NEW_frank[,c("franken_8")])),NA,"franken") #determines version that the scores come from
NEW_frank$frankenversion<-ifelse(is.na(NEW_frank[,c("frankenversion")]) & ! is.na(NEW_frank[,c("nsrs1")]),"nsrs",NEW_frank$frankenversion) #determines version that the scores come from
NEW_frank$frankenversion<-ifelse(is.na(NEW_frank[,c("frankenversion")]) & ! is.na(NEW_frank[,c("franken_a_1")]),"frankenadol",NEW_frank$frankenversion) #determines version that the scores come from

NEW_frank$newfrank1<-ifelse(is.na(NEW_frank[,c("franken_1")]), NEW_frank[,c("nsrs1")], NEW_frank[,c("franken_1")]) #if franken is NA, then use nsrs score, else use franken score
NEW_frank$newfrank1<-ifelse(is.na(NEW_frank[,c("newfrank1")]), NEW_frank[,c("franken_a_1")], NEW_frank[,c("newfrank1")]) #if nsrs score is NA, then use frankenadol score, else use nsrs score

NEW_frank$newfrank2<-ifelse(is.na(NEW_frank[,c("franken_2")]), NEW_frank[,c("nsrs2")], NEW_frank[,c("franken_2")])
NEW_frank$newfrank2<-ifelse(is.na(NEW_frank[,c("newfrank2")]), NEW_frank[,c("franken_a_2")], NEW_frank[,c("newfrank2")])

NEW_frank$newfrank3<-ifelse(is.na(NEW_frank[,c("franken_3")]), NEW_frank[,c("nsrs3")], NEW_frank[,c("franken_3")])
NEW_frank$newfrank3<-ifelse(is.na(NEW_frank[,c("newfrank3")]), NEW_frank[,c("franken_a_3")], NEW_frank[,c("newfrank3")])

NEW_frank$newfrank4<-ifelse(is.na(NEW_frank[,c("franken_4")]), NEW_frank[,c("franken_a_4")], NEW_frank[,c("franken_4")])

NEW_frank$newfrank5<-ifelse(is.na(NEW_frank[,c("franken_4a")]), NEW_frank[,c("nsrs8")], NEW_frank[,c("franken_4a")])
NEW_frank$newfrank5<-ifelse(is.na(NEW_frank[,c("newfrank5")]), NEW_frank[,c("franken_a_4a")], NEW_frank[,c("newfrank5")])

NEW_frank$newfrank6<-ifelse(is.na(NEW_frank[,c("franken_4b")]), NEW_frank[,c("nsrs9")], NEW_frank[,c("franken_4b")])
NEW_frank$newfrank6<-ifelse(is.na(NEW_frank[,c("newfrank6")]), NEW_frank[,c("franken_a_4b")], NEW_frank[,c("newfrank6")])

NEW_frank$newfrank7<-ifelse(is.na(NEW_frank[,c("franken_5")]), NEW_frank[,c("franken_a_5")], NEW_frank[,c("franken_5")])

NEW_frank$newfrank8<-ifelse(is.na(NEW_frank[,c("franken_5a")]), NEW_frank[,c("nsrs10b")], NEW_frank[,c("franken_5a")])
NEW_frank$newfrank8<-ifelse(is.na(NEW_frank[,c("newfrank8")]), NEW_frank[,c("franken_a_5a")], NEW_frank[,c("newfrank8")])

NEW_frank$newfrank9<-ifelse(is.na(NEW_frank[,c("franken_6")]), NEW_frank[,c("nsrs5")], NEW_frank[,c("franken_6")])
NEW_frank$newfrank9<-ifelse(is.na(NEW_frank[,c("newfrank9")]), NEW_frank[,c("franken_a_6")], NEW_frank[,c("newfrank9")])

NEW_frank$newfrank10<-ifelse(is.na(NEW_frank[,c("franken_7")]), NEW_frank[,c("franken_a_7")], NEW_frank[,c("franken_7")])

NEW_frank$newfrank11<-ifelse(is.na(NEW_frank[,c("franken_8")]), NEW_frank[,c("franken_a_8")], NEW_frank[,c("franken_8")])

NEW_frank$newfrank12<-ifelse(is.na(NEW_frank[,c("franken_9")]), NEW_frank[,c("nsrs6")], NEW_frank[,c("franken_9")])
NEW_frank$newfrank12<-ifelse(is.na(NEW_frank[,c("newfrank12")]), NEW_frank[,c("franken_a_9")], NEW_frank[,c("newfrank12")])

NEW_frank$newfrank13<-ifelse(is.na(NEW_frank[,c("franken_10")]), NEW_frank[,c("franken_a_10")], NEW_frank[,c("franken_10")])

NEW_frank$newfrank14<-ifelse(is.na(NEW_frank[,c("franken_11")]), NEW_frank[,c("franken_a_11")], NEW_frank[,c("franken_11")])

NEW_frank$newfrank15<-ifelse(is.na(NEW_frank[,c("franken_11a")]), NEW_frank[,c("nsrs15")], NEW_frank[,c("franken_11a")])
NEW_frank$newfrank15<-ifelse(is.na(NEW_frank[,c("newfrank15")]), NEW_frank[,c("franken_a_10a")], NEW_frank[,c("newfrank15")])

NEW_frank$newfrank16<-ifelse(is.na(NEW_frank[,c("franken_11b")]), NEW_frank[,c("nsrs16b")], NEW_frank[,c("franken_11b")])
NEW_frank$newfrank16<-ifelse(is.na(NEW_frank[,c("newfrank16")]), NEW_frank[,c("franken_a_11a")], NEW_frank[,c("newfrank16")])

NEW_frank$newfrank17<-ifelse(is.na(NEW_frank[,c("franken_11c")]), NEW_frank[,c("nsrs11")], NEW_frank[,c("franken_11c")])
NEW_frank$newfrank17<-ifelse(is.na(NEW_frank[,c("newfrank17")]), NEW_frank[,c("franken_a_12")], NEW_frank[,c("newfrank17")])

NEW_frank$newfrank18<-ifelse(is.na(NEW_frank[,c("franken_11d")]), NEW_frank[,c("nsrs12")], NEW_frank[,c("franken_11d")])
NEW_frank$newfrank18<-ifelse(is.na(NEW_frank[,c("newfrank18")]), NEW_frank[,c("franken_a_12a")], NEW_frank[,c("newfrank18")])

NEW_frank$newfrank19<-ifelse(is.na(NEW_frank[,c("franken_11e")]), NEW_frank[,c("nsrs13b")], NEW_frank[,c("franken_11e")])
NEW_frank$newfrank19<-ifelse(is.na(NEW_frank[,c("newfrank19")]), NEW_frank[,c("franken_a_13")], NEW_frank[,c("newfrank19")])

NEW_frank$newfrank20<-ifelse(is.na(NEW_frank[,c("franken_11f")]), NEW_frank[,c("nsrs14")], NEW_frank[,c("franken_11f")])
NEW_frank$newfrank20<-ifelse(is.na(NEW_frank[,c("newfrank20")]), NEW_frank[,c("franken_a_10b")], NEW_frank[,c("newfrank20")])

NEW_frank$newfrank21<-ifelse(is.na(NEW_frank[,c("franken_12")]), NEW_frank[,c("nsrs17")], NEW_frank[,c("franken_12")])
NEW_frank$newfrank21<-ifelse(is.na(NEW_frank[,c("newfrank21")]), NEW_frank[,c("franken_a_14")], NEW_frank[,c("newfrank21")])

NEW_frank$newfrank22<-ifelse(is.na(NEW_frank[,c("franken_13")]), NEW_frank[,c("nsrs18")], NEW_frank[,c("franken_13")])
NEW_frank$newfrank22<-ifelse(is.na(NEW_frank[,c("newfrank22")]), NEW_frank[,c("franken_a_15")], NEW_frank[,c("newfrank22")])

NEW_frank$newfrank23<-ifelse(is.na(NEW_frank[,c("franken_14")]), NEW_frank[,c("franken_a_16")], NEW_frank[,c("franken_14")])

NEW_frank$newfrank24<-ifelse(is.na(NEW_frank[,c("franken_15")]), NEW_frank[,c("nsrs19")], NEW_frank[,c("franken_15")])
NEW_frank$newfrank24<-ifelse(is.na(NEW_frank[,c("newfrank24")]), NEW_frank[,c("franken_a_17")], NEW_frank[,c("newfrank24")])

NEW_frank$newfrank25<-ifelse(is.na(NEW_frank[,c("franken_16")]), NEW_frank[,c("nsrs22")], NEW_frank[,c("franken_16")])
NEW_frank$newfrank25<-ifelse(is.na(NEW_frank[,c("newfrank25")]), NEW_frank[,c("franken_a_18")], NEW_frank[,c("newfrank25")])

NEW_frank2<-NEW_frank[,c('participant_id','bblid','frankenversion','newfrank1','newfrank2','newfrank3','newfrank4','newfrank5','newfrank6','newfrank7','newfrank8','newfrank9','newfrank10','newfrank11','newfrank12',
                         'newfrank13','newfrank14','newfrank15','newfrank16','newfrank17','newfrank18','newfrank19','newfrank20','newfrank21','newfrank22','newfrank23','newfrank24','newfrank25'), drop=FALSE]
currentDate<-Sys.Date()
write.csv(NEW_frank2, paste("/import/monstrum/Users/adaldal/Newfrank_", currentDate, ".csv", sep=''), row.names=F)

