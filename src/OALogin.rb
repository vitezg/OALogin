#usual boilerplate
require 'java'

import "eu.webtoolkit.jwt.WApplication"
import "eu.webtoolkit.jwt.WBreak"
import "eu.webtoolkit.jwt.WText"
import "eu.webtoolkit.jwt.auth.GoogleService"
import "eu.webtoolkit.jwt.auth.FacebookService"

import "eu.webtoolkit.jwt.auth.AuthService"

#global variables for facebook and google login
#only one of each must exist
$authservice = AuthService.new()
$fblogin = FacebookService.new($authservice)
$glogin = GoogleService.new($authservice)

class OALogin < WApplication

  def initialize(env)
    super(env)
    setTitle("OAuth Login")

    #debug to stdout, should be true
    puts
    puts FacebookService::configured
    puts GoogleService::configured
    puts

    fbt = WText.new "Log in with FB", getRoot
    WBreak.new getRoot

    #the login example from the OAuthService documentation
    #implemented for facebook
    fbprocess = $fblogin.createProcess($fblogin.getAuthenticationScope)

    #start the authentication when the "Log in with FB" text is clicked
    fbprocess.connectStartAuthenticate fbt.clicked
    fbprocess.authenticated.addListener(self){|o|

      #from here it's up to us how we use the information
      #maybe look up the user from a database based on the id
      WText.new "Welcome from FaceBook "+o.getEmail+" " + o.getId, getRoot
    }

    gt = WText.new "Log in with Google", getRoot
    WBreak.new getRoot

    #and for google
    gbprocess = $glogin.createProcess($glogin.getAuthenticationScope)

    #start the authentication when the "Log in with Google" text is clicked
    gbprocess.connectStartAuthenticate gt.clicked
    gbprocess.authenticated.addListener(self){|o|
      WText.new "Welcome from Google "+o.getEmail+" " + o.getId, getRoot
    }
  end
end


