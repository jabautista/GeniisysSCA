CREATE OR REPLACE PACKAGE CPI.Gipi_Wengg_Basic_Pkg
AS

    TYPE gipi_wengg_basic_list_type IS RECORD 
    (
         par_id                     GIPI_WENGG_BASIC.par_id%TYPE,
         engg_basic_infonum         GIPI_WENGG_BASIC.engg_basic_infonum%TYPE,
         contract_proj_buss_title   GIPI_WENGG_BASIC.contract_proj_buss_title%TYPE,
         site_location              GIPI_WENGG_BASIC.site_location%TYPE,
         construct_start_date       GIPI_WENGG_BASIC.construct_start_date%TYPE,
         construct_end_date         GIPI_WENGG_BASIC.construct_end_date%TYPE,
         maintain_start_date        GIPI_WENGG_BASIC.maintain_start_date%TYPE,
         maintain_end_date          GIPI_WENGG_BASIC.maintain_end_date%TYPE,
         testing_start_date         GIPI_WENGG_BASIC.testing_start_date%TYPE,
         testing_end_date           GIPI_WENGG_BASIC.testing_end_date%TYPE,
         weeks_test                 GIPI_WENGG_BASIC.weeks_test%TYPE,
         time_excess			    GIPI_WENGG_BASIC.time_excess%TYPE,
		 mbi_policy_no			    GIPI_WENGG_BASIC.mbi_policy_no%TYPE);
    
    TYPE gipi_wengg_basic_list_tab IS TABLE OF gipi_wengg_basic_list_type;
    
    
	Procedure del_gipi_wengg_basic (p_par_id IN GIPI_WENGG_BASIC.par_id%TYPE);
	
	Procedure set_gipi_wengg_basic(
		 p_par_id 					IN GIPI_WENGG_BASIC.par_id%TYPE,
		 p_engg_basic_infonum		IN GIPI_WENGG_BASIC.engg_basic_infonum%TYPE,
		 p_contract_proj_buss_title	IN GIPI_WENGG_BASIC.contract_proj_buss_title%TYPE,
		 p_site_location 			IN GIPI_WENGG_BASIC.site_location%TYPE,
		 p_construct_start_date		IN GIPI_WENGG_BASIC.construct_start_date%TYPE,
		 p_construct_end_date		IN GIPI_WENGG_BASIC.construct_end_date%TYPE,
		 p_maintain_start_date		IN GIPI_WENGG_BASIC.maintain_start_date%TYPE,
		 p_maintain_end_date		IN GIPI_WENGG_BASIC.maintain_end_date%TYPE,
		 p_testing_start_date		IN GIPI_WENGG_BASIC.testing_start_date%TYPE,
		 p_testing_end_date			IN GIPI_WENGG_BASIC.testing_end_date%TYPE,
		 p_weeks_test				IN GIPI_WENGG_BASIC.weeks_test%TYPE,
		 p_time_excess				IN GIPI_WENGG_BASIC.time_excess%TYPE,
		 p_mbi_policy_no			IN GIPI_WENGG_BASIC.mbi_policy_no%TYPE);
         
     FUNCTION get_gipi_wengg_basic (p_par_id IN GIPI_WENGG_BASIC.par_id%TYPE)
        RETURN gipi_wengg_basic_list_tab PIPELINED;

END Gipi_Wengg_Basic_Pkg;
/


