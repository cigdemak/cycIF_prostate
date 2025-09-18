# Spatial variability and sample size analysis
Code accompanying the manuscript "Multiplex imaging of localized prostate tumors reveals altered spatial organization of AR-positive cells in the microenvironment" by Ak et al., published in _iScience_. 

## Overview
This repository contains code and documentation related to the analysis of spatial variability and sample size effects in prostate cancer progression.  We performed several rigorous statistical analyses to ensure the sufficient spatial power and consistency of our results: (1) creating in silico tissues (ISTs) to augment sample size and to address sample variability, (2) leaving one patient out analysis to assess the impact of patient-to-patient variability on the results, (3) subsampling analysis to estimate the variability in our results and showed the stability of our findings, (4) permutation test to show further benchmarking and robustness of our findings.  All these different tests are different ways to address statistical power to determine the significance of the results.


## Methodology
Our approach included the following key steps:

  **1. Neighborhood Identification_10tiles.ipynb** performs Cellular Neighborhood (CN) analysis on ISTs derived from each patient sample. To tackle spatial variability and ensure a robust analysis, we adopted the approach of dividing each tumor sample into multiple regions. The subsequent step involved performing cellular neighborhood analysis on these regions. To address the effects of spatial variability and sample size, we divided each tumor sample into multiple regions, then performed cellular neighborhood analysis on these multiple regions, and showed the consistency of our results.

  **2. Neighborhood Identification_one_leave_out.ipynb** performs an exclusion analysis. Leave-one-patient-out analysis helps in understanding how sensitive the results are to the presence or absence of specific patients. It is particularly useful when dealing with a small dataset and can provide insights into the robustness and stability of the findings. It also allows us to assess the impact of patient-to-patient variability on the results, which directly addresses the patient-to-patient differences. 

  For each round of analysis, we excluded one patient's data from the imaging dataset. Then, we performed CN analysis, calculated the CN frequencies for each patient, and compared AR+ (androgen receptor positive) CN frequency between Tumor-adjacent normal (TAN) tissue and tumors. We repeated this process iteratively for each patient, leaving one out at a time. Hence, we performed the analysis 13 times, each time excluding a different patient's data. We evaluated the consistency of our results across the iterations. 

  **3. Neighborhood Identification_permutation_test.ipynb** performs permutation tests in two ways:
  - **3.1.	t-test with permutations.** We used scipy.stats.ttest_ind() function with exact permutations; permutations = np.inf during CN frequency comparison defined in Schürch et al 2020. This permutes the patient’s grade assignment while comparing CN frequencies with t-tests. We also separately tested equal variance across grades verified using Bartlett's test. 

  - **3.2.	Permutation test with sample mean difference statistic.** We performed a permutation test using scipy.stats.permutation_test(). We defined the difference between the sample means as a test statistic to be used in scipy.stats.permutation_test(). We performed an exact test, n_resamples=np.inf. 

  **4. Neighborhood Identification_random sampling.ipynb, Neighborhood Identification_random sampling50.ipynb, Neighborhood Identification_random sampling90.ipynb:**
  
These notebooks perform subsampling to validate that our sample size was sufficient to detect clinically relevant and statistically robust differences in our AR+ CN conclusion. First, 100 iterations of subsampling with different seeds were performed at independent values (sub-sampled from each grade data with a given sub-sampling percentage). Then we run the CN algorithm by Nolan Lab on each sub-sampled data to identify the AR+ CNs. We next tested whether the mean AR+ CN frequency was significantly different between TAN and tumors (G3 and G4) within each iteration of the sampled data. Lastly, we analyzed the distribution of p-values for the mean AR+ CN frequency differences between TAN vs tumors for each of these 100 iterations.

  **5. Neighborhood Identification_random sampling99_perm.ipynb** performs a permutation test on the subsampled data (99% of the data).
   
## Results
The findings highlight that the same neighborhoods were identified in all the experiments. Notably, the AR+ neighborhood frequency was significantly different in TAN vs G3 tumors and TAN vs G4 tumors. 

## Usage
NeighborhoodIdentification folder contains code for identifying cellular neighborhoods and statistical tests on them as defined above. Neighborhood Identification code was originally published by Schurch et al. Cell 2020. The utilized scripts have minimal dependencies, including the following packages with specified versions: statsmodels (0.11.1), numpy (1.18.1), pandas (1.0.1), jupyter (1.0.0), seaborn (0.9.0), scikit-learn (0.22.1).

InSilicoTissues folder contains code for creating in silico tissues for whole slide images and the point plots of cells showing ISTs on tissues.

data folder contains single-cell data with required annotations. To replicate or further explore our analysis, refer to the Figshare+ data link provided in the manuscript.

## Citation
If you find this work helpful in your research, please cite our paper: Ak, Cigdem et al. “Multiplex imaging of localized prostate tumors reveals altered spatial organization of AR-positive cells in the microenvironment.” _iScience_ vol. 27,9 110668. 3 Aug. 2024, [doi:10.1016/j.isci.2024.110668](https://doi.org/10.1016/j.isci.2024.110668)
