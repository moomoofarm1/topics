#' @importFrom utils packageVersion
#' @noRd
.onAttach <- function(libname, pkgname) {
  if (!grepl(x = R.Version()$arch, pattern = "64")) {
    warning("\n\nThe topic package requires running R on a 64-bit systems.")
  }

  topics_version_nr <- tryCatch(
    {
      topics_version_nr1 <- paste(" (version ", 
                                packageVersion("topics"), ")", 
                                sep = "")
    },
    error = function(e) {
      topics_version_nr1 <- ""
    }
  )

  packageStartupMessage(
    colourise(
      paste("\nThis is topics: your text's new best friend",
            topics_version_nr,
        ".\n",
        sep = ""
      ),
      fg = "blue", bg = NULL
    ),
    colourise("Please note that the topics package requires you to download and install java from www.java.com. \n",
      fg = "brown", bg = NULL
    ),
    colourise("\nFor more information about the topics package see www.r-topics.org and www.r-text.org.",
      fg = "green", bg = NULL
    )
  )
}


.onLoad <- function(libname, pkgname) {
  java_version <- tryCatch(system("java -version", intern = TRUE, ignore.stderr = TRUE), error = function(e) NULL)
  if (is.null(java_version)) {
    packageStartupMessage(
      "Java does not appear to be installed or accessible to R.\nPlease download and install it from https://www.java.com/en/download/ before using the 'topics' package."
    )
  }
}

# Below function is from testthat:
# https://github.com/r-lib/testthat/blob/717b02164def5c1f027d3a20b889dae35428b6d7/R/colour-text.r
#' Colourise text for display in the terminal.
#'
#' If R is not currently running in a system that supports terminal colours
#' the text will be returned unchanged.
#'
#' Allowed colours are: black, blue, brown, cyan, dark gray, green, light
#' blue, light cyan, light gray, light green, light purple, light red,
#' purple, red, white, yellow
#'
#' @param text character vector
#' @param fg foreground colour, defaults to white
#' @param bg background colour, defaults to transparent
# @examples
#' @noRd
colourise <- function(text, fg = "black", bg = NULL) {
  term <- Sys.getenv()["TERM"]
  colour_terms <- c("xterm-color", "xterm-256color", "screen", "screen-256color")

  if (rcmd_running() || !any(term %in% colour_terms, na.rm = TRUE)) {
    return(text)
  }

  col_escape <- function(col) {
    paste0("\033[", col, "m")
  }

  col <- .fg_colours[tolower(fg)]
  if (!is.null(bg)) {
    col <- paste0(col, .bg_colours[tolower(bg)], sep = ";")
  }

  init <- col_escape(col)
  reset <- col_escape("0")
  paste0(init, text, reset)
}

.fg_colours <- c(
  "black" = "0;30",
  "blue" = "0;34",
  "green" = "0;32",
  "cyan" = "0;36",
  "red" = "0;31",
  "purple" = "0;35",
  "brown" = "0;33"
  # "light gray" = "0;37",
  # "dark gray" = "1;30",
  # "light blue" = "1;34",
  # "light green" = "1;32",
  # "light cyan" = "1;36",
  # "light red" = "1;31",
  # "light purple" = "1;35",
  # "yellow" = "1;33",
  # "white" = "1;37"
)

.bg_colours <- c(
  "black" = "40",
  "red" = "41",
  "green" = "42",
  "brown" = "43",
  "blue" = "44",
  "purple" = "45",
  "cyan" = "46",
  "light gray" = "47"
)

rcmd_running <- function() {
  nchar(Sys.getenv("R_TESTS")) != 0
}
