class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.references :user
      t.string     :user_agent
      t.string     :ip_address
      t.text       :token
      t.boolean    :signed_out

      t.timestamps
    end
  end
end
