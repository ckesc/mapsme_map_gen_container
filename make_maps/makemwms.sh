#! /bin/bash

function tc_begin {
	echo -e "\n##teamcity[progressStart '$1']"
}

function tc_end {
	echo -e "\n##teamcity[progressFinish '$1']"
}

function tc_publish {
	echo -e "\n##teamcity[publishArtifacts '$1']"
}

echo -e "\n========================= GET RUSSIA FILE ==========================="
tc_begin 'Download russia'

if [ ! -e RU.osm.pbf ]
then
  echo -e "Download Russia pbf file"
  wget http://data.gis-lab.info/osm_dump/dump/latest/RU.osm.pbf
else
  echo -e "Found Russia pbf file"
fi
tc_end 'Download russia'

echo -e "\n======================== MAKE REGION FILES ==========================="
tc_begin 'Make region files'
if [ ! -d data ]
then
  mkdir data
fi

for FILE in borders/*
do  
  FILENAME=$(basename "$FILE")
  FILEPBF="${FILENAME%.*}.pbf"
  tc_begin "Make region $FILE"

  if [ ! -e "data/$FILEPBF" ]
  then
    echo -e "\nMake '$FILEPBF' file"
    osmconvert RU.osm.pbf  --complete-ways --complex-ways -B="$FILE" -v -o="data/$FILEPBF"
  else
    echo -e "\nFound '$FILEPBF' file"
  fi
  tc_end "Make region $FILE"
  echo ""
done
tc_end 'Make region files'

echo -e "\n========================= UPDATE REGION FILES ========================"
tc_begin 'Update region files'
cd data

for FILE in *
do
  tc_begin "Update region $FILE"
  osmupdate "$FILE" "${FILE}.new" --hour --day --keep-tempfiles -v && \
  rm "$FILE" && \
  cp "${FILE}.new" "$FILE" && \
  rm "${FILE}.new"
  tc_end "Update region $FILE"
  echo " "
done
cd ..
tc_end 'Update region files'

echo -e "\n======================== MAKE MWM FILES =============================="
tc_begin 'Make mwm'
for FILE in borders/*
do
  FILENAME=$(basename "$FILE")
  FILEPBF="${FILENAME%.*}.pbf"
  FILEMWM="${FILENAME%.*}.mwm"
  tc_begin "Make mwm $FILENAME"

  echo "Make $FILEMWM"
  ../omim/tools/unix/generate_mwm.sh "data/$FILEPBF"
  # docker run --rm -t -v $PWD:/srv/data "lcat/mwm" "data/$FILEPBF"
  tc_publish "data/$FILEMWM"
  tc_end "Make mwm $FILENAME"
  echo " "
done
tc_end 'Make mwm files'