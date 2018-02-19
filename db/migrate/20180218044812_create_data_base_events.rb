class CreateDataBaseEvents < ActiveRecord::Migration
  def change
    create_table :data_base_events do |t|
      t.string :batch_bid
      t.references :admin_user, index: true, foreign_key: true
      t.string :filename
      t.string :event_type
      t.timestamps null: false
    end
  end
end
