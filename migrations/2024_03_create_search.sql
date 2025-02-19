-- Up migration
-- Table for search history
CREATE TABLE search_history (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    query TEXT NOT NULL,
    scope VARCHAR NOT NULL,  -- 'chat', 'global'
    filters JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Table for search indexes
CREATE TABLE search_indexes (
    id SERIAL PRIMARY KEY,
    entity_type VARCHAR NOT NULL,  -- 'message', 'chat', 'user'
    entity_id INTEGER NOT NULL,
    content TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    indexed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_entity UNIQUE(entity_type, entity_id)
);

-- Create indexes for full-text search
CREATE INDEX idx_search_content ON search_indexes USING gin(to_tsvector('english', content));
CREATE INDEX idx_search_metadata ON search_indexes USING gin(metadata);

-- Down migration
DROP INDEX IF EXISTS idx_search_metadata;
DROP INDEX IF EXISTS idx_search_content;
DROP TABLE IF EXISTS search_indexes;
DROP TABLE IF EXISTS search_history; 