# Clock constraints

# 50MHzClk: 50 MHz
create_clock -name {50MHzClk} -period 20.000 -waveform {0.000 10.000} [get_ports {50MHzClk}]
# CAM_PCLK: 24 MHz
create_clock -name {CAM_PCLK} -period 41.667 -waveform {0.000 20.833} [get_ports {CAM_PCLK}]
# Separate unrelated clock domains
set_clock_groups -asynchronous -group {50MHzClk} -group {CAM_PCLK}
