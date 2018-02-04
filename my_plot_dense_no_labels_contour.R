# Written by Karolis Uziela in 2014

library(tools)
library(dplyr)
library(MASS)

my_plot_dense <- function(var1, var2, my_file, my_xlab, my_ylab, my_xlim=NULL, my_ylim=NULL, smooth=F, red_points=NULL, maint=NULL, MY_CEX=1, xaxis=FALSE, yaxis=FALSE, colors=NULL, draw_contour=FALSE, ...) {
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
    if (is.null(colors)) {
        colors <- densCols(var1, var2)
    }
    CEX_AXIS=4
    plot(var1, var2, col=colors, xlab=my_xlab, ylab=my_ylab, xlim=my_xlim, ylim=my_ylim, cex.axis=CEX_AXIS, cex.lab=MY_CEX, xaxt='n', yaxt='n', main=maint, cex.main=MY_CEX, font.main = 1, ...)
    if (draw_contour) {
        z <- kde2d(var1, var2)
        z$z <- log(z$z + 1)
        contour(z, drawlabels=FALSE, nlevels=20, add=TRUE)
    }
    if (xaxis & yaxis) {
        #plot(var1, var2, col=colors, xlab=my_xlab, ylab=my_ylab, xlim=my_xlim, ylim=my_ylim, cex.axis=CEX_AXIS, cex.lab=MY_CEX, main=maint, cex.main=MY_CEX, font.main = 1)
        axis(at=c(0,1), labels=c(0,1), side=1, cex.axis=CEX_AXIS, mgp=c(3,3,0))
        axis(at=c(0,1), las=2, labels=c(0,1), side=2, cex.axis=CEX_AXIS)
    } else if (xaxis) {
        axis(at=c(0,1), labels=c(0,1), side=1, cex.axis=CEX_AXIS, mgp=c(3,3,0))
    } else if (yaxis) {
        axis(at=c(0,1), las=2, labels=c(0,1), side=2, cex.axis=CEX_AXIS)
        #plot(var1, var2, col=colors, xlab=my_xlab, ylab=my_ylab, xlim=my_xlim, ylim=my_ylim, cex.axis=CEX_AXIS, cex.lab=MY_CEX, xaxt='n', main=maint, cex.main=MY_CEX, font.main = 1, las=2)
    } #else {
        #plot(var1, var2, col=colors, xlab=my_xlab, ylab=my_ylab, xlim=my_xlim, ylim=my_ylim, cex.axis=MY_CEX, cex.lab=MY_CEX, xaxt='n', yaxt='n', main=maint, cex.main=MY_CEX, font.main = 1, las=2)
    #}
    cols <- colorRampPalette(c("white", "red"))( 9 )
    cols <- cols[3:length(cols)]
    colors2 <- densCols(var1, var2, colramp = colorRampPalette(cols))
    points(var1[red_points], var2[red_points], col=colors2[red_points])
    #points(var1[red_points], var2[red_points], col='black')
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

