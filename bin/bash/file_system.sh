#!/bin/bash
set -euo pipefail
########################################################################################################################
# File Related Functions                                                                                               #
########################################################################################################################

##########################################################################################
# Symlink Functions                                                                      #
##########################################################################################

function create_symlink_if_necessary() {
    local source_file_path="$1"
    local target_file_path="$2"

    local source_file_name
    source_file_name=$(basename "$source_file_path")
    echo "Now setting up symlink for $source_file_path to $target_file_path"

    if [ -L "$target_file_path" ]; then
        if [ "$(readlink "$target_file_path")" -ef "$source_file_path" ] ; then
           echo "Symlink already exists and points to the correct target."
           return 0
        fi

        echo "Symlink exists, but points to an incorrect location, will remove and recreate"
        rm "$target_file_path"
    fi

    if [ -e "$target_file_path" ] ; then
        echo "File already exists but is not a symlink. Doing nothing"
        return 0
    fi

    if [ -e "$source_file_path" ] ; then
        echo "Creating a symlink now."
        sudo ln -s "$source_file_path" "$target_file_path"
    else
        echo "File ${source_file_name} not found. Skipping symlink creation"
    fi

    return 0
}

function create_symlink_if_necessary_into_dir() {
    local source_file_path="$1"
    local target_folder="$2"
    
    local source_file_name
    source_file_name=$(basename "$source_file_path")
    local target_file_path="$target_folder/$source_file_name"

    echo "Figuring out symlink details to symlink $source_file_path into $target_folder"

  create_symlink_if_necessary $source_file_path $target_file_path
  return 0
}

function symlink_or_symlink_as_alt_name_as_necessary() {
    local source_file_path="$1"
    local target_folder="$2"
    
    local source_file_name
    source_file_name=$(basename "$source_file_path")
    local target_file_path="$target_folder/$source_file_name"

    echo "Figuring out symlink details to symlink $source_file_path into $target_folder"

    if [ -e "$target_file_path" ] ; then
        local target_file_name="${source_file_name:1}"
        target_file_name=".personal_${target_file_name}"
        local renamed_file_path="$target_folder/$target_file_name"

        echo "File already exists but is not a symlink. Will symlink as ${target_file_name}"

        create_symlink_if_necessary $source_file_path $renamed_file_path
        return 0
    fi

  create_symlink_if_necessary $source_file_path $target_file_path
  return 0
}

function remove_symlinks_of_source_file() {
    echo ""

    local source_file_path="$1"
    # Use $HOME as the default search location if a search path isnt provided
    local search_path="${2:-$HOME}"

    if [ ! -f $source_file_path ]; then
      echo "source_file_path: '${source_file_path}' does not exist. Skipping!"
      return 0
    fi

    if [ ! -d $search_path ]; then
      echo "search_path '${search_path}' directory does not exist. Skipping!"
      return 0
    fi

    echo "Checking to remove symlinks of $source_file_path at search path of $search_path"

    while IFS= read -r -d '' file_found; do
        echo "Found $file_found in $search_path that has the same file link as $source_file_path"
        if [ "$(readlink "$file_found")" -ef "$source_file_path" ] ; then
            echo "Removing symlink of $source_file_path found at $file_found"
            sudo rm "$file_found"
        fi
    done < <(find -L "$search_path" -maxdepth 1 -samefile "$source_file_path" -print0)
}

##########################################################################################
# Find Functions                                                                         #
##########################################################################################

function find_directory_with_highest_build_number() {
  local directory_to_search="$1"
  local build_name="$2"

  cd "$directory_to_search"

  local latest_build_directory
  latest_build_directory=$(find . -maxdepth 1 -name "*${build_name}[0-9]*" -type d | sed "s/.\/${build_name}//" | sort -n | tail -1)

  echo "${build_name}${latest_build_directory}"
}

