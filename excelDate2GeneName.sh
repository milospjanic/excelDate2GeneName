#!/bin/bash

# change lower to upper cases function

function test_lower {
test=`echo $1 | grep [a-z]`
if [ "$?" = "0" ]; then
  #Lowercase letters found.
  #translate to upper case:
  echo $test | tr '[a-z]' '[A-Z]'
else
   #letters are all upper case, return them.
   echo $1
fi
}

# cut first column of the file containing the gene names
cut -f1 $1 > $1.cut
cut -f2- $1 > $1.cut2

# run test_lower on each line of .cut file

filename="$1.cut"

while read -r line
do
    name="$line"
    test_lower $name
done < "$filename" > $1.cut.mod

awk 'FNR==NR{a[FNR]=$1;next}{ print a[FNR], $0}' $1.cut.mod $1.cut2 > $1.upper

# replace Sep- and Sep-0 with gene name SEPT 
sed -E "s/(SEP-|SEP-0)/SEPT/g" $1.upper > $1.upper.sep
mv $1.upper.sep $1.upper

# replace Mar- and Mar-0 with gene name MAR 
sed -E "s/(MAR-|MAR-0)/MARCH/g" $1.upper > $1.upper.mar
mv $1.upper.mar $1.upper

# replace Dec- and Dec-0 with gene name DEC
sed -E "s/(DEC-|DEC-0)/DEC/g" $1.upper > $1.upper.dec
mv $1.upper.dec $1.corrected

rm $1.cut
rm $1.cut2
rm $1.cut.mod
