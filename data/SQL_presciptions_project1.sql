-- -- --1)
-- -- SELECT*
-- -- FROM prescription;

-- SELECT prescriber.npi, SUM(prescription.total_claim_count) AS total_number_of_claims
-- FROM prescriber
-- LEFT JOIN prescription
-- USING(npi)
-- WHERE prescription.total_claim_count IS NOT NULL
-- GROUP BY prescriber.npi
-- ORDER BY total_number_of_claims DESC;

 --answer 1a) npi 1881634483 sum_total_claims 99707
 --1b)
-- -- SELECT SUM(total_claim_count) AS total_number_of_claims ,nppes_provider_first_name || ' ' || nppes_provider_last_org_name AS prescriber,
-- -- 		specialty_description	
-- -- 	   FROM prescriber
-- -- 	   LEFT JOIN prescription
-- -- 	   USING (npi)
-- -- 	   WHERE prescription.total_claim_count IS NOT NULL
-- -- 	   GROUP BY prescriber.npi, nppes_provider_first_name, nppes_provider_last_org_name,
-- -- 		specialty_description
-- -- 	   ORDER BY total_number_of_claims DESC;
	   

-- -- --2)   a. Which specialty had the most total number of claims (totaled over all drugs)?
-- -- SELECT prescriber.specialty_description, SUM prescription_total_claim_coount AS total_claim_count
-- -- FROM prescriber
-- -- LEFT JOIN precription USING(npi)
-- -- WHERE prescription.total_calim_count IS NOT NULL
-- -- GROUP BY sprescriber.specialty_description
-- -- ORDER BY total_claim_count DESC;


-- -- SELECT DISTINCT specialty_description, SUM(total_claim_count) AS sum_total_claims
-- -- FROM prescription
-- -- INNER JOIN prescriber
-- -- USING (npi)
-- -- GROUP BY specialty_description
-- -- ORDER BY sum_total_claims DESC;

-- -- --2b) Which specialty had the most total number of claims for opioids? Nurse Practitioner, 900845
-- -- SELECT DISTINCT specialty_description, SUM(total_claim_count) AS sum_total_claims,
-- -- 	drug.opioid_drug_flag
-- -- FROM prescription
-- -- INNER JOIN prescriber
-- -- USING (npi)
-- -- JOIN drug
-- -- ON prescription.drug_name=drug.drug_name
-- -- WHERE drug.opioid_drug_flag = 'Y'
-- -- GROUP BY specialty_description, opioid_drug_flag
-- -- ORDER BY sum_total_claims DESC;

-- -- --2c) are there any specialties in the presciber table that dont have associated prescr
-- -- --in the prescription table 15
-- -- SELECT DISTINCT specialty_description
-- -- FROM prescriber
-- -- EXCEPT
-- -- SELECT DISTINCT specialty_description
-- -- FROM prescriber
-- -- WHERE npi IN (SELECT DISTINCT npi FROM prescription);

-- -- --3)a. Which drug (generic_name) had the highest total drug cost? PIRFENIDONE   
-- -- SELECT DISTINCT(generic_name), MAX(total_drug_cost::money) AS tdc  $2829174,30
-- -- FROM prescription
-- -- INNER JOIN drug
-- -- USING (drug_name)
-- -- GROUP BY generic_name
-- -- ORDER BY tdc DESC
-- -- LIMIT 1;

-- -- --3b)Which drug (generic_name) has the hightest total cost per day?

-- -- SELECT drug.generic_name, ROUND(SUM(total_day_supply)/NULLIF(SUM(total_drug_cost),0),2) AS cost_per_day
-- -- FROM prescription
-- -- INNER JOIN drug
-- -- ON prescription.drug_name=drug.drug_name
-- -- GROUP BY drug.generic_name
-- -- ORDER BY cost_per_day DESC
-- -- LIMIT 1;
-- -- --answer: Follic Acid $19.59

-- -- --4a)

-- -- SELECT drug_name,
-- --  CASE WHEN opioid_drug_flag = 'Y' then 'opioid'
-- --       WHEN antibiotic_drug_flag = 'Y' then 'antibiotic'
-- -- 	  ELSE 'neither' END AS drug_type
-- -- FROM drug;

