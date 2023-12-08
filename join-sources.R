


icews_scores <- read_csv("output/dissent-scores-icews.csv") %>%
  mutate(data_source = "ICEWS") %>%
  glimpse()

idea_scores <- read_csv("output/dissent-scores.csv") %>%
  mutate(data_source = "IDEA") %>%
  glimpse()

scores <- bind_rows(icews_scores, idea_scores) |> 
  write_csv("output/joined-dissent-scores.csv") |>
  glimpse()
