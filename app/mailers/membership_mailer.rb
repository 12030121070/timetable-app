class MembershipMailer < ActionMailer::Base
  default from: 'from@example.com'

  def invitation_email(membership)
    @membership = membership
    mail :to => @membership.email, :subject => 'You have been invited'
  end
end
