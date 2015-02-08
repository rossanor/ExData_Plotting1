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

# divide device do gráfico 4
par(mfrow=c(2,2))

#  1
plot(dados2$Global_active_power ~ dados2$dias, main = "", type = "l", 
     xaxt = "n", ylab="Global Active Power", xlab="")
axis(1, at = c(0, 1, 2), label = c("Thu", "Fri", "Sat"))

#  2
plot(dados2$Voltage ~ dados2$dias, main = "", type = "l", 
     xaxt = "n", ylab="Voltage", xlab="datetime")
axis(1, at = c(0, 1, 2), label = c("Thu", "Fri", "Sat"))

#  3
plot(dados2$Sub_metering_1 ~ dados2$dias, main = "", type = "l", 
     xaxt = "n", ylab="Energy sub metering", xlab="")
lines(dados2$dias, dados2$Sub_metering_2, col = "red")
lines(dados2$dias, dados2$Sub_metering_3, col = "blue")
axis(1, at = c(0, 1, 2), label = c("Thu", "Fri", "Sat"))
legend("topright", text.width = 1.1, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = 1, col=c("black", "red", "blue"), bty = "n")

#  4
plot(dados2$Global_reactive_power ~ dados2$dias, main = "", type = "l", 
     xaxt = "n", ylab="Global_reactive_power", xlab="datetime")
axis(1, at = c(0, 1, 2), label = c("Thu", "Fri", "Sat"))

# copia para um arquivo PNG
dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off() # close the PNG device

