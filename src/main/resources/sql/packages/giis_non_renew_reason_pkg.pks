CREATE OR REPLACE PACKAGE CPI.giis_non_renew_reason_pkg
AS
   TYPE giis_non_renew_reason_type IS RECORD (
      non_ren_reason_cd     giis_non_renew_reason.non_ren_reason_cd%TYPE,
      non_ren_reason_desc   giis_non_renew_reason.non_ren_reason_desc%TYPE,
      remarks               giis_non_renew_reason.remarks%TYPE,       
      user_id               giis_non_renew_reason.user_id%TYPE,
      last_update           giis_non_renew_reason.last_update%TYPE,
      line_cd               giis_non_renew_reason.line_cd%TYPE
   );

   TYPE giis_non_renew_reason_tab IS TABLE OF giis_non_renew_reason_type;
   
   FUNCTION get_non_renewal_cd (
        p_dsp_line_cd   giis_non_renew_reason.line_cd%TYPE
    )
    RETURN giis_non_renew_reason_tab PIPELINED;
    
    PROCEDURE validate_reason_cd(
        p_non_ren_reason_cd  IN giis_non_renew_reason.non_ren_reason_cd%TYPE,
        p_non_ren_reason    OUT giis_non_renew_reason.non_ren_reason_desc%TYPE,
        p_msg               OUT VARCHAR2
    );
    
END giis_non_renew_reason_pkg;
/


