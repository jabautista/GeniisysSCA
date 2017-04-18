CREATE OR REPLACE PACKAGE CPI.gipi_insp_data_dtl_pkg AS
  
  TYPE insp_data_dtl_type IS RECORD(
	insp_no				   GIPI_INSP_DATA_DTL.insp_no%TYPE,
	fi_pro_remarks		   GIPI_INSP_DATA_DTL.fi_pro_remarks%TYPE, 
	fi_station_remarks	   GIPI_INSP_DATA_DTL.fi_station_remarks%TYPE,
	sec_sys_remarks		   GIPI_INSP_DATA_DTL.sec_sys_remarks%TYPE, 
	gen_surr_remarks	   GIPI_INSP_DATA_DTL.gen_surr_remarks%TYPE, 
	maint_dtl_remarks	   GIPI_INSP_DATA_DTL.maint_dtl_remarks%TYPE,
	elec_inst_remarks	   GIPI_INSP_DATA_DTL.elec_inst_remarks%TYPE, 
	hk_remarks			   GIPI_INSP_DATA_DTL.hk_remarks%TYPE
  );

  TYPE insp_data_dtl_tab IS TABLE OF insp_data_dtl_type;
  
  FUNCTION get_insp_data_dtl(
   p_insp_no			   GIPI_INSP_DATA_DTL.insp_no%TYPE
  ) RETURN insp_data_dtl_tab PIPELINED;
  
  PROCEDURE set_insp_data_dtl (
	p_insp_no		  		  GIPI_INSP_DATA_DTL.insp_no%TYPE,
	p_fi_pro_remarks 		  GIPI_INSP_DATA_DTL.fi_pro_remarks%TYPE,
	p_fi_station_remarks	  GIPI_INSP_DATA_DTL.fi_station_remarks%TYPE,
	p_sec_sys_remarks		  GIPI_INSP_DATA_DTL.sec_sys_remarks%TYPE,
	p_gen_surr_remarks		  GIPI_INSP_DATA_DTL.gen_surr_remarks%TYPE,
	p_maint_dtl_remarks		  GIPI_INSP_DATA_DTL.maint_dtl_remarks%TYPE,
	p_elec_inst_remarks		  GIPI_INSP_DATA_DTL.elec_inst_remarks%TYPE,
	p_hk_remarks			  GIPI_INSP_DATA_DTL.hk_remarks%TYPE
  );
  
  PROCEDURE del_insp_data_dtl(
	p_insp_no				GIPI_INSP_DATA_DTL.insp_no%TYPE
  );
  
END;
/


