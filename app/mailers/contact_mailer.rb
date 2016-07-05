class ContactMailer < ActionMailer::Base
  default from: Rails.application.secrets.emails['default_from']

  def contact_form(email, message, request)
    @email = email
    @ip_address = RequestGeolocator.new(request).ip_address
    @ua = request.user_agent
    @message =  message
    mail(
      from: email,
      to: Rails.application.secrets.emails['contact'],
      subject: "nolotiro.org - contact from #{email}"
    )
  end

end
