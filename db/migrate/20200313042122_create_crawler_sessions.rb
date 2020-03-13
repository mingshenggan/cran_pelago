class CreateCrawlerSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :crawler_sessions do |t|
      t.string :url

      t.timestamps
    end
  end
end
