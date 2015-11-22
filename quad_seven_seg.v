// File: quad_seven_seg.v
// This is the top level design for EE178 Lab #2.
// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what 
// the simulator time step should be (1 ps here).
`timescale 1 ns / 1 ps
// Declare the module and its ports. This is
// using Verilog-2001 syntax.
module quad_seven_seg (
  input wire clk,
  //input wire rst,
  input wire [3:0] val3,
  input wire dot3,
  input wire [3:0] val2,
  input wire dot2,
  input wire [3:0] val1,
  input wire dot1,
  input wire [3:0] val0,
  input wire dot0, 
  output wire an3,
  output wire an2,
  output wire an1,
  output wire an0,
  output reg ca,
  output reg cb,
  output reg cc,
  output reg cd,
  output reg ce,
  output reg cf,
  output reg cg,
  output reg dp
  );

//Register Declarations
reg [15:0] cntr16 ;
reg [1:0] step ;
reg en; 
reg [3:0] mux_out;
wire rst;
reg dot;

  
//16 bit counter
always@(posedge clk)
if (rst) begin
 cntr16 <= #1 16'd0;
end else begin
 cntr16 <= #1 cntr16 + 1;
end   

//Enable Signal Logic for 2 bit counter
always @ (posedge clk)
 if (rst) begin
  en <= #1 1'b0;
 end else if (cntr16 == 16'd400000) begin
  en <= #1 1'b1;
 end else begin
  en <= #1 1'b0;
 end
 

//2 bit couter with enable
always@(posedge clk)
if (rst) begin
 step <= #1 2'b0;
end else if(en) begin 
 step <= #1 step + 1;
end else begin
 step <= #1 step;
end  
 
// 2 to 4 Encoder
assign an0 = !(step == 2'b00);
assign an1 = !(step == 2'b01);
assign an2 = !(step == 2'b10);
assign an3 = !(step == 2'b11);
  
// 4 to 1 Multiplexer
always@(*)
 if (step == 2'b00) begin
   mux_out = val0;
   dot = !(dot0);
 end else if (step == 2'b01) begin
   mux_out = val1;
   dot = !(dot1);
 end else if (step == 2'b10) begin
  mux_out = val2;
  dot = !(dot2);
 end else if (step == 2'b11) begin
  mux_out = val3;
  dot = !(dot3);
 end else begin
  mux_out = 4'bzzzz;
  dot = 1'bz;
 end
 
// 4 to 7 Decoder
always@(*)
 case(mux_out)
  4'd0 : {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b0000001,dot};
  4'd1 : {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b1001111,dot}; 
  4'd2 : {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b0010010,dot}; 
  4'd3 : {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b0000110,dot}; 
  4'd4 : {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b1001100,dot}; 
  4'd5 : {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b0100100,dot}; 
  4'd6 : {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b0100000,dot}; 
  4'd7 : {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b0001111,dot}; 
  4'd8 : {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b0000000,dot}; 
  4'd9 : {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b0000100,dot};
  4'd10: {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b0001000,dot};
  4'd11: {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b1100000,dot};
  4'd12: {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b0110001,dot};
  4'd13: {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b1000010,dot};
  4'd14: {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b0110000,dot};
  4'd15: {ca,cb,cc,cd,ce,cf,cg,dp} = {7'b0111000,dot};
  default : {ca,cb,cc,cd,ce,cf,cg} = 7'b1111110;
 endcase
  
endmodule
