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
('1e3d39a4-763e-41cd-a445-d1b0702bdf4e', 'bc0fca49-00c2-4c60-80ae-4e5df36e2054', '7a3c7edb-9673-45c1-bdb4-2d69cf5f96e4', 'Groceries', 'Weekly groceries shopping', '{ "member_splits": [ { "member_id": "c04355e1-9d60-4d79-a2e3-cbc773e66307", "amount_owed": 50.0, "paid_on": "2025-07-07 14:18:23" }, { "member_id": "9d7e114a-1cb3-4f61-8a9d-47fda72b2b88", "amount_owed": 45.75, "paid_on": "2025-06-25 09:30:00" }] }', 100.00, '2025-07-07 00:00:00', 'Groceries', TRUE, '2025-07-07 14:18:23', '2025-07-07 14:18:23', '2025-07-07 14:18:23'),
('c924d66c-0b47-4805-a7bc-57f3d97deca4', 'bc0fca49-00c2-4c60-80ae-4e5df36e2054', '1bfb2302-b002-4c5d-9bc2-96e24ad0ac48', 'Internet Bill', 'Monthly internet bill', '{ "member_splits": [ { "member_id": "c04355e1-9d60-4d79-a2e3-cbc773e66307", "amount_owed": 30.0, "paid_on": "2025-07-01 10:05:00" }, { "member_id": "9d7e114a-1cb3-4f61-8a9d-47fda72b2b88", "amount_owed": 30.0, "paid_on": "2025-07-03 16:20:00" } ] }', 100.00, '2025-07-01 00:00:00', 'Utilities', TRUE, '2025-07-03 16:20:00', '2025-07-03 16:20:00', '2025-07-03 16:20:00'),
('278e3e4f-e48c-4c8f-b8ec-c66d4fda54de', 'bc0fca49-00c2-4c60-80ae-4e5df36e2054', 'b2455b8a-b8ae-4933-91c0-13f45beae4b4', 'Cleaning Supplies', 'Bought cleaning stuff', '{ "member_splits": [ { "member_id": "c04355e1-9d60-4d79-a2e3-cbc773e66307", "amount_owed": 10.5, "paid_on": "2025-07-09 11:45:00" }, { "member_id": "9d7e114a-1cb3-4f61-8a9d-47fda72b2b88", "amount_owed": 10.5, "paid_on": null }, { "member_id": "64a6bc4f-0e6f-4d11-bcae-087a54fa7f8e", "amount_owed": 5.0, "paid_on": null } ] }', 100.00, '2025-07-09', 'Household', FALSE, NULL, '2025-07-09 11:45:00', '2025-07-09 11:45:00');

-- Blue Cottage
INSERT INTO expenses (expense_id, house_id, house_member_id, title, description, splits, total_amount, expense_date, category, is_settled, settled_at, created_at, updated_at) VALUES
('7b9f9705-72bc-4b95-8746-40cf34702be3', 'c781b376-5c18-4d6f-a415-b6117fe8e4b5', '30b0c262-4b3a-4fc1-b740-c7ad2d805eb1', 'Rent', 'Monthly rent payment', '{ "member_splits": [ { "member_id": "c04355e1-9d60-4d79-a2e3-cbc773e66307", "amount_owed": 1375.0, "paid_on": "2025-06-27 08:00:00" }, { "member_id": "978e57b25-f5fc-4c18-8c9f-02467f340be0", "amount_owed": 1225.0, "paid_on": "2025-06-26 13:00:00" }] }', 1500.00, '2025-07-01 00:00:00', 'Rent', TRUE, '2025-06-27 08:00:00', '2025-06-27 08:00:00', '2025-06-27 08:00:00'),
('62b2354f-019b-4dd6-a2fd-b6558b18e02c', 'c781b376-5c18-4d6f-a415-b6117fe8e4b5', '6822648d-4322-49ee-8907-bc009b41eac4', 'Electricity', 'Monthly electricity bill', '{ "member_splits": [ { "member_id": "c04355e1-9d60-4d79-a2e3-cbc773e66307", "amount_owed": 1375.0, "paid_on": "2025-07-06 17:00:00" }, { "member_id": "978e57b25-f5fc-4c18-8c9f-02467f340be0", "amount_owed": 1225.0, "paid_on": "2025-07-05 10:00:00" }] }', 200.00, '2025-07-08 09:15:00', 'Utilities', FALSE, NULL, '2025-07-06 17:00:00', '2025-07-06 17:00:00'),
('6fa3706d-b0cb-48e7-bfc2-e0fca3451dc3', 'c781b376-5c18-4d6f-a415-b6117fe8e4b5', '93a7b413-865e-4915-a2ce-cf365391b3e5', 'Water Bill', 'Monthly water bill', '{ "member_splits": [ { "member_id": "c04355e1-9d60-4d79-a2e3-cbc773e66307", "amount_owed": 50.0, "paid_on": "2025-07-08 09:15:00" }, { "member_id": "3c63a392-f260-4b64-9627-64ef31e67ff5", "amount_owed": 45.75, "paid_on": null }] }', 150.00, '2025-07-08', 'Utilities', FALSE, NULL, '2025-07-08 09:15:00', '2025-07-08 09:15:00');

-- Red Mansion
INSERT INTO expenses (expense_id, house_id, house_member_id, title, description, splits, total_amount, expense_date, category, is_settled, settled_at, created_at, updated_at) VALUES
('d7331ed9-7394-45ed-a23e-292f2237e9e5', 'a64f391d-e0e4-4cc4-9473-0508c247c57d', '9b44ff87-74a9-4b27-84d1-38cc0f4d18ec', 'Furniture', 'Bought a new sofa', '{ "member_splits": [ { "member_id": "64a6bc4f-0e6f-4d11-bcae-087a54fa7f8e", "amount_owed": 70.0, "paid_on": null }, { "member_id": "78e57b25-f5fc-4c18-8c9f-02467f340be0", "amount_owed": 30.0, "paid_on": null }] }', 800.00, '2025-07-12 15:00:00', 'Furniture', FALSE, NULL, '2025-07-10 15:00:00', '2025-07-10 15:00:00');