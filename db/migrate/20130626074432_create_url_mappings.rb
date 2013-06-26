class CreateUrlMappings < ActiveRecord::Migration
  def change
    create_table :url_mappings do |t|
      t.string :url_id
      t.text :url
      t.text :screenshot

      t.timestamps
    end
  end
end
