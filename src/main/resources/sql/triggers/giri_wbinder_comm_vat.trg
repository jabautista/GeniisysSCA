DROP TRIGGER CPI.GIRI_WBINDER_COMM_VAT;

CREATE OR REPLACE TRIGGER CPI.GIRI_WBINDER_COMM_VAT
before insert ON CPI.GIRI_WBINDER FOR EACH ROW
DECLARE
v_rate number(5,3);
v_parameters varchar2(1);
v_switch varchar2(1);
v_comm_amt number (16,2);
  BEGIN
    v_comm_amt := :new.ri_comm_amt;
	select param_value_v
	  INTO v_parameters
	  from giac_parameters
	 where param_name = 'COMM_INCLUSIVE_VAT';
	 exception
	 when no_data_found then
	   v_parameters := 'Y';
	  IF v_parameters = 'Y' then
	            select input_vat_rate, local_foreign_sw
                 INTO v_rate, v_switch
			     from giis_reinsurer
		        where ri_cd = :new.ri_cd;
         IF v_switch != 'L' then
			:new.ri_comm_amt := round(v_comm_amt / (1 + v_rate/100),2);
			:new.ri_comm_vat := v_comm_amt - :new.ri_comm_amt;
		 END IF;
	   END IF;
END;
/


