library(readr)
TAN_PCa_dfmerged_Nolan_names_0904 <- read_csv("../data/TAN-PCa_dfmerged_Nolan-names_0904.csv")
G3_PCa_dfmerged_Nolan_names_0904 <- read_csv("../data/G3-PCa_dfmerged_Nolan-names_0904.csv")
G4_PCa_dfmerged_Nolan_names_0904 <- read_csv("../data/G4-PCa_dfmerged_Nolan-names_0904.csv")
df <- rbind(TAN_PCa_dfmerged_Nolan_names_0904, G3_PCa_dfmerged_Nolan_names_0904, G4_PCa_dfmerged_Nolan_names_0904)
#df <- df[,-c(1,2,3,4,6,10)]

table(df$ClusterName)
table(df$Region)
df[,'Spots'] <- NA

colnames(df)[colnames(df) == 'X:X']<- 'X'
colnames(df)[colnames(df) == 'Y:Y']<- 'Y'

x<-c()
for(r in unique(df$Region)){
  print(r)
  coords <- df[df$Region ==r, c('X', 'Y')]
  print(range(coords$X))
  print(range(coords$Y))
  x <- c(x,coords)
  print('range')
  print(range(coords))
}
range(x)

size = 2000

x_grid = seq(0, 30000, size)[-1]
y_grid = seq(0, 30000, size)[-1]
grids = expand.grid(x_grid, y_grid)

for(r in unique(df$Region)){
  print(r)
  dX <- (df[df$Region ==r, c('X')])
  dY <-  (df[df$Region ==r, c('Y')])
  d <- data.frame(dX, dY)
  
  dX2 = ceiling(d$X/size)*size
  dY2 = ceiling(d$Y/size)*size
  
  d$group = match(paste(dX2,dY2,sep = "-"), paste(grids$Var1,grids$Var2,sep="-"))
  
  pdf(sprintf('%s_grid_spots.pdf', r))
  plot(d$X, d$Y, type = "p", col = d$group, pch = 19, main = r)
  legend("topright", legend=unique(d$group), col=unique(d$group), pch = 19, cex=0.8)
  dev.off()
  
  df$Spots[df$Region == r] <- paste0(r,'_',d$group)
  print('groups')
  #print(table(d$group))
  print(summary(as.numeric(table(d$group))))
}

write.csv(df, file = 'all_cells_with_grid_spots.csv', row.names = FALSE)

all_cells_with_2K_pixel_grid_spots <- read_csv("all_cells_with_2K_pixel_grid_spots.csv")
df <- all_cells_with_2K_pixel_grid_spots[,c("Spots", "Grades", "Region", "X", "Y", "CellType")]
colnames(df) <- c('Spots', 'Groups', 'Patients', 'X', 'Y', 'ClusterName')

g <- 'TAN'
# number of cells
sum(df$Groups == 'TAN')
dfg <- df[df$Groups == 'TAN', 'Spots']
#spots_tan <- names(sort(table(dfg), decreasing = TRUE))[1:50]

patients <- as.character(unlist(unique(df[df$Groups == 'TAN', 'Patients'])))
spots_tan <- c()
for(patient in patients){
  dfg <- c()
  dfg <- df[df$Patients == patient, 'Spots']
  spots_tan <- c(spots_tan, names(sort(table(dfg), decreasing = TRUE))[1:10])
}

g <- 'G3'
dfg <- df[df$Groups == 'G3', 'Spots']
#spots_g3 <- names(sort(table(dfg), decreasing = TRUE))[1:50]

patients <- as.character(unlist(unique(df[df$Groups == 'G3', 'Patients'])))
spots_g3 <- c()
#for(patient in patients){
for(patient in c('G3_1', 'G3_2', 'G3_5')){
  dfg <- c()
  dfg <- df[df$Patients == patient, 'Spots']
  spots_g3 <- c(spots_g3, names(sort(table(dfg), decreasing = TRUE))[1:10])
}

g <- 'G4'
dfg <- df[df$Groups == 'G4', 'Spots']
#spots_g4 <- names(sort(table(dfg), decreasing = TRUE))[1:50]

patients <- as.character(unlist(unique(df[df$Groups == 'G4', 'Patients'])))
spots_g4 <- c()
#for(patient in patients){
for(patient in c('G4_1', 'G4_2', 'G4_3')){
  dfg <- c()
  dfg <- df[df$Patients == patient, 'Spots']
  spots_g4 <- c(spots_g4, names(sort(table(dfg), decreasing = TRUE))[1:10])
}

df_with_all_cell_spots <- df[df$Spots %in% c(spots_tan, spots_g3, spots_g4), ]

write.csv(df_with_all_cell_spots, '../NeighborhoodIdentification/df_with_all_3patients_10spots.csv')
