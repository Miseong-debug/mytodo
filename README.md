# TodoList Backend - Authentication API

A secure authentication backend for TodoList application built with Node.js, Express, MariaDB, and JWT.

## Features

- ✅ User registration with email validation
- ✅ Secure password hashing using bcrypt
- ✅ JWT-based authentication
- ✅ Protected routes with middleware
- ✅ Input validation and sanitization
- ✅ Centralized error handling
- ✅ Security headers with Helmet
- ✅ CORS support

## Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MariaDB
- **Authentication**: JWT (JSON Web Tokens)
- **Password Hashing**: bcrypt
- **Validation**: express-validator
- **Security**: Helmet, CORS

## Prerequisites

- Node.js (v14 or higher)
- MariaDB (running on localhost)
- npm or yarn

## Installation

1. **Clone or navigate to the project directory**
   ```bash
   cd c:\myapp\mytodo
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment variables**
   
   The `.env` file is already configured with your database credentials:
   ```
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=scottmccall11!
   DB_NAME=mytodo
   JWT_SECRET=your-super-secret-jwt-key-change-this-in-production-12345
   PORT=3000
   NODE_ENV=development
   ```

4. **Ensure MariaDB is running**
   
   Make sure MariaDB is running and accessible with the credentials above.

## Running the Server

**Development mode:**
```bash
npm run dev
```

**Production mode:**
```bash
npm start
```

The server will start on `http://localhost:3000`

## API Endpoints

### 1. Health Check
```http
GET /health
```

**Response:**
```json
{
  "success": true,
  "message": "Server is running",
  "timestamp": "2025-11-25T02:27:05.000Z"
}
```

### 2. User Signup
```http
POST /api/auth/signup
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Success Response (201):**
```json
{
  "success": true,
  "message": "User registered successfully.",
  "data": {
    "userId": 1,
    "email": "user@example.com",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Error Response (409 - Email exists):**
```json
{
  "success": false,
  "message": "Email already registered."
}
```

**Error Response (400 - Validation error):**
```json
{
  "success": false,
  "errors": [
    {
      "field": "email",
      "message": "Please provide a valid email address"
    },
    {
      "field": "password",
      "message": "Password must be at least 6 characters long"
    }
  ]
}
```

### 3. User Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Login successful.",
  "data": {
    "userId": 1,
    "email": "user@example.com",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Error Response (401 - Invalid credentials):**
```json
{
  "success": false,
  "message": "Invalid email or password."
}
```

### 4. Get Current User (Protected)
```http
GET /api/auth/me
Authorization: Bearer <your-jwt-token>
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "email": "user@example.com",
    "createdAt": "2025-11-25T02:27:05.000Z"
  }
}
```

**Error Response (401 - No token):**
```json
{
  "success": false,
  "message": "Access denied. No token provided."
}
```

**Error Response (401 - Invalid token):**
```json
{
  "success": false,
  "message": "Invalid token."
}
```

## Database Schema

```sql
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

The table is automatically created when the server starts.

## Testing with curl

**1. Signup:**
```bash
curl -X POST http://localhost:3000/api/auth/signup -H "Content-Type: application/json" -d "{\"email\":\"test@example.com\",\"password\":\"test123\"}"
```

**2. Login:**
```bash
curl -X POST http://localhost:3000/api/auth/login -H "Content-Type: application/json" -d "{\"email\":\"test@example.com\",\"password\":\"test123\"}"
```

**3. Get current user (replace TOKEN with actual token from login):**
```bash
curl -X GET http://localhost:3000/api/auth/me -H "Authorization: Bearer TOKEN"
```

## Project Structure

```
mytodo/
├── src/
│   ├── config/
│   │   └── database.js          # Database connection pool
│   ├── controllers/
│   │   └── authController.js    # Authentication logic
│   ├── middleware/
│   │   ├── auth.js              # JWT authentication middleware
│   │   └── errorHandler.js      # Error handling middleware
│   ├── models/
│   │   └── userModel.js         # User database operations
│   ├── routes/
│   │   └── authRoutes.js        # API route definitions
│   ├── utils/
│   │   └── validators.js        # Input validation rules
│   ├── app.js                   # Express app configuration
│   └── server.js                # Server initialization
├── .env                         # Environment variables
├── .env.example                 # Environment template
├── .gitignore                   # Git ignore rules
├── package.json                 # Project dependencies
└── README.md                    # This file
```

## Security Features

- **Password Hashing**: Passwords are hashed using bcrypt with 10 salt rounds
- **JWT Authentication**: Tokens expire after 24 hours
- **Input Validation**: Email format and password strength validation
- **SQL Injection Protection**: Parameterized queries using mysql2
- **Security Headers**: Helmet middleware for HTTP security headers
- **CORS**: Cross-Origin Resource Sharing enabled
- **Error Sanitization**: Production errors don't leak sensitive information

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_HOST` | Database host | localhost |
| `DB_USER` | Database user | root |
| `DB_PASSWORD` | Database password | - |
| `DB_NAME` | Database name | mytodo |
| `JWT_SECRET` | Secret key for JWT signing | - |
| `PORT` | Server port | 3000 |
| `NODE_ENV` | Environment (development/production) | development |

## Error Handling

The API uses consistent error response format:

```json
{
  "success": false,
  "message": "Error description"
}
```

Common HTTP status codes:
- `200` - Success
- `201` - Created
- `400` - Bad Request (validation errors)
- `401` - Unauthorized (authentication errors)
- `404` - Not Found
- `409` - Conflict (duplicate email)
- `500` - Internal Server Error

## License

ISC