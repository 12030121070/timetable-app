ActionMailer::Base.smtp_settings = {
  :address              => Settings['mail']['address'],
  :port                 => Settings['mail']['port'],
  :domain               => Settings['mail']['domain'],
  :user_name            => Settings['mail']['login'],
  :password             => Settings['mail']['password'],
  :authentication       => "plain",
  :enable_starttls_auto => true
}
