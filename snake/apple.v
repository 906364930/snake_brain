`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:56:23 06/05/2018 
// Design Name: 
// Module Name:    apple 
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
//  ƻ������ģ��
//  1.������ƻ������λ�� [up_border,down_border] [left_border,right_border]
//  2.������ƻ����������жϣ�1.������ snake_x_pos snake_y_pos �غ� 
`include "Definition.h"
module apple(
    clk_25M,rst,apple_x_pos,apple_y_pos,apple_gen
    );
    input rst;
	 input clk_25M;
	 input apple_gen;
    output reg [6:0] apple_x_pos;                 //  ��ʱ��ƻ���� x,y ����
    output reg [5:0] apple_y_pos;

//  ƻ������Ĳ���������ʹ��һ���򵥵Ĳ���α������ķ���
//  Ĭ�����ú�ƻ����������Ϊ��(75,30)
//  in: clk_25M,rst,apple_refresh
//  out:apple_x_pos, 
//	 6/8�����ԣ��� apple_gen Ϊ�ߵ�ƽ��ÿ���� clk_25M һ�����ڲ���һ��α�����
//	 6/8������֤����
    always @ (posedge clk_25M or negedge rst)
    begin
      if(!rst)
        begin
          apple_x_pos <= 7'd75;
          apple_y_pos <= 7'd30;
        end
      else
        if(apple_gen)         //  ����������ź����غ��źų���ʱˢ��ƻ������
            begin
              apple_x_pos <= apple_x_pos[4:0] + apple_y_pos[4:1] + 25;           // ��Χ��5 -- 67
              apple_y_pos <= apple_x_pos[6:2] + apple_y_pos[5:2] + 7;           //  ��Χ��7 -- 53
            end
    end



endmodule
