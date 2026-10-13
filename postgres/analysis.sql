-- Bitcoin Price Analysis
-- Data: 6,484 days of daily BTC price history (2010-2026)
-- Database: btc_spiral | Table: btc_daily


-- ── 1. Biggest single-day crashes ─────────────────────────────────────────
SELECT date, price_usd_close,
       LAG(price_usd_close) OVER (ORDER BY date) AS prev_price,
       ROUND(((price_usd_close / LAG(price_usd_close) OVER (ORDER BY date)) - 1) * 100, 2) AS pct_change
FROM btc_daily
WHERE price_usd_close > 0
ORDER BY pct_change ASC
LIMIT 10;


-- ── 2. Biggest single-day pumps ────────────────────────────────────────────
SELECT date, price_usd_close,
       LAG(price_usd_close) OVER (ORDER BY date) AS prev_price,
       ROUND(((price_usd_close / LAG(price_usd_close) OVER (ORDER BY date)) - 1) * 100, 2) AS pct_change
FROM btc_daily
WHERE price_usd_close > 0
ORDER BY pct_change DESC
LIMIT 10;


-- ── 3. 200-day moving average (most recent 15 days) ───────────────────────
SELECT date, price_usd_close,
       ROUND(AVG(price_usd_close) OVER (
           ORDER BY date
           ROWS BETWEEN 199 PRECEDING AND CURRENT ROW
       ), 2) AS moving_avg_200
FROM btc_daily
WHERE price_usd_close > 0
ORDER BY date DESC
LIMIT 15;


-- ── 4. Yearly volatility (std dev of daily returns) ──────────────────────
WITH daily_returns AS (
    SELECT
        EXTRACT(YEAR FROM date) AS year,
        (price_usd_close / LAG(price_usd_close) OVER (ORDER BY date) - 1) AS daily_return
    FROM btc_daily
    WHERE price_usd_close > 0
)
SELECT
    year,
    ROUND(STDDEV(daily_return) * 100, 2) AS volatility_pct
FROM daily_returns
WHERE daily_return IS NOT NULL
GROUP BY year
ORDER BY year;


-- ── 5. Cycle data: End/Start dates, cycle_lows, cycle_highs and cycle_avg ──────────────────────
WITH cycles AS (
    SELECT
        date,
        price_usd_close,
        block_height / 210000 AS cycle
    FROM btc_daily
    WHERE price_usd_close > 0
)
SELECT
    cycle,
    MIN(date) AS cycle_start,
    MAX(date) AS cycle_end,
    ROUND(MIN(price_usd_close)::numeric, 2) AS cycle_low,
    ROUND(MAX(price_usd_close)::numeric, 2) AS cycle_high,
    ROUND(AVG(price_usd_close)::numeric, 2) AS avg_price
FROM cycles
GROUP BY cycle
ORDER BY cycle;

-- ── 6. Worst drawdowns from all-time high ──────────────────────
WITH highs AS (
    SELECT
        date,
        price_usd_close,
        MAX(price_usd_close) OVER (ORDER BY date) AS running_ath
    FROM btc_daily
    WHERE price_usd_close > 0
)
SELECT
    date,
    price_usd_close,
    running_ath,
    ROUND(((price_usd_close / running_ath) - 1) * 100, 2) AS drawdown_pct
FROM highs
ORDER BY drawdown_pct ASC
LIMIT 10; 