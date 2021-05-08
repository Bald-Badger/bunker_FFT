// all defines usin in RISCV (except the ones used in alu)

package defines;

`ifndef _defines_sv_
`define _defines_sv_

//	ISA define
	localparam 	FREQ 	= 	5e7;			// bus clock, 50Mhz crystal oscillator on FPGA board
	localparam	FFT_LEN = 65536;
	localparam	FFT_DELAY = 57490;

//	constant define
	localparam	TRUE 	= 1;
	localparam	FALSE 	= 0;
	integer 	NULL 	= 0;
	logic		ENABLE 	= 1'b1;
	logic		DISABLE	= 1'b0;
	logic		VALID	= 1'b1;
	logic		INVALID = 1'b0;


`endif

endpackage
