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
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE RESTRICT
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
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (house_id) REFERENCES Houses(house_id) ON DELETE CASCADE
);

-- Table: Expenses
-- Stores details of individual expenses posted within a house.
CREATE TABLE IF NOT EXISTS expenses (
    expense_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    house_id UUID NOT NULL,
    house_member_id UUID NOT NULL, -- The HouseMember who posted the expense
    description TEXT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
    expense_date DATE NOT NULL DEFAULT CURRENT_DATE,
    category VARCHAR(100), -- E.g., 'Rent', 'Groceries', 'Utilities'
    is_settled BOOLEAN DEFAULT FALSE NOT NULL, -- Whether the expense has been fully settled
    settled_at TIMESTAMP WITH TIME ZONE, -- When the expense was settled (nullable)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (house_id) REFERENCES Houses(house_id) ON DELETE CASCADE,
    FOREIGN KEY (house_member_id) REFERENCES HouseMembers(house_member_id) ON DELETE RESTRICT
);

-- Table: ExpenseSplits
-- Details how an expense is divided among house members.
CREATE TABLE IF NOT EXISTS expense_spits (
    expense_split_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expense_id UUID NOT NULL,
    house_member_id UUID NOT NULL, -- The HouseMember responsible for this portion of the expense
    amount_owed DECIMAL(10, 2) NOT NULL CHECK (amount_owed >= 0),
    is_paid BOOLEAN DEFAULT FALSE NOT NULL, -- Whether this specific split portion has been paid
    paid_at TIMESTAMP WITH TIME ZONE, -- When this split portion was paid (nullable)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (expense_id) REFERENCES Expenses(expense_id) ON DELETE CASCADE,
    FOREIGN KEY (house_member_id) REFERENCES HouseMembers(house_member_id) ON DELETE RESTRICT
);

-- Table: Receipts
-- Stores references to uploaded receipts/images for expenses.
CREATE TABLE IF NOT EXISTS receipts (
    receipt_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expense_id UUID UNIQUE NOT NULL, -- One receipt per expense for simplicity, or remove UNIQUE for multiple
    image_url TEXT NOT NULL, -- Path or URL to the stored image
    user_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (expense_id) REFERENCES Expenses(expense_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE RESTRICT
);

-- Table: RecurringExpenses
-- Stores templates for recurring payments.
CREATE TABLE IF NOT EXISTS recurring_expenses (
    recurring_expense_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    house_id UUID NOT NULL,
    house_member_id UUID NOT NULL,
    description_template TEXT NOT NULL,
    amount_template DECIMAL(10, 2) NOT NULL,
    frequency VARCHAR(50) NOT NULL, -- E.g., 'monthly', 'weekly', 'yearly'
    start_date DATE NOT NULL,
    end_date DATE, -- Nullable, if recurring indefinitely
    next_due_date DATE NOT NULL, -- The date the next instance of this expense is due
    is_active BOOLEAN DEFAULT TRUE NOT NULL, -- Can be deactivated/cancelled
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (house_id) REFERENCES Houses(house_id) ON DELETE CASCADE,
    FOREIGN KEY (house_member_id) REFERENCES HouseMembers(house_member_id) ON DELETE RESTRICT
);
