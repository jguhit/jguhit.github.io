#!/usr/bin/env python

import pyvisa 
import time 
import sys 
import os 
import scanf

def comm5(addr):
    addr = int(addr)
    rm = pyvisa.ResourceManager()
    #print(rm)
    resource = rm.list_resources()
    #print(resource)
    gpib_inst5 = rm.open_resource('GPIB0::{}::INSTR'.format(addr))
    #print("GPIB Connected: ", gpib_inst5)
    #print(gpib_inst.query('*IDN?'))

    for i in range(1,3):
        inst = gpib_inst5.write('INST:SEL OUT{}'.format(i))
        #checking if the output changes to outp1 and outp2
        instq = gpib_inst5.query('INST:SEL?') 
        #print('INST:SEL: ', instq) 

        appl = gpib_inst5.write('APPL 7.0, 2.0')
        #checking if the voltage and current were applied 
        applq = gpib_inst5.query('APPL?')
        #print('APPLY: ', applq)

    #In matlab there is a timer strcmp command check later 
    #Log file saying "Power Supply Initialized"
    return gpib_inst5

#comm5('5')

def PS_on5():
    gpib_inst5 = comm5('5')
    for i in range(1,3):
        outp = gpib_inst5.write('INST:SEL OUT{}'.format(i))
        outpq = gpib_inst5.query('INST:SEL?')
        outp_on = gpib_inst5.write('OUTP ON')
        outp_onq = gpib_inst5.query('OUTP?')
        #print('INST:SEL: ', outpq, 'OUTP: ', outp_onq)
    
    time.sleep(2)
    #Include timer 
    #Log File: Power Supply Output ON 

#PS_on5()

def PS_off5():
    gpib_inst5 = comm5('5')
    outp_off = gpib_inst5.write('OUTP OFF')
    outp_offq = gpib_inst5.query('OUTP?')
    #print('OUTP: ', outp_offq)

    #Include timer 
    #Log File: Power Supply Output Off 

#PS_off5()

def IV_meas5():
    gpib_inst5 = comm5('5') 
    inst1 = gpib_inst5.write('INST:SEL OUT1')
    inst1q = gpib_inst5.query('INST:SEL?')
    volt1 = gpib_inst5.query('MEAS:VOLT?')
    nvolt1 = scanf.scanf("%f", volt1)
    #for ele in nvolt1: 
    #    print(ele)
    curr1 = gpib_inst5.query('MEAS:CURR?')
    ncurr1 = scanf.scanf("%f", curr1)
    #print('INST:SEL: ', inst1q, 'VOLT: ', nvolt1[0], 'CURR: ', ncurr1[0])

    inst2 = gpib_inst5.write('INST:SEL OUT2')
    inst2q = gpib_inst5.query('INST:SEL?')
    volt2 = gpib_inst5.query('MEAS:VOLT?')
    nvolt2 = scanf.scanf("%f", volt2)
    curr2 = gpib_inst5.query('MEAS:CURR?')
    ncurr2 = scanf.scanf("%f", curr2)
    #print('INST:SEL: ', inst2q, 'VOLT: ', nvolt2[0], 'CURR: ', ncurr2[0])

    return nvolt1, nvolt2, ncurr1, ncurr2
    #for i in range(1,3):
    #    inst = gpib_inst.write('INST:SEL OUT{}'.format(i))
    #    instq = gpib_inst.query('INST:SEL?')
    #    voltq = gpib_inst.query('MEAS:VOLT?')
    #    currq = gpib_inst.query('MEAS:CURR?')
    #    print('INST:SEL: ', instq, 'VOLT: ', voltq, 'CURR: ', currq)
    
    #return voltq, currq 

#IV_meas()
##Create a function for saving data 
