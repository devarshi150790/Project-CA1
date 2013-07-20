`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:53:51 05/30/2013 
// Design Name: 
// Module Name:    ckt 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ckt(btn,sw,led,clk,cathodes,anodes,rst);
input clk,rst;
input [1:0] btn;
reg [1:0] curbtns;
reg [1:0] prevbtns;
input [3:0] sw;
output [6:0] cathodes;
output [3:0] led;
output [3:0] anodes;
reg [6:0] cathodes;
reg [3:0] anodes;
reg [3:0] led;
reg [3:0] dig=0;
reg [3:0] dig1=0;
reg slow_clock;
reg flag;
integer count,x,y,c,x1,y1;
reg [3:0] z=0,b=0, prevb=0;
integer co=0,prev=0;
integer ticker2;

always @(posedge clk)
begin
co=c;
prevbtns=curbtns;
create_slow_clock(clk, slow_clock);
end

always @(curbtns or prevbtns or co or sw)
begin
if( prevbtns==0 && curbtns==2'b10)
begin
c=sw;
led=sw;
end
else if( prevbtns==0 && curbtns!=0)
begin
c = co + 1;
end
else
c = co;
end
always @(btn or prevbtns)
begin

case(btn)
2'b10:curbtns=2'b10;
2'b01:curbtns=2'b01;
2'b00:curbtns=2'b00;
default:curbtns = prevbtns;
endcase
end

always @(posedge slow_clock)
begin
/*
if (rst == 0) 
anodes=4'b 1111;
else*/
begin

if(c<=47)
begin
if(c<=15)
begin
x=0;
y=c;
end
else if(c<=31)
begin
x=1;
y=c-16;
end
else
begin
x=2;
y=c-32;
end
end
else
begin
x=0;
y=0;
end
end
//default: anodes= 4'b 0111;
case (anodes)
4'b 0111: anodes=4'b 1011;
4'b 1011: anodes=4'b 0111;
4'b 1111: anodes=4'b 1011;
default: anodes=1111;
endcase

case (anodes)
4'b 1011: begin dig=x; end
4'b 0111: begin dig=y; end 
endcase
cathodes=calc_cathode_value(dig);
end

function [6:0] calc_cathode_value; 
input [3:0] dig; 
begin 
case (dig) 
0: calc_cathode_value = 7'b 1000000;
1: calc_cathode_value = 7'b 1111001; 
2: calc_cathode_value = 7'b 0100100;
3: calc_cathode_value = 7'b 0110000;
4: calc_cathode_value = 7'b 0011001;
5: calc_cathode_value = 7'b 0010010;
6: calc_cathode_value = 7'b 0000010;
7: calc_cathode_value = 7'b 1111000;
8: calc_cathode_value = 7'b 0000000;
9: calc_cathode_value = 7'b 0010000;
10: calc_cathode_value = 7'b 0001000;   
11: calc_cathode_value = 7'b 0000011;
12: calc_cathode_value = 7'b 1000110;
13: calc_cathode_value = 7'b 0100001;
14: calc_cathode_value = 7'b 0000110;
15: calc_cathode_value = 7'b 0001110;
endcase 
end 
endfunction 
 
task create_slow_clock;
input clock;
inout slow_clock;
integer count;
begin
if (count > 250000)
begin
count=0;
slow_clock = ~slow_clock;
end
count = count+1;
end
endtask

endmodule
