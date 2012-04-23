# coding: utf-8
require 'digest/md5'

class Account < ActiveRecord::Base
  
  attr_accessor :password,:password_confirmation,
                :email_confirmation,
                #email的验证
                :email_hash,
                :terms_of_service,
                :login_errors
                
  #表单可访问字段（白名单）
  attr_accessible :username,
                  :email,:email_confirmation,:email_hash,
                  :password,:password_confirmation,
                  :phone,
                  :terms_of_service
  
  before_create :generate_salt,:generate_uuid
  before_save :encrypt_password
  
  validates :username,:presence => true,
                      :uniqueness => true
  
  validates :email,:presence => true,
                   :uniqueness => true,
                   :confirmation => {:if => :change_email?},                   
                   #使用自定义验证
                   :email => true
                   
  
  validates :phone,:mobile => true
                                    
  validates :password,:length => {:minimum => 6, :maximum => 32},
                      :confirmation => true,
                      :if => :change_password?
                      
  #用户协议
  #validates :terms_of_service,:acceptance => true
  
  #通过标识符查找用户 自动判断 username email uuid phone
  #identifier <object>
  def self.search(identifier)
    user = nil
    if identifier =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
      #email
      user = Account.where(:email => identifier).first      
    elsif identifier =~ /^0{0,1}(13[0-9]|15[0-9]|18[0-9]|14[0-9])[0-9]{8}$/
      #手机号
      user = Account.where(:phone => identifier).first
    elsif identifier =~ /^[0-9A-Za-z]{8}-[0-9A-Za-z]{4}-[0-9A-Za-z]{4}-[0-9A-Za-z]{4}-[0-9A-Za-z]{12}$/
      #uuid
      user = Account.where(:uuid => identifier).first     
    end
    #将标识符作为用户名重新查询
    if user.nil?    
      user = Account.where(:username => identifier).first
    end
        
    user
  end
  
  #检查用户是否可以登陆
  #param password <string>
  #return <boolean>
  def login?(password)
    self.login_errors = []    
    if verify(password)
      #TODO 其他检测 例如用户被锁定
      true
    else
      self.login_errors << I18n.t('login.errors.password_incorrect')      
      false  
    end
  end
  
  #生成表单中的email hash
  def get_email_hash
    Digest::MD5.hexdigest("#{email}-bdall-iusers")
  end
  
  #验证密码 空密码返回
  #param password <string>
  #return <boolean>
  def verify(password)
    !password.blank? && self.encrypted_password ==  Digest::MD5.hexdigest("#{Digest::MD5.hexdigest(password)}#{self.salt}")
  end
  
  protected
  #是否要重设 email
  def change_email?
    self.new_record? || (!self.email_hash.blank? && self.email_hash != self.get_email_hash)
  end
  
  #是否更新密码
  def change_password?    
    self.new_record? || !self.password.blank?
  end   
  
  #设置密码
  def encrypt_password(password='')
    password = self.password if password.blank?
    #判断是否修改了密码
    unless self.password_confirmation.blank?
      self.encrypted_password = Digest::MD5.hexdigest("#{Digest::MD5.hexdigest(password)}#{salt}")
    end
  end
  
  #生成盐值
  def generate_salt
    len = 6
    tokens = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a  
    rand_str = ""  
    1.upto(len) { |i| rand_str << tokens[rand(tokens.size-1)] }
    self.salt = rand_str
  end
  
  #生成用户唯一标识符
  def generate_uuid
    #UUIDTools::UUID.md5_create(UUIDTools::UUID_DNS_NAMESPACE, "bdall.com")
    self.uuid = UUIDTools::UUID.timestamp_create.to_s
  end
  
end
