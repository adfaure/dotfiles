# Script used to install dotfiles of the project.
# Calling install.sh will load mapping.txt, and install files
# according to their description.
#
# mapping.txt organizes files as follow:
# filename=path/into/env
# otherfile=$HOME/.myconf
#
# empty line are not allowed, howerver it is possible to use
# variable such as $HOME. If you the script as sudoer, please remenber to use `sudo -E ` so the environement is kept.

MAPPING=`cat mapping.txt`
backup_dir="./backup"

function instal_file {
  if [ -f $2 ]; then
    bak_file=./backup/$(basename $1).bak
    echo "$2 already exist... Creating a copy into $bak_file"
    cat $2 > $bak_file
    rm $2
  fi

  echo "create link for $1 to the location $2"
  folder_file=$(dirname $2)
  if ! [ -d $folder_file ]; then
    echo "Folder $folder_file does not exist yet, creating..."
    mkdir -p $folder_file
  fi
  ln -sf `pwd`/files/$1 $2
}

if ! [ -d $backup_dir ]; then
  mkdir $backup_dir
fi

for map in $MAPPING
do
  echo ""
  path=$(eval "echo ${map#*=}")
  file=${map%=*}
  instal_file $file $path
  echo ""
done
