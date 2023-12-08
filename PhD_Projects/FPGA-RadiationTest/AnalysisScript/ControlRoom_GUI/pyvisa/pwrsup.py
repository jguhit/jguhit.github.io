import pyvisa 

rm = pyvisa.ResourceManager()
print(rm)
resource = rm.list_resources()
print(resource)
#gpib_inst = rm.open_resource('GPIB0::8::INSTR')
gpib_inst = rm.open_resource('GPIB0::5::INSTR')
print("PS 1 Connected: ", gpib_inst)
#print("PS 2 Connected: ", gpib_inst1)
##print(gpib_inst.query('*IDN?'))
gpib_inst.write('APPL 7.0, 2.0')
print(gpib_inst.query('APPL?'))
'''
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
