DROP FUNCTION CPI.TOT_PREM_AMT;

CREATE OR REPLACE FUNCTION CPI.TOT_PREM_AMT
   (v_claim_id  gicl_item_peril.claim_id%TYPE,
    v_peril_cd  gicl_item_peril.peril_cd%TYPE,
    v_item_no   gicl_item_peril.item_no%TYPE
    )
RETURN NUMBER AS
   v_tot_prem_amt NUMBER;
BEGIN
   SELECT SUM(B380.prem_amt) tot_prem_amt
     INTO v_tot_prem_amt
     FROM gipi_polbasic B250,
               GICL_CLAIMS   C250,
               GIPI_ITMPERIL B380
         WHERE 1=1
           AND C250.claim_id    = v_claim_id     
           AND B250.line_cd     = C250.line_cd    --clm_info.line_cd
           AND B250.subline_cd  = C250.subline_cd --clm_info.subline_cd
           AND B250.iss_cd      = C250.POL_ISS_CD --clm_info.pol_iss_cd
           AND B250.issue_yy    = C250.ISSUE_YY   --clm_info.issue_yy
           AND B250.pol_seq_no  = C250.POL_SEQ_NO --clm_info.pol_seq_no
           AND B250.renew_no    = C250.renew_no   --clm_info.renew_no
           AND B250.pol_flag   IN ('1','2','3','X' )
           AND TRUNC(DECODE(b250.eff_date, 
                            b250.incept_date, C250.pol_eff_date, --clm_info.pol_eff_date,
                            b250.eff_date)) <= C250.loss_date    --clm_info.loss_date
           AND TRUNC(DECODE(b250.expiry_date,
                            NVL(b250.endt_expiry_date,b250.expiry_date), C250.expiry_date, --clm_info.expiry_date, 
                            b250.endt_expiry_date)) >= TRUNC(C250.loss_date)               --clm_info.loss_date
           AND b250.dist_flag   = '3'
           AND b380.policy_id   = b250.policy_id
           AND b380.peril_cd      = v_peril_cd
           AND b380.item_no       = v_item_no;
RETURN (v_tot_prem_amt);
END;
/


