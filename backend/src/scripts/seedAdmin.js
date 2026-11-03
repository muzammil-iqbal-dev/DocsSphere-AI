// Pre-seed Admin account as specified in 00-overview.md and 01-account.md
require('dotenv').config({ path: require('path').resolve(__dirname, '../../.env') });
const mongoose = require('mongoose');
const User = require('../models/User');

const seedAdmin = async () => {
  try {
    const mongoUri = process.env.MONGODB_URI;
    if (!mongoUri) {
      console.error('MONGODB_URI is not defined in .env');
      process.exit(1);
    }

    await mongoose.connect(mongoUri);
    console.log('[Seed] Connected to MongoDB Atlas');

    const adminEmail = (process.env.ADMIN_EMAIL || 'admin@docsphere.ai').toLowerCase();
    const adminPassword = process.env.ADMIN_PASSWORD || 'Admin@DocSphere2026';

    const existingAdmin = await User.findOne({ email: adminEmail });
    if (existingAdmin) {
      console.log(`[Seed] Admin account (${adminEmail}) already exists. Role: ${existingAdmin.role}`);
    } else {
      await User.create({
        fullName: 'System Administrator',
        email: adminEmail,
        password: adminPassword,
        role: 'Admin',
        isSuspended: false,
      });
      console.log(`[Seed] Admin account created successfully! Email: ${adminEmail}`);
    }

    await mongoose.disconnect();
    console.log('[Seed] Disconnected from MongoDB Atlas');
    process.exit(0);
  } catch (error) {
    console.error(`[Seed Error] ${error.message}`);
    process.exit(1);
  }
};

seedAdmin();
