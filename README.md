# NHS-MSDS-pipeline
Automatically download, join, and clean the NHS Digital Maternity Services Monthly Statistics data (MSMS), which is derived from the Maternity Services Data Set (MSDS). Newly released monthly files from NHS Digital will automatically be added to your dataset.  

## Project Description

- Each month, NHS Digital releases [Maternity Services Monthly Statistics](https://digital.nhs.uk/data-and-information/publications/statistical/maternity-services-monthly-statistics), which are derived from the [Maternity Services Data Set](https://digital.nhs.uk/data-and-information/data-collections-and-data-sets/data-sets/maternity-services-data-set).  Multiple CSV and XLSX files are released each month, addressing different parts of the available data.  

- Working with the raw data in this form is time-consuming, and involves downloading the raw files, handling file naming inconsistencies, and joining data from multiple months together to form a clean dataset.  

- The code written so far automates this process by:
  1. Automatically navigating to every monthly "publications" url on the main MSMS url.  (72 pages as at Sept 2021)
  2. Scraping a list of all .CSV and .XLSX files from each publications page.  (296 files as at Sept 2021)
  3. Downloading each file to a "data/downloaded" folder (approx 725MB of data as at Sept 2021).  
  4. Separate the different data type files into their own folders (eg. data, measures, CQIM, dq, meta, pa, rdt, qual).  One-off files are sorted into a "miscellaneous" folder).  

- Future code (PRs welcome) **will**:
  1. Join monthly datasets of the same type together to allow time-series analysis. ** in progress **
  2. Give the option to re-export a set of cleaned CSVs.  

- Future code **might**:
  1. Implement a shiny dashboard to give a basic window into the data.  Several dashboards using the same source data are already available.  One is the [NHS Digital Maternity Services Dashboard](https://digital.nhs.uk/data-and-information/data-collections-and-data-sets/data-sets/maternity-services-data-set/maternity-services-dashboard).
  2. Implement this code as a package, with vignette examples and tests.  
  3. Generalise to enable downloading of other NHS Digital statistical datasets.  

## How to use

The entry point for the code is `R/main.R`.  All the configuration options are contained here, and this file calls out to functions where needed.  Just run the functions in this file in sequence, as required.  You will probably not need to modify anything else unless you wish to extend the package (in which case, PRs are welcome! :)  The main functions of interest are listed below:

1. `download_msds_data()`  
The first run of `download_msds_data()` will scrape all 70+ monthly pages, and start downloading all 296+ files (725MB+).  You can cancel the R script to abort this if you need.  
On subsequent runs, if you do not want to check for updated data (re-scraping takes approx 30s), set the argument `check_for_new_data = FALSE`
Similarly, if you are unsure of the status of previously downloaded data files, and you want to force re-downloading of all data you can run with the argument `force_redownload_all = TRUE`.  You might consider deleting all existing raw data before doing this, to be sure that the final downloaded set is error-free.  

2. `sort_data_into_subfolders()`  
This function sorts downloaded files into appopriate subfolders, based on their filename structure.  

3. `get_measures()`, `get_data()`, `get_dq()`
These functions combine the available data for measures, exp-data, and exp-dq respectively into dataframes, and perform any data cleaning required.  Note that `get_dq()` is not yet implemented.  

4. `measure_comparative_plot()`, `data_comparative_plot()`, `dq_comparative_plot()`
These functions return an example visualisation using each of the consolidated datasets.  Note that `dq_comparative_plot()` is not yet implemented.  

## Similar work by others

- [https://github.com/sg-peytrignet/MHSDS-pipeline](https://github.com/sg-peytrignet/MHSDS-pipeline).  Similar project for downloading mental health statistics.  
- [https://github.com/HorridTom/nhsAEscraper](https://github.com/HorridTom/nhsAEscraper). Similar project for downloading A&E statistics.  
