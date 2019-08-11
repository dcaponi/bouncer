class CreatePolicies < ActiveRecord::Migration[5.2]
  def change
    create_table :policies, id: :uuid do |t|
      t.integer :permission
      t.references :user, foreign_key: true, type: :uuid
      t.references :resource, foreign_key: true, type: :uuid
      t.references :resource_server, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
