# Docker registry with easier env var setup

This registry image can be used to easily set up a Docker registry that has simple `htpasswd` auth and some other than `filesystem` storage. All necessary parameters can be specified by environment variables.

## Running

### htpasswd auth

Environment variables `HTPASSWD_0_USER` and `HTPASSWD_0_PASS` define a user that will be able to log in to the registry using `htpasswd` auth. Up to 5 users can be created like this, just increment the number in env var names. If you need more users, then really you should be using something else than this image, maybe have a look at [Portus](http://port.us.org/).

`REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY` has to be explicitly specified because this image does not have any storage configured by default (to make it easier to configure other storage options).

```
docker run -d -p 5000:5000 --name registry \
  -e "REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/var/lib/registry" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=basic-realm" \
  -e "HTPASSWD_0_USER=alice" \
  -e "HTPASSWD_0_PASS=AGoodPassword" \
  -e "HTPASSWD_1_USER=bob" \
  -e "HTPASSWD_1_PASS=BetterPassword" \
  sverik/htpasswd-registry:2
```

### Alternative (S3) storage

The default registry image specifies `filesystem` storage in `config.yml`. This makes it difficult to specify some other storage option via environment variables. In this image, there is no storage configured. If you want to use the default `filesystem` storage, it has to be defined with env var `-e "REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/var/lib/registry"`. On the other hand, configuring S3 is now easy with environment variables only.

```
docker run -d -p 5000:5000 --name registry \
  -e "REGISTRY_STORAGE_S3_ACCESSKEY=awsaccesskey" \
  -e "REGISTRY_STORAGE_S3_SECRETKEY=awssecretkey" \
  -e "REGISTRY_STORAGE_S3_REGION=us-west-1" \
  -e "REGISTRY_STORAGE_S3_REGIONENDPOINT=http://myobjects.local" \
  -e "REGISTRY_STORAGE_S3_BUCKET=bucketname" \
  -e "REGISTRY_STORAGE_S3_ENCRYPT=true" \
  -e "REGISTRY_STORAGE_S3_KEYID=mykeyid" \
  -e "REGISTRY_STORAGE_S3_SECURE=true" \
  -e "REGISTRY_STORAGE_S3_V4AUTH=true" \
  -e "REGISTRY_STORAGE_S3_CHUNKSIZE=5242880" \
  -e "REGISTRY_STORAGE_S3_MULTIPARTCOPYCHUNKSIZE=33554432" \
  -e "REGISTRY_STORAGE_S3_MULTIPARTCOPYMAXCONCURRENCY=100" \
  -e "REGISTRY_STORAGE_S3_MULTIPARTCOPYTHRESHOLDSIZE=33554432" \
  -e "REGISTRY_STORAGE_S3_ROOTDIRECTORY=/s3/object/name/prefix" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=basic-realm" \
  -e "HTPASSWD_0_USER=alice" \
  -e "HTPASSWD_0_PASS=AGoodPassword" \
  sverik/htpasswd-registry:2
```
