class AddProvider < ActiveRecord::Migration
	def up
		create_table :providers, :force => true do |t|
			t.string :agency, :limit => 256
			t.string :organization, :limit => 256
			t.string :address, :limit => 256
			t.string :neighborhood, :limit => 256
			t.string :city, :limit => 64
			t.string :parish, :limit => 64
			t.string :state, :limit => 2
			t.string :zipcode, :limit => 10
			t.string :website, :limit => 256
			t.string :phone, :limit => 256
		end
	end

	def down
		drop_table :providers
	end
end
