class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :image
      t.float :price
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
