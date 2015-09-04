class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.text :description
      t.string :uid

      t.timestamps
    end
  end
end
