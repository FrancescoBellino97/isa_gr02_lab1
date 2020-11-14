library verilog;
use verilog.vl_types.all;
entity IIR_filter_order2 is
    port(
        Clk             : in     vl_logic;
        DIN             : in     vl_logic_vector(10 downto 0);
        VIN             : in     vl_logic;
        Rst_n           : in     vl_logic;
        Vout            : out    vl_logic;
        DOUT            : out    vl_logic_vector(10 downto 0)
    );
end IIR_filter_order2;
