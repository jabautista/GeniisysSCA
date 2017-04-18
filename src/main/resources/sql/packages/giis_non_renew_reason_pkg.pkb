CREATE OR REPLACE PACKAGE BODY CPI.giis_non_renew_reason_pkg
AS

    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 09.22.2011
    **  Reference By     : (GIEXS004- TAG EXPIRED POLICIES FOR RENEWAL)
    **  Description      : Retrieves the list of non-renewal codes and descriptions
    */
    FUNCTION get_non_renewal_cd (
        p_dsp_line_cd   giis_non_renew_reason.line_cd%TYPE
    )
    RETURN giis_non_renew_reason_tab PIPELINED
    IS
        v_non_renewal_cd   giis_non_renew_reason_type;
    BEGIN
      FOR a IN (SELECT non_ren_reason_cd, non_ren_reason_desc
                  FROM giis_non_renew_reason
                 WHERE line_cd = p_dsp_line_cd
                    OR line_cd IS NULL
                   AND active_tag = 'A' --added by carlo SR 5915 01-25-2017
                 ORDER BY 1)
        LOOP
         v_non_renewal_cd.non_ren_reason_cd    := a.non_ren_reason_cd;
         v_non_renewal_cd.non_ren_reason_desc  := a.non_ren_reason_desc;
         PIPE ROW (v_non_renewal_cd);
        END LOOP;

    END get_non_renewal_cd;

    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 10.19.2011
    **  Reference By     : (GIEXS004- TAG EXPIRED POLICIES FOR RENEWAL)
    **  Description      : Checks if the non renewal reason code exists in maintenance table
    */
    PROCEDURE validate_reason_cd(
        p_non_ren_reason_cd  IN giis_non_renew_reason.non_ren_reason_cd%TYPE,
        p_non_ren_reason    OUT giis_non_renew_reason.non_ren_reason_desc%TYPE,
        p_msg               OUT VARCHAR2
    )
    IS
    BEGIN
        SELECT non_ren_reason_desc
          INTO p_non_ren_reason
          FROM giis_non_renew_reason
         WHERE non_ren_reason_cd = p_non_ren_reason_cd;
    EXCEPTION
        WHEN no_data_found THEN
        p_non_ren_reason := '';
        p_msg := 'Non-renewal reason code does not exists in maintenance table.';
    END validate_reason_cd;

END giis_non_renew_reason_pkg;
/


