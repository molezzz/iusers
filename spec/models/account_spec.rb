# coding: utf-8
require 'spec_helper'
require 'account'

describe '新建用户' do
  user = {
      :username => 'bdall',
      :password => '1111111',
      :password_confirmation => '1111111',
      :phone => '13931200000',
      :email => 'iusers@bdall.com',
      :terms_of_service => true
    }
  
  before :each do
    @account = Account.new    
  end
    
  it '用户名不能为空' do
    @account.should have(3).error_on(:username)
  end
  
  it '电子邮件不能为空' do    
    @account.should have(6).error_on(:email)
  end
  
  it '用户名不能重复' do    
    Account.new(user).should have(1).error_on(:username)
  end
end
