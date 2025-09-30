	tools u0 (
		.clk_i_clk                       (<connected-to-clk_i_clk>),                       //                    clk_i.clk
		.leds_external_connection_export (<connected-to-leds_external_connection_export>), // leds_external_connection.export
		.pll_sdram_clk_clk               (<connected-to-pll_sdram_clk_clk>),               //            pll_sdram_clk.clk
		.reset_i_reset_n                 (<connected-to-reset_i_reset_n>),                 //                  reset_i.reset_n
		.sdram_controller_wire_addr      (<connected-to-sdram_controller_wire_addr>),      //    sdram_controller_wire.addr
		.sdram_controller_wire_ba        (<connected-to-sdram_controller_wire_ba>),        //                         .ba
		.sdram_controller_wire_cas_n     (<connected-to-sdram_controller_wire_cas_n>),     //                         .cas_n
		.sdram_controller_wire_cke       (<connected-to-sdram_controller_wire_cke>),       //                         .cke
		.sdram_controller_wire_cs_n      (<connected-to-sdram_controller_wire_cs_n>),      //                         .cs_n
		.sdram_controller_wire_dq        (<connected-to-sdram_controller_wire_dq>),        //                         .dq
		.sdram_controller_wire_dqm       (<connected-to-sdram_controller_wire_dqm>),       //                         .dqm
		.sdram_controller_wire_ras_n     (<connected-to-sdram_controller_wire_ras_n>),     //                         .ras_n
		.sdram_controller_wire_we_n      (<connected-to-sdram_controller_wire_we_n>)       //                         .we_n
	);

