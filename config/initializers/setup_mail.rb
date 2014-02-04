ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "Ubuntu",
  :user_name            => "maxwelltietze@gmail.com",
  :password             => ENV['mail_password'],
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "Ubuntu:3000"