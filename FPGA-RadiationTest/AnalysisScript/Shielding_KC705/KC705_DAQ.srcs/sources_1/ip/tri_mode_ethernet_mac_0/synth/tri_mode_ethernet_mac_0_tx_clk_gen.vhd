--------------------------------------------------------------------------------
-- Title      : Transmitter Clock Generator
-- Project    : Tri-Mode Ethernet MAC
--------------------------------------------------------------------------------
-- File       : tri_mode_ethernet_mac_0_tx_clk_gen.vhd
-- Author     : Xilinx Inc.
-- -----------------------------------------------------------------------------
-- (c) Copyright 2004-2013 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- -----------------------------------------------------------------------------
-- Description:  This module takes CLK (GTX_CLK from top level) and generates
--               the clocks needed to run the TX portion of the TEMAC.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity tri_mode_ethernet_mac_0_tx_clk_gen is
   port (
      reset                   : in  std_logic;   -- Global Asynchronous Reset
      clk                     : in  std_logic;   -- Global clock, always at 125Mhz
      mii_tx_clk              : in  std_logic;   -- 10/100 clock from PHY, at 25 Mhz or 2.5Mhz
      speed_is_10_100         : in  std_logic;   -- decode from speed register bits                                 
      tx_gmii_mii_clk         : out std_logic    -- For running the GMII/MII blocks
   );

end tri_mode_ethernet_mac_0_tx_clk_gen;

architecture rtl of tri_mode_ethernet_mac_0_tx_clk_gen is

   signal mii_tx_clk_ibuf     : std_logic;
   
  
begin

   ------------------------------------------------------------------------------
   -- Input/Output Buffers
   ------------------------------------------------------------------------------
   mii_tx_clk_ibuf_i : IBUF  
   port map (
      I              => mii_tx_clk,
      O              => mii_tx_clk_ibuf
   );

   -----------------------------------------------------------------------------
   -- Generate TX_GMII_MII_CLK.
   -- At 1000Mb/s we select GTX_CLK (CLK) to provide this. At 10/100 we use
   -- the MII interface clock (MII_TX_CLK) sourced by the PHY.
   -----------------------------------------------------------------------------

   BUFGMUX_SPEED_CLK : BUFGMUX
   generic map (
      CLK_SEL_TYPE            => "ASYNC"
   )
   port map (
      O                       => tx_gmii_mii_clk,
      I0                      => clk,
      I1                      => mii_tx_clk_ibuf,
      S                       => speed_is_10_100
   );


end rtl;

