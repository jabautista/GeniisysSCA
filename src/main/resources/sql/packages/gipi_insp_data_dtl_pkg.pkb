CREATE OR REPLACE PACKAGE BODY CPI.gipi_insp_data_dtl_pkg AS

  FUNCTION get_insp_data_dtl(
   p_insp_no			   GIPI_INSP_DATA_DTL.insp_no%TYPE
  ) RETURN insp_data_dtl_tab PIPELINED

  IS
    v_dtl	 				insp_data_dtl_type;
  BEGIN
	   FOR i IN (SELECT insp_no, fi_pro_remarks, fi_station_remarks,
	   	 			    sec_sys_remarks, gen_surr_remarks, maint_dtl_remarks,
	   				    elec_inst_remarks, hk_remarks
  			       FROM gipi_insp_data_dtl
 				  WHERE insp_no = p_insp_no)
	   LOOP
	 	   v_dtl.insp_no		  	      := i.insp_no;
		   v_dtl.fi_pro_remarks 		  := i.fi_pro_remarks;
		   v_dtl.fi_station_remarks		  := i.fi_station_remarks;
		   v_dtl.sec_sys_remarks		  := i.sec_sys_remarks;
		   v_dtl.gen_surr_remarks		  := i.gen_surr_remarks;
		   v_dtl.maint_dtl_remarks		  := i.maint_dtl_remarks;
		   v_dtl.elec_inst_remarks		  := i.elec_inst_remarks;
		   v_dtl.hk_remarks				  := i.hk_remarks;
		   PIPE ROW(v_dtl);
	   END LOOP;
	   RETURN;
  END get_insp_data_dtl;

  PROCEDURE set_insp_data_dtl (
	p_insp_no		  		  GIPI_INSP_DATA_DTL.insp_no%TYPE,
	p_fi_pro_remarks 		  GIPI_INSP_DATA_DTL.fi_pro_remarks%TYPE,
	p_fi_station_remarks	  GIPI_INSP_DATA_DTL.fi_station_remarks%TYPE,
	p_sec_sys_remarks		  GIPI_INSP_DATA_DTL.sec_sys_remarks%TYPE,
	p_gen_surr_remarks		  GIPI_INSP_DATA_DTL.gen_surr_remarks%TYPE,
	p_maint_dtl_remarks		  GIPI_INSP_DATA_DTL.maint_dtl_remarks%TYPE,
	p_elec_inst_remarks		  GIPI_INSP_DATA_DTL.elec_inst_remarks%TYPE,
	p_hk_remarks			  GIPI_INSP_DATA_DTL.hk_remarks%TYPE
  )

  IS

  BEGIN
	   MERGE INTO GIPI_INSP_DATA_DTL
	   USING DUAL ON (insp_no = p_insp_no)
	   WHEN NOT MATCHED THEN
	 	    INSERT (insp_no, fi_pro_remarks, fi_station_remarks,
	   	 		    sec_sys_remarks, gen_surr_remarks, maint_dtl_remarks,
	   			    elec_inst_remarks, hk_remarks, user_id, last_update)
		    VALUES (p_insp_no, p_fi_pro_remarks, p_fi_station_remarks,
	   	 	  	    p_sec_sys_remarks, p_gen_surr_remarks, p_maint_dtl_remarks,
	   			    p_elec_inst_remarks, p_hk_remarks, USER, SYSDATE)
	   WHEN MATCHED THEN
	 	    UPDATE SET fi_pro_remarks    	= p_fi_pro_remarks,
		  		 	   fi_station_remarks  	= p_fi_station_remarks,
				   	   sec_sys_remarks		= p_sec_sys_remarks,
					   gen_surr_remarks		= p_gen_surr_remarks,
					   maint_dtl_remarks	= p_maint_dtl_remarks,
	   			  	   elec_inst_remarks	= p_elec_inst_remarks,
					   hk_remarks			= p_hk_remarks,
					   user_id 				= USER,
					   last_update 			= SYSDATE;
  END set_insp_data_dtl;

  PROCEDURE del_insp_data_dtl(
	p_insp_no				GIPI_INSP_DATA_DTL.insp_no%TYPE
  )

  IS

  BEGIN
	   DELETE
	     FROM gipi_insp_data_dtl
	    WHERE insp_no = p_insp_no;
  END del_insp_data_dtl;

END;
/


