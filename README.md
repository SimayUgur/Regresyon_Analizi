# Regresyon_Analizi1
## ÇOKLU DOĞRUSAL REGRESYON ANALİZİ
 ISLR paketinde yer alan Hitters veri setini kullanarak aşağıdaki sorulara yanıt aranacaktır.
 
 Bağımlı değişken: Salary

 Bağımsız değişkenler:CRuns,Walks,Years,Division,CRBI,CWalks,NewLeague,CAtBat,PutOuts

Soruları cevaplamadan önce;
*Hitters=na.omit(Hitters) kodunu kullanarak kayıp gözlemleri temizlenecek.

*Veri setinin %70’i eğitim ve %30’u test verisi olmak üzere ayrılacak. (set.seed=123)


Yapılacaklar:
1. Matris Plot oluşturma.

2. Korelasyon matrisi ve korelasyon katsayılarına ilişkin p değerlerini matrisini elde ederek, %5
önem düzeyinde anlamlı korelasyon katsayılarını elde etmek.

3. Çoklu doğrusal regresyon modelini elde etme ve model geçerliliğini sıfır ve alternatif
hipotezleri belirterek %5 önem düzeyinde test etme.

4. Hipotezleri yazarak, elde edilen modeldeki anlamlı katsayıları belirlemek.

5. VIF değerlerini hesaplama ve yorumlama.

6. En iyi olası alt küme değişken seçim yöntemini uygulayarak alternatif iki model belirleme.

7. Alternatif modellerin tahmin performansını test seti üzerinde PRESS değerini dikkate alarak
inceleme ve en uygun modele karar verme.

Karar verilen modeli dikkate alarak  soruları cevaplandırmaya çalışılacak:

8. Hipotezlerioluşturma, hataların normal dağıldığı varsayımını grafikle ve uygun istatistiksel test
ile kontrol etme. (α=0.05) 

9. Hipotezleri yazarak, hataların sabit varyanslı olup olmadığını grafikle ve uygun istatistiksel
test ile kontrol etme. (α=0.05) 

10. Uç değer ve etkin gözlem olup olmadığını grafiklerle ve ilgili değerlerle belirlemek.

11. Modelde yer alan iki değişkene ait katsayıyı yorumlama.

12. Yeni bir gözlem değeri için %95’lik güven aralığını ve kestirim aralığını bularak yorumlamak.
