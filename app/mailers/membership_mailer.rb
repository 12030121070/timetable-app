# encoding: utf-8

class MembershipMailer < ActionMailer::Base
  default :from => Settings['mail']['from']

  def invitation_email(membership)
    @membership = membership
    mail :to => @membership.email, :subject => 'Приглашение на Fliptable.ru'
  end
end
