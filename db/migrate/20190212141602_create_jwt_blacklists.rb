class CreateJwtBlacklists < ActiveRecord::Migration[5.2]
  def change
    create_table :jwt_blacklists do |t|
      t.string :token
      t.belongs_to :user
      t.timestamps
    end
  end
end
