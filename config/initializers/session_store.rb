# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bibmix_app_session',
  :secret      => 'ac38d05fb2b505985fb12290477040b234fe548d5682bcda9020a578dcc0ca52ae897566dc3670ca4341e60c82b0156aca1a1cb0138dbdf646dd5b0c8575c7c7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
