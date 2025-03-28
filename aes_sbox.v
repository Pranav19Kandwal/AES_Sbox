module GF_28_to_GF_242(g1, g2);
  input [7:0] g1;
  output [7:0] g2;
  assign g2[7] = g1[7] ^ g1[5];
  assign g2[6] = g1[7] ^ g1[5] ^ g1[3] ^ g1[2];
  assign g2[5] = g1[7] ^ g1[6] ^ g1[4] ^ g1[1];
  assign g2[4] = g1[6] ^ g1[5] ^ g1[4];
  assign g2[3] = g1[7] ^ g1[6] ^ g1[2] ^ g1[1];
  assign g2[2] = g1[6] ^ g1[4] ^ g1[1];
  assign g2[1] = g1[3] ^ g1[1];
  assign g2[0] = g1[7] ^ g1[6] ^ g1[4] ^ g1[3] ^ g1[2] ^ g1[0];
endmodule

module GF_242_to_GF_28(g2, g1);
  input [7:0] g2;
  output [7:0] g1;
  assign g1[7] = g2[5] ^ g2[2];
  assign g1[6] = g2[7] ^ g2[6] ^ g2[5] ^ g2[3] ^ g2[2] ^ g2[1];
  assign g1[5] = g2[7] ^ g2[5] ^ g2[2];
  assign g1[4] = g2[6] ^ g2[4] ^ g2[3] ^ g2[1];
  assign g1[3] = g2[7] ^ g2[5] ^ g2[4] ^ g2[1];
  assign g1[2] = g2[6] ^ g2[5] ^ g2[4] ^ g2[1];
  assign g1[1] = g2[7] ^ g2[5] ^ g2[4];
  assign g1[0] = g2[6] ^ g2[4] ^ g2[0];
endmodule

module GF_24_to_GF_222(g2, g3);
  input [3:0] g2;
  output [3:0] g3;
  assign g3[3] = g2[3];
  assign g3[2] = g2[3] ^ g2[2] ^ g2[1];
  assign g3[1] = g2[3] ^ g2[2];
  assign g3[0] = g2[0];
endmodule

module GF_222_to_GF_24(g3, g2);
  input [3:0] g3;
  output [3:0] g2;
  assign g2[3] = g3[3];
  assign g2[2] = g3[3] ^ g3[1];
  assign g2[1] = g3[2] ^ g3[1];
  assign g2[0] = g3[0];
endmodule

module GF22_multiplicativeInverse(elem, elem_inv);
  input [1:0] elem;
  output [1:0] elem_inv;
  assign elem_inv[1] = elem[1];
  assign elem_inv[0] = elem[1] ^ elem[0];
endmodule

module GF22_multiplication(t1, t2, t3);
  input [1:0] t1;
  input [1:0] t2;
  output [1:0] t3;
  assign t3[1] = (t1[1] & t2[1]) ^ (t1[1] & t2[0]) ^ (t1[0] & t2[1]);
  assign t3[0] = (t1[0] & t2[0]) ^ (t1[1] & t2[1]);
endmodule

module GF22_squaring(t, t_sq);
  input [1:0] t;
  output [1:0] t_sq;
  assign t_sq[1] = t[1];
  assign t_sq[0] = t[1] ^ t[0];
endmodule

module squaring(gamma, gamma_sq);
  input [3:0] gamma;
  output [3:0] gamma_sq;
  wire [3:0] tau;
  wire [3:0] tau_sq;
  GF_24_to_GF_222 GF_24_to_GF_222_inst1 (.g2(gamma), .g3(tau));
  wire [1:0] t1 = {tau[3], tau[2]};
  wire [1:0] t0 = {tau[1], tau[0]};
  wire [1:0] N;
  wire [1:0] t1_sq;
  wire [1:0] t0_sq;
  wire [1:0] prod_t1sq_N;
  assign N = 2'b10;
  GF22_squaring GF22_squaring_inst1 (.t(t1), ,t_sq(t1_sq));
  GF22_squaring GF22_squaring_inst2 (.t(t2), ,t_sq(t2_sq));
  GF22_multiplication GF22_multiplication_inst0 (.t1(t1_sq), .t2(N), .t3(prod_t1sq_N));

  assign tau_sq[3] = t1_sq[1];
  assign tau_sq[2] = t1_sq[0];
  assign tau_sq[1] = t0_sq[1] ^ prod_t1sq_N[1];
  assign tau_sq[0] = t0_sq[0] ^ prod_t1sq_N[0];
  GF_222_to_GF_24 GF_222_to_GF_24_inst1 (.g3(tau_sq), .g2(gamma_sq));
