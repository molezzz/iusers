# coding: utf-8

class MobileValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^0{0,1}(13[0-9]|15[0-9]|18[0-9]|14[0-9])[0-9]{8}$/
      record.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.account.not_mobile')) 
    end
  end
end