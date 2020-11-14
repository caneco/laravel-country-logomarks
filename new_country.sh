#!/bin/bash
# 'return' when run as "source <script>" or ". <script>", 'exit' otherwise
[[ "$0" != "${BASH_SOURCE[0]}" ]] && safe_exit="return" || safe_exit="exit"

script_name=$(basename "$0")
current_directory=$(pwd)

ask(){
    # ask <question> <default>
    local ANSWER
    read -r -p "$1: " ANSWER
    echo "${ANSWER:-$2}"
}

confirm(){
    # confirm <question> (default = N)
    local ANSWER
    read -r -p "$1 (y/N): " -n 1 ANSWER
    echo " "
    [[ "$ANSWER" =~ ^[Yy]$ ]]
}

country_code=$(ask "Country code?")
country_code=`echo "$country_code" | tr '[:upper:]' '[:lower:]'`
country_path="$current_directory/src/$country_code"

# if [ -d "$current_directory/src/$country_code" ] ; then
#     echo "Country folder already exists!"
#     $safe_exit 1
# fi

country_name=$(ask "Country name?")
echo "Country: $country_name"

cp -R "$current_directory/stubs/new_country" "$country_path"
echo
files=$(grep -E -r -l -i ":country_name" $country_path/*)
for file in $files ; do
    echo "UPDATING: $file"
    temp_file="$file.temp"
    < "$file" sed "s/:country_name/$country_name/g" > "$temp_file"
    rm -f "$file"
    mv "$temp_file" "$file"
done

mv "$country_path/README.md.stub" "$country_path/README.md"

echo
echo 'DONE!'
