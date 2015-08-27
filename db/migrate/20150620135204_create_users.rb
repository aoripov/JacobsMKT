class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :email
      t.integer :role # 1:admin, 2:editor, 3:user
      t.string :token
      t.timestamps null: false
    end
  end
end
