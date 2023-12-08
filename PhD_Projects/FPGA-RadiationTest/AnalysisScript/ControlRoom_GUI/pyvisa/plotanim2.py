import matplotlib.pylab as plt
import matplotlib.animation as anim
import numpy as np


image = np.random.rand(100,10,10)
repeat_length = (np.shape(image)[0]+1)/4

fig = plt.figure()
ax1 = ax1=fig.add_subplot(1,2,1)
im = ax1.imshow(image[0,:,:])

ax2 = plt.subplot(122)
ax2.set_xlim([0,repeat_length])
ax2.set_ylim([np.amin(image[:,5,5]),np.amax(image[:,5,5])])
im2, = ax2.plot(image[0:0,5,5],color=(0,0,1))

canvas = ax2.figure.canvas

def init():
    im = ax1.imshow(image[0,:,:])
    im2.set_data([], [])
    return im,im2,

def animate(time):
    time = time%len(image)
    im = ax1.imshow(image[time,:,:])
    im2, = ax2.plot(image[0:time,5,5],color=(0,0,1))
    if time>repeat_length:
        print(time)
        im2.axes.set_xlim(time-repeat_length,time)
        plt.draw()
    return im,im2,

ax2.get_yaxis().set_animated(True)

# call the animator.  blit=True means only re-draw the parts that have changed.
animate = anim.FuncAnimation(fig, animate, init_func=init,
                               interval=0, blit=True, repeat=True)

plt.show()
