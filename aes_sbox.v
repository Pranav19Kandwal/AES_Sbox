module affineTransformation(state_in);
  input [7:0] state_in;
  output [7:0] state_out;
  
  wire [7:0] A [7:0];
  assign A[0] = 8'b11111000;
  assign A[1] = 8'b01111100;
  assign A[2] = 8'b00111110;
  assign A[3] = 8'b00011111;
  assign A[4] = 8'b10001111;
  assign A[5] = 8'b11000111;
  assign A[6] = 8'b11100011;
  assign A[7] = 8'b11110001;
  
  wire [7:0] b = 8'b01100011;
  
  wire temp;
  wire [7:0] state_out_temp;
  genvar i, j;
  generate
    for(i=7; i>=0; i = i-1)begin
      assign temp = 0;
      for(j=7; j>=0; j=j-1)begin
        assign temp = temp ^ (A[i][j] & state_in[j]);
      end
      assign state_out_temp[i] = temp ^ b[i];
    end
  endgenerate 
  assign state_out = state_out_temp;
endmodule


  
