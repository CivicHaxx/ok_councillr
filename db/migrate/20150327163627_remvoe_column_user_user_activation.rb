class RemvoeColumnUserUserActivation < ActiveRecord::Migration
  def change
  	remove_column :users, :activation_state
    remove_column :users, :activation_token
    remove_column :users, :activation_token_expires_at
  end
end
