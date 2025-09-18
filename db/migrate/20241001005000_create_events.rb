class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.references :group, null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.string :name, null: false
      t.text :description
      t.boolean :require_everyone, null: false, default: false
      t.boolean :requires_contribution, null: false, default: false

      t.timestamps
    end
  end
end
