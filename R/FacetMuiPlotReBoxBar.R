#' Use facets to show the results of variance analysis, box+bar plot selected
#'
#' @param data a data.frame contain the input data;Enter the data frame, the first column is the sample number, the second column is the group, note that the group label must be set to group, and the third column and later are the indicators for measurement or collection.
#' @param  num col index wtich need to test
#' @param result output from aovMcomper or KwWlx. You can also import result calculated from other software (a data frame)
#' @param sig_show Distinctive display, "abc" or "line"
#' @param ncol If you choose faceted display, choose to place several graphics per line
#' @examples
#' # data(data_wt)
#' result = MuiKwWlx(data = data_wt,num = c(4:6))
#' result1 = FacetMuiPlotReBoxBar (data = data_wt,num = c(4:6),result = result,sig_show ="abc",ncol = 2 )
#' result1[[1]]
#' @return list
#' @author Contact: Tao Wen \email{2018203048@@njau.edu.cn} Jun Yuan \email{junyuan@@njau.edu.cn}
#' @references
#'
#' Yuan J, Zhao J, Wen T, Zhao M, Li R, Goossens P, Huang Q, Bai Y, Vivanco JM, Kowalchuk GA, Berendsen RL, Shen Q
#' Root exudates drive the soil-borne legacy of aboveground pathogen infection
#' Microbiome 2018,DOI: \url{doi: 10.1186/s40168-018-0537-x}
#' @export






FacetMuiPlotReBoxBar = function(data = data_wt,num = c(4:6),result = result,sig_show ="abc",ncol = 3 ){

  for (N in num) {

    name = colnames(data[N])

    as = result[match( name,colnames(result))]
    # as = result[c(N - length(num))]
    as
    colnames(as) = "groups"
    as$group = row.names(as)

    PlotresultBox = aovMuiBoxP(data = data, i= N,sig_show =sig_show,result =as)

    p = PlotresultBox[[2]]
    p
    name = colnames(data[N])
    p$name = name

    if (N == num[1]) {
      A = p
    }
    if (N != num[1]) {
      A = rbind(A,p)
    }


  }

  iris_groups<- dplyr::group_by(A, group,name)
  databar<- dplyr::summarise(iris_groups, mean(dd), sd(dd))
  colnames(databar) = c("group","name","mean","sd")

  head(databar)
  p = ggplot(A) +
    geom_bar(data = databar,aes(x= group,y = mean,fill = group),stat = "identity", width = 0.4,position = "dodge",colour= "black") +
    geom_text(data=A, aes(x=group , y=y ,label=stat))+
    geom_errorbar(data = databar,aes(x= group,y = mean,ymin=mean -sd, ymax=mean +sd),colour="black",width=0.1,size = 1)+
    geom_jitter(aes(x=group, y=dd, fill=group),A,position=position_jitter(0.17), size=4, alpha=0.7,pch = 21,color = "black")+
    labs(x="", y="")+
   facet_wrap(.~name,scales="free_y",ncol  = ncol)

  return(list(p,table = A,bartable = databar))
}
