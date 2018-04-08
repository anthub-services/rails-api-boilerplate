class CreatePaths < ActiveRecord::Migration[5.1]
  def change
    create_table :paths do |t|
      t.references :user
      t.jsonb      :value

      t.timestamps
    end
  end
end
