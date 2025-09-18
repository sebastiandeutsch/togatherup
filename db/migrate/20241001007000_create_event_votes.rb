class CreateEventVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :event_votes do |t|
      t.references :event_time_suggestion, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: "tentative"
      t.text :note

      t.timestamps
    end

    add_index :event_votes, [:event_time_suggestion_id, :user_id], unique: true, name: "index_event_votes_on_suggestion_and_user"
  end
end
