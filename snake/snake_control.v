`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:57:06 06/05/2018 
// Design Name: 
// Module Name:    snake_control 
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
//  �������ģ�飺
//  ����Ĵ洢��10��reg 
//  ��Ҫ��֤����ü��㣺1.�ܷ���ȷ����1sʱ���ź� 2.���շ��������ܷ�˳���� 3.�����ܷ���ȷ�ı� 4.�ܷ���ȷ��� apple_refresh�ź�
//                    5.�ܷ���ȷ��� is_snake,is_appple�ź� 6. �ܷ���ȷ��� is_crash�ź�
//	 ���ԣ��޸ģ�1.1sʱ�Ӳ��� count_1s
//	 6/20ɾ��ƻ����С�ı�ģ�飻�����ֶ����Ե粨���ƣ��Ե������ת���ź��ǣ�100MHz�Ķ������źţ������л����õڶ������뿪�أ�����

`include "Definition.h"

module snake_control(
    clk,clk_1s,clk_25M,rst,left_bt,right_bt,game_status,x_pos,y_pos,apple_x_pos,apple_y_pos,is_snake,is_apple,is_crash,score,apple_gen,is_suicide,
	 man_control,brain_right,brain_left
    );
    input rst;
    input clk;                                  //  ����100MHzƵ�ʣ�������������
    input clk_1s;
    input clk_25M;                              //  ����25MHzʱ��Ƶ��
    input left_bt,right_bt;                     //  �������ƶ�
    input [1:0] game_status;                    //  ��Ϸ״̬
    input [6:0] x_pos;                          //  ��ʱɨ�赽�� x,y ����
    input [5:0] y_pos;
    input [6:0] apple_x_pos;                    //  ��ʱ��ƻ���� x,y ����
    input [5:0] apple_y_pos;
	 input man_control;									//	 �˹��������Ե���Ƶ��л�
	 input brain_right,brain_left;					//	 �Ե��������������ת��
    output reg is_snake,is_apple;               //  ���������ƻ����ɫ������Ϣ;�ź���ʽΪ����һ�� 25MHz һ�����ڵĸߵ�ƽ
    output is_crash;                        		//  ����Ƿ�ײ��ǽ��;�ź���ʽΪ�����ߵ�ƽ ʱ��Ϊ 1s
    output reg [2:0] score;                     //  �����ǰ������Ϣ��max = 7
    output reg apple_gen;                   		//  ���ƻ��ˢ���źţ�����ź���ʽ������1����25Mʱ�����ڵĸߵ�ƽ
    output is_suicide;                      		//  ����Ƿ��Ծ�������ź���ʽΪ������һ�� 1s �ĸߵ�ƽ

    reg [6:0] snake_x_pos [9:0];                //  �洢�����x����
    reg [5:0] snake_y_pos [9:0];                //  �洢�����y����
    reg snake_valid [9:0];                      //  �洢�������Чλ

//  �������������ƶ��ٶȲ���ģ��
//  ����1sʱ���źţ�������Լ��50M��ƽ����һ������
//	 ����֤����
/*    reg clk_1s;
    reg [25:0] count_1s;
    always @ (posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            clk_1s <= 1'b0;
            count_1s <= 26'd0;
        end
        else
            //if(count_1s == 26'd52428800)
				if(count_1s == 26'd5)
            begin
                clk_1s <= ~clk_1s;
                count_1s <= 26'd0;
            end
            else
                count_1s <= count_1s + 1;
    end*/

//  �������ģ�飺״̬�����ݵ�ǰ����״̬�����밴����������ǰ�ķ�����Ϣ
//	 6/7�ģ�1.ͨ���س������жϷ��򣻷���ʱ��Ƶ�ʹ��죬��ƽ�жϷ���᲻�ϸı�
//	  		  2.����֤����
//	 6/8�⣺ԭ��������ڰ�����ʱ����̣������ش�����ִ�� else ���·����޸ģ�����
//   6/16�⣺����Ӧ���ǰ����������·���ı�����ң��������ģ��

