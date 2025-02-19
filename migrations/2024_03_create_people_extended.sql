-- Up migration
-- Update people types
CREATE TYPE people_type AS ENUM (
    'subscriber',    -- Chat subscribers
    'contact',      -- Saved contacts
    'regular',      -- Regular users
    'business',     -- Business accounts
    'bot',          -- Bot accounts
    'system'        -- System accounts
);

-- User status and blocking features
CREATE TYPE user_status AS ENUM (
    'active',
    'blocked',
    'suspended',
    'deleted'
);

-- Create contacts table
CREATE TABLE contacts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    contact_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    nickname VARCHAR,
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_contact UNIQUE(user_id, contact_id)
);

-- Create subscribers table
CREATE TABLE chat_subscribers (
    id SERIAL PRIMARY KEY,
    chat_id INTEGER REFERENCES chats(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    subscribed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    subscription_type VARCHAR NOT NULL DEFAULT 'free',
    expires_at TIMESTAMP,
    CONSTRAINT unique_subscriber UNIQUE(chat_id, user_id)
);

-- Create custom roles table
CREATE TABLE custom_roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    permissions JSONB DEFAULT '{}'::jsonb
);

-- Create user blocking settings table
CREATE TABLE user_blocking_settings (
    id SERIAL PRIMARY KEY,
    blocker_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    blocked_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    hide_info BOOLEAN DEFAULT true,        -- Hide user info (banner, avatar, bio, etc)
    block_mentions BOOLEAN DEFAULT true,    -- Make user unmentionable
    block_search BOOLEAN DEFAULT true,      -- Make user unsearchable
    block_messages BOOLEAN DEFAULT true,    -- Block messages
    block_forwards BOOLEAN DEFAULT true,    -- No message forwarding
    block_two_way_deletion BOOLEAN DEFAULT true,  -- No two-way message deletion
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_block_settings UNIQUE(blocker_id, blocked_id)
);

-- Extend users table with additional fields
ALTER TABLE users 
ADD COLUMN status user_status DEFAULT 'active',
ADD COLUMN custom_role_id INTEGER REFERENCES custom_roles(id),
ADD COLUMN profile_settings JSONB DEFAULT '{
    "privacy": {
        "show_online_status": true,
        "show_last_seen": true,
        "show_profile_photo": true,
        "allow_messages_from": "all",
        "allow_forward": true
    }
}'::jsonb;

-- Create indexes
CREATE INDEX idx_contacts_user_id ON contacts(user_id);
CREATE INDEX idx_subscribers_chat_id ON chat_subscribers(chat_id);
CREATE INDEX idx_blocking_blocker_id ON user_blocking_settings(blocker_id);

-- Down migration
DROP INDEX IF EXISTS idx_blocking_blocker_id;
DROP INDEX IF EXISTS idx_subscribers_chat_id;
DROP INDEX IF EXISTS idx_contacts_user_id;

ALTER TABLE users 
DROP COLUMN status,
DROP COLUMN custom_role_id,
DROP COLUMN profile_settings;

DROP TABLE IF EXISTS user_blocking_settings;
DROP TABLE IF EXISTS custom_roles;
DROP TABLE IF EXISTS chat_subscribers;
DROP TABLE IF EXISTS contacts;

DROP TYPE IF EXISTS user_status; 