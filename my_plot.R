library(tools)

my_cor <- function(var1, var2, my_method) {
    cor_x <- cor(var1, var2, method=my_method)
    cor_x <- round(cor_x, 2)
    return(cor_x)
}

my_plot <- function(var1, var2, my_file, my_xlab, my_ylab, red_points=NULL, blue_points=NULL, green_points=NULL, my_labels=NULL) {
    cor1 <- my_cor(var1, var2, "pearson")
    cor2 <- my_cor(var1, var2, "spearman")
    #print(paste("file", my_file))
    #print(paste(my_xlab, "vs", my_ylab))
    #print(paste(cor1,cor2))
    n <- length(var1)
    
    my_ext <- file_ext(my_file)
    #png(my_file, width = 300, height = 300, paste(my_file,".png", sep=""))
    #png(my_file, width = 360, height = 360, pointsize=14)
    #png(my_file, width = 180, height = 180, pointsize=6)
    #png(my_file, pointsize=18)
    #png(my_file, width = 10, height = 10, units="cm", res=600)
    
    if (my_ext == "pdf") {
        pdf(my_file, width=10, height=10)
        #pdf(my_file)
    } else {
        png(my_file)
    }

    if (is.null(my_labels)) {
        plot(var1, var2, xlab=my_xlab, ylab=my_ylab)
        points(var1[red_points], var2[red_points], col="red")
        points(var1[blue_points], var2[blue_points], col="blue")
        points(var1[green_points], var2[green_points], col="green")
    } else {
        plot(var1, var2, xlab=my_xlab, ylab=my_ylab, cex=0.5)
        points(var1[red_points], var2[red_points], col="red", cex=0.5)
        points(var1[blue_points], var2[blue_points], col="blue", cex=0.5)
        points(var1[green_points], var2[green_points], col="green", cex=0.5)
        text(var1, var2, xlab=my_xlab, ylab=my_ylab, labels=my_labels, pos=3, cex=0.5, srt=85)
        #text(var1[red_points], var2[red_points], xlab=my_xlab, ylab=my_ylab, labels=my_labels, col="red")
        #text(var1[blue_points], var2[blue_points], xlab=my_xlab, ylab=my_ylab, labels=my_labels, col="blue")
        #text(var1[green_points], var2[green_points], xlab=my_xlab, ylab=my_ylab, labels=my_labels, col="green")
    }

    r = paste("r =", cor1)
    s = paste("s =", cor2)
    n = paste("n =", n)
    
    #legend(x="topleft", legend=c(r, s, n))
    legend(x="topleft", legend=c(r, s, n), bg="white")
    
    
    dev.off()
}

my_hist <- function(var1, my_file, my_xlab, nbreaks) {
    #png(my_file)
    pdf(paste(my_file, ".pdf", sep=""), width=5, height=5)
    hist(var1, xlab=my_xlab, breaks=nbreaks, main="")
    dev.off()
}

my_venn <- function(venn_input, my_file) {
    library(gplots)
    
    #pdf(my_file)
    pdf(my_file, pointsize=16)
    #png(my_file, width = 360, height = 360)
    venn(venn_input)
    dev.off()
}
