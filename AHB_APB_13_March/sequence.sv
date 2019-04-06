class seq extends uvm_sequence#(sequence_item);
	 `uvm_object_utils(seq)
	
	sequence_item tx;
	
	function new(string name="seq");
		super.new(name);
	endfunction

	virtual task body();
		sequence_item tx;
			repeat(130) begin
					tx = sequence_item::type_id::create("tx");
					start_item(tx);	
						assert(tx.randomize());
					//`uvm_info("seq_item",tx.sprint(),UVM_LOW);
					finish_item(tx);
		    		   end
	endtask : body
endclass:seq


