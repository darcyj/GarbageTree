# This script compares the garbage tree made in the example script (garbage_tree_example.r)
	# with a tree made using GhostTree 
	# (https://github.com/JTFouquier/ghost-tree)
	# (https://github.com/darcyj/ghost-tree-unite7-silva128)

# The ghost-tree has already had the tips re-named to zOTUIDs using BLAST (not shown).
	# Contact the author for more info on tip-renaming.

# Read in trees
	library(ape)
	ghosttree <- read.tree("ghosttree_otuIDs.nwk")
	garbagetree<- read.tree("garbagetree_example.nwk")

# remove extra tips from ghosttree 
	extra_tips <- ghosttree$tip.label[ ! ghosttree$tip.label %in% garbagetree$tip.label ]
	ghosttree <- drop.tip(ghosttree, tip=extra_tips, trim.internal=TRUE)

# make cophenetic distance matrices for each tree
	garbage_coph <- cophenetic.phylo(garbagetree)
	ghost_coph <- cophenetic.phylo(ghosttree)

# sanity check
	all(dim(garbage_coph) == dim(ghost_coph))

# sort cophenetic matrices to match each other
	garbage_coph <- garbage_coph[order(rownames(garbage_coph)), order(colnames(garbage_coph))]
	ghost_coph <- ghost_coph[order(rownames(ghost_coph)), order(colnames(ghost_coph))]

# make a plot using jpeg() because plotting millions of points
	# X11 and pdfs don't like millions of points, raster images are OK.
	tb <- (col2rgb("black")/255)
	tb <- rgb(tb[1], tb[2], tb[3], 0.25)
	jpeg("whatever.jpg", width=1000, height=1000)

	plot(as.dist(garbage_coph) ~ as.dist(ghost_coph), 
		ylab="GarbageTree cophenetic", 
		xlab="GhostTree cophenetic",
		pch=20, col=tb
	)
	dev.off()
