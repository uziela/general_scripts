# Written by Karolis Uziela in 2014

library(tools)
library(dplyr)

my_plot_dense <- function(var1, var2, my_file, my_xlab, my_ylab, my_xlim=NULL, my_ylim=NULL, smooth=F, red_points=NULL, MY_CEX=2) {
    cor1 <- my_cor(var1, var2, "pearson")
    cor2 <- my_cor(var1, var2, "spearman")
    rmse <- my_rmse(var1, var2)
    n <- length(var1)

    my_ext <- file_ext(my_file)

    if (my_file != "NONE") {
        if (my_ext == "pdf") {
            pdf(my_file, width=10, height=10)
            #pdf(my_file)
        } else if (my_ext == "eps") {
            setEPS()
            postscript(my_file, width=5, height=5, fonts=c('serif'))
        } else {
            png(my_file, type=c("cairo"))
        }
    }
    #colors <- densCols(var1, var2, colramp=colorRampPalette(c("black", "white")))
    #colors <- densCols(var1, var2, colramp=colorRampPalette(rev(grey.colors(9))[-c(1:3)]))
    colors <- densCols(var1, var2)
    #MY_CEX=2
    plot(var1, var2, col=colors, xlab=my_xlab, ylab=my_ylab, xlim=my_xlim, ylim=my_ylim, cex.axis=MY_CEX, cex.lab=MY_CEX)
    cols <- colorRampPalette(c("white", "red"))( 9 )
    cols <- cols[3:length(cols)]
    colors2 <- densCols(var1, var2, colramp = colorRampPalette(cols))
    points(var1[red_points], var2[red_points], col=colors2[red_points])
#    if (!smooth) {
#        plot(var1, var2, xlab=my_xlab, ylab=my_ylab, xlim=my_xlim, ylim=my_ylim)
#        points(var1[red_points], var2[red_points], col="red")
#    } else {
#        if (is.null(my_ylim)) {
#            smoothScatter(var1, var2, xlab=my_xlab, ylab=my_ylab, xlim=my_xlim)
#        } else {
#            smoothScatter(var1, var2, xlab=my_xlab, ylab=my_ylab, xlim=my_xlim, ylim=my_ylim)
#        }
#    }
    r = paste("pears =", cor1)
    s = paste("spear =", cor2)
    e = paste("rmse =", rmse)
    n = paste("n =", n)
    cc = paste("cc = ", cor1, sep="")

    #legend(x="topleft", legend=c(r, s, e, n), bg="white")
    legend(x="topleft", legend=cc, bg="white", cex=MY_CEX)

    if (my_file != "NONE") {
        dev.off()
    }
}

my_cor <- function(var1, var2, my_method) {
    cor_x <- cor(var1, var2, method=my_method)
    #cor_x <- round(cor_x, 2)
    cor_x <- format(round(cor_x, 2), nsmall = 2)
    return(cor_x)
}

my_rmse <- function(var1, var2) {
    rmse = sqrt(sum((var1 - var2) ^ 2) / length(var1))
    rmse <- round(rmse, 3)
    return(rmse)
}

