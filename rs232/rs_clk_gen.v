`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:52:25 05/19/2018 
// Design Name: 
// Module Name:    rs_clk_gen 
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
module rs_clk_gen(  
    clk,rst,rs_clk,rs_ena  
     );  
 input clk;//ϵͳʱ��  
 input rst;//��λ�ź�  
 input rs_ena; //����ͨ�������ź�  
 output rs_clk; //�������Ĳ������ź�ʱ��  
   
 parameter N1=10417;//10417,9600bps 100M��ϵͳʱ�ӣ�  
 parameter N2=5207;//5207,������0-5207��������5208��  
   
 reg rs_clk='b0;  
 reg [13:0] count='d0;//������  
   
 always @(posedge clk or negedge rst)  
 begin  
    if(!rst)  
       begin  
        count<='d0;  //��λ�źŵ���ʱ��count����������  
        end  
    else  
       if(count==N1 || !rs_ena) count<='d0;//��count���������޴���ͨ��ʹ��ʱcount��������  
        else count<=count+'b1;//���ҽ���count��Ϊ0��ͨ��ʹ��ʱcount������  
 end  
 always @(posedge clk or negedge rst)  
 begin    
    if (!rst)  
     rs_clk<='b0;  
     else  
       if(count==N2&&rs_ena)		//���ҽ���count������һ�� 5207 ��ͨ��ʹ��ʱ����ʱ�ӷ�ת  
          rs_clk<='b1;           //  
          else   
          rs_clk<='b0;				//ʹ��rs_clk��һ��С�����ʱ���źţ�����Ч�źŵ�����λΪ�ߵ�ƽ��  
            
 end  
 endmodule  