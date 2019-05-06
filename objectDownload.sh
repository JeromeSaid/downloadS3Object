#!/bin/bash
 
# AWS Credentials for ricaud-fr / Bucket path

adpanid="adpan_id"
accessKey="AWS_ACCESSKEY";
secretKey="AWS_SECRETKEY;
region="BUCKET_REGION";
bucket="BUCKET_PATH";

# Feed destination

destDir="/destination";
debugDir="/logfiles";

# create config profile for adpan id

aws configure set aws_access_key_id $accessKey --profile $adpanid
aws configure set aws_secret_access_key $secretKey --profile $adpanid
aws configure set region $region --profile $adpanid

# Get name of last GZ file updated
# Source: https://stackoverflow.com/questions/38384879/downloading-the-latest-file-in-an-s3-bucket-using-aws-cli #
# Update file format if neccessary on lines 25 and 29

feedName=$( aws s3 ls $bucket --profile $adpanid | egrep '*.gz*' | sort | tail -n 1 | awk '{print $4}' );
feedPath="${bucket}/${feedName}";

aws s3 cp $feedPath $destDir --profile $adpanid --debug 2>${debugDir}${adpanid}.log
mv $destDir$feedName ${destDir}${adpanid}.gz
