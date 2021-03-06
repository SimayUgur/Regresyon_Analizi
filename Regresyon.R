library(caret)
library(Hmisc)
library(ggplot2)
library(tidyverse)
library(AppliedPredictiveModeling)
library(pls) #kismi en kucuk kareler ve pcr icin
library(elasticnet)
library(broom) #tidy model icin
library(glmnet)
library(MASS)
library(ISLR)
library(PerformanceAnalytics)
library(funModeling)
library(Matrix)
library(caret)
library(tidyverse)
library(pls) #kismi en kucuk kareler ve pcr icin
library("car")
library("olsrr")
library("GGally")
library(corrplot)
library(Matrix)
library(olsrr)
library("car")
library("ISLR")
library(broom) #tidy model icin
library(glmnet)
library(MASS)
library(ISLR)
library("knitr")
library("rmarkdown")
library("corrplot")
library("Hmisc")
library("corrplot")
library("car")
library("olsrr")
library("GGally")
library(nortest)
## veri i�leme _veriye genel bak��
df <- ISLR::Hitters
rownames(df) <- c()#row namesleri sildim veriye daha g�zel bakabiliriz.
glimpse(df)

# NA's olanlar� silelim
df <- na.omit(df)
sum(ifelse(is.na(df), 1, 0))

#Columnlar� filtreyelim
# CRuns-11,Walks-6,Years-7,Division,CRBI-12,CWalks-13,NewLeague-20,CAtBat,PutOuts en sona Salarayi att�m
df <- df[,c(6, 7, 8, 11, 12, 13, 15, 16, 20, 19)]
head(df)

set.seed(123)
smp_size <- round(0.7 * nrow(df))
train_ind <- sample(x = nrow(df),size = smp_size,replace = F)
train <- df[train_ind,]
test <- df[-train_ind,]


### 1) Matris Plot olu�turarak yorumlay�n�z
plot(train)


#Geli�mi� Scatter plot:
chart.Correlation(train %>% dplyr::select(-c("NewLeague","Division")), histogram=TRUE, pch=19)

###2) Korelasyon matrisi ve korelasyon katsay�lar�na ili�kin p de�erlerini matrisini  elde ederek, %5 �nem d�zeyinde anlaml� korelasyon katsay�lar�n� belirleyiniz. 


#ilk ba�ta korelasyon .
cormatris <- as.matrix(train[,-c(7,9)])
matris1 <-Hmisc::rcorr(cormatris)
matris1$r


matris1 <-Hmisc::rcorr(cormatris)
matris1$r
corrplot::corrplot(matris1$r, type = "upper", order = "hclust", 
                   tl.col = "black", tl.srt = 45)
matris1$P

corrplot::corrplot(matris1$r, type = "upper", order = "hclust", 
                   tl.col = "black", tl.srt = 45)

#3)�oklu do�rusal regresyon modelini elde ediniz ve model ge�erlili�ini s�f�r ve alternatif
#hipotezleri belirterek %5 �nem d�zeyinde test ediniz.
model<-lm(Salary~Walks+Years+CAtBat+CRuns+CRBI+CWalks+Division+PutOuts+NewLeague, data = train)
summary(model)

##5. VIF de�erlerini hesaplay�n�z ve yorumlay�n�z.
vif(model)
##6En iyi olas� alt k�me de�i�ken se�im y�ntemini uygulayarak alternatif iki model belirleyiniz. Gerek�elerini belirtiniz.
olsrr::ols_step_best_subset(model)

model1<-lm(Salary~Walks+CAtBat+CRuns+CRBI+CWalks+Division+PutOuts+NewLeague,data=train)
summary(model1)
vif(model1)
model2=lm(Salary~Years+CRuns+Division+PutOuts,data=train)
#formul <- train$Salary~train$Years + train$CRuns + train$Division + train$PutOuts
#model2 <- lm(formul)
summary(model2)
#b�t�n katsay�lar anlaml� vif()bakal�m
vif(model2)
model3 <-  lm(Salary~Walks+CRuns+CWalks+Division+PutOuts, data = train)
summary(model3)
car::vif(model3)
### 7) Alternatif modellerin tahmin performans�n� test seti �zerinde PRESS de�erini dikkate alarak inceleyiniz ve en uygun modele karar veriniz.
pred2 <- predict(model2, test)
press2 <- Metrics::rmse(pred2, test$Salary)
print(press2)
pred3 <- predict(model3, test)
press3 <- Metrics::rmse(pred3, test$Salary)
print(press3)
### 8) Hipotezleri yazarak, hatalar�n normal da��ld��� varsay�m�n� grafikle ve uygun istatistiksel test ile kontrol ediniz. (??=0.05) 

plot(model2)
#####Normallik varsay�m�
st.res <- model2$residuals / sd(model2$residuals) 
ks.test(st.res, y = "pnorm")
hist(st.res)
#### 9) Hipotezleri yazarak, hatalar�n sabit varyansl� olup olmad���n� grafikle ve uygun istatistiksel test ile kontrol ediniz. (??=0.05) 
car::ncvTest(model2)
#### 10) U� de�er ve etkin g�zlem olup olmad���n� grafiklerle ve ilgili de�erlerle belirleyiniz.plot(model2$fitted.values, st.res)
abline(h = 0, lty = 2)
abline(h = c(-2,2), col = "red")
cutoff <- 4/(length(train$Salary)-5)
plot(model2, which=4, cook.levels=cutoff)
bad_lev <- which(abs(st.res)>2 & hatvalues(model2)> 2*mean(hatvalues(model2)))
bad_lev
require(dplyr)
df2 <- df[-bad_lev,]
df2 <- df2[-c(128),]
set.seed(123)
smp_size2 <- round(0.7 * nrow(df2))
train_ind2 <- sample(x = nrow(df2),size = smp_size2,replace = F)
train2 <- df2[train_ind2,]
test2 <- df2[-train_ind2,]
model4 <- lm(Salary~Years + CRuns + Division + PutOuts, data=train2)
summary(model4)
plot(model4)
st.res4 <- model4$residuals / sd(model4$residuals) 
stats::ks.test(st.res4, y = "pnorm")
car::ncvTest(model4)
# art�klar�n mutlak de�eri
abs_res <- abs(model4$residuals)
# fitted valuelar
fitted_val <- model4$fitted.values
# a��rl�kland�r�lmak i�in b�yle bir method izleyece�iz. wts de�i�kenini modelimizi a��rl�kland�rmak i�in kullanaca��z.
wts <- 1/fitted(lm(abs_res ~ fitted_val))^2
# a��rl�kland�r�lm�� model:
model5 <- lm(Salary~Years + CRuns + Division + PutOuts, data = train2, weights = wts)

summary(model5)
plot(model5)
st.res5 <- model5$residuals / sd(model5$residuals)
stats::ks.test(st.res5, y = "pnorm")
car::ncvTest(model5)
###11. Modelde yer alan iki de�i�kene ait katsay�y� yorumlay�n�z.
summary(model5)
model5$coefficients

### 12.Yeni bir g�zlem de�eri i�in %95�lik g�ven aral���n� ve kestirim aral���n� bularak yorumlay�n�z.
library(stats)
confint(model5, level = 0.95)
#x0 Y0 i�in G�ven aral��� tahmini.
pred_confint <- predict(model5, test2, interval = "confidence")
test_confint <- cbind(test2, pred_confint)
head(test_confint)
##X0 icin Y0'a ait tahmin araligi##
pred_confint1 <- predict(model5, test2, interval = "predict")
test_confint1 <- cbind(test2, pred_confint1)
head(test_confint)


