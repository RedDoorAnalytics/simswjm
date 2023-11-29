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
  mutate(o = factor(o, levels = c("g", "b", "c"), labels = c("Gaussian", "Binary", "Count"))) |>
  mutate(model = factor(model, levels = c("glmm", "jm"), labels = c("GLMM", "JM")))
p_res <- ggplot(filter(results, subm == "glmm"), aes(x = term, y = b, color = model)) +
  geom_errorbar(aes(ymin = b - qnorm(1 - 0.05 / 2) * se, ymax = b + qnorm(1 - 0.05 / 2) * se), position = position_dodge(width = 2 / 3)) +
  geom_point(position = position_dodge(width = 2 / 3)) +
  facet_grid(i ~ o, scales = "free") +
  scale_color_viridis_d(end = 3 / 4) +
  coord_flip() +
  theme_bw(base_size = 12, base_family = "DM Sans") +
  theme(legend.position = "top") +
  labs(x = "", y = "Parameter Estimate (95% C.I.)", color = "")
ggsave(filename = here("testing/03-res.pdf"), plot = p_res, device = cairo_pdf, width = 9, height = 7)
