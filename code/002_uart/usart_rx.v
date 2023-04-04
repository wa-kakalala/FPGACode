`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Engineer: wkk
// 
// Create Date: 2023/03/15 09:37:21
// Design Name: 
// Module Name: uart_rx
// 
//////////////////////////////////////////////////////////////////////////////////
module uart_rx(
    input          i_clk ,
    input          i_rst_n,
    input          i_data,
    output [7:0]   o_data,
    output         o_data_valid    
);

parameter       I_CLK_FREQ   =  27_000_000       ;
parameter       BAUDRATE     =  115200           ;
parameter       COUNTER_LEN  =  12               ;
localparam      COUNT_MAX    =  I_CLK_FREQ / BAUDRATE ;
reg             i_data_d0       ;
reg             i_data_d1       ;
wire            i_data_negedge_valid  ;

reg             start_rx        ; // 开始接收
reg [4:0]       bit_index       ;

reg [COUNTER_LEN-1:0]       time_counter              ;
wire                        counter_en                ;
wire                        counter_half_en           ;

reg [7:0]                   o_data_reg                ;
// 检测下降沿
assign i_data_negedge_valid = i_data_d1 & (~i_data_d0);
always @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n ) begin
        i_data_d0 <= 1'b1;
        i_data_d1 <= 1'b1;
    end else begin
        i_data_d0 <= i_data;
        i_data_d1 <= i_data_d0;
    end
end

// 开始信号
always @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n ) 
        start_rx <= 1'b0;
    else if(start_rx == 1'b0 && i_data_negedge_valid)
            start_rx <= 1'b1;
    else if(start_rx == 1'b1 && bit_index== 4'd9)
            start_rx <= 1'b0;
    else
        start_rx <= start_rx;
end

assign counter_half_en = (time_counter == (COUNT_MAX >> 1 ));
assign counter_en = (time_counter == COUNT_MAX-1);
// 计时器
always @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n )
        time_counter <= {COUNTER_LEN{1'b0}};
    else if(start_rx) 
        if(time_counter == COUNT_MAX-1) 
            time_counter <= {COUNTER_LEN{1'b0}};
        else
            time_counter <= time_counter+1'b1;
    else
        time_counter <= {COUNTER_LEN{1'b0}};
end
// bit_index 控制
always @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n ) 
        bit_index <= 4'b0;
    else if(start_rx) 
        if(counter_en)
            bit_index <= bit_index + 4'b1;
        else
            bit_index <= bit_index;
    else
        bit_index <= 4'b0;
end

//输出
always @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n ) 
        o_data_reg <= 7'b0;
    else if( counter_half_en )
    case ( bit_index )
        4'd1:
            o_data_reg[0] <= i_data_d0;
        4'd2:
            o_data_reg[1] <= i_data_d0;
        4'd3:
            o_data_reg[2] <= i_data_d0;
        4'd4:
            o_data_reg[3] <= i_data_d0;
        4'd5:
            o_data_reg[4] <= i_data_d0;
        4'd6:
            o_data_reg[5] <= i_data_d0;
        4'd7:
            o_data_reg[6] <= i_data_d0;
        4'd8:
            o_data_reg[7] <= i_data_d0;
        default:
            o_data_reg <= o_data_reg;
    endcase
    else
        o_data_reg <= o_data_reg;
end

assign o_data_valid = (bit_index== 4'd9);
assign o_data  = o_data_reg;

endmodule