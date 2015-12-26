# concrete5 backup shell:

This is simple shell script to back up your concrete5.7.x site.
Since you're using GitHub, I assume you know what you're doing.

## MIT LISENCE and NO GURANTEE.

This script is licensed under The MIT License. **USE IT AT YOUR OWN RISK.**

## Set-up

1. Add your server config in `concrete5-backup.sh`
1. If you don't uncomment MYSQL_PASSWORD option, you will have to enter MySQL Password every time you run this script.
1. Upload the `concrete5-backup.sh` to your server
1. Change the file permission `chmod 700 concrete5-backup.sh` Or whatever the permission you need to execute the file. But make sure to minimize the permission.
1. Run the sh file from ssh or set-up CRON job.

It's is highly advised that you know what you're doing with this script. You MUST have certain amount of knowledge of what shell script is.

## How to Run and Options

`cd path/to/shell/file`
`sh concrete5-backup.sh [option]`

At default, you still need to enter the MySQL Password.


### Default `file` option

back up a SQL and the files in application/files
- - [no option]
- -- files
- - f

### ALL file

back up a SQL and all files under WHERE_IS_CONCRETE5 path
- --all
- -a

### PACKAGE option

back up a SQL, and the files in application/files, packages/

- --packages 
- --package
- -p:

### HELP

Shows all the help options.

- --help
- -h


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

`MYSQL_USER="root"`


### MYSQL_PASSWORD (Option)

If you don't want to enter the password every time, uncomment the MYSQL_PASSWORD and enter the MySQL password.

`MYSQL_PASSWORD="root"`
