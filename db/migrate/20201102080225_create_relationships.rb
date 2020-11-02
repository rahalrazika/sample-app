class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id, index: true
      t.integer :followed_id, index: true

      t.timestamps
    end
  
    add_index :relationships, [:follower_id, :followed_id], unique: true

  end
end
