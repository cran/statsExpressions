#' @title Correlation analyses
#' @name corr_test
#'
#' @description
#'
#'  A dataframe containing results from correlation test with confidence
#'  intervals for the correlation coefficient estimate.
#'
#' @references To see details about functions which are internally used to carry
#'   out these analyses, see the following vignette-
#' \url{https://indrajeetpatil.github.io/statsExpressions/articles/stats_details.html}
#'
#' @param x The column in `data` containing the explanatory variable to be
#'   plotted on the `x`-axis.
#' @param y The column in `data` containing the response (outcome) variable to
#'   be plotted on the `y`-axis.
#' @inheritParams oneway_anova
#'
#' @importFrom dplyr select case_when ungroup
#' @importFrom correlation correlation
#' @importFrom ipmisc stats_type_switch
#' @importFrom parameters standardize_names
#' @importFrom tidyr drop_na
#'
#' @examples
#' \donttest{
#' # for reproducibility
#' set.seed(123)
#' library(statsExpressions)
#' options(tibble.width = Inf, pillar.bold = TRUE, pillar.neg = TRUE)
#'
#' # without changing defaults
#' corr_test(
#'   data = ggplot2::midwest,
#'   x = area,
#'   y = percblack
#' )
#'
#' # changing defaults
#' corr_test(
#'   data = ggplot2::midwest,
#'   x = area,
#'   y = percblack,
#'   type = "robust"
#' )
#' }
#' @export

# function body
corr_test <- function(data,
                      x,
                      y,
                      type = "parametric",
                      k = 2L,
                      conf.level = 0.95,
                      tr = 0.2,
                      bf.prior = 0.707,
                      top.text = NULL,
                      ...) {

  # see which method was used to specify type of correlation
  type <- ipmisc::stats_type_switch(type)

  # ----------------- creating correlation dataframes -----------------------

  # creating a dataframe of results
  stats_df <- correlation::correlation(
    data = tidyr::drop_na(dplyr::select(dplyr::ungroup(data), {{ x }}, {{ y }})),
    method = ifelse(type == "nonparametric", "spearman", "pearson"),
    ci = conf.level,
    bayesian = ifelse(type == "bayes", TRUE, FALSE),
    bayesian_prior = bf.prior,
    winsorize = ifelse(type == "robust", tr, FALSE)
  ) %>%
    parameters::standardize_names(style = "broom") %>%
    dplyr::mutate(effectsize = method)

  # ---------------------- preparing expression -------------------------------

  # no. of parameters
  no.parameters <- ifelse(type %in% c("parametric", "robust"), 1L, 0L)
  if (type == "nonparametric") stats_df %<>% dplyr::mutate(statistic = log(statistic))
  if (type == "bayes") stats_df %<>% dplyr::rename("bf10" = "bayes.factor")

  # preparing expression
  as_tibble(stats_df) %>%
    dplyr::mutate(expression = list(expr_template(
      data = stats_df,
      no.parameters = no.parameters,
      top.text = top.text,
      paired = TRUE,
      n = stats_df$n.obs[[1]],
      k = k,
      bayesian = ifelse(type == "bayes", TRUE, FALSE)
    )))
}
