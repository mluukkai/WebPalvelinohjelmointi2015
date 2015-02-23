class AddFrozenStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_frozen, :boolean
  end
end
