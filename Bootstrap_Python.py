#--------------------
# Bootstrap in Python
#--------------------

import pandas as pd
import numpy as np
from scipy.stats import bootstrap

sample1 = pd.read_csv("C:/Users/julia/OneDrive/Desktop/github/sample1.csv")
sample1

# example 1
sample1 = np.array([8.26, 6.33, 10.4, 5.27, 5.35, 5.61, 6.12, 6.19, 5.2, 7.01, 8.74, 7.78, 
    7.02, 6, 6.5, 5.8, 5.12, 7.41, 6.52, 6.21, 12.28, 5.6, 5.38, 6.6, 8.74], dtype = float)

sample1 = (sample1,)
B = 10000   # set the number of boostrap replicates

#calculate 95% bootstrapped confidence interval for median
bootstrap_ci = bootstrap(sample1, np.median, random_state=B, method='percentile')

#view 95% boostrapped confidence interval
bootstrap_ci.confidence_interval
# ConfidenceInterval(low=5.8, high=7.02)

#----
# end
#----