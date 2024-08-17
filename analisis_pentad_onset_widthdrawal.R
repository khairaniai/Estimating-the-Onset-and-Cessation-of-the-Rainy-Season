install.packages("rJava")
#setwd('data hujan st/')
library("xlsx")
library(readxl)
#library("plotly")

nday <- 365
onsetDays <- rep(1:73,each=5)
#hujan <- na.omit(hujan)
save_all <- NULL

fs <- list.files(path="./", pattern = "xlsx$", full.names = F) #fs memperlihatkan data excel dlm setdir folder
nfile =1 ##ambil data(excel) pertama dalam suatu folder dari working directory
for (nfile in 1:length(fs)) {
  xlsxFile = fs[nfile]
  hujan <- read_xlsx(xlsxFile,sheet = 1)
   # hujan$hujan <- as.integer(hujan$hujan)
  hujan$hujan <- as.numeric(as.character(hujan$hujan))
  
    nama_stasiun <- sub(x = xlsxFile,pattern = ".xlsx",replacement = "")
    
    uji <- seq(1,length(hujan$tanggal),365)+214 ##bisa diganti tergantung julian date
    
    ## analisi pentad mm 5 hari
    # pentad = sum prcp each 5 days
    # onset if mean 3 pentad > sum annual prcp (pm)/73
    # day analysis started in augs 1st
    
    a = 1
    save_lock <- NULL
    
    for (a in 1:20) { tryCatch({ ##ambil data mulai th ke-1 hingga ke 20
      
      dstart <- uji[a]
      dend <- dstart-1+nday
      
      hujan_tahun <- hujan[dstart:dend,1:2]
      
      #pentad <- tapply(hujan$hujan[dstart:dend],onsetDays,mean,na.rm=T)/(sum(hujan$hujan[dstart:dend],na.rm=T)/73)
      pentad <- tapply(hujan$hujan[dstart:dend],onsetDays,sum,na.rm=T) #pentad
      annual_pentad <- (sum(hujan$hujan[dstart:dend],na.rm=T)/73)
      
      m3_pe = 0
      pe =2
      for (pe in 1:(73-2)){
        m3_pe[pe]<- mean(pentad[pe:(pe+2)]) ##utk merata2kan 3 konsekutif pentad 
      }
      loc_onset <- which((m3_pe>annual_pentad)==T)[1] ##onset diprediksi pd tanggal jika m3_pe>annual_pentad
      loc_widrowl <- rev(which((m3_pe>annual_pentad)==T))[1]
      
      all_day_onset <- seq(dstart,dend,5)+2
      
      peak_onset <- match(pentad[pentad>(sum(hujan$hujan[dstart:dend],na.rm=T)/73)],pentad)
      
      res_allonset <- data.frame(hujan$tanggal[all_day_onset],pentad)
      names(res_allonset)[1] <- "tanggal"
      names(res_allonset)[2] <- "onset"
      
      na_annual <- sum(is.na(hujan_tahun$hujan))
      
      ##calculate avg rainy season
      n_o <- which(hujan_tahun$tanggal==res_allonset[loc_onset,1])
      n_w <- which(hujan_tahun$tanggal==res_allonset[loc_widrowl,1])
      avg_rainy <- mean(hujan_tahun$hujan[n_o:n_w],na.rm = T)
      na_rainy <- sum(is.na(hujan_tahun$hujan[n_o:n_w]))
      total_prcp <- sum(hujan_tahun$hujan,na.rm=T)
      
      loc_detect <- rbind.data.frame(res_allonset[loc_onset,],res_allonset[loc_widrowl,])
      loc_detect_save <- cbind.data.frame(nama_stasiun,format(hujan$tanggal[uji[a]], "%Y"),
                                          loc_onset,res_allonset[loc_onset,1],loc_widrowl,
                                          res_allonset[loc_widrowl,1],res_allonset[loc_widrowl,1]
                                          -res_allonset[loc_onset,1],
                                          avg_rainy,na_rainy,na_annual,total_prcp)
      
      names(loc_detect_save)[1] <- "st"
      names(loc_detect_save)[2] <- "year"
      names(loc_detect_save)[3] <- "onset pentad"
      names(loc_detect_save)[4] <- "onset"
      names(loc_detect_save)[5] <- "withdrawal pentad"
      names(loc_detect_save)[6] <- "withdrawal"
      names(loc_detect_save)[7] <- "length"
      
      
      if(a==1){ ###INI BUKAN SIH PENYEBAB TDK DISAVE DARI TH 2000??? a==1
        save_lock <- loc_detect_save
        }
      else{
        save_lock <- rbind.data.frame(save_lock,loc_detect_save)
        }
      ## start plotting
      png(paste('pentad_',xlsxFile,'_dst_',dstart,'.png',sep =''), width = 3200, height = 1600,res = 300)
      par(mar=c(4, 8, 2, 2) + 0.1)
      plot(res_allonset,axes=F, ylim=c(0,max(res_allonset$onset,na.rm = T)+50), xlab='', ylab='',type='n',col='red', main='')
      ##lines(res_allonset$tanggal[all_day_onset],rep((sum(hujan$hujan[dstart:dend],na.rm=T)/73),73))
      ##text(x=res_allonset$tanggal[peak_onset+4],y=res_allonset$onset[peak_onset]+0.02,res_allonset$tanggal[peak_onset])
      text(x=loc_detect$tanggal,y=100,loc_detect$tanggal)
      
      axis(2, ylim=c(0,max(res_allonset$onset,na.rm = T)+50),col='black',lwd=2)
      mtext(2,text='Pentad',line=2)
      title(nama_stasiun)
      par(new=T)
      plot(x = hujan$tanggal[all_day_onset], y=rep((sum(hujan$hujan[dstart:dend],na.rm=T)/73),73),axes=F,
           ylim=c(0,max(res_allonset$onset,na.rm = T)+50), xlab='', ylab='',type='l',col='red', main='')
      points.default(x=loc_detect$tanggal[1],y=loc_detect$onset[1],type ="p",pch=19,col='blue')  
      points.default(x=loc_detect$tanggal[2],y=loc_detect$onset[2],type ="p",pch=25,col='blue')  
      
      #lines(res_allonset,col="red")
      par(new=T)
      barplot(height = res_allonset$onset,axes=F, ylim=c(0,max(res_allonset$onset,na.rm = T)+50), xlab='', ylab='',col="black",main='')
      
      par(new=T)
      plot(hujan_tahun,axes=F, ylim=rev(c(0,max(hujan_tahun$hujan,na.rm = T)+50)), col='blue'  ,xlab='', ylab='', 
           type='l',lty=2, main='')
      axis(2, ylim=rev(c(0,max(hujan_tahun$hujan,na.rm = T)+50)),lwd=2,line=3.5)
      mtext(2,text='Prcp (mm/day)',line=5.5)
      
      axis.Date(1,at=seq(min(hujan_tahun$tanggal), seq(max(hujan_tahun$tanggal), by='1 month', length=2)[2], by="1 month"), 
                format = "%m-%Y", lwd=2)
      axis.Date(3,at=seq(min(hujan_tahun$tanggal), seq(max(hujan_tahun$tanggal), by='1 month', length=2)[2], by="1 month"), 
                format = "%m-%Y",labels = F,lwd=2)
      mtext('Date',side=1,col='black',line=2)
      dev.off()
      
    }, error=function(e){})
    }
    
    if(nfile==1){
      save_all <- save_lock
    }
    else{
      save_all <- rbind.data.frame(save_all,save_lock)
    }
  write.csv(save_lock,file = paste('pentad_onset_wdt',nama_stasiun,'_result.csv',sep = ""))
}
write.csv( save_all,file = paste('pentad_onset_wdt_all_result.csv',sep = ""))
