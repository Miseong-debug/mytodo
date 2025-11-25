require('dotenv').config();
const bcrypt = require('bcrypt');
const { pool } = require('./src/config/database');

async function initDatabase() {
    try {
        console.log('Initializing database...\n');

        // Drop existing users table
        console.log('Dropping existing users table...');
        await pool.execute('DROP TABLE IF EXISTS users');
        console.log('✓ Table dropped\n');

        // Create new users table with username
        console.log('Creating users table...');
        const createTableQuery = `
            CREATE TABLE users (
                id INT PRIMARY KEY AUTO_INCREMENT,
                username VARCHAR(50) UNIQUE NOT NULL,
                password_hash VARCHAR(255) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        `;
        await pool.execute(createTableQuery);
        console.log('✓ Users table created\n');

        // Create root user
        console.log('Creating root user...');
        const rootPassword = 'scottmccall11!';
        const passwordHash = await bcrypt.hash(rootPassword, 10);

        await pool.execute(
            'INSERT INTO users (username, password_hash) VALUES (?, ?)',
            ['root', passwordHash]
        );
        console.log('✓ Root user created');
        console.log(`  Username: root`);
        console.log(`  Password: ${rootPassword}\n`);

        console.log('✅ Database initialization complete!');
        process.exit(0);
    } catch (error) {
        console.error('❌ Error:', error.message);
        process.exit(1);
    }
}

initDatabase();
