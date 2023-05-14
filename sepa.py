import numpy as np

def generate_signal(length):
    """Generate a simple signal."""
    t = np.linspace(0, 10, length)
    signal = np.sin(2 * np.pi * t)
    return signal

def generate_noise(length, amplitude):
    """Generate random noise."""
    noise = np.random.normal(0, amplitude, length)
    return noise

def add_noise_to_signal(signal, noise):
    """Mix the signal and noise together."""
    mixed_signal = signal + noise
    return mixed_signal

def moving_average_filter(signal, window_size):
    """Apply a moving average filter to the signal."""
    filtered_signal = np.convolve(signal, np.ones(window_size)/window_size, mode='same')
    return filtered_signal

# Generate signal and noise
length = 1000
amplitude = 0.5
signal = generate_signal(length)
noise = generate_noise(length, amplitude)

# Mix signal and noise
mixed_signal = add_noise_to_signal(signal, noise)

# Apply moving average filter
window_size = 10
filtered_signal = moving_average_filter(mixed_signal, window_size)

# Plot the original signal, mixed signal, and filtered signal
import matplotlib.pyplot as plt

plt.figure(figsize=(10, 6))
plt.plot(signal, label='Original Signal')
plt.plot(mixed_signal, label='Mixed Signal')
plt.plot(filtered_signal, label='Filtered Signal')
plt.legend()
plt.xlabel('Time')
plt.ylabel('Amplitude')
plt.title('Signal Separation')
plt.grid(True)
plt.show()

