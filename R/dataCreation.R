#' Simulated data for running examples
#'
#' @name simData
#' @aliases simCount trueCluster
#' @docType data
#' @author Elizabeth Purdom \email{epurdom@@stat.berkeley.edu}
#' @format Three objects are loaded, two data frame(s) of simulated data each
#'   with 300 samples/columns and 153 variables/rows, and a vector of length 300
#'   with the true cluster assignments.
#' @details \code{simData} is simulated normal data of 300 observations with 51
#'   relevant variables and the rest of the variables being noise, with
#'   observations being in one of 3 groups. \code{simCount} is simulated count
#'   data of the same dimensions. \code{trueCluster} gives the true cluster
#'   identifications of the samples. The true clusters are each of size 100 and
#'   are in order in the columns of the data.frames.
#' @keywords data
#' @examples
#' #code used to create data:
#' \dontrun{
#' nvar<-51 #multiple of 3
#' n<-100
#' x<-cbind(matrix(rnorm(n*nvar,mean=5),nrow=nvar),
#'  matrix(rnorm(n*nvar,mean=-5),nrow=nvar),
#'           matrix(rnorm(n*nvar,mean=0),nrow=nvar))
#' #make some of them flipped effects (better for testing if both sig under/over
#' #expressed variables)
#' geneGroup<-sample(rep(1:3,each=floor(nvar/3)))
#' gpIndex<-list(1:n,(n+1):(n*2),(2*n+1):(n*3))
#' x[geneGroup==1,]<-x[geneGroup==1,unlist(gpIndex[c(3,1,2)])]
#' x[geneGroup==2,]<-x[geneGroup==2,unlist(gpIndex[c(2,3,1)])]
#'
#' #add in differences in variable means
#' smp<-sample(1:nrow(x),10)
#' x[smp,]<-x[smp,]+10
#'
#' #make different signal y
#' y<-cbind(matrix(rnorm(n*nvar,mean=1),nrow=nvar),
#'          matrix(rnorm(n*nvar,mean=-1),nrow=nvar),
#'          matrix(rnorm(n*nvar,mean=0),nrow=nvar))
#' y<-y[,sample(1:ncol(y))]+ matrix(rnorm(3*n*nvar,sd=3),nrow=nvar)
#'
#' #add together the two signals
#' simData<-x+y
#'
#' #add pure noise variables
#' simData<-rbind(simData,matrix(rnorm(3*n*nvar,mean=10),nrow=nvar),
#'                matrix(rnorm(3*n*nvar,mean=5),nrow=nvar))
#' #make count data
#' countMean<-exp(simData/2)
#' simCount<-matrix(rpois(n=length(as.vector(countMean)), lambda
#' =as.vector(countMean)+.1),nrow=nrow(countMean),ncol=ncol(countMean))
#' #labels for the truth
#' trueCluster<-rep(c(1:3),each=n)
#' save(list=c("simCount","simData","trueCluster"),file="data/simData.rda")
#' }
NULL




#' RSEC run for vignette
#'
#' @name rsecFluidigm
#' @docType data
#' @author Elizabeth Purdom \email{epurdom@@stat.berkeley.edu}
#' @format ClusterExperiment object, the result of running \code{\link{RSEC}} on
#' fluidigm data described in vignette and available in the \code{scRNAseq}
#' package.
#' @seealso \code{\link[scRNAseq]{fluidigm}}
#' @keywords data
#' @examples
#' #code used to create rsecFluidigm:
#' \dontrun{
#' library(scRNAseq)
#' data("fluidigm")
#' se <- fluidigm[,colData(fluidigm)[,"Coverage_Type"]=="High"]
#' wh_zero <- which(rowSums(assay(se))==0)
#' pass_filter <- apply(assay(se), 1, function(x) length(x[x >= 10]) >= 10)
#' se <- se[pass_filter,]
#' fq <- round(limma::normalizeQuantiles(assay(se)))
#' assays(se) <- list(normalized_counts=fq)
#' wh<-which(colnames(colData(se)) %in% c("Cluster1","Cluster2"))
#' colnames(colData(se))[wh]<-c("Published1","Published2")
#' library(clusterExperiment)
#' ncores<-1
#' system.time(
#'   rsecFluidigm<-RSEC(se, 
#'                      isCount = TRUE, 
#'                      k0s = 4:15, 
#'                      alphas=c(0.1, 0.2, 0.3), 
#'                      betas = 0.9,
#'                      reduceMethod="PCA", 
#'                      nReducedDims=10,
#'                      minSizes=1, 
#'                      clusterFunction="hierarchical01",
#'                      consensusMinSize=3,
#'                      consensusProportion=0.7,
#'                      dendroReduce= "mad",
#'                      dendroNDims=1000,
#'                      mergeMethod="adjP",
#' 	                    mergeDEMethod="limma",
#'                      mergeCutoff=0.01,
#'                      ncores=ncores, 
#'                      random.seed=176201)
#' )
#' metadata(rsecFluidigm)$packageVersion<-packageVersion("clusterExperiment")
#' ## Tests that haven't changed the clustering results.
#' x<-unique(clusterMatrix(rsecFluidigm)[,"makeConsensus"])
#' y<-unique(clusterMatrix(rsecFluidigm)[,"mergeClusters"])
#' if(length(x[x>0]) != 8) 
#'   stop("rsecFluidigm object has changed -- makeConsensus")
#' if(length(y[y>0]) != 6) 
#'   stop("rsecFluidigm object has changed -- different # of mergeClusters")
#' adjPValues<-c(0.049794879, 0.007356062, 0.008204838, 
#'   0.013156033, 0.009336540, 0.007497524, 0.033526666)
#' if(nrow(rsecFluidigm@merge_nodeProp)!=length(adjPValues)) 
#'   stop("rsecFluidigm object has changed -- makeDendrogram")
#' if(!all.equal(adjPValues,rsecFluidigm@merge_nodeProp[,"adjP"])) 
#'   stop("rsecFluidigm object has changed -- different percentages")	
#' devtools::use_data(rsecFluidigm,overwrite=FALSE)
#' }
NULL




