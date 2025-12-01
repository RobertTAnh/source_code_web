# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_08_29_050141) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_logs", force: :cascade do |t|
    t.string "state"
    t.string "code"
    t.jsonb "action_data"
    t.jsonb "object_before"
    t.bigint "actor_id"
    t.string "actionable_type"
    t.bigint "actionable_id"
    t.jsonb "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "changed_data"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "albums", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug"
    t.bigint "owner_id"
    t.string "owner_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_albums_on_discarded_at"
    t.index ["slug"], name: "index_albums_on_slug"
  end

  create_table "cart_items", force: :cascade do |t|
    t.string "customer_uuid"
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_id"
    t.bigint "variant_id"
    t.index ["order_id"], name: "index_cart_items_on_order_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
    t.index ["variant_id"], name: "index_cart_items_on_variant_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.bigint "parent_id"
    t.integer "depth", null: false
    t.bigint "view_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kind"
    t.string "description"
    t.string "status"
    t.string "image_url"
    t.integer "display_order"
    t.string "locale", limit: 2, default: "vi", null: false
    t.string "universal_slug"
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_categories_on_discarded_at"
    t.index ["name"], name: "idx_name_on_categories"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["slug", "locale"], name: "index_categories_on_slug_and_locale", unique: true, where: "(discarded_at IS NULL)"
    t.index ["slug"], name: "idx_slug_on_categories"
    t.index ["universal_slug", "locale"], name: "index_categories_on_universal_slug_and_locale", unique: true, where: "(discarded_at IS NULL)"
    t.index ["view_id"], name: "index_categories_on_view_id"
  end

  create_table "categorizations", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "categorizable_type", null: false
    t.bigint "categorizable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "primary"
    t.index ["categorizable_type", "categorizable_id"], name: "index_categorizations_on_categorizable"
    t.index ["category_id", "categorizable_id", "categorizable_type"], name: "index_categorizations_on_category_id_and_categorizable", unique: true
    t.index ["category_id"], name: "index_categorizations_on_category_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "name"
    t.string "user_uuid"
    t.boolean "is_admin", default: false, null: false
    t.string "phone"
    t.string "email"
    t.string "address"
    t.text "content", null: false
    t.integer "depth", default: 0, null: false
    t.integer "rate"
    t.string "status", null: false
    t.bigint "owner_id"
    t.string "owner_type"
    t.bigint "user_id"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "form"
    t.string "name"
    t.string "phone"
    t.string "email"
    t.text "note"
    t.jsonb "extra"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_contacts_on_discarded_at"
  end

  create_table "contents", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.text "description"
    t.text "body"
    t.string "image_url"
    t.string "meta_title"
    t.string "meta_keywords"
    t.string "meta_description"
    t.string "tracking_head"
    t.string "tracking_body"
    t.string "tracking_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "seo_index", default: true
    t.boolean "seo_follow", default: true
    t.text "table_of_content"
    t.jsonb "seo_schema"
    t.jsonb "seo_schema_breadcumb"
    t.jsonb "catalog"
    t.string "meta_image_url"
    t.jsonb "custom_content"
    t.index ["owner_type", "owner_id"], name: "index_contents_on_owner", unique: true
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "extra_fields", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "data"
    t.string "data_type"
    t.index ["owner_type", "owner_id", "key"], name: "index_extra_fields_on_owner_type_and_owner_id_and_key", unique: true
    t.index ["owner_type", "owner_id"], name: "index_extra_fields_on_owner"
  end

  create_table "global_slugs", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "sluggable_id", null: false
    t.string "sluggable_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "primary", default: false
    t.string "locale", limit: 2, default: "vi", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_global_slugs_on_discarded_at"
    t.index ["name", "locale"], name: "index_global_slugs_on_name_and_locale", unique: true, where: "(discarded_at IS NULL)"
  end

  create_table "granted_permissions", force: :cascade do |t|
    t.bigint "permission_id", null: false
    t.string "granted_to_type"
    t.bigint "granted_to_id"
    t.jsonb "conditions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_granted_permissions_on_permission_id"
  end

  create_table "ip_logs", force: :cascade do |t|
    t.string "ip"
    t.string "action"
    t.boolean "spam"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.float "original_price"
    t.float "price"
    t.integer "quantity"
    t.float "discount_percentage"
    t.jsonb "variants"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "variant_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
    t.index ["variant_id"], name: "index_order_items_on_variant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "code", null: false
    t.string "customer_uuid"
    t.string "customer_name"
    t.string "customer_email"
    t.string "customer_phone"
    t.string "payment_method"
    t.string "shipping_method"
    t.jsonb "shipping_address"
    t.boolean "invoice_required"
    t.jsonb "invoice_data"
    t.string "status"
    t.float "vat_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.jsonb "extra"
    t.index ["code"], name: "index_orders_on_code", unique: true, where: "(discarded_at IS NULL)"
    t.index ["discarded_at"], name: "index_orders_on_discarded_at"
  end

  create_table "page_contents", force: :cascade do |t|
    t.jsonb "data"
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_page_contents_on_owner", unique: true
  end

  create_table "pages", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.bigint "view_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.string "status"
    t.string "description"
    t.string "locale", limit: 2, default: "vi", null: false
    t.string "universal_slug"
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_pages_on_discarded_at"
    t.index ["slug", "locale"], name: "index_pages_on_slug_and_locale", unique: true, where: "(discarded_at IS NULL)"
    t.index ["universal_slug", "locale"], name: "index_pages_on_universal_slug_and_locale", unique: true, where: "(discarded_at IS NULL)"
    t.index ["view_id"], name: "index_pages_on_view_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name"
    t.string "granted_on"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.bigint "view_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.string "image_url"
    t.string "status"
    t.integer "display_order"
    t.datetime "release_date"
    t.integer "view_count", default: 0
    t.string "locale", limit: 2, default: "vi", null: false
    t.string "universal_slug"
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_posts_on_discarded_at"
    t.index ["name"], name: "idx_name_on_posts"
    t.index ["slug", "locale"], name: "index_posts_on_slug_and_locale", unique: true, where: "(discarded_at IS NULL)"
    t.index ["slug"], name: "idx_slug_on_posts"
    t.index ["universal_slug", "locale"], name: "index_posts_on_universal_slug_and_locale", unique: true, where: "(discarded_at IS NULL)"
    t.index ["view_id"], name: "index_posts_on_view_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.bigint "view_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.string "description"
    t.string "status"
    t.float "original_price"
    t.float "price"
    t.float "discount_percentage"
    t.string "sku", null: false
    t.integer "display_order"
    t.jsonb "properties"
    t.jsonb "variant_options"
    t.float "review_rating"
    t.integer "view_count", default: 0
    t.string "locale", limit: 2, default: "vi", null: false
    t.string "universal_slug"
    t.datetime "discarded_at"
    t.string "kind"
    t.index ["discarded_at"], name: "index_products_on_discarded_at"
    t.index ["name"], name: "idx_name_on_products"
    t.index ["sku", "locale"], name: "index_products_on_sku_and_locale", unique: true, where: "(discarded_at IS NULL)"
    t.index ["slug", "locale"], name: "index_products_on_slug_and_locale", unique: true, where: "(discarded_at IS NULL)"
    t.index ["slug"], name: "idx_slug_on_products"
    t.index ["universal_slug", "locale"], name: "index_products_on_universal_slug_and_locale", unique: true, where: "(discarded_at IS NULL)"
    t.index ["view_id"], name: "index_products_on_view_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "type", null: false
    t.string "slug"
    t.string "name", null: false
    t.bigint "view_id"
    t.string "image_url"
    t.string "status"
    t.string "description"
    t.jsonb "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locale", limit: 2, default: "vi", null: false
    t.string "universal_slug"
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_resources_on_discarded_at"
    t.index ["universal_slug", "locale"], name: "index_resources_on_universal_slug_and_locale", unique: true, where: "(discarded_at IS NULL)"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "protected"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "owner_id", null: false
    t.string "owner_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "owner_id", "owner_type"], name: "index_tags_on_name_and_owner_id_and_owner_type", unique: true
  end

  create_table "themes", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "is_default", default: false
    t.string "source", null: false
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "image_url"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variants", force: :cascade do |t|
    t.string "name"
    t.string "sku", null: false
    t.jsonb "options"
    t.float "price"
    t.float "original_price"
    t.bigint "owner_id"
    t.string "owner_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "properties"
    t.string "image_url"
    t.string "status", default: "published"
    t.index ["sku", "owner_type"], name: "index_variants_on_sku_and_owner_type", unique: true
  end

  create_table "views", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.bigint "theme_id", null: false
    t.string "viewable_type"
    t.string "view_type"
    t.integer "version"
    t.string "template_format"
    t.text "template"
    t.string "path"
    t.text "javascript"
    t.text "style"
    t.jsonb "config"
    t.jsonb "data"
    t.bigint "layout_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["layout_id"], name: "index_views_on_layout_id"
    t.index ["theme_id"], name: "index_views_on_theme_id"
  end

  create_table "web_configs", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cart_items", "orders"
  add_foreign_key "cart_items", "products"
  add_foreign_key "cart_items", "variants"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "categories", "views"
  add_foreign_key "categorizations", "categories"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "users"
  add_foreign_key "granted_permissions", "permissions"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "order_items", "variants"
  add_foreign_key "pages", "views"
  add_foreign_key "posts", "views"
  add_foreign_key "products", "views"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "views", "themes"
  add_foreign_key "views", "views", column: "layout_id"
end
