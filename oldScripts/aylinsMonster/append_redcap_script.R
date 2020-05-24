source("/import/monstrum/Users/adaldal/append_items.R")
currentDate<-Sys.Date()

#dw_request<-append_items(measure="newfranksummary",items=c("diagnosis","demographics","studyenroll","newfranksummary",
                                               #"baisummary","bdisummary","bisbassummary","medications","bsssummary"))
#write.csv(dw_request, paste('/import/monstrum/Users/adaldal/529append_', currentDate, '.csv', sep=''), row.names=F)


appended<-append_items(measure="arisummary",items=c("arisummary","diagnosis"))
write.csv(appended, paste('/import/monstrum/Users/adaldal/ari_append_', currentDate, '.csv', sep=''), row.names=F)