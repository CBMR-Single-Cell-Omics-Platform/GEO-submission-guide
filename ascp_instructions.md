Transferring files to the SRA with Aspera

If a data set exceeds the file size limit (XXXGb) for transfers to GEO through the usual FTP, it is necessary to transfer to the Short Read Archive (SRA) using the Aspera tool.

Write an email to sra@ncbi.nlm.nih.gov with the header "Requesting Aspera private SSH key file for GEO Submission" and request an SSH key file for use with Aspera for a GEO submission. They will send you the instructions below.

We (Piotr) already has the installation files ready to install ascp for a given user on yggdrasil/nidhogg.

1. Files should have relatively unique file names. 

2. UDP transfer must be enabled for the following IP ranges (please consult your local network admin if you are unsure): 130.14.29.0/24 and 130.14.250.0/24. TCP port 22 and UDP port 33001 must be open for our subnet.

3. Completed files will be transferred out of the upload directory. 

4. Please download and install Aspera Connect (a free plugin that includes ascp). It is available directly from Asperasoft:

http://downloads.asperasoft.com/connect2/

The software client is free for NCBI site users for the purpose of exchanging data with NCBI.

5. Attached is an openssh private formatted key (sra-**.ssh.priv). This file along with Aspera's ascp program can be used to deposit files at the SRA. Please note that Aspera keys may be deactivated from time to time and users will need to contact SRA to acquire the new key for uploads.

The aspera upload account is:

asp-sra@upload.ncbi.nlm.nih.gov

The command line utility for Aspera transfers is 'ascp', which is usually found in the directories created by the Aspera Connect installation; As of version 3.3x of Aspera Connect, the default install location for ascp is:

Microsoft Windows: 'C:\Program Files\Aspera\Aspera Connect\bin\ascp.exe'

Mac OS X: '/Applications/Aspera Connect.app/Contents/Resources/ascp' (Administrator-installed Aspera Connect), or

                '/Users/[username]/Applications/Aspera\ Connect.app/Contents/Resources/ascp' (Non-administrator install)

Linux: '/opt/aspera/bin/ascp' or '/home/[username]/.aspera/connect/bin/ascp'

6. To make an upload to SRA using ascp:

$ <path to ascp install>/ascp -i <path/key file> -QT -l100m -k1 <path/file(s) to transfer> asp-sra@upload.ncbi.nlm.nih.gov:<directory>

A specific example (Linux) in which "file.fastq" is sent would be:

$ /opt/aspera/bin/ascp ­-i ~/.ssh/<name of key file> -QT -l100m ­-k1 <path_to_file>/file.fastq asp-sra@upload.ncbi.nlm.nih.gov:test

As indicated in the above example, you should familiarize yourself with the ascp options and flags. Some useful ones include:

–Q (for adaptive flow control) – needed for disk throttling!

–T to disable encryption

–k1 enable resume of failed transfers

–l (maximum bandwidth of request, try 100m ; you may need to go up or down from there for optimum transfer)

–r recursive copy

–i <path/key file> (note in this example, the user has placed the key in ~/.ssh/)

<directory> is either 'incoming' or 'test'.  Please direct your uploads to the 'test' directory until you are confident your transmission command will work as intended.

Files deposited in the 'incoming' directory will automatically be moved into the archive. Any files in the incoming area will typically be copied into the archive within 1-4 hours and will be removed from the incoming area once the copy is complete.

Troubleshooting

 Aspera sometimes aborts uploads (with a disk write failed error) when there are a very large number of files to be transferred. If this happens, it is recommended to script the upload in order to send 1 file per ascp command (eg. using a 'for' loop). Please contact the SRA team (sra@ncbi.nlm.nih.gov) if you need guidance scripting the upload.
    
If you are prompted to enter a "Key passphrase" it probably means that aspera isn't able to find the ssh key file. This can usually be resolved by giving the full path to the key file after the '-i' option. Aspera has trouble following relative paths sometimes, even if the key file is in the current working directory.


For file transfer tips please read our Aspera transfer guide:

http://www.ncbi.nlm.nih.gov/books/NBK242625/
