class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.text :content
      t.integer :score
      t.integer :movie_id

      t.timestamps null: false
    end
  end
end
