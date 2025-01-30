module pong_graph_animate(
input wire clk, reset,
input wire video_on ,
input wire [1:0] btn,
input wire [9:0] pix_x, pix_y,
output reg [2:0] graph_rgb
);

localparam MAX_X = 640;          // Largura máxima da tela
localparam MAX_Y = 480;          // Altura máxima da tela
wire refr_tick;                  // Sinal de tick de atualização

// Parede vertical (esquerda)
localparam WALL_X_L = 32;        // Limite esquerdo da parede
localparam WALL_X_R = 35;        // Limite direito da parede

// Barra vertical (direita)
localparam BAR_X_L = 600;        // Limite esquerdo da barra
localparam BAR_X_R = 603;        // Limite direito da barra
localparam BAR_Y_SIZE = 72;      // Tamanho vertical da barra

// Registros para rastrear a posição da barra
reg [9:0] bar_y_reg, bar_y_next; // Posição Y da barra

// Velocidade da barra ao pressionar o botão
localparam BAR_V = 4;            // Velocidade da barra

// Bola quadrada
localparam BALL_SIZE = 8;        // Tamanho da bola

// Limites da bola
wire [9:0] ball_x_l, ball_x_r;   // Limites horizontais da bola
wire [9:0] ball_y_t, ball_y_b;   // Limites verticais da bola

// Registros para rastrear a posição da bola
reg [9:0] ball_x_reg, ball_y_reg; // Posição atual da bola
wire [9:0] ball_x_next, ball_y_next; // Próxima posição da bola

// Registros para rastrear a velocidade da bola
reg [9:0] x_delta_reg, x_delta_next; // Velocidade horizontal da bola
reg [9:0] y_delta_reg, y_delta_next; // Velocidade vertical da bola

// Velocidade da bola (pode ser positiva ou negativa)
localparam BALL_V_P = 2;         // Velocidade positiva
localparam BALL_V_N = -2;        // Velocidade negativa

// Memória ROM para a bola redonda
wire [2:0] rom_addr, rom_col;    // Endereço e coluna da ROM
reg [7:0] rom_data;              // Dados da ROM
wire rom_bit;                    // Bit da ROM


// Sinais para indicar se o pixel atual está na parede, barra ou bola
wire wall_on, bar_on, sq_ball_on, rd_ball_on;

// Cores RGB para parede, barra e bola
wire [2:0] wall_rgb, bar_rgb, ball_rgb;

// Memória ROM para a imagem da bola redonda
always @*
    case (rom_addr)
        3'h0: rom_data = 8'b00111100; // ****
        3'h1: rom_data = 8'b01111110; // ******
        3'h2: rom_data = 8'b11111111; // ********
        3'h3: rom_data = 8'b11111111; // ********
        3'h4: rom_data = 8'b11111111; // ********
        3'h5: rom_data = 8'b11111111; // ********
        3'h6: rom_data = 8'b01111110; // ******
        3'h7: rom_data = 8'b00111100; // ****
    endcase

// Registros para armazenar estados
always @(posedge clk or posedge reset)
    if (reset) begin
        bar_y_reg <= 0;
        ball_x_reg <= 0;
        ball_y_reg <= 0;
        x_delta_reg <= 10'h004;
        y_delta_reg <= 10'h004;
    end
    else begin
        bar_y_reg <= bar_y_next;
        ball_x_reg <= ball_x_next;
        ball_y_reg <= ball_y_next;
        x_delta_reg <= x_delta_next;
        y_delta_reg <= y_delta_next;
    end

// Sinal de tick de atualização (60 Hz)
assign refr_tick = (pix_y == 481) && (pix_x == 0);

// Parede vertical esquerda
assign wall_on = (WALL_X_L <= pix_x) && (pix_x <= WALL_X_R);

// Cor da parede (azul)
assign wall_rgb = 3'b001; // blue

assign bar_y_t = bar_y_reg; 
assign bar_y_b = bar_y_t + BAR_Y_SIZE - 1; 
assign bar_on = (BAR_X_L <= pix_x) && (pix_x <= BAR_X_R) && (bar_y_t <= pix_y) && (pix_y <= bar_y_b); 
assign bar_rgb = 3'b010; // green 

always @* begin 
    bar_y_next = bar_y_reg; 
    if (refr_tick) begin 
        if (btn[1] && (bar_y_b < (MAX_Y - 1 - BAR_V))) 
            bar_y_next = bar_y_reg + BAR_V; 
        else if (btn[0] && (bar_y_t > BAR_V)) 
            bar_y_next = bar_y_reg - BAR_V; 
    end 
end 

assign ball_x_1 = ball_x_reg; 
assign ball_y_t = ball_y_reg; 
assign ball_x_r = ball_x_1 + BALL_SIZE - 1; 
assign ball_y_b = ball_y_t + BALL_SIZE - 1; 
assign sq_ball_on = (ball_x_1 <= pix_x) && (pix_x <= ball_x_r) && (ball_y_t <= pix_y) && (pix_y <= ball_y_b); 
assign rom_addr = pix_y[2:0] - ball_y_t[2:0]; 
assign rom_col = pix_x[2:0] - ball_x_1[2:0]; 
assign rom_bit = rom_data[rom_col]; 
assign rd_ball_on = sq_ball_on && rom_bit; 
assign ball_rgb = 3'b100; // red 

assign ball_x_next = (refr_tick) ? ball_x_reg + x_delta_reg : ball_x_reg; 
assign ball_y_next = (refr_tick) ? ball_y_reg + y_delta_reg : ball_y_reg; 

always @* begin 
    y_delta_next = y_delta_reg; 
    if (ball_y_t < 1) 
        y_delta_next = BALL_V_P; 
    else if (ball_y_b > (MAX_Y - 1)) 
        y_delta_next = BALL_V_N; 
    else if (ball_x_1 <= WALL_X_R) ; // reach wall 
    else if ((BAR_X_L <= ball_x_r) && (ball_x_r <= BAR_X_R) && (bar_y_t <= ball_y_b) && (ball_y_t <= bar_y_b)) 
        x_delta_next = BALL_V_N; 
end 

always @* begin 
    if ("video_on") 
        graph_rgb = 3'b000; // blank 
    else if (wall_on) 
        graph_rgb = wall_rgb; 
    else if (bar_on) 
        graph_rgb = bar_rgb; 
    else if (rd_ball_on) 
        graph_rgb = ball_rgb; 
    else 
        graph_rgb = 3'b110; // yellow background 
end
endmodule

      
