# create a key
def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes

# ASL
pcasl = create_key('sub-{subject}/{session}/perf/sub-{subject}_{session}_asl') 

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
    info = {pcasl: []}
    for s in seqinfo:
        protocol = s.protocol_name.lower()

        if ("pcasl" in protocol) and ("MOCO" not in s.image_type):
            info[pcasl].append(s.series_id)

    return info

MetadataExtras = {
    pcasl: {
        'ArterialSpinLabelingType': 'PCASL',
        "LabelingDuration": 1.5088,
        "PostLabelingDelay": 1.2,
        "BackgroundSuppression": False,
        'M0Type': 'Absent', 
        "TotalAcquiredPairs": 40,
        "RepetitionTimePreparation": 4.0
    }    
}

def AttachToSession():

    NUM_VOLUMES=40
    data = ['label', 'control'] * NUM_VOLUMES
    data = '\n'.join(data)
    data = 'volume_type\n' + data # the data is now a string; perfect!

    output_file = {

      'name': '{subject}/{session}/perf/{subject}_{session}_aslcontext.tsv',
      'data': data,
      'type': 'text/tab-separated-values'
    }

    return output_file