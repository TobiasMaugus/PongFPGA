module pong-graph-animate(

input wire clk, reset,
input wire video-on ,
input wire [l:O] btn ,
input wire [9:0] pix-x , pix-y,
output reg [2:0] graph-rgb);


localparam MAX-X = 640;
localparam MAX-Y = 480;
wire refr-tick;

localparam WALL-X-L = 32 ;
localparam WALL-X-R = 35 ;

localparam BAR-X-L = 600 ;
localparam BAR-X-R = 603 ;
// bar t o p , bottom boundary
wire [9:0] bar-y-t , bar-y-b;
localparam BAR-Y-SIZE = 72 ;

reg [9:0] bar-y-reg, bar-y-next;
/ / b a r m o v i n g v e l o c i t y when a b u t t o n i s p r e s s e d
localparam BAR-V = 4 ;
//

localparam BALL-SIZE = 8 ;
// b a l l l e f t , r i g h t boundary
wire [ 9 : 01 ball-x-1 , ball-x-r;
// b a l l t o p , bottom boundary
      wire [ 9 : 01 ball-y-t , ball-y-b;
// reg t o t r a c k l e f t , t o p p o s i t i o n
reg [ 9 : 01 ball-x-reg , ball-y-reg;
wire [9 : 01 ball-x-next , ball-y-next;
// reg t o t r a c k b a l l speed
      reg [9 : 01 x-delta-reg , x-delta-next ;
           reg [9:01 y-delta-reg , y-delta-next ;
/ / b a l l v e l o c i t y c a n be pos o r n e g )
localparam BALL-V-P = 2 ;
localparam BALL-V-N = - 2 ;
// round
ball
, ,
wire [ 2 : 01 r o m - a d d r , r o m - c o l ;
reg [7:01 rom-data;
wire rom-bit ;
//
object output signalswire wall-on , bar-on , sq-ball-on , rd-ball-on;
     wire[2:0] wall-rgb , bar-rgb , ball-rgb;
, ,
// r o u n d b a l l

always Q*
case (rom-addr)
3'hO:
3'hl:
3'h2:
3'h3:
3'h4:
3'h5:
3'h6:
3'h7:
rom-data
rom-data
rom-data
rom-data
rom-data
rom-data
rom-data
rom-data
= 8'b00111100;
= 8'b01111110;
= 8'bllllllll;
= 8 ' b l l l l l l l l ;
= 8'bllllllll;
= 8'bllllllll;
= 8'b01111110;
= 8'b00111100;
//
//
//
//
//
//
//
//
****
******
********
********
********
********
******
****
endcase
// r e g i s t e r s
a l w a y s Q( p o s e d g e c l k , p o s e d g e r e s e t
if (reset)
begin
b a r - y - r e g <= 0 ;
b a l l - x - r e g <= 0 ;
b a l l - y - r e g <= 0 ;
x - d e l t a - r e g <= l O ' h 0 0 4 ;
y - d e l t a - r e g <= l O ' h 0 0 4 ;
end
else
begin
b a r - y - r e g <= b a r - y - n e x t ;
b a l l - x - r e g <= b a l l - x - n e x t ;
b a l l - y - r e g <= b a l l - y - n e x t ;
x - d e l t a - r e g <= x - d e l t a - n e x t ;
y - d e l t a - r e g <= y - d e l t a - n e x t ;
end
//
/ /
r e f r - t i c k : I-clock t i c k a s s e r t e d at s t a r t of v-sync
i . e . . when t h e s c r e e n i s r e f r e s h e d ( 6 0 H z )
a s s i g n r e f r - t i c k = ( p i x - y = = 4 8 1 ) && ( p i x - x = = O ) ;
1
,
// ( w a l l ) l e f t
vertical
strip
// p i x e l w i t h i n w a l l
a s s i g n w a l l - o n = (WALL-X-L < = p i x - x ) && ( p i x - x <=WALL-X-R) ;
// wall rgb output
a s s i g n w a l l - r g b = 3'bOOl; // blue
, ,
// r i g h t v e r t i c a l
/ /
// boundary
barVGA CONTROLLER I: GRAPHIC
assign bar-y-t = bar-y-reg;
a s s i g n b a r - y - b = b a r - y - t + BAR-Y-SIZE - 1 ;
// p i x e l w i t h i n bar
a s s i g n b a r - o n = (BAR-X-L<=pix-x) && (pix-x<=BAR-X-R) &&
( b a r - y - t < = p i x - y ) && ( p i x - y < = b a r - y - b ) ;
// bar rgb o u t p u t
a s s i g n b a r - r g b = 3 ' b O l O ; // g r e e n
/ / new b a r y - p o s i t i o n
always O*
begin
b a r - y - n e x t = b a r - y - r e g ; / / no move
if (refr-tick)
i f ( b t n El1 & ( b a r - y - b < (MAX-Y-1-BAR-V)))
b a r - y - n e x t = b a r - y - r e g + BAR-V; // move down
e l s e i f ( b t n [ O ] & ( b a r - y - t > BAR-V))
b a r - y - n e x t = b a r - y - r e g - BAR-V; // move up
end
// s q u a r e
ball
// b o u n d a r y
assign ball-x-1 = ball-x-reg;
assign ball-y-t = ball-y-reg;
a s s i g n b a l l - x - r = b a l l - x - 1 + BALL-SIZE - 1 ;
a s s i g n b a l l - y - b = b a l l - y - t + BALL-SIZE - 1 ;
// p i x e l w i t h i n b a l l
assign sq-ball-on =
( b a l l - x - 1 < = p i x - x ) && ( p i x - x < = b a l l - x - r ) &&
( b a l l - y - t < = p i x - y ) && ( p i x - y < = b a l l - y - b ) ;
/ / map c u r r e n t p i x e l l o c a t i o n t o ROM a d d r / c o l
a s s i g n rom-addr = p i x - y [2:01 - b a l l - y - t [2:0] ;
a s s i g n rom-col = pix-x [2:0] - b a l l - x - 1 [2:0] ;
assign rom-bit = rom-data [rom-col] ;
// p i x e l w i t h i n b a l l
assign rd-ball-on = sq-ball-on & rom-bit;
// b a l l rgb o u t p u t
// red
assign b a l l - r g b = 3'blOO;
/ / new b a l l p o s i t i o n
assign ball-x-next = ( r e f r - t i c k ) ? ball-x-reg+x-delta-reg
ball-x-reg ;
assign ball-y-next = ( r e f r - t i c k ) ? ball-y-reg+y-delta-reg
ball-y-reg ;
// new b a l l v e l o c i t y
always O*
begin
y-delta-next = y-delta-reg;
i f ( b a l l - y - t < 1 ) // r e a c h t o p
y - d e l t a - n e x t = BALL-V-P;
e l s e i f ( b a l l - y - b > (MAX-Y-1)) // r e a c h b o t t o m
y - d e l t a - n e x t = BALL-V-N;
e l s e i f ( b a l l - x - 1 <= WALL-X-R) // r e a c h w a l l
:
:x-delta-next = BALL-V-P;
// bounce back
e l s e i f ( (BAR-X-L <=ball-x-r ) && (ball-x-r <=BAR-X-R) &&
(bar-y-t <=ball-y-b) && (ball-y-t <=bar-y-b))
// r e a c h x o f r i g h t bar and h i t , b a l l bounce back
x-delta-next = BALL-V-N;
end
//
// rgb m u l t i p l e x i n g
circuit
, ,
175
185
always O*
i f ("video-on)
graph-rgb = 3'bOOO; / / b l a n k
else
i f (wall-on)
graph-rgb = wall-rgb ;
e l s e i f (bar-on)
graph-rgb = bar-rgb ;
e l s e i f (rd-ball-on)
graph-rgb = ball-rgb ;
else
graph-rgb = 3'b110; / / y e l l o w
background
endmodule
