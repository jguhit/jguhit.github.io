from PP_AGLT2CHI_func import AGLT2CHI, AGLT2CHI_Stats
import time

### AGLT2_CHI ###
AGLT2CHI_list = [0,1,2,3,4,5]
for j in AGLT2CHI_list:
    AGLT2CHI('AGLT2_CHI_{}'.format(j))

time.sleep(10)
AGLT2CHI_Stats('AGLT2_CHI')
