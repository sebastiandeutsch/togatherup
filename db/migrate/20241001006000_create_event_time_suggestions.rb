class CreateEventTimeSuggestions < ActiveRecord::Migration[8.0]
  def change
    create_table :event_time_suggestions do |t|
      t.references :event, null: false, foreign_key: true
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false

      t.timestamps
    end
  end
end
