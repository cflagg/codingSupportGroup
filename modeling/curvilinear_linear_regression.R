## setup hypothetical data
set.seed(42)
age <- round(runif(n = 1000)*100,0)
gender <- sample(x = c('m', 'f'), size = 1000, replace=TRUE)

## coef defines our hypothetical model between age and performance -- here we 
coef <- 0.3
noise <- rnorm(1000, mean = 0, sd = 0.1)

## build a hypothetical dataset of performance as influenced by age, a power relationship, and some gaussian noise
## this is our "real" data i.e. this is a population of data points we are modeling with lm()
## add random gaussian value to simulate noisy data
performance <- (age ^ coef) + noise

## visualize it
plot(age, performance)

## prep data for lm()
input_data <- data.frame(age = age, gender = gender, performance = performance)

## fit linear model, no curvilinear variables
model1 <- lm(performance ~ age + gender, data = input_data)

## assess model fit
summary(model1)

## fit linear model, curvilinear relationship with age but inaccurate coefficient (0.5 instead of the "true" 0.3)
model2 <- lm(performance ~ I(age^0.5) + gender, data = input_data)

## assess model fit
summary(model2)

## plot model fits
plot(age, performance)
lines(x = age, y = predict(model1), type = 'p', col = 'red') # add model1 predictions
lines(x = age, y = predict(model2), type = 'p', col = 'blue') # add model2 predictions
