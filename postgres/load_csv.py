import csv 
import psycopg2

conn = psycopg2.connect(dbname="btc_spiral", user="johnnyreed")
cursor = conn.cursor()

with open("../BTC_DATA/btc_data.csv") as f:
    reader = csv.DictReader(f)
    for row in reader:
        if float(row["price_usd_close"]) == 0:
            continue
        cursor.execute("""
            INSERT INTO btc_daily (date, timestamp, price_usd_close, block_height)
            VALUES (%s, %s, %s, %s)
            ON CONFLICT (date) DO NOTHING
        """, (
            row["date"],
            int(float(row["timestamp"])),
            float(row["price_usd_close"]),
            int(float(row["block_height"]))
        ))
conn.commit()
print("done inserting rows. ")

# Verify
cursor.execute("SELECT COUNT(*) FROM btc_daily")
count = cursor.fetchone()[0]
print(f"Rows in database: {count}")

cursor.close()
conn.close()

