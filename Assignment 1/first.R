# options(digits=2)
# EXERCISE 1
data <- read.table("./Ice_cream-1.csv", header = TRUE, sep = ",")

# A)
# NORMALITY ASSUMPTION
mu <- mean(data$video)
hist(data$video)
qqnorm(data$video)
plot(density(data$video))
# 0.97 CI (Answer: l-50.33, u-53.37)
n <- length(data$video)
sd_sample <- sd(data$video)
sem <- sd_sample / sqrt(n)
z_score <- qnorm(1 - 0.015)
margin_error <- z_score * sem
lower_bound <- mu - margin_error
upper_bound <- mu + margin_error
# NUMBER SAMPLES FOR interval length<=3 (Answer: 205.17)
n_min = (z_score^2) * (sd_sample^2) / (1.5^2)

# BOOTSTRAP 97% CONFIDENCE INTERVAL
b_count <- 10000
bootstrap_stat <- numeric(b_count)
for (i in 1:b_count) {
    bootstrap_sample <- sample(data$video, replace=TRUE)
    bootstrap_stat[i] <- mean(bootstrap_sample)
}
hist(bootstrap_stat)
boxplot(bootstrap_stat)

bootstrap_conf_int <- quantile(bootstrap_stat, c(0.015, 0.985))
s <- sum(bootstrap_stat<bootstrap_conf_int[1])
bootstrap_conf_int_check <- c(2*mu-bootstrap_conf_int[2] ,2*mu-bootstrap_conf_int[1])

# B)
t_test_result <- t.test(data$video, mu = 50, alternative = "greater")

# C)
# SIGN TEST
test_median <- 50
larger_median <- sum(data$video > test_median)
sign_result <- binom.test(larger_median, n, conf.level = .97, alternative = 'greater')
# WILCOXON TEST
wilcox_result <- wilcox.test(data$video, mu=50, alternative = 'greater')
# TEST FOR 25% results less than 42
wilcox_25_result <- wilcox.test(data$video, mu=42, alternative = 'less') # not sure if this one is correct
count_lt_42 <- sum(data$video < 42)
# both should be the same tests
sign_25_result <- binom.test(count_lt_42, n, p = 0.25, alternative = "less")
prop_25_result <- prop.test(x = count_lt_42, n = n, p = 0.25, alternative = "less")


# D) *
b2_count <- 10000
b2_stat <- numeric(b2_count)
for (i in 1:b2_count) {
    b2_sample <- sample(data$video, replace=TRUE)
    b2_stat[i] <- min(b2_sample)
}

# E)
vid_female <- data$video[data$female==1]
vid_male <- data$video[data$female==0]

# since we know that sample comes from normal distribution two sample t test is a suitable test to perform
mf_t_result <- t.test(vid_male, vid_female, alternative = 'greater')
# Wlcoxon test compares medians of two samples not means, but it can still give good idea of
# differences between samples
mf_wilcox_result <- wilcox.test(vid_male, vid_female, alternative = 'greater')
# This one is not suitable for our sample, need to justify why
# Kolmogorov test is used to check if two samples come from the same distribution or if one sample comes
# from normal distribution, here our goal is to check if mean of one sample is indeed higher than a mean
# of a second sample.
mf_ks_result <- ks.test(vid_male, vid_female, alternative = 'greater')

# F)
video_puzzle <- data[c('video', 'puzzle')]
cor_result <- round(cor(video_puzzle), 3)
pairs(video_puzzle)
cor_test_result <- cor.test(video_puzzle$video, video_puzzle$puzzle)

# EXERCISE 2
hemo_data <- read.table("./hemoglobin-1.txt", header = TRUE)

n_fishes <- nrow(hemo_data)
methods <- unique(hemo_data$method)
rates <- unique(hemo_data$rate)

combinations <- expand.grid(methods=methods, rates=rates)
block <- xtabs(formula = hemoglobin~method+rate, data = hemo_data)

attach(hemo_data)
par(mfrow=c(1,4))
interaction.plot(method, rate, hemoglobin)
interaction.plot(rate, method, hemoglobin)
anova(lm(hemoglobin~method*rate))

      