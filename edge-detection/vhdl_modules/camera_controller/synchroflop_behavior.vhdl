ARCHITECTURE behave OF synchro_flop IS

   SIGNAL s_delay_line : std_logic_vector( 2 DOWNTO 0 );

BEGIN
   tick_out <= s_delay_line(2);

   del1 : PROCESS( clock_in , s_delay_line , tick_in ,
                   reset )
   BEGIN
      IF (s_delay_line(2) = '1' OR
          reset = '1') THEN s_delay_line(0) <= '0';
      ELSIF (rising_edge(clock_in)) THEN
         s_delay_line(0) <= s_delay_line(0) OR tick_in;
      END IF;
   END PROCESS del1;
   
   del2 : PROCESS( clock_out , s_delay_line , reset )
   BEGIN
      IF (s_delay_line(2) = '1' OR
          reset = '1') THEN s_delay_line(1) <= '0';
      ELSIF (rising_edge(clock_out)) THEN
         s_delay_line(1) <= s_delay_line(0);
      END IF;
   END PROCESS del2;
   
   del3 : PROCESS( clock_out , reset , s_delay_line )
   BEGIN
      IF (reset = '1') THEN s_delay_line(2) <= '0';
      ELSIF (rising_edge(clock_out)) THEN
         s_delay_line(2) <= s_delay_line(1);
      END IF;
   END PROCESS del3;
   
END behave;

