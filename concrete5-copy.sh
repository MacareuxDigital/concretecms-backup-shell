#!/bin/sh
#
# concrete5 Dev Copy:
# ----------
# Version 3.2.1
# By katzueno

# INSTRUCTION:
# ----------
# https://github.com/katzueno/concrete5-backup-shell

# USE IT AT YOUR OWN RISK!

set -e

# VARIABLES
# ----------
NOW_TIME=$(date "+%Y%m%d%H%M%S")
WHERE_TO_GET="/var/www/vhosts/example.com"
WHERE_TO_COPY="/var/www/vhosts/test.example.com"
ORIGIN_MYSQL_SERVER="localhost"
ORIGIN_MYSQL_NAME="db_production"
ORIGIN_MYSQL_USER="db_user"
ORIGIN_MYSQL_PASSWORD="password"
# Make sure to set the proper MySQL character encoding to avoid character corruption
ORIGIN_MYSQL_CHARASET="utf8mb4"
# Set "true" if you're using MySQL 5.7.31 or later
ORIGIN_MYSQL_IF_NO_TABLESPACE="false"
TARGET_MYSQL_SERVER="localhost"
TARGET_MYSQL_NAME="db_develop"
TARGET_MYSQL_USER="db_user"
TARGET_MYSQL_PASSWORD="password"
TARGET_C5_ENVIRONMENT="develop" # Indicate environment if you use non default C5_ENVIRONMENT
TARGET_C5_JOB_NAME="batch_modify_test_users"

# ==============================
#
# DO NOT TOUCH BELOW THIS LINE (unless you know what you're doing.)
#
# ==============================

# ---- tablespace option after MySQL 5.7.31
if [ "$ORIGIN_MYSQL_IF_NO_TABLESPACE" = "TRUE" ] || [ "$ORIGIN_MYSQL_IF_NO_TABLESPACE" = "True" ] || [ "$ORIGIN_MYSQL_IF_NO_TABLESPACE" = "true" ] || [ "$ORIGIN_MYSQL_IF_NO_TABLESPACE" = "t" ]; then
    MYSQLDUMP_OPTION_TABLESPACE="--no-tablespaces"
elif [ "$ORIGIN_MYSQL_IF_NO_TABLESPACE" = "FALSE" ] || [ "$ORIGIN_MYSQL_IF_NO_TABLESPACE" = "False" ] || [ "$ORIGIN_MYSQL_IF_NO_TABLESPACE" = "false" ] || [ "$ORIGIN_MYSQL_IF_NO_TABLESPACE" = "f" ]; then
    MYSQLDUMP_OPTION_TABLESPACE=""
else
    echo "c5 Backup ERROR: ORIGIN_MYSQL_IF_NO_TABLESPACE variable is not properly set in the shell script"
    exit 1
fi

# ---- Starting shell -----
echo "===================="
echo "c5 Copy: USE IT AT YOUR OWN RISK!"
echo "===================="
echo "c5 Copy:"
echo "c5 Copy: Starting concrete5 copy..."

echo "c5 Copy:"
echo "c5 Copy:"
echo "===================="
echo "c5 Copy: MySQL Copy"
echo "===================="
mysqldump -h "$ORIGIN_MYSQL_SERVER" -u "$ORIGIN_MYSQL_USER" --password="$ORIGIN_MYSQL_PASSWORD" --single-transaction --default-character-set="$ORIGIN_MYSQL_CHARASET" ${MYSQLDUMP_OPTION_TABLESPACE} "$ORIGIN_MYSQL_NAME" | mysql -h "$TARGET_MYSQL_SERVER" -u "$TARGET_MYSQL_USER" --password="$TARGET_MYSQL_PASSWORD" "$TARGET_MYSQL_NAME"
echo "c5 Copy: MySQL copy is done!"