endmodule

module multiplication(gamma1, gamma2, gamma3);
  input [3:0] gamma1;
  input [3:0] gamma2;
  output [3:0] gamma3;
  
  wire [3:0] tau1;
  wire [3:0] tau2;
  wire [3:0] tau3;
  GF_24_to_GF_222 GF_24_to_GF_222_inst2 (.g2(gamma1), .g3(tau1));
  GF_24_to_GF_222 GF_24_to_GF_222_inst3 (.g2(gamma2), .g3(tau2));
  
  wire [1:0] t3;
  wire [1:0] t2;
  wire [1:0] t1;
  wire [1:0] t0;
  wire [1:0] res_t3_t1;
  wire [1:0] res_t3_t0;
  wire [1:0] res_t2_t1;
  wire [1:0] res_t2_t0;
  wire [1:0] res_t3_t1_N;
  wire [1:0] N;

  assign N = 2'b10;
  assign t3 = tau1[3:2];
  assign t2 = tau1[1:0];
  assign t1 = tau2[3:2];
  assign t0 = tau2[1:0];
  
  GF22_multiplication GF22_multiplication_inst1 (.t1(t3), .t2(t1), .t3(res_t3_t1));
  GF22_multiplication GF22_multiplication_inst2 (.t1(t3), .t2(t0), .t3(res_t3_t0));
  GF22_multiplication GF22_multiplication_inst3 (.t1(t2), .t2(t1), .t3(res_t2_t1)); 
  GF22_multiplication GF22_multiplication_inst4 (.t1(t2), .t2(t0), .t3(res_t2_t0)); 
  GF22_multiplication GF22_multiplication_inst5 (.t1(res_t3_t1), .t2(N), .t3(res_t3_t1_N));
  
  assign tau3[3] = res_t3_t1[1] ^ res_t3_t0[1] ^ res_t2_t1[1];
  assign tau3[2] = res_t3_t1[0] ^ res_t3_t0[0] ^ res_t2_t1[0];
  assign tau3[1] = res_t2_t0[1] ^ res_t3_t1_N[1];
  assign tau3[0] = res_t2_t0[0] ^ res_t3_t1_N[0];

  GF_222_to_GF_24 GF_222_to_GF_24_inst2 (.g3(tau3), .g2(gamma3));
endmodule

module multiplicative_inverse(gamma, gamma_inv);
  input [3:0] gamma;
  output [3:0] gamma_inv;
  wire [3:0] tau;
  wire [1:0] t1;
  wire [1:0] t0;
  wire [1:0] N;
  wire [1:0] sum_t1_t0;
  wire [1:0] t1_sq;
  wire [1:0] t0_sq;
  wire [1:0] prod_t1_t0;
  wire [1:0] prod_t1sq_N;
  wire [1:0] delta0;
  wire [1:0] delta1;
  wire [1:0] delta01;
  wire [1:0] delta01_inv;
  wire [3:0] delta;
  
  GF_24_to_GF_222 GF_24_to_GF_222_inst4 (.g2(gamma), .g3(tau));
  assign t1 = {tau[3], tau[2]};
  assign t0 = {tau[1], tau[0]};
  assign sum_t1_t0 = t1 ^ t0;
  assign N = 2'b10;
  GF22_squaring GF22_squaring_inst3 (.t(t0), .t_sq(t0_sq));
  GF22_squaring GF22_squaring_inst4 (.t(t1), .t_sq(t1_sq));
  GF22_multiplication GF22_multiplication_inst6 (.t1(t1), .t2(t0), .t3(prod_t1_t0));
  GF22_multiplication GF22_multiplication_inst7 (.t1(t1_sq), .t2(N), .t3(prod_t1sq_N));
  assign delta01 = t0_sq ^ prod_t1_t0 ^ prod_t1sq_N;
  GF22_multiplicativeInverse GF22_multiplicativeInverse_inst1 (.elem(delta01), .elem_inv(delta01_inv));
  GF22_multiplication GF22_multiplication_inst8 (.t1(sum_t1_t0), .t2(delta01_inv), .t3(delta0));
  GF22_multiplication GF22_multiplication_inst9 (.t1(t1), .t2(delta01_inv), .t3(delta1));
   
  assign delta = {delta1[1], delta1[0], delta0[1], delta0[0]};
  GF_222_to_GF_24 GF_222_to_GF_24_inst3 (.g3(delta), .g2(gamma_inv));
