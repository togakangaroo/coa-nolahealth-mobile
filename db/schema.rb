# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120301024737) do

  create_table "providers", :force => true do |t|
    t.string   "agency",              :limit => 256
    t.string   "organization",        :limit => 256
    t.string   "address",             :limit => 256
    t.string   "neighborhood",        :limit => 256
    t.string   "city",                :limit => 64
    t.string   "parish",              :limit => 64
    t.string   "state",               :limit => 2
    t.string   "zipcode",             :limit => 10
    t.string   "website",             :limit => 256
    t.string   "phone",               :limit => 256
    t.boolean  "verified",                                                            :default => false
    t.decimal  "lat",                                 :precision => 20, :scale => 16, :default => 0.0
    t.decimal  "lng",                                 :precision => 20, :scale => 16, :default => 0.0
    t.string   "hours",               :limit => 256
    t.string   "payment",             :limit => 128
    t.string   "medical_services",    :limit => 512
    t.string   "additional_services", :limit => 512
    t.string   "social_services",     :limit => 512
    t.string   "pharmacy_services",   :limit => 512
    t.string   "service_types",       :limit => 512
    t.boolean  "dental"
    t.boolean  "optometry"
    t.boolean  "medicaid"
    t.boolean  "healthnet_member"
    t.string   "specialties",         :limit => 512
    t.string   "languages",           :limit => 512
    t.string   "population_types",    :limit => 512
    t.string   "insurance_types",     :limit => 512
    t.string   "notes",               :limit => 2048
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
