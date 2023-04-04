`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: wkk
// 
// Create Date: 2023/03/15 15:35:05
// Design Name: 
// Module Name: usart_demo
//
/////////////////////////////////////////////////////////////////////////////////
module usart_demo(
    input       i_clk           ,
    input       i_rst_n         ,
    input       i_data          ,
    output      o_data      
);

parameter I_CLK_FREQ =  100_000_000   ;
parameter BAUDRATE   =  115200       ;

wire  [7:0]         data;
wire                data_valid;


uart_rx#(
     .I_CLK_FREQ(I_CLK_FREQ),
     .BAUDRATE(BAUDRATE)   
)uart_rx_inst(
   .i_clk            (i_clk),
   .i_rst_n          (i_rst_n),
   .i_data           (i_data),
   .o_data           (data),
   .o_data_valid     (data_valid)
);

uart_tx#(
    .I_CLK_FREQ(I_CLK_FREQ),
    .BAUDRATE(BAUDRATE)   
)uart_tx_inst(
    .i_clk                   (i_clk),
    .i_rst_n                 (i_rst_n),
    .i_data                  (data),
    .i_data_valid            (data_valid),
    .o_data                  (o_data)
);

endmodule
