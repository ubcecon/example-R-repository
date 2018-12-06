[![Build
Status](https://travis-ci.com/ubcecon/example-R-repository.svg?branch=master)](https://travis-ci.com/ubcecon/example-R-repository)
[![codecov](https://codecov.io/gh/ubcecon/example-R-repository/branch/master/graphs/badge.svg)](https://codecov.io/gh/ubcecon/example-R-repository) 

Following the tutorial below will result in a package that looks like this repository -- take it as an example of the end result of following the workflow below.

# CI and Workflow for R

### Useful links:
- [R package primer](https://kbroman.org/pkg_primer/): contains a minimal tutorial on R package build workflow, without CI setups. 
- [R packages by Hadley Wickham](http://r-pkgs.had.co.nz/): complete manual for R package creation
- [Travis tutorial](https://github.com/ropenscilabs/travis): tutorial by [rOpenSci Project](https://ropensci.org/) on Travis setup for R projects

# Creating a new package for a project
## Getting started
In RSTudio, click `File -> New Project`. Choose `New Directory`, and select `R Package`. After adding a package name `findavg`, click on `Create Project`. This will create:

- An `R/` directory for codes
- `DESCRIPTION` and `NAMESPACE` for package metadata

One can alternatively run the following line in R console to get the barebone:
```r
usethis::create_package("findavg")
```

Once the barebone is complete, it will look something like [69dcfef](https://github.com/ubcecon/example-R-repository/tree/69dcfefc7e62216df019893581579c6f2d8454ba)

## Package metadata
Once the first package file is created, fill in `DESCRIPTION` to add the package title, author, maintainer information, description, and license.
### Add project dependency
If the package requires methods or dataset from other packages, one can add `Imports` field. For instance, to add `gapminder` as a required package, one can add
```r
Imports: 
    gapminder
```

at the end of `DESCRIPTION` file. Note that this can be also done by running
```r
usethis::use_package("gapminder")
```
in R console. Note that this barely adds a package requirement; to use dependent packages within the package without calling `library`, import should be done in `NAMESPACE` too. To do so, add the following line
```r
import(gapminder)
```
at the end of `NAMESPACE`. This will remove the burden of using `gapminder::` to call any method or dataset from `gapminder`.

Completing both `DESCRIPTION` and `NAMESPACE` will give something like [af2c110](https://github.com/ubcecon/example-R-repository/tree/af2c11029d919690bb415b3193a1cf3c3925674a). 

## Adding functions
All the methods to be used in the package should be contained in `R` directory. Here, I am adding the following function called `getavg` that returns the average of a given numeric vector saved in `getavg.R`:
```r
#' Returns the average of a given numeric vector.
#'
#' @param v A vector of numerics
#'
#' @return The average of v
#'
#' @examples
#' getavg(c(1,3)) # returns (1+3)/2 = 2
#' getavg(c(1,2,3)) # returns (1+2+3)/3 = 2
getavg <- function (v) {
  return (mean(v))
}
```
The comments above the actual method definition are something called *roxygen comments* that can be used to build package manuals using `roxygen`. This is not needed unless you want to create an R package ready for CRAN submission or extra clarity.

Adding `R/getavg.R` will give something like [4b32b9d](https://github.com/ubcecon/example-R-repository/tree/4b32b9dddbcad81f58c2f63d89c503a50c4977f0).

## Implementing unit tests
### Sniffing the code
To do some sanity check before actual unit tests, one can load the package in current R session by running
```r
devtools::load_all(".")
```
In RStudio, this can be done by clicking on `Build -> Load All`. Once the package is loaded, `getavg` can be called as the following:
```r
getavg(c(2,4)) # should return 3
```

### Adding `testthat`
In R, unit tests can be performed by the package `testthat`. To set up the package to use `testthat`, run the following:
```r
usethis::use_testthat()
```
which will add `tests/` directory with files for unit tests and `Suggests` feature in `DESCRIPTION` file.

### Adding unit tests
All unit tests must be contained in `tests/testthat/`. Usual naming convention is that the unit test file has the name of `test-METHOD_NAME` where `METHOD_NAME` is the method you want to test.

Save the following unit tests as `tests/testthat/test-getavg.R`:
```r
context("getavg")

test_that("check if getavg returns average values", {
  expect_equal(getavg(c(1)), 1) # 1/1 = 1
  expect_equal(getavg(c(1,3)), 2) # (1+3)/2 = 2

  expect_warning(getavg(NULL)) # getavg(NULL) should return a warning
})
```
Once the unit tests are added, it will something like [717708b](https://github.com/ubcecon/example-R-repository/tree/717708b170b29507f7d3585be0e0c9143e4f7b04).

### Running unit tests
To run the unit tests, execute the following:
```r
devtools::test()
```
In RStudio, this can be done by clicking on `Build -> Test Package`.



## Using CI Travis
Save the following text file as `.travis.yml`:

```
# R for travis: see documentation at https://docs.travis-ci.com/user/languages/r

language: R
sudo: false
cache: packages
```

Activating the repo from Travis CI will complete implementation. Add the following line in `README.md` to add a badge for build status:

```

[![Build
Status](https://travis-ci.org/YOUR_USERNAME/REPO_NAME.svg?branch=master)](https://travis-ci.org/YOUR_USERNAME/REPO_NAME)
```
where `YOUR_USERNAME` is your username and `REPO_NAME` is the name of repository in Github. To trigger builds, make a commit and push.

Note that having proper documentation is necessary to get all the checks run without warnings. Travis CI treats warnings as errors in default -- to prevent this, append the following in `.travis.yml`:

```
warnings_are_errors: false
```

## Using codecov.io
Append the followings to `.travis.yml`:
```
r_packages:
  - covr

after_success:
  - Rscript -e 'library(covr); codecov()'
```

Activating the repo from codecov.io will complete implementation. Add the following line in `README.md` to add a badge for test coverage status:

```
[![codecov](https://codecov.io/gh/YOUR_USERNAME/REPO_NAME/branch/master/graphs/badge.svg)](https://codecov.io/gh/YOUR_USERNAME/REPO_NAME) 
```
where `YOUR_USERNAME` is your username and `REPO_NAME` is the name of repository in Github.

# Working on a project with an existing package
## Soft installation
To install a package available in Github (that might not be on CRAN), one can use `devtools::install_github()`; for instance, to install this package, run the following line:
```r
devtools::install_github("ubcecon/example-R-repository")
```

## Modifying the package
To modify a package in Github, first clone the package. Once changes are made, the package can be rebuilt by running the following line in bash console:
```
R CMD build PACKAGE_DIRECTORY
```
where `PACKAGE_DIRECTORY` is the directory where the cloned package is installed. In Windows, this can be done by running:
```
Rcmd.exe INSTALL --no-multiarch --with-keep.source PACKAGE_DIRECTORY
```
In RStudio, `Build -> Install and Restart` will do the same thing. The reinstalled package will replace the preexisting one in your local computer. To use the modified package, simply run
```r
library(PACKAGE_NAME)
```
in R console where `PACKAGE_NAME` is the name of the R package installed.
