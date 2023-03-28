`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: wkk
// 
// Create Date: 2023/03/27 17:32:32
// Design Name: 
// Module Name: water_led_tb
//////////////////////////////////////////////////////////////////////////////////

module water_led_tb();

reg clk;
reg rst_n;
wire [5:0]  led;

water_led #(
    .LED_NUM(6),
    .COUNT_WIDTH(2),
    .COUNT_MAX(2),
    .LED_MODE(1)
)water_led_inst(
    .clk        (clk),
    .rst_n      (rst_n),
    .led        (led)
);

initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    #10 rst_n = 1'b1;
    #1000 $stop;
end

endmodule