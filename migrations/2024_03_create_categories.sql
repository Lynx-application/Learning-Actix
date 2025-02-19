-- Up migration 
-- Predefined main categories
CREATE TYPE main_category AS ENUM (
    'Movies',
    'Music',
    'Engineering',
    'Art',
    'Entertainment',
    'Job_related',
    'Gaming',
    'Commercial',
    'Science',
    'Cooking',
    'Humane'
);

-- Table for main categories
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name main_category NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

-- Table for subcategories (tags)
CREATE TABLE subcategories (
    id SERIAL PRIMARY KEY,
    parent_id INTEGER REFERENCES categories(id) ON DELETE CASCADE,
    tag_name VARCHAR NOT NULL,  -- Will be stored with # prefix
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER REFERENCES users(id),
    is_active BOOLEAN DEFAULT true,
    CONSTRAINT unique_tag_per_parent UNIQUE(parent_id, tag_name),
    CONSTRAINT tag_format CHECK (tag_name ~ '^#[A-Za-z0-9_]+$')  
);

-- Table for chat category assignments
CREATE TABLE chat_category_assignments (
    id SERIAL PRIMARY KEY,
    chat_id INTEGER REFERENCES chats(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES categories(id) ON DELETE CASCADE,
    subcategory_id INTEGER REFERENCES subcategories(id) ON DELETE CASCADE,
    assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    assigned_by INTEGER REFERENCES users(id),
    CONSTRAINT unique_chat_category UNIQUE(chat_id, category_id, subcategory_id)
);

-- Insert predefined categories
INSERT INTO categories (name, description) VALUES
    ('Movies', 'Movie-related discussions and content'),
    ('Music', 'Music-related discussions and content'),
    ('Engineering', 'Engineering topics and discussions'),
    ('Art', 'Art-related content and discussions'),
    ('Entertainment', 'Entertainment and leisure activities'),
    ('Job_related', 'Career and job-related discussions'),
    ('Gaming', 'Gaming-related content and discussions'),
    ('Commercial', 'Business and commercial topics'),
    ('Science', 'Scientific discussions and content'),
    ('Cooking', 'Cooking and culinary discussions'),
    ('Humane', 'Humanitarian and social topics');

-- Down migration
DROP TABLE IF EXISTS chat_category_assignments;
DROP TABLE IF EXISTS subcategories;
DROP TABLE IF EXISTS categories;
DROP TYPE IF EXISTS main_category; 