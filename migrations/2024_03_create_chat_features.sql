-- Up migration
-- Table for user blocks
CREATE TABLE user_blocks (
    id SERIAL PRIMARY KEY,
    blocker_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    blocked_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    UNIQUE(blocker_id, blocked_id)
);

-- Table for reports
CREATE TABLE reports (
    id SERIAL PRIMARY KEY,
    reporter_id INTEGER REFERENCES users(id),
    reported_user_id INTEGER REFERENCES users(id),
    chat_id INTEGER REFERENCES chats(id),
    message_id INTEGER REFERENCES messages(id),
    report_type VARCHAR NOT NULL,
    description TEXT,
    status VARCHAR NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP
);

-- Table for chat categories
CREATE TABLE chat_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER REFERENCES users(id)
);

-- Table for chat tags
CREATE TABLE chat_tags (
    id SERIAL PRIMARY KEY,
    chat_id INTEGER REFERENCES chats(id) ON DELETE CASCADE,
    name VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER REFERENCES users(id)
);

-- Table for saved messages (Important conversations)
CREATE TABLE saved_messages (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    message_id INTEGER REFERENCES messages(id) ON DELETE CASCADE,
    saved_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    note TEXT,
    UNIQUE(user_id, message_id)
);

-- Down migration
DROP TABLE IF EXISTS saved_messages;
DROP TABLE IF EXISTS chat_tags;
DROP TABLE IF EXISTS chat_categories;
DROP TABLE IF EXISTS reports;
DROP TABLE IF EXISTS user_blocks; 