const express = require("express");
const Customer = require("./models/Customer");

const app = express();
app.use(express.json());

// API: Lấy danh sách khách hàng
app.get("/DKP-test", async (req, res) => {
    const customers = await Customer.find();
    res.json(customers);
});

// API: Thêm khách hàng mới
app.post("/DKP-test", async (req, res) => {
    try {
        const newCustomer = new Customer(req.body);
        await newCustomer.save();
        res.status(201).json(newCustomer);
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
});

// API: Cập nhật thông tin 
app.put("/DKP-test/:id", async (req, res) => {
    try {
        const updatedCustomer = await Customer.findByIdAndUpdate(req.params.id, req.body, { new: true });
        res.json(updatedCustomer);
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
});

// API: Xóa
app.delete("/customers/:id", async (req, res) => {
    await Customer.findByIdAndDelete(req.params.id);
    res.json({ message: "Khách hàng đã bị xóa!" });
});

app.listen(3000, () => console.log("Server đang chạy trên cổng 3000"));
