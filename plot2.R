# baixa o arquivo ZIP, descompacta e lê
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
dados <- read.table(unz(temp, "household_power_consumption.txt"), 
                    h=T, sep=";", na.strings = "?")
unlink(temp)

dados2 <- dados

# converte data e tempo de texto para o formato do R
data_aux <- as.Date(dados2$Date, "%d/%m/%Y")

# seleciona subamostra dos dados
dados2 <- dados2[data_aux >= as.Date("2007-02-01") &
                 data_aux <= as.Date("2007-02-02"), ]

# cria uma variável para data e tempo
datahora <- paste(dados2$Date, dados2$Time)
dados2$datahora <- strptime(datahora, format = "%d/%m/%Y %H:%M:%S")
dados2$dias <- difftime(dados2$datahora, 
                        strptime("01/02/2007 00:00:00", format = "%d/%m/%Y %H:%M:%S"), units = "days")
                
str(dados2)
rm(dados, temp, data_aux, datahora)

# cria uma tela nova independente do Rstudio
dev.new(noRStudioGD = T)

# graf 2
plot(dados2$Global_active_power ~ dados2$dias, main = "", type = "l", 
     xaxt = "n", ylab="Global Active Power (kilowatts)", xlab="")
axis(1, at = c(0, 1, 2), label = c("Thu", "Fri", "Sat"))

# copia para um arquivo PNG
dev.copy(png, file = "plot2.png", width=480, height=480)
dev.off() # close the PNG device
