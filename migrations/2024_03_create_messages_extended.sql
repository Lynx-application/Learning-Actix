-- Up migration
-- Message types
CREATE TYPE message_type AS ENUM (
    'text',
    'video',
    'gif',
    'voice',
    'music',
    'image',
    'file',
    'large_file',
    'private_message'
);

-- Message formatting types
CREATE TYPE text_decoration AS ENUM (
    'bold',
    'italic',
    'underline',
    'strikethrough',
    'spoiler',
    'code',
    'quote'
);

-- Create messages table with extended features
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    chat_id INTEGER REFERENCES chats(id) ON DELETE CASCADE,
    sender_id INTEGER REFERENCES users(id),
    reply_to_id INTEGER REFERENCES messages(id),
    type message_type NOT NULL DEFAULT 'text',
    content TEXT,
    formatted_content JSONB, -- For storing text with decorations
    caption TEXT,
    media_url TEXT,
    file_metadata JSONB DEFAULT '{}'::jsonb, -- For storing file-specific metadata
    is_edited BOOLEAN DEFAULT false,
    is_deleted BOOLEAN DEFAULT false,
    is_forwarded BOOLEAN DEFAULT false,
    is_private BOOLEAN DEFAULT false,
    show_sender_name BOOLEAN DEFAULT true, -- For forwarded messages
    expires_at TIMESTAMP, -- For timed messages
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    CONSTRAINT valid_timed_message CHECK (
        (type = 'text' AND expires_at IS NOT NULL) OR
        expires_at IS NULL
    )
);

-- Table for message mentions
CREATE TABLE message_mentions (
    id SERIAL PRIMARY KEY,
    message_id INTEGER REFERENCES messages(id) ON DELETE CASCADE,
    mentioned_user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    mention_type VARCHAR NOT NULL DEFAULT 'text', -- 'text' or 'caption'
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_mention UNIQUE(message_id, mentioned_user_id)
);

-- Table for message downloads
CREATE TABLE message_downloads (
    id SERIAL PRIMARY KEY,
    message_id INTEGER REFERENCES messages(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    downloaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    download_type VARCHAR NOT NULL, -- 'media', 'file', etc.
    CONSTRAINT unique_download UNIQUE(message_id, user_id)
);

-- Table for message forwards
CREATE TABLE message_forwards (
    id SERIAL PRIMARY KEY,
    original_message_id INTEGER REFERENCES messages(id),
    forwarded_message_id INTEGER REFERENCES messages(id),
    forwarded_by INTEGER REFERENCES users(id),
    show_sender BOOLEAN DEFAULT true,
    show_caption BOOLEAN DEFAULT true,
    forwarded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Table for favorite messages
CREATE TABLE favorite_messages (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    message_id INTEGER REFERENCES messages(id) ON DELETE CASCADE,
    added_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    CONSTRAINT unique_favorite UNIQUE(user_id, message_id)
);

-- Table for message edit history
CREATE TABLE message_edit_history (
    id SERIAL PRIMARY KEY,
    message_id INTEGER REFERENCES messages(id) ON DELETE CASCADE,
    previous_content TEXT,
    previous_formatted_content JSONB,
    edited_by INTEGER REFERENCES users(id),
    edited_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_messages_chat_id ON messages(chat_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_type ON messages(type);
CREATE INDEX idx_message_mentions_message_id ON message_mentions(message_id);
CREATE INDEX idx_favorite_messages_user_id ON favorite_messages(user_id);

-- Down migration
DROP INDEX IF EXISTS idx_favorite_messages_user_id;
DROP INDEX IF EXISTS idx_message_mentions_message_id;
DROP INDEX IF EXISTS idx_messages_type;
DROP INDEX IF EXISTS idx_messages_sender_id;
DROP INDEX IF EXISTS idx_messages_chat_id;

DROP TABLE IF EXISTS message_edit_history;
DROP TABLE IF EXISTS favorite_messages;
DROP TABLE IF EXISTS message_forwards;
DROP TABLE IF EXISTS message_downloads;
DROP TABLE IF EXISTS message_mentions;
DROP TABLE IF EXISTS messages;

DROP TYPE IF EXISTS text_decoration;
DROP TYPE IF EXISTS message_type; 