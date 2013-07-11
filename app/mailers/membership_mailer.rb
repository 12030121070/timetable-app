class MembershipMailer < ActionMailer::Base
  default :from => Settings['mail']['from']

  def invitation_email(membership)
    @membership = membership
    mail :to => @membership.email, :subject => 'You have been invited'
  end
end