echo "c5 Copy:"
echo "c5 Copy:"
echo "===================="
echo "c5 Copy: File Copy"
echo "===================="
echo "c5 Copy: Remove application files at the destination: ${WHERE_TO_COPY}/application/files/"
# rm -r ${WHERE_TO_COPY}/application/files/*
echo "c5 Copy: Copying application files from ${WHERE_TO_GET}/* to ${WHERE_TO_COPY}/"
cp -r ${WHERE_TO_GET}/* ${WHERE_TO_COPY}/

echo "c5 Copy:"
echo "c5 Copy:"
echo "===================="
echo "c5 Copy: Change Database Name"
echo "===================="
echo "**START** Replace database.php info to target database"
DATABASE_CONFIG="${WHERE_TO_COPY}/application/config/database.php"
DATABASE_CONFIG_TMP=$(mktemp "${DATABASE_CONFIG}.tmp.XXXXXX")
trap 'rm -f "$DATABASE_CONFIG_TMP"; exit 1' HUP INT TERM
trap 'rm -f "$DATABASE_CONFIG_TMP"' EXIT

# Escape values used in sed patterns and replacements. The pipe is the sed
# delimiter, so forward slashes in database credentials need no special handling.
sed_pattern_escape() {
    printf '%s' "$1" | sed 's/[][\.^$*|]/\\&/g'
}

sed_replacement_escape() {
    printf '%s' "$1" | sed 's/[\\&|]/\\&/g'
}

ORIGIN_MYSQL_SERVER_PATTERN=$(sed_pattern_escape "$ORIGIN_MYSQL_SERVER")
ORIGIN_MYSQL_NAME_PATTERN=$(sed_pattern_escape "$ORIGIN_MYSQL_NAME")
ORIGIN_MYSQL_USER_PATTERN=$(sed_pattern_escape "$ORIGIN_MYSQL_USER")
ORIGIN_MYSQL_PASSWORD_PATTERN=$(sed_pattern_escape "$ORIGIN_MYSQL_PASSWORD")
TARGET_MYSQL_SERVER_REPLACEMENT=$(sed_replacement_escape "$TARGET_MYSQL_SERVER")
TARGET_MYSQL_NAME_REPLACEMENT=$(sed_replacement_escape "$TARGET_MYSQL_NAME")
TARGET_MYSQL_USER_REPLACEMENT=$(sed_replacement_escape "$TARGET_MYSQL_USER")
TARGET_MYSQL_PASSWORD_REPLACEMENT=$(sed_replacement_escape "$TARGET_MYSQL_PASSWORD")

sed -e "s|'server' => '${ORIGIN_MYSQL_SERVER_PATTERN}',|'server' => '${TARGET_MYSQL_SERVER_REPLACEMENT}',|g" \
    -e "s|'database' => '${ORIGIN_MYSQL_NAME_PATTERN}',|'database' => '${TARGET_MYSQL_NAME_REPLACEMENT}',|g" \
    -e "s|'username' => '${ORIGIN_MYSQL_USER_PATTERN}',|'username' => '${TARGET_MYSQL_USER_REPLACEMENT}',|g" \
    -e "s|'password' => '${ORIGIN_MYSQL_PASSWORD_PATTERN}',|'password' => '${TARGET_MYSQL_PASSWORD_REPLACEMENT}',|g" \
    "$DATABASE_CONFIG" > "$DATABASE_CONFIG_TMP"
mv "$DATABASE_CONFIG_TMP" "$DATABASE_CONFIG"
trap - EXIT HUP INT TERM

echo "c5 Copy:"
echo "c5 Copy:"
echo "===================="
echo "c5 Copy: User Modify"
echo "===================="
echo "c5 Copy: Modifying the User Info"
echo "c5 Copy: Environment: ${TARGET_C5_ENVIRONMENT}"
${WHERE_TO_COPY}/concrete/bin/concrete5 c5:job --env=${TARGET_C5_ENVIRONMENT} ${TARGET_C5_JOB_NAME}

echo "c5 Copy: Completed!"
