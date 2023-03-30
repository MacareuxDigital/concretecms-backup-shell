# concreteCMS backup shell libraries

This is simple shell script to back up your concreteCMS 7.x & concreteCMS Version 8 site.
Since you're using GitHub, I assume you know what you're doing. This is the script that runs on your server.

## MIT LICENSE and NO GUARANTEE

This script is licensed under The MIT License. **USE IT AT YOUR OWN RISK.**

# concretecms-backup.sh shell

## Set-up

You need to have the server that allows to run the shell script.

1. Add your server config in `concretecms-backup.conf`
1. If you don't uncomment MYSQL_PASSWORD option, you will have to enter MySQL Password every time you run this script.
1. Upload the `concretecms-backup.sh` `concretecms-backup.conf`to your server
1. Change the file permission `chmod 700 concretecms-backup.sh` Or whatever the permission you need to execute the file. But make sure to minimize the permission.
1. Run the sh file from ssh or set-up CRON job.

It's is highly advised that you know what you're doing with this script. You MUST have certain amount of knowledge of what shell script is.

## CAUTION: Check your concreteCMS folder.

This script first save the SQL dump file onto concreteCMS directory. If the script fails, it may leave the SQL file under the server. MAKE SURE to check the server occasionally.

## How to Run and Options

At default, you still need to enter the MySQL Password.

### Format

```
cd path/to/shell/file
sh oncretecms-backup.sh [1st option] [2nd option]
```

### Example

```
cd /var/www/html
sh oncretecms-backup.sh --all --relative
```

### 1st Option

1st option will determine how much file you want to backup

#### FILES option (default)

back up a SQL and the files in application/files, application/config/generated_overrides, application/config/doctrine and application/language files.
- [no option]
- --files
- --file
- -f

#### Database + CONFIG option

back up a SQL and the files in application/config/generated_overrides, application/config/doctrine and application/language files.
- [no option]
- --config
- -c

#### DATABASE option

back up only a SQL dump file under WHERE_IS_concrete5 path

- --database
- -d

#### ALL file option

back up a SQL and all files under WHERE_IS_concrete5 path
- --all
- -a

#### PACKAGE option

back up a SQL, and the files in application/ (all files), packages/

- --packages 
- --package
- -p

#### CONCRETECMS MINIMUM option

back up a SQL, and application (EXCEPT files), concrete, packages, updates folders and composer.*, index.php, robots.txt files. This is useful option if you want to backup all concreteCMS files BUT excluding inside of file managers.

This is useful option that you want to backup concreteCMS files, but not the file manager files. It won't backup any other non-concreteCMS files on the concreteCMS document root directory such as sitemap.xml, site verification files.

- --c5-min
- --c5-minimum
- -cm

#### ALL concreteCMS option

back up a SQL, and application, concrete, packages, updates folders and composer.*, index.php, robots.txt files.

This is useful option if the concreteCMS root directory contains many non-concreteCMS folders. It won't backup any other non-concreteCMS files on the concreteCMS document root directory such as sitemap.xml, site verification files.

- --all-c5
- -c

#### HELP option

Shows all the help options.

- --help
- -h

### 2nd option

You MUST specify 1st option if you want to specify 2nd option.

2nd option determine if you need to work as absolute path or relative path. A Mac OS User reported that they need to be specify absolute path. You may need to use the 2nd option if you're running this as a cron job.


#### RELATIVE option (default) 

The shell runs relative path.

- [default]
- -r
- --relative

#### ABSOLUTE option

The shell always use absolute path when dumping and zipping files. 

- -a
- --absolute


## VARIABLES TO SET

After downloading the conf file, you must change the VARIABLES.

### NOW_TIME

Default:`date "+%Y%m%d%H%M%S"`

It would add current year, month, date, hour, and seconds to the backup files.

For example, if you think you don't want to put all the minutes and second, remove `%M%S`.


### WHERE_TO_SAVE

Enter the server full path where you want to save your backup files to.

e.g.
`WHERE_TO_SAVE="/var/www/html/backup"`

HINT: If you don't know where to find, use "pwd" command to find your current location of the server to find the full path of the server.

### WHERE_IS_concrete5

Enter the full server path of where your concreteCMS site is installed

e.g.
`WHERE_IS_concrete5="/var/www/html/concreteCMS"`



### FILE_NAME

Enter the identical file name. This will be the prefix of your file.

e.g.
`FILE_NAME="katzueno"`

### MYSQL_SERVER

Enter the MySQL server address.

e.g.
`MYSQL_SERVER="localhost"`

