# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Mikl_me_session',
  :secret      => '71f7c52bd3c035668d4f25c728deb1db92ce5bb9507489e1832b9681478b0a5653cfeef05ec6e66cdec6147b8d0aa8a4c6761cd33d379adb856158347662e179'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
