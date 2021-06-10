#!/bin/bash

SESSION=$1 # the sub study eg fndm1

echo Beginning data transfer from Flywheel...

DEST=$HOME/original_data/bidsdatasets/$SESSION 

if [ ! -d $DEST ] 
then
    echo Creating Directory...
    mkdir -p $DEST
fi

echo running: fw export bids $DEST --project Reward2018 --session $SESSION

fw export bids $DEST --project Reward2018 --session $SESSION