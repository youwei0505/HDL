module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);


always@(posedge clk)
begin
	if( reset )
	begin
		q <= 16'd0;
		ena[3:1] <= 0;
	end
	else
	begin
		q[3:0] <= q[3:0] + 1'd1;
		if( ena[1] == 1 )
		begin
			q[3:0] <= 4'd0;
			q[7:4] <= q[7:4] + 4'd1;
		end
		
		if( ena[2] == 1 )
		begin
			q[7:4] <= 4'd0;
			q[11:8] <= q[11:8] + 4'd1;
		end
		
		if( ena[3] == 1 )
		begin
			q[11:8] <= 4'd0;
			if( q[15:12] < 4'b1001 )
				q[15:12] <= q[15:12] + 4'd1;
			else
				q[15:12] <= 4'd0;
		end
		
		if( q[3:0] == 4'b1000 )
			ena[1] <= 1;
		else
			ena[1] <= 0;
		if( q[7:4] == 4'b1001 && q[3:0] == 4'b1000 )
			ena[2] <= 1;
		else
			ena[2] <= 0;
		if( q[11:8] == 4'b1001 && q[7:4] == 4'b1001 && q[3:0] == 4'b1000 )
			ena[3] <= 1;
		else
			ena[3] <= 0;
	end
end


endmodule