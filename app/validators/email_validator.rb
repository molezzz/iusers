# coding: utf-8

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
      record.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.account.not_email'))
    end  
  end
end