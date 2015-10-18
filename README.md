#Women Rising

##Women supporting women in tech and business.

Women Rising is an open source project to help with the advancement of women by assisting them in finding female peers and mentors in their respective fields. Our goal making this open source is to give mainly women but anyone who is looking to get into development, a place to display their awesome skills as well as try to give feedback to people on their code. All this is to be done in a respective way so any contributor should review our code of conduct at [Code Of Conduct](https://github.com/kma3a/womenrising/blob/master/CODE_OF_CONDUCT.md). If you have any complaint please let us know and we will do our best to address them!

###Versions

Ruby 4.1.4

####Authentication
devise
omniauth
omniauth-linkedin-oauth2

####Database
postgres

###Getting Started

In order to get started with this project please fork the repo and clone it to put it locally on your computer

####setting up with Linkedin:

Create your own dev profile on [linkedin developer site](https://developer.linkedin.com/) that way you can create a local testing enviroment which will allow you to login as yourself and view changes to your profile. (if you already have a linkedin account look on the bottom for the sign in)

#####Next create an application on Linkedin

Fill in the information with temporary info using your personal email and phone for business.

Under Authentication, you will find your client ID and Secret (keep these secret!!). You will also see Default Applications persissions check off the r\_basicprofile r\_emailaddress and w\_messages (you will need those for the profile).

Next under OAuth 2.0 add in the redirect URL for http://localhost:3000/users/auth/linkedin/callback and https://localhost:3000/users/auth/linkedin/callback (this will allow linkedin to redirect back to your localhost also if your localhost is something other than 3000 you just need to change the number to the correct one).

#####Setting up With Oauth2.0

In your Config folder create an application.yml file (his file should contain the appid and secret key that you created).  Once you have done that add in your config:

```ruby
API_KEY: <<your Client Key here>>
API_SECRET: <<your Client Secret here>>
```

####Rails

Once you have gotten all that set up

bundle install to get the vendors

Then set-up the database with 

rake db:create
rake db:migrate
rake db:seed (this is the run the seed file that I created to simulate users for testing purposes)

Once the database is set-up you can start working on changes or improvements that you are making.


###Reporting Bugs

Currently bug reporting is being worked on. If you have any Issues please send it to 


###Sources

The choice of the code of conduct was inspired by the awesome [Coraline Ada Ehmke](https://github.com/CoralineAda) from her talk at [Geekfest](https://vimeo.com/101449990). If you want to look more into this you can find more at [contributor-covenant](http://contributor-covenant.org/).
