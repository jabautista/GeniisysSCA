CREATE OR REPLACE PACKAGE BODY CPI.GIXX_ENGG_BASIC_PKG AS

  FUNCTION get_engg_basic_details(p_extract_id	   GIXX_ENGG_BASIC.extract_id%TYPE)
    RETURN gixx_engg_basic_tab PIPELINED IS
	v_engg     gixx_engg_basic_type;
  BEGIN
    FOR i IN (SELECT construct_end_date,
                     construct_start_date,
       				 contract_proj_buss_title,
					 TO_CHAR(LENGTH(contract_proj_buss_title)) f_length,
       				 mbi_policy_no,
       				 extract_id,
       				 site_location,
       				 time_excess,
       				 weeks_test,
       				 to_char(testing_start_date, 'fmMonth dd, yyyy') TESTING_START_DATE,
       				 to_char(testing_end_date, 'fmMonth dd, yyyy') TESTING_END_DATE,
       				 to_char(maintain_start_date, 'fmMonth dd, yyyy') MAINTAIN_START_DATE,
       				 to_char(maintain_end_date, 'fmMonth dd, yyyy') MAINTAIN_END_DATE
  				FROM gixx_engg_basic
			   WHERE extract_id = p_extract_id)
	LOOP
	  v_engg.construct_end_date 	  := i.construct_end_date;
	  v_engg.construct_start_date 	  := i.construct_start_date;
	  v_engg.contract_proj_buss_title := i.contract_proj_buss_title;
	  v_engg.f_length				  := i.f_length;
	  v_engg.mbi_policy_no 			  := i.mbi_policy_no;
	  v_engg.extract_id 			  := i.extract_id;
	  v_engg.site_location 			  := i.site_location;
	  v_engg.time_excess 			  := i.time_excess;
	  v_engg.weeks_test 			  := i.weeks_test;
	  v_engg.testing_start_date 	  := i.testing_start_date;
	  v_engg.testing_end_date 		  := i.testing_end_date;
	  v_engg.maintain_start_date 	  := i.maintain_start_date;
	  v_engg.maintain_end_date 		  := i.maintain_end_date;
	  PIPE ROW(v_engg);
	END LOOP;
	RETURN;
  END get_engg_basic_details;

END GIXX_ENGG_BASIC_PKG;
/


