use project;

show tables;

select count(*) from healthcare_project ;

describe healthcare_project;

describe hospital_in_india;

USE healthcare_project;

alter table  hospital_in_india rename column ï»¿id to id ;

-- 1.1 Total patient records

SELECT COUNT(*) AS Total_Patient_Records
FROM healthcare_project;

-- 1.2 Total unique patients

SELECT COUNT(DISTINCT Patient_ID) AS Total_Unique_Patients
FROM healthcare_project;


-- 1.3 Total hospitals

SELECT COUNT(*) AS Total_Hospitals
FROM hospital_in_India;


-- 1.4 Duplicate Patient IDs

SELECT
    Patient_ID,
    COUNT(*) AS Record_Count
FROM healthcare_project
GROUP BY Patient_ID
HAVING COUNT(*) > 1;


-- 1.5 Duplicate Hospital IDs

SELECT
    id AS Hospital_ID,
    COUNT(*) AS Record_Count
FROM hospital_in_India
GROUP BY id
HAVING COUNT(*) > 1;


-- 1.6 Missing values in patient data

SELECT
    SUM(Patient_ID IS NULL) AS Missing_Patient_ID,
    SUM(Age IS NULL) AS Missing_Age,
    SUM(Gender IS NULL) AS Missing_Gender,
    SUM(Region IS NULL) AS Missing_Region,
    SUM(Visit_Date IS NULL) AS Missing_Visit_Date,
    SUM(Primary_Diagnosis IS NULL) AS Missing_Diagnosis,
    SUM(BMI IS NULL) AS Missing_BMI
FROM healthcare_project;


-- 2. PATIENT DEMOGRAPHICS

-- 2.1 Patients by Gender

SELECT
    Gender,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY Gender
ORDER BY Patient_Count DESC;


-- 2.2 Average Age by Gender

SELECT
    Gender,
    ROUND(AVG(Age), 2) AS Average_Age,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY Gender
ORDER BY Patient_Count DESC;


-- 2.3 Patients by Age Group

SELECT
   'Age Group' AS Age_Group,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY `Age`
ORDER BY Patient_Count DESC;


-- 2.4 Socioeconomic Status

SELECT
    Socioeconomic_Status,
    COUNT(*) AS Patient_Count,
    ROUND(
        100 * COUNT(*) /
        (SELECT COUNT(*) FROM healthcare_project),
        2
    ) AS Percentage
FROM healthcare_project
GROUP BY Socioeconomic_Status
ORDER BY Patient_Count DESC;


-- 2.5 Patients by Occupation

SELECT
    Occupation,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY Occupation
ORDER BY Patient_Count DESC;


-- 3. GEOGRAPHIC ANALYSIS

-- 3.1 Patients by Region

SELECT
    Region,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY Region
ORDER BY Patient_Count DESC;


-- 3.2 Region-wise Average Age

SELECT
    Region,
    COUNT(*) AS Patient_Count,
    ROUND(AVG(Age), 2) AS Average_Age
FROM healthcare_project
GROUP BY Region
ORDER BY Patient_Count DESC;


-- 3.3 Top Diagnosis in Each Region

SELECT
    Region,
    Primary_Diagnosis,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY Region, Primary_Diagnosis
ORDER BY Region, Patient_Count DESC;


-- 4. DISEASE ANALYSIS

-- 4.1 Most Common Diagnoses

SELECT
    Primary_Diagnosis,
    COUNT(*) AS Patient_Count,
    ROUND(
        100 * COUNT(*) /
        (SELECT COUNT(*) FROM healthcare_project),
        2
    ) AS Percentage
FROM healthcare_project
GROUP BY Primary_Diagnosis
ORDER BY Patient_Count DESC;


-- 4.2 Diagnosis by Gender

SELECT
    Gender,
    Primary_Diagnosis,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY Gender, Primary_Diagnosis
ORDER BY Gender, Patient_Count DESC;


-- 4.3 Average Age by Diagnosis

SELECT
    Primary_Diagnosis,
    COUNT(*) AS Patient_Count,
    ROUND(AVG(Age), 2) AS Average_Age
FROM healthcare_project
GROUP BY Primary_Diagnosis
ORDER BY Average_Age DESC;


-- 4.4 Average BMI by Diagnosis