function find_files_with_same_name() {
  local directory_to_search="$1"
  local exception="$2"

  if [ -z ${directory_to_search} ]; then
    echo "directory_to_search was not supplied. Skipping find!"
    return
  fi

  if [ -z ${exception} ]; then
    ls ${directory_to_search} | sed 's/.\{4\}$//' | sort | uniq -d
  else
    ls ${directory_to_search} |  awk "!/${exception}/"  | sed 's/.\{4\}$//' | sort | uniq -d
  fi
}

# find a file with a pattern in name:
function ff() { /usr/bin/find . -type f -iname '*'$*'*' -ls ; }

# find a directory with a pattern in name:
function fd() { /usr/bin/find . -type d -iname '*'$*'*' -ls ; }

# find a file with pattern $1 in name and Execute $2 on it:
function fe() { /usr/bin/find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }

#############################################
# Size Related Find Functions               #
#############################################

# list all files larger than input value otherwise use default of 10MB
function find_large_files_bigger_than() {
  local filesLargerThanSize="${1:-10M}"

  find / -size "+${filesLargerThanSize}" -ls
}

# list all files larger than the first input value but less than the second input value otherwise use defaults of 10MB and 200MB
function find_large_files_between() {
  local filesLargerThanSize="${1:-10M}"
  local filesSmallerThanSize="${2:-200M}"

  find / -size "+${filesLargerThanSize}" -size "-${filesSmallerThanSize}" -ls
}

# Example usage list_50_largest_files "./.nvm/*"
function find_50_largest_folders() {
  local excludeDirs="${1:-}" # example "./mnt/*""

  excludeDirsFlag=""
  if [ ! -z ${excludeDirs+x} ]; then
    excludeDirsFlag="--exclude=$excludeDirs"
  fi

  du -aBM "$excludeDirsFlag" | sort -nr | head -n 50 | more
}

function find_largest_folders() {
  local excludeDirs="${1:-}" # example "./mnt/*""

  excludeDirsFlag=""
  if [ ! -z ${excludeDirs+x} ]; then
    excludeDirsFlag="--exclude=$excludeDirs"
  fi

  du -aBM "$excludeDirsFlag" | sort -nr | more
}

function find_largest_files() {
  ls -1Rhs | sed -e "s/^ *//" | grep "^[0-9]" | sort -hr | head -n20
}

function find_50_largest_files() {
  du -aBM 2>/dev/null | sort -nr | head -n 50 | more
}

##########################################################################################
# Create/Move Functions                                                                  #
##########################################################################################

function create_directory_for_all_files_sharing_name() {
  local directory_to_search="$1"
  local exception="$2"

  uniq_file_names_array=()

	while IFS= read -r line; do
    uniq_file_names_array+=( "$line" )
	done < <( find_files_with_same_name $directory_to_search $exception )

	for index in "${!uniq_file_names_array[@]}"; do
    unqiue_file=${uniq_file_names_array[index]}
    echo "Creating Directory named: $unqiue_file"
		mkdir -p "$directory_to_search/$unqiue_file"
  done
}

function move_files_with_name_into_directory() {
  local directory_to_search="$1"
	local destination="$2"
  local exception="$3"

  uniq_file_names_array=()

	while IFS= read -r line; do
    uniq_file_names_array+=( "$line" )
	done < <( find_files_with_same_name $directory_to_search $exception )

	for index in "${!uniq_file_names_array[@]}"; do
    unqiue_file=${uniq_file_names_array[index]}
    echo "Moving files named: $unqiue_file* to $destination"
		mv "${directory_to_search}/${unqiue_file}"* "$destination"
  done
}

