library(tidyverse)
library(haven)
library(devtools)
library(here)
library(glue)
devtools::load_all()

# Read in results
results <- read_dta(here("testing/testing.dta")) |>
  mutate(outcome = factor(str_to_title(outcome), levels = c("Gaussian", "Binomial", "Count"))) |>
  mutate(inf = factor(inf, levels = c(0, 1), labels = c("Non Informative", "Informative"))) |>
  mutate(model = factor(model, levels = c(1, 2, 3), labels = c("GLMM (gsem)", "JM (gsem)", "JM (merlin)"))) |>
  mutate(subm = case_when(
    grepl("^y:", term) ~ "glmm",
    grepl("^t:", term) ~ "surv",
    .default = "var"
  ))

# Plots
for (.o in unique(results$outcome)) {
  this_plot <- ggplot(filter(results, outcome == .o), aes(x = inf, y = b, color = model)) +
    geom_point(aes(y = true), color = "red") +
    geom_errorbar(aes(ymin = b - qnorm(1 - 0.05 / 2) * stderr, ymax = b + qnorm(1 - 0.05 / 2) * stderr), position = position_dodge(width = 2 / 3)) +
    geom_point(position = position_dodge(width = 2 / 3)) +
    facet_wrap(~term, scales = "free_x") +
    scale_color_viridis_d(end = 3 / 4) +
    coord_flip() +
    theme_bw(base_size = 12) +
    theme(legend.position = "top") +
    labs(x = "", y = "Parameter Estimate (95% C.I.)", color = "", caption = glue("Outcome: {.o}"))
  ggsave(filename = here(glue("testing/03-res-{.o}.pdf")), plot = this_plot, device = cairo_pdf, width = 8, height = 8)
}
