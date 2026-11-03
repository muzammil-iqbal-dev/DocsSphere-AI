// UC01, UC02, UC03: Authentication Routes
const express = require('express');
const router = express.Router();
const {
  register,
  login,
  logout,
  getMe,
} = require('../controllers/authController');
const { protect } = require('../middleware/authMiddleware');

// UC01: Register Account
router.post('/register', register);

// UC02: Log In
router.post('/login', login);

// UC03: Log Out
router.post('/logout', logout);

// Get currently authenticated user profile
router.get('/me', protect, getMe);

module.exports = router;
