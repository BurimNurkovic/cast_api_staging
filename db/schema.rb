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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160609020046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "amazon_offers", force: true do |t|
    t.string   "amazon_id"
    t.string   "offer_listing_id"
    t.integer  "normal_price"
    t.integer  "sale_price"
    t.integer  "lowest_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", force: true do |t|
    t.integer  "question_id"
    t.string   "text"
    t.integer  "order_by",    default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "blogentries", force: true do |t|
    t.integer  "blog_type"
    t.string   "title"
    t.text     "text"
    t.string   "video_url"
    t.boolean  "is_deleted",         default: false, null: false
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "url"
  end

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "favorites", force: true do |t|
    t.string   "amazon_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "advert_title"
    t.string   "advert_vendor"
    t.string   "advert_image_url"
    t.integer  "advert_price_amount"
    t.string   "advert_price_currency"
    t.string   "advert_price_formatted"
  end

  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "locations", force: true do |t|
    t.integer  "user_id"
    t.string   "display_name"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["user_id"], name: "index_locations_on_user_id", using: :btree

  create_table "product_search_logs", force: true do |t|
    t.integer  "user_id"
    t.string   "status",         default: "success"
    t.string   "search_type"
    t.string   "search_level"
    t.string   "keywords"
    t.integer  "current_page"
    t.integer  "products_count", default: 0
    t.text     "search_results"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "request_params"
    t.text     "response_body"
  end

  create_table "push_conditions", force: true do |t|
    t.string   "skin_type"
    t.string   "hair_type"
    t.integer  "minimum_temperature"
    t.integer  "maximum_temperature"
    t.integer  "minimum_humidity"
    t.integer  "maximum_humidity"
    t.string   "time_of_a_day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "amazon_tags"
    t.string   "type"
    t.text     "country_codes"
    t.string   "menu_item",           default: "home"
    t.string   "status",              default: "pending"
    t.integer  "match_users_count",   default: 0
  end

  create_table "push_texts", force: true do |t|
    t.string   "text"
    t.integer  "push_condition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "push_texts", ["push_condition_id"], name: "index_push_texts_on_push_condition_id", using: :btree

  create_table "push_texts_users", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "push_text_id"
  end

  create_table "questions", force: true do |t|
    t.string   "text"
    t.integer  "question_type"
    t.integer  "limit",         default: 1, null: false
    t.integer  "order_by",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "responses", force: true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.integer  "order_by",    default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responses", ["answer_id"], name: "index_responses_on_answer_id", using: :btree
  add_index "responses", ["question_id"], name: "index_responses_on_question_id", using: :btree
  add_index "responses", ["user_id"], name: "index_responses_on_user_id", using: :btree

  create_table "shopping_carts", force: true do |t|
    t.string   "cart_id"
    t.string   "cart_hmac"
    t.integer  "user_id"
    t.string   "status",              default: "new"
    t.integer  "product_type_count"
    t.integer  "items_count"
    t.text     "products"
    t.integer  "sub_total_amount"
    t.string   "sub_total_currency"
    t.string   "sub_total_formatted"
    t.string   "purchase_url"
    t.text     "response_body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shopping_product_images", force: true do |t|
    t.string   "asin"
    t.string   "image_full_url"
    t.string   "image_thumb_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",               default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "age"
    t.string   "hair_type"
    t.string   "skin_type"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "auth_token"
    t.string   "installation_id"
    t.string   "facebook_id"
    t.string   "amazon_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "postal_town"
    t.string   "country"
    t.string   "endpoint_arn"
    t.string   "postal_code"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
