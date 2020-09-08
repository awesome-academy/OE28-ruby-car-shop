class ChangeFavouriteListToFavoriteList < ActiveRecord::Migration[6.0]
  def change
    rename_table :favourite_lists, :favorite_lists
  end
end
