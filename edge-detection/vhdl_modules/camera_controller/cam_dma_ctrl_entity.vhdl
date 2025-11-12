LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY cam_dma_ctrl IS
   PORT ( Clock                    : IN  std_logic;
          Reset                    : IN  std_logic;
          CamRstBar                : IN  std_logic;
          PixelIFReset             : OUT std_logic;
          
          NextLine                 : IN  std_logic;
          NextFrame                : IN  std_logic;
          
          PixelData                : IN  std_logic_vector( 31 DOWNTO 0 );
          NrOfWords                : IN  std_logic_vector(  9 DOWNTO 0 );
          Pop                      : OUT std_logic;
          
          startstreaming           : IN  std_logic;
          stopstreaming            : IN  std_logic;
          startsingleimage         : IN  std_logic;
          quad_buffering           : IN  std_logic;
          MemoryPointer1           : IN  std_logic_vector( 32 DOWNTO 2 );
          MemoryPointer2           : IN  std_logic_vector( 32 DOWNTO 2 );
          MemoryPointer3           : IN  std_logic_vector( 32 DOWNTO 2 );
          MemoryPointer4           : IN  std_logic_vector( 32 DOWNTO 2 );
          CurrentImagePointer      : OUT std_logic_vector( 32 DOWNTO 2 );
          CoreBusy                 : OUT std_logic;
          GenIrq                   : OUT std_logic;
          InStreamingMode          : OUT std_logic;
          
          -- master avalon interface
          master_address           : OUT std_logic_vector(31 DOWNTO 0 );
          master_we                : OUT std_logic;
          master_write_data        : OUT std_logic_vector(31 DOWNTO 0 );
          master_burst_count       : OUT std_logic_vector( 9 DOWNTO 0 );
          master_wait_req          : IN  std_logic);
END cam_dma_ctrl;
          
          
