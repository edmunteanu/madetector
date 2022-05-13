class AddFingerprintToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :fingerprint, :string
  end
end
