class AddDeletedAtToCars < ActiveRecord::Migration[6.0]
  def change
    add_column :cars, :deleted_at, :datetime
    add_index :cars, :deleted_at
  end
end