SELECT
    Primary_Diagnosis,
    ROUND(AVG(BMI), 2) AS Average_BMI,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY Primary_Diagnosis
ORDER BY Average_BMI DESC;


-- 5. HEALTH METRICS

-- 5.1 Overall Health Metrics

SELECT
    ROUND(AVG(BMI), 2) AS Average_BMI,
    ROUND(AVG(Blood_Glucose_mg_dL), 2) AS Average_Glucose,
    ROUND(AVG(`HbA1c_%`), 2) AS Average_HbA1c,
    ROUND(AVG(Total_Cholesterol_mg_dL), 2) AS Average_Cholesterol
FROM healthcare_project;


-- 5.2 Health Metrics by Diagnosis

SELECT
    Primary_Diagnosis,
    ROUND(AVG(BMI), 2) AS Average_BMI,
    ROUND(AVG(Blood_Glucose_mg_dL), 2) AS Average_Glucose,
    ROUND(AVG(`HbA1c_%`), 2) AS Average_HbA1c,
    ROUND(AVG(Total_Cholesterol_mg_dL), 2) AS Average_Cholesterol
FROM healthcare_project
GROUP BY Primary_Diagnosis
ORDER BY Average_Glucose DESC;


-- 6. BMI ANALYSIS

-- 6.1 BMI Category Distribution

SELECT
    'BMI Category ' AS BMI_Category,
    COUNT(*) AS Patient_Count,
    ROUND(
        100 * COUNT(*) /
        (SELECT COUNT(*) FROM healthcare_project),
        2
    ) AS Percentage
FROM healthcare_project
GROUP BY 'BMI Category'
ORDER BY Patient_Count DESC;


-- 6.2 BMI Category by Diagnosis

SELECT
    'BMI Category' AS BMI_Category,
    Primary_Diagnosis,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY 'BMI Category', Primary_Diagnosis
ORDER BY BMI_Category, Patient_Count DESC;


-- 7. TREATMENT ANALYSIS

-- 7.1 Treatment Type Distribution

SELECT
    Treatment_Type,
    COUNT(*) AS Patient_Count,
    ROUND(
        100 * COUNT(*) /
        (SELECT COUNT(*) FROM healthcare_project),
        2
    ) AS Percentage
FROM healthcare_project
GROUP BY Treatment_Type
ORDER BY Patient_Count DESC;


-- 7.2 Treatment Outcomes

SELECT
    Treatment_Outcome,
    COUNT(*) AS Patient_Count,
    ROUND(
        100 * COUNT(*) /
        (SELECT COUNT(*) FROM healthcare_project),
        2
    ) AS Percentage
FROM healthcare_project
GROUP BY Treatment_Outcome
ORDER BY Patient_Count DESC;

-- 7.3 Treatment Type vs Treatment Outcome

SELECT
    Treatment_Type,
    Treatment_Outcome,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY Treatment_Type, Treatment_Outcome
ORDER BY Treatment_Type, Patient_Count DESC;


-- 8. TREATMENT IMPROVEMENT ANALYSIS

-- Improved Rate by Treatment Type

SELECT
    Treatment_Type,
    COUNT(*) AS Total_Patients,
    SUM(
        Treatment_Outcome = 'Improved'
    ) AS Improved_Patients,
    ROUND(
        100 * SUM(
            Treatment_Outcome = 'Improved'
        ) / COUNT(*),
        2
    ) AS Improvement_Rate
FROM healthcare_project
GROUP BY Treatment_Type
ORDER BY Improvement_Rate DESC;


-- 9. POSITIVE OUTCOME ANALYSIS

-- Improved + Recovered

SELECT
    Treatment_Type,
    COUNT(*) AS Total_Patients,
    SUM(
        Treatment_Outcome IN ('Improved', 'Recovered')
    ) AS Positive_Outcomes,
    ROUND(
        100 * SUM(
            Treatment_Outcome IN ('Improved', 'Recovered')
        ) / COUNT(*),
        2
    ) AS Positive_Outcome_Rate
FROM healthcare_project
GROUP BY Treatment_Type
ORDER BY Positive_Outcome_Rate DESC;


-- 10. HOSPITAL TYPE ANALYSIS

-- 10.1 Government vs Private

SELECT
    Hospital_Type,
    COUNT(*) AS Patient_Count,
    ROUND(
        100 * COUNT(*) /
        (SELECT COUNT(*) FROM healthcare_project),
        2
    ) AS Percentage
