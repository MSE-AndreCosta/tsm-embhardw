# Processor
set_location_assignment PIN_T1   -to 50MHzClk
set_location_assignment PIN_E10  -to Reset

# SDRAM
set_location_assignment PIN_AA3  -to SDRAM_Clk
set_location_assignment PIN_Y4   -to SDRAM_AD[0]
set_location_assignment PIN_Y3   -to SDRAM_AD[1]
set_location_assignment PIN_W6   -to SDRAM_AD[2]
set_location_assignment PIN_Y6   -to SDRAM_AD[3]
set_location_assignment PIN_Y8   -to SDRAM_AD[4]
set_location_assignment PIN_W10  -to SDRAM_AD[5]
set_location_assignment PIN_W8   -to SDRAM_AD[6]
set_location_assignment PIN_AA4  -to SDRAM_AD[7]
set_location_assignment PIN_Y10  -to SDRAM_AD[8]
set_location_assignment PIN_Y7   -to SDRAM_AD[9]
set_location_assignment PIN_U7   -to SDRAM_AD[10]
set_location_assignment PIN_AA5  -to SDRAM_AD[11]
set_location_assignment PIN_V7   -to SDRAM_DQ[0]
set_location_assignment PIN_T8   -to SDRAM_DQ[1]
set_location_assignment PIN_U8   -to SDRAM_DQ[2]
set_location_assignment PIN_T9   -to SDRAM_DQ[3]
set_location_assignment PIN_V8   -to SDRAM_DQ[4]
set_location_assignment PIN_T10  -to SDRAM_DQ[5]
set_location_assignment PIN_U9   -to SDRAM_DQ[6]
set_location_assignment PIN_T11  -to SDRAM_DQ[7]
set_location_assignment PIN_AA7  -to SDRAM_DQ[8]
set_location_assignment PIN_AA8  -to SDRAM_DQ[9]
set_location_assignment PIN_AB7  -to SDRAM_DQ[10]
set_location_assignment PIN_AA9  -to SDRAM_DQ[11]
set_location_assignment PIN_AB8  -to SDRAM_DQ[12]
set_location_assignment PIN_AA10 -to SDRAM_DQ[13]
set_location_assignment PIN_AB9  -to SDRAM_DQ[14]
set_location_assignment PIN_AB10 -to SDRAM_DQ[15]
set_location_assignment PIN_V9   -to SDRAM_DQM[0]
set_location_assignment PIN_AB5  -to SDRAM_DQM[1]
set_location_assignment PIN_V11  -to SDRAM_BA[0]
set_location_assignment PIN_U11  -to SDRAM_BA[1]
set_location_assignment PIN_W7   -to SDRAM_CKE
set_location_assignment PIN_V6   -to SDRAM_CS_n
set_location_assignment PIN_U10  -to SDRAM_RAS_n
set_location_assignment PIN_V10  -to SDRAM_CAS_n
set_location_assignment PIN_V5   -to SDRAM_WE_n

# LCD
set_location_assignment PIN_A18  -to LCD_RESETn
set_location_assignment PIN_G14  -to LCD_CSn
set_location_assignment PIN_H14  -to LCD_D_Cn
set_location_assignment PIN_G15  -to LCD_WRn
set_location_assignment PIN_H15  -to LCD_RDn
set_location_assignment PIN_G13  -to IM0
set_location_assignment PIN_G16  -to LCD_DATA[0]
set_location_assignment PIN_E12  -to LCD_DATA[1]
set_location_assignment PIN_E13  -to LCD_DATA[2]
set_location_assignment PIN_F14  -to LCD_DATA[3]
set_location_assignment PIN_E15  -to LCD_DATA[4]
set_location_assignment PIN_F15  -to LCD_DATA[5]
set_location_assignment PIN_E16  -to LCD_DATA[6]
set_location_assignment PIN_F16  -to LCD_DATA[7]
set_location_assignment PIN_C15  -to LCD_DATA[8]
set_location_assignment PIN_D15  -to LCD_DATA[9]
set_location_assignment PIN_C17  -to LCD_DATA[10]
set_location_assignment PIN_D17  -to LCD_DATA[11]
set_location_assignment PIN_C19  -to LCD_DATA[12]
set_location_assignment PIN_D19  -to LCD_DATA[13]
set_location_assignment PIN_A16  -to LCD_DATA[14]
set_location_assignment PIN_B16  -to LCD_DATA[15]

