-- Table: Users
CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    display_name VARCHAR(100),
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table: Houses
-- Stores information about each house.
CREATE TABLE IF NOT EXISTS houses (
    house_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    invite_code VARCHAR(50) UNIQUE NOT NULL,
    user_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT
);

-- Table: HouseMembers
-- Links Users to Houses and stores house-specific user roles/details.
CREATE TABLE IF NOT EXISTS house_members (
    house_member_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    house_id UUID NOT NULL,
    is_admin BOOLEAN DEFAULT FALSE NOT NULL, -- True if this member is the "Head of House" for this house
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    nickname VARCHAR(100), -- House-specific nickname for the user
    is_active BOOLEAN DEFAULT TRUE NOT NULL, -- For managing (add/remove) members without deleting history
    UNIQUE (user_id, house_id), -- A user can only be a member of a house once
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (house_id) REFERENCES houses(house_id) ON DELETE CASCADE
);

-- Table: Expenses
-- Stores details of individual expenses posted within a house.
CREATE TABLE IF NOT EXISTS expenses (
    expense_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    house_id UUID NOT NULL,
    house_member_id UUID NOT NULL, -- The HouseMember who posted the expense
    title VARCHAR(100) NOT NULL,
    description TEXT,
    splits JSONB NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
    expense_date DATE NOT NULL DEFAULT CURRENT_DATE,
    category VARCHAR(100), -- E.g., 'Rent', 'Groceries', 'Utilities'
    is_settled BOOLEAN DEFAULT FALSE NOT NULL, -- Whether the expense has been fully settled
    settled_at TIMESTAMP WITH TIME ZONE, -- When the expense was settled (nullable)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (house_id) REFERENCES houses(house_id) ON DELETE CASCADE,
    FOREIGN KEY (house_member_id) REFERENCES house_members(house_member_id) ON DELETE RESTRICT
);
