class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.string :name
      t.string :am_pm
      t.integer :start
      t.integer :finish

      t.timestamps
    end
  end
end
