# apdevblog-env

Vagrant/chef setup around the [blog](https://github.com/apdev/apdevblog.com) to better deal with dependencies.

## Install
```
vagrant up
```

## Enable deploy
To be able to push changes to S3/CloudFront you need to configure aws-cli.
```
# enable aws-cli cloudfront "preview" feature
aws configure set preview.cloudfront true

# will ask you for credentials
aws configure
```

## Work
[Click here](https://github.com/apdev/apdevblog.com/blob/master/README.md) to learn how to work with apdevblog.

Quick start:
```
vagrant up
vagrant ssh
cd repos/apdevblog.com
rake preview
```
Now you can open [192.168.44.44:4000](http://192.168.44.44:4000/) to preview.