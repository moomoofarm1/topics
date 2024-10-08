% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/main.R
\name{topicsGrams}
\alias{topicsGrams}
\title{The function computes ngrams from a text}
\usage{
topicsGrams(data, n = 2, sep = " ", top_n = NULL)
}
\arguments{
\item{data}{(tibble) The data}

\item{n}{(integer) The length of ngram}

\item{sep}{(string) The separator}
}
\value{
A list containing tibble of the ngrams with the frequency and probability and a tibble containing the relative frequency of the ngrams for each user
}
\description{
The function computes ngrams from a text
}