# Camera
set_location_assignment PIN_T4   -to SCL_CAM
set_location_assignment PIN_P4   -to SDATA_CAM
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to SCL_CAM
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to SDATA_CAM
set_location_assignment PIN_V1   -to MCLK
set_location_assignment PIN_AA1  -to CAM_PWRDWN
set_location_assignment PIN_P2   -to CAM_RSTB
set_location_assignment PIN_Y2   -to CAM_D[0]
set_location_assignment PIN_Y1   -to CAM_D[1]
set_location_assignment PIN_P3   -to CAM_D[2]
set_location_assignment PIN_V3   -to CAM_D[3]
set_location_assignment PIN_M4   -to CAM_D[4]
set_location_assignment PIN_V4   -to CAM_D[5]
set_location_assignment PIN_R1   -to CAM_D[6]
set_location_assignment PIN_U1   -to CAM_D[7]
set_location_assignment PIN_R2   -to CAM_D[8]
set_location_assignment PIN_U2   -to CAM_D[9]
set_location_assignment PIN_T2   -to CAM_PCLK
set_location_assignment PIN_W2   -to CAM_VSYNC
set_location_assignment PIN_W1   -to CAM_HSYNC

# VGA
set_location_assignment PIN_M22  -to HSYNC
set_location_assignment PIN_M21  -to VSYNC
set_location_assignment PIN_B20  -to DAC_CLK
set_location_assignment PIN_K17  -to RED[0]
set_location_assignment PIN_K18  -to RED[1]
set_location_assignment PIN_D20  -to RED[2]
set_location_assignment PIN_F19  -to RED[3]
set_location_assignment PIN_H19  -to RED[4]
set_location_assignment PIN_H20  -to RED[5]
set_location_assignment PIN_K19  -to RED[6]
set_location_assignment PIN_C21  -to RED[7]
set_location_assignment PIN_C22  -to RED[8]
set_location_assignment PIN_D21  -to RED[9]
set_location_assignment PIN_L22  -to GREEN[0]
set_location_assignment PIN_L21  -to GREEN[1]
set_location_assignment PIN_K21  -to GREEN[2]
set_location_assignment PIN_J22  -to GREEN[3]
set_location_assignment PIN_J21  -to GREEN[4]
set_location_assignment PIN_H22  -to GREEN[5]
set_location_assignment PIN_H21  -to GREEN[6]
set_location_assignment PIN_F22  -to GREEN[7]
set_location_assignment PIN_F21  -to GREEN[8]
set_location_assignment PIN_D22  -to GREEN[9]
set_location_assignment PIN_J18  -to BLUE[0]
set_location_assignment PIN_J17  -to BLUE[1]
set_location_assignment PIN_H18  -to BLUE[2]
set_location_assignment PIN_H17  -to BLUE[3]
set_location_assignment PIN_G17  -to BLUE[4]
set_location_assignment PIN_F17  -to BLUE[5]
set_location_assignment PIN_H16  -to BLUE[6]
set_location_assignment PIN_A20  -to BLUE[7]
set_location_assignment PIN_B19  -to BLUE[8]
set_location_assignment PIN_A19  -to BLUE[9]

# Dip switches
set_location_assignment PIN_B11  -to DIPSW[0]
set_location_assignment PIN_A11  -to DIPSW[1]
set_location_assignment PIN_B12  -to DIPSW[2]
set_location_assignment PIN_A12  -to DIPSW[3]
set_location_assignment PIN_AA12 -to DIPSW[4]
set_location_assignment PIN_AB12 -to DIPSW[5]
set_location_assignment PIN_AA11 -to DIPSW[6]
set_location_assignment PIN_AB11 -to DIPSW[7]
