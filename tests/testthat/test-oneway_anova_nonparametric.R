test_that(
  desc = "between-subjects - data with and without NAs",
  code = {
    # between-subjects ----------------------------------------------

    options(tibble.width = Inf)

    # `statsExpressions` output
    set.seed(123)
    df1 <-
      oneway_anova(
        type = "np",
        data = dplyr::sample_frac(movies_long, 0.1),
        x = "genre",
        y = length,
        paired = FALSE,
        k = 5
      )

    # testing all details
    set.seed(123)
    expect_snapshot(dplyr::select(df1, -expression))
    expect_snapshot(df1$expression[[1]])

    # `statsExpressions` output
    set.seed(123)
    df2 <-
      suppressWarnings(oneway_anova(
        type = "np",
        data = ggplot2::msleep,
        x = vore,
        y = sleep_cycle,
        k = 3,
        paired = FALSE,
        conf.level = 0.99
      ))

    # testing all details
    set.seed(123)
    expect_snapshot(dplyr::select(df2, -expression))
    expect_snapshot(df2$expression[[1]])
  }
)

test_that(
  desc = "within-subjects - data with and without NAs",
  code = {
    options(tibble.width = Inf)

    # within-subjects -------------------------------------------------------

    # `statsExpressions` output
    set.seed(123)
    df1 <-
      oneway_anova(
        type = "np",
        data = bugs_long,
        x = condition,
        y = "desire",
        k = 4L,
        paired = TRUE,
        conf.level = 0.99
      )

    # testing all details
    set.seed(123)
    expect_snapshot(df1$expression[[1]])

    # `statsExpressions` output
    set.seed(123)
    df2 <-
      oneway_anova(
        type = "np",
        data = iris_long,
        x = condition,
        y = "value",
        k = 3,
        paired = TRUE,
        conf.level = 0.90
      )

    # testing all details
    set.seed(123)
    expect_snapshot(df2$expression[[1]])
  }
)

test_that(
  desc = "works with subject id",
  code = {
    # works with subject id -----------------------------------------------

    # data
    df <-
      structure(list(
        score = c(
          70, 82.5, 97.5, 100, 52.5, 62.5,
          92.5, 70, 90, 92.5, 90, 75, 60, 90, 85, 67.5, 90, 72.5, 45, 60,
          72.5, 80, 100, 100, 97.5, 95, 65, 87.5, 90, 62.5, 100, 100, 97.5,
          100, 97.5, 95, 82.5, 82.5, 40, 92.5, 85, 72.5, 35, 27.5, 82.5
        ), condition = structure(c(
          5L, 1L, 2L, 3L, 4L, 4L, 5L, 1L,
          2L, 3L, 2L, 3L, 3L, 4L, 2L, 1L, 5L, 5L, 4L, 1L, 1L, 4L, 3L, 5L,
          2L, 5L, 1L, 2L, 3L, 4L, 4L, 5L, 1L, 2L, 3L, 2L, 3L, 4L, 1L, 5L,
          3L, 2L, 5L, 4L, 1L
        ), .Label = c("1", "2", "3", "4", "5"), class = "factor"),
        id = structure(c(
          1L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L,
          2L, 3L, 3L, 4L, 3L, 4L, 3L, 4L, 3L, 4L, 4L, 5L, 5L, 5L, 5L,
          5L, 6L, 6L, 6L, 6L, 6L, 7L, 7L, 7L, 7L, 7L, 8L, 8L, 8L, 8L,
          8L, 9L, 9L, 9L, 9L, 9L
        ), .Label = c(
          "1", "2", "3", "4", "5",
          "6", "7", "8", "9"
        ), class = "factor")
      ), row.names = c(
        NA,
        45L
      ), class = "data.frame")

    # incorrect
    set.seed(123)
    expr1 <-
      oneway_anova(
        type = "np",
        data = df,
        x = condition,
        y = score,
        subject.id = id,
        paired = TRUE
      )

    # correct
    set.seed(123)
    expr2 <-
      oneway_anova(
        type = "np",
        data = dplyr::arrange(df, id),
        x = condition,
        y = score,
        paired = TRUE
      )

    expect_equal(expr1, expr2)
  }
)
