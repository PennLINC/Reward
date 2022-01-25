import os

# create a key
def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes

# Create Keys

# T1 scans
t1w = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_T1w')

# Field maps
b0_phase = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_phase{item}')
b0_mag = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_magnitude{item}')

# fmri scans
effort_sbref = create_key(
    'sub-{subject}/{session}/func/sub-{subject}_{session}_task-effort_sbref')
effort_01 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-effort_run-01_bold')
effort_02 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-effort_run-02_bold')
effort_03 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-effort_run-03_bold')
effort_04 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-effort_run-04_bold')


# create the dictionary evaluate the heuristics
def infotodict(seqinfo):

    """Heuristic evaluator for determining which runs belong where
    allowed template fields - follow python string module:
    item: index within category
    subject: participant id
    seqitem: run number during scanning
    subindex: sub index within group
    """

    # create the heuristic
    info = {t1w: [], effort_01: [], effort_02: [], effort_03: [], effort_04: [],
            b0_mag: [], b0_phase: [], effort_sbref: []
            }
    for s in seqinfo:
        protocol = s.protocol_name.lower()
        # t1
        if "mprage" in protocol:
            info[t1w].append(s.series_id)

        # b0 maps
        elif ("b0map" in protocol) and ("P" in s.image_type):
            info [b0_phase].append(s.series_id)
        elif ("b0map" in protocol) and ("M" in s.image_type):
            info[b0_mag].append(s.series_id)

        # tasks
        # note: the dicom name is itc this is actually effort according to Dan (07/22/2019)
        elif "itc1" in protocol:
            info[effort_01].append(s.series_id)
        elif "itc2" in protocol:
            info[effort_02].append(s.series_id)
        elif "itc3" in protocol:
            info[effort_03].append(s.series_id)
        elif "itc4" in protocol:
            info[effort_04].append(s.series_id)

        # effort single band ref image
        elif "ep2d_single" in protocol:
            info[effort_sbref].append(s.series_id)
    return info

IntendedFor = {
    b0_mag: [
        '{session}/func/sub-{subject}_{session}_task-effort_sbref.nii.gz',
        '{session}/func/sub-{subject}_{session}_task-effort_run-01_bold.nii.gz',
        '{session}/func/sub-{subject}_{session}_task-effort_run-02_bold.nii.gz',
        '{session}/func/sub-{subject}_{session}_task-effort_run-03_bold.nii.gz',
        '{session}/func/sub-{subject}_{session}_task-effort_run-04_bold.nii.gz'],

    b0_phase: [
        '{session}/func/sub-{subject}_{session}_task-effort_sbref.nii.gz',
        '{session}/func/sub-{subject}_{session}_task-effort_run-01_bold.nii.gz',
        '{session}/func/sub-{subject}_{session}_task-effort_run-02_bold.nii.gz',
        '{session}/func/sub-{subject}_{session}_task-effort_run-03_bold.nii.gz',
        '{session}/func/sub-{subject}_{session}_task-effort_run-04_bold.nii.gz']
}

MetadataExtras = {
    b0_phase: {
        "EchoTime1": 0.00269,
        "EchoTime2": 0.00527
    },
    effort_sbref:{
        "TaskName": 'effort'
    },

    effort_01: {
        "TaskName": 'effort'
    },

    effort_02: {
        "TaskName": 'effort'
    },

    effort_03: {
        "TaskName": 'effort'
    },

    effort_04: {
        "TaskName": 'effort'
    }
}
