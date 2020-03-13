class AddJoinTableForCranPackagesAndPeople < ActiveRecord::Migration[6.0]
  def change
    create_join_table :cran_packages, :people do |t|
      t.string :relationship

      t.timestamps
    end
  end
end
