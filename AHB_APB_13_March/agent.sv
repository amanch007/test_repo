class agent extends uvm_agent;
	`uvm_component_utils(agent)

	sequencer 	h_seqn;
	driver 		h_dri;
	monitor 	h_mon;

	function new(string name="agent", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(), "We are in agent's build_phase",UVM_LOW);
		 h_seqn=sequencer::type_id::create("h_seqn",this);
		 h_dri =driver::type_id::create("h_dri", this);
		 h_mon =monitor::type_id::create("h_mon",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_full_name(), " We are in agent's Connect Phase", UVM_LOW);
		 h_dri.seq_item_port.connect(h_seqn.seq_item_export);
	endfunction
endclass:agent


