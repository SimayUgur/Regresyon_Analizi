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
## veri iþleme _veriye genel bakýþ
df <- ISLR::Hitters
rownames(df) <- c()#row namesleri sildim veriye daha güzel bakabiliriz.
glimpse(df)

# NA's olanlarý silelim
df <- na.omit(df)
sum(ifelse(is.na(df), 1, 0))

#Columnlarý filtreyelim
# CRuns-11,Walks-6,Years-7,Division,CRBI-12,CWalks-13,NewLeague-20,CAtBat,PutOuts en sona Salarayi attým
df <- df[,c(6, 7, 8, 11, 12, 13, 15, 16, 20, 19)]
head(df)

set.seed(123)
smp_size <- round(0.7 * nrow(df))
train_ind <- sample(x = nrow(df),size = smp_size,replace = F)
train <- df[train_ind,]
test <- df[-train_ind,]


### 1) Matris Plot oluþturarak yorumlayýnýz
plot(train)


#Geliþmiþ Scatter plot:
chart.Correlation(train %>% dplyr::select(-c("NewLeague","Division")), histogram=TRUE, pch=19)

###2) Korelasyon matrisi ve korelasyon katsayýlarýna iliþkin p deðerlerini matrisini  elde ederek, %5 önem düzeyinde anlamlý korelasyon katsayýlarýný belirleyiniz. 


#ilk baþta korelasyon .
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

#3)Çoklu doðrusal regresyon modelini elde ediniz ve model geçerliliðini sýfýr ve alternatif
#hipotezleri belirterek %5 önem düzeyinde test ediniz.
model<-lm(Salary~Walks+Years+CAtBat+CRuns+CRBI+CWalks+Division+PutOuts+NewLeague, data = train)
summary(model)

##5. VIF deðerlerini hesaplayýnýz ve yorumlayýnýz.
vif(model)
##6En iyi olasý alt küme deðiþken seçim yöntemini uygulayarak alternatif iki model belirleyiniz. Gerekçelerini belirtiniz.
olsrr::ols_step_best_subset(model)

model1<-lm(Salary~Walks+CAtBat+CRuns+CRBI+CWalks+Division+PutOuts+NewLeague,data=train)
summary(model1)
vif(model1)
model2=lm(Salary~Years+CRuns+Division+PutOuts,data=train)
#formul <- train$Salary~train$Years + train$CRuns + train$Division + train$PutOuts
#model2 <- lm(formul)
summary(model2)
#bütün katsayýlar anlamlý vif()bakalým
vif(model2)
model3 <-  lm(Salary~Walks+CRuns+CWalks+Division+PutOuts, data = train)
summary(model3)
car::vif(model3)
### 7) Alternatif modellerin tahmin performansýný test seti üzerinde PRESS deðerini dikkate alarak inceleyiniz ve en uygun modele karar veriniz.
pred2 <- predict(model2, test)
press2 <- Metrics::rmse(pred2, test$Salary)
print(press2)
pred3 <- predict(model3, test)
press3 <- Metrics::rmse(pred3, test$Salary)
print(press3)
### 8) Hipotezleri yazarak, hatalarýn normal daðýldýðý varsayýmýný grafikle ve uygun istatistiksel test ile kontrol ediniz. (??=0.05) 

plot(model2)
#####Normallik varsayýmý
st.res <- model2$residuals / sd(model2$residuals) 
ks.test(st.res, y = "pnorm")
hist(st.res)
#### 9) Hipotezleri yazarak, hatalarýn sabit varyanslý olup olmadýðýný grafikle ve uygun istatistiksel test ile kontrol ediniz. (??=0.05) 
car::ncvTest(model2)
#### 10) Uç deðer ve etkin gözlem olup olmadýðýný grafiklerle ve ilgili deðerlerle belirleyiniz.plot(model2$fitted.values, st.res)
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
# artýklarýn mutlak deðeri
abs_res <- abs(model4$residuals)
# fitted valuelar
fitted_val <- model4$fitted.values
# aðýrlýklandýrýlmak için böyle bir method izleyeceðiz. wts deðiþkenini modelimizi aðýrlýklandýrmak için kullanacaðýz.
wts <- 1/fitted(lm(abs_res ~ fitted_val))^2
# aðýrlýklandýrýlmýþ model:
model5 <- lm(Salary~Years + CRuns + Division + PutOuts, data = train2, weights = wts)

summary(model5)
plot(model5)
st.res5 <- model5$residuals / sd(model5$residuals)
stats::ks.test(st.res5, y = "pnorm")
car::ncvTest(model5)
###11. Modelde yer alan iki deðiþkene ait katsayýyý yorumlayýnýz.
summary(model5)
model5$coefficients

### 12.Yeni bir gözlem deðeri için %95’lik güven aralýðýný ve kestirim aralýðýný bularak yorumlayýnýz.
library(stats)
confint(model5, level = 0.95)
#x0 Y0 için Güven aralýðý tahmini.
pred_confint <- predict(model5, test2, interval = "confidence")
test_confint <- cbind(test2, pred_confint)
head(test_confint)
##X0 icin Y0'a ait tahmin araligi##
pred_confint1 <- predict(model5, test2, interval = "predict")
test_confint1 <- cbind(test2, pred_confint1)
head(test_confint)


