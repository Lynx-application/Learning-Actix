-- Up migration
CREATE TYPE folder_type AS ENUM (
    'auto_category',    -- Folders filled with favorite chats and user categories
    'custom',          -- Empty folders created by user
    'saved_chats'      -- Folders with saved chats
);

-- Table for folders
CREATE TABLE folders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR NOT NULL,
    type folder_type NOT NULL,
    icon VARCHAR,
    color VARCHAR,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    settings JSONB DEFAULT '{}'::jsonb,
    CONSTRAINT unique_folder_name_per_user UNIQUE(user_id, name)
);

-- Table for folder items (chats in folders)
CREATE TABLE folder_items (
    id SERIAL PRIMARY KEY,
    folder_id INTEGER REFERENCES folders(id) ON DELETE CASCADE,
    chat_id INTEGER REFERENCES chats(id) ON DELETE CASCADE,
    added_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    added_by INTEGER REFERENCES users(id),
    CONSTRAINT unique_chat_per_folder UNIQUE(folder_id, chat_id)
);

-- Table for folder category filters (for auto_category type)
CREATE TABLE folder_category_filters (
    id SERIAL PRIMARY KEY,
    folder_id INTEGER REFERENCES folders(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES categories(id) ON DELETE CASCADE,
    subcategory_id INTEGER REFERENCES subcategories(id) ON DELETE SET NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_category_filter UNIQUE(folder_id, category_id, subcategory_id)
);

-- Down migration
DROP TABLE IF EXISTS folder_category_filters;
DROP TABLE IF EXISTS folder_items;
DROP TABLE IF EXISTS folders;
DROP TYPE IF EXISTS folder_type; 