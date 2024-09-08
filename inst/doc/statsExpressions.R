## -----------------------------------------------------------------------------
source("setup.R")

pkgs <- "ggplot2"

successfully_loaded <- purrr::map_lgl(pkgs, requireNamespace, quietly = TRUE)
can_evaluate <- all(successfully_loaded)

if (can_evaluate) {
  purrr::walk(pkgs, library, character.only = TRUE)
} else {
  knitr::opts_chunk$set(eval = FALSE)
}

## -----------------------------------------------------------------------------
citation("statsExpressions")

## -----------------------------------------------------------------------------
oneway_anova(mtcars, cyl, wt, type = "nonparametric")

oneway_anova(mtcars, cyl, wt, type = "robust")

## -----------------------------------------------------------------------------
# running one-sample proportion test for `vs` at all levels of `am`
mtcars %>%
  group_by(am) %>%
  group_modify(~ contingency_table(.x, vs), .keep = TRUE) %>%
  ungroup()

## -----------------------------------------------------------------------------
knitr::include_graphics("stats_reporting_format.png")

## -----------------------------------------------------------------------------
# needed libraries
library(ggplot2)

# creating a data frame
res <- oneway_anova(iris, Species, Sepal.Length, type = "nonparametric")

ggplot(iris, aes(x = Sepal.Length, y = Species)) +
  geom_boxplot() + # use 'expression' column to display results in the subtitle
  labs(
    x = "Penguin Species",
    y = "Body mass (in grams)",
    title = "Kruskal-Wallis Rank Sum Test",
    subtitle = res$expression[[1]]
  )

