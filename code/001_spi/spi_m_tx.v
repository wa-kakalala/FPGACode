`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Engineer: wkk
// 
// Create Date: 2023/03/26 15:24:41
// Design Name: 
// Module Name: spi_tx
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////

module spi_m_tx # (
    parameter CPOL          =    1'b0        ,        // clock polarity
    parameter CPHA          =    1'b0        ,        // clock phase -> simple time
    parameter MAX_COUNT     =       3        ,
    parameter COUNT_BITS    =       12
)(
    input           i_clk                   ,
    input           i_rst_n                 ,
    input  [7:0]    i_tx_data               ,
    input           i_tx_data_valid         ,
    output          o_spi_tx                ,
    output          o_spi_clk               ,
    output          o_spi_cs_n              ,
    output          o_spi_busy              
);

localparam      COUNT_HALF       =  (MAX_COUNT >> 1)   ;  

reg  [COUNT_BITS-1:0]     time_counter               ;
wire                      time_en                    ;
wire                      half_time_en               ;

reg     [7:0]             i_tx_data_reg              ;

reg                       start_en                   ;              // start tx
reg     [3:0]             send_cnt                   ;
reg                       o_spi_clk_reg              ;
reg                       o_spi_tx_reg               ;

wire                      send_en                    ;
wire                      skip_reg                   ;            //  CPHA == 1 , skip first 


assign skip_reg = (CPHA==1)?1'b1:1'b0;

always@( posedge i_clk or negedge i_rst_n ) begin
    if( !i_rst_n || !start_en) begin
        send_cnt = 1'b0;
    end 
    else if(send_en) begin
        send_cnt <= send_cnt + 1;
    end else
        send_cnt <= send_cnt ;
end

always @( posedge i_clk or negedge i_rst_n ) begin
    if( !i_rst_n) begin
        i_tx_data_reg <= 8'b0;
    end 
    else if( i_tx_data_valid ) begin
        i_tx_data_reg <= i_tx_data;
    end
    else if(send_en)begin
        if( send_cnt < skip_reg) 
            i_tx_data_reg <= i_tx_data_reg;
        else
            i_tx_data_reg <= {i_tx_data_reg[6:0],1'b0};
    end 
    else begin
        i_tx_data_reg <= i_tx_data_reg;
    end
end

always @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n || !start_en )
        o_spi_tx_reg <= 1'b0;
    else 
        o_spi_tx_reg <= i_tx_data_reg[7];
end

always @( posedge i_clk or negedge i_rst_n ) begin
    if( !i_rst_n || send_cnt == 4'd9 || send_cnt == 4'd8 && skip_reg == 1'b0) begin
        start_en <= 1'b0;
    end 
    else begin
        if( i_tx_data_valid && start_en == 1'b0 ) 
            start_en <= 1'b1;
        else 
            start_en <= start_en;
    end
end  
      
assign   time_en =      ( time_counter  == MAX_COUNT -  1)?1'b1:1'b0; 
assign   half_time_en = ( time_counter  == COUNT_HALF - 1)?1'b1:1'b0; 
assign   send_en      = ( CPHA==1'b0 ) ?  time_en :half_time_en ;
always @( posedge i_clk or negedge i_rst_n ) begin
    if( !i_rst_n ) begin
        time_counter <= {COUNT_BITS{1'b0}};
    end  
    else if( start_en ) begin
        if(time_counter == MAX_COUNT - 1) 
            time_counter <= {COUNT_BITS{1'b0}};
        else 
            time_counter <= time_counter + 1'b1;
    end
    else
        time_counter <= {COUNT_BITS{1'b0}};
end

always @( posedge i_clk or negedge i_rst_n ) begin
    if( !i_rst_n )
        o_spi_clk_reg <= 1'b0;
    else if(half_time_en || time_en ) 
        o_spi_clk_reg <= ~o_spi_clk_reg;
    else
        o_spi_clk_reg <= o_spi_clk_reg;
end

assign o_spi_tx  = o_spi_tx_reg;
assign o_spi_clk = (CPOL==1'b0)?o_spi_clk_reg:~o_spi_clk_reg;
assign o_spi_busy = start_en;
assign o_spi_cs_n = ~start_en;
endmodule