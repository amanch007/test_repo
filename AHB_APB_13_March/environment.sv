class environment extends uvm_env;
	`uvm_component_utils(environment)
	   
	agent h_agent;

	function new(string name="environment", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		h_agent=agent::type_id::create("h_agent",this);
		`uvm_info(get_full_name()," We are in environment", UVM_LOW);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_full_name(), " We are in Connect Phase of environment", UVM_LOW);
	endfunction

endclass:environment




