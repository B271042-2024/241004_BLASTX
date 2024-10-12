#!/bin/bash

FILE=$1
BASENAME=$(basename "$FILE" .fasta)

echo ""
echo "          /\ 00"
echo "            o  "
echo "           \_/ "
echo ""

echo "##############################"
echo ""
echo "Performing BLASTX on file: ${FILE}"

if [ -f "${BASENAME}_blastx.out" ]; then
	echo ""
	echo "BLASTX was previously performed with an output File: ${BASENAME}_blast.out"
else
	echo "May take more than 5 mins depending on file size"
	blastx -query "${FILE}" -remote -db nr -outfmt 7 > "${BASENAME}_blastx.out"
	echo ""
	echo "BLASTX done"
	echo "------------------------------"
fi

echo ""
echo "          /\ 01"
echo "            o  "
echo "           \_/ "
echo ""

echo "##############################"
echo ""
echo "Analysis 1: List of Subject Accession"

if [ -f "${BASENAME}_analysis1.txt" ]; then
	echo ""
	echo "The file: ${BASENAME} exist and will be replaced"
	rm "${BASENAME}_analysis1.txt"
	echo "Creating new list..."
else
	echo ""
	echo "Creating the list..."
fi

grep "# Fields:" "${BASENAME}_blastx.out" | awk 'BEGIN {FS=": "}{gsub(", ", "\t", $2); print $2}' | awk 'BEGIN {FS="\t"}{print $2}' > "${FOLDER}/${BASENAME}_analysis1.txt"
awk 'BEGIN {FS="\t"}{if($5){print $2}}' "${BASENAME}_blastx.out" >> "${BASENAME}_analysis1.txt"

echo ""
echo "Analysis 1: done. Output file: ${BASENAME}_analysis1.txt"
echo "------------------------------"

echo ""
echo "          /\ 02"
echo "            o  "
echo "           \_/ "
echo ""

echo "##############################"
echo ""
echo "Analysis 2: Alignment and % identity"

if [ -f "${BASENAME}_analysis2.txt" ]; then
        echo ""
        echo "The file: ${BASENAME}_analysis2.txt exists and will be replaced"
        rm "${BASENAME}_analysis2.txt"
        echo "Creating new list..."
else
        echo ""
        echo "Creating the list..."
fi

grep "# Fields: " "${BASENAME}_blastx.out" | awk 'BEGIN {FS=": "}{gsub(", ", "\t", $2); print $2}' | awk 'BEGIN {FS="\t"}{print $1,$4,$3}' > "${BASENAME}_analysis2.txt"
awk 'BEGIN {FS="\t"}{if($5){print $1,$4,$3}}' "${BASENAME}_blastx.out" >> "${BASENAME}_analysis2.txt"

echo ""
echo "Analysis 2: done. Output file: ${BASENAME}_analysis2.txt"
echo "------------------------------"

echo ""
echo "          /\ 03"
echo "            o  "
echo "           \_/ "
echo ""

echo "##############################"
echo ""
echo "Analysis 3: HSPs with >20 mismatches"

if [ -f "${BASENAME}_analysis3.txt" ]; then
        echo ""
        echo "The file: ${BASENAME}_analysis3.txt exists and will be replaced"
        rm "${BASENAME}_analysis3.txt"
        echo "Creating new list..."
else
        echo ""
        echo "Creating the list..."
fi

grep "# Fields: " "${BASENAME}_blastx.out" | awk 'BEGIN {FS=": "}{gsub(", ", "\t", $2); print $2}' | awk 'BEGIN {FS="\t"}{print $1,$2,$5}' > "${BASENAME}_analysis3.txt"
awk 'BEGIN {FS="\t"}{if($5 > 20){print $1,$2,$5}}' "${BASENAME}_blastx.out" >> "${BASENAME}_analysis3.txt"

echo ""
echo "Analysis 3: done. Output file: ${BASENAME}_analysis3.txt"
echo "------------------------------"

echo ""
echo "          /\ 04"
echo "            o  "
echo "           \_/ "
echo ""

