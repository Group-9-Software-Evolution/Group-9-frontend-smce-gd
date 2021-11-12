# importing Pandas libary
import pandas as pd
from chord import Chord



# reading data from csv
df = pd.read_csv("housing.csv")

# List of columns to delete and then dropping them.
#delete = ['ZN', 'INDUS', 'CHAS', 'DIS','RAD','PTRATIO','B','LSTAT']
#df.drop(delete, axis=1, inplace=True)

# Now, matrix contains a 6x6 matrix of the values.
matrix = df.corr()
# Replacing negative values with 0’s, as features can be negatively correlated.
matrix[matrix < 0] = 0
# Multiplying all values by 100 for clarity, since correlation values lie b/w 0 and 1.
matrix = matrix.multiply(100).astype(int)
# Converting the DataFrame to a 2D List, as it is the required input format.
matrix = matrix.values.tolist()

# Names of the features.
names = ["Crime Rate","N-Oxide","Number of rooms","Older buildings","Property Tax","Media"
                                                                                   ""
                                                                                   ""
                                                                                   "n Price"]

Chord(matrix, names).show()
#Note: The show() function works only with Jupyter Labs.
# (Not Jupyter notebook)
