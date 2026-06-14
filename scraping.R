
library(httr)
library(readr)
library(dplyr)
library(tidyr)
library(tibble)
library(purrr)
library(janitor)

matches <- read_csv("data/wc2026_matches.csv")
players = read_csv("data/wc2026_players.csv")

get_efi_partido <- function(id) {
  Sys.sleep(2)  
  
  url <- paste0("https://fdh-api.fifa.com/v1/stats/match/", id, "/players.json")
  
  tryCatch({
    resp  <- GET(url)
    
    stats <- resp %>% 
            content() %>% 
            enframe("player_id", "values") %>%
            unnest_longer(values) %>%
            hoist(values,
                  metric_name  = 1,
                  metric_value = 2) %>%
            select(-values) %>%
            mutate(
              player_id = as.integer(player_id),
              match_id  = id
            ) %>%
            pivot_wider(names_from  = metric_name,
                        values_from = metric_value) %>%
            clean_names()
          
    message("✓ Partido ", id, " descargado (", nrow(stats), " jugadores)")
    stats
    
  }, error = function(e) {
    warning("✗ Partido ", id, " falló: ", conditionMessage(e))
    NULL  
  })
}

played_games <- nrow(matches %>% filter(date < Sys.time()))
ids <- matches$result_id[1:played_games]

all_stats_efi <- map_df(ids, get_efi_partido)


data_efi <- all_stats_efi %>% 
            inner_join(players, by = "player_id")

write_csv(data_efi, "data/efi_wc2026.csv")
