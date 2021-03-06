# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100830101109) do

  create_table "citations", :force => true do |t|
    t.text     "citation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eval_references", :force => true do |t|
    t.string   "referencetype"
    t.string   "address"
    t.text     "annote"
    t.text     "author"
    t.text     "booktitle"
    t.string   "chapter"
    t.string   "crossref"
    t.string   "edition"
    t.text     "editor"
    t.string   "howpublished"
    t.string   "institution"
    t.string   "journal"
    t.string   "key"
    t.string   "month"
    t.string   "note"
    t.string   "number"
    t.string   "organization"
    t.string   "pages"
    t.string   "publisher"
    t.string   "school"
    t.string   "series"
    t.text     "title"
    t.string   "mytype"
    t.string   "volume"
    t.string   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "citation"
    t.string   "status"
  end

  create_table "evaluations", :force => true do |t|
    t.integer  "evaluator_id"
    t.integer  "citation_id"
    t.string   "parser"
    t.string   "process"
    t.boolean  "result"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "evaluators", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "references", :force => true do |t|
    t.text     "citation"
    t.text     "authors"
    t.text     "title"
    t.integer  "year"
    t.text     "publisher"
    t.text     "location"
    t.text     "booktitle"
    t.text     "journal"
    t.text     "pages"
    t.text     "volume"
    t.text     "number"
    t.text     "institution"
    t.text     "editor"
    t.text     "note"
    t.text     "author"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "parser"
  end

end
