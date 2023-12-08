from PP_AGLT2_func import AGLT2_Stats
import time

### AGLT2 ###
metadata = ['CPU_load', 'CPU_utilization', 'Disk_IO_SUMMARY', 'Memory']
for j in metadata:
        AGLT2_Stats('AGLT2', '{}'.format(j))
