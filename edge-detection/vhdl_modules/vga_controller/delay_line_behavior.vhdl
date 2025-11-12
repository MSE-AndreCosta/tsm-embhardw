ARCHITECTURE general OF delay_line IS

   SIGNAL s_del_next , s_del_reg : std_logic_vector( (nr_of_elements-1) DOWNTO 0);

BEGIN
   value_out <= s_del_reg(nr_of_elements-1);
   
   s_del_next(0) <= value_in;
   s_del_next((nr_of_elements-1) DOWNTO 1) <= s_del_reg((nr_of_elements-2) DOWNTO 0);
   
   make_del_reg : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_del_reg <= (OTHERS => reset_value);
                          ELSE s_del_reg <= s_del_next;
         END IF;
      END IF;
   END PROCESS make_del_reg;
END general;
