# Scan & Task Files Documentation
# This R script creates one large spreadsheet of scans with their associated task files.
# Please note that the original code was partitioned into different sections ran on R Notebook.
# However, this script is in .R form to avoid PHI. 

# Load libraries
library(dplyr)

# Read in spreadsheet and subset to relevant files
fw_audit <- read.csv("rewardFlywheelAudit.csv")
fw_nifti <- fw_audit %>% subset(type == "nifti")
fw_task <- fw_audit %>% subset(type == "text" | type == "log")

# Check for appropriate number of scans.
# Function for doing so:
check_num_scans <- function(scan_df){
  temp_df <- scan_df %>%  group_by(bblid, proj) %>%  summarise(n())
  if (nrow(temp_df) == 509){
    print("All scans are present.")
  } else {
    print (paste0("Missing number of scans: ", (509 - nrow(temp_df))))
  }
} 
# Run code:
check_num_scans(fw_nifti)

# Classify the scans
source("classify_scans.R")
source("classify_task.R")

# Make sure all scans are characters
fw_nifti %>% mutate_all(as.character)
fw_task %>% mutate_all(as.character)

# Match task files to scans 
fw_scan_task <- full_join(fw_nifti, fw_task, by=c("bblid","proj", "task"))

# Clean the dataframe
scans <- fw_scan_task %>%
  subset(type.x == "nifti") %>% 
  group_by(bblid, proj, file.x, type.x, bids.x, mod.x, task, file.y,is_task) %>%
  summarise(n())
scans

# Clean up the dataframe to output
names(scans)=c("bblid","project","scan_file","is_nifti","bids","modality","file_type","assoc_task_file","is_task","count")
scans

# Create a new variable to make easier to subset missing task files
scans$is_missing <-
  ifelse((scans$is_task=="task") & is.na(scans$assoc_task_file), "missing", "hasTask")

# Summarise missingness of task files
missing_doc <- scans %>%
  subset(is_missing == "missing") %>%
  group_by(bblid, project, is_missing) %>%
  summarise(n()) %>%
  arrange(desc(`n()`))
missing_doc

# Output CSV of all scans and associated task files
write.csv(scans, "fwScansTask_20200624.csv")

# Output CSV of summary count of missing task files
write.csv(missing_doc, "missingTaskFiles_20200625.csv")