-- --  --4b)
-- --  SELECT drug_type,
-- --  SUM(total_drug_cost::money) AS sum_total_drug_cost
-- --  FROM 
-- -- (SELECT drug_name,
-- --  CASE WHEN opioid_drug_flag = 'Y' then 'opioid'
-- --       WHEN antibiotic_drug_flag = 'Y' then 'antibiotic'
-- -- 	  ELSE 'neither' END AS drug_type	  
-- --       FROM drug)
-- -- INNER JOIN prescription
-- -- USING (drug_name)
-- -- WHERE drug_type IN('opioid','antibiotic')
-- -- GROUP BY drug_type
-- -- ORDER BY sum_total_drug_cost DESC;


-- --5a)
-- --   How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information
-- -- for all states not just TN
-- SELECT COUNT(fipscounty) AS amt_of_cbsa_TN, 
-- state 
-- FROM cbsa
-- INNER JOIN fips_county
-- USING(fipscounty)
-- WHERE state = 'TN'
-- GROUP BY state;
-- --5a) 42 cbsa

-- --5b) Which cbsa has the largest combined population? Which has the smallest? Report the CBSA 
-- --       name and total population
-- SELECT *
-- FROM fips_county;

-- SELECT cbsaname,SUM(population) as total_population, MAX(population)
-- 	AS max_population, MIN(population) AS min_population
-- FROM cbsa
-- INNER JOIN population
-- USING (fipscounty)
-- GROUP BY cbsaname
-- ORDER BY total_population;
-- --5b) Nashville largest population 1830410, Morristown,TN smallest population 1 16,352

-- --5c)What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

-- (SELECT county, SUM(population) AS total_pop
-- FROM fips_county
-- INNER JOIN population USING (fipscounty)
-- GROUP BY county)
-- EXCEPT
-- (SELECT county, SUM(population) AS total_pop
-- FROM fips_county
-- INNER JOIN population USING (fipscounty)
-- INNER JOIN cbsa USING (fipscounty)
-- GROUP BY  county)
-- ORDER BY total_pop DESC;
-- --5c SEVIER 95523

-- --6a)
-- SELECT drug_name,total_claim_count
-- FROM prescription
-- WHERE total_claim_count>=3000;

-- --6b)
-- SELECT total_claim_count, drug_name,
-- 	CASE WHEN opioid_drug_flag = 'Y' then 'opioid'
-- 		ELSE 'not opioid'
-- 		END AS drug_type
-- FROM prescription 
-- INNER JOIN drug
-- USING (drug_name)
-- WHERE total_claim_count>=3000;


-- --6c)
-- SELECT nppes_provider_last_org_name || ' ' || nppes_provider_first_name AS provider, total_claim_count, drug.drug_name,
-- 	CASE WHEN drug.opioid_drug_flag = 'Y' then 'opioid'
-- 		ELSE 'not opioid'
-- 		END AS drug_type
-- FROM prescription 
-- INNER JOIN drug USING (drug_name)
-- INNER JOIN prescriber USING (npi) 
-- WHERE total_claim_count>=3000
-- ORDER BY total_claim_count DESC;
-- --7a)
-- SELECT *
-- FROM prescriber;

-- SELECT drug_name, opioid_drug_flag
-- FROM drug
-- WHERE opioid_drug_flag = 'Y';
-- --7a)
-- SELECT npi, drug_name, nppes_provider_city, specialty_description, opioid_drug_flag
-- FROM prescriber
-- CROSS JOIN drug
-- WHERE nppes_provider_city='NASHVILLE' and opioid_drug_flag='Y' 
-- and specialty_description='Pain Management';

-- --7b)

-- SELECT drug.drug_name, npi, prescriber.nppes_provider_last_org_name || ' ' || prescriber.nppes_provider_first_name
-- 	AS provider,
-- 	-- SUM(total_claim_count) AS sum_total_claims
-- FROM prescriber
-- CROSS JOIN drug
-- INNER JOIN prescription USING(npi)
-- WHERE nppes_provider_city='NASHVILLE' and opioid_drug_flag='Y' and specialty_description=
-- 		'Pain Management'
-- 		GROUP BY drug.drug_name, npi, provider
-- ORDER BY sum_total_claims DESC;

--7c)
-- SELECT drug.drug_name, npi,
-- 		COALESCE(SUM(total_claim_count),0) AS total_claim_count
-- FROM prescriber
-- CROSS JOIN drug
-- INNER JOIN prescription USING(npi)
-- WHERE nppes_provider_city='NASHVILLE' and opioid_drug_flag='Y' and specialty_description=
-- 		'Pain Management'
-- 		GROUP BY npi, drug.drug_name
--         ORDER BY total_claim_count desc;
		















	   