% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/two_sample_test.R
\name{two_sample_test}
\alias{two_sample_test}
\title{Two-sample tests}
\usage{
two_sample_test(
  data,
  x,
  y,
  subject.id = NULL,
  type = "parametric",
  paired = FALSE,
  alternative = "two.sided",
  k = 2L,
  conf.level = 0.95,
  effsize.type = "g",
  var.equal = FALSE,
  bf.prior = 0.707,
  tr = 0.2,
  nboot = 100L,
  top.text = NULL,
  ...
)
}
\arguments{
\item{data}{A dataframe (or a tibble) from which variables specified are to
be taken. Other data types (e.g., matrix,table, array, etc.) will \strong{not}
be accepted.}

\item{x}{The grouping (or independent) variable from the dataframe \code{data}. In
case of a repeated measures or within-subjects design, if \code{subject.id}
argument is not available or not explicitly specified, the function assumes
that the data has already been sorted by such an id by the user and creates
an internal identifier. So if your data is \strong{not} sorted, the results
\emph{can} be inaccurate when there are more than two levels in \code{x} and there
are \code{NA}s present. The data is expected to be sorted by user in
subject-1,subject-2, ..., pattern.}

\item{y}{The response (or outcome or dependent) variable from the
dataframe \code{data}.}

\item{subject.id}{Relevant in case of a repeated measures or within-subjects
design (\code{paired = TRUE}, i.e.), it specifies the subject or repeated
measures identifier. \strong{Important}: Note that if this argument is \code{NULL}
(which is the default), the function assumes that the data has already been
sorted by such an id by the user and creates an internal identifier. So if
your data is \strong{not} sorted and you leave this argument unspecified, the
results \emph{can} be inaccurate when there are more than two levels in \code{x} and
there are \code{NA}s present.}

\item{type}{A character specifying the type of statistical approach:
\itemize{
\item \code{"parametric"}
\item \code{"nonparametric"}
\item \code{"robust"}
\item \code{"bayes"}
}

You can specify just the initial letter.}

\item{paired}{Logical that decides whether the experimental design is
repeated measures/within-subjects or between-subjects. The default is
\code{FALSE}.}

\item{alternative}{a character string specifying the alternative
    hypothesis, must be one of \code{"two.sided"} (default),
    \code{"greater"} or \code{"less"}.  You can specify just the initial
    letter.}

\item{k}{Number of digits after decimal point (should be an integer)
(Default: \code{k = 2L}).}

\item{conf.level}{Confidence/Credible Interval (CI) level. Default to \code{0.95}
(\verb{95\%}).}

\item{effsize.type}{Type of effect size needed for \emph{parametric} tests. The
argument can be \code{"d"} (for Cohen's \emph{d}) or \code{"g"} (for Hedge's \emph{g}).}

\item{var.equal}{a logical variable indicating whether to treat the
    two variances as being equal. If \code{TRUE} then the pooled
    variance is used to estimate the variance otherwise the Welch
    (or Satterthwaite) approximation to the degrees of freedom is used.}

\item{bf.prior}{A number between \code{0.5} and \code{2} (default \code{0.707}), the prior
width to use in calculating Bayes factors and posterior estimates. In
addition to numeric arguments, several named values are also recognized:
\code{"medium"}, \code{"wide"}, and \code{"ultrawide"}, corresponding to \emph{r} scale values
of 1/2, sqrt(2)/2, and 1, respectively. In case of an ANOVA, this value
corresponds to scale for fixed effects.}

\item{tr}{Trim level for the mean when carrying out \code{robust} tests. In case
of an error, try reducing the value of \code{tr}, which is by default set to
\code{0.2}. Lowering the value might help.}

\item{nboot}{Number of bootstrap samples for computing confidence interval
for the effect size (Default: \code{100L}).}

\item{top.text}{Text to display on top of the Bayes Factor message. This is
mostly relevant in the context of \code{ggstatsplot} functions.}

\item{...}{Currently ignored.}
}
\description{
A dataframe containing results from a two-sample test and effect size plus
confidence intervals.

To see details about functions which are internally used to carry out these
analyses, see the following vignette-
\url{https://indrajeetpatil.github.io/statsExpressions/articles/stats_details.html}
}
\examples{
\donttest{
# for reproducibility
set.seed(123)
library(statsExpressions)
options(tibble.width = Inf, pillar.bold = TRUE, pillar.neg = TRUE)

# ----------------------- parametric -------------------------------------

# between-subjects design
two_sample_test(
  data = sleep,
  x = group,
  y = extra,
  type = "p"
)

# within-subjects design
two_sample_test(
  data = VR_dilemma,
  x = modality,
  y = score,
  paired = TRUE,
  subject.id = id,
  type = "p"
)

# ----------------------- non-parametric ----------------------------------

# between-subjects design
two_sample_test(
  data = sleep,
  x = group,
  y = extra,
  type = "np"
)

# within-subjects design
two_sample_test(
  data = VR_dilemma,
  x = modality,
  y = score,
  paired = TRUE,
  subject.id = id,
  type = "np"
)

# ------------------------------ robust ----------------------------------

# between-subjects design
two_sample_test(
  data = sleep,
  x = group,
  y = extra,
  type = "r"
)

# within-subjects design
two_sample_test(
  data = VR_dilemma,
  x = modality,
  y = score,
  paired = TRUE,
  subject.id = id,
  type = "r"
)

#' # ------------------------------ Bayesian ------------------------------

# between-subjects design
two_sample_test(
  data = sleep,
  x = group,
  y = extra,
  type = "bayes"
)

# within-subjects design
two_sample_test(
  data = VR_dilemma,
  x = modality,
  y = score,
  paired = TRUE,
  subject.id = id,
  type = "bayes"
)
}
}
