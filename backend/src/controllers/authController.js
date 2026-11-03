// UC01, UC02, UC03: Authentication Controller
const User = require('../models/User');
const jwt = require('jsonwebtoken');

// Helper to generate JWT Token
const generateToken = (user) => {
  return jwt.sign(
    { id: user._id, email: user.email, role: user.role },
    process.env.JWT_SECRET || 'fallback_secret',
    { expiresIn: '30d' }
  );
};

// @desc    Register a new Document Owner
// @route   POST /api/auth/register
// @access  Public
// UC01: Register Account
exports.register = async (req, res) => {
  try {
    const { fullName, email, password, confirmPassword } = req.body;

    // UC01 Step 4 & Alternative Flow: Validate input
    if (!fullName || !email || !password || !confirmPassword) {
      return res.status(400).json({
        success: false,
        message: 'Please provide all required fields: name, email, password, and confirm password.',
      });
    }

    const emailRegex = /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid email address format.',
      });
    }

    if (password.length < 6) {
      return res.status(400).json({
        success: false,
        message: 'Password is too weak. Must be at least 6 characters long.',
      });
    }

    if (password !== confirmPassword) {
      return res.status(400).json({
        success: false,
        message: 'Passwords do not match.',
      });
    }

    // UC01 Step 5 & Alternative Flow: Check if email is already registered
    const existingUser = await User.findOne({ email: email.toLowerCase() });
    if (existingUser) {
      return res.status(409).json({
        success: false,
        alreadyRegistered: true,
        message: 'This email is already registered. Please log in instead.',
      });
    }

    // UC01 Step 6: Create account with role 'Owner'
    const user = await User.create({
      fullName,
      email: email.toLowerCase(),
      password,
      role: 'Owner',
      isSuspended: false,
    });

    // UC01 Step 7: Log in and return token + user info
    const token = generateToken(user);

    return res.status(201).json({
      success: true,
      message: 'Account registered successfully.',
      token,
      user: {
        id: user._id,
        fullName: user.fullName,
        email: user.email,
        role: user.role,
      },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message || 'Server error during registration.',
    });
  }
};

// @desc    Log in registered Document Owner or Admin
// @route   POST /api/auth/login
// @access  Public
// UC02: Log In
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Please provide both email and password.',
      });
    }

    // UC02 Step 4 & Alternative Flow: Check if user exists
    const user = await User.findOne({ email: email.toLowerCase() }).select('+password');
    if (!user) {
      return res.status(404).json({
        success: false,
        noAccount: true,
        message: 'No account exists for this email. Would you like to sign up?',
      });
    }

    // UC02 Alternative Flow: Check if account is suspended
    if (user.isSuspended) {
      return res.status(403).json({
        success: false,
        isSuspended: true,
        message: 'Your account has been suspended by an administrator. Please contact support.',
      });
    }

    // UC02 Step 4 & Alternative Flow: Validate password
    const isMatch = await user.matchPassword(password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Incorrect email or password. Please try again.',
      });
    }

    // UC02 Step 5 & 6: Sign in securely and return role
    const token = generateToken(user);

    return res.status(200).json({
      success: true,
      message: 'Logged in successfully.',
      token,
      user: {
        id: user._id,
        fullName: user.fullName,
        email: user.email,
        role: user.role,
      },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message || 'Server error during login.',
    });
  }
};

// @desc    Log out user
// @route   POST /api/auth/logout
// @access  Private / Public
// UC03: Log Out
exports.logout = async (req, res) => {
  try {
    // In JWT architecture, client clears stored token.
    return res.status(200).json({
      success: true,
      message: 'Logged out successfully.',
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message || 'Server error during logout.',
    });
  }
};

// @desc    Get currently logged in user
// @route   GET /api/auth/me
// @access  Private
exports.getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }
    return res.status(200).json({
      success: true,
      user: {
        id: user._id,
        fullName: user.fullName,
        email: user.email,
        role: user.role,
        isSuspended: user.isSuspended,
      },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message || 'Server error.',
    });
  }
};
