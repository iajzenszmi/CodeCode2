import matplotlib.pyplot as plt
import numpy as np

# Create a list of angles
angles = np.linspace(0, 2 * np.pi, 400)

# Create the scalar radius
r = 5

# Use the angles to create the 3D coordinates of a Moebius Strip
x = np.cos(angles) * (r + (np.cos(angles) * 0.75))
y = np.sin(angles) * (r + (np.cos(angles) * 0.75))
z = np.sin(angles) * 0.25

# Create the 3D Klein Bottle
x2 = (np.cos(angles) * (r + (np.cos(angles) * 0.75))) + (np.sin(angles) * 0.25)
y2 = np.sin(angles) * (r + (np.cos(angles) * 0.75))
z2 = np.cos(angles) * 0.25

# Generate a figure
fig = plt.figure(figsize=(10, 10))
ax = fig.add_subplot(111, projection='3d')

# Plot the Moebius Strip
ax.plot(x, y, z, color='b', zorder=1, alpha=0.4, linewidth=2)

# Plot the Klein Bottle
ax.plot(x2, y2, z2, color='r', zorder=2, alpha=0.4, linewidth=2)

# Add Labels
ax.set_xlabel('X', fontsize=10)
ax.set_ylabel('Y', fontsize=10)
ax.set_zlabel('Z', fontsize=10)

# Add a Title
ax.set_title('Moebius Strip to Klein Bottle', fontsize=12)

# Show the Plot
plt.show()
