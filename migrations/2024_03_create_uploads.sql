-- Up migration
CREATE TYPE upload_type AS ENUM (
    'image',
    'video',
    'audio',
    'document',
    'voice',
    'other'
);

-- Table for uploaded files
CREATE TABLE uploads (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    type upload_type NOT NULL,
    original_name VARCHAR NOT NULL,
    file_path VARCHAR NOT NULL,
    mime_type VARCHAR,
    size BIGINT NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Table for upload usage (where the upload is being used)
CREATE TABLE upload_usage (
    id SERIAL PRIMARY KEY,
    upload_id INTEGER REFERENCES uploads(id) ON DELETE CASCADE,
    entity_type VARCHAR NOT NULL,  -- 'message', 'profile_picture', etc.
    entity_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_upload_usage UNIQUE(upload_id, entity_type, entity_id)
);

-- Down migration
DROP TABLE IF EXISTS upload_usage;
DROP TABLE IF EXISTS uploads;
DROP TYPE IF EXISTS upload_type; 