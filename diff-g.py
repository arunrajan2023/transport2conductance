import numpy as np
import matplotlib.pyplot as plt
import scipy.interpolate
from matplotlib.font_manager import FontProperties
from matplotlib import figure
from pylab import *
import Image
from matplotlib import rc


rc("font", family="serif")
rc("font", size=14)
rc('axes', linewidth=1.2)

title("Naphthalene (g=dI/dV)")
ylabel(r'V$_{\rm{b}}$ (V)')
xlabel(r'E - E$_{\rm{F}}$ (eV)')

x, y, z=np.loadtxt("2d-diff-g.dat", unpack=True)

yticks(arange(-1.0, 1.01, 0.5))
xticks(arange(-1.5, 2.0,.5))

# Set up a regular grid of interpolation points
xi, yi = np.linspace(x.min(), x.max(), 80), np.linspace(y.min(), y.max(), 80)
xi, yi = np.meshgrid(xi, yi)

# Interpolate
rbf = scipy.interpolate.Rbf(x, y, z, function='linear')
zi = rbf(xi, yi)

plt.imshow(zi, vmin=z.min(), vmax=z.max(), origin='lower', extent=[x.min(), x.max(), y.min(), y.max()])
xlim([-1.5,-0.5])
ylim([-1.01,1.01])
plt.colorbar()
savefig("plot4.png", dpi=600)
Image.open('plot4.png').save('2d-diff-g.jpg','JPEG')
#plt.show()
