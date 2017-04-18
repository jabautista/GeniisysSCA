DROP PROCEDURE CPI.GET_INTM_INFO;

CREATE OR REPLACE PROCEDURE CPI.GET_INTM_INFO
  (p_intm_no           giis_intermediary.intm_no%type,
   p_intm_type         in out giis_intermediary.intm_type%type,
   p_intm_name         in out giis_intermediary.intm_name%type,
   p_wtax_rate         in out giis_intermediary.wtax_rate%type,
   p_special_rate      in out giis_intermediary.special_rate%type,
   p_parent_intm_no    in out giis_intermediary.intm_no%type,
   p_parent_intm_type  in out giis_intermediary.intm_type%type,
   p_parent_intm_name  in out giis_intermediary.intm_name%type) is

   v_tag               giac_parameters.param_value_v%type;
   v_intm_no           gipi_comm_invoice.intrmdry_intm_no%type;
   v_intm_name         giis_intermediary.intm_name%type;
   v_intm_type         giis_intermediary.intm_type%type;
   v_p_intm_no         giis_intermediary.parent_intm_no%type;
   v_p_intm_name       giis_intermediary.intm_name%type;
   v_p_intm_type       giis_intermediary.intm_type%type;
   v_lic_tag           giis_intermediary.lic_tag%type;
   v_wtax_rate         giis_intermediary.wtax_rate%type;
   v_special_rate      giis_intermediary.special_rate%type;
BEGIN
  FOR j IN (select param_value_v from giac_parameters where param_name like 'PARENT_LIC_TAG' ) loop
    v_tag := j.param_value_v;
  END LOOP;
  v_tag := nvl(v_tag,'Y');
  v_intm_no := p_intm_no;
  <<repeat>>
  begin
    select lic_tag, intm_name, intm_type, parent_intm_no, wtax_rate, special_rate
    into v_lic_tag, v_intm_name, v_intm_type, v_p_intm_no, v_wtax_rate, v_special_rate
    from giis_intermediary
	where intm_no = v_intm_no;

	if v_lic_tag = 'Y' then
	   p_intm_name := v_intm_name;
	   p_intm_type := v_intm_type;
       if v_p_intm_no is not null then
         if v_tag != 'Y' then
           goto repeat;
         else
           begin
	  	     select intm_no, intm_name, intm_type
		     into v_p_intm_no, v_p_intm_name, v_p_intm_type
		     from giis_intermediary
		     where intm_no = v_p_intm_no;
   		       p_parent_intm_no := v_p_intm_no;
               p_parent_intm_type	:= v_p_intm_type;
	           p_parent_intm_name := v_p_intm_name;
		   exception
		     when no_data_found then
		       p_parent_intm_no := null;
               p_parent_intm_type	:= null;
			   p_parent_intm_name := null;
           end;
         end if;
       else
         p_parent_intm_no   := v_intm_no;
		 p_parent_intm_type := v_intm_type;
		 p_parent_intm_name := v_intm_name;
       end if;
    elsif v_p_intm_no is null then
	   p_intm_name := v_intm_name;
	   p_intm_type := v_intm_type;
       p_parent_intm_no := v_intm_no;
	   p_parent_intm_type := v_intm_type;
	   p_parent_intm_name := v_intm_name;
    else
	   p_intm_name := null;
	   p_intm_type := null;
	   p_parent_intm_no := null;
	   p_parent_intm_type := null;
	   p_parent_intm_name := null;
	   goto repeat;
    end if;
  exception
    when no_data_found then
	  raise_application_error(-20090,to_char(p_intm_no)||' intm no has no record in giis_intermediary');
  end;
END;
/


