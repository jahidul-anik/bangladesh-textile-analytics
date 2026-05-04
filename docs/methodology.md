# Technical Methodology

## Data Model

Star schema with `orders` as fact table:
- `buyers` dimension (Buyer_ID)
- `fabrics` dimension (Fabric_Type)
- `campaigns` and `inventory` as standalone analysis tables

## SQL Architecture

### Window Functions Used
- `RANK()` — Fabric performance ranking
- `NTILE(4)` — RFM quartile scoring
- `SUM() OVER (PARTITION BY... ROWS BETWEEN...)` — Running totals

### CTEs
- `buyer_metrics` — Aggregates recency, frequency, monetary values
- `scored` — Applies NTILE scoring

## DAX Architecture

### Time Intelligence
All time-based measures use a custom `DateTable` marked as date table:
- `TOTALYTD()` — Year-to-date accumulation
- `SAMEPERIODLASTYEAR()` — Prior period comparison
- `DATESINPERIOD()` — Rolling window calculations

### Context Transition
`CALCULATE()` used with `ALLEXCEPT()` and `ALL()` to modify filter context 
for percentage-of-total and ranking measures.

## Data Generation

Python script using pandas and numpy with:
- Seasonal multipliers (peaks in Q2 and Q4)
- Buyer tier-based quantity distributions
- Regional shipping day variations
- Realistic price negotiation ranges
