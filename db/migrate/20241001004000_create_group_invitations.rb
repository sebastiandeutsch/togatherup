class CreateGroupInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :group_invitations do |t|
      t.references :group, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.string :email
      t.string :token, null: false
      t.datetime :accepted_at
      t.datetime :expires_at

      t.timestamps
    end

    add_index :group_invitations, :token, unique: true
  end
end
