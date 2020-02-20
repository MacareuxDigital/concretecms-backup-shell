# concrete5 backup shell:

This is simple shell script to back up your concrete5.7.x & concrete5 Version 8 site.
Since you're using GitHub, I assume you know what you're doing. This is the script that runs on your server.

## MIT LICENSE and NO GUARANTEE

This script is licensed under The MIT License. **USE IT AT YOUR OWN RISK.**

## Set-up

You need to have the server that allows to run the shell script.

1. Add your server config in `concrete5-backup.sh`
1. If you don't uncomment MYSQL_PASSWORD option, you will have to enter MySQL Password every time you run this script.
1. Upload the `concrete5-backup.sh` to your server
1. Change the file permission `chmod 700 concrete5-backup.sh` Or whatever the permission you need to execute the file. But make sure to minimize the permission.
1. Run the sh file from ssh or set-up CRON job.

It's is highly advised that you know what you're doing with this script. You MUST have certain amount of knowledge of what shell script is.

## CAUTION: Check your concrete5 folder.

This script first save the SQL dump file onto concrete5 directory. If the script fails, it may leave the SQL file under the server. MAKE SURE to check the server occasionally.

## How to Run and Options

At default, you still need to enter the MySQL Password.

### Format

```
cd path/to/shell/file
sh concrete5-backup.sh [1st option] [2nd option]
```

### Example

```
cd /var/www/html
sh concrete5-backup.sh --all --relative
```

### 1st Option

1st option will determine how much file you want to backup

#### FILES option (default)

back up a SQL and the files in application/files (only file manager files)
- [no option]
- --files
- --file
- -f

#### DATABASE option

back up only a SQL dump file under WHERE_IS_CONCRETE5 path

- --database
- -d

#### ALL file option

back up a SQL and all files under WHERE_IS_CONCRETE5 path
- --all
- -a

#### PACKAGE option

back up a SQL, and the files in application/ (all files), packages/

- --packages 
- --package
- -p

#### CONCRETE5 MINIMUM option

back up a SQL, and application (EXCEPT files), concrete, packages, updates folders and composer.*, index.php, robots.txt files. This is useful option if you want to backup all concrete5 files BUT excluding inside of file managers.

This is useful option that you want to backup concrete5 files, but not the file manager files. It won't backup any other non-concrete5 files on the concrete5 document root directory such as sitemap.xml, site verification files.

- --c5-min
- --c5-minimum
- -cm

#### ALL CONCRETE5 option

back up a SQL, and application, concrete, packages, updates folders and composer.*, index.php, robots.txt files.

This is useful option if the concrete5 root directory contains many non-concrete5 folders. It won't backup any other non-concrete5 files on the concrete5 document root directory such as sitemap.xml, site verification files.

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

Once you download the sh file, you must change the where VARIABLES is from line 15

### NOW_TIME

Default:`date "+%Y%m%d%H%M%S"`

It would add current year, month, date, hour, and seconds to the backup files.

For example, if you think you don't want to put all the minutes and second, remove `%M%S`.


### WHERE_TO_SAVE

Enter the server full path where you want to save your backup files to.

e.g.
`WHERE_TO_SAVE="/var/www/html/backup"`

HINT: If you don't know where to find, use "pwd" command to find your current location of the server to find the full path of the server.

### WHERE_IS_CONCRETE5

Enter the full server path of where your concrete5 site is installed

e.g.
`WHERE_IS_CONCRETE5="/var/www/html/concrete5"`



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


## Version History

### 2.2.0 (Februrary 20, 2020)

- Added CONCRETE5 MINIMUM and ALL CONCRETE5 options

### 2.1.1 (October 24, 2018)

- Fixed a bug which --all option stopped in the middle and leaving the tar & sql file in WHERE_IS_CONCRETE5 Path.
- Better documentation

### 2.1 (June 28, 2018)

Changed compress option from zip to tar because tar is better to contain file ownership and group information.

### 2.0L (April 3, 2016)

Made the legacy version to support concrete5.6.x and before. Switch the branch to [legacy](https://github.com/katzueno/concrete5-backup-shell/tree/legacy).

### 2.0 (December 28, 2015)

- `--single-transaction` option added to MySQLdump command (thanks Endo-san)
- 2nd option of relative path or absolute path added for Mac OS user (thanks Endo-san)
- database option added: option to only back-up the SQL dump file
- Some script validation using [www.shellcheck.net](http://www.shellcheck.net)
- Fix some English

### 1.0.1 (December 26, 2015)

- Fix where the ALL option generates error because it was indicating the same zip location twice.

### 1.0 (December 26, 2015)

- First version.

## Contact

http://katzueno.com/

Please feel free to create an issue or send me a pull request.
Your feedback is always welcome!
