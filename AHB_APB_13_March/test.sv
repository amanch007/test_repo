class test extends uvm_test;
	`uvm_component_utils(test)

		seq 		h_seq;
		environment 	h_env;

	function new(string name="test", uvm_component parent=null);
		super.new(name,parent);
	endfunction:new
	
	virtual function void build_phase(uvm_phase phase);
   			super.build_phase(phase);
			h_env=environment::type_id::create("h_env",this);
			`uvm_info(get_full_name(), "We are in test Class", UVM_LOW);
			h_seq=seq::type_id::create("h_seq",this);
  		endfunction:build_phase
  
	virtual function void end_of_elaboration();
    		//	uvm_top.print();
		uvm_top.print_topology;
  		endfunction:end_of_elaboration

	/*function void report_phase(uvm_phase phase);
		uvm_report_server svr;
   		super.report_phase(phase);
   			svr = uvm_report_server::get_server();
   			if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) 
				begin
     					`uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     					`uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
     					`uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    				end
    			else 
				begin
     					`uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     					`uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
     					`uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    				end
	endfunction:report_phase*/

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
      			h_seq.start(h_env.h_agent.h_seqn);
    		phase.drop_objection(this);
			phase.phase_done.set_drain_time(this, 50);
	endtask:run_phase

endclass:test


