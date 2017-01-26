# excelDate2GeneName

In case you are working with gene lists previously modified in Excel chances are that 3 genes classes are modified, e.g. SEPT1, DEC1, MARCH1 into dates Sep-01, Dec-01, Mar-01. Here is the simple script to correct this. Script will test if gene names are lower or upper cases and if they are lower cases they will be converted to upper cases, followed by the conversion of SEP- and SEP-0 to SEPT, MAR- and MAR-0 to MARCH, and DEC- and DEC-0 to DEC. Output will contain oriiginal gene list in upper cases corrected for Excel conversions. Output is in saved in .corrected file.

```sh
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

```
##Usage
<pre>
$cat genes.file
Tcf21	11
Tcf22	13
Tcf23	43
Ahr1	233
Ahr2	23
Dec-01	2
Dec-11	45
Sep-11	2
Sep-09	1342
Mar-13	2
Mar-11	22

$chmod 755 excelDate2GeneName.sh

$ ./excelDate2GeneName.sh genes.file
TCF21 11
TCF22 13
TCF23 43
AHR1 233
AHR2 23
DEC1 2
DEC11 45
SEPT11 2
SEPT9 1342
MARCH13 2
MARCH11 22
</pre>
