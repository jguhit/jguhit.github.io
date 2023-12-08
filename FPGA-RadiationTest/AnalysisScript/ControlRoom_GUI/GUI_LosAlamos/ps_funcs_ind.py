#!/usr/bin/env python

import pyvisa 
import time 
import sys 
import os 
import scanf

def comm(addr):
    addr = int(addr)
    rm = pyvisa.ResourceManager()
    resource = rm.list_resources()
    gpib_inst = rm.open_resource('GPIB0::{}::INSTR'.format(addr))
    #print("GPIB Connected: ", gpib_inst)
    #print(gpib_inst.query('*IDN?'))

    for i in range(1,3):
        inst = gpib_inst.write('INST:SEL OUT{}'.format(i))
        #checking if the output changes to outp1 and outp2
        instq = gpib_inst.query('INST:SEL?') 
        #print('INST:SEL: ', instq) 

        appl = gpib_inst.write('APPL 6.0, 2.0')
        #checking if the voltage and current were applied 
        applq = gpib_inst.query('APPL?')
        #print('APPLY: ', applq)

    return gpib_inst

#comm('6')

def comm1(addr):
    addr = int(addr)
    rm = pyvisa.ResourceManager()
    resource = rm.list_resources()
    gpib_inst1 = rm.open_resource('GPIB0::{}::INSTR'.format(addr))
    #print("GPIB Connected: ", gpib_inst1)

    inst1 = gpib_inst1.write('INST:SEL OUT1')
    instq1 = gpib_inst1.query('INST:SEL?')
    appl1 = gpib_inst1.write('APPL 6.0, 2.0')
    applq1 = gpib_inst1.query('APPL?')
    #print('INST:SEL: ', instq1) 
    #print('APPLY: ', applq1)
    return gpib_inst1

def comm2(addr):
    addr = int(addr)
    rm = pyvisa.ResourceManager()
    resource = rm.list_resources()
    gpib_inst2 = rm.open_resource('GPIB0::{}::INSTR'.format(addr))
    #print("GPIB Connected: ", gpib_inst2)

    inst2 = gpib_inst2.write('INST:SEL OUT2')
    instq2 = gpib_inst2.query('INST:SEL?')
    appl2 = gpib_inst2.write('APPL 6.0, 2.0')
    applq2 = gpib_inst2.query('APPL?')
    #print('INST:SEL: ', instq2)
    #print('APPLY: ', applq2)
    return gpib_inst2


def PS_on():
    gpib_inst = comm('6')
    for i in range(1,3):
        outp = gpib_inst.write('INST:SEL OUT{}'.format(i))
        outpq = gpib_inst.query('INST:SEL?')
        outp_on = gpib_inst.write('OUTP ON')
        outp_onq = gpib_inst.query('OUTP?')
        #print('INST:SEL: ', outpq, 'OUTP: ', outp_onq)
    
    time.sleep(2)

#PS_on()

def PS_on1():
    gpib_inst1 = comm1('6')
    outp1 = gpib_inst1.write('INST:SEL OUT1')
    outpq1 = gpib_inst1.query('INST:SEL?')
    outp_on1 = gpib_inst1.write('OUTP ON')
    outp_onq1 = gpib_inst1.query('OUTP?')
    #outp2 = gpib_inst1.write('INST:SEL OUT2')
    #outpq2 = gpib_inst1.query('INST:SEL?')
    #outp_off2 = gpib_inst1.write('OUTP OFF')
    #outp_off2q = gpib_inst1.query('OUTP?')
    #print('INST:SEL: ', outpq1, 'OUTP: ', outp_onq1)
    #print('INST:SEL: ', outpq2, 'OUTP: ', outp_off2q)
    return

