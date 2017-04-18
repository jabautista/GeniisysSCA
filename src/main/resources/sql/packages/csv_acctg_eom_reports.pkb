CREATE OR REPLACE PACKAGE BODY CPI.Csv_Acctg_EOM_reports
AS

FUNCTION GIACR101_PROD_REG_WITH_TAX_DTL(p_parameter     NUMBER,
                                        p_date          DATE,
                                        p_date2         DATE,
                                        p_iss_cd        VARCHAR2,
                                        p_line_cd       VARCHAR2,
                                        p_subline_cd    VARCHAR2)
    RETURN tdr_type
    PIPELINED
  IS
    v_tdr           tdr_rec_type;

  BEGIN

/* Created by Vondanix 4/19/2013
** Modified query based from GIACS101 Program Unit: Direct Register
*/

    FOR x IN (
        SELECT   gi.iss_cd gi_iss_cd, gi.iss_name gi_iss_name,
                 gp.policy_id gp_policy_id, gp.line_cd gp_line_cd,
                 gp.subline_cd gp_subline_cd,
                 DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd) gp_iss_cd,
                 gp.issue_yy gp_issue_yy, gp.pol_seq_no gp_pol_seq_no,
                 gp.renew_no gp_renew_no, gp.endt_iss_cd gp_endt_iss_cd,
                 gp.endt_yy gp_endt_yy, gp.endt_seq_no gp_endt_seq_no,
                 gp.incept_date gp_incept_date, gp.expiry_date gp_expiry_date,
                 gl.line_name gl_line_name, gs.subline_name gs_subline_name,
                 gp.tsi_amt gp_tsi_amt, gp.prem_amt gp_prem_amt,
                 giv.acct_ent_date giv_acct_ent_date,
                 SUM (DECODE (gpr.param_name, 'EVAT', git.tax_amt, 0) * giv.currency_rt) gparam_evat,
                 SUM (DECODE (gpr.param_name, 'PREM_TAX', git.tax_amt, 0) * giv.currency_rt) gparam_prem_tax,
                 SUM (DECODE (gpr.param_name, 'FST', git.tax_amt, 0) * giv.currency_rt) gparam_fst,
                 SUM (DECODE (gpr.param_name, 'LGT', git.tax_amt, 0) * giv.currency_rt) gparam_lgt,
                 SUM (DECODE (gpr.param_name, 'DOC_STAMPS', git.tax_amt, 0) * giv.currency_rt) gparam_doc_stamps,

                 (SUM (  DECODE (gpr.param_name, 'EVAT', git.tax_amt, 0) * giv.currency_rt) +
                  SUM (  DECODE (gpr.param_name, 'PREM_TAX', git.tax_amt, 0) * giv.currency_rt) +
                  SUM (  DECODE (gpr.param_name, 'FST', git.tax_amt, 0) * giv.currency_rt) +
                  SUM (  DECODE (gpr.param_name, 'LGT', git.tax_amt, 0) * giv.currency_rt) +
                  SUM (  DECODE (gpr.param_name, 'DOC_STAMPS', git.tax_amt, 0) * giv.currency_rt)) total_taxes
        FROM     giis_issource gi,
                 gipi_polbasic gp,
                 giis_line gl,
                 giis_subline gs,
                 giac_parameters gpr,
                 gipi_inv_tax git,
                 gipi_invoice giv
        WHERE    gp.line_cd = gl.line_cd
          AND    gp.iss_cd = gi.iss_cd
          AND    gp.subline_cd = gs.subline_cd
          AND    gl.line_cd = gs.line_cd
          AND    gp.policy_id = giv.policy_id
          AND    giv.iss_cd = git.iss_cd(+)
          AND    giv.prem_seq_no = git.prem_seq_no(+)
          AND    git.tax_cd = gpr.param_value_n(+)
          AND    DECODE (gp.iss_cd, 'BB', 0, 'RI', 0, 1) = 1
          AND    (TRUNC(giv.acct_ent_date) BETWEEN p_date AND p_date2)
          AND    gi.iss_cd = NVL (p_iss_cd, gi.iss_cd)
          AND    gl.line_cd = NVL (p_line_cd, gl.line_cd)
          AND    gs.subline_cd = NVL (p_subline_cd, gs.subline_cd)
          AND    DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd) =
                    DECODE (p_parameter, 1, NVL (gp.cred_branch, gp.iss_cd), NVL (p_iss_cd, gp.iss_cd))
          AND    check_user_per_iss_cd_acctg (NULL, DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd), 'GIACS101') = 1
        GROUP BY gi.iss_cd,
                 gi.iss_name,
                 gp.policy_id,
                 gp.line_cd,
                 gp.subline_cd,
                 DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd),
                 gp.issue_yy,
                 gp.pol_seq_no,
                 gp.renew_no,
                 gp.endt_iss_cd,
                 gp.endt_yy,
                 gp.endt_seq_no,
                 gp.incept_date,
                 gp.expiry_date,
                 gl.line_name,
                 gs.subline_name,
                 gp.tsi_amt,
                 gp.prem_amt,
                 giv.acct_ent_date
        UNION ALL
        SELECT   gi.iss_cd gi_iss_cd,
                 gi.iss_name gi_iss_name,
                 gp.policy_id gp_policy_id, gp.line_cd gp_line_cd,
                 gp.subline_cd gp_subline_cd,
                 DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd) gp_iss_cd,
                 gp.issue_yy gp_issue_yy, gp.pol_seq_no gp_pol_seq_no,
                 gp.renew_no gp_renew_no, gp.endt_iss_cd gp_endt_iss_cd,
                 gp.endt_yy gp_endt_yy, gp.endt_seq_no gp_endt_seq_no,
                 gp.incept_date gp_incept_date, gp.expiry_date gp_expiry_date,
                 gl.line_name gl_line_name, gs.subline_name gs_subline_name,
                 DECODE (gp.pol_flag, TO_CHAR (5), (gp.tsi_amt) * (-1), gp.tsi_amt) gp_tsi_amt,
                 DECODE (gp.pol_flag, TO_CHAR (5), (gp.prem_amt) * (-1), gp.prem_amt) gp_prem_amt,
                 giv.acct_ent_date giv_acct_ent_date,
                 DECODE (gp.pol_flag, TO_CHAR (5), ( SUM(  DECODE (gpr.param_name, 'EVAT', git.tax_amt, 0) * giv.currency_rt) * (-1)),
                         SUM (  DECODE (gpr.param_name, 'EVAT', git.tax_amt, 0) * giv.currency_rt)) gparam_evat,
                 DECODE (gp.pol_flag, TO_CHAR (5), (  SUM (  DECODE (gpr.param_name, 'PREM_TAX', git.tax_amt, 0) * giv.currency_rt) * (-1)),
                         SUM (  DECODE (gpr.param_name, 'PREM_TAX', git.tax_amt, 0) * giv.currency_rt)) gparam_prem_tax,
                 DECODE (gp.pol_flag, TO_CHAR (5), (  SUM (  DECODE (gpr.param_name, 'FST', git.tax_amt, 0) * giv.currency_rt) * (-1)),
                         SUM (  DECODE (gpr.param_name, 'FST', git.tax_amt, 0) * giv.currency_rt)) gparam_fst,
                 DECODE (gp.pol_flag, TO_CHAR (5), (  SUM (  DECODE (gpr.param_name, 'LGT', git.tax_amt, 0) * giv.currency_rt) * (-1)),
                         SUM (  DECODE (gpr.param_name, 'LGT', git.tax_amt, 0) * giv.currency_rt)) gparam_lgt,
                 DECODE (gp.pol_flag, TO_CHAR (5), (  SUM (  DECODE (gpr.param_name, 'DOC_STAMPS', git.tax_amt, 0) * giv.currency_rt) * (-1)),
                         SUM (  DECODE (gpr.param_name, 'DOC_STAMPS', git.tax_amt, 0) * giv.currency_rt)) gparam_doc_stamps,

                 (DECODE(GP.POL_FLAG, TO_CHAR(5), (SUM(DECODE(GPR.PARAM_NAME,'EVAT',GIT.TAX_AMT,0)*GIV.CURRENCY_RT)*(-1)),SUM(DECODE(GPR.PARAM_NAME,'EVAT',GIT.TAX_AMT,0)*GIV.CURRENCY_RT)) +
                 DECODE(GP.POL_FLAG, TO_CHAR(5), (SUM(DECODE(GPR.PARAM_NAME,'PREM_TAX',GIT.TAX_AMT,0)*GIV.CURRENCY_RT)*(-1)),SUM(DECODE(GPR.PARAM_NAME,'PREM_TAX',GIT.TAX_AMT,0)*GIV.CURRENCY_RT)) +
                 DECODE(GP.POL_FLAG, TO_CHAR(5), (SUM(DECODE(GPR.PARAM_NAME,'FST',GIT.TAX_AMT,0)*GIV.CURRENCY_RT)*(-1)),SUM(DECODE(GPR.PARAM_NAME,'FST',GIT.TAX_AMT,0)*GIV.CURRENCY_RT)) +
                 DECODE(GP.POL_FLAG, TO_CHAR(5), (SUM(DECODE(GPR.PARAM_NAME,'LGT',GIT.TAX_AMT,0)*GIV.CURRENCY_RT)*(-1)),SUM(DECODE(GPR.PARAM_NAME,'LGT',GIT.TAX_AMT,0)*GIV.CURRENCY_RT)) +
                 DECODE(GP.POL_FLAG, TO_CHAR(5), (SUM(DECODE(GPR.PARAM_NAME,'DOC_STAMPS',GIT.TAX_AMT,0)*GIV.CURRENCY_RT)*(-1)),SUM(DECODE(GPR.PARAM_NAME,'DOC_STAMPS',GIT.TAX_AMT,0)*GIV.CURRENCY_RT))) Total_taxes

        FROM     giis_issource gi,
                 gipi_polbasic gp,
                 giis_line gl,
                 giis_subline gs,
                 giac_parameters gpr,
                 gipi_inv_tax git,
                 gipi_invoice giv
        WHERE    gp.line_cd = gl.line_cd
          AND    gp.iss_cd = gi.iss_cd
          AND    gp.subline_cd = gs.subline_cd
          AND    gl.line_cd = gs.line_cd
          AND    gp.policy_id = giv.policy_id
          AND    giv.iss_cd = git.iss_cd(+)
          AND    giv.prem_seq_no = git.prem_seq_no(+)
          AND    git.tax_cd = gpr.param_value_n(+)
          AND    DECODE (gp.iss_cd, 'BB', 0, 'RI', 0, 1) = 1
          AND    (TRUNC (giv.spoiled_acct_ent_date) BETWEEN p_date AND p_date2)
          AND    (gp.pol_flag = TO_CHAR (1)
                 OR gp.pol_flag = TO_CHAR (2)
                 OR gp.pol_flag = TO_CHAR (3)
                 OR gp.pol_flag = TO_CHAR (4)
                 OR gp.pol_flag = TO_CHAR (5))
          AND    gi.iss_cd = NVL (p_iss_cd, gi.iss_cd)
          AND    gl.line_cd = NVL (p_line_cd, gl.line_cd)
          AND    gs.subline_cd = NVL (p_subline_cd, gs.subline_cd)
          AND    DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd) =
                    DECODE (p_parameter, 1, NVL (gp.cred_branch, gp.iss_cd), NVL (p_iss_cd, gp.iss_cd))
          AND    check_user_per_iss_cd_acctg (NULL, DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd), 'GIACS101') = 1
        GROUP BY giv.spoiled_acct_ent_date,
                 gp.pol_flag,
                 gi.iss_cd,
                 gi.iss_name,
                 gp.policy_id,
                 gp.line_cd,
                 gp.subline_cd,
                 DECODE (p_parameter, 1, gp.cred_branch, gp.iss_cd),
                 gp.issue_yy,
                 gp.pol_seq_no,
                 gp.renew_no,
                 gp.endt_iss_cd,
                 gp.endt_yy,
                 gp.endt_seq_no,
                 gp.incept_date,
                 gp.expiry_date,
                 gl.line_name,
                 gs.subline_name,
                 gp.tsi_amt,
                 gp.prem_amt,
                 giv.acct_ent_date
        ORDER BY 1, 4, 5, 6, 7, 8, 9, 10, 11, 12)
    LOOP

    v_tdr.policy_no :=  x.GP_line_cd ||'-'||
                        x.GP_subline_cd ||'-'||
                        x.GP_iss_cd ||'-'||
                        ltrim(to_char(x.GP_issue_yy,'00'))||'-'||
                        ltrim(to_char(x.GP_pol_seq_no,'0000000'))||'-'||
                        ltrim(to_char(x.GP_renew_no,'00'));

    IF x.GP_ENDT_SEQ_NO <> 0 THEN
    v_tdr.policy_no :=  v_tdr.policy_no||'/'||x.GP_endt_iss_cd||'-'||
                                              ltrim(to_char(x.GP_endt_yy,'00'))||'-'||
                                              ltrim(to_char(x.GP_endt_seq_no,'000000'));
    END IF;

    v_tdr.incept_date   :=  x.GP_incept_date;
    v_tdr.expiry_date   :=  x.GP_expiry_date;
    v_tdr.tsi_amt       :=  x.GP_tsi_amt;
    v_tdr.total_prem    :=  x.GP_prem_amt;
    v_tdr.vat_amt       :=  x.GPARAM_evat;
    v_tdr.prem_tax      :=  x.GPARAM_prem_tax;
    v_tdr.fst           :=  x.GPARAM_fst;
    v_tdr.lgt           :=  x.GPARAM_lgt;
    v_tdr.docstamps     :=  x.GPARAM_doc_stamps;
    v_tdr.total_tax     :=  x.total_taxes;


    PIPE ROW(v_tdr);
    END LOOP;


    RETURN;

    END;
END;
/


