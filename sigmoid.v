module sigmoid (
	input         clk,
	input         rst_n,
	input         i_in_valid,
	input  [ 7:0] i_x,
	output [15:0] o_y,
	output        o_out_valid,
	output [50:0] number
);

// Your design
wire [15:0] o_y_prime;
//wire clk_prime, calculation_done;
wire x_positive, x2_interval, x2_interval_prime, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11;
wire [15:0] adder1;	//adder1 = x*2^-4 
wire [15:0] adder2;	//adder2 = x*2^-3
wire add1, add2;	//add1 = 2^-2, add2 = 2^-3
wire control;	//control = 0 if -2 < x < 0
wire [50:0] gate_count0, gate_count1, gate_count2, gate_count3, gate_count4, gate_count5, gate_count6, gate_count7, gate_count8, gate_count9, gate_count10, gate_count11,
gate_count12, gate_count13, gate_count14, gate_count15, gate_count16, gate_count17, gate_count18, gate_count19, gate_count20, gate_count21, gate_count22, gate_count23,
gate_count24, gate_count25, gate_count26, gate_count27, gate_count28, gate_count29;

//AN2 an1(clk_prime, clk, i_in_valid, gate_count0);

assign number = /*gate_count0 +*/ gate_count1 + gate_count2 + gate_count3 + gate_count4 + gate_count5 + gate_count6 + gate_count7 + gate_count8 /*+ gate_count9*/
+ gate_count10 + gate_count11 + gate_count12 + /*gate_count13 +*/ gate_count14 + gate_count15 + gate_count16 + gate_count17 +/* gate_count18 +*/ gate_count19 
/*+ gate_count20*/ + gate_count21 + gate_count22 + gate_count23 + gate_count24 + gate_count25; //+ gate_count26 + gate_count27 + gate_count28 + gate_count29 + gate_count30;

IV iv1(x_positive, i_x[7], gate_count1);	//out1 = 1 if x is positive
EO en1(x2_interval, x_positive, i_x[6], gate_count2);	//x2_interval = 1 if |x| < 2
//IV iv2(x2_interval_prime, x2_interval, gate_count18);	//including x = 2
//EO eo1(x2_interval_prime, i_x[7], i_x[6], gate_count18);
NR2 nor1(add1, i_x[7], x2_interval, gate_count19);	// x >= 2
ND2 nd1(control, i_x[7], x2_interval, gate_count21);	// x > 0 or x <= -2
IV iv3(add2, control, gate_count23);
//assign add1 = control;
//AN2 an2(o_out_valid, i_in_valid, 1'b1, gate_count3);
assign o_y[0] = i_x[0];	//1'b0;
assign o_y[1] = i_x[1];	//1'b0;
assign o_y[2] = i_x[0];	//1'b0;
assign o_y[3] = i_x[1];	//1'b0;
assign o_y[4] = i_x[0];	//1'b0;
assign o_y[5] = i_x[1];	//1'b0;
assign o_y[14] = x_positive;
assign o_y[15] = 1'b0;
AN2 an11(adder1[12], i_x[6], control, gate_count22);
assign adder1[11] = i_x[5];
assign adder1[10] = i_x[4];
assign adder1[9] = i_x[3];
assign adder1[8] = i_x[2];
assign adder1[7] = i_x[1];
assign adder1[6] = i_x[0];
AN3 an3(adder2[13], i_x[6], x2_interval, x_positive, gate_count4);
AN2 an4(adder2[12], i_x[5], x2_interval, gate_count5);
AN2 an5(adder2[11], i_x[4], x2_interval, gate_count6);
AN2 an6(adder2[10], i_x[3], x2_interval, gate_count7);
AN2 an7(adder2[9], i_x[2], x2_interval, gate_count8);
AN2 an9(adder2[7], i_x[0], x2_interval, gate_count10);
assign o_y[6] = adder1[6];
OR2 or5(o_y[7], adder1[7], adder2[7], gate_count11);
//HA1 ha1(c1, o_y[7], adder1[7], adder2[7], gate_count11);
//assign o_y[8] = c1;
assign o_y[8] = adder1[8];
//FA1 fa2(c2, o_y[8], adder1[8], adder2[8], c1, gate_count12);
//FA1 fa3(c3, o_y[9], adder1[9], adder2[9], c2, gate_count13);
HA1 ha2(c3, o_y[9], adder1[9], adder2[9], gate_count12);
FA1 fa4(c4, o_y[10], adder1[10], adder2[10], c3, gate_count14);
FA1 fa5(c5, o_y[11], adder1[11], adder2[11], c4, gate_count15);
FA1 fa6(c6, o_y_prime[12], adder1[12], adder2[12], c5, gate_count16);	//two adder addition
HA1 ha3(c10, o_y[12], o_y_prime[12], add2, gate_count25);	//add 2^-3
OR2 or12(c9, c10, c6, gate_count17);
FA1 fa7(c11, o_y[13], c9, add1, adder2[13], gate_count24);
/*FA1 fa7(c9, o_y_prime[13], c6, add1, adder2[13], gate_count17);
HA1 ha4(c11, o_y[13], o_y_prime[13], c10, gate_count24);*/
IV iv4(o_out_valid, c11, gate_count3);
//HA1 ha3(c10, o_y[14], c9, c8, gate_count21);

endmodule



//BW-bit FD2
module REGP#(
	parameter BW = 2
)(
	input           clk,
	input           rst_n,
	output [BW-1:0] Q,
	input  [BW-1:0] D,
	output [  50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		FD2 f0(Q[i], D[i], clk, rst_n, numbers[i]);
	end
endgenerate

//sum number of transistors
reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

