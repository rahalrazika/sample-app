class AddRememberDigestTo < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :remembre_digest, :string

  end
end
