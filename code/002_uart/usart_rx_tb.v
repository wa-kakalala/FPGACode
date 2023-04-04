`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/15 10:03:32
// Design Name: 
// Module Name: usart_rx_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module usart_rx_tb();
reg i_clk;
reg i_rst_n;
reg i_data;
wire  [7:0] o_data;
wire o_data_valid;

uart_rx#(
.I_CLK_FREQ(10),
.BAUDRATE  (2)
)uart_rx_inst(
    i_clk ,
    i_rst_n,
    i_data,
    o_data,
    o_data_valid    
);

initial begin
    i_clk = 1'b0;
    i_rst_n = 1'b0;
    i_data  = 1'b1;
end
always #5 i_clk = ~i_clk;

initial begin
    $display("start\r\n--------------------");
    $monitor($time,"o_data_valid: %b",o_data_valid );
    #10 i_rst_n = 1'b1;
    #50 i_data = 1'b0;
    
    #50 i_data = 1'b1;
    #50 i_data = 1'b0;
    #50 i_data = 1'b1;
    #50 i_data = 1'b0;
    #50 i_data = 1'b1;
    #50 i_data = 1'b1;
    #50 i_data = 1'b1;
    #50 i_data = 1'b0;

    #50 i_data = 1'b1;
    #50
    //01110101
    #100;
    $stop;
    

end

endmodule
