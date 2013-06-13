#!/bin/bash

set -e

CONFIGS=$(cd ../configs && pwd)

ALL_CONFIGS=($(find $CONFIGS -name "_config.yml"))

if [[ ${#ALL_CONFIGS[@]} -lt 1 ]]; then
    echo "No config files."
    exit
else
    echo "Found ${#ALL_CONFIGS[@]} config files in ${CONFIGS}."
fi

PRINT()
{
    let COL=$(tput cols)-${#1}
    printf "%s%${COL}s\n" "$1" "[$2]"
}

for CONFIG in "${ALL_CONFIGS[@]}"
do
    PRINT "${CONFIG}" "PROCESSING"
    sed -i.bak "25 i\\
# 自定首页公司简介段落\\
# homepage_about: |\\
#   全能保险柜是以从事保险柜（箱）等安防产品为主的现代化保险柜...\\
\\
# 自定关于我们页面内容，默认是读取 _includes/about_company.md\\
# about: |\\
#   广东安能保险柜制造有限公司是...\\
\\
#   公司控股工业集团创始于1935年...\\
\\
#   经过多年的持续发展，公司已跻身...\\
\\
" $CONFIG
    rm -f "$CONFIG.bak"
    printf "\e[1A"
    PRINT "${CONFIG}" "DONE"
    exit
done
