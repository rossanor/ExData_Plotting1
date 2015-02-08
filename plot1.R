# baixa o arquivo ZIP, descompacta e lê
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
dados <- read.table(unz(temp, "household_power_consumption.txt"), 
                    h=T, sep=";", na.strings = "?")
unlink(temp)


#dados <- read.table("household_power_consumption.txt", h=T, sep=";", na.strings = "?")

summary(dados)
head(dados)
str(dados)

dados2 <- dados

# converte data de texto para o formato do R
dados2$Date <- as.Date(dados2$Date, "%d/%m/%Y")

# seleciona subamostra dos dados
dados2 <- dados2[dados2$Date >= as.Date("2007-02-01") &
                 dados2$Date <= as.Date("2007-02-02"), ]
                
str(dados2)
rm(dados, temp)

# cria uma tela nova independente do Rstudio
dev.new(noRStudioGD = T)

# graf 1
hist(dados2$Global_active_power, col = 2, main = "Global Active Power", xlab = "Global Active Power (kilowatts)")

# copia para um arquivo PNG
dev.copy(png, file = "plot1.png", width=480, height=480)
dev.off() # close the PNG device
