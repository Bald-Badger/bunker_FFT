import defines::*;

module fft_ip_tb();
	logic       clk;          //    clk.clk
	logic       rst_n;      //    rst.reset_n
	logic       sink_valid;   //   sink.sink_valid
	logic       sink_ready;   //       .sink_ready
	logic [1:0] sink_error;   //       .sink_error
	logic       sink_sop;     //       .sink_sop
	logic       sink_eop;     //       .sink_eop
	logic [11:0] sink_real;    //       .sink_real
	logic [11:0] sink_imag;    //       .sink_imag
	logic [0:0] inverse;      //       .inverse
	logic       source_valid; // source.source_valid
	logic       source_ready; //       .source_ready
	logic [1:0] source_error; //       .source_error
	logic       source_sop;   //       .source_sop
	logic       source_eop;   //       .source_eop
	logic [11:0] source_real;  //       .source_real
	logic [11:0] source_imag;  //       .source_imag
	logic [5:0] source_exp;    //       .source_exp

	fft_ip fft_ip_inst (
		.clk          (clk),          //    clk.clk
		.reset_n      (rst_n),      //    rst.reset_n
		.sink_valid   (sink_valid),   //   sink.sink_valid
		.sink_ready   (sink_ready),   //       .sink_ready
		.sink_error   (sink_error),   //       .sink_error
		.sink_sop     (sink_sop),     //       .sink_sop
		.sink_eop     (sink_eop),     //       .sink_eop
		.sink_real    (sink_real),    //       .sink_real
		.sink_imag    (sink_imag),    //       .sink_imag
		.inverse      (inverse),      //       .inverse
		.source_valid (source_valid), // source.source_valid
		.source_ready (source_ready), //       .source_ready
		.source_error (source_error), //       .source_error
		.source_sop   (source_sop),   //       .source_sop
		.source_eop   (source_eop),   //       .source_eop
		.source_real  (source_real),  //       .source_real
		.source_imag  (source_imag),  //       .source_imag
		.source_exp   (source_exp)    //       .source_exp
	);
	
	clkrst #(.FREQ(FREQ)) clkrst_inst
	(
		.clk(clk),
		.rst_n(rst_n)
	);

task init();
	begin
		// static inputs
		sink_valid = VALID;
		sink_error = 2'b00;
		sink_imag = 10'b0;
		source_ready = VALID;
		// dynamic inputs
		sink_sop = 1'b0;
		sink_eop = 1'b0;
		sink_real = 10'b0;
		inverse = DISABLE;
		@(negedge rst_n);
		repeat(2) @(negedge clk);
	end
endtask

task write_data(input logic[7:0] data);
	begin
		@(negedge clk);
		sink_real = {{4'b0000}, data};
		@(posedge clk);
	end
endtask

task sop();
	fork
		begin
			@(negedge clk);
			sink_sop = 1'b1;
			//sink_valid = VALID;
			@(negedge clk);
			sink_sop = 1'b0;
		end
	join
endtask

task eop();
	fork
		begin
			@(negedge clk);
			sink_eop = 1'b1;
			//sink_valid = INVALID;
			@(negedge clk);
			sink_eop = 1'b0;
			sink_sop = 1'b1;
			@(negedge clk);
			sink_sop =1'b0;
		end
	join
endtask


string line;
int fd;
integer pix;
task write_file(input string file_name);
	fd = $fopen(file_name, "r");
	if (fd) begin
		$display("file opened successfully");
	end else begin
		$display("file not found");
		$stop();
	end
	begin
		for (int i = 0; i < FFT_LEN-3; i++) begin
			$fgets(line, fd);
			if (line != "\n") begin
				pix = line.atoi();
				write_data(pix[7:0]);
			end
		end
	end
endtask


integer i;
logic counter_start;
logic[31:0] counter;
initial begin

	init();
	counter_start = 1'b0;

	fork
		sop();
	join
	
	write_file("zebra.txt");

	eop();
	
	@(posedge source_sop);
	fork
		begin
			counter_start = 1'b1;
			repeat(1000) @(posedge clk);
			$display("image height: %d", stride);
			$stop();
		end

	join
end

logic[11:0] comp1;
logic[11:0] comp2;
logic[12:0] sum;
logic[12:0] stride;
logic found;
assign comp1 = source_real[11] ? -source_real : source_real;
assign comp2 = source_imag[11] ? -source_imag : source_imag;
assign sum = comp1 + comp2;
assign trigger = (counter > 300) && (sum > 13'd38);
always_ff @(posedge clk or negedge rst_n) begin
	if (~rst_n)begin
		found <= 1'b0;
		stride <= 13'b0;
	end else if (trigger && ~found) begin
		stride <= counter;
		found <= 1'b1;
	end else begin
		found <= found;
		stride <= stride;
	end
end


always_ff @(posedge clk or negedge rst_n) begin
	if(~rst_n) counter <= 0;
	else if (counter_start) counter <= counter + 1'b1;
	else counter <= counter;
end

endmodule