class CreateEventChanges < ActiveRecord::Migration[7.1]
  def change
    create_table :event_changes do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :action, null: false
      t.json :changes_made, null: false

      t.timestamps
    end
  end
end
