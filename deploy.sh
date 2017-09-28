#!/usr/bin/env bash

source_path="$PWD/source/_posts"

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
&& echo -e "\033[33m =====will push commit to repository===== \033[0m" \
&& sleep 3s \
&& git add . \
&& git commit -m "${new_files[@]}" \
&& git push git@github.com:xxxxxMiss/xxxxxMiss.github.io.git master:gh-pages