import pandas as pd
import matplotlib.pyplot as plt

# Read the rainfall data from CSV file
data = pd.read_csv('rainfall_data.csv')

# Calculate the deciles
deciles = data['Rainfall'].quantile([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9])

# Display deciles in text
print("Deciles of Rainfall:")
print(deciles)

# Create a bar plot of deciles
plt.bar(deciles.index, deciles.values)
plt.xlabel('Decile')
plt.ylabel('Rainfall')
plt.title('Deciles of Rainfall')
plt.show()
