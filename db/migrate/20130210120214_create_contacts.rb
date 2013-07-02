class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.string :email
      t.string :name
      t.string :picture_url
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
