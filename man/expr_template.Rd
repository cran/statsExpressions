% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers_expr_templates.R
\name{expr_template}
\alias{expr_template}
\title{Template for expressions with statistical details}
\usage{
expr_template(
  data,
  no.parameters = 0L,
  bayesian = FALSE,
  statistic.text = NULL,
  effsize.text = NULL,
  top.text = NULL,
  prior.distribution = NULL,
  prior.type = NULL,
  n = NULL,
  n.text = NULL,
  paired = FALSE,
  conf.method = "HDI",
  k = 2L,
  k.df = 0L,
  k.df.error = 0L,
  ...
)
}
\arguments{
\item{data}{A dataframe containing details from the statistical analysis
and should contain some or all of the the following columns:
\itemize{
\item \emph{statistic}: the numeric value of a statistic.
\item \emph{df.error}: the numeric value of a parameter being modeled (often degrees
of freedom for the test); note that if \code{no.parameters = 0L} (e.g., for
non-parametric tests), this column will be irrelevant.
\item \emph{df} relevant only if the statistic in question has two degrees of freedom.
\item \emph{p.value} the two-sided \emph{p}-value associated with the observed statistic.
\item \emph{estimate}: estimated value of the effect size.
\item \emph{conf.level}: width for the confidence intervals.
\item \emph{conf.low}: lower bound for effect size estimate.
\item \emph{conf.high}: upper bound for effect size estimate.
\item \emph{\code{bf10}} Bayes Factor value (if \code{bayesian = TRUE}).
\item \emph{method}: method describing the test carried out.
}}

\item{no.parameters}{An integer that specifies that the number of parameters
for the statistical test. Can be \code{0} for non-parametric tests, \code{1} for
tests based on \emph{t}-statistic or chi-squared statistic, \code{2} for tests based
on \emph{F}-statistic.}

\item{bayesian}{Is this Bayesian analysis? Defaults to \code{FALSE}. The template
is slightly different for Bayesian analysis.}

\item{statistic.text}{A character that specifies the relevant test statistic.
For example, for tests with \emph{t}-statistic, \code{statistic.text = "t"}.}

\item{effsize.text}{A character that specifies the relevant effect size.}

\item{top.text}{Text to display on top of the Bayes Factor message. This is
mostly relevant in the context of \code{ggstatsplot} functions.}

\item{prior.distribution}{A character that specifies the prior type.}

\item{prior.type}{The type of prior.}

\item{n}{An integer specifying the sample size used for the test.}

\item{n.text}{A character that specifies the design, which will determine
what the \code{n} stands for. If \code{NULL}, defaults to
\code{quote(italic("n")["pairs"])} if \code{paired = TRUE}, and to
\code{quote(italic("n")["obs"])} if \code{paired = FALSE}.}

\item{paired}{Logical that decides whether the experimental design is
repeated measures/within-subjects or between-subjects. The default is
\code{FALSE}.}

\item{conf.method}{The type of index used for Credible Interval. Can be
\code{"hdi"} (default), \code{"eti"}, or \code{"si"} (see \code{si()}, \code{hdi()}, \code{eti()}
functions from \code{bayestestR} package).}

\item{k}{Number of digits after decimal point (should be an integer)
(Default: \code{k = 2L}).}

\item{k.df, k.df.error}{Number of decimal places to display for the
parameters (default: \code{0}).}

\item{...}{Currently ignored.}
}
\description{
Creates an expression from a dataframe containing statistical details.
Ideally, this dataframe would come from having run \code{tidy_model_parameters}
function on your model object.

This function is currently \strong{not} stable and should not be used outside of
this package context.
}
\examples{
set.seed(123)

# creating a dataframe with stats results
stats_df <-
  cbind.data.frame(
    statistic = 5.494,
    df = 29.234,
    p.value = 0.00001,
    estimate = -1.980,
    conf.level = 0.95,
    conf.low = -2.873,
    conf.high = -1.088
  )

# expression for *t*-statistic with Cohen's *d* as effect size
# note that the plotmath expressions need to be quoted
statsExpressions::expr_template(
  no.parameters = 1L,
  data = stats_df,
  statistic.text = quote(italic("t")),
  effsize.text = quote(italic("d")),
  n = 32L,
  k = 3L,
  k.df = 3L
)
}
