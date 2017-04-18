CREATE OR REPLACE PACKAGE CPI.GIPI_UPLOAD_ITMPERIL_PKG
AS

  PROCEDURE set_gipi_upload_itmperil(
  			p_upload_no			 		   GIPI_UPLOAD_ITMPERIL.upload_no%TYPE,
	   		p_filename					   GIPI_UPLOAD_ITMPERIL.filename%TYPE,
			p_control_type_cd			   GIPI_UPLOAD_ITMPERIL.control_type_cd%TYPE,
			p_control_cd				   GIPI_UPLOAD_ITMPERIL.control_cd%TYPE,
			p_peril_cd					   GIPI_UPLOAD_ITMPERIL.peril_cd%TYPE,
			p_prem_rt					   GIPI_UPLOAD_ITMPERIL.prem_rt%TYPE,
			p_tsi_amt					   GIPI_UPLOAD_ITMPERIL.tsi_amt%TYPE,
			p_prem_amt					   GIPI_UPLOAD_ITMPERIL.prem_amt%TYPE,
			p_aggregate_sw				   GIPI_UPLOAD_ITMPERIL.aggregate_sw%TYPE,
			p_base_amt					   GIPI_UPLOAD_ITMPERIL.base_amt%TYPE,
			p_ri_comm_rate				   GIPI_UPLOAD_ITMPERIL.ri_comm_rate%TYPE,
			p_ri_comm_amt				   GIPI_UPLOAD_ITMPERIL.ri_comm_amt%TYPE,
			p_user_id					   GIPI_UPLOAD_ITMPERIL.user_id%TYPE,
			p_last_update				   GIPI_UPLOAD_ITMPERIL.last_update%TYPE,
			p_no_of_days				   GIPI_UPLOAD_ITMPERIL.no_of_days%TYPE
			);
			
END;
/


