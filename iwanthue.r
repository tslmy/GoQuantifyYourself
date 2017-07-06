swatch <- function(x) {
  # x: a vector of colours (hex, numeric, or string)
  par(mai=c(0.2, max(strwidth(x, "inch") + 0.4, na.rm = TRUE), 0.2, 0.4))
  barplot(rep(1, length(x)), col=rev(x), space = 0.1, axes=FALSE, 
          names.arg=rev(x), cex.names=0.8, horiz=T, las=1)  
}

# Example:
# swatch(colours()[1:10])
# swatch(iwanthue(5))
# swatch(1:4)

iwanthue <- function(n, hmin=0, hmax=360, cmin=0, cmax=180, lmin=0, lmax=100, 
                     plot=FALSE) {
  # Presently doesn't allow hmax > hmin (H is circular)
  # n: number of colours
  # hmin: lower bound of hue (0-360)
  # hmax: upper bound of hue (0-360)
  # cmin: lower bound of chroma (0-180)
  # cmax: upper bound of chroma (0-180)
  # lmin: lower bound of lightness (0-100)
  # lmax: upper bound of lightness (0-100)
  # plot: plot a colour swatch?
  require(colorspace)
  stopifnot(hmin >= 0, cmin >= 0, lmin >= 0, 
            hmax <= 360, cmax <= 180, lmax <= 100, 
            hmin <= hmax, cmin <= cmax, lmin <= lmax,
            n > 0)
  lab <- LAB(as.matrix(expand.grid(seq(0, 100, 1), 
                                   seq(-100, 100, 5), 
                                   seq(-110, 100, 5))))
  if (any((hmin != 0 || cmin != 0 || lmin != 0 ||
           hmax != 360 || cmax != 180 || lmax != 100))) {
    hcl <- as(lab, 'polarLUV')
    hcl_coords <- coords(hcl)
    hcl <- hcl[which(hcl_coords[, 'H'] <= hmax & hcl_coords[, 'H'] >= hmin &
                       hcl_coords[, 'C'] <= cmax & hcl_coords[, 'C'] >= cmin & 
                       hcl_coords[, 'L'] <= lmax & hcl_coords[, 'L'] >= lmin), ]
    #hcl <- hcl[-which(is.na(coords(hcl)[, 2]))]
    lab <- as(hcl, 'LAB')    
  }
  lab <- lab[which(!is.na(hex(lab))), ]
  clus <- kmeans(coords(lab), n, iter.max=50)
  if (isTRUE(plot)) {
    swatch(hex(LAB(clus$centers)))
  }
  hex(LAB(clus$centers))
}

# Examples:
# iwanthue(5)
# iwanthue(5, hmin=200, hmax=300, plot=TRUE)