echo "##############################"
echo ""
echo "Analysis 4: HSPs with <100 AA and >20 mismatches"

if [ -f "${BASENAME}_analysis4.txt" ]; then
        echo ""
        echo "The file: ${BASENAME}_analysis4.txt exists and will be replaced"
        rm "${BASENAME}_analysis4.txt"
        echo "Creating new list..."
else
        echo ""
        echo "Creating the list..."
fi

grep "# Fields: " "${BASENAME}_blastx.out" | awk 'BEGIN {FS=": "}{gsub(", ", "\t", $2); print $2}' | awk 'BEGIN {FS="\t"}{print $1,$2,$4,$5}' > "${BASENAME}_analysis4.txt"
awk 'BEGIN {FS="\t"}{if($4 < 100 && $5 > 20){print $1,$2,$4,$5}}' "${BASENAME}_blastx.out" >> "${BASENAME}_analysis4.txt"

echo ""
echo "Analysis 4: done. Output file: ${BASENAME}_analysis4.txt"
echo "------------------------------"

echo ""
echo "          /\ 05"
echo "            o  "
echo "           \_/ "
echo ""

echo "##############################"
echo ""
echo "Analysis 5: The first 20 HSPs with <20 mismatches"

if [ -f "${BASENAME}_analysis5.txt" ]; then
        echo ""
        echo "The file: ${BASENAME}_analysis5.txt exists and will be replaced"
        rm "${BASENAME}_analysis5.txt"
        echo "Creating new list..."
else
        echo ""
        echo "Creating the list..."
fi

grep "# Fields: " "${BASENAME}_blastx.out" | awk 'BEGIN {FS=": "}{gsub(", ", "\t", $2); print $2}' | awk 'BEGIN {FS="\t"}{print $1,$2,$5}' > "${BASENAME}_analysis5.txt"
sort -t $'\t' -k 5 "${BASENAME}_blastx.out" | awk 'BEGIN {FS="\t"}{if($5 < 20){print $1,$2,$5}}' | head -20 >> "${BASENAME}_analysis5.txt"

echo ""
echo "Analysis 5: done. Output file: ${BASENAME}_analysis5.txt"
echo "------------------------------"

echo ""
echo "          /\ 06"
echo "            o  "
echo "           \_/ "
echo ""

echo "##############################"
echo ""
echo "Analysis 6: HSP counts with <100 AA"

if [ -f "${BASENAME}_analysis6.txt" ]; then
        echo ""
        echo "The file: ${BASENAME}_analysis6.txt exists and will be replaced"
        rm "${BASENAME}_analysis6.txt"
        echo "Creating new list..."
else
        echo ""
        echo "Creating the list..."
fi

echo "Total HSPs with <100 AA:" > "${BASENAME}_analysis6.txt"
awk 'BEGIN {FS="\t"}{if($4 < 100){print $1,$2,$4}}' "${BASENAME}_blastx.out" | wc -c >> "${BASENAME}_analysis6.txt"

echo ""
echo "          /\ 07"
echo "            o  "
echo "           \_/ "
echo ""

echo "##############################"
echo ""
echo "Analysis 7: Top 10 HSPs"

if [ -f "${BASENAME}_analysis7.txt" ]; then
        echo ""
        echo "The file: ${BASENAME}_analysis7.txt exists and will be replaced"
        rm "${BASENAME}_analysis7.txt"
        echo "Creating new list..."
else
        echo ""
        echo "Creating the list..."
fi

grep "# Fields: " "${BASENAME}_blastx.out" | awk 'BEGIN {FS=": "}{gsub(", ", "\t", $2); print $2}' > "${BASENAME}_analysis7.txt"
awk 'BEGIN {FS="\t"}{if($4){print $0}}' "${BASENAME}_blastx.out" | head -10 >> "${BASENAME}_analysis7.txt"

echo ""
echo "          /\ 08"
echo "            o  "
echo "           \_/ "
echo ""

echo "##############################"
echo ""
echo "Analysis 8: Start positions of all matches where HSP subject accession includes \"AEI\""

