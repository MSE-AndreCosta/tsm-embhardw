LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY SendReceiveInterface IS
   PORT ( -- Here the internal interface is defined
          Clock                 : IN  std_logic;
          Reset                 : IN  std_logic;
          ResetDisplay          : IN  std_logic;
          StartSendReceive      : IN  std_logic;
          CommandBarData        : IN  std_logic;
          EightBitSixteenBitBar : IN  std_logic;
          WriteReadBar          : IN  std_logic;
          DataToSend            : IN  std_logic_vector( 15 DOWNTO 0 );
          DataReceived          : OUT std_logic_vector( 15 DOWNTO 0 );
          busy                  : OUT std_logic;
          
          -- Here the external LCD-panel signals are defined
          ChipSelectBar         : OUT std_logic;
          DataCommandBar        : OUT std_logic;
          WriteBar              : OUT std_logic;
          ReadBar               : OUT std_logic;
          ResetBar              : OUT std_logic;
          IM0                   : OUT std_logic;
          DataBus               : INOUT std_logic_vector( 15 DOWNTO 0 ));
END SendReceiveInterface;
