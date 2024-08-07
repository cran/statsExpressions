% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/long-to-wide-converter.R
\name{long_to_wide_converter}
\alias{long_to_wide_converter}
\title{Convert long/tidy data frame to wide format}
\usage{
long_to_wide_converter(
  data,
  x,
  y,
  subject.id = NULL,
  paired = TRUE,
  spread = TRUE,
  ...
)
}
\arguments{
\item{data}{A data frame (or a tibble) from which variables specified are to
be taken. Other data types (e.g., matrix,table, array, etc.) will \strong{not}
be accepted. Additionally, grouped data frames from \code{{dplyr}} should be
ungrouped before they are entered as \code{data}.}

\item{x}{The grouping (or independent) variable from \code{data}. In case of a
repeated measures or within-subjects design, if \code{subject.id} argument is
not available or not explicitly specified, the function assumes that the
data has already been sorted by such an id by the user and creates an
internal identifier. So if your data is \strong{not} sorted, the results \emph{can}
be inaccurate when there are more than two levels in \code{x} and there are
\code{NA}s present. The data is expected to be sorted by user in
subject-1,subject-2, ..., pattern.}

\item{y}{The response (or outcome or dependent) variable from \code{data}.}

\item{subject.id}{Relevant in case of a repeated measures or within-subjects
design (\code{paired = TRUE}, i.e.), it specifies the subject or repeated
measures identifier. \strong{Important}: Note that if this argument is \code{NULL}
(which is the default), the function assumes that the data has already been
sorted by such an id by the user and creates an internal identifier. So if
your data is \strong{not} sorted and you leave this argument unspecified, the
results \emph{can} be inaccurate when there are more than two levels in \code{x} and
there are \code{NA}s present.}

\item{paired}{Logical that decides whether the experimental design is
repeated measures/within-subjects or between-subjects. The default is
\code{FALSE}.}

\item{spread}{Logical that decides whether the data frame needs to be
converted from long/tidy to wide (default: \code{TRUE}).}

\item{...}{Currently ignored.}
}
\value{
A data frame with \code{NA}s removed while respecting the
between-or-within-subjects nature of the dataset.
}
\description{
This conversion is helpful mostly for repeated measures design, where
removing \code{NA}s by participant can be a bit tedious.
}
\section{Citation}{
Patil, I., (2021). statsExpressions: R Package for Tidy Dataframes and Expressions with Statistical Details. Journal of Open Source Software, 6(61), 3236, https://doi.org/10.21105/joss.03236
}

\examples{
# for reproducibility
library(statsExpressions)
set.seed(123)

# repeated measures design
long_to_wide_converter(
  bugs_long,
  condition,
  desire,
  subject.id = subject,
  paired = TRUE
)

# independent measures design
long_to_wide_converter(mtcars, cyl, wt, paired = FALSE)

}
