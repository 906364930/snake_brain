`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:31:00 06/20/2018 
// Design Name: 
// Module Name:    brain_direction 
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
//  �Ե粨�����ж�ģ��
//	 in: blink�ź�Ϊ��������ʱ��ĸߵ�ƽ
//  out: brain_right,brain_left����ź���ʽΪ100MHz�ĸߵ�ƽ

module brain_direction(
	clk,rst,blink,brain_right,brain_left
    );
    input clk,rst;
    input blink;
    output brain_left,brain_right;
	 
	 

//  2s�ķ�Ƶģ�飺��2sʱ���ڵ�գ�۴���
//  ��գ�۴���Ϊ1ʱ�����ת�ź�
//  ��գ�۴���Ϊ���ڵ���2ʱ�����ת�ź�
//	 6/20������֤������
/*	reg [27:0] count_2s;
	reg blink_1;
	reg blink_2;
	reg [2:0] blink_num;
    parameter [27:0]
        s2s_count = 28'd268435456;
//			 s2s_count = 28'd100;
//        s_0_5_count = 27'd687432000;
    always @ (posedge clk or negedge rst)
    begin
        if(!rst)									//		!rst �е��źŲ������ã�����
		  begin
            count_2s <= 28'd0;
				brain_left <= 1'b0;
				brain_right <= 1'b0;	
		  end
        else
        begin
				brain_left <= 1'b0;
				brain_right <= 1'b0;
            if(count_2s == s2s_count)
            begin
					 count_2s <= 28'd0;
                if(blink_num == 1)
                    brain_left <= 1'b1;
                else if(blink_num >= 2)
                    brain_right <= 1'b1;
            end
            else
                count_2s <= count_2s + 1;
        end
    end
	 
	 always @ (posedge clk or negedge rst)
	 if(!rst)
		 begin
				blink_num <= 3'd0;
		 end
	 else
		begin
				blink_1 <= blink;
				blink_2 <= blink_1;
				if(blink_1 && !blink_2)
					blink_num <= blink_num + 1'b1;
	 end*/

	 

endmodule
