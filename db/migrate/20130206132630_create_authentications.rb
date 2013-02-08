class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :user_id
      t.string :provider
      t.string :token
      t.string :refresh_token
      t.integer :token_expires_time

      t.timestamps
    end
  end
end
