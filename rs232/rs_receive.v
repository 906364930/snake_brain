`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:53:46 05/19/2018 
// Design Name: 
// Module Name:    rs_receive 
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
module rs_receive(  
    input rx_data,//���յ��Ĵ�������  
    input clk,  
    input rst,  
    output [7:0] byte_data_out,//������ɵ�һ�ֽ��������  
    input rs_clk,//�����������Ч����ʱ��ʱ��  
    output reg rs_ena='b0//��Ч���ݵ�����־  
    );  
   
//++++++++++++++++++++++++++++++++++++++++++++++  
  reg rx_data0='b0;  
  reg rx_data1='b0;   
  reg rx_data2='b0;//�����Ĵ���������ȡ��Ч���ݵ��½��أ�  
  wire neg_rx_data=~rx_data1 & rx_data2;//�½���ʱ���źŵ�ƽΪ��    
  always @(posedge clk or negedge rst)    
  begin  
    if(!rst)  
      begin  
            rx_data0<='b0;  
            rx_data1<='b0;  
            rx_data2<='b0;  
      end  
     else  
        begin  
            rx_data0<=rx_data;  
            rx_data1<=rx_data0;  
            rx_data2<=rx_data1;  
        end  
  end  
 //+++++++++++++++++++++++++++++++++++++++++++++  
 reg rx_int='b0;//�����ж��ź�  
 //reg rs_ena;  
  reg [3:0]num='d0;  
 always @(posedge clk or negedge rst)  
 begin  
    if(!rst)  
     begin  
        rx_int<='b0;  
        rs_ena<='bz;  
     end  
     else  
        if(neg_rx_data)  
            begin  
                rx_int<='b1;//�½��ص���ʱ�����������ж�--���ڼ伴ʹ���½��ص���Ҳ����ᣬ��ʱʹ��ģ��1����rs_enaΪ�ߵ�ƽ��  
                rs_ena<='b1;  
             end  
        else  
           if(num=='d10)  
            begin  
                rx_int<='b0;//num==10,�����ݽ������ʱ���жϽ�����  
                rs_ena<='b0;  
            end  
 end  
 reg [7:0]rx_data_buf='d0;//�����źŻ���������������һλһλ���䣬�������̸�ֵ��������ڻ������ݣ�����������ٸ�ֵ�����  
 reg [7:0]data_byte_r='d0;//�Ĵ����ͣ�������ɸ�ֵ����󸳸������  
 assign byte_data_out=data_byte_r;  
  
 always @(posedge clk or negedge rst)  
 begin  
        if(!rst)  
            num<='d0;  
         else   
         if(rx_int)  
          begin  
              if(rs_clk)//�ڽ����жϵ�����£�����һ�β���ʱ�ӽ���һ���������㣬  
                 begin  
                    num<=num+1'b1;  
                    case(num)  
                     'd1:rx_data_buf[0]<=rx_data;  
                     'd2:rx_data_buf[1]<=rx_data;  
                     'd3:rx_data_buf[2]<=rx_data;  
                     'd4:rx_data_buf[3]<=rx_data;//�������μ��뵽������  
                       
                     'd5:rx_data_buf[4]<=rx_data;  
                     'd6:rx_data_buf[5]<=rx_data;  
                     'd7:rx_data_buf[6]<=rx_data;  
                     'd8:rx_data_buf[7]<=rx_data;  
                     default:;  
                    endcase  
                  end  
                else  
                  if(num=='d10)  
                     begin//���ݽ�����ɣ����������ݽ����Ĵ�����ͬʱ����������  
                        num<='d0;  
                        data_byte_r<=rx_data_buf;  
                     end  
            end  
 end  
    
endmodule
