`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Engineer: wkk
// 
// Create Date: 2023/03/14 22:54:49
// Design Name: 
// Module Name: uart_tx
//////////////////////////////////////////////////////////////////////////////////

module uart_tx(
    input               i_clk                   ,
    input               i_rst_n                 ,
    input   [7:0]       i_data                  ,
    input               i_data_valid            ,
    output              o_data     
);
parameter    I_CLK_FREQ     = 27_000_00                   ;
parameter    BAUDRATE       = 115200                      ;
parameter    COUNTER_LEN    = 12                          ;                    

localparam    COUNT_MAX  = I_CLK_FREQ / BAUDRATE          ;

reg         [7:0]               i_data_reg                ;
reg                             i_data_reg_valid          ;

reg                             start_tx                  ;
reg         [3:0]               bit_num                   ;
reg                             o_data_reg                ;
reg         [COUNTER_LEN-1:0]   time_counter              ;
wire                            time_counter_en           ;


// 缓存数据
always @(posedge i_clk or negedge i_rst_n)  begin
    if(! i_rst_n ) begin
        i_data_reg <= 7'b0;
        i_data_reg_valid <= 1'b0;
    end 
    else if( i_data_valid ) begin
        i_data_reg <= i_data;
        i_data_reg_valid <= 1'b1;
    end
    else begin
        i_data_reg <= i_data_reg;
        i_data_reg_valid <= 1'b0;
    end
end

always @(posedge i_clk or negedge i_rst_n)begin
     if(! i_rst_n )
        start_tx <= 1'b0;
     else if(i_data_reg_valid) 
        start_tx <= 1'b1;
     else if(bit_num == 4'd9)
        start_tx <= 1'b0;
     else
        start_tx <= start_tx;
end

assign time_counter_en = (time_counter == COUNT_MAX -1) ? 1'b1 :1'b0;
always @(posedge i_clk or negedge i_rst_n) begin
    if(! i_rst_n )
        time_counter <= {COUNTER_LEN{1'b0}};
    else if( start_tx )
        if(time_counter == COUNT_MAX -1 ) 
            time_counter <= {COUNTER_LEN{1'b0}};
        else
            time_counter <= time_counter + 1'b1;
    else
        time_counter <= {COUNTER_LEN{1'b0}};
end

always @(posedge i_clk or negedge i_rst_n) begin
    if(! i_rst_n )
        bit_num <= 4'b0;
    else if( start_tx )
        if( time_counter_en )
            bit_num <= bit_num +1'b1;
        else
            bit_num <= bit_num;
    else
        bit_num <= 4'b0;
end


always @(posedge i_clk or negedge i_rst_n) begin
    if(! i_rst_n )
        o_data_reg <= 1'b1;
    else if( start_tx )
        case( bit_num)
           4'd0: o_data_reg <= 1'b0;
           4'd1: o_data_reg <= i_data_reg[0];
           4'd2: o_data_reg <= i_data_reg[1];
           4'd3: o_data_reg <= i_data_reg[2];
           4'd4: o_data_reg <= i_data_reg[3];
           4'd5: o_data_reg <= i_data_reg[4];
           4'd6: o_data_reg <= i_data_reg[5];
           4'd7: o_data_reg <= i_data_reg[6];
           4'd8: o_data_reg <= i_data_reg[7];
           4'd9: o_data_reg <= 1'b1;
           default: o_data_reg <= 1'b1;
        endcase
    else
        o_data_reg = 1'b1;
end
assign o_data = o_data_reg;

endmodule
