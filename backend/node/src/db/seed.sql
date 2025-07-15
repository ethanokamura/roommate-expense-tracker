-- USERS
INSERT INTO users (user_id, display_name, email, created_at, updated_at) VALUES
('9d7e114a-1cb3-4f61-8a9d-47fda72b2b88', 'Alice Johnson', 'alice@example.com', NOW(), NOW()),
('c04355e1-9d60-4d79-a2e3-cbc773e66307', 'Bob Smith', 'bob@example.com', NOW(), NOW()),
('3c63a392-f260-4b64-9627-64ef31e67ff5', 'Charlie Brown', 'charlie@example.com', NOW(), NOW()),
('64a6bc4f-0e6f-4d11-bcae-087a54fa7f8e', 'Diana Prince', 'diana@example.com', NOW(), NOW()),
('78e57b25-f5fc-4c18-8c9f-02467f340be0', 'Evan Lee', 'evan@example.com', NOW(), NOW());

-- HOUSES
INSERT INTO houses (house_id, name, invite_code, user_id, created_at, updated_at) VALUES
('bc0fca49-00c2-4c60-80ae-4e5df36e2054', 'Green Villa', 'GREEN123', '9d7e114a-1cb3-4f61-8a9d-47fda72b2b88', NOW(), NOW()),
('c781b376-5c18-4d6f-a415-b6117fe8e4b5', 'Blue Cottage', 'BLUE456', 'c04355e1-9d60-4d79-a2e3-cbc773e66307', NOW(), NOW()),
('a64f391d-e0e4-4cc4-9473-0508c247c57d', 'Red Mansion', 'RED789', '64a6bc4f-0e6f-4d11-bcae-087a54fa7f8e', NOW(), NOW());

-- HOUSE MEMBERS
-- Green Villa
INSERT INTO house_members (house_member_id, user_id, house_id, is_admin, nickname, is_active, created_at, updated_at) VALUES
('7a3c7edb-9673-45c1-bdb4-2d69cf5f96e4', '9d7e114a-1cb3-4f61-8a9d-47fda72b2b88', 'bc0fca49-00c2-4c60-80ae-4e5df36e2054', TRUE, 'AliceG', TRUE, NOW(), NOW()),
('1bfb2302-b002-4c5d-9bc2-96e24ad0ac48', 'c04355e1-9d60-4d79-a2e3-cbc773e66307', 'bc0fca49-00c2-4c60-80ae-4e5df36e2054', FALSE, 'BobG', TRUE, NOW(), NOW()),
('b2455b8a-b8ae-4933-91c0-13f45beae4b4', '64a6bc4f-0e6f-4d11-bcae-087a54fa7f8e', 'bc0fca49-00c2-4c60-80ae-4e5df36e2054', FALSE, 'DianaG', TRUE, NOW(), NOW());

-- Blue Cottage
INSERT INTO house_members (house_member_id, user_id, house_id, is_admin, nickname, is_active, created_at, updated_at) VALUES
('30b0c262-4b3a-4fc1-b740-c7ad2d805eb1', 'c04355e1-9d60-4d79-a2e3-cbc773e66307', 'c781b376-5c18-4d6f-a415-b6117fe8e4b5', TRUE, 'BobB', TRUE, NOW(), NOW()),
('6822648d-4322-49ee-8907-bc009b41eac4', '3c63a392-f260-4b64-9627-64ef31e67ff5', 'c781b376-5c18-4d6f-a415-b6117fe8e4b5', FALSE, 'CharlieB', TRUE, NOW(), NOW()),
('93a7b413-865e-4915-a2ce-cf365391b3e5', '78e57b25-f5fc-4c18-8c9f-02467f340be0', 'c781b376-5c18-4d6f-a415-b6117fe8e4b5', FALSE, 'EvanB', TRUE, NOW(), NOW());

-- Red Mansion
INSERT INTO house_members (house_member_id, user_id, house_id, is_admin, nickname, is_active, created_at, updated_at) VALUES
('9b44ff87-74a9-4b27-84d1-38cc0f4d18ec', '64a6bc4f-0e6f-4d11-bcae-087a54fa7f8e', 'a64f391d-e0e4-4cc4-9473-0508c247c57d', TRUE, 'DianaR', TRUE, NOW(), NOW()),
('c715f84d-3d33-4c39-902f-ea13e90d8e88', '78e57b25-f5fc-4c18-8c9f-02467f340be0', 'a64f391d-e0e4-4cc4-9473-0508c247c57d', FALSE, 'EvanR', TRUE, NOW(), NOW());

