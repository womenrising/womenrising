# Women Rising
[![Build Status](https://travis-ci.org/womenrising/womenrising.svg?branch=master)](https://travis-ci.org/womenrising/womenrising)

[![Code Climate](https://codeclimate.com/github/womenrising/womenrising/badges/gpa.svg)](https://codeclimate.com/github/womenrising/womenrising)

## Women supporting women in tech and business.

Women Rising is a website that helps to promote women by assisting them in
finding female peers and mentors in their field. Visit our site here [Women Rising](http://www.womenrising.co/)

The website for Women Rising has become an open source project. Our goal in
making this open source is to give mainly women but anyone who is looking to
get into development or someone who is just looking for a project to help out
with, a place to display their awesome skills as well as try to give feedback
to people on their code. All this is to be done in a respectful way, any
contributor should review our code of conduct at
[Code Of Conduct](https://github.com/kma3a/womenrising/blob/master/CODE_OF_CONDUCT.md).
If you have any complaints please let us know by sending an email to
info@womenrising.co and we will do our best to address them!

## Getting Started
Check out our [Contributing doc](https://github.com/womenrising/womenrising/blob/master/CONTRIBUTING.md) for more information on contributing to this project. In order to get started please fork the repo and clone it to have it locally on your computer.

### Setup Options

##### Mac OSX

If you don't have Ruby installed, check out [Getting Started with Ruby](https://github.com/womenrising/womenrising/blob/master/GETTING_STARTED_WITH_RUBY.md)

1. Fork, then clone the repo and cd (change directory) into the womenrising rails app and
install the gems.

  ```sh
  git clone git@github.com:your-username/womenrising.git
  cd womenrising
  bundle install
  ```

2. Set up the database:

  ```sh
  rake db:create
  rake db:migrate
  rake db:seed  # seed file containing test users
  ```

3. Copy `config/application.example.yml` to `config/application.yml`. Then run the test suite to ensure everything is passing.

  ```sh
  bundle exec rspec spec/
  ```

4. Fire up the app, and open your web browser to
[localhost:3000](http://localhost:3000).

  ```sh
  rails server
  ```

  Or you can run guard, which will automically start the server and rerun your specs when you make changes to files.

  ```sh
  bundle exec guard
  ```


#### Docker

1. Install docker-machine locally

2. Start `docker-machine`,

  ```sh
  docker-machine start default
  docker-machine env default
  ```

2. Run these commands,
  ```sh
  docker-compose build
  docker-compose run web rake db:create db:migrate
  docker-compose up
  ```

---

### Importing the Staging or Production DB

```sh
pg_restore --verbose --clean --no-acl --no-owner -h localhost -d womenrising_development ./db/backup-2016-01-14.dump
```

### Monthly Matches

```sh
# open a heroku rails shell
heorku run rake womenrising:peer_group_monthly_match c -a womenrising
```

### Setting up with Linkedin(*optional*):

Create your own application on
[linkedin developer site](https://developer.linkedin.com/) on this page click
my Apps which will take you to a create an account screen. If you already have
a linkedin account look to the bottom to find a sign in with linkedin.

This personal application will allow you to create a testing enviroment which
will allow you to login as yourself and view changes to your profile.

##### Next create an application on Linkedin

Fill in the information with temporary info using your personal email and phone
for business. The application use will be networking and you can use the
womenrising logo and url for the logo and url and click submit after agreeing
to the terms.

Under Authentication, you will find your client ID and Secret (keep these
secret!!). You will also see Default Applications persissionsi under that
check off r\_basicprofile r\_emailaddress and w\_messages (you will need those
for the profile).

Next under OAuth 2.0 add in the redirect URL for
http://localhost:3000/users/auth/linkedin/callback and
https://localhost:3000/users/auth/linkedin/callback (this will allow linkedin
to redirect back to your localhost also if your localhost is something other
than 3000 you just need to change the number to the correct one).

##### Setting up With Oauth2.0

In your config folder create an application.yml file (this file should contain
the appid and secret key that you created).  Once you have done that go into
the file and add:

```yaml
LINKEDIN_ID: <<your Client ID here>>
LINKEDIN_SECRET: <<your Client Secret here>>

gmail_username: <<your gmail email address>>
gmail_password: <<your gmail password>>
```

*note this file is in the .gitignore file so it will not be uploaded to the
internet (hence why we are having you create the linkedin dev account). The use
of the gmail username and password is only for sending emails and will not be
seen by anyone else.*

This will give you access to Linkedin so that you will be able to sign-in.

## Reporting Bugs

To report a bug, please create an issue with [Github Issues](https://github.com/womenrising/womenrising/issues/new)

Please make sure that you have your issues be as detailed as possible
(screenshots are always helpful!!).

## Sources

The choice of the code of conduct was inspired by the awesome
[Coraline Ada Ehmke](https://github.com/CoralineAda) from her talk at
[Geekfest](https://vimeo.com/101449990). If you want to look more into this you can find more at [contributor-covenant](http://contributor-covenant.org/).
