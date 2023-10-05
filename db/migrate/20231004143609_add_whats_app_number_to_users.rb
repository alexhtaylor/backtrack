class AddWhatsAppNumberToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :whatsapp_number, :string
  end
end
