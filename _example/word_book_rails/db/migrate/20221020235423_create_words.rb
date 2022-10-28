class CreateWords < ActiveRecord::Migration[7.0]
  def change
    create_table :words do |t|
      t.string :en
      t.string :jp

      t.timestamps
    end
  end
end
