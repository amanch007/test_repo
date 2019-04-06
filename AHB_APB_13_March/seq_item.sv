class sequence_item extends uvm_sequence_item;
   `uvm_object_utils(sequence_item)

		rand bit 	[31:0] 	haddrs;
		rand bit 		hsels;
		rand bit 		hwrites;
		rand bit 	 [1:0] 	htranss;
		rand bit 	 [2:0] 	hsizes;
		rand bit 	 [2:0] 	hbursts;
		rand bit 		hreadys;
		rand bit 	[31:0] 	hwdatas;

		rand bit	[31:0] 	prdata;
		rand bit 		pslverr;
		rand bit 		pready;

		     bit 		hreadyouts;
		     bit 	 [1:0] 	hresps;
		     bit 	[31:0] 	hrdatas;

		     bit 		psel;
		     bit 	[31:0] 	paddr;
		     bit 		pwrite;
		     bit 		penable;
		     bit 	[31:0] 	pwdata;
	   

	   function new(string name="sequence_item");
		super.new(name);
	   endfunction

endclass:sequence_item

