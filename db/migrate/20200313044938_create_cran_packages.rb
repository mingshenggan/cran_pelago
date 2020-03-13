class CreateCranPackages < ActiveRecord::Migration[6.0]
  def change
    create_table :cran_packages do |t|
      t.string :name
      t.string :version
      t.timestamp :published_at
      t.string :title
      t.text :description
      t.belongs_to :crawler_session, null: false, foreign_key: true, index: true

      t.timestamp :parsed_at
      t.timestamps
    end
  end
end
