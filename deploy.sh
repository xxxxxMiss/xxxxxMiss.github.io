#!/usr/bin/env bash

source_path="$PWD/source/_posts"
commit_msg=

file_names=$(find $source_path -type f -name "*.md" -mtime -1)

declare -a new_files

for name in $file_names; do
  base_name=${name##*/}
  file_name=${base_name%.*}
  new_files+=($file_name)
done

hexo clean \
&& hexo deploy \
&& echo -e "\033[32m =====deploy successed===== \033[0m" \
&& echo -e "\033[33m =====will push source code to repository===== \033[0m" \

select option in "Yes" "No"; do
  case $option in
    Yes )
    git add .

    if [[ -z ${#new_files[@]} ]]; then
      read -r -p "Enter a commit msg" msg
      commit_msg=$msg
    else
      commit_msg=${new_files[@]}
    fi

    git commit -m "${commit_msg}" \
    && git push git@github.com:xxxxxMiss/xxxxxMiss.github.io.git master:gh-pages
    ;;
    No )
    echo -e "\033[32m Bye! \033[0m"
    exit 0
    ;;
  esac
done

