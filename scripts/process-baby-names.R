library("data.table")

# Import name counts by state, sex, year
names <- fread("raw/us-names-by-gender-state-year.csv")

## Save name counts by sex
tmp <- names[, list(count=sum(count)), by=list(sex, name)][order(-count)]
write.csv(tmp, "data/us-names-by-gender.csv", quote=F, row.names=F)

## Smaller data:top 1000 names by sex
tmp <- names[sex=='F', list(count=sum(count)), by=list(sex,name)][order(-count)][1:1000]
write.csv(tmp[,list(name)], "lists/top-us-female-names.csv", quote=F, row.names=F)
tmp <- names[sex=='M', list(count=sum(count)), by=list(sex,name)][order(-count)][1:1000]
write.csv(tmp[,list(name)], "lists/top-us-male-names.csv", quote=F, row.names=F)


## Save name counts by decade
## Sorting by decade is newest-oldest
names[,decade:=year-(year %% 10),]
tmp <- names[, list(count=sum(count)), by=list(sex, name, decade)][order(-decade, -count)]
write.csv(tmp, "data/us-names-by-decade.csv", quote=F, row.names=F)

## Estimate name popularity order in 2014 by accounting for life expectancy
## 
## P(alive|age)=P(age|alive)*P(alive)/P(age)
## where,
## P(age|alive) is the percentage of the 2014 population that is that age
## P(alive) is the current population divided by total American count.
##      This is difficult to estimate (births+unique immigrants, but easier
##      said than done), so currently, is ignored. Thus the COUNTS ARE NOT MEANINGFUL.
## P(age) is the percent of baby names at that age relative to all baby names.

ages <- fread("raw/us-population-by-age-and-sex-2014.csv")
names[, age:=as.factor(2014-year),]
names[age %in% as.character(100:104), age:="100+"]
names[age %in% as.character(95:99), age:="95-99"]
names[age %in% as.character(90:94), age:="90-94"]
names[age %in% as.character(85:89), age:="85-89"]
alive <- names[, list(count.in.names=sum(count)), by=list(sex, age)][,percent.of.names:=100*count.in.names/sum(count.in.names)]
ages <- merge(alive, ages, by=c("sex", "age"))
ages[,modifier:=percent/percent.of.names,]
# Rough P(alive) estimate, assuming most 1 year olds are alive
# In fact, we know how many don't survive by 1 year, 6.17/1000, 
# but this would lend a false sense of precision
ages[, percent.alive:=modifier/modifier[1], by=list(sex)]
tmp <- merge(names, ages[,list(sex, age, percent.alive)], by=c("sex", "age"))
tmp[,alive.count:=round(count*percent.alive)]
names.in.2014 <- tmp[,percent.alive:=NULL]
rm(ages, alive, tmp)
## Save Living estimates per year
write.csv(names.in.2014[alive.count>10, list(state, sex, year, name, alive.count)], "data/us-living-estimate-names-by-sex-state-year.csv", quote=F, row.names=F)

## Save living estimate by gender/name. More useful.
tmp <- names.in.2014[, list(count=sum(alive.count)), by=list(sex, name)][order(-count)]
write.csv(tmp[count > 10], 
          "data/us-living-estimate-names-by-sex.csv", 
          quote=F, row.names=F)
write.csv(tmp[sex=='M'][1:1000][,list(name)], "lists/top-us-male-names-alive-in-2014.csv", quote=F, row.names=F)
write.csv(tmp[sex=='F'][1:1000][,list(name)], "lists/top-us-female-names-alive-in-2014.csv", quote=F, row.names=F)


## Save likelihood of name gender
tmp[,gender.prob:=count/sum(count), by=name]
write.csv(tmp[gender.prob > 0.5 & count > 100][order(-gender.prob, -count)][,list(sex, name, gender.prob)], 
          "data/us-likelihood-of-gender-by-name-in-2014.csv",
          quote=F, row.names=F)

## For fun: gender-neutral names that are fairly common in 2014 in the US
write.csv(tmp[gender.prob > 0.5 & count > 1000][order(gender.prob)][1:50][, list(name, sex, gender.prob)], 
          "lists/us-50-gender-neutral-names.csv", 
          quote=F, row.names=F)

## For fun: Names for US-born people that are all but dead
tmp <- names.in.2014[, list(name.survival=sum(alive.count)/sum(count)), by=list(sex, name)][name.survival > 0][order(name.survival)][1:1000][,name]
write.csv(tmp, "lists/us-dead-names.csv", quote=F, row.names=F)
