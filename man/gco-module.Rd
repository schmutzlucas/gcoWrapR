\name{gco}
\alias{gco}
\alias{GCoptimizationGridGraph}
\title{
	Rcpp module: \code{gco} to expose the class \code{GCoptimizationGridGraph} from the C++ library GCO
}
\description{
	Rcpp module, \code{gco}, to expose the class \code{GCoptimizationGridGraph} from the C++ library GCO.
	This class allows to do MRF optimization based on GraphCut using either alpha-beta swap or alpha expansion.
}
\details{
	The module exposes the \code{GCoptimizationGridGraph} class.
	The following methods are made available:
  \describe{
        \item{constructor(int width, int height , int nlabels)}{

          construct a graph  a on regular (four neighbour) grid.

          It takes as arguments the width, the height of the grid and the number of possible labels.

          Each node is identified with respect to an index system. The indice of a node (i, j), i = 0:(width-1), j = 0:(height-1) is (i + width * j )
        }
        \item{setDataCost(SEXP Xptrt, Rcpp::List extraData)}{

          sets the smooth cost term of the energy of the MRF.

          It takes as arguments

            \itemize{
              \item a Xptr pointer to a C++ function with header:

              float (*DataCostFnExtra)(int s1,  int l1,  Rcpp::List extraData)

              with s1 the index of the node, l1 its label index.
              C-style indexing style is used, i.e. the first index starts at 0.
              Such a pointer can be created with the package \code{RcppXPtrUtils}, as shown in the example.

              \item a list extraData from which the C++ function DataCostFnExtra takes the data it needs
            }
        }

        \item{setSmoothCost(SEXP Xptr, Rcpp::List extraData)}{

          sets the smooth cost term of the engery of the MRF.

          It takes as arguments:
          \itemize{
            \item  a Xptr pointer to a C++ function with header:

            float (*SmoothCostFnExtra)(int s1, int s2, int l1, int l2, Rcpp::List extraData)

            with s1, s2 the indexes of the nodes and  l1,  l2 thier corresponding its label indexes.
            C-style indexing style is used, i.e. the first index starts at  0.
            Such a pointer can be created with the package \code{RcppXPtrUtils}, as shown in the example.

            \item a list extraData from which the C++ function DataCostFnExtra takes the data it needs
          }
        }
        \item{setLabel(int s1, int l1)}{

          sets the node s1 with label l1.

          It takes as arguments:
            \itemize{
              \item s1, the index of the node.
              \item l1, the label to set the node to.
            }
          \code{setLabels} can be used to initialize labels before the optimization.
          By default, all the labels are set to zero.
        }
        \item{whatLabel(int s1)}{

          returns the current label of a  node s1.

          It takes as argument, s1, the index of the node we want the label from
        }
        \item{compute_energy()}{
          return the energy of the MRF given its current labels.

          It takes no argument.
        }
        \item{giveDataDenergy()}{
          returns the data term of the MRF energy given its current labels.

          It takes no argument.
        }
        \item{giveSmoothDenergy()}{
          return the smooth term of the MRF energy given its current labels.

          It takes no argument.
        }
        \item{expansion(int maxiter)}{
          performs the MRF optimization by alpha expansion.

          It takes as parameter the number of maximum iterations.

          If set to -1, optimization is done until convergence.
        }
        \item{swap(int maxiter)}{
          performs the MRF optimization by alpha-beta swap.

          It takes as parameter the number of maximum iterations.

          If set to -1, optimization is done until convergence.
        }
		}
		For more details on the C++ library GCO, see the README located in:
		\code{system.file("GCO_README.TXT", package = "gcoWrapR")}
}
\source{
    \url{https://vision.cs.uwaterloo.ca/code/}
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
\examples{
  library(RcppXPtrUtils)

  nlabs = 3
  width = height = 8

  # Objective: recreate the matrix "ref" by "cutting and pasting"
  # the matrices lab1, lab2, lab3 and minimizing the cost of the cuts.
  ref = lab1 = lab2 = lab3 = matrix(0, nrow = height, ncol = width)
  ref[1:3, 1:3] =  1
  lab1[1:4, 1:4] =  1
  lab2[1:2, 1:2] =  1
  lab3[1:3, 1:3] =  1
  lab3[8, 8] = 1

  labs = array(c(lab1, lab2, lab3), dim = c(height, width, nlabs))
  bias = labs - c(ref)
  print(bias)
  bias = c(aperm(bias, c(2, 1, 3)))

  # instanciation of class GCoptimizationGridGraph
  gco <- new(GCoptimizationGridGraph, width, height, 3)
  # Preparing the DataCost and SmoothCost functions of the MRF in C++
  ptrDataCost <- cppXPtr(
    code = 'float dataFn(int p, int l, Rcpp::List extraData)
  {
    int numPix = extraData["numPix"];
    NumericVector data = extraData["data"];
    return( 1.0 * pow(data[p + numPix * l], 2) );
  }',
    includes = c("#include <math.h>", "#include <Rcpp.h>")
  )
  ptrSmoothCost <- cppXPtr(
    code = 'float smoothFn(int p1, int p2, int l1, int l2, Rcpp::List extraData)
  {
    int numPix = extraData["numPix"];
    NumericVector data = extraData["data"];
    float cost = abs(data[p1 + numPix * l1]-data[p1 + numPix * l2])
    + abs(data[p2 + numPix * l1] - data[p2 + numPix * l2]) ;
    return(0.5 * cost);
  }',
    includes = c("#include <math.h>", "#include <Rcpp.h>")
  )
  # Assigning the DataCost and SmoothCost functions to the MRF graph, gco
  gco$setDataCost(ptrDataCost, list(numPix = width * height, data = bias))
  gco$setSmoothCost(ptrSmoothCost, list(numPix = width * height, data = bias))
  cat("energy before optimization: ", gco$compute_energy(), "\n with labels: \n")
  for(j in 1:height){
    for(i in 1:width){
      cat(gco$whatLabel((i - 1) + width * (j - 1)), " ")
    }
    cat("\n")
  }
  # Optimizing the MRF energy with alpha-beta swap
  gco$swap(-1)
  # For alpha expansion, use:
  # gco$expansion(-1)
  cat("energy after optimization: ", gco$compute_energy(), "\n with labels: \n")
  for(j in 1:height){
    for(i in 1:width){
      cat(gco$whatLabel((i - 1) + width * (j - 1)), " ")
    }
    cat("\n")
  }
}
\keyword{datasets}
