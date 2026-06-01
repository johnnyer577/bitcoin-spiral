# Bitcoin Price Spiral

An animated visualization of Bitcoin's price history mapped to block height, displayed as a polar spiral alongside a traditional linear chart.

<!-- Replace the line below with your actual GIF once exported -->
<!-- ![Bitcoin Spiral Animation](bitcoin_spiral.gif) -->

## What This Shows

Bitcoin's mining schedule runs on a fixed drumbeat: every **210,000 blocks**, the block reward is cut in half (a "halving"). This visualization uses that rhythm as a clock:

- **Left — Spiral (polar chart):** Each full loop = one halving cycle (210,000 blocks). The angle represents where we are in the current cycle (like a clock face: 12, 1, 2... 11). The radius represents price on a log scale ($1 → $10M).
- **Right — Linear chart:** Traditional price-vs-block-height view, with dynamic axes that rescale as the animation progresses.

Both charts draw simultaneously, day by day, from Bitcoin's genesis block in January 2009 through today.

## Data

`BTC_DATA/btc_data.csv` — 6,300+ rows of daily data:

| Column | Description |
|---|---|
| `timestamp` | Unix timestamp (UTC midnight) |
| `date` | YYYY-MM-DD |
| `price_usd_close` | Daily closing price in USD (source: CoinGecko) |
| `block_height` | Last block mined that calendar day (source: Blockchain.info) |

**Note:** Data is daily resolution — one row per day, mapped to the last block mined that day. True per-block pricing doesn't exist since exchange prices run on real-world clocks, not block clocks. This is the standard approach.

## How to Run

```bash
# Clone the repo
git clone https://github.com/fudruster/bitcoin-spiral.git
cd bitcoin-spiral

# Install dependencies
pip install pandas matplotlib numpy jupyter

# Launch Jupyter
jupyter notebook bitcoin_spiral_graph.ipynb
```

Run all cells. The final cell renders the full animation inline in the notebook.

## Tech Stack

- Python 3, Jupyter Notebook
- `pandas` — data loading
- `matplotlib` — polar + linear charts, `FuncAnimation`
- Data: CoinGecko (prices) + Blockchain.info (block heights)
