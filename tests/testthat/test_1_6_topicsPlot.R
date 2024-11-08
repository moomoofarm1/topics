# tests/test-topicsWordclouds.R
library(testthat)
library(topics)  # Replace with your package name
#library(text)

library(here)


test_that("topicsPlot with test", {
  dtm <- topicsDtm(data = Language_based_assessment_data_8$harmonytexts)
  model <- topicsModel(dtm = dtm)
  preds <- topicsPreds(model = model, data = Language_based_assessment_data_8$harmonytexts)
  result <- topicsTest(model=model, preds=preds, data=Language_based_assessment_data_8, pred_var_x = "hilstotal")
  topicsPlot(model, result, p_threshold=1, figure_format = "png")
  
  # Check if the wordcloud directory exists
  testthat::expect_true(dir.exists("./results/seed_42/wordclouds"))
})

test_that("topicsPlot without test and preds", {
  dtm <- topicsDtm(data = Language_based_assessment_data_8$harmonytexts)
  model <- topicsModel(dtm = dtm)
  
  topicsPlot(model, figure_format = "png")
  
  # Check if the wordcloud directory exists
  testthat::expect_true(dir.exists("./results/seed_42/wordclouds"))
})

test_that("topicsPlot with topicsGrams",{
  data <- Language_based_assessment_data_8$harmonytexts
  ngrams <- topicsGrams(data = data, top_n = 20)
  topics::topicsPlot(ngrams = ngrams, figure_format = "png" )
  testthat::expect_true(file.exists("./results/seed_42/wordclouds/ngrams.png"))
})

