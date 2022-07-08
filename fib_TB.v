`timescale 1ns/1ns

module TestBench();
    reg Start_s, Clk_s, Rst_s;
    reg [9:0]Number_s;
    wire [9:0]Result_s;
    wire Done_s;
    integer Index;

    Fib_Seq FibTest(Start_s, Clk_s, Rst_s, Number_s, Result_s, Done_s);

    //Clock Procedure
    always begin
        Clk_s <= 1'b0;
        #10;
        Clk_s <= 1'b1;
        #10;
    end

    //Vector Procedure
    initial begin
        for (Index = 1; Index < 100; Index = Index + 1) begin
            Rst_s <= 1'b1;
            Start_s <= 1'b0;
            Number_s <= Index;
            @(posedge Clk_s);

            //current state is wait
            Rst_s <= 1'b0;
            Start_s <= 1'b1;
            @(posedge Clk_s); 

            //from s1 ~ s4
            while(Done_s != 1'b1) 
      	        @(posedge Clk_s);

            //s4 finished
            begin
             $display("#%d: %d!",Index, Result_s);
	        end
        end
        $stop;
    end

endmodule