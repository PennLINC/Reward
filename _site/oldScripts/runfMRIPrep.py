# Import Flywheel

import flywheel
import pandas

fw = flywheel.Client()

# Import Gear
# Note that this is the fMRIPrep gear specific for scans with b0 phase 1 and 2 images. This part should be replaced with the newer gear version on Flywheel.
fmriprep_b0 = fw.lookup('gears/fmriprep-phases')
fmriprep_b0

# Import Reward2018
rewardProj=fw.projects.find_first('label=Reward2018')
rewardSes=rewardProj.sessions()

# Gear-specific setups

import datetime
now = datetime.datetime.now().strftime("%Y-%m-%d_%H:%M")

## Freesurfer license
with open("license.txt") as f:
    freesurfer_lic = f.read()

## Configurations

config_vals = {
  'FREESURFER_LICENSE': freesurfer_lic,
  "cifti_output": True,
  "force_bbr": True,
  'save_outputs': True
}

analysis_ids = []
fails = []

# Run fMRIPrep

import datetime
now = datetime.datetime.now().strftime("%Y-%m-%d_%H:%M")

# Freesurfer license
with open("license.txt") as f:
    freesurfer_lic = f.read()

analysis_ids = []
fails = []

for r in rewardSes:
    try:
        config = config_vals
        inputs = {

            "freesurfer_license": rewardProj.files[0],

        }
        _id = fmriprep_b0.run(analysis_label='fmriprep-phases_SDK_{}_{}'.format(r.label, now), config=config, inputs=inputs, destination=r)
        analysis_ids.append(_id)
    except Exception as e:
        print(e)
        fails.append(s)
