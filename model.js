const mongoose = require("mongoose");

// Định nghĩa schema 
const CustomerSchema = new mongoose.Schema({
    name: { type: String, required: true },
    email: { type: String, unique: true, required: true },
});

// Tạo model
const Customer = mongoose.model("DKP-test", CustomerSchema);

module.exports = Customer;
