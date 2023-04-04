`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  wkk
// 
// Create Date: 2023/03/15 15:43:27
// Design Name: 
// Module Name: usart_demo_tb
// 
//////////////////////////////////////////////////////////////////////////////////


module usart_demo_tb();
reg     i_clk    ;
reg     i_rst_n  ;
reg     i_data   ;
wire    o_data   ;

usart_demo usart_demo_inst(
     i_clk           ,
     i_rst_n         ,
     i_data          ,
     o_data      
);

initial  begin
    i_clk = 1'b0;
    i_rst_n  = 1'b0;
end

always #5 i_clk = ~i_clk;

initial  begin
    #10 i_rst_n = 1'b1;
    #20 i_data  = 1'b0;
    
    #50 i_data  = 1'b1;
    #50 i_data  = 1'b1;
    #50 i_data  = 1'b0;
    #50 i_data  = 1'b1;
    #50 i_data  = 1'b0;
    #50 i_data  = 1'b0;
    #50 i_data  = 1'b1;
    #50 i_data  = 1'b1;
    
    #50 i_data  = 1'b1;
    
    #100 $stop;
end


endmodule
