#!/bin/bash

WEBSITES=(
"yzqnn.com.cn"
"hyqnn.com.cn"
"zqqnn.com.cn"
"suqnn.com.cn"
"qtqnn.com.cn"
"czqnn.cn"
"bjqnn.com.cn"
"scqnn.cn"
"lyqnn.cn"
"hzqnn.cn"
"wzqnn.com.cn"
"nmgqnn.com.cn"
"lfqnn.com.cn"
"dqqnn.com.cn"
"pzhqnn.com.cn"
"tyqnn.com.cn"
"jzqnn.com.cn"
"smqnn.com.cn"
"hnqnn.com.cn"
"lygqnn.com.cn"
"mmqnn.com.cn"
"nxqnn.com.cn"
"gllpqnn.cn"
"bhhpqnn.cn"
"xaqnn.com.cn"
"jnqnn.com.cn"
"zjqnn.com.cn"
"jnqnn.com.cn"
"zjqnn.com.cn"
"czqnn.com.cn"
"ptqnn.com.cn"
"hhqnn.com.cn"
"mzqnn.com.cn"
"hdqnn.com.cn"
"rgqnn.com.cn"
"dgqnn.cn"
"szqnn.com.cn"
"gzqnn.cn"
"ncqnn.cn"
"lzqnn.cn"
"ncqnn.com.cn"
"jmqnn.com.cn"
"ylqnn.com.cn"
"nlqnn.com.cn"
"xtqnn.com.cn"
"csqnn.cn"
"cqqnn.com.cn"
"ycqnn.com.cn"
"kmqnn.com.cn"
"cdqnn.com.cn"
"zhqnn.com.cn"
"plqnn.com.cn"
"lbqnn.com.cn"
"chqnn.com.cn"
"jyqnn.com.cn"
"pyqnn.com.cn"
"xmqnn.com.cn"
"zsqnn.com.cn"
"fsqnn.com.cn"
"zzqnn.com.cn"
"qzqnn.com.cn"
"lyqnn.com.cn"
"yyqnn.com.cn"
"njqnn.com.cn"
"fzqnn.com.cn"
"xxqnn.com.cn"
"cyqnn.com.cn"
"qzqnn.cn"
"tjqnn.com.cn"
"sdqnn.com.cn"
"lzqnn.com.cn"
"shqnn.com.cn"
"bxqnn.com.cn"
"wxqnn.com.cn"
"qyqnn.com.cn"
"dxqnn.com.cn"
"hzqnn.com.cn"
"sdqnn.cn"
"gzqnn.com.cn"
"swqnn.com.cn"
"hfqnn.com.cn"
"whqnn.com.cn"
"gyqnn.com.cn"
"zcqnn.com.cn"
"aqqnn.com.cn"
"xzqnn.com.cn"
"jsczqnn.cn"
"sgqnn.com.cn"
)

CONFIGS="$(pwd)/configs"

if [[ ! -d $CONFIGS ]]; then
	mkdir "$CONFIGS"
fi

for SITE in "${WEBSITES[@]}"
do
	if [[ ! -d "$CONFIGS/$SITE" ]]; then
		mkdir "$CONFIGS/$SITE"
		echo "$CONFIGS/$SITE created"
	fi
	if [[ ! -f "$CONFIGS/$SITE/_config.yml" ]]; then
		# clone config file
		cp "$(pwd)/sample_config.yml" "$CONFIGS/$SITE/_config.yml"
		
		if [[ ! -f "$CONFIGS/$SITE/_config.yml" ]]; then
			echo "$CONFIGS/$SITE/_config.yml is NOT OK."
			exit
		fi
		
		# replace url in config file
		sed -i.bak "s/url: http:\/\/www\.qnn\.com\.cn/url: http:\/\/www\.$SITE/g" "$CONFIGS/$SITE/_config.yml"
		rm -f "$CONFIGS/$SITE/_config.yml.bak"
		
		if [[ -f "$CONFIGS/$SITE/_config.yml" ]]; then
			echo "$CONFIGS/$SITE/_config.yml is OK."
		else
			echo "$CONFIGS/$SITE/_config.yml is NOT OK."
			exit
		fi
	fi
done
