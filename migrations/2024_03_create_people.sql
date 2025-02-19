-- Up migration
-- People types and states
CREATE TYPE people_type AS ENUM (
    'regular',      -- Normal users
    'business',     -- Business accounts
    'bot',          -- Bot accounts
    'system'        -- System accounts
);

CREATE TYPE user_state AS ENUM (
    'online',
    'offline',
    'away',
    'busy',
    'invisible'
);

CREATE TYPE user_role AS ENUM (
    'super_admin',
    'admin',
    'moderator',
    'premium_user',
    'regular_user'
);

-- Extend users table with additional fields
ALTER TABLE users 
ADD COLUMN type people_type NOT NULL DEFAULT 'regular',
ADD COLUMN role user_role NOT NULL DEFAULT 'regular_user',
ADD COLUMN current_state user_state DEFAULT 'offline',
ADD COLUMN last_seen_at TIMESTAMP,
ADD COLUMN is_verified BOOLEAN DEFAULT false,
ADD COLUMN metadata JSONB DEFAULT '{}'::jsonb;

-- Table for user presence history
CREATE TABLE user_presence_history (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    state user_state NOT NULL,
    started_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP
);

-- Table for role permissions
CREATE TABLE role_permissions (
    id SERIAL PRIMARY KEY,
    role user_role NOT NULL,
    permission_name VARCHAR NOT NULL,
    granted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    granted_by INTEGER REFERENCES users(id),
    CONSTRAINT unique_role_permission UNIQUE(role, permission_name)
);

-- Down migration
DROP TABLE IF EXISTS role_permissions;
DROP TABLE IF EXISTS user_presence_history;
ALTER TABLE users 
DROP COLUMN type,
DROP COLUMN role,
DROP COLUMN current_state,
DROP COLUMN last_seen_at,
DROP COLUMN is_verified,
DROP COLUMN metadata;
DROP TYPE IF EXISTS user_role;
DROP TYPE IF EXISTS user_state;
DROP TYPE IF EXISTS people_type; 