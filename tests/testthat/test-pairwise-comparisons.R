# between-subjects design --------------------------------------------------

test_that(
  desc = "`pairwise_comparisons()` works for between-subjects design",
  code = {
    # student's t
    set.seed(123)
    df1 <- pairwise_comparisons(
      data = msleep,
      x = vore,
      y = brainwt,
      type = "p",
      var.equal = TRUE,
      paired = FALSE,
      p.adjust.method = "bonferroni"
    )

    expect_snapshot(df1)
    expect_snapshot(df1[["expression"]])

    # games-howell
    df_msleep <- msleep

    # adding empty factor level (shouldn't change results)
    df_msleep %<>% dplyr::mutate(vore = as.factor(vore))

    df_msleep$vore <- factor(df_msleep$vore, levels = c(levels(df_msleep$vore), "Random"))

    set.seed(123)
    df2 <- pairwise_comparisons(
      data = df_msleep,
      x = vore,
      y = brainwt,
      type = "p",
      var.equal = FALSE,
      paired = FALSE,
      p.adjust.method = "bonferroni"
    )

    expect_snapshot(df2)
    expect_snapshot(df2[["expression"]])

    # Dunn test
    set.seed(123)
    df3 <- pairwise_comparisons(
      data = msleep,
      x = vore,
      y = brainwt,
      type = "np",
      paired = FALSE,
      p.adjust.method = "none"
    )

    expect_snapshot(df3)
    expect_snapshot(df3[["expression"]])

    # robust t test
    set.seed(123)
    df4 <- pairwise_comparisons(
      data = msleep,
      x = vore,
      y = brainwt,
      type = "r",
      paired = FALSE,
      p.adjust.method = "fdr"
    )

    expect_snapshot(df4)
    expect_snapshot(df4[["expression"]])

    # checking the edge case where factor level names contain `-`
    set.seed(123)
    df5 <- pairwise_comparisons(
      data = movies_long,
      x = mpaa,
      y = rating,
      var.equal = TRUE
    )

    expect_snapshot(df5)
    expect_snapshot(df5[["expression"]])

    # bayes test
    set.seed(123)
    df6 <- pairwise_comparisons(
      data = df_msleep,
      x = vore,
      y = brainwt
    )

    expect_snapshot(df6)
    expect_snapshot(df6[["expression"]])
  }
)

# dropped levels --------------------------------------------------

test_that(
  desc = "dropped levels are not included",
  code = {
    # drop levels
    msleep2 <- dplyr::filter(.data = msleep, vore %in% c("carni", "omni"))

    # check those levels are not included
    set.seed(123)
    df1 <- pairwise_comparisons(
      data = msleep2,
      x = vore,
      y = brainwt,
      p.adjust.method = "none"
    )

    expect_snapshot(df1)
    expect_snapshot(df1[["expression"]])

    set.seed(123)
    df2 <- pairwise_comparisons(
      data = msleep,
      x = vore,
      y = brainwt,
      p.adjust.method = "none"
    ) %>%
      dplyr::filter(group2 == "omni", group1 == "carni")

    expect_equal(df1$statistic, df2$statistic, tolerance = 0.01)
  }
)

# data without NAs --------------------------------------------------

test_that(
  desc = "data without NAs",
  code = {
    set.seed(123)
    df <- pairwise_comparisons(
      data = iris,
      x = Species,
      y = Sepal.Length,
      type = "p",
      p.adjust.method = "fdr",
      var.equal = TRUE
    )

    expect_snapshot(df)
    expect_snapshot(df[["expression"]])
  }
)


# within-subjects design - NAs --------------------------------------------

test_that(
  desc = "`pairwise_comparisons()` works for within-subjects design - NAs",
  code = {
    # student's t test
    set.seed(123)
    df1 <- pairwise_comparisons(
      data = bugs_long,
      x = condition,
      y = desire,
      type = "p",
      digits = 3L,
      paired = TRUE,
      p.adjust.method = "bonferroni"
    )

    expect_snapshot(df1)
    expect_snapshot(df1[["expression"]])

    # Durbin-Conover test
    set.seed(123)
    df2 <- pairwise_comparisons(
      data = bugs_long,
      x = condition,
      y = desire,
      type = "np",
      digits = 3L,
      paired = TRUE,
      p.adjust.method = "BY"
    )

    expect_snapshot(df2)
    expect_snapshot(df2[["expression"]])

    # robust t test
    set.seed(123)
    df3 <- pairwise_comparisons(
      data = bugs_long,
      x = condition,
      y = desire,
      type = "r",
      digits = 3L,
      paired = TRUE,
      p.adjust.method = "hommel"
    )

    expect_snapshot(df3)
    expect_snapshot(df3[["expression"]])

    # Bayesian
    set.seed(123)
    df4 <- pairwise_comparisons(
      data = bugs_long,
      x = condition,
      y = desire,
      type = "bf",
      paired = TRUE
    )

    expect_snapshot(df4)
    expect_snapshot(df4[["expression"]])
  }
)


