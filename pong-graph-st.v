module pong-graph-st
(
5
input wire video-on,
input wire [9:01 pix-x, pix-y,
output reg [2:0] graph-rgb
1 ;
/ / c o n s t a n t and s i g n a l d e c l a r a t i o n
// x , y c o o r d i n a t e s ( 0 . 0 ) to ( 6 3 9 , 4 7 9 )

localparam MAX-X=640;
localparam MAX-Y=480;

// v e r t i c a l s t r i p e as a w a l l
//
// w a l l l e f t , r i g h t b o u n d a r y
localparam WALL-X-L = 32;
localparam WALL-X-R = 35;
//
// r i g h t v e r t i c a l bar
//
/ / bar l e f t , r i g h t b o u n d a r y
localparam BAR-X-L = 600;
localparam BAR-X-R = 603;
// bar t o p , b o t t o m b o u n d a r y
localparam BAR-Y-SIZE = 7 2 ;
localparam BAR-Y-T = MAX-Y/2-BAR-Y_SIZE/2; / / 2 0 4
localparam BAR-Y-B = BAR-Y-T+BAR-Y-SIZE -1 ;
// square
/ /
ball
localparam BALL-SIZE = 8 ;
// b a l l l e f t , r i g h t boundary
localparam BALL-X-L = 580;
localparam BALL-X-R = BALL-X-L+BALL-SIZE-1;
// b a l l t o p , b o t t o m b o u n d a r y
localparam BALL-Y-T = 238;
localparam BALL-Y-B = BALL-Y-T+BALL-SIZE -1 ;
, ,
//

wire wall-on , bar-on , sq-ball-on ;
wire [2: 01 wall-rgb , bar-rgb , ball-rgb ;
// body
/ /
// ( w a l l ) l e f t
vertical strip
// p i x e l
within wall
assign wall-on = (WALL-X-L<=pix-x) && (pix-x<=WALL-X-R);
// wall rgb o u t p u t
assign wall-rgb = 3'bOOl; / / b l u e
/ /
// r i g h t

assign bar-on = (BAR-X-L<=pix-x) && (pix-x<=BAR-X-R) &&
(BAR-Y-T<=pix-y) && (pix-y<=BAR-Y-B);
// bar r g b o u t p u t
assign bar-rgb = 3'bOlO;
//
// s q u a r e
 // g r e e n

// p i x e l

assign sq-ball-on = (BALL-X-L <=pix-x) && (pix-x <=BALL-X-R) &&
(BALL-Y-T <=pix-y) && (pix-y <=BALL-Y-B) ;
assign ball-rgb = 3'blOO;
// r e d
// rgb
always @*
  if(~video-on)
    graph-rgb = 3'bOOO;
  else
    if(wall-on)
      graph-rgb = wall-rgb ;
    else if (bar-on)
      graph-rgb = bar-rgb ;
    else if(sq-ball-on)
      graph-rgb = ball-rgb;
    else
      graph-rgb = 3'bllO;
  
endmodule
