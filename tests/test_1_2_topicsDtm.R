library(testthat)
library(topics)  # Replace with your package name
library(tibble)
library(dplyr)
library(text)
test_that("topicsDtm creates a DTM correctly with default parameters", {

  data <- Language_based_assessment_data_8$harmonytexts
  options(mc.cores = 1)  # Set the number of cores to 2
  result <- topicsDtm(data = data)
  
  testthat::expect_true(is.list(result))
  testthat::expect_true("train_dtm" %in% names(result))
  testthat::expect_true("test_dtm" %in% names(result))
  testthat::expect_true("train_data" %in% names(result))
  testthat::expect_true("test_data" %in% names(result))
  testthat::expect_s4_class(result$train_dtm, "dgCMatrix")
})

test_that("topicsDtm handles different ngram_window values", {
  data <- Language_based_assessment_data_8$harmonytexts
  result <- topicsDtm(data, ngram_window = c(1, 2))
  
  testthat::expect_true(is.list(result))
  testthat::expect_s4_class(result$train_dtm, "dgCMatrix")
})

test_that("topicsDtm removes a specified word", {
  data <- Language_based_assessment_data_8$harmonytexts
  result <- topicsDtm(data, removalword = "test")
  
  testthat::expect_true(is.list(result))
  testthat::expect_s4_class(result$train_dtm, "dgCMatrix")
  testthat::expect_false("test" %in% colnames(result$train_dtm))
})

test_that("topicsDtm handles different occurrence rates", {
  data <- Language_based_assessment_data_8$harmonytexts
  result <- topicsDtm(data, occ_rate = 1)
  
  testthat::expect_true(is.list(result))
  testthat::expect_s4_class(result$train_dtm, "dgCMatrix")
})

test_that("topicsDtm handles different removal modes", {
  data <- Language_based_assessment_data_8$harmonytexts
  result <- topicsDtm(data, removal_mode = "absolute")
  
  testthat::expect_true(is.list(result))
  testthat::expect_s4_class(result$train_dtm, "dgCMatrix")
})

test_that("topicsDtm handles different split proportions", {
  data <- Language_based_assessment_data_8$harmonytexts
  result <- topicsDtm(data, split = 0.5)
  
  testthat::expect_true(is.list(result))
#  testthat::expect_true(nrow(result$train_data) <= nrow(data)*0.5)
#  testthat::expect_true(nrow(result$test_data) <= nrow(data)*0.5)
  testthat::expect_s4_class(result$train_dtm, "dgCMatrix")
})

test_that("topicsDtm handles different seeds for reproducibility", {
  data <- Language_based_assessment_data_8$harmonytexts
  result1 <- topicsDtm(data, seed = 123)
  result2 <- topicsDtm(data, seed = 123)
  
  testthat::expect_equal(result1$train_dtm, result2$train_dtm)
})

test_that("topicsDtm saves results to the specified directory", {
  data <- Language_based_assessment_data_8$harmonytexts
  save_dir <- tempfile()
  result <- topicsDtm(data, save_dir = save_dir)
  
  testthat::expect_true(file.exists(file.path(save_dir, "seed_42", "dtms.rds")))
})

test_that("topicsDtm loads results from the specified directory", {
  data <- Language_based_assessment_data_8$harmonytexts
  result1 <- topicsDtm(data)
  result2 <- topicsDtm(load_dir = "./results")
  
  testthat::expect_equal(result1$train_dtm, result2$train_dtm)
})

test_that("topicsDtm removes least frequent words based on a threshold", {
  data <- Language_based_assessment_data_8$harmonytexts
  result <- topicsDtm(data, removal_mode = "threshold", removal_rate_least = 2)
  
  testthat::expect_true(is.list(result))
  testthat::expect_s4_class(result$train_dtm, "dgCMatrix")
})

test_that("topicsDtm removes most frequent words based on a threshold", {
  data <- Language_based_assessment_data_8$harmonytexts
  result <- topicsDtm(data, removal_mode = "threshold", removal_rate_most = 50)
  
  testthat::expect_true(is.list(result))
  testthat::expect_s4_class(result$train_dtm, "dgCMatrix")
})

#test_that("topicsDtm removes least frequent words in percent mode", {
#  data <- Language_based_assessment_data_8$harmonytexts
#  result <- topicsDtm(data, removal_mode = "percent", removal_rate_least = 50)
  
#  testthat::expect_true(is.list(result))
#  testthat::expect_s4_class(result$train_dtm, "dgCMatrix")
#})

test_that("topicsDtm removes most frequent words in percent mode", {
  data <- Language_based_assessment_data_8$harmonytexts
  result <- topicsDtm(data, removal_mode = "percent", removal_rate_most = 5)
  
  testthat::expect_true(is.list(result))
  testthat::expect_s4_class(result$train_dtm, "dgCMatrix")
})
