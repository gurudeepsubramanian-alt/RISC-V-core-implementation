module tb_processor2stage;
    reg clk, reset;
    wire [7:0] result_out, pc_out;

    processor2stage uut(
        .clk(clk),
        .reset(reset),
        .result_out(result_out),
        .pc_out(pc_out)
    );

    initial begin
        clk = 0;
        reset = 1;
        #5 reset = 10;      // Release reset
    end

    always #10 clk = ~clk; // 50MHz clock

    initial begin
        $display("Time\tPC\tResult");
        $monitor("%0t\t%h\t%h", $time, pc_out, result_out);
        #200 $finish;
    end
endmodule
