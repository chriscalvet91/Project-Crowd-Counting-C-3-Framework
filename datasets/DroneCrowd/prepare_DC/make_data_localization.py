import h5py
import scipy.io as io
import numpy as np
import os
import glob
from matplotlib import pyplot as plt
from multiprocessing import Pool
from functools import partial

def process(idx, img_paths):
    img_path = img_paths[idx]
    mat = io.loadmat(img_path.replace('.jpg','.mat').replace('images','ground_truth').replace('img','GT_img'))
    img = plt.imread(img_path)
    base_range = 5
    off1 = np.zeros((int(img.shape[0]/2),int(img.shape[1]/2),2))
    off2 = np.zeros((int(img.shape[0]/4),int(img.shape[1]/4),2))
    off3 = np.zeros((int(img.shape[0]/8),int(img.shape[1]/8),2))
    ids = np.zeros((int(img.shape[0]/2),int(img.shape[1]/2)), np.int16)
    gt = mat["image_info"][0,0][0,0][0]

    for i in range(len(gt)):
      for j in range(3):
        h, w = int(img.shape[0]/2**(j+1)), int(img.shape[1]/2**(j+1))
        y, x = int(gt[i][1]/2**(j+1)), int(gt[i][0]/2**(j+1))
        if x < w and y < h:
            if j == 0:
                ids[y,x] = gt[i][2]
            trk_range = int(base_range/(j+1.))
            left = max(0, x - trk_range)
            right = min(w-1, x + trk_range)
            top = max(0, y - trk_range)
            down = min(h-1, y + trk_range)
            for n in range(left,right+1,1):
                for m in range(top,down+1,1):
                  if j == 0:
                    off1[m,n,0], off1[m,n,1] = y-m, x-n
                  elif j == 1:
                    off2[m,n,0], off2[m,n,1] = y-m, x-n
                  elif j == 2:
                    off3[m,n,0], off3[m,n,1] = y-m, x-n

    with h5py.File(img_path.replace('.jpg','_max.h5').replace('images','ground_truth'), 'w') as hf:
        hf['identity'] = ids
        hf['offset1'] = off1
        hf['offset2'] = off2
        hf['offset3'] = off3

    print(idx, len(img_paths))


part_train = os.path.join('train_data','images')
part_test = os.path.join('test_data','images')

img_paths = []
for img_path in glob.glob(os.path.join(part_train, '*.jpg')):
	img_paths.append(img_path)
for img_path in glob.glob(os.path.join(part_test, '*.jpg')):
	img_paths.append(img_path)
img_paths.sort()

pool = Pool(10)
partial = partial(process, img_paths=img_paths)
_ = pool.map(partial, range(len(img_paths)))