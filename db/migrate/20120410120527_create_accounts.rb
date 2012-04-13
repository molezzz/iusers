class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :status_id,:null => false,:default => 0
      t.string :username,:null => false
      t.string :email,:null => false
      t.string :phone
      t.string :uuid,:null => false
      t.string :encrypted_password
      t.string :salt
      t.string :secques
      t.string :reg_ip
      t.datetime :login_at

      t.timestamps
    end
    add_index :accounts, :username, :unique => true    
    add_index :accounts, :email, :unique => true
    add_index :accounts, :uuid, :unique => true
    add_index :accounts, :phone
  end
end
