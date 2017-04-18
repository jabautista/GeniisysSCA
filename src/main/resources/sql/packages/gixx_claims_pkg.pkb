CREATE OR REPLACE PACKAGE BODY CPI.GIXX_CLAIMS_PKG 
AS
    /*
    ** Created by:    Marie Kris Felipe
    ** Date Created:  March 4, 2013
    ** Reference by:  GIPIS101 - Policy Information (Summary)
    ** Description:   Retrieves claims for GIPIS101
    */
    FUNCTION get_gixx_claims (
        p_extract_id        gixx_claims.extract_id%TYPE
    ) 
    RETURN gixx_claims_tab PIPELINED
    IS
        v_claim     gixx_claims_type;
    BEGIN
        FOR rec IN (SELECT extract_id, claim_id, 
                           line_cd, subline_cd, clm_yy, clm_seq_no, iss_cd,
                           TRUNC(clm_setl_date) clm_setl_date, 
                           TRUNC(clm_file_date) clm_file_date, 
                           TRUNC(loss_date) loss_date,
                           loss_res_amt, exp_res_amt,
                           loss_pd_amt, exp_pd_amt
                     FROM gixx_claims
                    WHERE extract_id = p_extract_id
                    ORDER BY clm_file_date)
        LOOP
            FOR a IN (SELECT line_cd || '-' || subline_cd || '-' || iss_cd || '-' ||
                             TO_CHAR(clm_yy, '09') || '-' || TO_CHAR(clm_seq_no, '09999') claim_no
                        FROM gixx_claims
                       WHERE claim_id = rec.claim_id
                         AND extract_id = p_extract_id)
            LOOP
                v_claim.claim_no := a.claim_no;
            END LOOP;
            
            FOR b IN (SELECT (NVL(loss_res_amt,0) + NVL(exp_res_amt,0)) claim_amt
                        FROM gixx_claims
                       WHERE claim_id = rec.claim_id
                         AND extract_id = p_extract_id)
            LOOP
                v_claim.claim_amt := b.claim_amt;
            END LOOP;
            
            FOR c IN (SELECT (NVL(loss_pd_amt,0) + NVL(exp_pd_amt,0)) paid_amt
                        FROM gixx_claims
                       WHERE claim_id = rec.claim_id
                         AND extract_id = p_extract_id)
            LOOP
                v_claim.paid_amt := c.paid_amt;
            END LOOP;
            
            v_claim.extract_id := rec.extract_id;
            v_claim.claim_id := rec.claim_id;
            v_claim.line_cd := rec.line_cd;
            v_claim.subline_cd :=  rec.subline_cd;
            v_claim.clm_yy := rec.clm_yy;
            v_claim.clm_seq_no := rec.clm_seq_no;
            v_claim.iss_cd := rec.iss_cd;
            v_claim.clm_setl_date := rec.clm_setl_date;
            v_claim.clm_file_date := rec.clm_file_date;
            v_claim.loss_date := rec.loss_date;
            v_claim.loss_res_amt := rec.loss_res_amt;
            v_claim.loss_pd_amt := rec.loss_pd_amt;
            v_claim.exp_res_amt := rec.exp_res_amt;
            v_claim.exp_pd_amt := rec.exp_pd_amt;
            
            PIPE ROW(v_claim);
        END LOOP;
    END get_gixx_claims;
    
END gixx_claims_pkg;
/