def PS_on2():
    gpib_inst2 = comm2('6')
    outp2 = gpib_inst2.write('INST:SEL OUT2')
    outpq2 = gpib_inst2.query('INST:SEL?')
    outp_on2 = gpib_inst2.write('OUTP2 ON')
    outp_onq2 = gpib_inst2.query('OUTP?')
    #gpib_inst2.write('INST:SEL OUT1')
    #gpib_inst2.write('OUTP1 OFF')
    #print('INST:SEL: ', outpq2, 'OUTP: ', outp_onq2)
    return 
    

def PS_off():
    gpib_inst = comm('6')
    outp_off = gpib_inst.write('OUTP OFF')
    outp_offq = gpib_inst.query('OUTP?')
    print('OUTP: ', outp_offq)
    return
#PS_off()

def PS_off1():
    gpib_inst1 = comm1('6')
    gpib_inst1.write('INST:SEL OUT1')
    outp_off1 = gpib_inst1.write('OUTP1 OFF')
    outp_offq1 = gpib_inst1.query('OUTP?')
    #print('OUTP: ', outp_offq1)
    return

def PS_off2():
    gpib_inst2 = comm2('6')
    gpib_inst2.write('INST:SEL OUT2')
    outp_off2 = gpib_inst2.write('OUTP2 OFF')
    outp_offq2 = gpib_inst2.query('OUTP?')
    #print('OUTP: ', outp_offq2)
    return

def IV_meas():
    gpib_inst = comm('6') 
    inst1 = gpib_inst.write('INST:SEL OUT1')
    inst1q = gpib_inst.query('INST:SEL?')
    volt1 = gpib_inst.query('MEAS:VOLT?')
    nvolt1 = scanf.scanf("%f", volt1)
    curr1 = gpib_inst.query('MEAS:CURR?')
    ncurr1 = scanf.scanf("%f", curr1)
    #print('INST:SEL: ', inst1q, 'VOLT: ', nvolt1[0], 'CURR: ', ncurr1[0])

    inst2 = gpib_inst.write('INST:SEL OUT2')
    inst2q = gpib_inst.query('INST:SEL?')
    volt2 = gpib_inst.query('MEAS:VOLT?')
    nvolt2 = scanf.scanf("%f", volt2)
    curr2 = gpib_inst.query('MEAS:CURR?')
    ncurr2 = scanf.scanf("%f", curr2)
    #print('INST:SEL: ', inst2q, 'VOLT: ', nvolt2[0], 'CURR: ', ncurr2[0])

    return nvolt1, nvolt2, ncurr1, ncurr2

def IV_meas_1():
    gpib_inst1 = comm1('6')
    
    inst1 = gpib_inst1.write('INST:SEL OUT1')
    inst1q = gpib_inst1.query('INST:SEL?')
    volt1 = gpib_inst1.query('MEAS:VOLT?')
    nvolt1 = scanf.scanf("%f", volt1)
    curr1 = gpib_inst1.query('MEAS:CURR?')
    ncurr1 = scanf.scanf("%f", curr1)
    #print('INST:SEL: ', inst1q, 'VOLT: ', nvolt1[0], 'CURR: ', ncurr1[0])
    return nvolt1, ncurr1

def IV_meas_2():
    gpib_inst2 = comm2('6')
    inst2 = gpib_inst2.write('INST:SEL OUT1')
    inst2q = gpib_inst2.query('INST:SEL?')
    volt2 = gpib_inst2.query('MEAS:VOLT?')
    nvolt2 = scanf.scanf("%f", volt2)
    curr2 = gpib_inst2.query('MEAS:CURR?')
    ncurr2 = scanf.scanf("%f", curr2)
    #print('INST:SEL: ', inst2q, 'VOLT: ', nvolt2[0], 'CURR: ', ncurr2[0])
    return nvolt2, ncurr2

#print('OUT1')
#comm1('6')
#PS_on1()
#IV_meas_1()
#PS_off1()

#print('OUT2')
#comm2('6')
#PS_on2()
#IV_meas_2()
#PS_off2()
