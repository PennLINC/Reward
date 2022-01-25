#!/bin/bash

#prep
source activate reward

SESSION=$1 # the sub study eg fndm1

DEST=$HOME/curation/code/fw-heudiconv-tabulate_outputs/$SESSION 

if [ ! -d $DEST ] 
then
    echo Creating Directory...
    mkdir -p $DEST
fi

echo running tabulate...

fw-heudiconv-tabulate --project Reward2018 --session $SESSION --no-unique --path $DEST

python remove_tabulate_PHI.py $DEST/Reward2018_SeqInfo.tsv