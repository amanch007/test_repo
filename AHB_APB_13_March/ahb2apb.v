//`timescale 1ns / 1ps
module ahb2apb(	
		hclk,
		hresetn,
		hreadyouts,
		hresps,
		hrdatas,
		haddrs,
		hsels,
		hwrites,
		htranss,
		hsizes,
		hbursts,
		hreadys,
		hwdatas,
	
		paddr,
		psel,
		pwrite,
		penable,
		pwdata,
		prdata,
		pslverr,
		pready
		);

		input			hclk;
		input 			hresetn;
		input 		[31:0] 	haddrs;
		input 			hsels;
		input 			hwrites;
		input 		 [1:0] 	htranss;
		input 		 [2:0] 	hsizes;
		input 		 [2:0] 	hbursts;
		input 			hreadys;
		input 		[31:0] 	hwdatas;

		input 		[31:0] 	prdata;
		input 			pslverr;
		input 			pready;

		output reg 		hreadyouts;
		output reg 	 [1:0] 	hresps;
		output reg 	[31:0] 	hrdatas;

		output reg 		psel;
		output reg 	[31:0] 	paddr;
		output reg 		pwrite;
		output reg 		penable;
		output reg 	[31:0] 	pwdata;

		parameter AHB_IDLE =9'b0_0000_0001;  	//IDLE Phase 
		parameter AHB_R_ADDR=9'b0_0000_0010; 	//Addrs READ phase
		parameter AHB_W_DATA=9'b0_0000_0100; 	//WRITE Data Phase
		parameter AHB_W_TCR1=9'b0_0000_1000; 	//WRITE Control_1 Phase
		parameter AHB_W_TCR2=9'b0_0001_0000; 	//WRITE Control_2 Phase
		parameter AHB_W_ADDR=9'b0_0010_0000; 	//WRITE ADDR Phase
		parameter AHB_R_DATA=9'b0_0100_0000; 	//READ Data Phase
		parameter AHB_R_TCR1=9'b0_1000_0000; 	//READ Control_1 Phase
		parameter AHB_R_TCR2=9'b1_0000_0000; 	//READ Control_2 Phase

		parameter APB_IDLE=4'b0001;	 	//IDLE State
		parameter APB_W_SETUP=4'b0010;		//SETUP for WRITE State
		parameter APB_R_SETUP=4'b0100;		//SETUP for READ State
		parameter APB_ACCESS=4'b1000;		//ACCESS State

		parameter TRANS_IDLE=2'b00;		//IDLE TRANSFER
		parameter TRANS_BUSY=2'b01;		//BUSY TRANSFER
		parameter TRANS_NSEQ=2'b10;		//NSEQ ADDRESS TRANSFER
		parameter TRANS_SEQ= 2'b11;		//SEQ ADDRESS TRANSFER

		parameter  RESP_OKAY=2'b00;		//OKAY RESPONSE
		parameter RESP_ERROR=2'b01;		//ERROR RESPONSE
		parameter RESP_RETRY=2'b10;		//RETRY RESPONSE
		parameter RESP_SPLIT=2'b11;		//SPLIT RESPONSE

		reg [8:0] ahb_cstate,ahb_nstate;	//Current_state and Next_state of AHB
		reg [3:0] apb_cstate, apb_nstate;	//Current_state and Next_state of APB

		//assign hrdatas = prdata;

		always@(posedge hclk or negedge hresetn)
		begin:always_block_1
			if(!hresetn)
				hrdatas <= 32'h0;
			else if (psel & penable & pready & !pwrite)
				hrdatas <= prdata;
			else
 				hrdatas <= hrdatas;
 		end:always_block_1
 
		wire addr_phase;
 		assign addr_phase = hsels & hreadys & (htranss == TRANS_NSEQ);
 
		always@(posedge hclk or negedge hresetn)	//AHB_STATES BLOCK
		begin:always_block_2
			if(!hresetn)
				ahb_cstate <= AHB_IDLE;
			else 	
				ahb_cstate <= ahb_nstate;
		end:always_block_2

		always@(addr_phase,ahb_cstate,hwrites,apb_cstate,pready,pslverr) 
		begin:always_block_3
				ahb_nstate = ahb_cstate;
			case(ahb_cstate)
				AHB_IDLE	:	begin
								if(addr_phase & hwrites)
									ahb_nstate = AHB_W_ADDR;  //decides to write
								else if (addr_phase & ~hwrites)
									ahb_nstate = AHB_R_ADDR;  //decides to read 
							end
				AHB_W_ADDR	:	begin
								if(apb_cstate == APB_ACCESS)
									if (pready)
										if (!pslverr)
											ahb_nstate = AHB_IDLE;
										else
											ahb_nstate = AHB_W_TCR1;
							end
				AHB_W_TCR1	:	begin
								ahb_nstate = AHB_W_TCR2;
							end
				AHB_W_TCR2 	:	begin
							ahb_nstate = AHB_IDLE;
							end
				AHB_R_ADDR 	:	begin
								if(apb_cstate == APB_ACCESS)
									if(pready)
										if(!pslverr)
											ahb_nstate = AHB_IDLE;
										else
											ahb_nstate = AHB_R_TCR1;
							end
				AHB_R_TCR1	:	begin 	
								ahb_nstate = AHB_R_TCR2;
							end
				AHB_R_TCR2	:	begin
								ahb_nstate = AHB_IDLE;
							end
			endcase
		end:always_block_3

		always@(posedge hclk or negedge hresetn)
		begin:always_block_4
			if(!hresetn) 
				begin
					hreadyouts <=1'b1;
					hresps <= RESP_OKAY;
				end
			else if(ahb_nstate == AHB_IDLE) 
				begin
					hreadyouts <= 1'b1;
					hresps <= RESP_OKAY;
				end
			else if(ahb_nstate == AHB_W_ADDR || ahb_nstate == AHB_R_ADDR) 
				begin
					hreadyouts <= 1'b0;
					hresps <= RESP_OKAY;
				end
			else if(ahb_nstate == AHB_W_TCR1 || ahb_nstate == AHB_R_TCR1) 
				begin
					hreadyouts <= 1'b0;
					hresps <= RESP_ERROR;
				end
			else if(ahb_nstate == AHB_W_TCR2 || ahb_nstate ==  AHB_R_TCR2) 
				begin
					hreadyouts <= 1'b1;
					hresps <= RESP_ERROR;
				end
		end:always_block_4

		always@(posedge hclk or negedge hresetn) 	//APB STATES INITIALIZATION on hreset
		begin:always_block_5
			if(!hresetn)
				apb_cstate <= APB_IDLE;
			else 
				apb_cstate <= apb_nstate;
		end:always_block_5

		always@(apb_cstate,ahb_nstate,pready)		//APB STATES
		begin:always_block_6
			apb_nstate = apb_cstate;
			case(apb_cstate)
				APB_IDLE	:	begin
								if(ahb_nstate == AHB_W_ADDR)
									apb_nstate = APB_W_SETUP;
								else if(ahb_nstate == AHB_R_ADDR)
									apb_nstate = APB_R_SETUP;
							end
				APB_W_SETUP	: 	begin
								apb_nstate = APB_ACCESS;
							end
				APB_R_SETUP	: 	begin
								apb_nstate = APB_ACCESS;
							end
				APB_ACCESS	:	begin
						 		if(!pready) 
									apb_nstate = APB_ACCESS;
								else 
									apb_nstate = APB_IDLE;
							end
			endcase
		end:always_block_6

		always@(posedge hclk or negedge hresetn)	//TASK what to do on Various States of APB 
		begin:always_block_7
			if(!hresetn)	//on reset 
				begin
					paddr <= 32'h0;
					psel <= 1'b0;
					penable <= 1'b0;
					pwrite  <= 1'b0;
					pwdata <= 32'h0;
				end
			else if (apb_nstate == APB_IDLE) 
				begin
					paddr <= 1'b0;
					psel <= 1'b0;
					penable <= 1'b0;
				end
			else if (apb_nstate == APB_W_SETUP) 
				begin
					paddr <= haddrs;
					psel <= 1'b1;
					pwrite <= 1'b1;
				end
			else if (ahb_nstate == APB_R_SETUP) 
				begin
					paddr <= haddrs;
					psel <= 1'b1;
					pwrite <= 1'b0;
				end
			else if (apb_nstate == APB_ACCESS) 
				begin
					penable <= 1'b1;
					pwdata <= hwdatas;
				end
		end:always_block_7
endmodule
