class CreateRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :description

      t.timestamps
    end

    create_table :roles_users, id: false do |t|
      t.belongs_to :role
      t.belongs_to :user
    end

    add_index :roles, :name, unique: true
    add_index :roles_users, [ :role_id, :user_id ], unique: true
  end
end
