LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY pixel_formatter IS
   PORT ( -- Here the internal interface is defined
          Clock                       : IN  std_logic;
          Reset                       : IN  std_logic;
          StartTransfer               : IN  std_logic;
          Busy                        : OUT std_logic;
          GenerateIrq                 : OUT std_logic;
          
          -- Here the register interface is defined
          ImageSize                   : IN  std_logic_vector(19 DOWNTO 0);
          ImagePointer                : IN  std_logic_vector(31 DOWNTO 2);
          ImageXSize                  : IN  std_logic_vector(11 DOWNTO 0);
          EightSixteenBar             : IN  std_logic;
          RGB888RGB565Bar             : IN  std_logic;
          GrayscaleColorBar           : IN  std_logic;
          
          -- Here the DMA-interface signals are defined
          StartDMA                    : OUT std_logic;
          DMAAddress                  : OUT std_logic_vector(31 DOWNTO 2);
          DMABusy                     : IN  std_logic;
          DMAFifoEmpty                : IN  std_logic;
          DMAFifoPop                  : OUT std_logic;
          DMAFifoDataIn               : IN  std_logic_vector(31 DOWNTO 0);
          
          -- Here the LCD-interface signals are defined
          LCDStartSendReceive         : OUT std_logic;
          LCDCommandBarData           : OUT std_logic;
          LCDWriteReadBar             : OUT std_logic;
          LCDDataToSend               : OUT std_logic_vector( 15 DOWNTO 0 );
          LCDBusy                     : IN  std_logic);
END pixel_formatter;

-- Currently only the color mode, sixteen bit, RGB565  and
--                the grayscale , sixteen bit is supported!
