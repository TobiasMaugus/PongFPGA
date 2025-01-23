module pong-top-st
(

input wire clk, reset,
output wire hsync, vsync,
output wire [2:0] rgb

// s i g n a l

  wire [9:0] pixel-x , pixel-y ;
  wire video-on , pixel-tick;
  reg [2:0] rgb-reg;
  wire [2:0] rgb-next ;
// body
// i n s t a n t i a t e vga sync c i r c u i t
vga-sync vsync-unit
  (.clk(clk), .reset (reset), .hsync(hsync), .vsync(vsync),
.video-on(video-on), .p-tick(pixe1-tick),
 .pixel-x(pixe1-x), .pixel-y(pixel-y));
// i n s t a n t i a t e graphic g e n e r a t o r
pong-graph-st pong-grf-unit
  (.video-on(video-on), .pix-x(pixel-x), .pix-y(pixel-y),
 .graph-rgb(rgb-next));
// rgb b u f f e r
  always @ (posedge clk)
    if(pixel-tick)
      rgb-reg <= rgb-next ;
// o u t p u t
  assign rgb = rgb-reg;

endmodule
