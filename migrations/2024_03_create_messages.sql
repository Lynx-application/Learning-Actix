-- Up migration
CREATE TYPE message_type AS ENUM ('text', 'image', 'video', 'audio', 'file', 'voice', 'location');

CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    chat_id INTEGER REFERENCES chats(id) ON DELETE CASCADE,
    sender_id INTEGER REFERENCES users(id),
    reply_to_id INTEGER REFERENCES messages(id),
    type message_type NOT NULL DEFAULT 'text',
    content TEXT,
    media_url TEXT,  
    metadata JSONB DEFAULT '{}'::jsonb,  
    is_edited BOOLEAN DEFAULT false,
    is_deleted BOOLEAN DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    is_secured BOOLEAN DEFAULT false  
);

-- Table for message reactions
CREATE TABLE message_reactions (
    id SERIAL PRIMARY KEY,
    message_id INTEGER REFERENCES messages(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    reaction VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(message_id, user_id, reaction)
);

-- Table for message deletions (to track who deleted what and how)
CREATE TABLE message_deletions (
    id SERIAL PRIMARY KEY,
    message_id INTEGER REFERENCES messages(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id),
    deletion_type VARCHAR NOT NULL,  -- 'for_me', 'for_everyone'
    deleted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Table for forwarded messages
CREATE TABLE message_forwards (
    id SERIAL PRIMARY KEY,
    original_message_id INTEGER REFERENCES messages(id),
    forwarded_message_id INTEGER REFERENCES messages(id),
    forwarded_by INTEGER REFERENCES users(id),
    forwarded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Down migration
DROP TABLE IF EXISTS message_forwards;
DROP TABLE IF EXISTS message_deletions;
DROP TABLE IF EXISTS message_reactions;
DROP TABLE IF EXISTS messages;
DROP TYPE IF EXISTS message_type; 