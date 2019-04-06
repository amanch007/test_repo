`define dcb intf.DRIVER.driver_cb
	
class driver extends uvm_driver#(sequence_item);
 `uvm_component_utils(driver)

	virtual inf intf;	
	sequence_item tx;	
	
	function new(string name="driver", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(),"We are in driver's build Phase", UVM_LOW);
			if(uvm_config_db#(virtual inf)::get(null,"*","vif",intf))
				`uvm_info(get_name(),"Virtual Interface taken from Top to Driver", UVM_LOW);	
			tx = sequence_item::type_id::create("tx");
	endfunction:build_phase
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_full_name(),"We are in driver's connect Phase", UVM_LOW);
	endfunction
	
	task reset_phase (uvm_phase phase);
         	super.reset_phase (phase);
         		phase.raise_objection (phase);
                 		if(!intf.reset)
					begin
					reset();	
    					$display("APPLYING RESET");
					end
        			else
					$display("OUT OF RESET");
         		phase.drop_objection (phase);
      endtask:reset_phase
	
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
		      	seq_item_port.get_next_item(tx);
				drive();
      			seq_item_port.item_done();
			end
  		endtask:run_phase	
	
	virtual task reset();
			begin:reset_logic
			`dcb.haddrs	<= 32'b0; 
			`dcb.hsels	<=  1'b0; 
			`dcb.hwrites	<=  1'b0; 
			`dcb.htranss	<=  2'b0; 
			`dcb.hsizes	<=  3'b0; 
			`dcb.hbursts	<=  3'b0; 
			`dcb.hreadys	<=  1'b0; 
			`dcb.hwdatas	<= 32'b0; 
			`dcb.prdata	<= 32'b0; 
			`dcb.pslverr	<=  1'b0; 
			`dcb.pready	<=  1'b0; 
	
		#100	
			`dcb.haddrs	<= 32'b1; 
			`dcb.hsels	<=  1'b1; 
			`dcb.hwrites	<=  1'b1; 
			`dcb.htranss	<=  2'b1; 
			`dcb.hsizes	<=  3'b1; 
			`dcb.hbursts	<=  3'b1; 
			`dcb.hreadys	<=  1'b1; 
			`dcb.hwdatas	<= 32'b1; 
			`dcb.prdata	<= 32'b1; 
			`dcb.pslverr	<=  1'b1; 
			`dcb.pready	<=  1'b1; 
			
			end:reset_logic 		
	endtask:reset 	
	
	virtual task drive();
		@(posedge intf.DRIVER.clock)	
			begin:driver_logic
			//	`dcb.	<= tx.;
			end:driver_logic
	endtask:drive 	 	
	

endclass:driver

