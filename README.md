# Chicago Traffic Crash Trends & Insights for the CTA
Author: [Jared Peters](https://www.linkedin.com/in/jared-peters-728671153/)
<br><br>
Full project in the Source Code [here](https://github.com/petersjared5/Chicago-Transit-Authority-Case-Study/blob/main/Code.R)

Project presentation [here](https://github.com/petersjared5/Chicago-Transit-Authority-Case-Study/blob/main/Slide%20Deck.pdf)


## Overview
In this case study, I analyzed Chicago Transit Authority (CTA) traffic crash data to identify patterns in crash occurrences and highlight operational risks for the CTA. The dataset, provided by the Chicago Police Department, included over 920,000 crash records ([CDOT, 2024](https://data.cityofchicago.org/Transportation/Traffic-Crashes-Crashes/85ca-t3if/data_preview)). My analysis focused on understanding when and where crashes are most likely to occur, as well as identifying key contributing factors. Using R for data cleaning, transformation, and visualization, I summarized trends in crash times, locations, road conditions, weather, lighting, crash types, and contributing causes. The final product included a clear, visually engaging slide deck, highlighting actionable insights for CTA’s performance management teams.

<img src="https://www.redfin.com/blog/wp-content/uploads/2024/04/shutterstock_1537833677-1024x683.jpg" width="1280" height="640">

## Key Crash Statistics: Scope of Analysis
### Important Statistics
  - Chicago Police Traffic Crash Dataset
    - 924,030 total crashes in dataset
   - Peak Crash Times
     - Morning Peak: 8AM (49,141 crashes)
     - Evening Peak: 5 PM (71,538 crashes) (Rush hours have the highest crash volumes)
   - Common Crash Causes
     - **Top Cause: Failing to yield right-of-way**
     - Most Frequent Crash Type: Rear-end collisions (203,729 crashes)
   - Impact of Road
     - Most crashes occur in dry conditions (680,232), but **wet/icy/snowy roads increase risk**
     - Speed limit 30 MPH has the highest number of crashes (680,749)
     
### Executive Summary
The primary objective of this analysis is to evaluate how traffic crashes impact Chicago Transit Authority (CTA) operations and explore potential policy interventions. Specifically, the goals are to:

  1. Identify Where & When Crashes Happen:

     - Pinpoint high-risk locations across Chicago where crashes are most concentrated, with special attention to areas affecting CTA services.

     - Analyze crash frequency patterns to determine peak crash hours, particularly during key commuting times, to understand when CTA operations may be most disrupted.

  2. Understand Why Crashes Happen & Inform Policy:

      - Examine the most common types and contributing causes of crashes to provide actionable insights.

     - Evaluate the potential policy implications, including the feasibility of strategies like congestion pricing in The Loop, and how such policies could influence both traffic flow and
       CTA efficiency.

## **Overview of Data Preparation Steps**

Given the large volume and complexity of the Chicago crash dataset, careful preparation was essential to ensure reliable analysis and actionable insights. Key steps included:

  1. Data Inspection & Cleaning: Reviewed the dataset structure to understand variable types, checked for missing or non-informative values (e.g., 'UNKNOWN', 'OTHER'), and filtered them
     out to maintain data quality.

  2. Standardization & Formatting: Reformatted relevant variables (e.g., converting crash hour to numeric, reformatting AM/PM labels) to ensure consistency and readability across analysis.

  3. Categorical Value Filtering: Removed ambiguous entries such as “UNABLE TO DETERMINE” and “NOT APPLICABLE” from key columns (e.g., contributing causes, roadway conditions) to focus on
     meaningful categories.

  4. Geographical Filtering: Applied latitude/longitude filters to focus exclusively on the Chicago area, ensuring spatial accuracy in mapping and hotspot analysis.

  5. Feature Aggregation: Grouped crash records by key factors (e.g., crash type, street name, lighting condition) and summarized them to identify top occurrences, reducing noise and
     highlighting trends.

## **Data Preparation**
  For transparency and reproducibility, the entire data cleaning and preparation process was conducted within my R script file. The dataset provided by the Chicago Police Department’s Traffic Crashes database required several cleaning and filtering steps to ensure accuracy and focus the analysis. Key steps included:

  - Filtering out non-informative values (e.g., "UNKNOWN", "OTHER", "NOT APPLICABLE") across multiple variables to reduce noise.

  - Converting and formatting key variables like crash hour, lighting conditions, and roadway surface conditions to ensure consistency and readability.

  - Aggregating crash data to identify top locations, conditions, and contributing causes with the highest crash frequencies.

  - Removing invalid entries such as missing street names and zero or negative speed limits.

These steps ensured that the data was ready for insightful visualizations and reliable statistical analysis. Full details of the data preparation are embedded and well-documented within the R script used for this case exercise.

## **Final Cleaned Dataframe Overview**

  - Cleaned dataset derived from the original Chicago Police Department – Traffic Crashes dataset

  - Removed non-informative or redundant columns (e.g., entries marked "UNKNOWN", "NOT APPLICABLE")

  - Resolved data quality issues including missing values and inconsistent formatting

  - Focused on key variables relevant to crash frequency and conditions (e.g., crash time, location, road surface, lighting, weather, contributing causes)

  - Final dataset contains 924,030 crash records across 48 variables

  - Cleaned and ready for exploratory analysis, visualization, and summary statistics generation

## Exploratory Data Analysis
To understand patterns and potential risk factors influencing traffic crashes better, I conducted exploratory analysis across multiple key dimensions. This included examining when and where crashes most frequently occur, the types of crashes reported, and environmental factors such as lighting, road surface, weather conditions, and speed limits. By breaking down the data across these categories, I was able to identify recurring trends and high-risk scenarios that could impact CTA operations. The insights gathered provide a data-driven foundation for evaluating crash hotspots and shaping policy recommendations to improve traffic safety and reduce disruptions.

## Key findings
#### Section 1. Where & When Crashes Happen: Analyzing where and when crashes happen and their impact on CTA operations

**High-Risk Crash Locations**: 

Most crashes occur near the Loop or Streeterville, with six out of ten hotspots on Lake Shore Dr. (Outer Drive). 

Other hotspots occur on key arterial roads (e.g., Western Ave, Pulaski Rd, Cicero Ave). 

![Chicago Traffic Crash Hotspots Map](https://github.com/petersjared5/Chicago-Transit-Authority-Case-Study/blob/main/images/Chicago%20Traffic%20Crash%20Hotspots%20Map.png)


**Peak Crash Hours**

Morning (8 AM) and evening rush hours (3-5 PM) see the most crashes. 

This increase in crashes during those hours contributes to bus delays & increased commute times for riders.

![Traffic Crashes by Hour of the Day](https://github.com/petersjared5/Chicago-Transit-Authority-Case-Study/blob/main/images/Traffic%20Crashes%20by%20Hour%20of%20the%20Day.png)

#### Section 2. Why Crashes Happen & Policy Implications: Analyzing the causes and suggesting potential CTA-focused solutions

**Most Common Speed Limit Crashes** 

30 MPH zones have the most crashes, covering key CTA routes

![Top 5 Most Common Crash Types](https://github.com/petersjared5/Chicago-Transit-Authority-Case-Study/blob/main/images/Top%205%20Most%20Common%20Crash%20Types.png)

**Most Common Crash Types**: 

Rear ends, sideswipes, and turning were nearly 500k of common crashes. Bus stops, turning lanes, and high-traffic intersections contribute to these crashes.

These are indicative of congestion-related incidents.

![Top 5 Speed Limits with the Most Crashes](https://github.com/petersjared5/Chicago-Transit-Authority-Case-Study/blob/main/images/Top%205%20Speed%20Limits%20with%20the%20Most%20Crashes.png)

**Most Common Roadway Surface Conditions During Crashes**
  
Wintry weather causes many crashes. 

This is when CTA services are the most needed.

![Top 5 Weather Conditions During Crashes](https://github.com/petersjared5/Chicago-Transit-Authority-Case-Study/blob/main/images/Top%205%20Weather%20Conditions%20During%20Crashes.png)

#### Section 3. Policy Recommendation – Congestion Pricing in the Loop: Proposing a data-driven policy solution relevant to CTA & city planning

**The Case for Congestion Pricing**
  1. High crash rates near the Loop during peak hours.
     - Crash hotspots are centered near the Loop or other near by areas.
  2. Increased CTA bus delays due to congestion during peak hours.
     - Crashes peak during morning and evening rushhours.

**Need for Congestion Pricing:**
  - Fewer private vehicles → reduced crashes.
  - Improved bus travel times & reliability.

**How Congestion Pricing Would Work** 
  1. Vehicles pay a fee to enter the Loop during peak hours
     - Price to be set based on CTA transit rates.
  2. CTA Improvement
     - Faster bus routes through additionally bus lanes and more frequent “L” service
  3. Reduce Car Traﬃc
     - Crash frequency go down
     - Fewer crashes at key intersections

<img src="https://hips.hearstapps.com/hmg-prod/images/nyc-congestion-pricing-getty-images-677bf68757178.jpg?crop=0.8893229166666666xw:1xh;center,top&resize=1200:*" width="1280" height="640">

Similar to Lower Manhattan's congestion pricing system.

### Conclusion. Key Takeaways & Next Steps for CTA Consideration: How the CTA can mitigate crash risks and improve mobility in high-impact areas
**Key Takeaways** 
  1. High crash density in the Loop & major corridors.
  2. Rush hour crashes disrupt CTA services.
  3. Congestion pricing can ease traffic & improve transit reliability.

**Next Steps for CTA Consideration** 
  1. Partner with CDOT to assess congestion pricing impact & feasibility.
  2. Implement bus priority measures in high-crash areas.
  3. Develop targeted crash reduction strategies for key transit routes.

### Final Thoughts
**By leveraging congestion pricing and data-driven transit improvements, CTA can enhance efficiency and safety for Chicago’s commuters.**

### Thank You

## Additional Information

View the full project in my GitHub [here](https://github.com/petersjared5/Chicago-Transit-Authority-Case-Study). 
<br><br>
View the project presentation [here](https://github.com/petersjared5/Chicago-Transit-Authority-Case-Study/blob/main/Slide%20Deck.pdf)


Contact Jared Peters at [petersjared5@gmail.com](mailto:petersjared5@gmail.com) with additional questions.

## Repository Structure

```
Chicago-Transit-Authority-Case-Study/
├── Code.R                              # Main R script used for data cleaning, analysis, and visualization
├── Slide Deck.pdf                      # Final presentation summarizing key findings and recommendations
├── README.md                           # Overview of the project, objectives, methods, and key takeaways
├── images/                             # Directory containing all output visuals used in the slide deck
│   ├── Traffic Crashes by Hour of the Day.png
│   ├── Chicago Traffic Crash Hotspots Map.png
│   ├── Top 5 Lighting Conditions During Crashes.png
│   ├── Top 5 Most Common Crash Types.png
│   ├── Top 5 Primary Contributing Causes of Crashes.png
│   ├── Top 5 Roadway Surface Conditions During Crashes.png
│   ├── Top 5 Speed Limits with the Most Crashes.png
│   ├── Top 5 Streets with the Most Crashes.png
│   └── Top 5 Weather Conditions During Crashes.png
└── .DS_Store                           # System file (can be ignored or removed)
```
