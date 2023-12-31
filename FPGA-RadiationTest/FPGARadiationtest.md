# Project Background 

The 2012 discovery of the Higgs boson by the ATLAS experiment at CERN was a significant milestone in particle physics, validating the theory of electroweak symmetry breaking. While this discovery shed light on how particles gain mass through their interaction with the Higgs field, it also opened the door to further investigations into the Higgs boson's properties and its interactions with other particles. To facilitate a better understanding, the High Luminosity LHC (HL-LHC) is an anticipated upgrade to the existing LHC. The HL-LHC is set to increase particle collisions by a factor of five, greatly enhancing the radiation environment.  The University of Michigan is contributing to the upgrades with the development of the Chamber Service Module (CSM). The CSM is a key component of the precision tracking system in the ATLAS experiment's muon architecture.  Designed as a multiplexer, the CSM manages data acquisition and transmission using mezzanine cards, ensuring compatibility with existing and future cards to handle increased data bandwidth and radiation levels.

One of the main challenges in a high-radiation environment is the risk of Single Event Upsets (SEUs) - errors where radiation changes a data bit to an incorrect value, often due to energetic particles interacting with sensitive components. These “bitflips” in electronic devices can corrupt data streams, leading to inconsistencies and reduced muon system efficiency. Recognizing the potential damage SEUs can cause to our hardware upgrades, we propose an in-depth SEU evaluation of the CSM at the Los Alamos Neutron Science Center (LANSCE).

# Role in Project
I made significant contributions to the upcoming SEU (Single Event Upsets) tests. One of my key contributions was the development of firmware for the FPGA (Field-Programmable Gate Array) device, specifically focusing on the ethernet communication between the FPGA device under test and FPGAs that collect data. This development is crucial for our experiment as it enables seamless communication and data collection  In the figure below, this corresponds to the **"Shielding"** part of the setup. Additionally, I designed the software GUI used in radiation tests, simplifying the data acquisition and analysis processes. In the figure below, this corresponds to the **"Control Room"** part of the setup. Furthermore, I played a vital role in mentoring and sharing my expertise with new graduate students in our project. This mentorship not only enhanced their technical skills but also instilled values of collaboration and knowledge sharing, contributing to the overall success of our research team. 

<div align="center">
  <img src="FPGA_RadiationSystem.png" alt="FPGA Setup" width="600" height="300">
  <p><em>Caption: FPGA Radiation Test System.</em></p>
</div>

# Results

<div align="center">
  <img src="fluence.png" alt="Fluence" width="900" height="500"/>
  <p><em>Caption: Fluence (n/cm^2) for two FPGA boards under test and show similar fluence rates. All SEU Errors are shown and has even distribution. > 20 MeV is close to > 10 MeV energies. The fluence values are used to calculate average flux.</em></p>
</div>

<div align="center">
  <img src="aveflux.png" alt="Average Flux" width="900" height="500">
  <p><em>Caption: Average Flux (n/cm^2/s) for two FPGA boards under test, it summarizes different SEU errors that occurred during the beam test and they show optimistic results.</em></p>
</div>
