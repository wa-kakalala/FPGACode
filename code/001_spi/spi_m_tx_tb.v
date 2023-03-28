`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Engineer:  wkk 
//
// Create Date: 2023/03/27 11:05:50
// Design Name: 
// Module Name: spi_tx_tb
//////////////////////////////////////////////////////////////////////////////////

module spi_m_tx_tb();

 reg           i_clk                   ;           
 reg           i_rst_n                 ;           
 reg  [7:0]    i_tx_data               ;           
 reg           i_tx_data_valid         ;        
 wire          o_spi_tx                ;
 wire          o_spi_clk               ;      
 wire          o_spi_cs_n              ;
 wire          o_spi_busy              ;                      

spi_m_tx # (
   .CPOL         (  1'b1        ),        // clock polarity
   .CPHA         (  1'b0        ),        // clock phase
   .MAX_COUNT    (     4        ),
   .COUNT_BITS   (     12       )
)spi_m_tx_inst(
   .i_clk                  ( i_clk            ),
   .i_rst_n                ( i_rst_n          ),
   .i_tx_data              ( i_tx_data        ),
   .i_tx_data_valid        ( i_tx_data_valid  ),
   .o_spi_tx               ( o_spi_tx         ),
   .o_spi_clk              (o_spi_clk         ),
   .o_spi_cs_n             (o_spi_cs_n        ),
   .o_spi_busy             (o_spi_busy        )
);

initial begin
    i_clk = 1'b0;
    i_rst_n = 1'b0;
    forever #5 i_clk = ~i_clk;
end

initial  begin
    #10 i_rst_n = 1'b1;
    #20 i_tx_data = 8'b10101101; i_tx_data_valid = 1'b1;
    #10 i_tx_data_valid = 1'b0;
    #1000 $stop;

end
endmodule