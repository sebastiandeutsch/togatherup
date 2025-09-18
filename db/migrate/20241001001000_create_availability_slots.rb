class CreateAvailabilitySlots < ActiveRecord::Migration[8.0]
  def change
    create_table :availability_slots do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :day_of_week, null: false
      t.time :starts_at, null: false
      t.time :ends_at, null: false

      t.timestamps
    end

    add_index :availability_slots, [:user_id, :day_of_week]
  end
end
