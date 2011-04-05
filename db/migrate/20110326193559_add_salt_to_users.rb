class AddSaltToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :salt, :String
  end

  def self.down
    remove_column :users, :salt
  end
end