function create_directory_and_move_files_for_all_files_sharing_name() {

  local directory_to_search="$1"
  local exception="$2"

  uniq_file_names_array=()

	while IFS= read -r line; do
    uniq_file_names_array+=( "$line" )
	done < <( find_files_with_same_name $directory_to_search $exception )

	pushd "${directory_to_search}"
	for index in "${!uniq_file_names_array[@]}"; do
    unqiue_file=${uniq_file_names_array[index]}
    echo "Creating Directory named: $unqiue_file"
		mkdir -p "$unqiue_file"
		IFS=$'\n'
		mv "${unqiue_file}"* "${unqiue_file}"
  done

  popd
}

function create_new_parent_directory_for_file_for_all_files_in_directory() {
  for file in *; do
    # if file is a directory then skip it
    [[ -d "$file" ]] && continue
    create_new_parent_directory_for_file "$file"
  done
}

function create_new_parent_directory_for_file() {
	local file="$1"
  ext=${file##*.}
  filenamenoext=$(basename "$file" ".$ext")
  echo "Creating Directory named: $filenamenoext"
  mkdir -p "$filenamenoext"
  echo "Moving File: $file to directory: $filenamenoext"
  mv "${file}" "${filenamenoext}"
}

##########################################################################################
# File Name Functions                                                                    #
##########################################################################################

function remove_substring_from_directory_name() {

  local directory_to_search="$1"
  local substring_to_remove="$2"

	cd "${directory_to_search}"

  for dir in */; do # Loop through all directories in the current directory
      # Remove the trailing slash for cleaner name handling
      dir_name="${dir%/}"

      # Check if the directory name does NOT contain the substring
      if [[ "$dir_name" =~ "$substring_to_remove" ]]; then
          NEW_DIR_NAME=${dir_name//"$substring_to_remove"}
          echo "Renaming '$dir_name' to '$NEW_DIR_NAME'"
          mv "$dir_name" "$NEW_DIR_NAME"
      fi
  done
}

function replace_substring_from_directory_name() {

  local directory_to_search="$1"
  local substring_to_remove="$2"
  local substring_to_replace_with="$3"

	cd "${directory_to_search}"

  for dir in */; do # Loop through all directories in the current directory
      # Remove the trailing slash for cleaner name handling
      dir_name="${dir%/}"

      # Check if the directory name does NOT contain the substring
      if [[ "$dir_name" =~ "$substring_to_remove" ]]; then
          NEW_DIR_NAME=${file_name/"$substring_to_remove"/"$substring_to_replace_with"}
          echo "Renaming '$dir_name' to '$NEW_DIR_NAME'"
          mv "$dir_name" "$NEW_DIR_NAME"
      fi
  done
}

function remove_substring_from_file_name() {

  local directory_to_search="$1"
  local substring_to_remove="$2"

	cd "${directory_to_search}"

  for file_name in "${directory_to_search}"/*; do # Loop through all files in the current directory
      if [[ "$file_name" =~ "$substring_to_remove" ]]; then
          NEW_DIR_NAME=${file_name//"$substring_to_remove"}
          echo "Renaming '$file_name' to '$NEW_DIR_NAME'"
          mv "$file_name" "$NEW_DIR_NAME"
      fi
  done
}

function replace_substring_from_file_name() {

  local directory_to_search="$1"
  local substring_to_remove="$2"
  local substring_to_replace_with="$3"

	cd "${directory_to_search}"

  for file_name in "${directory_to_search}"/*; do # Loop through all files in the current directory
      if [[ "$file_name" =~ "$substring_to_remove" ]]; then
          new_file_name=${file_name/"$substring_to_remove"/"$substring_to_replace_with"}
          echo "Renaming '$file_name' to '$new_file_name'"
          mv "$file_name" "$new_file_name"
      fi
  done
}

##########################################################################################
# File Meta Functions                                                                    #
##########################################################################################

function get_number_of_files_in_directory() {
  find . -maxdepth 1 -type d | while read -r dir; do printf "%s:\t" "$dir"; find "$dir" -type f | wc -l; done
}

function create_tars_of_every_directory() {
  for file in *; do
    sudo tar czf $file.tar -C $file .
  done
}
