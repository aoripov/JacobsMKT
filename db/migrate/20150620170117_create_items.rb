class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :image
      t.text :description
      t.float :price
      t.integer :status, default: 1
      t.integer :priority, default: 0
      t.belongs_to :user, index: true
      t.belongs_to :category, index: true
      t.timestamps null: false
    end
  end
end
