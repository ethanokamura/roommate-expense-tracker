// node/src/db/setup.js

const { query } = require("./connection");
const fs = require("fs");
const path = require("path");

async function setupDatabase() {
  try {
    console.log("🚀 Setting up database tables...");

    // Read the schema.sql file
    const schemaPath = path.join(__dirname, "schema.sql");
    const schema = fs.readFileSync(schemaPath, "utf8");

    // Execute the schema
    await query(schema);

    console.log("✅ Database tables created successfully!");

    // Test with a simple query
    const result = await query(
      "SELECT table_name FROM information_schema.tables WHERE table_schema = $1",
      ["public"]
    );
    console.log(
      "📋 Created tables:",
      result.rows.map((row) => row.table_name)
    );

    console.log("🌱 Seeding database...");
    const seedPath = path.join(__dirname, "seed.sql");
    const seed = fs.readFileSync(seedPath, "utf8");
    await query(seed);
    console.log("✅ Database seeded successfully!");
  } catch (error) {
    console.error("❌ Database setup failed:", error);
  } finally {
    process.exit();
  }
}

// Run the setup
setupDatabase();