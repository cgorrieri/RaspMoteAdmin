class CreateOutlets < ActiveRecord::Migration
  def change
    create_table :outlets do |t|
      t.integer :uuid
      t.string :name
      t.string :room
      t.boolean :state
      t.string :comNb
      t.string :nbId

      t.timestamps
    end
  end
end