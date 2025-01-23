module vga-sync
(
input wire clk, reset,
output wire hsync , vsync , video-on, p-tick,
outpu wire [9:0] pixel-x, pixel-y
);

// c o n s t a n t d e c l a r a t i o n
/ / VGA 6 4 0 - b y - 4 8 0 s y n c p a r a m e t e r s
localparam HD = 640; / / h o r i z o n t a l d i s p l a y a r e a
localparam HF = 4 8 ; // h . f r o n t ( l e f t ) b o r d e r
localparam HB = 16 ; // h . b a c k ( r i g h t ) b o r d e r
localparam HR = 96 ; / / h . r e t r a c e
localparam VD = 480; // v e r t i c a l d i s p l a y a r e a
localparam VF = 10; / / v . f r o n t ( t o p ) b o r d e r
localparam VB = 33; / / v . b a c k ( b o t t o m ) b o r d e r
localparam VR = 2;
// v . r e t r a c e
/ / mod-2 c o u n t e r
  reg mod2-reg;
  wire mod2-next ;
  // sync c o u n t e r s
  reg [9:01 h-count-reg, h-count-next;
  reg [9: 01 v-count-reg , v-count-next ;
  // outpzit b u f f e r
  reg v-sync-reg , h-sync-reg ;
  wire v-sync-next , h-sync-next ;
  // s t a t u s s i g n a l
  wire h-end , v-end , pixel-t ick;

/ / body
// r e g i s t e r s

  always@ (posedge clk , posedge reset)
  if(reset)
    begin mod2-reg <= l'bO;
    v-count-reg <= 0 ;
    h-count-reg <= 0 ;
    v-sync-reg <= l'bO;
    h-sync-reg <= l'bO;
  end
  else
    begin
      mod2-reg <= mod2-next ;
      v-count-reg <= v-count-next;
      h-count-reg <= h-count-next;
      v-sync-reg <= v-sync-next ;
      h-sync-reg <= h-sync-next ;
    end
/ / mod-2 c i r c u i t t o g e n e r a t e 25 MHz e n a b l e
  assign mod2-next = ~mod2-reg ;
  assign pixel-tick = mod2-reg;

tick
// s t a t u s s i g n a l s
// end o f h o r i z o n t a l c o u n t e r ( 7 9 9 )
  assign h-end = (h-count-reg==(HD+HF+HB+HR-1)) ;
// end o f v e r t i c a l c o u n t e r ( 5 2 4 )
  assign v-end = (v-count-reg==(VD+VF+VB+VR-1)) ;

/ / n e x t - s t a t e l o g i c o f mod-800 h o r i z o n t a l s y n c c o u n t e r
  always @*
  if (pixel-tick)
    if(h-end)
      h-count-next = 0 ;
    else
      h-count-next = h-count-reg + 1;
  else
    h-count-next = h-count-reg;
/ / n e x t - s t a t e l o g i c o f mod-525 v e r t i c a l s y n c c o u n t e r
  always @*
    if (pixel-tick & h-end)
      if (v-end)
        v-count-next = 0 ;
      else
        v-count-next = v-count-reg + 1;
      else
        v-count-next = v - count-reg;


  h o r i z o n t a l and v e r t i c a l s y n c , b u f f e r e d t o a v o i d g l i t c h
  h - s v n c - n e x t a s s e r t e d b e t w e e n 656 and 751
  assign h-sync-next = (h-count-reg>=(HD+HB) &&
  h-count-reg<=(HD+HB+HR-1));
  / / v h - s y n c - n e x t a s s e r t e d b e t w e e n 490 and 491
  assign v-sync-next = (v-count-reg>=(VD+VB) &&
  v-count-reg<=(VD+VB+VR-1));90
  
  // v i d e o o n / o f f
  assign video-on = (h-count-reg<HD) && (v-count-reg<VD);
  // output
  assign hsync = h-sync-reg;
  assign vsync = v-sync-reg;
  assign pixel-x = h-count-reg;
  assign pixel-y = v-count-reg;
  assign p-tick = pixel-tick;
endmodule
