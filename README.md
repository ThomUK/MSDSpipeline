# MSDSpipeline
Automatically download, join, and clean the NHS Digital Maternity Services Monthly Statistics data (MSMS), which is derived from the Maternity Services Data Set (MSDS).  When new information is released by NHS Digital easily download and join it with the data already downloaded.  

## Project Description

- Each month, NHS Digital releases [Maternity Services Monthly Statistics](https://digital.nhs.uk/data-and-information/publications/statistical/maternity-services-monthly-statistics), which are derived from the [Maternity Services Data Set](https://digital.nhs.uk/data-and-information/data-collections-and-data-sets/data-sets/maternity-services-data-set).  Multiple CSV and XLSX files are released each month, addressing different parts of the available data.  

- Working with the raw data in this form is time-consuming, and involves downloading the raw files, handling file naming inconsistencies, and joining data from multiple months together to form a clean time-series dataset.  

- This package enables an automated data pipeline by:
  1. Navigating to every monthly "publications" url on the main [MSMS](https://digital.nhs.uk/data-and-information/publications/statistical/maternity-services-monthly-statistics) url, and scraping a list of all .csv and .xlsx files from each monthly page ([example](https://digital.nhs.uk/data-and-information/publications/statistical/maternity-services-monthly-statistics/may-2021) - 296 files as at Sept 2021).
  2. Downloading the .csv and .xlsx data to a local folder (780MB+ of data as at Nov 2021), and sorting into folders according to type.  (eg. data, measures, CQIM, dq, meta, pa, rdt, qual, and "miscellaneous" files).  
  3. Joining mothly files of the same type together, including cleaning and consolidating columns where formats have changed over the 6+ years that the datasets have been released.  
  4. Implementing an example plotting function that quickly demonstrates the volume of data available.

- Potential future work:
  1. Implement getter functions to get details of the available measures contained in each dataframe.  
  2. Implement a shiny dashboard to give a basic window into the data.  Several dashboards using the same source data are already available.  One is the [NHS Digital Maternity Services Dashboard](https://digital.nhs.uk/data-and-information/data-collections-and-data-sets/data-sets/maternity-services-data-set/maternity-services-dashboard).
  3. Generalise to enable downloading of other NHS Digital statistical datasets.  

## How to use

You can install from GitHub using the {remotes} package with:

```r
# install.packages("remotes")
remotes::install_github("https://github.com/ThomUK/MSDSpipeline")

# Load the package
library(MSDSpipeline)
```

Using the package is a two-stage process.  First the data must be downloaded locally.  Next, each of the 3 groups of data contained in MSDS (measures, data, and dq) must be joined together and tidied.  Once tidied the resulting dataframes are ready for use in your analysis.  

1. Download the data.

```r
# Download the data to your local machine, or a destination of your choice.
# This will begin downloading 780MB+ and 300+ files to your machine.
# Files are also sorted into subfolders, according to the information contained in each file.
# The download can be cancelled in RStudio by clicking the red button in the console window.

msds_download_data(destination = "data/msds_download")
```

2. Tidy the data you need.

```r
# Tidy the data you need.  This will combine and tidy data, including consolidating column names, fixing date formats, and altering data and unit columns in a consistent way.
 measures_data <- msds_tidy_measures()
 exp_data <- msds_tidy_data()
 dq_data <- msds_tidy_dq()
 ```

3. Do your analysis.  Some demo plotting functions are included below to illustrate the available data.

```r
# Measure
plot_demo_measure(measures_data, "CQIMPreterm", "RX1")

# Exp-data
plot_demo_data(exp_data, "TotalBabies", "RX1")

# DQ
plot_demo_dq(dq_data, "RX1")
```

## Example plot outputs

#### Measure
![image](https://user-images.githubusercontent.com/10871342/143512658-6ec33cc2-9871-40cd-b7f1-81bbd82d74ee.png)

#### Data
![image](https://user-images.githubusercontent.com/10871342/143512717-b2ff59c9-a0f8-4583-b5fb-87904d48dc6e.png)

#### DQ
![image](https://user-images.githubusercontent.com/10871342/143512748-d6bf56e8-5a5a-4299-8c3c-baa99fe68a34.png)


## Contributing

I am always interested to hear from others working with maternity data.  If you spot a problem, please raise an issue, or make a PR.

## Similar work by others

- [https://github.com/sg-peytrignet/MHSDS-pipeline](https://github.com/sg-peytrignet/MHSDS-pipeline). Similar project for downloading mental health statistics.  
- [https://github.com/HorridTom/nhsAEscraper](https://github.com/HorridTom/nhsAEscraper). Similar project for downloading A&E statistics.  
- [https://github.com/matthewgthomas/NHSWinterSitreps](https://github.com/matthewgthomas/NHSWinterSitreps). Similar project for downloading winter situation reports (sitreps).

## Similar NHS source data relating to Maternity

This source data could be collated with a project similar to this one, but no project currently exists.  

- [NHSEI Friends and Family Test data](https://www.england.nhs.uk/fft/friends-and-family-test-data/). National FFT monthly data.  
