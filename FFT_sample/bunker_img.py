stride = round(510 * 340 / 384)
from PIL import Image
import numpy as np


def rgb2g(rgb):
	weight = (0.299, 0.587, 0.114)
	# weight = (1/3, 1/3, 1/3)
	return round(np.dot(rgb, weight))


def map(pos):
	return pos


if __name__ == '__main__':
	img_name = 'owl.jpg'
	im = Image.open(img_name)
	pix = im.load()
	dim = (im.size[1], im.size[0])
	print("image size: {}".format(im.size))
	arr = np.zeros(dim, dtype=np.uint8)
	for i in range(dim[0]):
		for j in range(dim[1]):
			arr[i, j] = rgb2g(pix[j, i])
	im.close()
	arr = np.ndarray.flatten(arr)
	mapped = np.zeros(dim, dtype=np.uint8)
	mapped = np.ndarray.flatten(mapped)
	length = len(arr)
	for i in range(dim[0]):
		for j in range(dim[1]):
			try:
				mapped[i * 510 + j] = arr[510 * i + j]
			except Exception:
				mapped[i * 510 + j] = 0
	dif = 1
	ramin = 173400 % (510 - dif)
	mapped = mapped[0: 173400 - ramin]
	mapped = mapped.reshape(-1, 510 - dif)
	im = Image.fromarray(mapped, "L")
	im.show()
