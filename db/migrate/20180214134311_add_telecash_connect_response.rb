class AddTelecashConnectResponse < ActiveRecord::Migration[5.1]
  def change
    create_table :telecash_connect_responses do |t|
      t.string :order_number, null: false
      t.string :payment_method
      t.string :total
      t.string :currency
      t.string :processor_response_code
      t.string :status
      t.string :creditcard_brand
      t.string :response_hash
      t.string :approval_code
      t.string :transaction_id
      t.timestamps null: false
    end
  end
end
