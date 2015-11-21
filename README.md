#Women Rising

##Women supporting women in tech and business.

Women Rising is a website that helps to permote women by assisting them in finding female peers and mentors in their field.

The website for women rising has become an open source project. Our goal in making this open source is to give mainly women but anyone who is looking to get into development or someone who is just looking for a project to help out with, a place to display their awesome skills as well as try to give feedback to people on their code. All this is to be done in a respectable way, any contributor should review our code of conduct at [Code Of Conduct](https://github.com/kma3a/womenrising/blob/master/CODE_OF_CONDUCT.md). If you have any complaint please let us know by sending an email to info@womenrising.co and we will do our best to address them!

###Versions

Rails 4.1.4

####Authentication
devise
omniauth
omniauth-linkedin-oauth2

####Database
postgres

###Getting Started

In order to get started with this project please fork the repo and clone it to put it locally on your computer.

####setting up with Linkedin:

Create your own application on [linkedin developer site](https://developer.linkedin.com/) on this page click my Apps which will take you to a create an account screen. If you already have a linkedin account look to the bottom to find a sign in with linkedin.

This personal application will allower you to create a testing enviroment which will allow you to login as yourself and view changes to your profile.

#####Next create an application on Linkedin

Fill in the information with temporary info using your personal email and phone for business. The application use will be networking and you can use the wemen rising logo and url for the logo and url and click submit after agreeing to the terms.

Under Authentication, you will find your client ID and Secret (keep these secret!!). You will also see Default Applications persissionsi under that check off r\_basicprofile r\_emailaddress and w\_messages (you will need those for the profile).

Next under OAuth 2.0 add in the redirect URL for http://localhost:3000/users/auth/linkedin/callback and https://localhost:3000/users/auth/linkedin/callback (this will allow linkedin to redirect back to your localhost also if your localhost is something other than 3000 you just need to change the number to the correct one).

#####Setting up With Oauth2.0

In your config folder create an application.yml file (this file should contain the appid and secret key that you created).  Once you have done that go into the file and add:

```yaml
LINKEDIN_ID: <<your Client ID here>>
LINKEDIN_SECRET: <<your Client Secret here>>

gmail_username: <<your gmail email address>>
gmail_password: <<your gmail password>>
```

*note this file is in the .gitignore file so it will not be uploaded to the internet (hence why we are having you create the linkedin dev account). The use of the gmail username and password is only for sending emails and will not be seen by anyone else.*

This will give you access to Linkedin so that you will be able to sign-in.

####Rails

Once you have gotten all that set up

bundle install to make sure everything is ready for this project.

Then set-up the database with:

```sh
rake db:create
rake db:migrate
rake db:seed  # this is the seed file that I created to simulate users for testing purposes
```

Once the database is set-up you can start working on changes or improvements that you are making. You can run rails s to start the server and should be able to login.

###Reporting Bugs

Currently the how to report bugs is being worked on. If you have any issues please send it to info@womenrising.co.

Please make sure that you have your issues be as detailed as possible (screenshots are always helpful!!).

###Sources

The choice of the code of conduct was inspired by the awesome [Coraline Ada Ehmke](https://github.com/CoralineAda) from her talk at [Geekfest](https://vimeo.com/101449990). If you want to look more into this you can find more at [contributor-covenant](http://contributor-covenant.org/).
