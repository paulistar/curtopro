class CreateUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :urls do |t|
      t.text :original_url
      t.string :short_code
      t.integer :clicks

      t.timestamps
    end
  end
end
