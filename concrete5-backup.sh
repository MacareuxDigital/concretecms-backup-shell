#!/bin/sh
#
# concrete5 backup shell:
# ----------
# Version 1.0
# By katzueno

# INSTRUCTION:
# ----------
# https://github.com/katzueno/concrete5-backup-shell

# USE IT AT YOUR OWN RISK!

set -e

# VARIABLES
# ----------
NOW_TIME=`date "+%Y%m%d%H%M%S"`
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

# ---- Checking Variable -----
echo "c5 Backup: Checking variables..."
if [ -n "$WHERE_TO_SAVE" ]; then
if [ -n "$WHERE_IS_CONCRETE5" ]; then
if [ -n "$NOW_TIME" ]; then
if [ -n "$MYSQL_SERVER" ]; then
if [ -n "$MYSQL_USER" ]; then
if [ -n "$MYSQL_NAME" ]; then

# ---- Checking The Options -----
if [ "$1" == "--all" ] || [ "$1" == "-a" ]; then
    echo "c5 Backup: You've chosen the ALL option. Now we're backing up all concrete5 directory files."
    ZIP_OPTION="${FILE_NAME}_${NOW_TIME}.sql ./"
    NO_OPTION="0"
elif [ "$1" == "--packages" ] || [ "$1" == "--package" ] || [ "$1" == "-p" ]; then
    echo "c5 Backup: You've chosen the PACKAGE option. Now we're backing up the SQL, application/files and packages/ folder."
    ZIP_OPTION="${FILE_NAME}_${NOW_TIME}.sql ./application/files/ ./packages/"
    NO_OPTION="0"
elif [ "$1" == "--file" ] || [ "$1" == "-f" ] || [ "$1" == "" ]; then
    echo "c5 Backup: You've chosen the DEFAULT FILE option. Now we're backing up the SQL and application/files."
    ZIP_OPTION="${FILE_NAME}_${NOW_TIME}.sql ./application/files/"
    NO_OPTION="0"
elif [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "===================="
    echo "c5 Backup: Options"
    echo "===================="
    echo "[no option] OR --files OR -f: back up a SQL and the files in application/files"
    echo "--all OR -a: back up a SQL and all files under WHERE_IS_CONCRETE5 path"
    echo "--packages OR --package OR -p: back up a SQL, and the files in application/files, packages/"
    echo "--help OR -h: This help option."
    echo "===================="
    echo ""
    echo "Have a good day! from katzueno.com"
    echo ""
    exit
else
    NO_OPTION="1"
fi

if [ "$NO_OPTION" == "0" ]; then


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
        mysqldump -h ${MYSQL_SERVER} -u ${MYSQL_USER} --password=${MYSQL_PASSWORD} --default-character-set=utf8 ${MYSQL_NAME} > ${FILE_NAME}_${NOW_TIME}.sql
    ret=$?
    if [ "$ret" -eq 0 ]; then
        echo ""
        echo "c5 Backup: MySQL Database dumped successfully."
    else
        echo "c5 Backup: ERROR: MySQL password failed. You must type MySQL password manually. OR hit ENTER if you want to stop this script now."
        set -e
        mysqldump -h ${MYSQL_SERVER} -u ${MYSQL_USER} -p --default-character-set=utf8 ${MYSQL_NAME} > ${FILE_NAME}_${NOW_TIME}.sql
    fi
    set -e
else
    echo "c5 Backup: Enter the MySQL password..."
    mysqldump -h ${MYSQL_SERVER} -u ${MYSQL_USER} -p --default-character-set=utf8 ${MYSQL_NAME} > ${FILE_NAME}_${NOW_TIME}.sql
fi

echo "c5 Backup: Now zipping files..."
zip -r -q ${FILE_NAME}_${NOW_TIME}.zip ${ZIP_OPTION}

echo "c5 Backup: Now removing SQL dump file..."
rm ${FILE_NAME}_${NOW_TIME}.sql

echo "c5 Backup: Now moving the back up file to the final destination..."
echo "${WHERE_TO_SAVE}"
mv ${FILE_NAME}_${NOW_TIME}.zip ${WHERE_TO_SAVE}

echo "c5 Backup: Completed!"



# ---- Option Error ----
else
echo "c5 Backup ERROR: You specified WRONG OPTION. Please execute 'sh backup.sh -h' for the available options."
fi

# ---- Checking Variable -----
else
echo "c5 Backup ERROR: MYSQL_NAME variable is not set"
fi
else
echo "c5 Backup ERROR: MYSQL_USER variable is not set"
fi
else
echo "c5 Backup ERROR: MYSQL_SERVER variable is not set"
fi
else
echo "c5 Backup ERROR: NOW_TIME variable is not set"
fi
else
echo "c5 Backup ERROR: WHERE_IS_CONCRETE5 variable is not set"
fi
else
echo "c5 Backup ERROR: WHERE_TO_SAVE variable is not set"
fi