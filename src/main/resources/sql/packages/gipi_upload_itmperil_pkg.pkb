CREATE OR REPLACE PACKAGE BODY CPI.GIPI_UPLOAD_ITMPERIL_PKG
AS

    /*
	**  Created by		: Jerome Orio  
	**  Date Created 	: 06.16.2010  
	**  Reference By 	: (GIPIS195- Grouped Accident Uploading Module)    
	**  Description 	: insert records in GIPI_UPLOAD_ITMPERIL 
	*/	
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
			)
  IS
      v_exists          VARCHAR2(1) := 'N';
  BEGIN
      --marco - 04.20.2014 - check if uploaded record is already existing
      FOR i IN(SELECT 1
                 FROM GIPI_UPLOAD_ITMPERIL
                WHERE upload_no = p_upload_no
                  AND control_cd = p_control_cd
                  AND peril_cd = p_peril_cd)
      LOOP
         v_exists := 'Y';
      END LOOP;
  
      IF v_exists = 'N' THEN
         INSERT INTO GIPI_UPLOAD_ITMPERIL 
                            (upload_no, 			filename, 			control_type_cd,
                        control_cd, 			peril_cd, 			prem_rt,
                       tsi_amt, 				prem_amt, 			aggregate_sw,
                       base_amt, 			ri_comm_rate, 		ri_comm_amt,
                       user_id, 				last_update, 		no_of_days)
                     VALUES(p_upload_no, 			p_filename, 		p_control_type_cd,
                        p_control_cd, 		p_peril_cd, 		p_prem_rt,
                       p_tsi_amt, 			p_prem_amt, 		p_aggregate_sw,
                       p_base_amt, 			p_ri_comm_rate, 	p_ri_comm_amt,
                       p_user_id, 			SYSDATE, 			p_no_of_days);
      END IF;
  END;			
			
END;
/


