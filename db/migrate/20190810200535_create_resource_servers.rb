class CreateResourceServers < ActiveRecord::Migration[5.2]
  def change
    create_table :resource_servers, id: :uuid do |t|
      t.string :name
      t.timestamps
    end
  end
end
