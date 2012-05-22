{-# LANGUAGE OverloadedStrings, ExtendedDefaultRules #-}
{-# LANGUAGE DeriveDataTypeable         #-}

module Controllers.User 
       ( routes 
       , redirectToSignin 
       , withAuthUser ) where

------------------------------------------------------------------------------

import           Control.Applicative ((<$>), (<*>))
import           Snap.Core
import           Snap.Snaplet.Auth
import           Snap.Snaplet
import           Snap.Snaplet.I18N
import           Text.Digestive.Snap
import           Control.Monad.CatchIO (try)
import qualified Data.ByteString as BS

import           Application
import           Controllers.Home
import           Models.Exception
import           Views.UserForm
import           Views.Utils
import qualified Models.User as MD


routes :: [(BS.ByteString, Handler App App ())]
routes =  [ ("/signup",  signup)
          , ("/signin",  signin)
          , ("/signout", signout) 
          ]

redirectToSignin :: AppHandler ()
redirectToSignin = redirect "/signin"

-- | Perform a action `AppHandler ()` within Auth user otherwise redirect to signin.
--
withAuthUser :: AppHandler () -> AppHandler ()
withAuthUser = requireUser appAuth redirectToSignin

------------------------------------------------------------------------------
    
-- | sign up user and redirect to home page.
--   Snap `registerUser` allow empty username and password
-- 
signup :: AppHandler ()
signup = do
          errorMsg       <- (,) <$> lookupI18NValue "requiredLoginname" 
                                <*> lookupI18NValue "requiredPassword"
          (view, result) <- runForm "form" $ signupForm errorMsg
          case result of
              Just u -> do
                        result' <- try (with appAuth (MD.createNewUser u))
                        either (toPage . updateViewErrors view . showUE) toHome result'
              Nothing -> toPage view
          where toHome = const redirectToHome
                toPage = renderDfPage "signup" 
                


------------------------------------------------------------------------------

-- | Sign in the user.
-- 
-- 1. fetch i18n message for error
-- 2. run digestive functor form
-- 3. return to signin page if form validation failed.
-- 4. otherwise doing authentication
-- 5. return to sign page if any errors 
-- 6. otherwise return to home page.
-- 
signin :: AppHandler ()
signin = do
    errorMsg       <- (,) <$> lookupI18NValue "requiredLoginname" 
                          <*> lookupI18NValue "requiredPassword"
    (view, result) <- runForm "form" $ signinForm errorMsg
    case result of
        Just usr -> do
                  result' <- try (with appAuth $ MD.loginUser usr)
                  either (toPage . updateViewErrors view . showUE) toHome result'
        Nothing -> toPage view
    where toPage = renderDfPage "signin"
          toHome = const redirectToHome

          
------------------------------------------------------------------------------

-- | log out
-- 
signout :: AppHandler ()
signout = with appAuth logout >> redirectToHome


------------------------------------------------------------------------------

