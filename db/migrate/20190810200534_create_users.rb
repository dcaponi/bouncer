class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email
      t.string :name_first
      t.string :name_last
      t.string :profile_pic_url
      t.string :password_digest
      t.string :email_confirm_token
      t.timestamps
    end
  end
end
