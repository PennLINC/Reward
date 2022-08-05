---
layout: default
title: Data Narrative
parent: CogTrain
nav_order: 1
---

# CogTrain
{: .no_toc}

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Data Processing Flow & Important Links:
* Flow diagram that describes the lifecycle of this dataset curation and preprocessing:

NA
   
# Plan for the Data 

* Why does PennLINC need this data?
> Acquired at UPenn

* Goal:
> Curate and preprocess an amalgam of datasets for a harmonized PennLINC resource

# Data Acquisition

* Data acquired by Joe Kable
* Describe the data:
   * number of subjects = 166
   * types of images = bold (4 runs task-RISK, 4 runs task-ITC, rest), T1w, fieldmaps, DWI

# Download and Storage 

* Original data available from Kable Lab
* Source data (NIfTI) on CUBIC in `/cbica/projects/wolf_satterthwaite_reward/original_data/bidsdatasets/CogTrain`.
* Data was copied to `/cbica/projects/wolf_satterthwaite_reward/Curation/bidsdatasets/CogTrain` and checked in to `datalad` after removing PHI (below)
* JSON's within origial_data were updated using `cubids-add-nifti-info`.

# Curation Process

* Data curation by Tinashe Tapera on the CUBIC project user `wolfsatterthwaitereward`
* Link to final CuBIDS csvs: NA

## BIDS Validation:

* BIDS validation output at `/cbica/projects/wolf_satterthwaite_reward/Curation/code/validate_outputs/CogTrain/CogTrain_validation_2.csv`:

    - INCONSISTENT_PARAMETERS ( Not all subjects/sessions/runs have the same scanning parameters. ) : 244 counts

    - PARTICIPANT_ID_PATTERN (Participant_id column labels must consist of the pattern "sub-<subject_id>".) : 166

Data at this stage were approved for preprocessing.

## BIDS Optimization:

* All cubids optimization results are available in `/cbica/projects/wolf_satterthwaite_reward/Curation/code/iterations/iter<ITERATION_NUMBER>/CogTrain/`

* Final optimization resulted in `/cbica/projects/wolf_satterthwaite_reward/Curation/code/iterations/iter1/CogTrain/CogTrain_summary.csv`

# Preprocessing Pipelines 

## fMRIPrep (version 20.2.3)
   * Tinashe Tapera was responsible for running preprocessing pipelines/audits on CUBIC

### Exemplar Testing:

* Used cubids to create exemplar dataset: `cubids-copy-exemplars /cbica/projects/wolf_satterthwaite_reward/Curation/bidsdatasets/CogTrain/BIDS /cbica/projects/wolf_satterthwaite_reward/Testing/CogTrain/exemplars_dir /cbica/projects/wolf_satterthwaite_reward/Curation/code/iterations/iter1/CogTrain/CogTrain_AcqGrouping.csv`
* Path to exemplar dataset (annexed to datalad): `/cbica/projects/wolf_satterthwaite_reward/Testing/CogTrain/exemplars_dir` 
* Path to fmriprep container: Original in `~/dropbox`, datalad in `/cbica/projects/wolf_satterthwaite_reward/Testing/exemplars_test/fmriprep-container`
   
Testing directory was deleted to save space on CUBIC on 12/2/21, once production completed
   
### Production Testing:

* 291/293 sessions completed fMRIPrep successfully
* Path to production inputs: `/cbica/projects/wolf_satterthwaite_reward/Curation/bidsdatasets/CogTrain/BIDS`
* Path to fmriprep run command: `/cbica/projects/wolf_satterthwaite_reward/Production/CogTrain/fmriprep-multises/analysis/code/fmriprep_zip.sh`
* Path to production outputs: `/cbica/projects/wolf_satterthwaite_reward/Production/CogTrain/fmriprep-multises/output_ria`
* Path to fmriprep production audit: `/cbica/projects/wolf_satterthwaite_reward/Production/CogTrain/fmriprep-multises-audit/FMRIPREP_AUDIT.csv`
* Path to freesurfer production audit: NA
      
## XCP-ABCD (version 0.0.8)
### Production Testing:

* 289/293 sessions completed XCP successfully
* Path to production inputs: `/cbica/projects/wolf_satterthwaite_reward/Curation/bidsdatasets/CogTrain/fmriprep-multises/merge_ds`
* Path to xcp run command: `/cbica/projects/wolf_satterthwaite_reward/Production/CogTrain/xcp-multises/analysis/code/xcp_zip.sh`
* Path to production outputs: `/cbica/projects/wolf_satterthwaite_reward/Production/CogTrain/xcp-multises/output_ria`
* Path to xcp production audit: NA
* Path to xcp derivatives: `/cbica/projects/wolf_satterthwaite_reward/Production/CogTrain/xcp-derivatives/XCP`
* Path to xcp derivatives (concatenated): NA

# Post Processing 
           
* Who is using the data/for which projects are people in the lab using this data?
   * Link to project page(s) here 
* For each post-processing analysis that has been run on this data, fill out the following
   * Who performed the analysis?
   * Where it was performed (CUBIC, PMACS, somewhere else)?
   * GitHub Link(s) to result(s)
   * Did you use pennlinckit?  
      * https://github.com/PennLINC/PennLINC-Kit/tree/main/pennlinckit           

### To Do 
   * backup to PMACS
   * Add task events files
