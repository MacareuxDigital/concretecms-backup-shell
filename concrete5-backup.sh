#!/bin/bash
#
# concrete5 backup shell:
# ----------
# Version 2.0
# By katzueno

# INSTRUCTION:
# ----------
# https://github.com/katzueno/concrete5-backup-shell

# USE IT AT YOUR OWN RISK!

#set -e

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
function chkvar() {
    echo "c5 Backup: Checking variables..."
    if [ -z "$WHERE_TO_SAVE" ] || [ "$WHERE_TO_SAVE" = " " ]; then
        echo "c5 Backup ERROR: WHERE_TO_SAVE variable is not set"
        exit 1
    fi
    if [ -z "$WHERE_IS_CONCRETE5" ] || [ "$WHERE_IS_CONCRETE5" = " " ]; then
        echo "c5 Backup ERROR: WHERE_IS_CONCRETE5 variable is not set"
        exit 1
    fi
    if [ -z "$NOW_TIME" ] || [ "$NOW_TIME" = " " ]; then
        echo "c5 Backup ERROR: NOW_TIME variable is not set"
        exit 1
    fi
    if [ -z "$MYSQL_SERVER" ] || [ "$MYSQL_SERVER" = " " ]; then
        echo "c5 Backup ERROR: MYSQL_SERVER variable is not set"
        exit 1
    fi
    if [ -z "$MYSQL_USER" ] || [ "$MYSQL_USER" = " " ]; then
        echo "c5 Backup ERROR: MYSQL_USER variable is not set"
        exit 1
    fi
    if [ -z "$MYSQL_NAME" ] || [ "$MYSQL_NAME" = " " ]; then
        echo "c5 Backup ERROR: MYSQL_NAME variable is not set"
        exit 1
    fi

    return 0
}

# ---- Checking The Options -----
function chkopt() {
    BASE_PATH=''
    if [ "$3" = "-t" ] || [ "$3" = "--tar" ]; then
        ARC_PTN="tar"
    elif [ "$3" = "" ]; then
        ARC_PTN="zip"
    else
        NO_3rd_OPTION="1"
    fi

    if [ "$2" = "-a" ] || [ "$2" = "--absolute" ]; then
        BASE_PATH="${WHERE_IS_CONCRETE5}"
        if [ $ARC_PTN = "tar" ]; then
            BASE_PATH=`pwd`
        fi
    elif [ "$2" = "-r" ] || [ "$2" = "--relative" ] || [ "$2" = "" ]; then
        BASE_PATH=`pwd`
    else
        NO_2nd_OPTION="1"
    fi

    if [ "$1" = "--all" ] || [ "$1" = "-a" ]; then
        echo "c5 Backup: You've chosen the ALL option. Now we're backing up all concrete5 directory files."
        ZIP_OPTION="${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.sql ${BASE_PATH}/"
        BACKUP_PTN="a"
        NO_OPTION="0"
    elif [ "$1" = "--packages" ] || [ "$1" = "--package" ] || [ "$1" = "-p" ]; then
        echo "c5 Backup: You've chosen the PACKAGE option. Now we're backing up the SQL, application/files and packages/ folder."
        ZIP_OPTION="${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.sql ${BASE_PATH}/application/files/ ${BASE_PATH}/packages/"
        BACKUP_PTN="p"
        NO_OPTION="0"
    elif [ "$1" = "--database" ] || [ "$1" = "-d" ]; then
        echo "c5 Backup: You've chosen the DATABASE option. Now we're only backing up the SQL file."
        ZIP_OPTION="${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.sql"
        NO_OPTION="0"
    elif [ "$1" = "--file" ] || [ "$1" = "-files" ] || [ "$1" = "-f" ] || [ "$1" = "" ]; then
        echo "c5 Backup: You've chosen the DEFAULT FILE option. Now we're backing up the SQL and application/files."
        ZIP_OPTION="${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.sql ${BASE_PATH}/application/files/"
        BACKUP_PTN="f"
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
        --packages OR --package OR -p: back up a SQL, and the files in application/files, packages/
        --help OR -h: This help option.
        --------------------
        Second Option
        --------------------
        -r OR --relative: This is default option. You can leave this option blank
        -a OR --absolute: The script will execute using absolute path. Zip file may contain the folder structure
        --------------------
        3rd Option
        --------------------
        -t OR --tar: This is default option. You can leave this option blank

        * Second option is optional. You must specify 1st option if you want to specify 2nd option.
        ====================

        Have a good day! from katzueno.com
    "
        exit 1
    else
        NO_OPTION="1"
    fi

    if [ "$NO_OPTION" = "1" ] || [ "$NO_2nd_OPTION" = "1" ] || [ "$NO_3rd_OPTION" = "1" ]; then
        echo "c5 Backup ERROR: You specified WRONG OPTION. Please try 'sh backup.sh -h' for the available options."
        exit 1
    fi
    
    return 0
}


function dbbackup() {
    echo "c5 Backup: Executing MySQL Dump..."

    if [ -n "$MYSQL_PASSWORD" ]; then
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
    else
        echo "c5 Backup: Enter the MySQL password..."
        mysqldump -h ${MYSQL_SERVER} -u ${MYSQL_USER} -p --single-transaction --default-character-set=utf8 ${MYSQL_NAME} > ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.sql
    fi

    return 0
}

# ---- Checking Variable -----
chkvar

# ---- Checking The Options -----
chkopt $1 $2 $3

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

# ---- Checking The Options -----
dbbackup

if [ "$ARC_PTN" = "zip" ]; then
    echo "c5 Backup: Now zipping files..."
    zip -r -q ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.zip ${ZIP_OPTION}

    echo "c5 Backup: Now moving the backup file(s) to the final destination..."
    echo "${WHERE_TO_SAVE}"
    mv ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.zip ${WHERE_TO_SAVE}

    cp ${WHERE_TO_SAVE}/${FILE_NAME}_${NOW_TIME}.zip ${WHERE_TO_SAVE}/lastbackup.zip

else
    echo "c5 Backup: Now tar.gz files..."
    cd ${BASE_PATH}
    tar -cf ${FILE_NAME}_${NOW_TIME}.tar ${FILE_NAME}_${NOW_TIME}.sql

    cd ${WHERE_IS_CONCRETE5}
    case $BACKUP_PTN in
        'a' )
            tar -rf ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.tar ./
            ;;
        'f' )
            tar -rf ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.tar ./application/files/
            ;;
        'p' )
            tar -rf ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.tar ./application/files/
            tar -rf ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.tar ./packages/
            ;;
    esac

    gzip ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.tar

    echo "c5 Backup: Now moving the backup file(s) to the final destination..."
    echo "${WHERE_TO_SAVE}"
    mv ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.tar.gz ${WHERE_TO_SAVE}

    cp ${WHERE_TO_SAVE}/${FILE_NAME}_${NOW_TIME}.tar.gz ${WHERE_TO_SAVE}/lastbackup.tar.gz
fi

echo "c5 Backup: Now removing SQL dump file..."
rm -f ${BASE_PATH}/${FILE_NAME}_${NOW_TIME}.sql

echo "c5 Backup: Completed!"