//  ����˼·��ͨ�������һ��ʱ���������ƽ���ж��Ƿ�Ϊ���°�������ʱʱ��Ϊ20ms
//  ����źű���Ϊ�����ٳ��� 20ms�ĵ�ƽ������
//  in: left_bt,right_bt
//  out: left_button,right_button
//	 ����֤������
    reg reg_left_bt_1,reg_left_bt_2;
    reg reg_right_bt_1,reg_right_bt_2;
    wire left_button,right_button;
    reg [10:0] count_button;
    always @ (posedge clk or negedge rst)
    begin
      if(!rst)
		begin
        count_button <= 11'd0;
		  reg_left_bt_1 <= 1'b0;
		  reg_left_bt_2 <= 1'b0;
		  reg_right_bt_1 <= 1'b0;
		  reg_right_bt_2 <= 1'b0;
		end
      else
        begin
          if(count_button == 11'h7ff)
          begin
            reg_left_bt_1 <= left_bt;
            reg_right_bt_1 <= right_bt;
            count_button <= 11'h0;
			reg_left_bt_2 <= reg_left_bt_1;
			reg_right_bt_2 <= reg_right_bt_1;
          end
          else
				count_button <= count_button + 1;
        end
    end

    assign left_button = ~reg_left_bt_2 & reg_left_bt_1;
    assign right_button = ~reg_right_bt_2 & reg_right_bt_1;

//  �������źţ�������߼������� clk �ᱨ warning��
//	 ����֤����
    reg left_1,left_2;
    reg right_1,right_2;
    reg is_left,is_right;
    always @ (posedge clk)
    begin
        left_1 <= left_button;
        left_2 <= left_1;
        right_1 <= right_button;
        right_2 <= right_1;
    end
//	 �����ֶ��������Ե粨����ģ���л�
//
	 always @ (posedge clk)
	 begin
		if(!man_control)
			begin
				is_right <= right_1 & ~right_2;
				is_left <= left_1 & ~left_2;
			end
		else
			begin
				is_right <= brain_right;
				is_left <= brain_left;
			end
	 end
	 
    parameter [1:0]
        up = 2'd0,
        right = 2'd1,
        down = 2'd2,
        left = 2'd3;
    reg [1:0] direction;
    always @ (posedge clk or negedge rst)
    begin
      if(!rst)
        begin
            direction <= right;
        end
      else
        begin
          case (direction)
            up: begin if(is_left) direction <= left; else if(is_right) direction <= right; end
            right: begin if(is_left) direction <= up; else if(is_right) direction <= down; end
            down: begin if(is_left) direction <= right; else if(is_right) direction <= left; end
            left: begin if(is_left) direction <= down; else if(is_right) direction <= up; end
            default: ;
          endcase
        end
    end

//  �����ƶ�ģ�飺���ݵ�ǰ������Ϣ��ÿ��1s���в�������
//  ����ͷ��������ֱ�ӽ���˳��ǰ��Ľ��и���ǰ��������Ϣ����Ȼֻ�Ǹ��� valid ������
//  �����ʼ��Ϊ(40,30),(39,30)
//	 6/7: ���ԣ�snake_x_pos,snake_y_pos�����궼��˳���ƽ�
//	 6/7������֤����
    integer i;
    always @ (posedge clk_1s or negedge rst)
    begin
      if(!rst)
        begin
          snake_x_pos[0] <= 7'd40;
          snake_y_pos[0] <= 6'd30;
          snake_x_pos[1] <= 7'd39;
          snake_y_pos[1] <= 6'd30;
          snake_x_pos[2] <= 7'd0;
          snake_y_pos[2] <= 6'd0;
          snake_x_pos[3] <= 7'd0;
          snake_y_pos[3] <= 6'd0;
          snake_x_pos[4] <= 7'd0;
          snake_y_pos[4] <= 6'd0;
          snake_x_pos[5] <= 7'd0;
          snake_y_pos[5] <= 6'd0;
          snake_x_pos[6] <= 7'd0;
          snake_y_pos[6] <= 6'd0;
          snake_x_pos[7] <= 7'd0;
          snake_y_pos[7] <= 6'd0;
          snake_x_pos[8] <= 7'd0;
          snake_y_pos[8] <= 6'd0;
          snake_x_pos[9] <= 7'd0;
          snake_y_pos[9] <= 6'd0;
        end
        else
            begin
                case(direction)
                up: snake_y_pos[0] <= snake_y_pos[0] - 1;
                right: snake_x_pos[0] <= snake_x_pos[0] + 1;
                left: snake_x_pos[0] <= snake_x_pos[0] - 1;
                down: snake_y_pos[0] <= snake_y_pos[0] + 1;
                default: ;
                endcase
                for(i=1;i<=9;i=i+1)
                begin
                snake_x_pos[i] <= snake_x_pos[i-1];
                snake_y_pos[i] <= snake_y_pos[i-1];
                end    
            end
    end

//	 �ߵ���ҧ�ж�
//	 ѭ���Ƚ��ж��Ƿ������غ�

	 assign is_suicide = (snake_x_pos[0] == snake_x_pos[4] && snake_y_pos[0] == snake_y_pos[4] && snake_valid[4]) || 
								(snake_x_pos[0] == snake_x_pos[5] && snake_y_pos[0] == snake_y_pos[5] && snake_valid[5]) ||
								(snake_x_pos[0] == snake_x_pos[6] && snake_y_pos[0] == snake_y_pos[6] && snake_valid[6]) ||
								(snake_x_pos[0] == snake_x_pos[7] && snake_y_pos[0] == snake_y_pos[7] && snake_valid[7]) ||
								(snake_x_pos[0] == snake_x_pos[8] && snake_y_pos[0] == snake_y_pos[8] && snake_valid[8]) ||
								(snake_x_pos[0] == snake_x_pos[9] && snake_y_pos[0] == snake_y_pos[9] && snake_valid[9]);
//  �ж����Ƿ�����ǽ��
//  ��� is_crash �ߵ�ƽ�źţ�����1s�ĸߵ�ƽ
//	 6/7���ԣ�1.��snake_x_pos = 80 && direction = right is_crash �ź���� clk_1s���ڸߵ�ƽ
//				 2.snake_x_pos ���ӵ� 123 etc...
//	 6/7������֤����
	 
	 assign is_crash = (snake_x_pos[0] == `left_border) ||
								(snake_x_pos[0] == `right_border) ||
								(snake_y_pos[0] == `up_border) ||
								(snake_y_pos[0] == `down_border);
//  �ж����Ƿ�Ե�ƻ��
//  in: apple_x_pos,apple_y_pos,snake_x_pos,snake_y_pos
//  out: snake_valid,score
//	  6/7���ԣ�1.score ���� 2. snake_valid����
//	  6/7������֤����
    always @ (posedge clk_1s or negedge rst)
    begin
      if(!rst)
        begin
            score <= 3'd0;
				snake_valid[0] <= 1'b1;
				snake_valid[1] <= 1'b1;
				snake_valid[2] <= 1'b0;
				snake_valid[3] <= 1'b0;
				snake_valid[4] <= 1'b0;
				snake_valid[5] <= 1'b0;
				snake_valid[6] <= 1'b0;
				snake_valid[7] <= 1'b0;
				snake_valid[8] <= 1'b0;
				snake_valid[9] <= 1'b0;
        end
       else
        if(snake_x_pos[0] == apple_x_pos && snake_x_pos[0] == apple_x_pos && snake_y_pos[0] == apple_y_pos && snake_y_pos[0] == apple_y_pos)
            begin
              score <= score + 1;
              snake_valid[score+2] <= 1'b1;
            end

    end
//  ����ƻ����С�ɱ�ģ�飬����רע�ȵ���ƻ����С
//  ���� size��С��0,1,2,3,4,��Ϊ�����ȼ���apple_x_pos,apple_y_pos����apple���Ͻ������С
//  in: size [0,4]
//  out: 








//  ����Ƚ�����ƻ���Ľ�� is_snake,is_apple
//  in: snake_x_pos,snake_y_pos,snake_valid,x_pos,y_pos
//  out: is_snake,is_apple
//	 6/7�����ԣ�1.�߼���ȷ 2.���Ϊ clk_25M һ�����ڵĸߵ�ƽ
//	 6/7: ����֤����
    integer j;
    always @ (posedge clk_25M or negedge rst)
    begin
      if(!rst)
        begin
          is_snake <= 1'b0;
          is_apple <= 1'b0;
        end
      else
        begin
          is_snake <= 1'b0;
          is_apple <= 1'b0;
          for(j=0;j<=9;j=j+1)
            begin
              if(snake_valid[j] == 1'b1)
                if(x_pos == snake_x_pos[j] && y_pos == snake_y_pos[j])
                    is_snake <= 1'b1;
            end
          if(x_pos == apple_x_pos && x_pos == apple_x_pos && y_pos == apple_y_pos && y_pos == apple_y_pos)
            is_apple <= 1'b1;
        end
    end
//  ������ƻ���Ƚ�ȷ��ģ�飺����ѭ���Ƚ����жϵ�ǰ�Ƿ���������ƻ�����沿λ
//  ƻ���Ĳ���ģ�������������Ӧ�ñ�֤��������ǽ����
//  ˼·Ϊ������25MHz����Ϊ�жϵıȼ�ʱ�ӣ�����������1s���ж�θı����
//  Ϊ�����·�����ü����Ƚϵķ�ʽ����ֹ for ѭ�����ֵ�·������󣬱Ͼ�ǰ���Ѿ����ֶ�� for ѭ��
//    in:x_pos,y_pos,clk_25M
//    out:apple_refresh
//	 6/8���ԣ����߳Ե�ƻ��ʱ������һ��25Mʱ�����ڵĸߵ�ƽ apple_refresh�ź�
//	 6/8������֤
    reg [2:0] score_bak;
	reg apple_refresh;
    always @ (posedge clk_25M or negedge rst)
    begin
      if(!rst)
        apple_refresh <= 1'b0;
      else
        begin
          apple_refresh <= 1'b0; 
			 score_bak <= score;
          if(score != score_bak)			//	�Ե�ƻ���÷�����£�ˢ��ƻ��
            apple_refresh <= 1'b1;		//���� apple_refresh������Ϣ���ܳ�����???????????????????????????????????????????????
        end
    end
//  ������ƻ���Ƚ�ȷ��ģ�飺����ѭ���Ƚ����жϵ�ǰ�Ƿ���������ƻ�����沿λ
//  ƻ���Ĳ���ģ�������������Ӧ�ñ�֤��������ǽ����
//  ˼·Ϊ������25MHz����Ϊ�жϵıȼ�ʱ�ӣ�����������1s���ж�θı����
//  Ϊ�����·�����ü����Ƚϵķ�ʽ����ֹ for ѭ�����ֵ�·������󣬱Ͼ�ǰ���Ѿ����ֶ�� for ѭ��
//    in:x_pos,y_pos,clk_25M
//    out:apple_superpos
    reg [3:0] pos_num;
    reg apple_superpos;                 //  ��ʾ����ƻ�������������غ�
    parameter [3:0] max_pos_num = 4'd9;
    always @ (posedge clk_25M or negedge rst)
    begin
      if(!rst)
      begin
        apple_superpos <= 1'b0;
        pos_num <= 4'd0;
      end
      else
        begin
            apple_superpos <= 1'b0;
			if(pos_num == max_pos_num)
                pos_num <= 4'd0;
			else
				pos_num <= pos_num + 1;
            if(apple_gen && snake_x_pos[pos_num] == apple_x_pos && snake_y_pos[pos_num] == apple_y_pos && snake_valid[pos_num] == 1'b1)
                apple_superpos <= 1'b1;
        end

    end
//	���� apple_gen �ź�
    always @ (posedge clk_25M or negedge rst)
    begin
      if(!rst)
        apple_gen <= 1'b0;
      else
		begin
        if(apple_refresh)
            apple_gen <= 1'b1;
        if(apple_gen && !apple_superpos)
            apple_gen <= ~apple_gen;
		end
    end    
//  �����ж��Ƿ�ҧ���Լ�
//  in: clk_1s,rst,snake_x_pos,snake_y_pos
//  out: is_suicide



endmodule