-- EXPENSES
-- Green Villa
INSERT INTO expenses (expense_id, house_id, house_member_id, title, description, splits, total_amount, expense_date, category, is_settled, settled_at, created_at, updated_at) VALUES
('1e3d39a4-763e-41cd-a445-d1b0702bdf4e', 'bc0fca49-00c2-4c60-80ae-4e5df36e2054', '7a3c7edb-9673-45c1-bdb4-2d69cf5f96e4', 'Groceries', 'Weekly groceries shopping', '{"9d7e114a-1cb3-4f61-8a9d-47fda72b2b88": 50, "c04355e1-9d60-4d79-a2e3-cbc773e66307": 50}', 100.00, '2025-07-10', 'Groceries', FALSE, NULL, NOW(), NOW()),
('c924d66c-0b47-4805-a7bc-57f3d97deca4', 'bc0fca49-00c2-4c60-80ae-4e5df36e2054', '1bfb2302-b002-4c5d-9bc2-96e24ad0ac48', 'Internet Bill', 'Monthly internet bill', '{"9d7e114a-1cb3-4f61-8a9d-47fda72b2b88": 70, "c04355e1-9d60-4d79-a2e3-cbc773e66307": 30}', 100.00, '2025-07-05', 'Utilities', TRUE, NOW(), NOW(), NOW()),
('278e3e4f-e48c-4c8f-b8ec-c66d4fda54de', 'bc0fca49-00c2-4c60-80ae-4e5df36e2054', 'b2455b8a-b8ae-4933-91c0-13f45beae4b4', 'Cleaning Supplies', 'Bought cleaning stuff', '{"9d7e114a-1cb3-4f61-8a9d-47fda72b2b88": 30, "c04355e1-9d60-4d79-a2e3-cbc773e66307": 20, "64a6bc4f-0e6f-4d11-bcae-087a54fa7f8e": 50}', 100.00, '2025-07-11', 'Household', FALSE, NULL, NOW(), NOW());

-- Blue Cottage
INSERT INTO expenses (expense_id, house_id, house_member_id, title, description, splits, total_amount, expense_date, category, is_settled, settled_at, created_at, updated_at) VALUES
('7b9f9705-72bc-4b95-8746-40cf34702be3', 'c781b376-5c18-4d6f-a415-b6117fe8e4b5', '30b0c262-4b3a-4fc1-b740-c7ad2d805eb1', 'Rent', 'Monthly rent payment', '{"c04355e1-9d60-4d79-a2e3-cbc773e66307": 60, "3c63a392-f260-4b64-9627-64ef31e67ff5": 40}', 1500.00, '2025-07-01', 'Rent', TRUE, NOW(), NOW(), NOW()),
('62b2354f-019b-4dd6-a2fd-b6558b18e02c', 'c781b376-5c18-4d6f-a415-b6117fe8e4b5', '6822648d-4322-49ee-8907-bc009b41eac4', 'Electricity', 'Monthly electricity bill', '{"c04355e1-9d60-4d79-a2e3-cbc773e66307": 50, "3c63a392-f260-4b64-9627-64ef31e67ff5": 50}', 200.00, '2025-07-08', 'Utilities', FALSE, NULL, NOW(), NOW()),
('6fa3706d-b0cb-48e7-bfc2-e0fca3451dc3', 'c781b376-5c18-4d6f-a415-b6117fe8e4b5', '93a7b413-865e-4915-a2ce-cf365391b3e5', 'Water Bill', 'Monthly water bill', '{"c04355e1-9d60-4d79-a2e3-cbc773e66307": 40, "3c63a392-f260-4b64-9627-64ef31e67ff5": 30, "78e57b25-f5fc-4c18-8c9f-02467f340be0": 30}', 150.00, '2025-07-09', 'Utilities', FALSE, NULL, NOW(), NOW());

-- Red Mansion
INSERT INTO expenses (expense_id, house_id, house_member_id, title, description, splits, total_amount, expense_date, category, is_settled, settled_at, created_at, updated_at) VALUES
('d7331ed9-7394-45ed-a23e-292f2237e9e5', 'a64f391d-e0e4-4cc4-9473-0508c247c57d', '9b44ff87-74a9-4b27-84d1-38cc0f4d18ec', 'Furniture', 'Bought a new sofa', '{"64a6bc4f-0e6f-4d11-bcae-087a54fa7f8e": 70, "78e57b25-f5fc-4c18-8c9f-02467f340be0": 30}', 800.00, '2025-07-12', 'Furniture', FALSE, NULL, NOW(), NOW());