# within-subjects design - no NAs -----------------------------------------

test_that(
  desc = "`pairwise_comparisons()` works for within-subjects design - without NAs",
  code = {
    # student's t test
    set.seed(123)
    df1 <- pairwise_comparisons(
      data = WRS2::WineTasting,
      x = Wine,
      y = Taste,
      type = "p",
      digits = 3L,
      paired = TRUE,
      p.adjust.method = "none"
    )

    expect_snapshot(df1)
    expect_snapshot(df1[["expression"]])

    # Durbin-Conover test
    set.seed(123)
    df2 <- pairwise_comparisons(
      data = WRS2::WineTasting,
      x = Wine,
      y = Taste,
      type = "np",
      digits = 3L,
      paired = TRUE,
      p.adjust.method = "none"
    )

    expect_snapshot(df2)
    expect_snapshot(df2[["expression"]])

    # robust t test
    set.seed(123)
    df3 <- pairwise_comparisons(
      data = WRS2::WineTasting,
      x = Wine,
      y = Taste,
      type = "r",
      digits = 3L,
      paired = TRUE,
      p.adjust.method = "none"
    )

    expect_snapshot(df3)
    expect_snapshot(df3[["expression"]])

    set.seed(123)
    df4 <- pairwise_comparisons(
      data = WRS2::WineTasting,
      x = Wine,
      y = Taste,
      type = "bf",
      paired = TRUE
    )

    expect_snapshot(df4)
    expect_snapshot(df4[["expression"]])
  }
)

test_that(
  desc = "works with subject id",
  code = {
    set.seed(123)
    df1 <- purrr::pmap_dfr(
      .f = pairwise_comparisons,
      .l = list(
        data = list(WRS2::WineTasting),
        x = list("Wine"),
        y = list("Taste"),
        type = list("p", "np", "r", "bf"),
        digits = 3L,
        subject.id = list("Taster"),
        paired = TRUE
      )
    )

    set.seed(123)
    df2 <- purrr::pmap_dfr(
      .f = pairwise_comparisons,
      .l = list(
        data = list(dplyr::arrange(WRS2::WineTasting, Taster)),
        x = list("Wine"),
        y = list("Taste"),
        type = list("p", "np", "r", "bf"),
        digits = 3L,
        paired = TRUE
      )
    )

    # columns should be same no matter the test
    expect_equal(dplyr::select(df1, -expression), dplyr::select(df2, -expression), ignore_attr = TRUE)
    expect_equal(dplyr::select(df1, expression), dplyr::select(df2, expression), ignore_attr = TRUE)
  }
)

# additional arguments are passed ---------------------------------------

test_that(
  desc = "additional arguments are passed to underlying methods",
  code = {
    set.seed(123)
    df1 <- pairwise_comparisons(
      data = bugs_long,
      x = condition,
      y = desire,
      paired = TRUE,
      p.adjust.method = "none",
      alternative = "less"
    )

    expect_snapshot(df1)
    expect_snapshot(df1[["expression"]])

    set.seed(123)
    df2 <- pairwise_comparisons(
      data = bugs_long,
      x = condition,
      y = desire,
      paired = TRUE,
      p.adjust.method = "none",
      alternative = "greater"
    )

    expect_snapshot(df2)
    expect_snapshot(df2[["expression"]])

    set.seed(123)
    df3 <- pairwise_comparisons(
      data = mtcars,
      x = cyl,
      y = wt,
      var.equal = TRUE,
      p.adjust.method = "none",
      alternative = "less"
    )

    expect_snapshot(df3)
    expect_snapshot(df3[["expression"]])

    set.seed(123)
    df4 <- pairwise_comparisons(
      data = mtcars,
      x = cyl,
      y = wt,
      var.equal = TRUE,
      p.adjust.method = "none",
      alternative = "greater"
    )

    expect_snapshot(df4)
    expect_snapshot(df4[["expression"]])
  }
)
