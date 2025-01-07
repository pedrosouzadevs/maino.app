ActionMailer::Base.smtp_settings = {
  domain: 'https://maino-app-58ff4c2d5bcd.herokuapp.com/',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  user_name: 'apikey',
  password: ENV['SENDGRID_API_KEY']
}
