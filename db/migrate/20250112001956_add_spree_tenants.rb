class AddSpreeTenants < ActiveRecord::Migration[7.0]
  def change
    create_table :spree_tenants do |t|
      t.string :name

      t.timestamps
    end

    add_index :spree_tenants, :name, unique: true
  end
end
