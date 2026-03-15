# Black-Scholes Option Pricing for Reliance Industries
# Author: Ananya Pahwa
# Methods: Black-Scholes formula, Monte Carlo simulation, Greeks
# Language: R

# combining the historical price data files of Reliance Industries 
data1 <- read.csv("01:03:23-01:03:24.csv")
data2 <- read.csv("01:03:24-01:03:25.csv")
data3 <- read.csv("01:03:25-01:03:26.csv")


head(data1)
head(data2)
head(data3)

reliance_data <- rbind(data1, data2, data3)
head(reliance_data)

# sorting the combined data
colnames(reliance_data)
reliance_data <- reliance_data[,c("DATE","CLOSE")]

head(reliance_data$DATE)
reliance_data$DATE <- as.Date(reliance_data$DATE, format = "%d-%b-%Y")
head(reliance_data$DATE)
reliance_data <- reliance_data[order(reliance_data$DATE),]

#calculating log returns


str(reliance_data$CLOSE)
reliance_data$CLOSE <- gsub(",","", reliance_data$CLOSE)
reliance_data$CLOSE <- as.numeric(reliance_data$CLOSE)
reliance_data$Log_Return <- c(NA, diff(log(reliance_data$CLOSE)))
reliance_data <- na.omit(reliance_data)
head(reliance_data)
summary(reliance_data$Log_Return)

# counting trading days per year 

reliance_data$Year <- format(reliance_data$DATE, "%Y")
table(reliance_data$Year)

# calculating volatility using historical prices 

daily_volatility <- sd(reliance_data$Log_Return)
daily_volatility
annual_volatility <- daily_volatility * sqrt(252)
annual_volatility

# Defining Option Pricing Inputs 
# Setting current stock price, S_0

S0 <- tail(reliance_data$CLOSE, 1)
S0

# setting strike price, K
K <- S0
K

# setting risk-free rate, r
r <- 0.067
r

# setting volatility, sigma
sigma <- annual_volatility
sigma

# setting time to maturity (time to expiry), T
T <- 30/365
T

# calculating d1 and d2
d1 <- (log(S0/K) + (r + 0.5 * sigma^2) * T) / (sigma * sqrt(T))
d1

d2 <- d1 - sigma * sqrt(T)
d2

# calculating call option price
call_price <- S0 * pnorm(d1) - K * exp(-r * T) * pnorm(d2)
call_price


# Monte Carlo Simulation

n_sim <- 10000
Z <- rnorm(n_sim)
ST <- S0 * exp((r - 0.5 * sigma^2) * T + sigma * sqrt(T) * Z) 

head(ST)  
summary(ST)  

ST  

# Monte Carlo Option Price

payoff <- pmax(ST - K, 0)
mc_price <- exp(-r * T) * mean(payoff)  
mc_price

# Greeks Calculation 
delta <- pnorm(d1)
gamma <- dnorm(d1) / (S0 * sigma * sqrt(T))
vega <- S0 * dnorm(d1) * sqrt(T)
theta <- - (S0 * dnorm(d1) * sigma) / (2 * sqrt(T)) - r * K * exp(-r * T) * pnorm(d2)

delta
gamma
vega
theta

theta_daily <- theta / 365
theta_daily

# Graphs and visualization 

#Distribution of Simulated Stock prices
hist(ST, breaks = 50, col = "lightblue", main = "Distribution of Simulated Stock Prices", xlab = "Simulated Stock Price", ylab = "Frequency")
abline(v = S0, col = "red", lwd = 2)

# Distribution of Option Payoffs
hist(payoff, breaks = 50, col = "lightgreen", main = "Distribution of Option Payoffs", xlab = "Option Payoff", ylab = "Frequency")


  
  