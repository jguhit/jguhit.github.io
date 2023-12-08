rm = py.pyvisa.ResourceManager();
%fopen(rm)
%resource = rm.list_resources();
%disp(resource)
gpib_inst = rm.open_resource('GPIB0::6::INSTR');
disp(gpib_inst)
%IDN = gpib_inst.query('*IDN?');
%gpib_inst.write('OUTP 1');
%OUTPq = gpib_inst.query('OUTP?');
%disp(IDN);
%disp(OUTPq);

%gpib_inst.write('INST:SEL OUT1');
%gpib_inst.write('APPL 2.500, 0.100');
%gpib_inst.write('INST:SEL OUT2');
%gpib_inst.write('APPL 2.500, 0.100');

%gpib_inst.write('INST:SEL OUT1');
%volt = gpib_inst.query('MEAS:VOLT?');
%disp(volt)
%newvolt = py.scanf.scanf("%f", volt);
%disp(newvolt)
%curr = gpib_inst.query('MEAS:CURR?');
%p2p = gpib_inst.query('CALC:AVER:PTP');
%disp(p2p)
%voltmax = gpib_inst.query('VOLT? MAX');
%disp(voltmax)
%voltmin = gpib_inst.query('VOLT? MIN');
%disp(voltmin)

%voltage1 = fscanf(gpib_inst, '%e', 16);

%disp(gpib_inst.session)
%disp(gpib_inst.close())

%disp(gpib_inst.session)