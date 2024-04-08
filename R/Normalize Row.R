data <- data.frame(column1 = c(2, 2, 4),
                   column2 = c(2, 2, 4),
                   column3 = c(4, 4, 4))

data

data_percent <- t(apply(data, 1, function(x) x / sum(x)))

data_percent
