# Baby Names Datasets

Baby name datasets presented in different ways.
I find myself going back to this dataset frequently, and hope it is useful.

Included are estimates of name frequencies among living people in 2014, various slices of birth name statistics since 1910, and gender probabilities.

## Living Citizen Name Estimates

By cross-referencing US-born birth names with the population age distribution for 2014, I estimate the likelihood of encountering a name today.
A number of a caveats here, most significantly that relying on baby names does not factor in the 40 million foreign-born residents in the US.

Included:

- `data/us-living-estimate-names-by-sex-state-year.csv`
- `data/us-living-estimate-names-by-sex.csv`

The rough estimation approach is `P(alive|age)=P(age|alive)*P(alive)/P(age)`, where `P(age|alive)` is the proportion of the current population that is the given age,
	`P(age)` is the proportion of the baby names for year `(2014-age)` out of the full baby name set. `P(alive)` would be the percent of people born since 1910 that
	is still alive, but this is hard to estimate. Instead, I make a guess based on `P(alive|age=1)` being close to 1.0 (infant mortality rates gives us a real
	estimate, 0.9939). This would put the sum US population since 1910 at about 1.05 billion. Regardless, since all this is rough, _it's best to consider the
	ranking more than the actual counts_.

## Gender Likelihood

Guesses for a gender based on a first name, in 2014. Includes birth year so you can filter to population age groups.

`data/us-likelihood-of-gender-by-name-in-2014.csv`

## Most popular US-born baby names since 1910

`raw/us-names-by-gender-state-year.csv` -- the source data, of name counts per gender, year, and state, since 1910.
Source: Social Security Administration

- `data/us-names-by-gender.csv` - most popular names, overall
- `data/us-names-by-year.csv` - most popular names by year
- `data/us-names-by-decade.csv` - most popular names by decade
- `data/us-names-by-state.csv` - most popular names by state, overall

## Other

- `lists/top-us-female-names.csv, lists/top-us-male-names.csv` - Truncated list of most common US names.
- `lists/top-us-[male|female]-names-alive-in-2014.csv` - 1000 most common names in 2014.
- `lists/us-50-gender-neutral-names.csv` - 50 fairly common gender-neutral names in 2014.
- `lists/us-dead-names.csv` - List of names that are dying out among the US-born population.

## Other sources

- `raw/us-population-by-age-and-sex-2014.csv` - Population age distributions. Source: [Census.gov](http://www.census.gov/population/international/data/idb/informationGateway.php)
