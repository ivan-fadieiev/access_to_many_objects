class CreateAddThirds < ActiveRecord::Migration[5.0]
  def change
    create_table :add_thirds do |t|
      t.string :title
      t.string :body
      t.string :text
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