if [ -f "${BASENAME}_analysis8.txt" ]; then
        echo ""
        echo "The file: ${BASENAME}_analysis8.txt exists and will be replaced"
        rm "${BASENAME}_analysis8.txt"
        echo "Creating new list..."
else
        echo ""
        echo "Creating the list..."
fi

grep "# Fields: " "${BASENAME}_blastx.out" | awk 'BEGIN {FS=": "}{gsub(", ", "\t", $2); print $2}' | awk 'BEGIN {FS="\t"}{print $2,$9}'  > "${BASENAME}_analysis8.txt"
awk 'BEGIN {FS="\t"}{if($2 ~ "AEI"){print $2,$9}}' "${BASENAME}_blastx.out" >> "${BASENAME}_analysis8.txt"

echo ""
echo "          /\ 09"
echo "            o  "
echo "           \_/ "
echo ""

echo "##############################"
echo ""
echo "Analysis 9: Subject counts with >1 HSPs"

if [ -f "${BASENAME}_analysis9.txt" ]; then
        echo ""
        echo "The file: ${BASENAME}_analysis9.txt exists and will be replaced"
        rm "${BASENAME}_analysis9.txt"
        echo "Creating new list..."
else
        echo ""
        echo "Creating the list..."
fi

echo "Total subjects with >1 HSPs" > "${BASENAME}_analysis9.txt"
awk 'BEGIN {FS="\t"}{print $2}' "${BASENAME}_blastx.out" | sort | uniq -d | wc -c >> "${BASENAME}_analysis9.txt"

echo ""
echo "          /\ 10"
echo "            o  "
echo "           \_/ "
echo ""

echo "##############################"
echo ""
echo "Analysis 10: Percentage of each HSP made up of mismatches"

if [ -f "${BASENAME}_analysis10.txt" ]; then
        echo ""
        echo "The file: ${BASENAME}_analysis10.txt exists and will be replaced"
        rm "${BASENAME}_analysis10.txt"
        echo "Creating new list..."
else
        echo ""
        echo "Creating the list..."
fi

echo "" > "${BASENAME}_analysis10.txt"
awk 'BEGIN {FS="\t"}{if($5 && $5 > 0){print $0}}' "${BASENAME}_blastx.out" | wc -c > "temp1.txt"
awk 'BEGIN {FS="\t"}{if($5){print $0}}' "${BASENAME}_blastx.out" | wc -c >> "temp1.txt"
target=$(head -1 "temp1.txt")
total=$(tail -n 1 "temp1.txt")
if [ "$total" > 0 ]; then
	percentage=$((target/total * 100))
	echo "%HSPs with mismatches" > "${BASENAME}_analysis10.txt"
	echo "${percentage}" >> "${BASENAME}_analysis10.txt"
	echo "%HSPs with mismatches: ${percentage}%"
else
	echo "Operation cannot be performed. Total = 0" >> "${BASENAME}_analysis10.txt"
fi
rm "temp1.txt"

echo ""
echo "          /\ 11"
echo "            o  "
echo "           \_/ "
echo ""

echo "##############################"
echo ""
echo "Analysis 11: Grouped based on scores"

if [ -f "${BASENAME}_analysis11.txt" ]; then
        echo ""
        echo "The file: ${BASENAME}_analysis11.txt exists and will be replaced"
        rm "${BASENAME}_analysis11.txt"
        echo "Creating new list..."
else
        echo ""
        echo "Creating the list..."
fi

grep "Fields" "${BASENAME}_blastx.out" | awk 'BEGIN {FS="# Fields: "}{print $2}' > "${BASENAME}_analysis11.txt"

#begins
awk -v output="${BASENAME}_analysis11.txt" 'BEGIN {FS="\t"; prev=""; number=1}{
	if ($12){
		if ($12 != "" && prev != $12){
			print number " Score " $12 >> output
			number++
		}
	print $0 >> output
	prev = $12
	}
}' "${BASENAME}_blastx.out"
#ends





#grep "# Fields:" "${BASENAME}_blastx.out" | awk 'BEGIN {FS=": "}{gsub(", ", "\t", $2); print $2}' > "${BASENAME}_analysis1.txt"
