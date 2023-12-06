#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
from scipy import stats
#open file 
df=pd.read_csv('/projects/p31240/abcd/DTI/persistent_report.csv') #file with all sessions; created this file manually through a shell script

info=df['FileName'].str.split('_',n=4,expand=True)

df['sub']=info[0]
df['ses']=info[1]

mad=stats.median_abs_deviation(df['Neighboring DWI correlation']) #median absolute deviation
med=np.median(df['Neighboring DWI correlation'])
neg_cutoff=med - 3 * mad
pos_cutoff=med + 3 * mad
#data set would be rejected if the baseline and follow-up scans have a difference in mean Pearson correlation coefficient greater than 0.1
ses1=df[df['ses']=='ses-baselineYear1Arm1']
ses2=df[df['ses']=='ses-2YearFollowUpYArm1']
ses1['cutoff_score']=ses1['Neighboring DWI correlation']-.1
ses1.drop(columns=['FileName','# Bad Slices'],inplace=True)
ses2.drop(columns=['FileName','# Bad Slices'],inplace=True)
ses2.rename(columns={'Neighboring DWI correlation':'time2','ses':'ses2'},inplace=True)
session=ses1.merge(ses2,on='sub')
ses=session.round(1)
ses['flag']=ses['time2']-ses['cutoff_score']
ses=ses[ses['flag']<0]


# In[2]:


#print subjs who have a difference>.1 should be excluded
ses


# In[3]:


#subjs that should be excluded because dwi corr coed is greater than 3 median absolute deviations
new=df[df['Neighboring DWI correlation']<neg_cutoff] 
new.to_csv('/projects/p31240/abcd/DTI/persistent_cutoff_subs.csv', index=False)


# In[4]:


#accept data set if the number of bad slices is smaller than 0.001*total slice number .001*69=.06
#more or less exclude any subjects >0 bad slice
#subjs should be excluded because of large number of bad slices
bad = df[df['# Bad Slices']!=0]


# In[5]:


bad.groupby('sub').nunique()


# In[6]:


bad.reset_index()


# In[7]:


df

