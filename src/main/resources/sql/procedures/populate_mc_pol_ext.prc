DROP PROCEDURE CPI.POPULATE_MC_POL_EXT;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_MC_POL_EXT(
    p_user_id           MC_POL_EXT.user_id%TYPE,
    p_branch_param      NUMBER,
    p_iss_cd            EDST_EXT.iss_cd%TYPE,
    p_subline_cd        EDST_EXT.subline_cd%TYPE,
    p_from_date         VARCHAR2,
    p_to_date           VARCHAR2
)
AS
    /*
    **  Created by    : Marco Paolo Rebong
    **  Date Created  : 04.24.2012
    **  Reference By  : GIPIS901A - UW PRODUCTION REPORTS
    **  Description   : Populates MC_POL_EXT table
    */ 
BEGIN
    DELETE FROM MC_POL_EXT
     WHERE user_id = p_user_id;
     
    FOR x IN (SELECT policy_id, assd_no, spld_date, acct_ent_date,
                     spld_acct_ent_date, pol_flag, total_prem, total_tsi as tsi_amt
                FROM EDST_EXT
               WHERE line_cd = 'MC'
                 AND DECODE(p_branch_param,1,cred_branch,iss_cd) = DECODE(p_branch_param,1,cred_branch,NVL(p_iss_cd, iss_cd))
                 AND subline_cd = NVL(p_subline_cd, subline_cd)
                 AND DECODE (iss_cd, 'BB', 0, 'RI', 0, 1) = 1
                 AND acct_ent_date BETWEEN TO_DATE(p_from_date, 'MM-DD-YYYY') AND TO_DATE(p_to_date, 'MM-DD-YYYY')
                 AND user_id = p_user_id
                 AND from_date = TO_DATE(p_from_date, 'MM-DD-YYYY')
                 AND to_date1 = TO_DATE(p_to_date, 'MM-DD-YYYY'))
    LOOP
        FOR y IN (SELECT SUM (b.prem_amt) prem_amt, SUM (b.tsi_amt) ctpl_tsi_amt
                    FROM GIPI_ITMPERIL b, GIIS_PERIL c
                   WHERE 1 = 1
                     AND c.peril_cd = b.peril_cd
                     AND c.line_cd = b.line_cd
                     AND peril_sname = 'CTPL'
                     AND b.policy_id = x.policy_id)
        LOOP
            INSERT INTO MC_POL_EXT
            VALUES (p_user_id, x.policy_id, x.assd_no, y.prem_amt, x.total_prem,
                      x.spld_date, x.acct_ent_date, x.spld_acct_ent_date,
                      x.pol_flag, SYSDATE, x.tsi_amt, y.ctpl_tsi_amt);
        END LOOP;
    END LOOP;   
END POPULATE_MC_POL_EXT;
/


