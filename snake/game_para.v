`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:07:45 06/20/2018 
// Design Name: 
// Module Name:    game_para 
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
//	������Ϸ�Ĳ�����snake_speed[2:0],apple_size[2:0]
//	Ҫ�󣺲�����һ������ʱ��Ϊ���Ӿ�Ч��
//	attention_data �ķ�Χ���¾�ȡ�����λ��Ϊ�ȼ�����
module game_para(
	clk_1s,rst,attention_data,snake_speed,apple_size
    );
	 input clk_1s;
	 input rst;
	 input [7:0] attention_data;
	 output reg [2:0] snake_speed;
	 output reg [2:0] apple_size;
	 
	 always @(posedge clk_1s or negedge rst)
	 begin
		if(!rst)
		begin
			snake_speed <= 3'd0;
			apple_size <= 3'd0;
		end
		else
		begin
			snake_speed <= attention_data[7:4];
		end
	 
	 end


endmodule
