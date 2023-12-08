import threading 
import time 
from ps_funcs import comm, PS_on, PS_off, IV_meas

def gpib(addr): # dont know if it works yet
        gpib_inst = comm('6')
        print('PS init')

def pwr_on():
        ON = PS_on()
        print('PS on')

def pwr_off():
        OFF = PS_off()
        print('PS off')

if __name__ == "__main__":
    t1 = threading.Thread(target=gpib, args=('6',))
    t2 = threading.Thread(target=pwr_on)
    t3 = threading.Thread(target=pwr_off)
    t1.start()
    time.sleep(0.2)
    t2.start()
    time.sleep(0.2)
    t3.start()
    t1.join()
    t2.join()
    t3.join()
    print("Done")