### MYSQL_NAME

Enter the name of your MySQL database.

e.g.
`MYSQL_NAME="database"`

### MYSQL_USER

Enter the MySQL username

e.g.
`MYSQL_USER="root"`


### MYSQL_PASSWORD (Option)

If you don't want to enter the password every time, uncomment the MYSQL_PASSWORD and enter the MySQL password.

e.g.
`MYSQL_PASSWORD="root"`

### MYSQL_CHARASET (charaset)

You must set what default-character encoding when exporting the dump.

- `utf8mb4` is recommended if you want emoji support.
- `utf8` is recommended if you are still using older server without emoji support.

e.g.
`MYSQL_CHARASET="utf8mb4"`

### MYSQL_IF_NO_TABLESPACE (true or false)

If you are using MySQL 5.7.31 or later, and you encounter the following error, you must set it to `true` 

```
mysqldump: Error: 'Access denied; you need (at least one of) the PROCESS privilege(s) for this operation' when trying to dump tablespaces
```

e.g.
`MYSQL_IF_NO_TABLESPACE="true"`

If you are using earlier version of MySQL or MariaDB, please set it `false`

e.g.
`MYSQL_IF_NO_TABLESPACE="false"`

### MYSQL_PORT (port number)

You must set the port number of MySQL server

- Set `3306` as default port number

e.g.
`MYSQL_PORT="3306"`


# concrete5-copy.sh shell

This is the shell script and concreteCMS job which copies the production concreteCMS to develop environment and modify user (mainly to make users info anonymous, or delete).

- concrete5-copy.sh
- appliction/jobs/batch_delete_users.php
- appliction/jobs/batch_modify_users.php

Read inside of each script and modify the necessary parameters.
concreteCMS jobs are set NOT TO RUN under `production` and `default` environments make sure to adjust if it doesn't run.


# Version History

## 4.0.0 (Mar 30, 2023)

- Separate the variable items from the shell scripts and put them in the conf file.
- Rename shell script file.

## 3.3.1 (Nov 9, 2021)

- Added -h option to tar command so that it can compress files under symbolic links

## 3.3.0 (Aug 9, 2021)

- Add `MYSQL_PORT` config parameter to be able to set mysql port number of mysqldump

## 3.2.0 (June 2, 2021)

- Add `MYSQL_CHARASET` config parameter to be able to set your default character encoding of mysqldump
- Add `MYSQL_IF_NO_TABLESPACE` config to make the shell configurable
- Better Readme documentation

## 3.1.2 (May 24, 2021)

- Add `--no-tablespaces` parameter to mysqldump commands, so that it can prevent the error `Access denied; you need (at least one of) the PROCESS privilege(s) for this operation` since MySQL 5.7.31.

## 3.1.1 (May 21, 2021)

- Removed `--default-character-set=utf8` parameter from mysqldump command so that if post 8.5.0 ConcreteCMS has utf8mb4 DB, it will respect the DB setting.
- TBD: whether to add default character option or not.

## 3.1.0 (March 22, 2021)

- config option added to save generated_overrides, proxies and language files. Default file option also now saves those config files.

## 3.0.0 (March 16, 2020)

- Added `concreteCMS-copy.sh` to copy production c5 to develop c5 if the both environment lives within a same server.

## 2.2.0 (Februrary 20, 2020)

- Added concreteCMS MINIMUM and ALL concreteCMS options

## 2.1.1 (October 24, 2018)

- Fixed a bug which --all option stopped in the middle and leaving the tar & sql file in WHERE_IS_concrete5 Path.
- Better documentation

## 2.1 (June 28, 2018)

Changed compress option from zip to tar because tar is better to contain file ownership and group information.

## 2.0L (April 3, 2016)

Made the legacy version to support concreteCMS.6.x and before. Switch the branch to [legacy](https://github.com/katzueno/concreteCMS-backup-shell/tree/legacy).

## 2.0 (December 28, 2015)

- `--single-transaction` option added to MySQLdump command (thanks Endo-san)
- 2nd option of relative path or absolute path added for Mac OS user (thanks Endo-san)
- database option added: option to only back-up the SQL dump file
- Some script validation using [www.shellcheck.net](http://www.shellcheck.net)
- Fix some English

## 1.0.1 (December 26, 2015)

- Fix where the ALL option generates error because it was indicating the same zip location twice.

## 1.0 (December 26, 2015)

- First version.

# Contact

http://katzueno.com/

Please feel free to create an issue or send me a pull request.
Your feedback is always welcome!
