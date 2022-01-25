---
title: Legacy Curation (2018-2020)
layout: default
filename: anna
has_toc: true
nav_order: 2
--- 

# Reward Documentation (2020)
Last updated: July 1, 2020 <br>
Written by Anna Xu

Reward is a dataset comprised of 6 projects collected over the span of years, totaling 509 participants (note that some participants were present in multiple projects). These are the 6 projects with the scans available in them:
* **FNDM1**: T1w, ASL, b0 phase 1 and 2, b0 magnitude, resting-state, task fMRI (face run 1 and 2; card run 1 and 2)
* **FNDM2**: T1w, b0 phase 1 and 2, b0 magnitude, resting-state, task fMRI (itc runs 1-4)
* **NEFF**: T1w, b0 phasediff, b0 magnitude, task fMRI (effort runs 1-4)
  * Note that 15 participants from FNDM2 have been reclassified into NEFF because they are neff pilots identified by Dan
* **NEFF2**: T1w, b0 phasediff, b0 magnitude, task fMRI (effort runs 1-4)
* **NODRA**: T1w, b0 phasediff, b0 magnitude, resting-state, task fMRI (card runs 1-2, itc runs 1-2)
  * Note that some participants have multiband resting-state scans while others have single band or both
* **DAY2**: T1w, ASL, b0 phase 1 and 2, b0 magnitude, resting-state, task fMRI (face run 1 and 2; card run 1 and 2), and DTI for very few participants (n<20)

## Imaging & Task Data Status (Flywheel)

## Scan data & associated task behavioral data

### Completeness

All scan data found on XNAT and associated task behavioral data found on XNAT or CfN has been uploaded onto Flywheel in the project `Reward2018`. Scan data was de-identified by uploading with the command `fw import dicom ${dicomUploadPath} mcieslak "Reward2018" --subject ${bblid} --session ${subproject} -y --profile "dicom_config.yaml"` in the command line and with the configuration file `dicom_config.yaml` found on Flywheel in `Reward2018 > Information`.

The following procedure checked to make sure all expected scans on XNAT were accounted for on Flywheel:
* All participants on XNAT were cross-checked with all participants on Flywheel to ensure that each expected participant in Reward had their scans on Flywheel.
* For each individual participant, completeness of scans were checked. If a participant did not have all the scans expected based on the project they were from, the missing scans were checked for on XNAT. If they existed on XNAT, the scans were uploaded onto Flywheel. If they were *not* on XNAT, they were documented on an excel file found on Flywheel in `Reward2018 > information > missingScans_20200624.xls` with any notes from XNAT documented.
  * This excel file contains the sheet `missingScanNotes` which details the bblid, project, scan missing, reason for scan missing (either not on xnat, upload error, or excluded participant), notes from xnat, and notes I've written.
  * The other sheet on this spreadsheet is `missingScanCount` which contains the number of scans missing for each particular scan in each project.

Scanid for each participant has also been noted in the custom info for each subject/session.

### Fw-heudiconv

These scans have also been fw'heudiconv-ed using [these heuristics](https://github.com/PennLINC/Reward/tree/master/oldScripts/annaHeuristics2019) and the command `fw-heudiconv-curate --project "Reward2018" --heuristic "${heuristicFile}" --session "${subproject}" --subject "${bblid}"`.

You can also use the script [subsetFwheudiconv.sh](https://github.com/PennLINC/Reward/blob/master/oldScripts/annaHeuristics2019/subsetFwheudiconv.sh) to mass run fw-heudiconv for a select few participants.

### fMRIPrep
Some scans have been processed with an old version of fMRIPrep but all scans may need to be fMRIPrep'd again with the latest version of fMRIPrep. [runfMRIPrep.py](https://github.com/PennLINC/Reward/blob/master/oldScripts/runfMRIPrep.py) details the previous process of running fMRIPrep.

### Task files
Files documenting all nifti scans and their associated task behavioral data can be found on Flywheel in the file `fwScansTask_20200624.csv`. This file is located in `Reward2018 > Information` and contains the following variables:
* `bblid`, `projects`
* `scan_file`: name of the nifti
* `bids`: BIDS name of the nifti
* `file_type`: type of scan (e.g., b0 magnitude, resting-state, etc.)
* `assoc_task_file`: name of task file uploaded onto Flywheel that is associated with the particular scan
* `is_task`: tells you whether the scan is a task fMRI scan
* `is_task_missing`: tells you whether the associated task file for a task fMRI scan is missing.

Another file, `missingTaskFiles_20200625.csv` documents a summary of the missing task files. This file is currently on the `reward_data_mgmt` slack channel (unsure if this is also on the Reward2018 project on Flywheel due to inability to check Flywheel before my departure). This file contains the following:
* `is_missing`: tells you whether the participant is missing is missing a task file, but since this spreadsheet is just of participants missing a task behavioral file, they all are
* `n()`: tells you how many task behavioral files associated with a participant is missing

If needed, [scanAuditFlywheel.py](https://github.com/PennLINC/Reward/blob/master/oldScripts/scanAuditFlywheel.py) goes through the process of generating a large spreadsheet of all files present in the Reward2018 project. To generate these associated files, use the script [scanTaskDocumentation.R](https://github.com/PennLINC/Reward/blob/master/oldScripts/scanTaskDocumention.R) which sources code from [classify_scans.R](https://github.com/PennLINC/Reward/blob/master/oldScripts/classify_scans.R) and [classify_task.R](https://github.com/PennLINC/Reward/blob/master/oldScripts/classify_task.R).

## Other data

### Demographics, Medication Status, Diagnosis

Demographics, medication status, diagnosis, and effort data are currently with Dan (not uploaded anywhere). Missing data has been previously reported in the `reward_data_mgmt` slack channel.

### Aylin's Monster

Aylin's monster scripts can be found in the Reward GitHub repo by clicking [here](https://github.com/PennLINC/Reward/tree/master/oldScripts/aylinsMonster). A wiki page of old documentation for Aylin's monster can be found [here](https://github.com/PennLINC/Reward/wiki/Aylin's-Monster-(OLD)).
