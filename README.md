# EFI FIFA Data — World Cup 2026 🏆
 
Automated pipeline to collect and store **Enhanced Football Intelligence (EFI)** data from the official FIFA website for the 2026 FIFA World Cup (USA · Canada · Mexico).
 
## What it does
 
Scrapes EFI metrics from the FIFA platform after each matchday and stores structured data ready for analysis. Data is updated daily and versioned through Git, providing a clean historical record across the full tournament.
 
## How it works
 
A scheduled **GitHub Actions** workflow runs automatically once a day (04:00 UTC), after the latest matches have concluded and FIFA has processed the data. No manual intervention required.
 
```
FIFA Website → GitHub Actions (scraper) → CSV / structured data → repository
```
 
## Data coverage
 
- All group stage, knockout, and final matches
- EFI scores per player and match
- Updated daily throughout the tournament (June 11 – July 19, 2026)

## Schedule
 
```yaml
on:
  schedule:
    - cron: '0 4 * * *'   # Daily at 04:00 UTC
  workflow_dispatch:        # Manual trigger available
```
 
## Stack
 
- **Scraping**: R (`httr`)
- **Process**: R (`dplyr`,`tidyr`,`tibble`,`purrr`,`janitor`)
- **Automation**: GitHub Actions
- **Storage**: CSV files versioned in this repository

## Use case
 
The data collected by this pipeline feeds the production of **post-match summary reports** published on the [FIFA Training Centre — Match Report Hub](https://www.fifatrainingcentre.com/en/fifa-world-cup-2026/match-report-hub.php). These reports cover all FIFA World Cup 2026™ matches, organised by group, and are released progressively as the tournament unfolds.
 
EFI metrics extracted here are used to analyse player and team performance across each match, supporting the technical narrative in those reports.

## Usage
 
Clone the repo and use the data directly from the `data/` folder. No setup needed: files are refreshed automatically.
 
```r
library(readr)
efi <- read_csv("data/wc2026_efi.csv")
```
 
---
 
> Data sourced from the official FIFA platform. This repository is intended for analytical and research purposes only.
