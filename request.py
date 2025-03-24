import requests

# Gọi API lấy dữ liệu đơn hàng
response = requests.get("https://api....")
data = response.json()

# Kiểm tra dữ liệu
for order in data:
    if not order["order_id"] or not order["customer_name"]:
        print(f"Lỗi: Đơn hàng {order['order_id']} bị thiếu thông tin!")





        