`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:42:30 05/28/2018 
// Design Name: 
// Module Name:    blink_detect 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: ��д���Ѽ���ģ����뿪���ŵ�����߼���·�У�����ģ��ŵ�ʱ���߼�ģ���У���С��ģ
//					 ��д����ɣ��������
//					  6/10���㷨�Ľ��������ۼ��ģ��ɾ�������������źţ�����ѡ��Ľ�����������Ľ���Ϊ����������
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
//	input: raw_data,
//	output: blink ����ź���ʽΪ�������������ڵĸߵ�ƽ
//
module blink_detect(
    clk,rst,raw_data,blink,num_clk_calcu
    );

    input clk;
    input rst;
	 input [15:0]raw_data;									//	 ��������Ϊ���λΪ ����λ���з�������ʾ��ʽ
    output blink;                               	//  ���Ϊ����һ��ʱ�����ڵĸߵ�ƽ
	 output [9:0] num_clk_calcu;							//	 clk_calcu�ļ���


    reg [31:0] mean_value = 32'd0;              	//  ��ֵ
    reg [31:0] mean_square_value = 32'd2560000;   	//  ����ֵ
    reg [31:0] s_square = 32'd0;                	//  s��ƽ��ֵ

    reg [63:0] k1 = 64'h0000_0000_0000_00ff;					//	8λС����������ʾΪ��0.99609375 B0.11111111
    reg [63:0] k2 = 64'h0000_0000_0000_0001;						//  8λС����������ʾΪ��0.00390625 B0.00000001

    parameter [2:0]
        case_Init = 2'd0,                           //  �����¼�
        case_A = 2'd1,                              //  �����¼�
        case_B = 2'd2;                              //  �����¼�
    
    reg [2:0] state = 3'd0;                         //  ��ǰ�¼�
    reg [7:0] num = 8'd0;                           //  �ƴ���
	 reg [63:0] tmp_1 = 64'd0;						//	��32λ�Ĵ�����ֹ���ݱ��ض�
	 reg [63:0] tmp_2 = 64'd0;
	 reg [31:0] exten_data = 32'd0;
	 reg [31:0] tmp_exten_data = 32'd0;					//	������ʱ����ϴ� raw_data��������ʱ���߼�ģ��Ƚ�

    reg blink = 1'b0;
	
    //  ����ģ��
    //	24 + 8 �Ķ���������ģʽ
	 //  6/11���ԣ�ʱ��Լ�����⣬����ʹ����ģ��ĳ�ʱ���߼�ģ�鲢����ʱ��Ƶ�ʣ���
	 //  6/17��raw_data ���ݸı���з������������з��Ŷ���С������ģ�飡��
	 //  6/17����֤���������֤����
	reg clk_calcu;
	reg [4:0] num_calcu;									//	������19���20������
	parameter [4:0] max_num_calcu = 5'd19;
	//reg calcu_flag;										//	1---����ǰ exten_dataΪ���� 0---����ǰ exten_data Ϊ����
	always @ (posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			tmp_exten_data <= 32'd0;
			exten_data <= 32'd0;
			clk_calcu <= 1'b0;
			num_calcu <= 5'd0;
		end
		else
		begin
			exten_data <= raw_data[15] ? {32'd0}:{8'b0000_0000,raw_data,8'b0000_0000};
			//	��Դ���ʾ
			if(exten_data != tmp_exten_data)
				begin
				tmp_exten_data <= exten_data;
				clk_calcu <= 1'b1;
				num_calcu <= 5'd0;
				end
			else
				num_calcu <= num_calcu + 1;
			if(num_calcu == max_num_calcu)
				begin
					clk_calcu <= 1'b0;
					num_calcu <= 5'd0;
				end
		end	
	end
//	debug: ����clk_calcu �Ĵ���
	
	reg [9:0] num_clk_calcu;
	always @ (posedge clk_calcu or negedge rst)
	begin
		if(!rst)
			num_clk_calcu <= 10'd0;
		else
			num_clk_calcu <= num_clk_calcu + 1'b1;
	end
	
//	ʱ�Ӹ�Ϊ raw_data���ݸı�ʱ��һ������ һ�����ڵ������ز����������ش���
//	6/11 	����֤���������ȷ����
//	6/17  �����з��Ŷ���С�����㣬��֤���������֤������
//	��һ������Ϊ��������Ŀ���
	always @ (posedge clk_calcu or negedge rst)
	begin
		if(!rst)
		    begin
			    mean_value = 32'd0;
			    mean_square_value = 32'd2560000;
			    s_square = 32'd0;
		    end
		else	
			begin
//===============================�����ֵ=================================================	 
			mean_value =  (k1 * mean_value + k2 * exten_data) >> 8;	
//===============================�������ֵ===============================================		  
			mean_square_value = (k1 * mean_square_value  + ((k2 * exten_data) >> 8 ) * exten_data) >> 8;
//===============================����s_square=============================================
//====						�������ݽض����⣬��1�Ĵ�����Ϊ�м����						  
			if(exten_data  > mean_value)
				begin
					tmp_1 = ((exten_data - mean_value) * (exten_data - mean_value)) >> 8;
					tmp_2 = (mean_value * mean_value) >> 8;
					s_square = (tmp_1 << 8) / (mean_square_value - tmp_2);
			    end
			else
				begin
					tmp_1 =  ((mean_value - exten_data) * (mean_value - exten_data)) >> 8;
					tmp_2 = (mean_value * mean_value) >> 8;
					s_square = (tmp_1 << 8) / (mean_square_value - tmp_2);
				end
			end

    end
//  ����ģ��
//  ʱ���߼�ģ��
//	1.����߼�ÿ�θı����ݾ�ִ��һ�Σ���ʱ���߼����ÿ��ʱ����ִ��һ��
//	 6/11: bug:����num ����׼ȷ�Ƴ� ���������ݸ���������
//			 �޸��������������ʱ�ӣ�������½��أ�����20��ʱ�����ڣ�����ʱ����Ӧ����׼����
//			 
    parameter [31:0]
        value_A = 32'd4096;	//32'd2304;                      //  �¼�A��s_square 9 * 256
    //    value_B = 8'd4;                        //  �¼�B��s_square
    parameter [7:0] max_num = 8'd200;            //  ���ƴ���
    always @(negedge clk_calcu or posedge clk_calcu or negedge rst)    
        begin
        if(!rst)
            begin
                state <= case_Init;
                blink <= 1'b0;
                num <= 8'd0;
            end
        else if(!clk_calcu)
				begin
					blink <= 1'b0;
					$display("Now in negedge !");
//===============================�ж��Ƿ�Ϊ�¼�A��������====================================	
					if(num < max_num)
						begin
						if(s_square > value_A && exten_data > mean_value && state == case_Init)
							begin
								state <= case_A;
								num <= 8'd0;  
								blink <= 1'b1;
							end
						else
							num <= num + 1;
						end
					else
						begin
							state <= case_Init;
							num <= 8'd0;
						end
				end
			else
				begin
				$display("Now in posedge !");
				blink <= 1'b0;
				end
				
		end

endmodule
