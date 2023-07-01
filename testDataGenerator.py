import pandas as pd
import numpy as np

# Generate random rainfall data
np.random.seed(42)  # Set seed for reproducibility
num_records = 100  # Number of records to generate
rainfall = np.random.uniform(0, 100, num_records)

# Create DataFrame
data = pd.DataFrame({'Rainfall': rainfall})

# Save data to CSV file
data.to_csv('rainfall_data.csv', index=False)
