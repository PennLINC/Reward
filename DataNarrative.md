---
title: Data Narrative
layout: template
filename: DataNarrative
--- 

# Transfer Process

The data were acquired at the University of Pennsylvania as part of Reward study. Access was given
to PennLINC as part of the joint project *Discovering Replicable and Robust Brain Activity Differences Between High and Low Discounters*. 

The data was transferred from Flywheel to CUBIC using the Flywheel CLI tool and scripts available in `~/working/code/flywheel_transfer`. 

The approximate date of transfer was June 14 2021. 
Before curation on CUBIC, the data in `~/original_data` was:


```python
!du -chs ~/original_data
```

    82G	/cbica/projects/wolf_satterthwaite_reward/original_data
    82G	total



```python
import bids
import glob

datasets = glob.glob("/cbica/projects/wolf_satterthwaite_reward/original_data/bidsdatasets/*/")
datasets = [x[x[:-1].rfind('/'):] for x in datasets]
```

The following sub projects are contained within the dataset:


```python
[x[1:-1] for x in datasets]
```




    ['neff', 'nodra', 'fndm1', 'day2x2', 'fndm2', 'neffx2', 'neff2x2', 'day2']




```python
dfs = []

for x in datasets:
    
    path = '/cbica/projects/wolf_satterthwaite_reward/original_data/bidsdatasets/' + x
    layout = bids.BIDSLayout(path, validate=False)
    dfs.append(layout.to_df())
    
import pandas as pd

projects = pd.concat(dfs)
```

    /cbica/projects/wolf_satterthwaite_reward/miniconda3/envs/reward/lib/python3.8/site-packages/bids/layout/models.py:148: FutureWarning: The 'extension' entity currently excludes the leading dot ('.'). As of version 0.14.0, it will include the leading dot. To suppress this warning and include the leading dot, use `bids.config.set_option('extension_initial_dot', True)`.
      warnings.warn("The 'extension' entity currently excludes the leading dot ('.'). "


The project has the following number of subjects:


```python
len(set(projects.subject))
```




    304



Across this range of sessions:


```python
set(projects.session)
```




    {'day2', 'day2x2', 'fndm1', 'fndm2', nan, 'neff', 'neff2x2', 'neffx2', 'nodra'}



The following datatypes were available (with the number of files of the type shown below):


```python
projects.groupby('suffix').size()
```




    suffix
    T1w             876
    T2w               6
    bold           4314
    description       8
    dwi              12
    magnitude1      846
    magnitude2      846
    phase1          640
    phase2          630
    phasediff       220
    sbref           298
    dtype: int64



The imaging data was
organised in BIDS and not anonymized at the time
of transfer. 



```python
fields = """Acknowledgements
AcquisitionDateTime
AcquisitionMatrixPE
AcquisitionNumber
AcquisitionTime
Authors
BIDSVersion
BandwidthPerPixelPhaseEncode
BaseResolution
CoilString
ConversionSoftware
ConversionSoftwareVersion
DatasetDOI
DeidentificationMethod
DerivedVendorReportedEchoSpacing
DeviceSerialNumber
DwellTime
EchoNumber
EchoTime
EchoTime1
EchoTime2
EchoTrainLength
EffectiveEchoSpacing
FlipAngle
Funding
HowToAcknowledge
ImageOrientationPatientDICOM
ImageType
ImagingFrequency
InPlanePhaseEncodingDirectionDICOM
InstitutionAddress
InstitutionName
InstitutionalDepartmentName
IntendedFor
InversionTime
License
MRAcquisitionType
MagneticFieldStrength
Manufacturer
ManufacturersModelName
Modality
Name
ParallelReductionFactorInPlane
PartialFourier
PatientPosition
PatientSex
PercentPhaseFOV
PhaseEncodingDirection
PhaseEncodingSteps
PhaseResolution
PixelBandwidth
ProcedureStepDescription
ProtocolName
PulseSequenceDetails
ReceiveCoilName
ReconMatrixPE
RefLinesPE
ReferencesAndLinks
RepetitionTime
SAR
ScanOptions
ScanningSequence
SequenceName
SequenceVariant
SeriesDescription
SeriesInstanceUID
SeriesNumber
ShimSetting
SliceThickness
SliceTiming
SoftwareVersions
SpacingBetweenSlices
StationName
StudyID
StudyInstanceUID
TaskName
TotalReadoutTime
TxRefAmp
template
Acknowledgements
AcquisitionDateTime
AcquisitionMatrixPE
AcquisitionNumber
AcquisitionTime
Authors
BIDSVersion
BaseResolution
ConversionSoftware
ConversionSoftwareVersion
DatasetDOI
DeidentificationMethod
DeviceSerialNumber
EchoTime
FlipAngle
Funding
HowToAcknowledge
ImageOrientationPatientDICOM
ImageType
ImagingFrequency
InPlanePhaseEncodingDirectionDICOM
InstitutionAddress
InstitutionName
InversionTime
License
MRAcquisitionType
MagneticFieldStrength
Manufacturer
ManufacturersModelName
Modality
Name
PartialFourier
PatientPosition
PatientSex
PercentPhaseFOV
PhaseEncodingSteps
PhaseResolution
PixelBandwidth
ProcedureStepDescription
ProtocolName
PulseSequenceDetails
ReceiveCoilName
ReconMatrixPE
ReferencesAndLinks
RepetitionTime
SAR
ScanOptions
ScanningSequence
SequenceName
SequenceVariant
SeriesDescription
SeriesInstanceUID
SeriesNumber
ShimSetting
SliceThickness
SoftwareVersions
StationName
StudyID
StudyInstanceUID
TxRefAmp
template
Acknowledgements
AcquisitionDateTime
AcquisitionMatrixPE
AcquisitionNumber
AcquisitionTime
Authors
BIDSVersion
BandwidthPerPixelPhaseEncode
BaseResolution
CoilString
ConversionSoftware
ConversionSoftwareVersion
DatasetDOI
DeidentificationMethod
DerivedVendorReportedEchoSpacing
DeviceSerialNumber
DwellTime
EchoNumber
EchoTime
EchoTime1
EchoTime2
EffectiveEchoSpacing
FlipAngle
Funding
HowToAcknowledge
ImageOrientationPatientDICOM
ImageType
ImagingFrequency
InPlanePhaseEncodingDirectionDICOM
InstitutionAddress
InstitutionName
InstitutionalDepartmentName
IntendedFor
InversionTime
License
MRAcquisitionType
MagneticFieldStrength
Manufacturer
ManufacturersModelName
Modality
Name
ParallelReductionFactorInPlane
PartialFourier
PatientPosition
PatientSex
PercentPhaseFOV
PhaseEncodingDirection
PhaseEncodingSteps
PhaseResolution
PixelBandwidth
ProcedureStepDescription
ProtocolName
PulseSequenceDetails
ReceiveCoilName
ReconMatrixPE
RefLinesPE
ReferencesAndLinks
RepetitionTime
SAR
ScanOptions
ScanningSequence
SequenceName
SequenceVariant
SeriesDescription
SeriesInstanceUID
SeriesNumber
ShimSetting
SliceThickness
SliceTiming
SoftwareVersions
SpacingBetweenSlices
StationName
StudyID
StudyInstanceUID
TaskName
TotalReadoutTime
TxRefAmp
template
Acknowledgements
AcquisitionDateTime
AcquisitionMatrixPE
AcquisitionNumber
AcquisitionTime
Authors
BIDSVersion
BandwidthPerPixelPhaseEncode
BaseResolution
ConversionSoftware
ConversionSoftwareVersion
DatasetDOI
DeidentificationMethod
DerivedVendorReportedEchoSpacing
DeviceSerialNumber
DwellTime
EchoNumber
EchoTime
EchoTime1
EchoTime2
EffectiveEchoSpacing
FlipAngle
Funding
HowToAcknowledge
ImageOrientationPatientDICOM
ImageType
ImagingFrequency
InPlanePhaseEncodingDirectionDICOM
InstitutionAddress
InstitutionName
InstitutionalDepartmentName
IntendedFor
InversionTime
License
MRAcquisitionType
MagneticFieldStrength
Manufacturer
ManufacturersModelName
Modality
Name
ParallelReductionFactorInPlane
PartialFourier
PatientPosition
PatientSex
PercentPhaseFOV
PhaseEncodingDirection
PhaseEncodingSteps
PhaseResolution
PixelBandwidth
ProcedureStepDescription
ProtocolName
PulseSequenceDetails
ReceiveCoilName
ReconMatrixPE
RefLinesPE
ReferencesAndLinks
RepetitionTime
SAR
ScanOptions
ScanningSequence
SequenceName
SequenceVariant
SeriesDescription
SeriesInstanceUID
SeriesNumber
ShimSetting
SliceThickness
SliceTiming
SoftwareVersions
SpacingBetweenSlices
StationName
StudyID
StudyInstanceUID
TaskName
TotalReadoutTime
TxRefAmp
template
Acknowledgements
AcquisitionDateTime
AcquisitionMatrixPE
AcquisitionNumber
AcquisitionTime
Authors
BIDSVersion
BandwidthPerPixelPhaseEncode
BaseResolution
CoilString
ConversionSoftware
ConversionSoftwareVersion
DatasetDOI
DeidentificationMethod
DerivedVendorReportedEchoSpacing
DeviceSerialNumber
DwellTime
EchoNumber
EchoTime
EchoTime1
EchoTime2
EffectiveEchoSpacing
FlipAngle
Funding
HowToAcknowledge
ImageOrientationPatientDICOM
ImageType
ImagingFrequency
InPlanePhaseEncodingDirectionDICOM
InstitutionAddress
InstitutionName
InstitutionalDepartmentName
IntendedFor
InversionTime
License
MRAcquisitionType
MagneticFieldStrength
Manufacturer
ManufacturersModelName
Modality
Name
ParallelReductionFactorInPlane
PartialFourier
PatientPosition
PatientSex
PercentPhaseFOV
PhaseEncodingDirection
PhaseEncodingSteps
PhaseResolution
PixelBandwidth
ProcedureStepDescription
ProtocolName
PulseSequenceDetails
ReceiveCoilName
ReconMatrixPE
RefLinesPE
ReferencesAndLinks
RepetitionTime
SAR
ScanOptions
ScanningSequence
SequenceName
SequenceVariant
SeriesDescription
SeriesInstanceUID
SeriesNumber
ShimSetting
SliceThickness
SliceTiming
SoftwareVersions
SpacingBetweenSlices
StationName
StudyID
StudyInstanceUID
TaskName
TotalReadoutTime
TxRefAmp
template
Acknowledgements
AcquisitionDateTime
AcquisitionMatrixPE
AcquisitionNumber
AcquisitionTime
Authors
BIDSVersion
BandwidthPerPixelPhaseEncode
BaseResolution
CoilString
ConversionSoftware
ConversionSoftwareVersion
DatasetDOI
DeidentificationMethod
DerivedVendorReportedEchoSpacing
DeviceSerialNumber
DwellTime
EchoNumber
EchoTime
EchoTime1
EchoTime2
EffectiveEchoSpacing
FlipAngle
Funding
HowToAcknowledge
ImageOrientationPatientDICOM
ImageType
ImagingFrequency
InPlanePhaseEncodingDirectionDICOM
IntendedFor
License
MRAcquisitionType
MagneticFieldStrength
Manufacturer
ManufacturersModelName
Modality
Name
PartialFourier
PatientPosition
PatientSex
PercentPhaseFOV
PhaseEncodingDirection
PhaseEncodingSteps
PhaseResolution
PixelBandwidth
ProcedureStepDescription
ProtocolName
PulseSequenceDetails
ReceiveCoilName
ReconMatrixPE
RefLinesPE
ReferencesAndLinks
RepetitionTime
SAR
ScanOptions
ScanningSequence
SequenceName
SequenceVariant
SeriesDescription
SeriesInstanceUID
SeriesNumber
ShimSetting
SliceThickness
SliceTiming
SoftwareVersions
SpacingBetweenSlices
StudyID
StudyInstanceUID
TaskName
TotalReadoutTime
TxRefAmp
template
Acknowledgements
AcquisitionDateTime
AcquisitionMatrixPE
AcquisitionNumber
AcquisitionTime
Authors
BIDSVersion
BandwidthPerPixelPhaseEncode
BaseResolution
ConversionSoftware
ConversionSoftwareVersion
DatasetDOI
DerivedVendorReportedEchoSpacing
DeviceSerialNumber
EchoNumber
EchoTime
EffectiveEchoSpacing
FlipAngle
Funding
HowToAcknowledge
ImageOrientationPatientDICOM
ImageType
ImagingFrequency
InPlanePhaseEncodingDirectionDICOM
IntendedFor
InversionTime
License
MRAcquisitionType
MagneticFieldStrength
Manufacturer
ManufacturersModelName
Modality
Name
PartialFourier
PatientPosition
PatientSex
PercentPhaseFOV
PhaseEncodingDirection
PhaseEncodingSteps
PhaseResolution
PixelBandwidth
ProcedureStepDescription
ProtocolName
PulseSequenceDetails
ReceiveCoilName
ReconMatrixPE
RefLinesPE
ReferencesAndLinks
RepetitionTime
SAR
ScanOptions
ScanningSequence
SequenceName
SequenceVariant
SeriesDescription
SeriesInstanceUID
SeriesNumber
ShimSetting
SliceThickness
SliceTiming
SoftwareVersions
SpacingBetweenSlices
StudyID
StudyInstanceUID
TaskName
TotalReadoutTime
TxRefAmp
template
Acknowledgements
AcquisitionDateTime
AcquisitionMatrixPE
AcquisitionNumber
AcquisitionTime
Authors
BIDSVersion
BandwidthPerPixelPhaseEncode
BaseResolution
CoilString
ConversionSoftware
ConversionSoftwareVersion
DatasetDOI
DeidentificationMethod
DerivedVendorReportedEchoSpacing
DeviceSerialNumber
DwellTime
EchoNumber
EchoTime
EchoTime1
EchoTime2
EffectiveEchoSpacing
FlipAngle
Funding
HowToAcknowledge
ImageComments
ImageOrientationPatientDICOM
ImageType
ImagingFrequency
InPlanePhaseEncodingDirectionDICOM
InstitutionAddress
InstitutionName
InstitutionalDepartmentName
IntendedFor
License
MRAcquisitionType
MagneticFieldStrength
Manufacturer
ManufacturersModelName
Modality
MultibandAccelerationFactor
Name
ParallelReductionFactorInPlane
PartialFourier
PatientPosition
PatientSex
PercentPhaseFOV
PhaseEncodingDirection
PhaseEncodingSteps
PhaseResolution
PixelBandwidth
ProcedureStepDescription
ProtocolName
PulseSequenceDetails
ReceiveCoilName
ReconMatrixPE
RefLinesPE
ReferencesAndLinks
RepetitionTime
SAR
ScanOptions
ScanningSequence
SequenceName
SequenceVariant
SeriesDescription
SeriesInstanceUID
SeriesNumber
ShimSetting
SliceThickness
SliceTiming
SoftwareVersions
SpacingBetweenSlices
StationName
StudyID
StudyInstanceUID
TaskName
TotalReadoutTime
TxRefAmp
template

""".split('\n')
```

## Anonymization

Using `bond-print-metadata-fields`, we found the following fields in JSON sidecars:


```python
set(fields)
```




    {'',
     'Acknowledgements',
     'AcquisitionDateTime',
     'AcquisitionMatrixPE',
     'AcquisitionNumber',
     'AcquisitionTime',
     'Authors',
     'BIDSVersion',
     'BandwidthPerPixelPhaseEncode',
     'BaseResolution',
     'CoilString',
     'ConversionSoftware',
     'ConversionSoftwareVersion',
     'DatasetDOI',
     'DeidentificationMethod',
     'DerivedVendorReportedEchoSpacing',
     'DeviceSerialNumber',
     'DwellTime',
     'EchoNumber',
     'EchoTime',
     'EchoTime1',
     'EchoTime2',
     'EchoTrainLength',
     'EffectiveEchoSpacing',
     'FlipAngle',
     'Funding',
     'HowToAcknowledge',
     'ImageComments',
     'ImageOrientationPatientDICOM',
     'ImageType',
     'ImagingFrequency',
     'InPlanePhaseEncodingDirectionDICOM',
     'InstitutionAddress',
     'InstitutionName',
     'InstitutionalDepartmentName',
     'IntendedFor',
     'InversionTime',
     'License',
     'MRAcquisitionType',
     'MagneticFieldStrength',
     'Manufacturer',
     'ManufacturersModelName',
     'Modality',
     'MultibandAccelerationFactor',
     'Name',
     'ParallelReductionFactorInPlane',
     'PartialFourier',
     'PatientPosition',
     'PatientSex',
     'PercentPhaseFOV',
     'PhaseEncodingDirection',
     'PhaseEncodingSteps',
     'PhaseResolution',
     'PixelBandwidth',
     'ProcedureStepDescription',
     'ProtocolName',
     'PulseSequenceDetails',
     'ReceiveCoilName',
     'ReconMatrixPE',
     'RefLinesPE',
     'ReferencesAndLinks',
     'RepetitionTime',
     'SAR',
     'ScanOptions',
     'ScanningSequence',
     'SequenceName',
     'SequenceVariant',
     'SeriesDescription',
     'SeriesInstanceUID',
     'SeriesNumber',
     'ShimSetting',
     'SliceThickness',
     'SliceTiming',
     'SoftwareVersions',
     'SpacingBetweenSlices',
     'StationName',
     'StudyID',
     'StudyInstanceUID',
     'TaskName',
     'TotalReadoutTime',
     'TxRefAmp',
     'template'}



Below is the list of fields that were removed using `bond-remove-metadata-fields`:

```AcquisitionDateTime AcquisitionTime InstitutionAddress InstitutionName InstitutionalDepartmentName Name PatientPosition PatientSex StationName StudyID StudyInstanceUID```


```python

```
