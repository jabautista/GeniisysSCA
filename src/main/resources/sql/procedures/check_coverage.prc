DROP PROCEDURE CPI.CHECK_COVERAGE;

CREATE OR REPLACE PROCEDURE CPI.CHECK_COVERAGE ( 
    cc_pack_line_cd     GIPI_WITEM.pack_line_cd%TYPE,
    cc_pack_subline_cd  GIPI_WITEM.pack_subline_cd%TYPE,
    p_msg           OUT VARCHAR2
)
IS
  v_dummy   VARCHAR2(1);
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-17-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : CHECK_COVERAGE program unit 
  */
  SELECT 'x' 
    INTO v_dummy
    FROM GIPI_WITEM
   WHERE pack_line_cd = cc_pack_line_cd
     AND pack_subline_cd = cc_pack_subline_cd
     AND ROWNUM = 1;

EXCEPTION
  WHEN no_data_found THEN
        p_msg := 'No data in giis_line_subline_coverages';
END;
/