FROM healthcare_project
GROUP BY Hospital_Type
ORDER BY Patient_Count DESC;


-- 10.2 Hospital Type vs Treatment Outcome

SELECT
    Hospital_Type,
    Treatment_Outcome,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY Hospital_Type, Treatment_Outcome
ORDER BY Hospital_Type, Patient_Count DESC;

-- 10.3 Improvement Rate by Hospital Type

SELECT
    Hospital_Type,
    COUNT(*) AS Total_Patients,
    SUM(
        Treatment_Outcome = 'Improved'
    ) AS Improved_Patients,
    ROUND(
        100 * SUM(
            Treatment_Outcome = 'Improved'
        ) / COUNT(*),
        2
    ) AS Improvement_Rate
FROM healthcare_project
GROUP BY Hospital_Type
ORDER BY Improvement_Rate DESC;


-- 11. INSURANCE ANALYSIS

-- 11.1 Insurance Status

SELECT
    'Insurance Status ' AS Insurance_Status,
    COUNT(*) AS Patient_Count,
    ROUND(
        100 * COUNT(*) /
        (SELECT COUNT(*) FROM healthcare_project),
        2
    ) AS Percentage
FROM healthcare_project
GROUP BY 'Insurance Status'
ORDER BY Patient_Count DESC;


-- 11.2 Insurance Covered TRUE/FALSE

SELECT
    Insurance_Covered,
    COUNT(*) AS Patient_Count,
    ROUND(
        100 * COUNT(*) /
        (SELECT COUNT(*) FROM healthcare_project),
        2
    ) AS Percentage
FROM healthcare_project
GROUP BY Insurance_Covered;


-- 11.3 Insurance vs Treatment Outcome

SELECT
    Insurance_Covered,
    Treatment_Outcome,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY Insurance_Covered, Treatment_Outcome
ORDER BY Insurance_Covered, Patient_Count DESC;


-- 12. TIME ANALYSIS

-- 12.1 Patients by Year

SELECT
    Year,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY Year
ORDER BY Year;


-- 12.2 Patients by Month Number

SELECT
    'Month' AS Month_Number,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY 'Month'
ORDER BY Month_Number;


-- 12.3 Patients by Month Name

SELECT
    'Month' AS Month_Number,
    'Month Name' AS Month_Name,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY 'Month', 'Month Name'
ORDER BY Month_Number;


-- 12.4 Year + Month Trend

SELECT
    Year,
    'Month' AS Month_Number,
    'Month Name' AS Month_Name,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY Year, 'Month ', 'Month Name '
ORDER BY Year, Month_Number;


-- 13. IMAGING ANALYSIS

-- 13.1 Imaging Type Distribution

SELECT
    Imaging_Type,
    COUNT(*) AS Patient_Count,
    ROUND(
        100 * COUNT(*) /
        (SELECT COUNT(*) FROM healthcare_project),
        2
    ) AS Percentage
FROM healthcare_project
GROUP BY Imaging_Type
ORDER BY Patient_Count DESC;


-- 13.2 Imaging Type by Diagnosis

SELECT
    Imaging_Type,
    Primary_Diagnosis,
    COUNT(*) AS Patient_Count
FROM healthcare_project
GROUP BY Imaging_Type, Primary_Diagnosis
ORDER BY Imaging_Type, Patient_Count DESC;


-- 14. HOSPITAL DATASET ANALYSIS

-- 14.1 Hospitals by State

SELECT
    State,
    COUNT(*) AS Hospital_Count
FROM hospital_in_India
GROUP BY State
ORDER BY Hospital_Count DESC;


-- 14.2 Hospitals by City

SELECT
    City,
    COUNT(*) AS Hospital_Count
FROM hospital_in_India
GROUP BY City
ORDER BY Hospital_Count DESC;


-- 14.3 Average Rating by State

SELECT
    State,
    COUNT(*) AS Hospital_Count,
    ROUND(AVG(Rating), 2) AS Average_Rating
FROM hospital_in_India
GROUP BY State
HAVING COUNT(*) >= 5
ORDER BY Average_Rating DESC;


-- 14.4 Average Hospital Density by State

SELECT
    State,
    COUNT(*) AS Hospital_Count,
    ROUND(AVG(Density), 2) AS Average_Density
