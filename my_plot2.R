# Written by Karolis Uziela in 2014

library(tools)

my_plot <- function(var1, var2, my_file, my_xlab, my_ylab, my_xlim=NULL, my_ylim=NULL, smooth=F, red_points=NULL) {
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
            postscript(my_file, width=10, height=10, fonts=c('serif'))
        } else {
            png(my_file, type=c("cairo"))
        }
    }
    if (!smooth) {
        plot(var1, var2, xlab=my_xlab, ylab=my_ylab, xlim=my_xlim, ylim=my_ylim)
        points(var1[red_points], var2[red_points], col="red")
    } else {
        if (is.null(my_ylim)) {
            smoothScatter(var1, var2, xlab=my_xlab, ylab=my_ylab, xlim=my_xlim)
        } else {
            smoothScatter(var1, var2, xlab=my_xlab, ylab=my_ylab, xlim=my_xlim, ylim=my_ylim)
        }
    }
    r = paste("pears =", cor1)
    s = paste("spear =", cor2)
    e = paste("rmse =", rmse)
    n = paste("n =", n)

    legend(x="topleft", legend=c(r, s, e, n), bg="white")

    if (my_file != "NONE") {
        dev.off()
    }
}

my_cor <- function(var1, var2, my_method) {
    cor_x <- cor(var1, var2, method=my_method)
    cor_x <- round(cor_x, 2)
    return(cor_x)
}

my_rmse <- function(var1, var2) {
    rmse = sqrt(sum((var1 - var2) ^ 2) / length(var1))
    rmse <- round(rmse, 2)
    return(rmse)
}

