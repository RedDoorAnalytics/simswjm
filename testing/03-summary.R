library(tidyverse)
library(readxl)
library(devtools)
library(here)
library(glue)
library(readr)
library(stringi)
devtools::load_all()

# Informative settings:
infs <- c(0, 1)

# Outcome type:
otype <- c("g", "b", "c")

# Term names and submodel indicators
terms_g <- c("", "j=1", "j=2", "j=3", "j=4", "j=5", "", "x=1", "M1[i]", "M2[i>id]", "Intercept", "var(M1[i])", "var(M2[i>id])", "var(e.yobs)", "", "x=1", "M1[i]", "M2[i>id]", "Intercept", "ln_p", "")
terms_b_c <- c("", "j=1", "j=2", "j=3", "j=4", "j=5", "", "x=1", "M1[i]", "M2[i>id]", "Intercept", "var(M1[i])", "var(M2[i>id])", "", "x=1", "M1[i]", "M2[i>id]", "Intercept", "ln_p", "")
subm_g <- c(rep("glmm", 14), rep("surv", 6), "tmp")
subm_b_c <- c(rep("glmm", 13), rep("surv", 6), "tmp")

# Loop over everything and read in results:
results <- map_dfr(.x = otype, .f = function(o) {
  map_dfr(.x = infs, .f = function(i) {
    b <- read_excel(here(glue("testing/d{i}{o}_b.xlsx")))
    names(b) <- glue("{names(b)}_b")
    se <- read_excel(here(glue("testing/d{i}{o}_se.xlsx")))
    names(se) <- glue("{names(se)}_se")
    for (j in which(grepl(pattern = paste0(glue("d{i}{o}")), x = names(se)))) {
      se[[j]] <- stri_replace_all_fixed(str = se[[j]], pattern = "(", replacement = "")
      se[[j]] <- stri_replace_all_fixed(str = se[[j]], pattern = ")", replacement = "")
      se[[j]] <- parse_double(se[[j]])
    }
    dt <- bind_cols(b, se)
    if (!all.equal(dt$...1, dt$...4)) stop("Something happened and there was a mismatch.", call. = FALSE)
    dt$...1 <- NULL
    dt$...4 <- NULL
    if (o == "g") {
      dt$term <- terms_g
      dt$subm <- subm_g
    } else if (o %in% c("b", "c")) {
      dt$term <- terms_b_c
      dt$subm <- subm_b_c
    }
    dt <- dt |>
      pivot_longer(cols = starts_with(glue("d{i}{o}"))) |>
      filter(term != "")
    dt$o <- o
    dt$i <- i
    return(dt)
  })
})
results <- results |>
  separate(col = "name", into = c("file", "model", "par"), sep = "_") |>
  pivot_wider(names_from = "par", values_from = "value") |>
  select(-file) |>
  mutate(i = factor(i, levels = c(0, 1), labels = c("Non Informative", "Informative"))) |>
  mutate(model = factor(model, levels = c("glmm", "jm"), labels = c("GLMM", "JM")))

# True values
true <- tribble(
  ~o, ~subm, ~term, ~true,
  "g", "glmm", "j=1", 50,
  "g", "glmm", "j=2", 50,
  "g", "glmm", "j=3", 50,
  "g", "glmm", "j=4", 50,
  "g", "glmm", "j=5", 50,
  "g", "glmm", "x=1", 0.2,
  "g", "glmm", "M1[i]", 1.0,
  "g", "glmm", "M2[i>id]", 1.0,
  "g", "glmm", "Intercept", 0.0,
  "g", "glmm", "var(M1[i])", 1.0,
  "g", "glmm", "var(M2[i>id])", 54,
  "g", "glmm", "var(e.yobs)", 52.8,
  "g", "surv", "x=1", -0.2,
  "g", "surv", "M1[i]", -0.1,
  "g", "surv", "M2[i>id]", -0.1,
  "g", "surv", "Intercept", -1.5,
  "g", "surv", "ln_p", 0.0,
  "b", "glmm", "j=1", -2,
  "b", "glmm", "j=2", -2,
  "b", "glmm", "j=3", -2,
  "b", "glmm", "j=4", -2,
  "b", "glmm", "j=5", -2,
  "b", "glmm", "x=1", 0.2,
  "b", "glmm", "M1[i]", 1.0,
  "b", "glmm", "M2[i>id]", 1.0,
  "b", "glmm", "Intercept", 0.0,
  "b", "glmm", "var(M1[i])", 0.1,
  "b", "glmm", "var(M2[i>id])", 1.0,
  "b", "surv", "x=1", -0.1,
  "b", "surv", "M1[i]", 1.0,
  "b", "surv", "M2[i>id]", 0.4,
  "b", "surv", "Intercept", -1.5,
  "b", "surv", "ln_p", 0.0,
  "c", "glmm", "j=1", -1,
  "c", "glmm", "j=2", -1,
  "c", "glmm", "j=3", -1,
  "c", "glmm", "j=4", -1,
  "c", "glmm", "j=5", -1,
  "c", "glmm", "x=1", 0.1,
  "c", "glmm", "M1[i]", 1.0,
  "c", "glmm", "M2[i>id]", 1.0,
  "c", "glmm", "Intercept", 0.0,
  "c", "glmm", "var(M1[i])", 0.1,
  "c", "glmm", "var(M2[i>id])", 1.7,
  "c", "surv", "x=1", -0.2,
  "c", "surv", "M1[i]", 0.8,
  "c", "surv", "M2[i>id]", 0.3,
  "c", "surv", "Intercept", -1.5,
  "c", "surv", "ln_p", 0.0,
)
results <- left_join(results, true) |>
  mutate(o = factor(o, levels = c("g", "b", "c"), labels = c("Gaussian", "Binary", "Count"))) |>
  mutate(true = ifelse(subm == "surv" & i == "Non Informative" & term %in% c("M1[i]", "M2[i>id]"), 0.0, true)) |>
  rename(Term = term)

# Plots
for (.subm in unique(results$subm)) {
  for (.o in unique(results$o)) {
    this_plot <- ggplot(filter(results, subm == .subm & o == .o), aes(x = i, y = b, color = model)) +
      geom_point(aes(y = true), color = "red") +
      geom_errorbar(aes(ymin = b - qnorm(1 - 0.05 / 2) * se, ymax = b + qnorm(1 - 0.05 / 2) * se), position = position_dodge(width = 2 / 3)) +
      geom_point(position = position_dodge(width = 2 / 3)) +
      facet_wrap(~Term, scales = "free_x", labeller = label_both) +
      scale_color_viridis_d(end = 3 / 4) +
      coord_flip() +
      theme_bw(base_size = 12) +
      theme(legend.position = "top") +
      labs(x = "", y = "Parameter Estimate (95% C.I.)", color = "", caption = glue("Outcome: {.o}"))
    ggsave(filename = here(glue("testing/03-res-{.subm}-{.o}.pdf")), plot = this_plot, device = cairo_pdf, width = 8, height = 6)
  }
}
