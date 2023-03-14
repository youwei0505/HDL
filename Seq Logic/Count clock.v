module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
	
wire ss_ena;
wire mm_ena;
wire hh_ena;
wire pm_ena;

assign ss_ena = (ss[7:4] == 4'd5 && ss[3:0] == 4'd9) ? 1 : 0;
assign mm_ena = (mm[7:4] == 4'd5 && mm[3:0] == 4'd9) ? 1 : 0;
assign hh_ena = (hh[7:4] == 4'd1 && hh[3:0] == 4'd2) ? 1 : 0;
assign pm_ena = ((hh[7:4] == 4'd1 && hh[3:0] == 4'd1) && ss_ena && mm_ena ) ? 1 : 0;

always@(posedge clk)
begin
	if( reset )
	begin
		ss <= 0;
		mm <= 0;
		pm <= 0;
		hh[7:4] <= 4'd1;
		hh[3:0] <= 4'd2;	
	end
	else
	begin
		//ss
		ss[3:0] <= ss[3:0] + 1;
		if( ss[3:0] == 4'd9 )
		begin
			ss[3:0] <= 4'd0;
			ss[7:4] <= ss[7:4] + 4'd1;
		end
		//mm
		if(ss_ena)
		begin
			mm[3:0] <= mm[3:0] + 4'd1;
			ss[3:0] <= 4'd0;
			ss[7:4] <= 4'd0;
			if( mm[3:0] == 4'd9 )
			begin
				mm[3:0] <= 4'd0;
				mm[7:4] <= mm[7:4] + 4'd1;
			end
		end
		
		//hh
		if(ss_ena && mm_ena)
		begin
			if( hh[3:0] == 4'd1 && hh[7:4] == 4'd2)
			begin
				hh[3:0] <= 4'd1;
				hh[7:4] <= 4'd0;
			end
			
			mm[3:0] <= 4'd0;
			mm[7:4] <= 4'd0;
			
			
		end
		
		//day by day
		if(pm_ena)
		begin
			pm <= 1;
		end
	end
end

endmodule