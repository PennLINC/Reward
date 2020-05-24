## making barplots,histograms and scatterplots for calculated summary scores summary scores ##
# must download the calculated summary scores in csv form before running and save in path below
# will remove entries that have NAs as a calculated summary score by default
# creates a page with all three types of plots for EVERY submeasure of EVERY summary score calculated scale (ex. for ari scale creates two pages: ari_total, ari_avg)
# can be run using output from append script (append_items.R) or output from date-matching script (collapse_redcap_data_across_forms_v3.4.R) but slight edits/changes need to be made to output before it can be run
# if using output from date-matching then there is a commented out line of code that fixes dates that needs to be commented in bc the dates that are output from date-matching
# are not in the right format to be used in the scatterplot but the output from the append script is fine

list<-Sys.glob("/import/monstrum/Users/adaldal/SummaryScores/diag_appended_sumscores/*.csv") #list of summary scores interested in saved as csvs in user folder
other_columns<-c("participant_id","bblid","procedure","dovisit","diagnosis","studyenroll") #additional columns that the tables should select
#other_columns<-c("bblid","date_provided","primarydiagnosis")

### multiplot function from cookbook-r; laying out all three plots on the same page ###
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  plots <- c(list(...), plotlist)
  numPlots = length(plots)
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  if (numPlots==1) {
    print(plots[[1]])   
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    # Make each plot, in the correct location on the page
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

#read through all .csv files in list provided by user
for(file in list) {
  print(file)
  temp<-read.csv(file)

  names<-colnames(temp[which(! colnames(temp) %in% other_columns)])
  names<-names[grep("naflag",names,invert=T)]
  names<-names[grep("version",names,invert=T)]
  names<-names[grep("primarydiagnosis",names,invert=T)]
  names<-names[grep("diagnosis_notes",names,invert=T)]
  names<-names[grep("moodstate",names,invert=T)]
  names<-names[grep("studyenroll_notes",names,invert=T)]
  names<-names[grep("secondarydiagnosis",names,invert=T)]
  names<-names[grep("studygroup",names,invert=T)]
  
  #create histogram, scatterplot and boxplot for each column in each file (except for columns declared in "other_columns")
  for(column in names){
    print(column)
    
    #histogram
    histogram<-ggplot(temp, aes(x=temp[[column]])) +
      geom_histogram(colour="black",fill="white") + xlab(column) + ggtitle(column) + 
      theme(plot.title = element_text(lineheight=.8, face="bold", size = 26))                  
    
    #convert date_provided column to usable format in R if using output from date-match script (ex. 20160517 -> 5-17-2016 so that R can plot correctly)
    #temp$dovisit2<-as.Date(paste(substr(temp$date_provided,1,4), substr(temp$date_provided,5,6), substr(temp$date_provided,7,8)), format="%Y %m %d",origin="1970-01-01")
    
    #scatterplot
    scatterplot<-ggplot(data=temp, aes(x=temp$dovisit, y=temp[[column]]))+ geom_point(shape=15, size=1, colour="black") + 
      xlab("date of visit") + ylab(column) + theme(axis.ticks = element_blank(), axis.text.x = element_blank())
    
    #boxplot
    boxplot<-ggplot(temp, aes(x=primarydiagnosis, y=temp[[column]], fill=primarydiagnosis)) + ylab(column) + geom_boxplot() +  
      coord_cartesian(ylim = c( round(min(temp[[column]],na.rm=T)-sd(temp[[column]],na.rm=T)),
                                round(max(temp[[column]],na.rm=T)+sd(temp[[column]],na.rm=T)))) +
      theme(text = element_text(size=10), axis.text=element_text(angle=0, vjust=1)) + theme(legend.position="none") + theme(axis.title.y = element_text(size = 12), axis.title.x = element_text(size=12))
    
    #save plots as .pdf file into user folder
pdf(file=paste(column,".pdf", sep = ""), onefile = F)
multiplot(histogram, scatterplot, boxplot, cols=1)
dev.off()
  }
}

