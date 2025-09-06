class CreateStatements < ActiveRecord::Migration[8.0]
  def change
    create_table :statements do |t|
      t.references :account, null: false, foreign_key: true
      t.string :filename
      t.datetime :upload_date
      t.text :file_content

      t.timestamps
    end
  end
end
