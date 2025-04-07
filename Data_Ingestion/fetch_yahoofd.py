import yfinance as yf
import pandas as pd
from datetime import datetime
import os

def fetch_stock_data(ticker="AAPL", start="2023-01-01", end=None):
    if end is None:
        end = datetime.today().strftime('%Y-%m-%d')

    print(f"📈 Fetching data for {ticker} from {start} to {end}")
    df = yf.download(ticker, start=start, end=end)

    # Ensure output directory exists
    output_dir = "output"
    os.makedirs(output_dir, exist_ok=True)

    # Save as CSV
    filename = f"{ticker}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv"
    path = os.path.join(output_dir, filename)
    df.to_csv(path)
    print(f"✅ Data saved to: {path}")

if __name__ == "__main__":
    fetch_stock_data("AAPL", "2023-01-01")
