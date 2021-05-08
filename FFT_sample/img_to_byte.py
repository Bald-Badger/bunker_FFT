from PIL import Image
import numpy as np


def rgb2g(rgb):
	weight = (0.299, 0.587, 0.114)
	# weight = (1/3, 1/3, 1/3)
	return round(np.dot(rgb, weight))


if __name__ == '__main__':
	in_name = "zebra.jpg"
	im = Image.open(in_name)
	pix = im.load()
	dim = (im.size[1], im.size[0])
	print("image size: {}".format(im.size))
	arr = np.zeros(dim, dtype=np.uint8)
	for i in range(dim[0]):
		for j in range(dim[1]):
			arr[i, j] = rgb2g(pix[j, i])
	im.close()
	arr = np.ndarray.flatten(arr)
	# im = Image.fromarray(arr, "L")
	# im.show()
	out_name = "zebra.txt"
	f = open(out_name, 'w')
	for pix in arr:
		f.write(str(int(pix)))
		f.write('\n')
	f.close()


