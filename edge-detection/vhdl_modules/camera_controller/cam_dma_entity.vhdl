LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY cam_dma IS
   PORT ( -- Here the internal interface is defined
          Clock                 : IN  std_logic;
          Reset                 : IN  std_logic;
          
          IRQ                   : OUT std_logic;
          
          -- Here the avalon slave interface is defined
          slave_address         : IN  std_logic_vector( 2 DOWNTO 0 );
          slave_cs              : IN  std_logic;
          slave_we              : IN  std_logic;
          slave_write_data      : IN  std_logic_vector(31 DOWNTO 0 );
          slave_read_data       : OUT std_logic_vector(31 DOWNTO 0 );
          
          -- Here the avalon master interface is defined
          master_address        : OUT std_logic_vector(31 DOWNTO 0 );
          master_we             : OUT std_logic;
          master_write_data     : OUT std_logic_vector(31 DOWNTO 0 );
          master_burst_count    : OUT std_logic_vector( 9 DOWNTO 0 );
          master_wait_req       : IN  std_logic;
          
          -- Here the camera interface is defined
          PixelClk              : IN  std_logic;
          HSync                 : IN  std_logic;
          VSync                 : IN  std_logic;
          DataIn                : IN  std_logic_vector( 9 DOWNTO 0 );
          ResetBar              : OUT std_logic;
          PowerDown             : OUT std_logic);
END cam_dma;

     -------- register model -----------
     -- 000 Nr. of bytes each line (read only)
     -- 001 Nr. of lines each frame (read only)
     -- 010 Nr. of frames each second (read only)
     -- 011 Control register
     --     bit 0 => Reset bit (1 -> reset, 0 -> no reset)
     --     bit 1 => Power down bit (0 -> normal operation, 1 -> Pwr down)
     --     bit 2 => Profiling data valid bit (read only)
     --     bit 3 => Take One Picture (Write only)
     --              Busy taking Picture(s) (Read only)
     --     bit 4 => Start Continues Mode (Write only)
     --              In continues mode (Read only)
     --     bit 5 => Stop Continues Mode (Write only)
     --     bit 6 => Enable avalon IRQ (Write only)
     --              avalon IRQ Enabled (Read only)
     --     bit 7 => Disable avalon IRQ (Write only)
     --              IRQ Generated [indicates new picture even if the
     --                             avalon IRQ is disabled; needs to
     --                             be reseted by the clear IRQ command
     --                             {see bit 8}] (Read only)
     --     bit 8 => Clear IRQ (Write only)
     --     bit 9 => Current Image valid (read only)
     -- 100 write: buffer 1 address
     --     read: address of buffer containing current image
     -- 101 write: buffer 2 address
     --     read: address of buffer containing current image
     -- 110 write: buffer 3 address
     --     read: address of buffer containing current image
     -- 111 write: buffer 4 address
     --     read: address of buffer containing current image
