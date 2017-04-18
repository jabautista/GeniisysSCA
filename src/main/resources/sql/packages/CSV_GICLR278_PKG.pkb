CREATE OR REPLACE PACKAGE BODY CPI.CSV_GICLR278_PKG
AS

 FUNCTION format_amt(amt NUMBER)
 RETURN VARCHAR2
    IS
    BEGIN
        RETURN TO_CHAR(amt, '9,999,999,999.99');
    END;

 FUNCTION populate_giclr278(
        p_dt_basis      VARCHAR2, --   
        p_from_date     DATE, --
        p_to_date       DATE,--
        p_line_cd       GICL_CLAIMS.line_cd%TYPE,--    
        p_subline_cd    GICL_CLAIMS.subline_cd%TYPE,--       
        p_pol_iss_cd    GICL_CLAIMS.pol_iss_cd%TYPE,--     
        p_issue_yy      GICL_CLAIMS.issue_yy%TYPE, --
        p_pol_seq_no    GICL_CLAIMS.pol_seq_no%TYPE, --
        p_renew_no      GICL_CLAIMS.renew_no%TYPE, --
        p_user_id       VARCHAR2, --
        p_as_of         DATE   --
   )
    RETURN giclr278_tab PIPELINED
   AS
    v_list giclr278_type;
   BEGIN
        FOR i IN (
               SELECT  a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||
                       ltrim(to_char(a.issue_yy,'09'))||'-'||ltrim(to_char(a.pol_seq_no,'0999999'))||'-'||
                       ltrim(to_char(a.renew_no,'09')) policy_no, 
                       d.assd_name assured_name,
                       get_claim_number(a.claim_id) claim_no, 
                       get_gpa_item_title(a.claim_id,a.line_cd,c.item_no,c.grouped_item_no) enrollee,
                       a.dsp_loss_date,
                       a.clm_file_date,
                       nvl(a.loss_res_amt,0) loss_res_amt, nvl(a.exp_res_amt,0) exp_res_amt, 
                       nvl(a.loss_pd_amt,0) loss_pd_amt, nvl(a.exp_pd_amt,0) exp_pd_amt
              FROM gicl_claims a, giis_clm_stat b,gicl_clm_item c, giis_assured d 
             WHERE a.clm_stat_cd = b.clm_stat_cd
               AND check_user_per_iss_cd_acctg2(LINE_CD,ISS_CD,'GICLS278',p_user_id)=1  --marco - added module id
               --AND CHECK_USER_PER_LINE(LINE_CD,ISS_CD,'GICLS278')=1
               AND NVL(c.grouped_item_no,0) <> 0
               AND c.claim_id          = a.claim_id
               AND a.assd_no           = d.assd_no
               AND UPPER(a.line_cd)    = UPPER(p_line_cd)
               AND UPPER(a.subline_cd) = UPPER(p_subline_cd)
               AND UPPER(a.pol_iss_cd) = UPPER(p_pol_iss_cd)
               AND a.issue_yy          = p_issue_yy
               AND a.pol_seq_no        = p_pol_seq_no
               AND a.renew_no          = p_renew_no 
               AND (((DECODE(p_dt_basis, 1, a.clm_file_date,2, a.dsp_loss_date, a.clm_file_date) >= p_from_date)
                   AND (DECODE(p_dt_basis, 1, a.clm_file_date,2, a.dsp_loss_date, a.clm_file_date)<= p_to_date ))
                   OR (DECODE(p_dt_basis, 1, a.clm_file_date,2, a.dsp_loss_date, a.clm_file_date) <= p_as_of))
                 )
        LOOP
            v_list.policy_no       := i.policy_no;
            v_list.assured_name    := i.assured_name;
            v_list.claim_no        := i.claim_no;
            v_list.enrollee        := i.enrollee;
            v_list.loss_date       := to_char(i.dsp_loss_date, 'MM-DD-YYYY');
            v_list.claim_file_date := to_char(i.clm_file_date, 'MM-DD-YYYY');
            v_list.loss_reserve    := format_amt(i.loss_res_amt);
            v_list.expense_reserve := format_amt(i.exp_res_amt);
            v_list.loss_paid       := format_amt(i.loss_pd_amt);
            v_list.expense_paid    := format_amt(i.exp_pd_amt);
                       
            PIPE ROW(v_list);
        END LOOP;
        RETURN;
   END;
END csv_giclr278_pkg;
/
