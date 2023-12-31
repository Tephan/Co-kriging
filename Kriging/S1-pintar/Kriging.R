library(sp)
library(png)
library(grid)
library(tibble)
library(viridis)
library(gstat)
library(ggplot2)
#Imagen de fondo

img <- readPNG("C:/Users/tepha/Documents/MSC/Estancia/Kriging-EEG/cokriging/Rplot04.png")
g <- rasterGrob(img, width=unit(1,"npc"), height=unit(1,"npc"), interpolate = FALSE)


#Lectura de los datos

dato <- read.csv('C:\\Users\\tepha\\Desktop\\Se�ales\\KRIGING\\Luis-pintar\\luis-pintar.csv')


#Creación de la malla
x<-seq(-2.6,2.57,length=200)
y<-seq(-3.5,3.8,length=200)


x1<-NA

for(k in 1:length(x)){
  if(is.na(x1))
    x1<- c(rep(x[k],length(y)))
  else
    x1<-c(x1,rep(x[k],length(y)))
}

y1<-NA
for(k in 1:length(x)){
  if(is.na(y1))
    y1<- c(y)
  else
    y1<-c(y1,y)
}

mi_df <- data.frame( "X" = x1, "Y" = y1)


#Se convierto a objecto espacial
coordinates(dato) <- ~X+Y
dato.grid<-mi_df

#Creación del variograma, Modificar la banda
v = variogram(Alfa~1, data=dato)
#Beta Method 2
#m <- vgm(psill=0.0054,model="Exp",range=2, nugget=0.00001)
#Alfa Method 2
m <- vgm(psill=0.0035,model="Sph",range=2, nugget=0.000001)
#Delta Method 2
#m <- vgm(psill=0.0255,model="Exp",range=1.5, nugget=0.0002)
#Tetha method 2
#m <- vgm(psill=0.0017,model="Sph",range=2, nugget=0.00005)
#Gamma method 2
#m <- vgm(psill=0.00068,model="Sph",range=1, nugget=0.0004)

#plot(v$dist, v$gamma,  xaxs="i", yaxs="i")
plot(v, model=m)
#Variograma ajustado
FittedModel <- fit.variogram(v,
                             model=m,fit.method = 2)

plot(v, model=FittedModel)
gridded(dato.grid) = ~X+Y

#Creación del Krige.
a <- krige(Alfa~1, dato,
           dato.grid, FittedModel)
#plot(a)+annotation_custom(g, -Inf, Inf, -Inf, Inf)


#Graficación del krige y de la malla.
mi_df2 <- as.data.frame(a@coords)
mi_df2<-cbind(mi_df2,a$var1.pred)
ggplot(mi_df2, aes(x=X, y=Y)) + ylim(-3.5,3.98)+xlim(-2.6,2.57)+ 
  geom_point(aes(color = a$var1.pred)) +
  scale_color_viridis(option = "B")+
  annotation_custom(g, -Inf, Inf, -Inf, Inf) +
  theme_minimal() +
  theme(legend.position = "bottom")+ theme(
    plot.background = element_rect(fill = 'white')
  )

ggplot(mi_df2, aes(x=X, y=Y)) + ylim(-3.5,3.98)+xlim(-2.6,2.57)+ 
  geom_point(aes(color = a$var1.var)) +
  scale_color_viridis(option = "B")+
  annotation_custom(g, -Inf, Inf, -Inf, Inf)+
  theme_minimal() +
  theme(legend.position = "bottom")+ theme(
    plot.background = element_rect(fill = 'white')
  )


