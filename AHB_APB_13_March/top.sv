module top();
	
	import uvm_pkg::*;
	import pkg::*;
	`include "uvm_macros.svh"	
	
	
	bit clock,reset;
	
	inf intf(clock,reset);

	ahb2apb DUT(
			.hclk(intf.clock),
			.hresetn(intf.reset),
			.hreadyouts(intf.hreadyouts),
			.hresps(intf.hresps),
			.hrdatas(intf.hrdatas),
			.haddrs(intf.haddrs),
			.hsels(intf.hsels),
			.hwrites(intf.hwrites),
			.htranss(intf.htranss),
			.hsizes(intf.hsizes),
			.hbursts(intf.hbursts),
			.hreadys(intf.hreadys),
			.hwdatas(intf.hwdatas),
	
			.paddr(intf.paddr),
			.psel(intf.psel),
			.pwrite(intf.pwrite),
			.penable(intf.penable),
			.pwdata(intf.pwdata),
			.prdata(intf.prdata),
			.pslverr(intf.pslverr),
			.pready(intf.pready)
		);	
	
	
	always 
	 	#5 clock=~clock;
	initial
		begin
		reset=0;
		#5 reset =1;
		end
	
	initial begin
		uvm_config_db#(virtual inf)::set(uvm_root::get(),"*","vif",intf);		
		run_test("test");
	//	# 1000 $finish;
		end
endmodule

