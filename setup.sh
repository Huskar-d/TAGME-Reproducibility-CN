#!/bin/sh
TAGME_HOME=/home/wangxin/entity_linking/TAGME-Reproducibility_bak/;

flag=2;
if [ $flag == 1 ]; then
	#pre-process the dumps.
	cd $TAGME_HOME;
	python ${TAGME_HOME}/lib/wikiextractor-master/WikiExtractor.py -o ${TAGME_HOME}/data/processed-20190220/ -l ${TAGME_HOME}/../../kg_data/wikipedia/zhwiki-20190220-pages-articles.xml.bz2;
	cd -;
fi

echo 'indexing Wikipedia articles';
flag=2;
if [ $flag == 1 ]; then
	#Index of Wikipedia articles (with resolved URIs)
	cd $TAGME_HOME;
	python -m nordlys.wikipedia.indexer -i data/processed-20190220/ -o data/20190220-index/;
	cd -;
fi
echo 'complete';

echo 'indexing Wikipedia only annotations';
flag=2;
if [ $flag == 1 ]; then
	#Index containing only Wikipedia annotations.
	cd $TAGME_HOME;
	python -m nordlys.wikipedia.indexer -a -i data/preprocessed-20190220/ -o data/20190220-index-annot/;
	cd -;
fi
echo 'complete'

flag=2;
if [ $flag == 1 ]; then
	#extract the redirect pages from the original dump
	cd ${TAGME_HOME}/lib/edu.cmu.lti.wikipedia_redirect
	javac src/edu/cmu/lti/wikipedia_redirect/*.java
	java -cp src edu.cmu.lti.wikipedia_redirect.WikipediaRedirectExtractor /home/wangxin/kg_data/wikipedia/zhwiki-20190220-pages-articles.xml
	mv ${TAGME_HOME}lib/edu.cmu.lti.wikipedia_redirect/target/zhwiki-redirect.txt ${TAGME_HOME}data/redirect-20190220/
	cd -
fi

flag=2;
if [ $flag == 1 ]; then
	#The anchor texts file are extracted using the following commands
	cd $TAGME_HOME
	python -m nordlys.wikipedia.annot_extractor -i data/processed-20190220/ -o data/annotations-20190220/
	python -m nordlys.wikipedia.anchor_extractor -i data/annotations-20190220/ -o data/anchors_count-20190220/
	cd -
fi

flag=2;
if [ $flag == 1 ]; then
	#extracts page id and title for all Wikipedia articles
	cd $TAGME_HOME
	python -m nordlys.wikipedia.pageid_extractor -in data/processed-20190220/ -o data/page-id-titles-20190220/
	cd -
fi

flag=2;
if [ $flag == 1 ]; then
	cd $TAGME_HOME
	python -m nordlys.wikipedia.merge_sf -redirects data/redirect-20190220/zhwiki-redirect.txt -anchors data/anchors_count-20190220/anchors_count.txt -titles data/page-id-titles-20190220/page-id-titles.txt -o data/sf_dict-20190220
	cd -
fi
