# Uploading files to GEO

## using 'ncftp'

```
ncftp
set passive on
set so-bufsize 33554432
open ftp://geoftp:rebUzyi1@ftp-private.ncbi.nlm.nih.gov
cd uploads/perslab_ofe3sOmQ
put -R Folder_with_submission_files
```

## Using 'lftp'

```
lftp ftp://geoftp:rebUzyi1@ftp-private.ncbi.nlm.nih.gov
cd uploads/perslab_ofe3sOmQ
mirror -R Folder_with_submission_files
```

## Using 'ftp'

```
ftp ftp-private.ncbi.nlm.nih.gov
name: geoftp
password: rebUzyi1
binary
cd uploads/perslab_ofe3sOmQ
mkdir new_geo_submission
cd new_geo_submission
put file_name
```

## Using 'sftp'

(expect slower transfer speeds since this method encrypts on-the-fly)

```
sftp geoftp@sftp-private.ncbi.nlm.nih.gov
password: rebUzyi1
cd uploads/perslab_ofe3sOmQ
mkdir new_geo_submission
cd new_geo_submission
put file_name
```

## Using 'ncftpput'
(transfers from the command-line without entering an interactive shell)

```
ncftpput -F -R -z -u geoftp -p "rebUzyi1" ftp-private.ncbi.nlm.nih.gov ./uploads/perslab_ofe3sOmQ ./local_dir_path
```

* local_dir_path: path to the local submission directory you are transferring to your personalized upload space

* -F to use passive (PASV) data connection
* -z is for resuming upload if a file upload gets interrupted
* -R to recursively upload an entire directory/tree

