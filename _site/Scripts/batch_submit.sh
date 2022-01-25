#!/bin/bash

declare -a studies=("day2" 
                    "day2x2" 
                    "fndm1" 
                    "fndm2" 
                    "neff" 
                    "neff2x2" 
                    "neffx2" 
                    "nodra")

submission=$1

for i in "${studies[@]}"
do
    
    echo submitting: $submission $i
    qsub -V $submission $i

done