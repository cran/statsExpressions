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
mtcars |>
  group_by(am) |>
  group_modify(~ contingency_table(.x, vs), .keep = TRUE) |>
  ungroup()

## -----------------------------------------------------------------------------
pairwise_comparisons(
  data            = mtcars,
  x               = cyl,
  y               = wt,
  type            = "parametric",
  var.equal       = FALSE,
  p.adjust.method = "holm"
)

## -----------------------------------------------------------------------------
multi_test_results <- dplyr::bind_rows(
  two_sample_test(mtcars, am, wt, type = "parametric"),
  two_sample_test(mtcars, am, wt, type = "nonparametric"),
  two_sample_test(mtcars, am, wt, type = "robust")
) |>
  dplyr::mutate(p.value = stats::p.adjust(p.value, method = "holm"))

dplyr::select(multi_test_results, method, effectsize, estimate, p.value)

## -----------------------------------------------------------------------------
# suppose you have run your own statistical test
custom_stats <- cbind.data.frame(
  statistic  = 2.18,
  df         = 18,
  p.value    = 0.041,
  estimate   = 0.65,
  conf.level = 0.95,
  conf.low   = 0.03,
  conf.high  = 1.27,
  method     = "Student's t-test"
)

# generate a formatted expression
add_expression_col(
  data           = custom_stats,
  statistic.text = list(quote(italic("t"))),
  effsize.text   = list(quote(italic("d")["Cohen"])),
  n              = 20L,
  digits         = 2L,
  digits.df      = 0L
)$expression[[1]]

## -----------------------------------------------------------------------------
knitr::include_graphics("stats_reporting_format.png")

## -----------------------------------------------------------------------------
# needed libraries
library(ggplot2)

# Example 1: Performing a t-test on raw tidy data and extracting the formatted expression
# for direct use in a plot annotation
res_ttest <- two_sample_test(mtcars, am, wt, type = "parametric")

ggplot(mtcars, aes(as.factor(am), wt)) +
  geom_boxplot() +
  labs(
    x = "Transmission (0 = automatic, 1 = manual)",
    y = "Weight (1000 lbs)",
    title = "Vehicle Weight by Transmission Type",
    subtitle = res_ttest$expression[[1]] # Extract formatted p-value and effect size
  )

# Example 2: One-way ANOVA
res_anova <- oneway_anova(iris, Species, Sepal.Length, type = "nonparametric")

ggplot(iris, aes(x = Sepal.Length, y = Species)) +
  geom_boxplot() + # use 'expression' column to display results in the subtitle
  labs(
    x = "Penguin Species",
    y = "Body mass (in grams)",
    title = "Kruskal-Wallis Rank Sum Test",
    subtitle = res_anova$expression[[1]]
  )

