class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.datetime :birthday
      t.integer :games_played
      t.integer :rank

      t.timestamps
    end
  end
end
