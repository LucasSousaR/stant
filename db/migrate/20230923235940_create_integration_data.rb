class CreateIntegrationData < ActiveRecord::Migration[7.0]
  def change
    create_table :integration_data do |t|
      t.jsonb :current_data
      t.string :identification_upload
      t.integer :version , default: 0

      t.timestamps
    end
  end
end
