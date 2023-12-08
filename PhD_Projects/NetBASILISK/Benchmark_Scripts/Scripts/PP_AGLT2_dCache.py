from PP_AGLT2_func import AGLT2
from PP_AGLT2_Memory_func import AGLT2_mem
import time

### AGLT2 ###
servers = ['umfs06', 'umfs09', 'umfs11', 'umfs16', 'umfs19', 'umfs20', 'umfs21', 'umfs22', 'umfs23', 'umfs24', 'umfs25', 'umfs26', 'umfs27', 'umfs28']
for i in servers:
     AGLT2('{}'.format(i), 'CPU_load', 'load5_AVERAGE', 5)
     AGLT2('{}'.format(i), 'CPU_utilization', 'util_AVERAGE', 11)
     AGLT2('{}'.format(i), 'Disk_IO_SUMMARY', 'disk_utilization_AVERAGE', 2)
     AGLT2_mem('{}'.format(i), 'Memory', 'mem_available_AVERAGE', 74)