endmodule
  
module AES_inverse(g1, g1_inv);
  input [7:0] g1;
  output [7:0] g1_inv;

  wire [7:0] g2;
  wire [7:0] g2_inv;
  GF_28_to_GF_242 GF_28_to_GF_242_inst1 (.g1(g1), .g2(g2));
  wire [3:0] gamma1;
  wire[3:0] gamma2;
  assign gamma1 = g2[7:4];
  assign gamma2 = g2[3:0];

  wire [3:0] delta0;
  wire [3:0] delta1;
  wire [3:0] delta00;
  wire [3:0] delta01;
  wire [3:0] delta01_inv;
  wire [3:0] gamma1_sq;
  wire [3:0] gamma2_sq;
  wire [3:0] mu;
  wire [3:0] prod_gamma1_gamma2;
  wire [3:0] prod_gamma2Sq_mu;
  
  assign mu = 4'b1110;
  squaring squaring_inst1 (.gamma(gamma1), .gamma_sq(gamma1_sq));
  squaring squaring_inst2 (.gamma(gamma2), .gamma_sq(gamma2_sq));
  multiplication multiplication_inst1 (.gamma1(gamma1), .gamma2(gamma2), .gamma3(prod_gamma1_gamma2));
  multiplication multiplication_inst2 (.gamma1(gamma2_sq), .gamma2(mu), .gamma3(prod_gamma2Sq_mu));
  assign delta00 = gamma1 ^ gamma2;
  assign delta01 = gamma1_sq ^ prod_gamma1_gamma2 ^ prod_gamma2Sq_mu;
  multiplicative_inverse multiplicative_inverse_inst1 (.gamma(delta01), .gamma_inv(delta01_inv));
  multiplication multiplication_inst3 (.gamma1(delta00), .gamma2(delta01_inv), .gamma3(delta0));
  multiplication multiplication_inst4 (.gamma1(gamma1), .gamma2(delta01_inv), .gamma3(delta1));

  assign g2_inv[7:4] = delta1[3:0];
  assign g2_inv[3:0] = delta0[3:0];
  GF_242_to_GF_28 GF_242_to_GF_28_inst1 (.g2(g2_inv), .g1(g1_inv)); 
endmodule

module affineTransformation(state_in, state_out);
  input [7:0] state_in;
  output reg [7:0] state_out;
  
  reg [7:0] A [7:0];
  initial begin
    A[0] = 8'b11111000;
    A[1] = 8'b01111100;
    A[2] = 8'b00111110;
    A[3] = 8'b00011111;
    A[4] = 8'b10001111;
    A[5] = 8'b11000111;
    A[6] = 8'b11100011;
    A[7] = 8'b11110001;
  end
  localparam [7:0] b = 8'b01100011;
  
  integer i, j;
  reg temp;
  
  always @(*) begin
    for (i = 0; i < 8; i = i + 1) begin
      temp = 1'b0;
      for (j = 0; j < 8; j = j + 1) begin
        temp = temp ^ (A[i][j] & state_in[j]);
      end
      state_out[i] = temp ^ b[i];
    end
  end
endmodule

module AES_SBox(output [7:0] sbox [0:255]);
    wire [7:0] g1_inv [0:255];
    wire [7:0] transformed [0:255];

    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin: sbox_gen
            wire [7:0] input_val;
            assign input_val = i; 
            AES_inverse aes_inv_inst (.g1(input_val), .g1_inv(g1_inv[i]));
            affineTransformation affine_inst (.state_in(g1_inv[i]), .state_out(transformed[i]));
            assign sbox[i] = transformed[i];
        end
    endgenerate
endmodule
