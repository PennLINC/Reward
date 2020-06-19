#!/bin/bash

# This script allows a user to subset BBLIDs to run fw-heudiconv on Reward2018.
# Note that PHI was taken out of this script.
# Replace words with all caps with appropriate information.

subjects=(BBLIDS) # substitute BBLIDs with list of bblids for fw-heudiconv

for i in "${subjects[@]}";
do
# note for following line,
# replace HEURISTIC with the .py file containing the heuristic for fw-heudiconv
# replace SESSION with session
echo $(fw-heudiconv-curate --project "Reward2018" --heuristic "HEURISTIC" --session "SESSION" --subject "$i")
#echo "$i";
done
