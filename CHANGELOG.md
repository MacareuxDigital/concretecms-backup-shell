# Version History
## 4.1.0 (Nov 08, 2024)

- Add `all-files` option to back up all files in the Concrete CMS directory excluding the database.
  Can exclude some directories by adding the name/path as 3rd argument.

## 4.0.1 (Mar 14, 2023)

- Exclude `application/files/cache` from backup

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

- Removed `--default-character-set=utf8` parameter from mysqldump command so that if post 8.5.0 Concrete CMS has utf8mb4 DB, it will respect the DB setting.
- TBD: whether to add default character option or not.

## 3.1.0 (March 22, 2021)

- config option added to save generated_overrides, proxies and language files. Default file option also now saves those config files.

## 3.0.0 (March 16, 2020)

- Added `concrete5-copy.sh` to copy production c5 to develop c5 if the both environment lives within a same server.

## 2.2.0 (Februrary 20, 2020)

- Added Concrete CMS MINIMUM and ALL Concrete CMS options

## 2.1.1 (October 24, 2018)

- Fixed a bug which --all option stopped in the middle and leaving the tar & sql file in WHERE_IS_CONCRETE5 Path.
- Better documentation

## 2.1 (June 28, 2018)

Changed compress option from zip to tar because tar is better to contain file ownership and group information.

## 2.0L (April 3, 2016)

Made the legacy version to support Concrete CMS.6.x and before. Switch the branch to [legacy](https://github.com/katzueno/Concrete CMS-backup-shell/tree/legacy).

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
