import flywheel

fwheudiconv = client.lookup('gears/fw-heudiconv')

rewardProj=client.projects.find_first('label=Reward2018')
rewardSes=rewardProj.sessions()

import datetime
now = datetime.datetime.now().strftime("%Y-%m-%d_%H:%M")

config_vals = {
  "action": 'Validate',
  "dry_run": False
}

analysis_ids = []
fails = []

for r in rewardSes:
    try:
        config = config_vals
        _id = fwheudiconv.run(analysis_label='validate_{}'.format(now), config=config, destination=r)
        analysis_ids.append(_id)
    except Exception as e:
        print(e)
        fails.append(s)
