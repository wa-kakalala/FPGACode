// author : wkk

module WaterLed#(
    parameter   INPUT_CLK    =     27_000_000       ,   // input clk frequency
    parameter   LED_NUM      =     6                ,   // led quantity
    parameter   COUNT_WIDTH  =     36               ,   // time counter bit quantity
    parameter   COUNT_MAX    =     27_000_000       ,   // max count value
    // LED MODE 1 ? 0 -> on       
    parameter   LED_MODE     =     0                    // led control mode: if 1 --> led on  or  0 --> led on                     

)(
    input                                       clk                     ,
    input                                       rst_n                   ,

    output      [LED_NUM-1:0]                   led                     
);


reg     [LED_NUM-1: 0]     curr_state                   ;
reg     [LED_NUM-1: 0]     next_state                   ;
reg     [LED_NUM-1:0]      led_out                      ;

reg                        time_en                      ;
reg     [COUNT_WIDTH-1:0]  time_count                   ;


always  @(posedge   clk or negedge rst_n) begin 
    if( !rst_n ) begin
        time_count <= {COUNT_WIDTH{1'b0}};
        time_en    <=  1'b0;
    end
    else begin
        if( time_count == COUNT_MAX) begin
            time_count <= {COUNT_WIDTH{1'b0}};
            time_en    <= 1'b1;
        end 
        else begin
            time_en    <= 1'b0;
            time_count <= time_count + 1'b1;
        end

    end
end

always @(posedge clk or negedge rst_n) begin
    if( !rst_n ) 
          curr_state <=  {{(LED_NUM-1){1'b0}},1'b1};
    else
          curr_state <= next_state;

end

always @(*) begin
    if(!rst_n )
        next_state = {{(LED_NUM-1){1'b0}},1'b1};
    else begin
        if( time_en )  
            next_state = {curr_state[LED_NUM-2:0],curr_state[LED_NUM-1]};
        else
            next_state = curr_state;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n ) 
        led_out <= {LED_NUM{1'b0}};
    else begin
        if( LED_MODE == 1) 
               led_out <= curr_state;
        else
               led_out <= ~curr_state;
    end
end

assign led = led_out;

endmodule





