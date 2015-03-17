class RemoveRecommendationsFromItemTable < ActiveRecord::Migration
  def change
    remove_column :items, :recommendations
  end
end
