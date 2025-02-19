-- Up migration
CREATE TYPE chat_type AS ENUM ('direct', 'group', 'channel', 'session', 'comment');

CREATE TABLE chats (
    id SERIAL PRIMARY KEY,
    type chat_type NOT NULL,
    title VARCHAR,  -- Null for direct chats
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    owner_id INTEGER REFERENCES users(id),
    is_active BOOLEAN DEFAULT true,
    settings JSONB DEFAULT '{}'::jsonb  
);

-- For tracking chat participants and their roles
CREATE TABLE chat_members (
    id SERIAL PRIMARY KEY,
    chat_id INTEGER REFERENCES chats(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR NOT NULL DEFAULT 'member',  -- 'owner', 'admin', 'member' 
    joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_muted BOOLEAN DEFAULT false,
    mute_until TIMESTAMP,
    settings JSONB DEFAULT '{}'::jsonb,  -- User-specific settings for this chat
    UNIQUE(chat_id, user_id)
);

-- Down migration
DROP TABLE IF EXISTS chat_members;
DROP TABLE IF EXISTS chats;
DROP TYPE IF EXISTS chat_type; 