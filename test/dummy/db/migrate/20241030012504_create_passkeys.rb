class CreatePasskeys < ActiveRecord::Migration[8.0]
  def change
    create_table :passkeys do |t|
      t.belongs_to :authenticatable, null: false, polymorphic: true
      t.string :external_id
      t.index :external_id
      t.string :public_key
      t.integer :sign_count
      t.datetime :last_used_at
      t.string :name

      t.timestamps
    end
  end
end
