# appending diagnosis procedure to summary scores, so can be plotted by diagnosis in graphing script #
# titled "summaryscore_graphs.R", which creates, box plots, scatterplots and histograms broken down by diagnoses#

source("/import/speedy/scripts/hopsonr/R_utilities/append_items.R")
currentDate<-Sys.Date()
arisummary<-append_items(measure="arisummary",items=c("diagnosis","studyenroll"))
write.csv(arisummary, paste('/import/monstrum/Users/adaldal/SummaryScores/ari_append', currentDate, '.csv', sep=''), row.names=F)

asrmsummary<-append_items(measure="asrmsummary",items=c("diagnosis","studyenroll"))
write.csv(asrmsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/asrm_append', currentDate, '.csv', sep=''), row.names=F)

baisummary<-append_items(measure="baisummary",items=c("diagnosis","studyenroll"))
write.csv(baisummary, paste('/import/monstrum/Users/adaldal/SummaryScores/bai_append', currentDate, '.csv', sep=''), row.names=F)

bdisummary<-append_items(measure="bdisummary",items=c("diagnosis","studyenroll"))
write.csv(bdisummary, paste('/import/monstrum/Users/adaldal/SummaryScores/bdi_append', currentDate, '.csv', sep=''), row.names=F)

bisbassummary<-append_items(measure="bisbassummary",items=c("diagnosis","studyenroll"))
write.csv(bisbassummary, paste('/import/monstrum/Users/adaldal/SummaryScores/bisbas_append', currentDate, '.csv', sep=''), row.names=F)

bisssummary<-append_items(measure="bisssummary",items=c("diagnosis","studyenroll"))
write.csv(bisssummary, paste('/import/monstrum/Users/adaldal/SummaryScores/biss_append', currentDate, '.csv', sep=''), row.names=F)

bprsv3summary<-append_items(measure="bprsv3summary",items=c("diagnosis","studyenroll"))
write.csv(bprsv3summary, paste('/import/monstrum/Users/adaldal/SummaryScores/bprsv3_append', currentDate, '.csv', sep=''), row.names=F)

bprsv4summary<-append_items(measure="bprsv4summary",items=c("diagnosis","studyenroll"))
write.csv(bprsv4summary, paste('/import/monstrum/Users/adaldal/SummaryScores/bprsv4_append', currentDate, '.csv', sep=''), row.names=F)

bprsv3combsummary<-append_items(measure="bprsv3combsummary",items=c("diagnosis","studyenroll"))
write.csv(bprsv3combsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/bprsv3comb_append', currentDate, '.csv', sep=''), row.names=F)

bsssummary<-append_items(measure="bsssummary",items=c("diagnosis","studyenroll"))
write.csv(bsssummary, paste('/import/monstrum/Users/adaldal/SummaryScores/bss_append', currentDate, '.csv', sep=''), row.names=F)

cdsssummary<-append_items(measure="cdsssummary",items=c("diagnosis","studyenroll"))
write.csv(cdsssummary, paste('/import/monstrum/Users/adaldal/SummaryScores/cdss_append', currentDate, '.csv', sep=''), row.names=F)

daisummary<-append_items(measure="daisummary",items=c("diagnosis","studyenroll"))
write.csv(daisummary, paste('/import/monstrum/Users/adaldal/SummaryScores/dai_append', currentDate, '.csv', sep=''), row.names=F)

dospert1summary<-append_items(measure="dospert1summary",items=c("diagnosis","studyenroll"))
write.csv(dospert1summary, paste('/import/monstrum/Users/adaldal/SummaryScores/dospert1_append', currentDate, '.csv', sep=''), row.names=F)

dospert2summary<-append_items(measure="dospert2summary",items=c("diagnosis","studyenroll"))
write.csv(dospert2summary, paste('/import/monstrum/Users/adaldal/SummaryScores/dospert2_append', currentDate, '.csv', sep=''), row.names=F)

fetsummary<-append_items(measure="fetsummary",items=c("diagnosis","studyenroll"))
write.csv(fetsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/fet_append', currentDate, '.csv', sep=''), row.names=F)

ftndsummary<-append_items(measure="ftndsummary",items=c("diagnosis","studyenroll"))
write.csv(ftndsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/ftnd_append', currentDate, '.csv', sep=''), row.names=F)

gritsummary<-append_items(measure="gritsummary",items=c("diagnosis","studyenroll"))
write.csv(gritsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/grit_append', currentDate, '.csv', sep=''), row.names=F)

hclsummary<-append_items(measure="hclsummary",items=c("diagnosis","studyenroll"))
write.csv(hclsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/hcl_append', currentDate, '.csv', sep=''), row.names=F)

lotrsummary<-append_items(measure="lotrsummary",items=c("diagnosis","studyenroll"))
write.csv(lotrsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/lotr_append', currentDate, '.csv', sep=''), row.names=F)

madrssummary<-append_items(measure="madrssummary",items=c("diagnosis","studyenroll"))
write.csv(madrssummary, paste('/import/monstrum/Users/adaldal/SummaryScores/madrs_append', currentDate, '.csv', sep=''), row.names=F)

mdqsummary<-append_items(measure="mdqsummary",items=c("diagnosis","studyenroll"))
write.csv(mdqsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/mdq_append', currentDate, '.csv', sep=''), row.names=F)

mfqsummary<-append_items(measure="mfqsummary",items=c("diagnosis","studyenroll"))
write.csv(mfqsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/mfq_append', currentDate, '.csv', sep=''), row.names=F)

newfranksummary<-append_items(measure="newfranksummary",items=c("diagnosis","studyenroll"))
write.csv(newfranksummary, paste('/import/monstrum/Users/adaldal/SummaryScores/newfrank_append', currentDate, '.csv', sep=''), row.names=F)

panassummary<-append_items(measure="panassummary",items=c("diagnosis","studyenroll"))
write.csv(panassummary, paste('/import/monstrum/Users/adaldal/SummaryScores/panas_append', currentDate, '.csv', sep=''), row.names=F)

panascsummary<-append_items(measure="panascsummary",items=c("diagnosis","studyenroll"))
write.csv(panascsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/panasc_append', currentDate, '.csv', sep=''), row.names=F)

passummary<-append_items(measure="passummary",items=c("diagnosis","studyenroll"))
write.csv(passummary, paste('/import/monstrum/Users/adaldal/SummaryScores/pas_append', currentDate, '.csv', sep=''), row.names=F)

qlsfullsummary<-append_items(measure="qlsfullsummary",items=c("diagnosis","studyenroll"))
write.csv(qlsfullsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/qlsfull_append', currentDate, '.csv', sep=''), row.names=F)

qlsshortsummary<-append_items(measure="qlsshortsummary",items=c("diagnosis","studyenroll"))
write.csv(qlsshortsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/qlsshort_append', currentDate, '.csv', sep=''), row.names=F)

rpassummary<-append_items(measure="rpassummary",items=c("diagnosis","studyenroll"))
write.csv(rpassummary, paste('/import/monstrum/Users/adaldal/SummaryScores/rpas_append', currentDate, '.csv', sep=''), row.names=F)

rpasshortsummary<-append_items(measure="rpasshortsummary",items=c("diagnosis","studyenroll"))
write.csv(rpasshortsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/rpasshort_append', currentDate, '.csv', sep=''), row.names=F)

rsassummary<-append_items(measure="rsassummary",items=c("diagnosis","studyenroll"))
write.csv(rsassummary, paste('/import/monstrum/Users/adaldal/SummaryScores/rsas_append', currentDate, '.csv', sep=''), row.names=F)

rsasshortsummary<-append_items(measure="rsasshortsummary",items=c("diagnosis","studyenroll"))
write.csv(rsasshortsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/rsasshort_append', currentDate, '.csv', sep=''), row.names=F)

rpasshortcombsummary<-append_items(measure="rpasshortcombsummary",items=c("diagnosis","studyenroll"))
write.csv(rpasshortcombsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/rpasshortcomb_append', currentDate, '.csv', sep=''), row.names=F)

rsasshortcombsummary<-append_items(measure="rsasshortcombsummary",items=c("diagnosis","studyenroll"))
write.csv(rsasshortcombsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/rsasshortcomb_append', currentDate, '.csv', sep=''), row.names=F)

sanssummary<-append_items(measure="sanssummary",items=c("diagnosis","studyenroll"))
write.csv(sanssummary, paste('/import/monstrum/Users/adaldal/SummaryScores/sans_append', currentDate, '.csv', sep=''), row.names=F)

sapssummary<-append_items(measure="sapssummary",items=c("diagnosis","studyenroll"))
write.csv(sapssummary, paste('/import/monstrum/Users/adaldal/SummaryScores/saps_append', currentDate, '.csv', sep=''), row.names=F)

sessummary<-append_items(measure="sessummary",items=c("diagnosis","studyenroll"))
write.csv(sessummary, paste('/import/monstrum/Users/adaldal/SummaryScores/ses_append', currentDate, '.csv', sep=''), row.names=F)

sissummary<-append_items(measure="sissummary",items=c("diagnosis","studyenroll"))
write.csv(sissummary, paste('/import/monstrum/Users/adaldal/SummaryScores/sis_append', currentDate, '.csv', sep=''), row.names=F)

staitraitsummary<-append_items(measure="staitraitsummary",items=c("diagnosis","studyenroll"))
write.csv(staitraitsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/staitrait_append', currentDate, '.csv', sep=''), row.names=F)

swlssummary<-append_items(measure="swlssummary",items=c("diagnosis","studyenroll"))
write.csv(swlssummary, paste('/import/monstrum/Users/adaldal/SummaryScores/swls_append', currentDate, '.csv', sep=''), row.names=F)

tepssummary<-append_items(measure="tepssummary",items=c("diagnosis","studyenroll"))
write.csv(tepssummary, paste('/import/monstrum/Users/adaldal/SummaryScores/teps_append', currentDate, '.csv', sep=''), row.names=F)

wolfpostsummary<-append_items(measure="wolfpostsummary",items=c("diagnosis","studyenroll"))
write.csv(wolfpostsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/wolfpost_append', currentDate, '.csv', sep=''), row.names=F)

wolftraitsummary<-append_items(measure="wolftraitsummary",items=c("diagnosis","studyenroll"))
write.csv(wolftraitsummary, paste('/import/monstrum/Users/adaldal/SummaryScores/wolftrait_append', currentDate, '.csv', sep=''), row.names=F)

