from PIL import Image
import numpy as np
import matplotlib.pyplot as plt

freq_offset = 300  # ignore the DC part

def get_fft(img_name):
	# Open the image form working directory
	image = Image.open(img_name).convert('L')

	# summarize some details about the image
	# show the image
	data = np.asarray(image)
	print(data.shape)
	y = np.ndarray.flatten(data)
	z = np.abs(np.fft.fft(y).real[freq_offset:3000])
	image.close()
	return z


def plot_space(img_name):
	# Open the image form working directory
	image = Image.open(img_name).convert('L')

	# summarize some details about the image
	# show the image
	data = np.asarray(image)
	print(data.shape)
	y = np.ndarray.flatten(data)
	x = np.arange(len(y))
	x = [n+freq_offset for n in x]


	# plotting
	plt.title("time domain graph")
	plt.xlabel("X axis")
	plt.ylabel("Y axis")
	plt.plot(x, y, color="green")
	plt.show()
	image.close()


def plot_freq(img_name):
	z = get_fft(img_name)
	x = np.arange(len(z))
	x = [n + freq_offset for n in x]
	plt.title("frequency domain graph")
	plt.xlabel("discrete frequency")
	plt.ylabel("frequency strength")
	plt.plot(x, z, color="green")
	plt.show()


def display_freq(img_name):
	# Open the image form working directory
	image = Image.open(img_name).convert('L')

	# summarize some details about the image
	# show the image
	data = np.asarray(image)
	print(data.shape)
	y = np.ndarray.flatten(data)
	x = np.arange(len(y))

	z = np.fft.fft(y).real

if __name__ == '__main__':
	name = "owl.jpg"
	# plot_space(name)
	plot_freq(name)
	z = get_fft(name)
	max = 0
	max_index = 0
	for i in range(len(z)):
		if z[i] > max:
			max = z[i]
			max_index = i
	print(max)
	print(max_index)
