from PP_RBIN_func import RBIN, RBIN_Stats
import time

### RBIN ###
RBIN_list = [0,1,2]
for i in RBIN_list:
   #print("RBIN_{}".format(i))
   RBIN('RBIN_{}'.format(i))

time.sleep(10)
RBIN_Stats('RBIN')

