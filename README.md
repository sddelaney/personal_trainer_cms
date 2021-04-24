# README

Requirements:
```
ruby-2.7.0
nodejs
yarn - npm install yarn
```

Set up environment variables as described in .env

***

Create /client_secrets.json with Google auth credential.

***

Install rails:
```
gem install rails
bundle install
```
``` 
bundle exec rake webpacker:install
```

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
