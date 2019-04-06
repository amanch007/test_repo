interface inf(input logic clock,reset);
	
	//	logic			hclk;
	//	logic 			hresetn;
		logic 		[31:0] 	haddrs;
		logic 			hsels;
		logic 			hwrites;
		logic 		 [1:0] 	htranss;
		logic 		 [2:0] 	hsizes;
		logic 		 [2:0] 	hbursts;
		logic 			hreadys;
		logic 		[31:0] 	hwdatas;

		logic 		[31:0] 	prdata;
		logic 			pslverr;
		logic 			pready;

		logic     		hreadyouts;
		logic     	 [1:0] 	hresps;
		logic     	[31:0] 	hrdatas;

		logic     		psel;
		logic     	[31:0] 	paddr;
		logic     		pwrite;
		logic     		penable;
		logic     	[31:0] 	pwdata;


  	clocking driver_cb @(posedge clock);
    		default input #0 output #0;
		output 	haddrs;
		output 	hsels;
		output 	hwrites;
		output 	htranss;
		output 	hsizes;
		output 	hbursts;
		output 	hreadys;
		output 	hwdatas;

		output	prdata;
		output	pslverr;
		output 	pready;

		input 	hreadyouts;
		input 	hresps;
		input 	hrdatas;
		
		input 	psel;
		input 	paddr;
		input 	pwrite;
		input 	penable;
		input 	pwdata;
  	endclocking:driver_cb
  
  	clocking monitor_cb @(posedge clock);
    		default input #0 output #0;
		output	prdata;
		output	pslverr;
		output 	pready;

		input 	hreadyouts;
		input 	hresps;
		input 	hrdatas;
		
		input 	psel;
		input 	paddr;
		input 	pwrite;
		input 	penable;
		input 	pwdata;
  	endclocking:monitor_cb
  
  modport DRIVER  (clocking driver_cb,input clock,reset);
  
  modport MONITOR (clocking monitor_cb,input clock,reset);
  

endinterface:inf
	
	
