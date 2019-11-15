\name{gco_wrapR-package}
\alias{gco_wrapR-package}
\alias{gco_wrapR}
\docType{package}
\title{
  A Wrapper For the C++ Library GCO for GraphCut Optimization
}
\description{
  A simple wrapper around the C++ library GCO to do Markov Random Field optimization over a regular grid.
}
\details{
  This packages provide a simple wrapper around the \code{GCoptimizationGridGraph} class of the C++ library GCO developped by developed by Olga Veksler and Andrew Delong \url{https://vision.cs.uwaterloo.ca/code/}. This library is based on the four papers listed in the references section. This R package exports the
\code{GCoptimizationGridGraph} class using the Rcpp module \code{gco}. See the corresponding man page for more information.
}
\author{
Soulivanh THAO, sthao@lsce.ipsl.fr.

Maintainer: Soulivanh THAO, sthao@lsce.ipsl.fr.
}
\references{
    [1] Efficient Approximate Energy Minimization via Graph Cuts.
        Y. Boykov, O. Veksler, R.Zabih. IEEE TPAMI, 20(12):1222-1239, Nov 2001.

    [2] What Energy Functions can be Minimized via Graph Cuts?
        V. Kolmogorov, R.Zabih. IEEE TPAMI, 26(2):147-159, Feb 2004.

    [3] An Experimental Comparison of Min-Cut/Max-Flow Algorithms for
        Energy Minimization in Vision. Y. Boykov, V. Kolmogorov.
        IEEE TPAMI, 26(9):1124-1137, Sep 2004.

    [4] Fast Approximate Energy Minimization with Label Costs.
        A. Delong, A. Osokin, H. N. Isack, Y. Boykov. In CVPR, June 2010.
}
\keyword{ package }
\seealso{
  \link{GCoptimizationGridGraph}
  \link{gco}
}

