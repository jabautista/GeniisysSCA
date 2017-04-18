CREATE OR REPLACE PACKAGE CPI.giis_clm_stat_pkg
AS
   TYPE giis_clm_stat_type IS RECORD (
      clm_stat_cd     giis_clm_stat.clm_stat_cd%TYPE,
      clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE,
      clm_stat_type   giis_clm_stat.clm_stat_type%TYPE,
      remarks         giis_clm_stat.remarks%TYPE
   );

   TYPE giis_clm_stat_tab IS TABLE OF giis_clm_stat_type;

   FUNCTION get_clm_stat_dtl 
      RETURN giis_clm_stat_tab PIPELINED;
      
   FUNCTION get_clm_desc (p_clm_stat_cd giis_clm_stat.clm_stat_cd%type)   
   RETURN VARCHAR2;
END;
/


