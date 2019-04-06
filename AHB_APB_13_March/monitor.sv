
class monitor extends uvm_monitor;
 `uvm_component_utils(monitor)

  	virtual inf intf;
	sequence_item h_collected_tx;
  	
	//uvm_analysis_port #(sequence_item) item_collected_port;
	
	function new(string name="monitor", uvm_component parent);
		super.new(name,parent);
		h_collected_tx = new();
   		//tx_collected_port = new("item_collected_port", this);
	endfunction:new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(), "We are in Biuld_Phase of Monitor", UVM_LOW);
			if(uvm_config_db#(virtual inf)::get(null,"*","vif",intf))
				`uvm_info(get_name(),"Virtual Interface taken from Top to Monitor", UVM_LOW);		
	endfunction:build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_full_name(), " We are in Connect Phase of Monitor", UVM_LOW);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		`uvm_info(get_full_name(), "TOPOLOGY is shown as:-", UVM_LOW);
	endfunction
	
  	virtual task run_phase(uvm_phase phase);
    		forever 
			begin
      				@(posedge intf.MONITOR.clock);
      				//	wait(vif.monitor_cb.wr_en || vif.monitor_cb.rd_en);
        			//	h_collected_tx. = vif.monitor_cb.dr;
	  			//item_collected_port.write(h_collected_tx);
      			end 
  endtask : run_phase

endclass:monitor



