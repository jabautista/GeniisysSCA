DROP FUNCTION CPI.CHECK_BACK_ENDT_WITMPERL_GRP;

CREATE OR REPLACE FUNCTION CPI.CHECK_BACK_ENDT_WITMPERL_GRP (
    p_line_cd IN gipi_wpolbas.line_cd%TYPE,
    p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,
    p_iss_cd IN gipi_wpolbas.iss_cd%TYPE,
    p_issue_yy IN gipi_wpolbas.issue_yy%TYPE,
    p_pol_seq_no IN gipi_wpolbas.pol_seq_no%TYPE,
    p_renew_no IN gipi_wpolbas.renew_no%TYPE,
    p_eff_date IN gipi_wpolbas.eff_date%TYPE,
    p_item_no IN gipi_witem.item_no%TYPE,
    p_grouped_item_no IN gipi_wgrouped_items.grouped_item_no%TYPE)
RETURN VARCHAR2
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 05.10.2011
    **  Reference By     : (GIPIS065 - Endt Item Information - Accident)
    **  Description     : This procedure is used for checking if policy is a backward endt
    */
    v_message VARCHAR2(4000) := 'SUCCESS';
BEGIN
    FOR A2 IN(
        SELECT policy_id, a.endt_iss_cd||'-'||TO_CHAR(a.endt_yy,'09')||TO_CHAR(a.endt_seq_no,'099999') endt_no
          FROM gipi_polbasic a
         WHERE a.line_cd =  p_line_cd
           AND a.iss_cd =  p_iss_cd
           AND a.subline_cd =  p_subline_cd
           AND a.issue_yy =  p_issue_yy
           AND a.pol_seq_no =  p_pol_seq_no
           AND a.renew_no =  p_renew_no
           AND a.pol_flag IN ( '1','2','3','X')
           AND a.eff_date >  p_eff_date
           AND NVL(a.endt_expiry_date,a.expiry_date) >=  p_eff_date
      ORDER BY eff_date)
    LOOP     
        FOR A3 IN (
            SELECT line_cd, peril_cd
              FROM gipi_itmperil_grouped b
             WHERE policy_id         = a2.policy_id
               AND b.item_no         = p_item_no
               AND b.grouped_item_no = p_grouped_item_no
               AND (b.prem_amt <> 0 OR b.tsi_amt  <> 0))
        LOOP
            FOR B IN (
                SELECT peril_name
                  FROM giis_peril
                 WHERE line_cd = a3.line_cd
                   AND peril_cd = a3.peril_cd)
            LOOP             
                v_message := 'Deletion of this peril is not allowed because this is a '||
                     'backward endorsement and there is an existing '||
                     'endorsement for peril ' || LTRIM(RTRIM(b.peril_name))||
                     ' in Endt No. ' || a2.endt_no;
                EXIT;
            END LOOP;      
       END LOOP;
     END LOOP;
     
     RETURN v_message;
END CHECK_BACK_ENDT_WITMPERL_GRP;
/


