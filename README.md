[![Docker Build Status](https://img.shields.io/docker/build/facastagnini/docker-protonmail-personal-gateway.svg)](https://hub.docker.com/r/facastagnini/docker-protonmail-personal-gateway/builds/)

# docker-protonmail-personal-gateway

The goal of this docker image is to create a simple gateway that will intercept email notifications from appliances and devices that can send alerts over email, encrypt the content of the email and send it to my protonmail account, using the free gmail SMTP service. It should be fairly simple for you to clone this repo and replace the google SMTP with another provider. 

Changes compared to tianon/exim4 and metabrainz/docker-exim:

- it only forwards email addressed to my protonmail account
- encrypts the body of the email with my protonmail public gpg key

## Parameters
- DOMAIN: optional, use it if you have a custom domain.
- GMAIL_USER: your google id
- GMAIL_PASSWORD: the google application password for your account.
- PROTONMAIL_USER: your protonmail address
- PROTONMAIL_USER_PUBLIC_KEY: path to your protonmail GPG public key

After getting a google application password, you may use something like:

```
docker run --detach --publish 12025:25 --env GMAIL_USER=youruser@yourdomain.com --env GMAIL_PASSWORD=yourpasswordhere --env PROTONMAIL_USER=youruser@protonmail.com --env PROTONMAIL_USER_PUBLIC_KEY=/home/user/youruser.key --name eximtest facastagnini/docker-protonmail-personal-gateway
```

Images are available at https://hub.docker.com/r/facastagnini/docker-protonmail-personal-gateway

## How to get my protonmail public key?
See https://protonmail.com/support/knowledge-base/download-public-key/

# Credits
Exim docker image based on https://github.com/tianon/dockerfiles/tree/master/exim4, plus some improvements added by https://github.com/metabrainz/docker-exim
Exim GPG plugin based on https://github.com/Interoberlin/exim-gpg-filter
