class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources, id: :uuid do |t|
      t.string :name
      t.references :resource_server, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
