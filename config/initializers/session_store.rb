# Be sure to restart your server when you modify this file.

TimetableApp::Application.config.session_store :cookie_store, key: '_timetable-app_session', :domain => :all

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# TimetableApp::Application.config.session_store :active_record_store
