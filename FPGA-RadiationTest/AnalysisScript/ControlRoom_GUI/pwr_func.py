import pyvisa 
import sys
#comm connects to the GPIB instrument
def comm():
    rm = pyvisa.ResourceManager()
    #print(rm)
    resource = rm.list_resources()
    gpib_inst = rm.open_resource('GPIB0::6::INSTR')
    #print("GPIB Connected: ", gpib_inst)
    return gpib_inst

def reset():
    gpib_inst = comm()
    rst = gpib_inst.write('*RST')
    cls = gpib_inst.write('*CLS')
    PSC = gpib_inst.write('*PSC 0')
    PSCq = gpib_inst.query('*PSC?')
    OUTP = gpib_inst.write('OUTP 0')
    OUTPq = gpib_inst.query('OUTP?')
    return rst, cls, PSCq, OUTPq

def status():
    gpib_inst = comm()
    ID = gpib_inst.query('*IDN?')
    PSC = gpib_inst.query('*PSC?')
    PSC = int(PSC)
    OUTP = gpib_inst.query('OUTP?')
    OUTP = int(OUTP)
    
    if PSC == 1:
        print('PSC is enabled, continue')
    else:
        print('PSC is disabled, now enabling')
        gpib_inst.write('*PSC 1')
        print('PSC Status: ', gpib_inst.query('*PSC?'))
    
    if OUTP == 1:
        print('OUTP is enabled, continue')
    else: 
        print('OUTP is disabled, now enabling')
        gpib_inst.write('OUTP 1')
        print('OUTP Status: ', gpib_inst.query('OUTP?'))

    #rst, cls, power, output = reset()
    #print('rst: ', rst)
    #print('cls: ', cls)
    #print('PSC: ', power)
    #print('OUTP: ', output)

#status()

def meas():
    gpib_inst = comm()
    #inst = gpib_inst.query('INST:NSEL?')
    #print(inst)
    outp = ['OUTP1', 'OUTP2']
    for i in range(1,3):
        #print(i)
        inst = gpib_inst.write('INST:NSEL {}'.format(i))
        instq = gpib_inst.query('INST:NSEL?')
        #print(instq)
        #appl = gpib_inst.write('APPL 6.0, 2.0')
        volt = gpib_inst.write('VOLT:DC:RANG 6,0,6')
        curr = gpib_inst.write('CURR:DC:RANG 2,0,2') #is the minimum 0 or -2? 
        voltq = gpib_inst.query('MEAS:VOLT:DC?')
        currq = gpib_inst.query('MEAS:CURR:DC?')
        #voltq = gpib_inst.query('VOLT? MAX')
        #currq = gpib_inst.query('CURR?')

        #print(voltq)
        #print(currq)

meas()
'''
gpib_inst = rm.open_resource('GPIB0::6::INSTR')
onoff = [0, 1]
outp = ['OUTP1', 'OUTP2']

print(gpib_inst.query('*IDN?'))
print(gpib_inst.query('*PSC?'))
#print(gpib_inst.query('OUTP?'))
print('Setting OUTP to 1')
gpib_inst.write('INST:NSEL 1')
print(gpib_inst.query('OUTP?'))
print('Info for OUTP1')
gpib_inst.write('APPL 6.0, 2.0')
print(gpib_inst.query('APPL?'))
print(gpib_inst.query('MEAS:VOLT?'))
print(gpib_inst.query('MEAS:CURR?'))
print(gpib_inst.query('VOLT:PROT:STAT?'))

print('Setting OUTP to 2')
gpib_inst.write('INST:NSEL 2')
print(gpib_inst.query('OUTP?'))
print('Infor for OUTP2')
gpib_inst.write('APPL 6.0, 2.0')
print(gpib_inst.query('APPL?'))
print(gpib_inst.query('MEAS:VOLT?'))
print(gpib_inst.query('MEAS:CURR?'))
print(gpib_inst.query('VOLT:PROT:STAT?'))
#VOLT? MAX|MIN and CURR? MAX|MIN give the highest 
#lowest programmable levels
#print(gpib_inst.query('SOUR:VOLT? MIN'))
#print(gpib_inst.query('SOUR:VOLT? MAX'))
#print(gpib_inst.query('SOUR:CURR? MIN'))
#print(gpib_inst.query('SOUR:CURR? MAX'))

#gpib_inst.write('*PSC 1')
#print(gpib_inst.query('*PSC?'))
#print(gpib_inst.query('MEAS:SCAL:VOLT:DC?'))
##print(gpib_inst.query('MEAS:SCAL:CURR:DC?'))
'''
