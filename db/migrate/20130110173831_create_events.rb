class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :date
      t.string :description, limit: 140
      t.string :location, default: ""
      t.string :time_section
      t.boolean :flexible, default: false

      t.timestamps
    end
  end
end
