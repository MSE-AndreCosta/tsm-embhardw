LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY i2c_core IS
   PORT ( clock              : IN    std_logic;
          reset              : IN    std_logic;
          irq                : OUT   std_logic;
          -- slave avalon interface
          slave_address      : IN    std_logic_vector( 1 DOWNTO 0 );
          slave_cs           : IN    std_logic;
          slave_we           : IN    std_logic;
          slave_write_data   : IN    std_logic_vector(31 DOWNTO 0 );
          slave_byte_enables : IN    std_logic_vector( 3 DOWNTO 0 );
          slave_read_data    : OUT   std_logic_vector(31 DOWNTO 0 );
          -- i2c buses
          SDA                : INOUT std_logic;
          SCL                : OUT   std_logic);
END i2c_core;

   -------- register model -----------
   -- 00 Write: I2c Device Identifyer (used also for autodetection index)
   --    Read:  Detected device Identifyer indexed by I2c Device Identifyer
   -- 01 Write: I2c Device Address Read: Nr. of devices detected
   -- 10 Write: I2c Data to send Read: I2C Data received from device
   -- 11 Write: Control register
   --           Bit 0 => Two-phase bit (0 -> 3 byte transfer, 1 -> two byte
   --                                   transfer)
   --           Bit 1 => Start I2C transfer
   --           Bit 2 => Start I2C autodetect
   --           Bit 3 => Clear I2C IRQ
   --           Bit 5 => Four data read
   --           Bit 6 => Send 2 byte address and 2 byte data
   --           Bit 15..8 => prescale value (0 = 400Khz, 255=1562.5Hz)
   --           Bit 16 => Enable(1)/Disable(0) I2C IRQ generation
   --    Read:  Status register
   --           Bit 0  => I2C transfer in progress
   --           Bit 1  => I2C autodetection in progress
   --           Bit 2  => I2C device ID ack-error
   --           Bit 3  => I2C address ack-error
   --           Bit 4  => I2C data ack-error
   --           Bit 8  => I2C irq generated
   --           Bit 10 => I2C IRQ enabled(1)/disabled(0)
   
