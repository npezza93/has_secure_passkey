class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email_address
      t.string :webauthn_id
      t.index :webauthn_id

      t.timestamps
    end
  end
end
