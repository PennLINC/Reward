import os
import sys
import pandas as pd

path = sys.argv[1]

df = pd.read_csv(path, sep='\t')
df = df.drop(['patient_id', 'patient_age', 'patient_sex', 'date', 'series_uid'], axis=1)

df.to_csv(path, index=False, sep='\t')