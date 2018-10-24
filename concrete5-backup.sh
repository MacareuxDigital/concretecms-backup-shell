#!/bin/sh
#
# concrete5 backup shell:
# ----------
# Version 2.1
# By katzueno

# INSTRUCTION:
# ----------
# https://github.com/katzueno/concrete5-backup-shell

# USE IT AT YOUR OWN RISK!

set -e

# VARIABLES
# ----------
NOW_TIME=$(date "+%Y%m%d%H%M%S")
WHERE_TO_SAVE="/var/www/html/backup"
WHERE_IS_CONCRETE5="/var/www/html/www"
FILE_NAME="katzueno"
MYSQL_SERVER="localhost"
MYSQL_NAME="database"
MYSQL_USER="root"
# MYSQL_PASSWORD="pass"

# ==============================
#
# DO NOT TOUCH BELOW THIS LINE (unless you know what you're doing.)
#
# ==============================

# ---- Checking The Options -----
BASE_PATH=''
if [ "$2" = "-a" ] || [ "$2" = "--absolute" ]; then
    BASE_PATH="${WHERE_IS_CONCRETE5}"
elif [ "$2" = "-r" ] || [ "$2" = "--relative" ] || [ "$2" = "" ]; then
    BASE_PATH="."
else
    NO_2nd_OPTION="1"
fi

if [ "$1" = "--all" ] || [ "$1" = "-a" ]; then
    echo "c5 Backup: You've chosen the ALL option. Now we're backing up all concrete5 directory files."
    TAR_OPTION="${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.sql ${BASE_PATH}/"
    NO_OPTION="0"
elif [ "$1" = "--packages" ] || [ "$1" = "--package" ] || [ "$1" = "-p" ]; then
    echo "c5 Backup: You've chosen the PACKAGE option. Now we're backing up the SQL, application/ and packages/ folder."
    TAR_OPTION="${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.sql ${BASE_PATH}/application/ ${BASE_PATH}/packages/"
    NO_OPTION="0"
elif [ "$1" = "--database" ] || [ "$1" = "-d" ]; then
    echo "c5 Backup: You've chosen the DATABASE option. Now we're only backing up the SQL file."
    TAR_OPTION="${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.sql"
    NO_OPTION="0"
elif [ "$1" = "--file" ] || [ "$1" = "-files" ] || [ "$1" = "-f" ] || [ "$1" = "" ]; then
    echo "c5 Backup: You've chosen the DEFAULT FILE option. Now we're backing up the SQL and application/files."
    TAR_OPTION="${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.sql ${BASE_PATH}/application/files/"
    NO_OPTION="0"
elif [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "
    ====================
    c5 Backup: Options
    ====================
    --------------------
    First Option
    --------------------
    --files OR --file OR -f: back up a SQL and the files in application/files. This is default option.
    --all OR -a: back up a SQL and all files under WHERE_IS_CONCRETE5 path
    --database OR -d: back up only a SQL dump
    --packages OR --package OR -p: back up a SQL, and the files in application/, packages/
    --help OR -h: This help option.
    --------------------
    Second Option
    --------------------
    -r OR --relative: This is default option. You can leave this option blank
    -a OR --absolute: The script will execute using absolute path. Zip file may contain the folder structure
    
    * Second option is optional. You must specify 1st option if you want to specify 2nd option.
    ====================
    
    Have a good day! from katzueno.com
"
    exit
else
    NO_OPTION="1"
fi

if [ "$NO_OPTION" = "1" ] || [ "$NO_2nd_OPTION" = "1" ]; then
    echo "c5 Backup ERROR: You specified WRONG OPTION. Please try 'sh backup.sh -h' for the available options."
    exit
fi

# ---- Checking Variable -----
echo "c5 Backup: Checking variables..."
if [ -z "$WHERE_TO_SAVE" ] || [ "$WHERE_TO_SAVE" = " " ]; then
    echo "c5 Backup ERROR: WHERE_TO_SAVE variable is not set"
    exit
fi
if [ -z "$WHERE_IS_CONCRETE5" ] || [ "$WHERE_IS_CONCRETE5" = " " ]; then
    echo "c5 Backup ERROR: WHERE_IS_CONCRETE5 variable is not set"
    exit
fi
if [ -z "$NOW_TIME" ] || [ "$NOW_TIME" = " " ]; then
    echo "c5 Backup ERROR: NOW_TIME variable is not set"
    exit
fi
if [ -z "$MYSQL_SERVER" ] || [ "$MYSQL_SERVER" = " " ]; then
    echo "c5 Backup ERROR: MYSQL_SERVER variable is not set"
    exit
fi
if [ -z "$MYSQL_USER" ] || [ "$MYSQL_USER" = " " ]; then
    echo "c5 Backup ERROR: MYSQL_USER variable is not set"
    exit
fi
if [ -z "$MYSQL_NAME" ] || [ "$MYSQL_NAME" = " " ]; then
    echo "c5 Backup ERROR: MYSQL_NAME variable is not set"
    exit
fi

# ---- Starting shell -----
echo "===================="
echo "c5 Backup: USE IT AT YOUR OWN RISK!"
echo "===================="
echo "c5 Backup:"
echo "c5 Backup: Starting concrete5 backup..."

# ---- Executing the commands -----
echo "c5 Backup: Switching current directory to"
echo "${WHERE_IS_CONCRETE5}"
cd ${WHERE_IS_CONCRETE5}
echo "c5 Backup: Executing MySQL Dump..."

if [ -n "$MYSQL_PASSWORD" ]; then
    set +e
        mysqldump -h ${MYSQL_SERVER} -u ${MYSQL_USER} --password=${MYSQL_PASSWORD} --single-transaction --default-character-set=utf8 ${MYSQL_NAME} > ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.sql
    ret=$?
    if [ "$ret" = 0 ]; then
        echo ""
        echo "c5 Backup: MySQL Database was dumped successfully."
    else
        echo "c5 Backup: ERROR: MySQL password failed. You must type MySQL password manually. OR hit ENTER if you want to stop this script now."
        set -e
        mysqldump -h ${MYSQL_SERVER} -u ${MYSQL_USER} -p --single-transaction --default-character-set=utf8 ${MYSQL_NAME} > ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.sql
    fi
    set -e
else
    echo "c5 Backup: Enter the MySQL password..."
    mysqldump -h ${MYSQL_SERVER} -u ${MYSQL_USER} -p --single-transaction --default-character-set=utf8 ${MYSQL_NAME} > ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.sql
fi

echo "c5 Backup: Now zipping files..."
# zip -r -q ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.zip ${TAR_OPTION}
tar -czpf ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.tar.gz -C ${BASE_PATH} ${TAR_OPTION}

echo "c5 Backup: Now removing SQL dump file..."
rm -f ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.sql

echo "c5 Backup: Now moving the backup file(s) to the final destination..."
echo "${WHERE_TO_SAVE}"
# mv ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.zip ${WHERE_TO_SAVE}
mv ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.tar.gz ${WHERE_TO_SAVE}

echo "c5 Backup: Completed!"