FROM hospital_in_India
GROUP BY State
ORDER BY Average_Density DESC;


-- 14.5 Top Rated Hospitals

SELECT
    id AS Hospital_ID,
    City,
    State,
    District,
    Rating,
    `Number of Reviews` AS Number_of_Reviews
FROM hospital_in_India
ORDER BY Rating DESC, `Number of Reviews` DESC
LIMIT 10;


-- 14.6 Hospitals with Highest Review Volume

SELECT
    id AS Hospital_ID,
    City,
    State,
    District,
    Rating,
    `Number of Reviews` AS Number_of_Reviews
FROM hospital_in_India
ORDER BY `Number of Reviews` DESC
LIMIT 10;


-- 15. HOSPITAL QUALITY ANALYSIS

-- High-rated hospitals with significant review volume

SELECT
    id AS Hospital_ID,
    City,
    State,
    Rating,
    `Number of Reviews` AS Number_of_Reviews
FROM hospital_in_India
WHERE Rating >= 4.5
  AND `Number of Reviews` >= 1000
ORDER BY Rating DESC, `Number of Reviews` DESC;


-- 16. ADVANCED SQL - TOP 3 REGIONS BY PATIENT COUNT

WITH Region_Patients AS (
    SELECT
        Region,
        COUNT(*) AS Patient_Count
    FROM healthcare_project
    GROUP BY Region),
Ranked_Regions AS (
SELECT
        Region,
        Patient_Count,
RANK() OVER (
            ORDER BY Patient_Count DESC
        ) AS Region_Rank
FROM Region_Patients)
SELECT
    Region,
    Patient_Count,
    Region_Rank
FROM Ranked_Regions
WHERE Region_Rank <= 3
ORDER BY Region_Rank;


-- 17. ADVANCED SQL - TOP DIAGNOSIS IN EACH REGION

WITH Diagnosis_By_Region AS (
    SELECT
        Region,
        Primary_Diagnosis,
        COUNT(*) AS Patient_Count
    FROM healthcare_project
    GROUP BY Region, Primary_Diagnosis),
Ranked_Diagnoses AS (
SELECT
        Region,
        Primary_Diagnosis,
        Patient_Count,
        RANK() OVER (
            PARTITION BY Region
            ORDER BY Patient_Count DESC
        ) AS Diagnosis_Rank
    FROM Diagnosis_By_Region)
SELECT
    Region,
    Primary_Diagnosis,
    Patient_Count
FROM Ranked_Diagnoses
WHERE Diagnosis_Rank = 1
ORDER BY Region;


-- 18. FINAL PROJECT KPI SUMMARY

SELECT
    COUNT(*) AS Total_Patient_Records,
    COUNT(DISTINCT Patient_ID) AS Unique_Patients,
    ROUND(AVG(Age), 2) AS Average_Age,
    ROUND(AVG(BMI), 2) AS Average_BMI,
    ROUND(
        AVG(Blood_Glucose_mg_dL), 2
    ) AS Average_Glucose,
    ROUND(
        AVG(`HbA1c_%`), 2
    ) AS Average_HbA1c,
    ROUND(
        AVG(Total_Cholesterol_mg_dL), 2
    ) AS Average_Cholesterol,
    SUM(
        Treatment_Outcome = 'Improved'
    ) AS Improved_Patients,
    SUM(
        Treatment_Outcome = 'Recovered'
    ) AS Recovered_Patients,
    ROUND(
        100 * SUM(
            Treatment_Outcome IN ('Improved', 'Recovered')
        ) / COUNT(*),
        2
    ) AS Positive_Outcome_Rate,
    SUM(
        Insurance_Covered = TRUE
    ) AS Insured_Patients,
    ROUND(
        100 * SUM(
            Insurance_Covered = TRUE
        ) / COUNT(*),
        2
    ) AS Insurance_Coverage_Percentage
FROM healthcare_project;


-- 20. FINAL HOSPITAL KPI SUMMARY

SELECT
    COUNT(*) AS Total_Hospitals,
    COUNT(DISTINCT State) AS Total_States,
    COUNT(DISTINCT City) AS Total_Cities,
    ROUND(AVG(Rating), 2) AS Average_Rating,
    ROUND(AVG(Density), 2) AS Average_Density,
    SUM(`Number of Reviews`) AS Total_Reviews
FROM hospital_in_India;

