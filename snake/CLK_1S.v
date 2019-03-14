`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:22:09 06/08/2018 
// Design Name: 
// Module Name:    CLK_1S 
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
//  ���� snake_speed �������ߵ��ƶ��ٶȣ�speed��ֵԽ���ٶ�Խ�죬
//  ע�⣺����� ֵӦ���ȶ�һЩ���ɷ�2s�ɼ����ı�һ��
module CLK_1S(
	clk,rst,clk_1s,clk_speed,snake_speed
    );
	 input clk,rst;
    input [2:0] snake_speed;
	 output reg clk_1s;
	 output reg clk_speed;

//  �����ƶ��ļ�������ģ��
//  in: snake_speed
//  out: max_count
//	 6/20������֤����
    parameter  [25:0]
        s1s_count = 26'd52428800,
        s0_9s_count = 26'd47185920,
        s0_8s_count = 26'd41943040,
        s0_7s_count = 26'd36700160,
        s0_6s_count = 26'd31457280,
        s0_5s_count = 26'd26214400,
        s0_4s_count = 26'd20971520,
        s0_3s_count = 26'd15728640;
    reg [25:0] max_count;
    always @ (posedge clk or negedge rst)
    begin
        if(!rst)
            max_count <= s1s_count;
        else
        begin
          case (snake_speed)
            3'd0: max_count <= s1s_count;
            3'd1: max_count <= s0_9s_count;
            3'd2: max_count <= s0_8s_count;
            3'd3: max_count <= s0_7s_count;
            3'd4: max_count <= s0_6s_count;
            3'd5: max_count <= s0_5s_count;
            3'd6: max_count <= s0_4s_count;
            3'd7: max_count <= s0_3s_count;
          endcase
        end
    end

//  �������������ƶ��ٶȲ���ģ��
//  ����1sʱ���źţ�������Լ��50M��ƽ����һ������
//	 ����֤����
    reg [25:0] count_speed;
    always @ (posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            clk_speed <= 1'b0;
            count_speed <= 26'd0;
        end
        else
            if(count_speed >= max_count)
            begin
                clk_speed <= ~clk_speed;
                count_speed <= 26'd0;
            end
            else
                count_speed <= count_speed + 1;
    end
//	1sʱ�ӵĲ���ģ��
	 reg [25:0] count_1s;
    always @ (posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            clk_1s <= 1'b0;
            count_1s <= 26'd0;
        end
        else
            if(count_1s == s1s_count)
            begin
                clk_1s <= ~clk_1s;
                count_1s <= 26'd0;
            end
            else
                count_1s <= count_1s + 1;
    end	

endmodule
