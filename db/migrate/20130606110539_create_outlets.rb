class CreateOutlets < ActiveRecord::Migration
  def change
    create_table :outlets do |t|
      t.string :name
      t.string :room
      t.boolean :state

      t.timestamps
    end
  end
end
