library(tidyverse)
library(MASS)

# Load your data from the CSV file
df <- read_csv('/Users/joannahernandez/Desktop/WM_Analyses/WM_tracts.csv')

set.seed(2021)

permutation.test <- function(df, increased_score, n){
  p_vals_distribution = c()
  for (i in 1:n){
    #f = sample(outcome, length(outcome))
    f = sample(df$increased_score, length(df$increased_score))
    df$increased_score = increased_score
    df$x_permuted = f #add demo below
    t=summary(lm(increased_score ~x_permuted+age+sex_at_birth_F+race_ethnicity_Asian+race_ethnicity_Black+race_ethnicity_Hispanic+race_ethnicity_Other+mri_manufacturer_GE+
                   mri_manufacturer_Philips+mri_manufacturer_SIEMENS+hh_income_50K+hh_income_100K+hh_income_50to100K+high_educ_HS_Diploma+high_educ_Bachelor+high_educ_HS_Diploma_GED+
                   high_educ_Post_Grad_Degree+high_educ_Some_College,
                 data=df))
    # Save p vals
    p_vals_distribution[i] = (t$coefficients[2,4])
  }
  # Compare to true significance pval
  #add demo data below
  true=summary(lm(increased_score ~age+sex_at_birth_F+race_ethnicity_Asian+race_ethnicity_Black+race_ethnicity_Hispanic+race_ethnicity_Other+mri_manufacturer_GE+
                    mri_manufacturer_Philips+mri_manufacturer_SIEMENS+hh_income_50K+hh_income_100K+hh_income_50to100K+high_educ_HS_Diploma+high_educ_Bachelor+high_educ_HS_Diploma_GED+
                    high_educ_Post_Grad_Degree+high_educ_Some_College,
                  data=df))
  true_p <- (true$coefficients[2,4])
  result <- sum((p_vals_distribution) <= (true_p))/(n)
  return(result)
}

tracts = c("left_caudal_anterior_cingulate","left_caudal_middle_frontal","left_cuneus","left_entorhinal","left_fusiform",
           "left_inferior_parietal","left_inferior_temporal","left_isthmus_cingulate","left_lateral_occipital","left_lateral_orbitofrontal",
           "left_lingual","left_medial_orbitofrontal","left_middle_temporal","left_parahippocampal","left_paracentral",
           "left_pars_opercularis","left_pars_orbitalis","left_pars_triangularis","left_pericalcarine","left_postcentral","left_posterior_cingulate",
           "left_precentral","left_precuneus","left_rostral_anterior_cingulate","left_rostral_middle_frontal","left_superior_frontal",
           "left_superior_parietal","left_superior_temporal","left_supramarginal","left_transverse_temporal","left_insula",
           "right_superior_temporal","right_caudal_anterior_cingulate","right_caudal_middle_frontal","right_cuneus","right_entorhinal",
           "right_fusiform","right_inferior_parietal","right_inferior_temporal","right_isthmus_cingulate","right_lateral_occipital",
           "right_lateral_orbitofrontal","right_lingual","right_medial_orbitofrontal","right_middle_temporal","right_parahippocampal",
           "right_paracentral","right_pars_opercularis","right_pars_orbitalis","right_pars_triangularis","right_pericalcarine","right_postcentral",
           "right_posterior_cingulate","right_precentral","right_precuneus","right_rostral_anterior_cingulate","right_rostral_middle_frontal","right_superior_frontal",
           "right_superior_parietal","right_superior_temporal","right_supramarginal","right_transverse_temporal","right_insula","age","sex_at_birth_F","race_ethnicity_Asian","race_ethnicity_Black","race_ethnicity_Hispanic","race_ethnicity_Other","mri_manufacturer_GE",
             "mri_manufacturer_Philips","mri_manufacturer_SIEMENS","hh_income_50K","hh_income_100K","hh_income_50to100K","high_educ_HS_Diploma","high_educ_Bachelor","high_educ_HS_Diploma_GED",
             "high_educ_Post_Grad_Degree","high_educ_Some_College","increased_score")

new <- df[tracts]
cols <- colnames(new)
sig<- c()
j = 1
for (i in colnames(new)){
  t <- permutation.test(new, new[[i]], 1000)
  sig[j] = t
  j = j+1
}

results <- data.frame(cols, sig)
results$sig<0.01
results %>% filter(sig<0.02)
