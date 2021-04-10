# README

Set up environment variables:

```
GOOGLE_CLIENT_ID=google client id
GOOGLE_CLIENT_SECRET=google client secret
TRUSTED_IP=trusted ip for testing
TWILIO_SID=id from twilio if using text notif
TWILIO_TOKEN=
TWILIO_PHONE=twilio phone number
MY_PHONE=phone number to receive notifs
SECOND_PHONE=secondary phone
GMAIL_USER=gmail user for sending emails
GMAIL_PW=app password for gmail user
MY_EMAIL=for receiving reports
ADMIN_EMAIL=admin of app
MANAGER_EMAIL=for reports
HOSTNAME=hostname or ip for whitelisting
PROGRAM_FOLDER=folder id for parent directory on google drive` 
```


***

Create /client_secrets.json with Google auth credential.

***


Create DB
```
rails db:create
rails db:migrate
rails db:seed
```

***

To Run

`rails s -b 0.0.0.0`

***

To create a key for IFTTT webhooks call:
```
rails c
ApiKey.create
```

Automate google calendar sessions using IFTTT
On event POST to /trainingsessions?access_token=KEY
