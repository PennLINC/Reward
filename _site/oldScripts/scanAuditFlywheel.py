# NOTE: Highly recommend breaking this script into pieces and going through in a Jupyter notebook.

# Imports Flywheel and the Reward2018 project

import flywheel
fw = flywheel.Client()

rewardProj=fw.projects.find_first('label=Reward2018') # Reward project
rewardSes=rewardProj.sessions() # Reward sessions

# Gathers all necessary Information
records = {"bblid": [], "proj": [], "file": [], "type": [], "bids": [], "mod": []}

for ses in rewardSes:
    acq=ses.acquisitions()
    subject=fw.get(ses.parents.subject)
    subid=subject.label
    subproject=ses.label
    for a in acq:
        rwdFiles=a.files
        for f in rwdFiles:
            file_name=f.name
            file_type = f.type
            bids_name=get_nested(f.to_dict(), 'info', 'BIDS', 'Filename')
            modality=get_nested(f.to_dict(), 'info', 'BIDS', 'Modality')
            # update dictionary with new values
            records["bblid"].append(subid)
            records["proj"].append(subproject)
            records["file"].append(file_name)
            records["type"].append(file_type)
            records["bids"].append(bids_name)
            records["mod"].append(modality)

# Construct a dataframe

import pandas as pd

file_df = pd.DataFrame(data=records)
file_df.head()

for ses in rewardSes:
    subject=fw.get(ses.parents.subject)
    subid=subject.label
    subproject=ses.label
    acquisitions=ses.acquisitions()
    for a in acquisitions:
        try:
            for analysis in acquisitions.analyses:
                print(analysis)
        except:
            continue

# Outputs dataset
file_df.to_csv(r'rewardFlywheelAudit.csv')
