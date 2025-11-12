LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY lcd_dma IS
   PORT ( -- Here the internal interface is defined
          Clock                       : IN  std_logic;
          Reset                       : IN  std_logic;
          
          -- Here the avalon slave interface is defined
          slave_address               : IN  std_logic_vector( 2 DOWNTO 0 );
          slave_cs                    : IN  std_logic;
          slave_we                    : IN  std_logic;
          slave_rd                    : IN  std_logic;
          slave_write_data            : IN  std_logic_vector(31 DOWNTO 0 );
          slave_read_data             : OUT std_logic_vector(31 DOWNTO 0 );
          slave_wait_request          : OUT std_logic;
          
          -- master avalon interface
          master_address              : OUT std_logic_vector(31 DOWNTO 0 );
          master_read                 : OUT std_logic;
          master_burst_count          : OUT std_logic_vector( 7 DOWNTO 0 );
          master_read_data            : IN  std_logic_vector(31 DOWNTO 0 );
          master_read_data_valid      : IN  std_logic;
          master_wait_request         : IN  std_logic;

          -- irq signal
          end_of_transaction_irq      : OUT std_logic;

          -- Here the external LCD-panel signals are defined
          ChipSelectBar               : OUT std_logic;
          DataCommandBar              : OUT std_logic;
          WriteBar                    : OUT std_logic;
          ReadBar                     : OUT std_logic;
          ResetBar                    : OUT std_logic;
          IM0                         : OUT std_logic;
          DataBus                     : INOUT std_logic_vector( 15 DOWNTO 0 ));
END lcd_dma;

     -------- register model -----------
     -- 000  write: Write a command to LCD
     --      read :  Read a command from LCD
     -- 001  write: Write data to LCD
     --      read : Read data from LCD
     -- 010  r/w  : Control register
     --             bit 0  => Select 0 => Sixteen bit transfer
     --                       Select 1 => Eight bit transfer
     --             bit 1  => Busy flag (read only)
     --                       Reset LCD Display (write only)
     --             bit 2  => DMA transfer in progress (read only)
     --             bit 3  => 0 -> RGB565 mode
     --                       1 -> RGB888 mode
     --             bit 4  => 0 -> color transfer 
     --                       1 -> grayscale transfer
     --             bit 5  => 0 -> IRQ disabled
     --                    => 1 -> IRQ enabled
     --             bit 6  => IRQ status (read only)
     --             bit 8  => Start DMA transfer (write only)
     --             bit 9  => clear irq (write only)
     --             others => 0
     -- 011  Picture start address (pointer to image)
     -- 100  Picture size in pixels
     -- 101  Nr. of Pixels each line of LCD
     -- 110  Nr. of Pixels each line of Image
