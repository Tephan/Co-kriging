# -*- coding: utf-8 -*-
"""
Created on Wed May 18 12:34:53 2022

@author: tepha
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import scipy
import glob
import os
from scipy import signal
from scipy.integrate import simps
from scipy.signal import filtfilt, butter
from scipy import fft, ifft
from scipy import stats
import csv
import numpy as np

file = 'C:\\Users\\tepha\\Desktop\\Señales\\Luis\\Resolver_EPOCPLUS_153302_2022.03.30T16.43.00.05.00.md.csv'
canales = ['EEG.AF3','EEG.F7','EEG.F3','EEG.FC5','EEG.T7','EEG.P7','EEG.O1','EEG.O2','EEG.P8','EEG.T8','EEG.FC6','EEG.F4','EEG.F8','EEG.AF4']
bandas=['Delta', 'Teta', 'Alfa', 'Beta', 'Gamma']
frequency=[[0.0001, 4 ],[4, 8],[8, 12],[12, 30],[30, 1000000]]
arr = np.ones((14, 5))

for k in range(len(canales)):
    print(k)
    datos = pd.read_csv(file)
    data_canal = datos[canales[k]].tolist()
    dataD = data_canal
    sf = 1024 #  Frecuencia de muestreo
    for i in range(len(bandas)):
        low,high=frequency[i]
        win = 4 * sf
        freqs, psd = signal.welch(dataD, sf, nperseg=win)
        idx = np.logical_and(freqs >= low, freqs <= high)
        freq_res = freqs[1] - freqs[0]  # = 1 / 4 = 0.25
        power = simps(psd[idx], dx=freq_res)
        total_power = simps(psd, dx=freq_res)
        rel_power = power / total_power
        print(rel_power)
        arr[k][i]=rel_power
    
df = pd.DataFrame(arr)
df.to_csv('C:\\Users\\tepha\\Desktop\\example2.csv')
