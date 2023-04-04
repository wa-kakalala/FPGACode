`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  wkk
// 
// Create Date: 2023/03/14 23:52:48
// Design Name: 
// Module Name: usart_tx_tb
// Project Name:  
//////////////////////////////////////////////////////////////////////////////////


module usart_tx_tb();
reg i_clk                   ;
reg i_rst_n                 ;
reg [7:0] i_data            ;
reg i_data_valid            ;
wire o_data                 ;

uart_tx # (
    .I_CLK         (20),
    .BAUDRATE      (10)  
)uart_tx_inst(
   i_clk                   ,
   i_rst_n                 ,
   i_data                  ,
   i_data_valid            ,
   o_data     
);

initial begin
    i_clk = 1'b0;
    i_rst_n = 1'b0;
    i_data_valid = 1'b0;
end

always #10 i_clk = ~i_clk;

initial begin
    #20;
    i_rst_n = 1'b1;
    #20;
    i_data = 8'b10110001;
    i_data_valid= 1'b1;
    #20
    i_data_valid = 1'b0;
    #500;
    i_data = 8'b11111111;
    i_data_valid= 1'b1;
    #20
    i_data_valid = 1'b0;
    
    $monitor($time,"\to_data: %b",o_data);
    #100;
    $stop;   
end

    
endmodule
