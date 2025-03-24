
import logging

logging.basicConfig(filename=r"C:\Documents\in_dkp\akop\etl_log.txt", level=logging.INFO)

try:
    logging.info("Bắt đầu quá trình ETL")

    response = requests.get(api_url)
    if response.status_code == 200:
        logging.info("Lấy dữ liệu thành công từ API")
    else:
        logging.error(f"Lỗi API: {response.status_code}")

    # xử lý dữ liệu
    df = pd.DataFrame(response.json())
    if df.empty:
        logging.warning("Dữ liệu rỗng!")
    
    # nhập vào database
    cursor.execute("INSERT INTO orders ...")
    logging.info("Dữ liệu đã được nhập thành công")

except Exception as e:
    logging.error(f"Lỗi pipeline: {str(e)}")
