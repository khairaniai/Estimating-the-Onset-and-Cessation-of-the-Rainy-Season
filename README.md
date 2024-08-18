<h1>Estimating the Onset and Cessation of the Rainy Season</h1>
<p align="right">
Supervised by: <br/>
<p align="right">
Atiqotun Fitriyah, S.TP., M.Agr., Ph.D
<br/>

<h2>Description</h2>
In this project, I estimated the onset and cessation of the rainy season in the Upper Bengawan Solo sub-watershed across 9 rainfall catchment locations for the period from 2000 to 2018. The estimation method employed was the pentad method introduced by Hamada et al. (2002).
<br />


<h2>Languages and Utilities Used</h2>

- <b>RStudio</b> 
- <b>Excel</b>

<h2>Environments Used </h2>

- <b>Windows 10</b>

<h2>Data</h2>
- The climate data used in this study consists of daily rainfall data obtained from the Ministry of Public Works and Housing (PUPR) of the Bengawan Solo Watershed. Years not listed in the table represent those with missing data that could not be tolerated.

<p align="center">
<img src="https://drive.google.com/uc?id=1FeKO4qD212igKpktj7JurlAwx3LGT0cP"/>
<br />

<h2>Program walk-through:</h2>

<p align="left">
The prediction of the onset of the rainy season using daily rainfall data can be performed using various methods, one of which is the pentad method. This method divides the daily rainfall data within a year into five-day accumulations, resulting in 73 pentads per year (Rahim et al., 2015). The pentad method used can indicate shifts in the onset of the rainy season, which can then be related to the influence of ENSO events, particularly during El Niño and La Niña years (Hamada et al., 2002).
<br/>
  
<h3>Data Management and Calculation</h3>
<p align="left">
Before starting with RStudio, I needed to break down and manually select the data for each site to identify any years for which the onset and cessation could not be determined. I had these data in Excel, with each dataset separated by location.
<br/>
  
<p align="center">
<img src="https://drive.google.com/uc?id=1ikN8fKd6HlNUvIfRdJ7pEiJG2L-JWFUG"/>
<br />
  
<p align="left">
Next, the syntax was developed according to Hamada et al. (2002). Since there was a large amount of Excel data and I did not want to process it manually one by one, I used the 'list.files' function to detect all Excel files that needed to be processed and 'loop' it so it will automatically run every Excel data.
<br/>

<p align="center">
<img src="https://drive.google.com/uc?id=1dZF7gHBMaBQ_a7zGDApPykbkY35GdaeE"/>
<br />

<p align="left">
The calculation to determine the onset and cessation of the rainy season each year was conducted using the pentad method (Hamada et al., 2002). Daily rainfall data for a year were divided into 73 pentads, with each pentad representing the total rainfall over a 5-day period. In this analysis, the first pentad is set to start on August 1st. For leap years, the data for February 29th is added to the pentad covering the period from February 25th to March 1st.

The onset of the rainy season is determined from the first pentad in which the total rainfall over three consecutive pentads exceeds the average annual rainfall. Conversely, the cessation of the rainy season is identified from the first pentad in which the total rainfall over three consecutive pentads falls below the average annual rainfall (Hamada et al., 2002).
<br/>

<p align="center">
<img src="https://drive.google.com/uc?id=1uizTH0NdopTgnEHh6hUcBkspTlUL5FnF"/>
<br />

<p align="left">
Next, I needed to calculate the average rainy season and arrange the output columns. I then created a loop to save the output in either Excel or CSV format inside my desired folder
<br/>

<p align="center">
<img src="https://drive.google.com/uc?id=1ioL6MUc1tRK3Gjq4WH2z8V5YbDMLgYzA"/>
<br />

<h3>Data Visualization</h3>
<p align="left">
To visualize the output, I created bar plots that are saved in the same folder as the Excel files, as the plots are generated within the loop. The bar plots display the start and end dates of the rainy season. These plots are automatically produced for each year and each rainfall catchment.
<br/>

<p align="center">
<img src="https://drive.google.com/uc?id=1pWZ9yZedv9lsDJskD0lig_FfaU4J1oYZ"/>
<br />

<p align="left">
The remaining task is to demonstrate how the outputs can be saved automatically. The path directory is not specified in the syntax because it was set manually before the session started.<br/>

<p align="center">
<img src="https://drive.google.com/uc?id=18LhnBoEyJATec4T3F1PE_bG-8DlXTauG"/>
<br />

<p align="left">
This is the result of the coding, which estimates the onset and cessation of the rainy season in the Upper Bengawan Solo sub-watershed for the years 2000-2018 across 9 rainfall catchment sites. The Excel file provides detailed output, while the graph presents an example from Kupang for the 2010/2011 season to facilitate the analysis.
<br/>

<p align="center">
  <img src="https://drive.google.com/uc?id=19NKxz2FuQN3oafj5fG1FraG1CwrW8t5v" width="40%" />
  <img src="https://drive.google.com/uc?id=1tBEFPTBu9NUrIWTYWNejIp_uyuKzLVdh" width="40%" />
</p>

<p align="left">
Reference: Hamada JL, Yamanaka MD, Matsumoto J, Fukao S, Winarso PA, Sribimawati T. 2002. Spatial and Temporal Variations of the Rainy Season over Indonesia and their Link to ENSO. Journal of the Meteorological Society of Japan. 80: 285-310.<br/>
