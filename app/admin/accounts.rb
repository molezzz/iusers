ActiveAdmin.register Account do
  
  filter :id
  filter :uuid
  filter :username
  filter :email
  filter :phone  
  #filter :status,:as => :select,
  #       :collection => status_options
  filter :login_at
  filter :created_at,:label => I18n.t('active_admin.labels.created_at')
  filter :updated_at,:label => I18n.t('active_admin.labels.updated_at')
  
  index do |a|
    column :id,:sortable => :id
    column :avatar,:sortable => false do |a|
      #TODO 读取头像
    end
    column :username,:sortable => false
    column :uuid,:sortable => false
    column :email,:sortable => false    
    column :phone    
    #column :status,:sortable => :status
    column :reg_ip
    column :login_at
    column :created_at
    column :updated_at
    default_actions    
  end
  
  form do |f|
    f.inputs do      
      f.input :username,:required => true,
              #:input_html => { :readonly => !f.object.new_record? },
              :hint => I18n.t('activerecord.tips.account.username')
      f.input :email,:required => true,
              :hint => I18n.t('activerecord.tips.account.email')
      f.input :email_confirmation
      if f.object.new_record?                 
        f.input :password,:as => :password
      else
        f.input :password,:as => :password,
                :hint => I18n.t('activerecord.tips.account.password_for_change')
        f.input :email_hash,:as => :hidden,
                :value => f.object.get_email_hash      
      end      
      f.input :password_confirmation,:as => :password
      f.input :phone,
              :hint => I18n.t('activerecord.tips.account.phone')
      f.input :terms_of_service,:as => :hidden,:value => true     
    end
    f.buttons
  end
  
  controller do 
    
    def update      
      super do |format|
       p @account.errors        
      end      
    end
    
  end  
    
end
