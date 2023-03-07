# FPGACode
## water_led

流水灯程序

![在这里插入图片描述](https://img-blog.csdnimg.cn/d7bfaf1895d5453785c808d55a74887d.png)

```verilog
parameter   INPUT_CLK    =  27_000_000  ,   // input clk frequency
parameter   LED_NUM      =  6           ,   // led quantity
parameter   COUNT_WIDTH  =  36          ,   // time counter bit quantity
parameter   COUNT_MAX    =  27_000_000  ,   // max count value
// LED MODE 1 ? 0 -> on       
parameter   LED_MODE     =  0   // led control mode: if 1 --> led on  or  0 --> led on      
```

