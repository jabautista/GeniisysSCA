CREATE OR REPLACE PACKAGE BODY CPI.Bae AS
/*
  Created By: Michaell
  Created On: Nov. 7, 2002
  Remarks   : This is the package body of package BAE. This contains the codes that
              where previously being run as scripts using PL/SQL. Modifications where
              made to accommodate the use of the BULK COLLECT function. The DATE variables
              are being passed to the VARCHAR2 table types because collections cannot
              handle date variables. Before inserting they are converted again to
              dates. This also contains the codes for the data checking used before
              running the batch production.
*/
/* modified by judyann 04032008
** added columns bill_iss_cd and prem_seq_no
** take-up of policy will be by bill number; this is due to the long-term policy enhancement
*/
/* modified by judyann 04172008
** added parameters GEN_VAT_ON_RI (to generate acctg entries for VAT)
** and GEN_TRTY_PREM_VAT (to generate acctg entries for VAT on premium and withholding VAT)
** to handle different treaty batch take-up of clients
*/

PROCEDURE bae1_copy_tax_to_extract
   (p_prod_date DATE) AS
   TYPE pol_id_tab IS TABLE OF GIAC_PRODUCTION_EXT.policy_id%TYPE;
   TYPE fund_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.fund_cd%TYPE;
   TYPE acct_br_tab IS TABLE OF GIAC_PRODUCTION_EXT.acct_branch_cd%TYPE;
   TYPE acct_ent_tab IS TABLE OF VARCHAR2(20);
   TYPE pos_neg_tab IS TABLE OF GIAC_PRODUCTION_EXT.pos_neg_inclusion%TYPE;
   TYPE spld_acct_ent_tab IS TABLE OF VARCHAR2(20);
   TYPE iss_cd_tab IS TABLE OF GIPI_INVOICE.iss_cd%TYPE;
   TYPE prem_seq_tab IS TABLE OF GIPI_INVOICE.prem_seq_no%TYPE;
   TYPE curr_rt_tab IS TABLE OF GIPI_INVOICE.currency_rt%TYPE;
   TYPE tax_cd_tab IS TABLE OF GIPI_INV_TAX.tax_cd%TYPE;
   TYPE tax_name_tab IS TABLE OF GIAC_TAXES.tax_name%TYPE;
   TYPE tax_amt_tab IS TABLE OF GIPI_INV_TAX.tax_amt%TYPE;
   vv_pol_id  pol_id_tab;
   vv_fund_cd  fund_cd_tab;
   vv_acct_br  acct_br_tab;
   vv_acct_ent  acct_ent_tab;
   vv_pos_neg  pos_neg_tab;
   vv_spld_acct_ent spld_acct_ent_tab;
   vv_iss_cd  iss_cd_tab;
   vv_prem_seq  prem_seq_tab;
   vv_curr_rt  curr_rt_tab;
   vv_tax_cd  tax_cd_tab;
   vv_tax_name  tax_name_tab;
   vv_tax_amt  tax_amt_tab;
BEGIN
   SELECT A.policy_id,A.fund_cd,A.acct_branch_cd,b.iss_cd,b.prem_seq_no,
          c.tax_cd,d.tax_name,b.currency_rt,c.tax_amt,
          TO_CHAR(A.acct_ent_date,'MM-DD-YYYY') acct_ent_date,
          A.pos_neg_inclusion, TO_CHAR(A.spld_acct_ent_date,'MM-DD-YYYY') spld_acct_ent_date
     BULK COLLECT INTO vv_pol_id,vv_fund_cd,vv_acct_br,vv_iss_cd,vv_prem_seq,
                       vv_tax_cd,vv_tax_name,vv_curr_rt,vv_tax_amt,vv_acct_ent,
                       vv_pos_neg,vv_spld_acct_ent
     FROM GIAC_PRODUCTION_EXT A,GIPI_INVOICE b,GIPI_INV_TAX c,GIAC_TAXES d
    WHERE a.policy_id = b.policy_id
   AND a.bill_iss_cd = b.iss_cd
   AND a.prem_seq_no = b.prem_seq_no
   AND b.iss_cd = c.iss_cd
      AND b.prem_seq_no = c.prem_seq_no
   AND A.fund_cd = d.fund_cd
   AND c.tax_cd = d.tax_cd;
    IF SQL%FOUND THEN
       FORALL mmb IN vv_pol_id.FIRST..vv_pol_id.LAST
          INSERT INTO GIAC_PRODUCTION_TAX_EXT(
             policy_id, fund_cd, acct_branch_cd, iss_cd, prem_seq_no,
             tax_cd, tax_name, currency_rt, tax_amt, acct_ent_date,
             pos_neg_inclusion, spld_acct_ent_date)
          VALUES(
             vv_pol_id(mmb), vv_fund_cd(mmb), vv_acct_br(mmb), vv_iss_cd(mmb), vv_prem_seq(mmb),
             vv_tax_cd(mmb), vv_tax_name(mmb), vv_curr_rt(mmb), vv_tax_amt(mmb),
             TO_DATE(vv_acct_ent(mmb),'MM-DD-YYYY'),
             vv_pos_neg(mmb), TO_DATE(vv_spld_acct_ent(mmb),'MM-DD-YYYY'));
    END IF;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE1_COPY_TAX_TO_EXTRACT');
END bae1_copy_tax_to_extract;

PROCEDURE bae1_copy_to_extract
   (p_prod_date DATE) AS
   TYPE pol_id_tab IS TABLE OF GIAC_PRODUCTION_EXT.policy_id%TYPE;
   TYPE fund_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.fund_cd%TYPE;
   TYPE iss_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.iss_cd%TYPE;
   TYPE acct_br_tab IS TABLE OF GIAC_PRODUCTION_EXT.acct_branch_cd%TYPE;
   TYPE branch_nm_tab IS TABLE OF GIAC_PRODUCTION_EXT.branch_name%TYPE;
   TYPE line_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.line_cd%TYPE;
   TYPE acct_line_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.acct_line_cd%TYPE;
   TYPE line_nm_tab IS TABLE OF GIAC_PRODUCTION_EXT.line_name%TYPE;
   TYPE subline_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.subline_cd%TYPE;
   TYPE acct_subline_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.acct_subline_cd%TYPE;
   TYPE subline_nm_tab IS TABLE OF GIAC_PRODUCTION_EXT.subline_name%TYPE;
   TYPE prem_amt_tab IS TABLE OF GIAC_PRODUCTION_EXT.prem_amt%TYPE;
   TYPE tsi_amt_tab IS TABLE OF GIAC_PRODUCTION_EXT.tsi_amt%TYPE;
   TYPE assd_no_tab IS TABLE OF GIAC_PRODUCTION_EXT.assd_no%TYPE;
   TYPE incept_dt_tab IS TABLE OF VARCHAR2(20);
   TYPE issue_dt_tab IS TABLE OF VARCHAR2(20);
   TYPE booking_mth_tab IS TABLE OF GIAC_PRODUCTION_EXT.booking_mth%TYPE;
   TYPE acct_ent_tab IS TABLE OF VARCHAR2(20);
   TYPE pos_neg_tab IS TABLE OF GIAC_PRODUCTION_EXT.pos_neg_inclusion%TYPE;
   TYPE spld_acct_ent_tab IS TABLE OF VARCHAR2(20);
   TYPE pol_no_tab IS TABLE OF GIAC_PRODUCTION_EXT.policy_no%TYPE;
   TYPE intm_no_tab IS TABLE OF GIAC_PRODUCTION_EXT.intm_no%TYPE;
   TYPE acct_intm_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.acct_intm_cd%TYPE;
   TYPE booking_yr_tab IS TABLE OF GIAC_PRODUCTION_EXT.booking_year%TYPE;
   TYPE expiry_dt_tab IS TABLE OF VARCHAR2(20);
   TYPE bill_iss_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.bill_iss_cd%TYPE;
   TYPE prem_seq_no_tab IS TABLE OF GIAC_PRODUCTION_EXT.prem_seq_no%TYPE;
   vv_pol_id  pol_id_tab;
   vv_fund_cd  fund_cd_tab;
   vv_iss_cd  iss_cd_tab;
   vv_acct_br  acct_br_tab;
   vv_branch_nm  branch_nm_tab;
   vv_line_cd  line_cd_tab;
   vv_acct_line_cd acct_line_cd_tab;
   vv_line_nm  line_nm_tab;
   vv_subline_cd subline_cd_tab;
   vv_acct_subline_cd acct_subline_cd_tab;
   vv_subline_nm subline_nm_tab;
   vv_prem_amt  prem_amt_tab;
   vv_tsi_amt  tsi_amt_tab;
   vv_assd_no  assd_no_tab;
   vv_incept_dt  incept_dt_tab;
   vv_issue_dt  issue_dt_tab;
   vv_booking_mth booking_mth_tab;
   vv_acct_ent  acct_ent_tab;
   vv_pos_neg  pos_neg_tab;
   vv_spld_acct_ent spld_acct_ent_tab;
   vv_pol_no  pol_no_tab;
   vv_intm_no  intm_no_tab;
   vv_acct_intm_cd acct_intm_cd_tab;
   vv_booking_yr booking_yr_tab;
   vv_expiry_dt  expiry_dt_tab;
   vv_bill_iss_cd bill_iss_cd_tab;
   vv_prem_seq_no prem_seq_no_tab;
BEGIN
   SELECT policy_id,fund_cd,iss_cd,acct_branch_cd,branch_name,line_cd,
          acct_line_cd,line_name,subline_cd,acct_subline_cd,subline_name,prem_amt,
          tsi_amt,assd_no,TO_CHAR(incept_date,'MM-DD-YYYY') incept_date,
          TO_CHAR(issue_date,'MM-DD-YYYY') issue_date,
          booking_mth,TO_CHAR(acct_ent_date,'MM-DD-YYYY') acct_ent_date,
          pos_neg_inclusion,
          TO_CHAR(spld_acct_ent_date,'MM-DD-YYYY') spld_acct_ent_date,
          policy_no,parent_intm_no intm_no,acct_intm_cd,
          booking_year,TO_CHAR(expiry_date,'MM-DD-YYYY') expiry_date,
    bill_iss_cd, prem_seq_no
   BULK COLLECT INTO vv_pol_id,vv_fund_cd,vv_iss_cd,vv_acct_br,vv_branch_nm,vv_line_cd,
                     vv_acct_line_cd,vv_line_nm,vv_subline_cd,vv_acct_subline_cd,vv_subline_nm,vv_prem_amt,
                     vv_tsi_amt,vv_assd_no,vv_incept_dt,vv_issue_dt,vv_booking_mth,vv_acct_ent,
                     vv_pos_neg,vv_spld_acct_ent,vv_pol_no,vv_intm_no,vv_acct_intm_cd,
                     vv_booking_yr,vv_expiry_dt,
      vv_bill_iss_cd, vv_prem_seq_no
   FROM giac_bae_giacb001_v
   WHERE TO_DATE(booking_mth||'-'||booking_year,'FMMONTH-YYYY') <= p_prod_date;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_pol_id.FIRST..vv_pol_id.LAST
         INSERT INTO GIAC_PRODUCTION_EXT(
            policy_id, fund_cd, iss_cd, acct_branch_cd, branch_name,
            line_cd, acct_line_cd, line_name, subline_cd, acct_subline_cd,
            subline_name, prem_amt, tsi_amt, assd_no, incept_date,
            issue_date, booking_mth, acct_ent_date, pos_neg_inclusion, spld_acct_ent_date,
            policy_no, intm_no, acct_intm_cd, booking_year, expiry_date,
   bill_iss_cd, prem_seq_no)
         VALUES(
            vv_pol_id(mmb), vv_fund_cd(mmb), vv_iss_cd(mmb), vv_acct_br(mmb), vv_branch_nm(mmb),
            vv_line_cd(mmb), vv_acct_line_cd(mmb), vv_line_nm(mmb), vv_subline_cd(mmb), vv_acct_subline_cd(mmb),
            vv_subline_nm(mmb), vv_prem_amt(mmb), vv_tsi_amt(mmb), vv_assd_no(mmb),
            TO_DATE(vv_incept_dt(mmb),'MM-DD-YYYY'),
            TO_DATE(vv_issue_dt(mmb),'MM-DD-YYYY'), vv_booking_mth(mmb),
            TO_DATE(vv_acct_ent(mmb),'MM-DD-YYYY'),
            vv_pos_neg(mmb), TO_DATE(vv_spld_acct_ent(mmb),'MM-DD-YYYY'),
            vv_pol_no(mmb), vv_intm_no(mmb), vv_acct_intm_cd(mmb), vv_booking_yr(mmb),
            TO_DATE(vv_expiry_dt(mmb),'MM-DD-YYYY'),
   vv_bill_iss_cd(mmb), vv_prem_seq_no(mmb));
   END IF;
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE1_COPY_TO_EXTRACT');
END bae1_copy_to_extract;

PROCEDURE bae1_copy_to_extract_reg
   (p_prod_date DATE) AS
   TYPE pol_id_tab IS TABLE OF GIAC_PRODUCTION_EXT.policy_id%TYPE;
   TYPE fund_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.fund_cd%TYPE;
   TYPE iss_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.iss_cd%TYPE;
   TYPE acct_br_tab IS TABLE OF GIAC_PRODUCTION_EXT.acct_branch_cd%TYPE;
   TYPE branch_nm_tab IS TABLE OF GIAC_PRODUCTION_EXT.branch_name%TYPE;
   TYPE line_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.line_cd%TYPE;
   TYPE acct_line_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.acct_line_cd%TYPE;
   TYPE line_nm_tab IS TABLE OF GIAC_PRODUCTION_EXT.line_name%TYPE;
   TYPE subline_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.subline_cd%TYPE;
   TYPE acct_subline_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.acct_subline_cd%TYPE;
   TYPE subline_nm_tab IS TABLE OF GIAC_PRODUCTION_EXT.subline_name%TYPE;
   TYPE prem_amt_tab IS TABLE OF GIAC_PRODUCTION_EXT.prem_amt%TYPE;
   TYPE tsi_amt_tab IS TABLE OF GIAC_PRODUCTION_EXT.tsi_amt%TYPE;
   TYPE assd_no_tab IS TABLE OF GIAC_PRODUCTION_EXT.assd_no%TYPE;
   TYPE incept_dt_tab IS TABLE OF VARCHAR2(20);
   TYPE issue_dt_tab IS TABLE OF VARCHAR2(20);
   TYPE booking_mth_tab IS TABLE OF GIAC_PRODUCTION_EXT.booking_mth%TYPE;
   TYPE acct_ent_tab IS TABLE OF VARCHAR2(20);
   TYPE pos_neg_tab IS TABLE OF GIAC_PRODUCTION_EXT.pos_neg_inclusion%TYPE;
   TYPE spld_acct_ent_tab IS TABLE OF VARCHAR2(20);
   TYPE pol_no_tab IS TABLE OF GIAC_PRODUCTION_EXT.policy_no%TYPE;
   TYPE intm_no_tab IS TABLE OF GIAC_PRODUCTION_EXT.intm_no%TYPE;
   TYPE acct_intm_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.acct_intm_cd%TYPE;
   TYPE booking_yr_tab IS TABLE OF GIAC_PRODUCTION_EXT.booking_year%TYPE;
   TYPE expiry_dt_tab IS TABLE OF VARCHAR2(20);
   TYPE bill_iss_cd_tab IS TABLE OF GIAC_PRODUCTION_EXT.bill_iss_cd%TYPE;
   TYPE prem_seq_no_tab IS TABLE OF GIAC_PRODUCTION_EXT.prem_seq_no%TYPE;
   vv_pol_id  pol_id_tab;
   vv_fund_cd  fund_cd_tab;
   vv_iss_cd  iss_cd_tab;
   vv_acct_br  acct_br_tab;
   vv_branch_nm  branch_nm_tab;
   vv_line_cd  line_cd_tab;
   vv_acct_line_cd acct_line_cd_tab;
   vv_line_nm  line_nm_tab;
   vv_subline_cd subline_cd_tab;
   vv_acct_subline_cd acct_subline_cd_tab;
   vv_subline_nm subline_nm_tab;
   vv_prem_amt  prem_amt_tab;
   vv_tsi_amt  tsi_amt_tab;
   vv_assd_no  assd_no_tab;
   vv_incept_dt  incept_dt_tab;
   vv_issue_dt  issue_dt_tab;
   vv_booking_mth booking_mth_tab;
   vv_acct_ent  acct_ent_tab;
   vv_pos_neg  pos_neg_tab;
   vv_spld_acct_ent spld_acct_ent_tab;
   vv_pol_no  pol_no_tab;
   vv_intm_no  intm_no_tab;
   vv_acct_intm_cd acct_intm_cd_tab;
   vv_booking_yr booking_yr_tab;
   vv_expiry_dt  expiry_dt_tab;
   vv_bill_iss_cd bill_iss_cd_tab;
   vv_prem_seq_no prem_seq_no_tab;
BEGIN
   SELECT policy_id,fund_cd,iss_cd,acct_branch_cd,branch_name,line_cd,
          acct_line_cd,line_name,subline_cd,acct_subline_cd,subline_name,prem_amt,
          tsi_amt,assd_no,TO_CHAR(incept_date,'MM-DD-YYYY') incept_date,
          TO_CHAR(issue_date,'MM-DD-YYYY') issue_date,booking_mth,
          TO_CHAR(acct_ent_date,'MM-DD-YYYY') acct_ent_date,
          pos_neg_inclusion,
          TO_CHAR(spld_acct_ent_date,'MM-DD-YYYY'),
          policy_no,parent_intm_no intm_no,acct_intm_cd,
          booking_year,
          TO_CHAR(expiry_date,'MM-DD-YYYY'),
    bill_iss_cd, prem_seq_no
   BULK COLLECT INTO vv_pol_id,vv_fund_cd,vv_iss_cd,vv_acct_br,vv_branch_nm,vv_line_cd,
                     vv_acct_line_cd,vv_line_nm,vv_subline_cd,vv_acct_subline_cd,vv_subline_nm,vv_prem_amt,
                     vv_tsi_amt,vv_assd_no,vv_incept_dt,vv_issue_dt,vv_booking_mth,vv_acct_ent,
                     vv_pos_neg,vv_spld_acct_ent,vv_pol_no,vv_intm_no,vv_acct_intm_cd,
                     vv_booking_yr,vv_expiry_dt,
      vv_bill_iss_cd, vv_prem_seq_no
   FROM giac_bae_giacb001_v
   WHERE TO_DATE(booking_mth||'-'||booking_year,'FMMONTH-YYYY') <= p_prod_date
     AND reg_policy_sw = 'Y';
   IF SQL%FOUND THEN
      FORALL mmb IN vv_pol_id.FIRST..vv_pol_id.LAST
         INSERT INTO GIAC_PRODUCTION_EXT(
            policy_id, fund_cd, iss_cd, acct_branch_cd, branch_name,
            line_cd, acct_line_cd, line_name, subline_cd, acct_subline_cd,
            subline_name, prem_amt, tsi_amt, assd_no, incept_date,
            issue_date, booking_mth, acct_ent_date, pos_neg_inclusion, spld_acct_ent_date,
            policy_no, intm_no, acct_intm_cd, booking_year, expiry_date,
   bill_iss_cd, prem_seq_no)
         VALUES(
            vv_pol_id(mmb), vv_fund_cd(mmb), vv_iss_cd(mmb), vv_acct_br(mmb), vv_branch_nm(mmb),
            vv_line_cd(mmb), vv_acct_line_cd(mmb), vv_line_nm(mmb), vv_subline_cd(mmb), vv_acct_subline_cd(mmb),
            vv_subline_nm(mmb), vv_prem_amt(mmb), vv_tsi_amt(mmb), vv_assd_no(mmb),
            TO_DATE(vv_incept_dt(mmb),'MM-DD-YYYY'),
            TO_DATE(vv_issue_dt(mmb),'MM-DD-YYYY'),
            vv_booking_mth(mmb),
            TO_DATE(vv_acct_ent(mmb),'MM-DD-YYYY'), vv_pos_neg(mmb),
            TO_DATE(vv_spld_acct_ent(mmb),'MM-DD-YYYY'),
            vv_pol_no(mmb), vv_intm_no(mmb), vv_acct_intm_cd(mmb), vv_booking_yr(mmb),
            TO_DATE(vv_expiry_dt(mmb),'MM-DD-YYYY'),
   vv_bill_iss_cd(mmb), vv_prem_seq_no(mmb));
   END IF;
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20000,'DUPLICATE VALUE BY BAE1_COPY_TO_EXTRACT_REG');
END bae1_copy_to_extract_reg;

PROCEDURE bae1_create_comm
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_item_no   NUMBER) AS
    TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
    TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;

 --jason 10/3/2008: added the following variable
 --v_param_val   GIAC_PARAMETERS.param_value_v%TYPE := Giacp.v('ENTER_PREPAID_COMM');  --commented by jason 08192009

BEGIN
 -- IF p_item_no NOT IN (11,12) THEN --jason 10/9/2008  --commented by jason: 8/19/2009
    SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
           A.iss_cd gacc_gibr_branch_cd, 1 acct_entry_id,c.gl_acct_id,c.gl_acct_category,
           c.gl_control_acct ,c.gl_sub_acct_1,c.gl_sub_acct_2,c.gl_sub_acct_3,
           c.gl_sub_acct_4   ,c.gl_sub_acct_5,c.gl_sub_acct_6,c.gl_sub_acct_7,
          --DECODE(NVL(c.gslt_sl_type_cd,'0'),'6', TO_NUMBER(LTRIM(TO_CHAR(A.acct_line_cd,'00'))||
            --LTRIM(TO_CHAR(A.acct_subline_cd,'00'))||LTRIM(TO_CHAR(A.peril_cd,'00'))),'3',A.parent_intm_no, NULL) sl_cd,--comment out and replaced by codes below mikel 03.21.2016 AUII 5467
           DECODE( NVL (c.gslt_sl_type_cd, '0'),
                    '6',   (a.acct_line_cd * 100000)
                         + (a.acct_subline_cd * 1000)
                         + NVL (a.peril_cd, 0),

                    '3', a.parent_intm_no,
                    NULL) sl_cd, --mikel 03.21.2016 AUII 5467 
           DECODE(c.dr_cr_tag,'D',
           DECODE(A.pos_neg_inclusion,'P',
           DECODE(SIGN(commission_amt),1,commission_amt/100, 0),
           DECODE(SIGN(commission_amt),1,0,commission_amt*-1/100)),
           DECODE(A.pos_neg_inclusion,'P',
           DECODE(SIGN(commission_amt),1,0,commission_amt*-1/100),
           DECODE(SIGN(commission_amt),1,commission_amt/100, 0))) debit_amt,
           DECODE(c.dr_cr_tag,'C',
           DECODE(A.pos_neg_inclusion,'P',
           DECODE(SIGN(commission_amt),1,commission_amt/100,0),
           DECODE(SIGN(commission_amt),1,0,commission_amt*-1/100)),
           DECODE(A.pos_neg_inclusion,'P',
           DECODE(SIGN(commission_amt),1,0,commission_amt*-1/100),
           DECODE(SIGN(commission_amt),1,commission_amt/100, 0))) credit_amt,
           NULL generation_type,c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd,
           b.user_id user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update,NULL remarks
      BULK COLLECT INTO vv_tran_id,vv_fund_cd,
                        vv_branch_cd,vv_acct_entry,vv_gl_id,vv_gl_categ,
                        vv_gl_cont,vv_gl_sub1,vv_gl_sub2,vv_gl_sub3,
                        vv_gl_sub4,vv_gl_sub5,vv_gl_sub6,vv_gl_sub7,
                        vv_sl_cd,
                        vv_debit_amt,
                        vv_credit_amt,
                        vv_gen_type,vv_sl_type_cd,vv_sl_src_cd,
                        vv_user_id,vv_last_upd,vv_remarks
      FROM giac_production_ext_dtl_v A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
     WHERE A.iss_cd = b.gibr_branch_cd
       AND b.tran_flag = 'C'
       AND b.tran_class = 'PRD'
       AND TRUNC(b.tran_date) = TRUNC(p_prod_date)
       AND NVL(commission_amt,0) != 0
       AND A.acct_line_cd = DECODE( p_line_dep, 0 , A.acct_line_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
       AND A.acct_intm_cd = DECODE( p_intm_dep, 0 , A.acct_intm_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
       AND c.item_no = p_item_no;

 --commented the following code by jason 8/192009: generation of entries for prepaid commissions will be handled by the newly created batch module, GIACB006
 --  --added by jason 10/2/2008: to handle generation of Prepaid Commissions for advanced commission payments for GIACB001
 --  ELSIF p_item_no IN (11,12) THEN

  /*    SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
            A.iss_cd gacc_gibr_branch_cd, 1 acct_entry_id,c.gl_acct_id,c.gl_acct_category,
            c.gl_control_acct ,c.gl_sub_acct_1,c.gl_sub_acct_2,c.gl_sub_acct_3,
            c.gl_sub_acct_4   ,c.gl_sub_acct_5,c.gl_sub_acct_6,c.gl_sub_acct_7,
            DECODE(NVL(c.gslt_sl_type_cd,'0'),'6', TO_NUMBER(LTRIM(TO_CHAR(A.acct_line_cd,'00'))||
            LTRIM(TO_CHAR(A.acct_subline_cd,'00'))||LTRIM(TO_CHAR(A.peril_cd,'00'))),'3',A.parent_intm_no, NULL) sl_cd,
            DECODE(c.dr_cr_tag,'D',
            DECODE(A.pos_neg_inclusion,'P',
            DECODE(SIGN(commission_amt),1,commission_amt/100, 0),
            DECODE(SIGN(commission_amt),1,0,commission_amt*-1/100)),
            DECODE(A.pos_neg_inclusion,'P',
            DECODE(SIGN(commission_amt),1,0,commission_amt*-1/100),
            DECODE(SIGN(commission_amt),1,commission_amt/100, 0))) debit_amt,
            DECODE(c.dr_cr_tag,'C',
            DECODE(A.pos_neg_inclusion,'P',
            DECODE(SIGN(commission_amt),1,commission_amt/100,0),
            DECODE(SIGN(commission_amt),1,0,commission_amt*-1/100)),
            DECODE(A.pos_neg_inclusion,'P',
            DECODE(SIGN(commission_amt),1,0,commission_amt*-1/100),
            DECODE(SIGN(commission_amt),1,commission_amt/100, 0))) credit_amt,
            NULL generation_type,c.gslt_sl_type_cd, 1 sl_source_cd,
            b.user_id user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update,NULL remarks
       BULK COLLECT INTO vv_tran_id,vv_fund_cd,
                       vv_branch_cd,vv_acct_entry,vv_gl_id,vv_gl_categ,
                       vv_gl_cont,vv_gl_sub1,vv_gl_sub2,vv_gl_sub3,
                       vv_gl_sub4,vv_gl_sub5,vv_gl_sub6,vv_gl_sub7,
                       vv_sl_cd,
                       vv_debit_amt,
                       vv_credit_amt,
                       vv_gen_type,vv_sl_type_cd,vv_sl_src_cd,
                       vv_user_id,vv_last_upd,vv_remarks
       FROM giac_production_ext_dtl_v A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
      WHERE A.iss_cd = b.gibr_branch_cd
        AND b.tran_flag = 'C'
        AND b.tran_class = 'PRD'
        AND TRUNC(b.tran_date) = TRUNC(p_prod_date)
        AND NVL(commission_amt,0) != 0
        AND A.acct_line_cd = DECODE( p_line_dep, 0 , A.acct_line_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
        AND A.acct_intm_cd = DECODE( p_intm_dep, 0 , A.acct_intm_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
     AND c.item_no = p_item_no
        AND EXISTS (SELECT 1
                   FROM GIAC_ADVANCED_PAYT
             WHERE iss_cd = a.bill_iss_cd
                 AND prem_seq_no = a.prem_seq_no);

  END IF;
  --jason end of modification: 10/9/2008
*/

  IF SQL%FOUND THEN
    FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
      INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
      VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
  END IF;
  COMMIT;



EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE1_CREATE_COMM');
END bae1_create_comm;

PROCEDURE bae1_create_other_charges
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_item_no   NUMBER) AS
    TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
    TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT DISTINCT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          A.iss_cd gacc_gibr_branch_cd, 1 acct_entry_id,c.gl_acct_id,c.gl_acct_category,
          c.gl_control_acct,c.gl_sub_acct_1,c.gl_sub_acct_2,c.gl_sub_acct_3,
          c.gl_sub_acct_4  ,c.gl_sub_acct_5,c.gl_sub_acct_6,c.gl_sub_acct_7,
          --DECODE(NVL(c.gslt_sl_type_cd,'0'),'6', TO_NUMBER(LTRIM(TO_CHAR(A.acct_line_cd,'00'))||LTRIM(TO_CHAR(A.acct_subline_cd,'00'))||LTRIM(TO_CHAR(A.peril_cd,'00'))),'1', A.assd_no, NULL) sl_cd, --comment out and replaced by codes below mikel 03.21.2016 AUII 5467
          DECODE (NVL (c.gslt_sl_type_cd, '0'),
                    '6',   (a.acct_line_cd * 100000)
                         + (a.acct_subline_cd * 1000)
                         + NVL (a.peril_cd, 0),

                    '1', a.assd_no,
                    NULL) sl_cd, --mikel 03.21.2016 AUII 5467
          DECODE(c.dr_cr_tag,'D',DECODE(A.pos_neg_inclusion,'P',DECODE(SIGN(A.OTHERS),1,A.OTHERS/100,0),DECODE(SIGN(A.OTHERS),1,0,A.OTHERS*-1/100)),DECODE(A.pos_neg_inclusion,'P',DECODE(SIGN(A.OTHERS),1,0,A.OTHERS*-1/100),DECODE(SIGN(A.OTHERS),1,A.OTHERS/100, 0))) debit_amt,
          DECODE(c.dr_cr_tag,'C',DECODE(A.pos_neg_inclusion,'P',DECODE(SIGN(A.OTHERS),1,A.OTHERS/100,0),DECODE(SIGN(A.OTHERS),1,0,A.OTHERS*-1/100)),DECODE(A.pos_neg_inclusion,'P',DECODE(SIGN(A.OTHERS),1,0,A.OTHERS*-1/100),DECODE(SIGN(A.OTHERS),1,A.OTHERS/100, 0))) credit_amt,
          NULL generation_type, c.gslt_sl_type_cd sl_type_cd,1 sl_source_cd,
          b.user_id user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update,
          TO_CHAR(prem_seq_no)||'-'||TO_CHAR(policy_id) remarks
     BULK COLLECT INTO vv_tran_id,vv_fund_cd,
                       vv_branch_cd,vv_acct_entry,vv_gl_id,vv_gl_categ,
                       vv_gl_cont,vv_gl_sub1,vv_gl_sub2,vv_gl_sub3,
                       vv_gl_sub4,vv_gl_sub5,vv_gl_sub6,vv_gl_sub7,
                       vv_sl_cd,
                       vv_debit_amt,
                       vv_credit_amt,
                       vv_gen_type,vv_sl_type_cd,vv_sl_src_cd,
                       vv_user_id,vv_last_upd,vv_remarks
     FROM giac_production_ext_dtl_v A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
    WHERE A.iss_cd = b.gibr_branch_cd AND b.tran_flag = 'C' AND b.tran_class = 'PRD'
      AND TRUNC(b.tran_date) = TRUNC(p_prod_date)
      AND NVL(A.OTHERS,0) != 0
      AND A.acct_line_cd = DECODE(p_line_dep, 0 , A.acct_line_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
      AND A.acct_intm_cd = DECODE(p_intm_dep, 0 , A.acct_intm_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
      AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE1_CREATE_OTHER_CHARGES');
END bae1_create_other_charges;

PROCEDURE bae1_create_parent_comm
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_item_no   NUMBER) AS
    TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
    TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          A.iss_cd gacc_gibr_branch_cd, 1 acct_entry_id,c.gl_acct_id,c.gl_acct_category,
          c.gl_control_acct ,c.gl_sub_acct_1 ,c.gl_sub_acct_2,c.gl_sub_acct_3,
          c.gl_sub_acct_4   ,c.gl_sub_acct_5 ,c.gl_sub_acct_6,c.gl_sub_acct_7,
          --DECODE(NVL(c.gslt_sl_type_cd,'0'),'6', TO_NUMBER(LTRIM(TO_CHAR(A.acct_line_cd,'00'))||
          --LTRIM(TO_CHAR(A.acct_subline_cd,'00'))|| LTRIM(TO_CHAR(e.peril_cd,'00'))),'3', e.intm_no, NULL) sl_cd, --comment out and replaced by codes below mikel 03.21.2016 AUII 5467
          DECODE (NVL (c.gslt_sl_type_cd, '0'),
                    '6',   (a.acct_line_cd * 100000)
                         + (a.acct_subline_cd * 1000)
                         + NVL (e.peril_cd, 0),

                    '3', e.intm_no,
                    NULL) sl_cd, --mikel 03.21.2016 AUII 5467
          DECODE(c.dr_cr_tag,'D',
          DECODE(A.pos_neg_inclusion,'P',
          DECODE(SIGN(commission_amt),1,commission_amt*currency_rt, 0),
          DECODE(SIGN(commission_amt),1,0,commission_amt*-1*currency_rt)),
          DECODE(A.pos_neg_inclusion,'P',
          DECODE(SIGN(commission_amt),1,0,commission_amt*-1*currency_rt),
          DECODE(SIGN(commission_amt),1,commission_amt*currency_rt, 0))) debit_amt,
          DECODE(c.dr_cr_tag,'C',
          DECODE(A.pos_neg_inclusion,'P',
          DECODE(SIGN(commission_amt),1,commission_amt*currency_rt,0),
          DECODE(SIGN(commission_amt),1,0,commission_amt*-1*currency_rt)),
          DECODE(A.pos_neg_inclusion,'P',
          DECODE(SIGN(commission_amt),1,0,commission_amt*-1*currency_rt),
          DECODE(SIGN(commission_amt),1,commission_amt*currency_rt, 0))) credit_amt,
          NULL generation_type,c.gslt_sl_type_cd sl_type_cd,1 sl_source_cd,
          b.user_id user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update,NULL remarks
    BULK COLLECT INTO vv_tran_id,vv_fund_cd,
                       vv_branch_cd,vv_acct_entry,vv_gl_id,vv_gl_categ,
                       vv_gl_cont,vv_gl_sub1,vv_gl_sub2,vv_gl_sub3,
                       vv_gl_sub4,vv_gl_sub5,vv_gl_sub6,vv_gl_sub7,
                       vv_sl_cd,
                       vv_debit_amt,
                       vv_credit_amt,
                       vv_gen_type,vv_sl_type_cd,vv_sl_src_cd,
                       vv_user_id,vv_last_upd,vv_remarks
    FROM GIAC_PRODUCTION_EXT A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c,GIPI_INVOICE d, GIAC_PARENT_COMM_INVPRL e
   WHERE A.iss_cd = b.gibr_branch_cd
     AND A.policy_id = d.policy_id
     AND d.iss_cd = e.iss_cd
     AND d.prem_seq_no = e.prem_seq_no
     AND b.tran_flag = 'C'
     AND b.tran_class = 'PRD'
     AND TRUNC(b.tran_date) = TRUNC(p_prod_date)
     AND NVL(commission_amt,0) != 0
     AND A.acct_line_cd = DECODE(p_line_dep , 0 , A.acct_line_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
     AND A.acct_intm_cd = DECODE(p_intm_dep , 0 , A.acct_intm_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
     AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE1_CREATE_PARENT_COMM');
END bae1_create_parent_comm;

PROCEDURE bae1_create_premiums
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_item_no   NUMBER) AS
    TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
    TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          A.iss_cd gacc_gibr_branch_cd, 1 acct_entry_id,
          c.gl_acct_id,c.gl_acct_category,c.gl_control_acct ,c.gl_sub_acct_1,
          c.gl_sub_acct_2,c.gl_sub_acct_3,c.gl_sub_acct_4,c.gl_sub_acct_5,
          c.gl_sub_acct_6,c.gl_sub_acct_7,
          --DECODE(NVL(c.gslt_sl_type_cd,'0'),'6', TO_NUMBER(LTRIM(TO_CHAR(A.acct_line_cd,'00'))||
          --LTRIM(TO_CHAR(A.acct_subline_cd,'00'))|| LTRIM(TO_CHAR(A.peril_cd,'00'))),
          --'1', A.assd_no, NULL) sl_cd, --comment out and replaced by codes below mikel 03.21.2016 AUII 5465 and 5467
          DECODE (NVL (c.gslt_sl_type_cd, '0'),
                    '6',   (a.acct_line_cd * 100000)
                         + (a.acct_subline_cd * 1000)
                         + NVL (a.peril_cd, 0),

                    '1', a.assd_no,
                    '3', a.intrmdry_intm_no,
                    NULL) sl_cd, --mikel 03.21.2016 AUII 5465 and 5467
          DECODE(c.dr_cr_tag,'D',
          DECODE(A.pos_neg_inclusion,'P',
          DECODE(SIGN(premium_amt),1,premium_amt/100, 0),
          DECODE(SIGN(premium_amt),1,0,premium_amt*-1/100)),
          DECODE(A.pos_neg_inclusion,'P',
          DECODE(SIGN(premium_amt),1,0,premium_amt*-1/100),
          DECODE(SIGN(premium_amt),1,premium_amt/100, 0))) debit_amt,
          DECODE(c.dr_cr_tag,'C',
          DECODE(A.pos_neg_inclusion,'P',
          DECODE(SIGN(premium_amt),1,premium_amt/100,0),
          DECODE(SIGN(premium_amt),1,0,premium_amt*-1/100)),
          DECODE(A.pos_neg_inclusion,'P',
          DECODE(SIGN(premium_amt),1,0,premium_amt*-1/100),
          DECODE(SIGN(premium_amt),1,premium_amt/100, 0))) credit_amt,
          NULL generation_type,c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd,
          b.user_id user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update,NULL remarks
     BULK COLLECT INTO vv_tran_id,vv_fund_cd,
                       vv_branch_cd,vv_acct_entry,vv_gl_id,vv_gl_categ,
                       vv_gl_cont,vv_gl_sub1,vv_gl_sub2,vv_gl_sub3,
                       vv_gl_sub4,vv_gl_sub5,vv_gl_sub6,vv_gl_sub7,
                       vv_sl_cd,
                       vv_debit_amt,
                       vv_credit_amt,
                       vv_gen_type,vv_sl_type_cd,vv_sl_src_cd,
                       vv_user_id,vv_last_upd,vv_remarks
     FROM giac_production_ext_dtl_v A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
    WHERE A.iss_cd = b.gibr_branch_cd
      AND b.tran_flag = 'C'
      AND b.tran_class = 'PRD'
      AND TRUNC(b.tran_date) = TRUNC(p_prod_date)
      AND NVL(premium_amt,0) != 0
      AND A.acct_line_cd = DECODE(p_line_dep, 0 , A.acct_line_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
      AND A.acct_intm_cd = DECODE(p_intm_dep, 0 , A.acct_intm_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
      AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE1_CREATE_PREMIUMS');
END bae1_create_premiums;

PROCEDURE bae1_create_prem_rec_gross
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_item_no   NUMBER) AS
    TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
    TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT DISTINCT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          A.iss_cd gacc_gibr_branch_cd, 1 acct_entry_id,c.gl_acct_id ,c.gl_acct_category ,
          c.gl_control_acct,c.gl_sub_acct_1,c.gl_sub_acct_2 ,c.gl_sub_acct_3,
          c.gl_sub_acct_4,c.gl_sub_acct_5,c.gl_sub_acct_6,c.gl_sub_acct_7,
          --DECODE(NVL(c.gslt_sl_type_cd,'0'),'6', TO_NUMBER(LTRIM(TO_CHAR(A.acct_line_cd,'00'))||    --comment out by Sam 05.13.2014
          --LTRIM(TO_CHAR(A.acct_subline_cd,'00'))|| LTRIM(TO_CHAR(A.peril_cd,'00'))), '1', A.assd_no, NULL) sl_cd,
          DECODE(NVL(c.gslt_sl_type_cd,'0'),
                '6', (a.acct_line_cd * 100000) + (a.acct_subline_cd * 1000) + NVL(a.peril_cd,0),
                '1', A.assd_no,
                '3', a.intrmdry_intm_no, NULL) sl_cd, --mikel 03.21.2016 AUII 5465; added 3 for intermediary
          DECODE(c.dr_cr_tag,'D',DECODE(A.pos_neg_inclusion,'P',
          DECODE(SIGN(prem_rec),1,prem_rec/100, 0),
          DECODE(SIGN(prem_rec),1,0,prem_rec*-1/100)),
          DECODE(A.pos_neg_inclusion,'P',
          DECODE(SIGN(prem_rec),1,0,prem_rec*-1/100),
          DECODE(SIGN(prem_rec),1,prem_rec/100, 0))) debit_amt,
          DECODE(c.dr_cr_tag,'C',DECODE(A.pos_neg_inclusion,'P',
          DECODE(SIGN(prem_rec),1,prem_rec/100,0),
          DECODE(SIGN(prem_rec),1,0,prem_rec*-1/100)),
          DECODE(A.pos_neg_inclusion,'P',
          DECODE(SIGN(prem_rec),1,0,prem_rec*-1/100),
          DECODE(SIGN(prem_rec),1,prem_rec/100, 0))) credit_amt,
          NULL generation_type,c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd,
          b.user_id user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update,
          TO_CHAR(policy_id) ||'-'||TO_CHAR(prem_seq_no)remarks
     BULK COLLECT INTO vv_tran_id,vv_fund_cd,
                       vv_branch_cd,vv_acct_entry,vv_gl_id,vv_gl_categ,
                       vv_gl_cont,vv_gl_sub1,vv_gl_sub2,vv_gl_sub3,
                       vv_gl_sub4,vv_gl_sub5,vv_gl_sub6,vv_gl_sub7,
                       vv_sl_cd,
                       vv_debit_amt,
                       vv_credit_amt,
                       vv_gen_type,vv_sl_type_cd,vv_sl_src_cd,
                       vv_user_id,vv_last_upd,vv_remarks
     FROM giac_production_ext_dtl_v A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
    WHERE A.iss_cd = b.gibr_branch_cd
      AND b.tran_flag = 'C'
      AND b.tran_class = 'PRD'
      AND TRUNC(b.tran_date) = TRUNC(p_prod_date)
      AND NVL(prem_rec,0) != 0
      AND A.acct_line_cd = DECODE(p_line_dep, 0 , A.acct_line_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
      AND A.acct_intm_cd = DECODE(p_intm_dep, 0 , A.acct_intm_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
      AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE1_CREATE_PREM_REC_GROSS');
END bae1_create_prem_rec_gross;

--added by mikel 06.15.2015; SR 4691 Wtax enhancements, BIR demo findings.
PROCEDURE bae1_create_wtax
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_item_no   NUMBER) AS
    TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
    TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    TYPE wholding_tax_tab IS TABLE OF GIAC_TAXES_WHELD.wholding_tax_amt%TYPE;
    TYPE commission_amt_tab IS TABLE OF GIAC_TAXES_WHELD.income_amt%TYPE;
    TYPE parent_intm_no_tab IS TABLE OF GIAC_TAXES_WHELD.payee_cd%TYPE;
    TYPE whtax_id_tab IS TABLE OF GIAC_TAXES_WHELD.gwtx_whtax_id%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
    vv_wholding_tax  wholding_tax_tab;
    vv_commission_amt commission_amt_tab;
    vv_parent_intm_no parent_intm_no_tab;
    vv_whtax_id whtax_id_tab;
    v_intm_class_cd VARCHAR2(5) := giacp.v('INTM_CLASS_CD');
        
BEGIN
 
    SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
           A.iss_cd gacc_gibr_branch_cd, 1 acct_entry_id,c.gl_acct_id,c.gl_acct_category,
           c.gl_control_acct ,c.gl_sub_acct_1,c.gl_sub_acct_2,c.gl_sub_acct_3,
           c.gl_sub_acct_4   ,c.gl_sub_acct_5,c.gl_sub_acct_6,c.gl_sub_acct_7,
          DECODE(NVL(c.gslt_sl_type_cd,'0'),'6', TO_NUMBER(LTRIM(TO_CHAR(A.acct_line_cd,'00'))||
            LTRIM(TO_CHAR(A.acct_subline_cd,'00'))||LTRIM(TO_CHAR(A.peril_cd,'00'))),'3',A.parent_intm_no, NULL) sl_cd,
           DECODE(c.dr_cr_tag,'D',
           DECODE(A.pos_neg_inclusion,'P',
           DECODE(SIGN(a.wholding_tax),1,a.wholding_tax/100, 0),
           DECODE(SIGN(a.wholding_tax),1,0,a.wholding_tax*-1/100)),
           DECODE(A.pos_neg_inclusion,'P',
           DECODE(SIGN(a.wholding_tax),1,0,a.wholding_tax*-1/100),
           DECODE(SIGN(a.wholding_tax),1,a.wholding_tax/100, 0))) debit_amt,
           DECODE(c.dr_cr_tag,'C',
           DECODE(A.pos_neg_inclusion,'P',
           DECODE(SIGN(a.wholding_tax),1,a.wholding_tax/100,0),
           DECODE(SIGN(a.wholding_tax),1,0,a.wholding_tax*-1/100)),
           DECODE(A.pos_neg_inclusion,'P',
           DECODE(SIGN(a.wholding_tax),1,0,a.wholding_tax*-1/100),
           DECODE(SIGN(a.wholding_tax),1,a.wholding_tax/100, 0))) credit_amt,
           NULL generation_type,c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd,
           b.user_id user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update,NULL remarks, 
           a.wholding_tax, a.commission_amt, A.parent_intm_no, d.whtax_id
      BULK COLLECT INTO vv_tran_id,vv_fund_cd,
                        vv_branch_cd,vv_acct_entry,vv_gl_id,vv_gl_categ,
                        vv_gl_cont,vv_gl_sub1,vv_gl_sub2,vv_gl_sub3,
                        vv_gl_sub4,vv_gl_sub5,vv_gl_sub6,vv_gl_sub7,
                        vv_sl_cd,
                        vv_debit_amt,
                        vv_credit_amt,
                        vv_gen_type,vv_sl_type_cd,vv_sl_src_cd,
                        vv_user_id,vv_last_upd,vv_remarks, 
                        vv_wholding_tax, vv_commission_amt,
                        vv_parent_intm_no, vv_whtax_id  
      FROM giac_production_ext_dtl_v A, GIAC_ACCTRANS b, giac_chart_of_accts c, gipi_comm_invoice d, giac_wholding_taxes e, gipi_polbasic f
     WHERE A.iss_cd = b.gibr_branch_cd
       AND b.tran_flag = 'C'
       AND b.tran_class = 'PRD'
       AND a.policy_id = f.policy_id
       AND a.policy_id = d.policy_id
       AND a.iss_cd = NVL (f.cred_branch, d.iss_cd)
       AND a.prem_seq_no = d.prem_seq_no
       AND a.intrmdry_intm_no = d.intrmdry_intm_no
       AND d.whtax_id = e.whtax_id
       AND c.gl_acct_id = e.gl_acct_id
       AND TRUNC(b.tran_date) = TRUNC(p_prod_date)
       AND NVL(a.wholding_tax,0) != 0;

  IF SQL%FOUND THEN
                   
    FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
      
      INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
      VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
  END IF;                                        
  COMMIT;

EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE1_CREATE_WTAX');
END bae1_create_wtax;                                  

PROCEDURE bae1_insert_taxes_wheld (p_prod_date DATE)
AS
   v_exists          VARCHAR2 (1);
   v_item_no         giac_taxes_wheld.item_no%TYPE;
   v_intm_class_cd   VARCHAR2 (5)                := giacp.v ('INTM_CLASS_CD');
   v_module_name     giac_modules.module_name%TYPE       := 'GIACB001';
   v_gen_type        giac_modules.generation_type%TYPE;
BEGIN
   BEGIN
      SELECT generation_type
        INTO v_gen_type
        FROM giac_modules
       WHERE module_name = v_module_name;
   END;

   FOR ins IN (SELECT   b.tran_id, a.parent_intm_no, d.whtax_id,
                        NULL generation_type,
                        SUM (a.wholding_tax) /100 wholding_tax,
                        SUM (a.commission_amt)/100 commission_amt
                   FROM giac_production_ext_dtl_v a,
                        giac_acctrans b,
                        giac_chart_of_accts c,
                        gipi_comm_invoice d,
                        giac_wholding_taxes e,
                        gipi_polbasic f
                  WHERE a.iss_cd = b.gibr_branch_cd
                    AND b.tran_flag = 'C'
                    AND b.tran_class = 'PRD'
                    AND a.policy_id = f.policy_id
                    AND a.policy_id = d.policy_id
                    AND a.iss_cd = NVL (f.cred_branch, d.iss_cd)
                    AND a.prem_seq_no = d.prem_seq_no
                    AND a.intrmdry_intm_no = d.intrmdry_intm_no
                    AND d.whtax_id = e.whtax_id
                    AND c.gl_acct_id = e.gl_acct_id
                    AND TRUNC (b.tran_date) = TRUNC (p_prod_date)
                    AND NVL (a.wholding_tax, 0) != 0
               GROUP BY b.tran_id, a.parent_intm_no, d.whtax_id)
   LOOP
      SELECT NVL (MAX (item_no), 0) item_no
        INTO v_item_no
        FROM giac_taxes_wheld
       WHERE gacc_tran_id = ins.tran_id;

      v_item_no := v_item_no + 1;

      INSERT INTO giac_taxes_wheld
                  (gacc_tran_id, gen_type, payee_class_cd, item_no,
                   gwtx_whtax_id, payee_cd, income_amt,
                   wholding_tax_amt,
                   remarks,
                   user_id, last_update
                  )
           VALUES (ins.tran_id, v_gen_type, v_intm_class_cd, v_item_no,
                   ins.whtax_id, ins.parent_intm_no, ins.commission_amt,
                   ins.wholding_tax,
                   'This is generated by the system after Batch Accounting Entry processing.',
                   NVL (giis_users_pkg.app_user, USER), SYSDATE
                  );
   END LOOP;

   COMMIT;
END;
    
PROCEDURE bae1_create_netcomm
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_item_no   NUMBER) AS
    TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
    TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
    

BEGIN
 
    SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
           A.iss_cd gacc_gibr_branch_cd, 1 acct_entry_id,c.gl_acct_id,c.gl_acct_category,
           c.gl_control_acct ,c.gl_sub_acct_1,c.gl_sub_acct_2,c.gl_sub_acct_3,
           c.gl_sub_acct_4   ,c.gl_sub_acct_5,c.gl_sub_acct_6,c.gl_sub_acct_7,
          DECODE(NVL(c.gslt_sl_type_cd,'0'),'6', TO_NUMBER(LTRIM(TO_CHAR(A.acct_line_cd,'00'))||
            LTRIM(TO_CHAR(A.acct_subline_cd,'00'))||LTRIM(TO_CHAR(A.peril_cd,'00'))),'3',A.parent_intm_no, NULL) sl_cd,
           DECODE(c.dr_cr_tag,'D',
           DECODE(A.pos_neg_inclusion,'P',
           DECODE(SIGN((commission_amt - wholding_tax)),1,(commission_amt - wholding_tax)/100, 0),
           DECODE(SIGN((commission_amt - wholding_tax)),1,0,(commission_amt - wholding_tax)*-1/100)),
           DECODE(A.pos_neg_inclusion,'P',
           DECODE(SIGN((commission_amt - wholding_tax)),1,0,(commission_amt - wholding_tax)*-1/100),
           DECODE(SIGN((commission_amt - wholding_tax)),1,(commission_amt - wholding_tax)/100, 0))) debit_amt,
           DECODE(c.dr_cr_tag,'C',
           DECODE(A.pos_neg_inclusion,'P',
           DECODE(SIGN((commission_amt - wholding_tax)),1,(commission_amt - wholding_tax)/100,0),
           DECODE(SIGN((commission_amt - wholding_tax)),1,0,(commission_amt - wholding_tax)*-1/100)),
           DECODE(A.pos_neg_inclusion,'P',
           DECODE(SIGN((commission_amt - wholding_tax)),1,0,(commission_amt - wholding_tax)*-1/100),
           DECODE(SIGN((commission_amt - wholding_tax)),1,(commission_amt - wholding_tax)/100, 0))) credit_amt,
           NULL generation_type,c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd,
           b.user_id user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update,NULL remarks
      BULK COLLECT INTO vv_tran_id,vv_fund_cd,
                        vv_branch_cd,vv_acct_entry,vv_gl_id,vv_gl_categ,
                        vv_gl_cont,vv_gl_sub1,vv_gl_sub2,vv_gl_sub3,
                        vv_gl_sub4,vv_gl_sub5,vv_gl_sub6,vv_gl_sub7,
                        vv_sl_cd,
                        vv_debit_amt,
                        vv_credit_amt,
                        vv_gen_type,vv_sl_type_cd,vv_sl_src_cd,
                        vv_user_id,vv_last_upd,vv_remarks
      FROM giac_production_ext_dtl_v A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
     WHERE A.iss_cd = b.gibr_branch_cd
       AND b.tran_flag = 'C'
       AND b.tran_class = 'PRD'
       AND TRUNC(b.tran_date) = TRUNC(p_prod_date)
       AND NVL(commission_amt,0) != 0
       AND A.acct_line_cd = DECODE( p_line_dep, 0 , A.acct_line_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
       AND A.acct_intm_cd = DECODE( p_intm_dep, 0 , A.acct_intm_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
       AND c.item_no = p_item_no;

  IF SQL%FOUND THEN
    FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
    
      INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
      VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
  END IF;
  COMMIT;

EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE1_CREATE_WTAX');
END bae1_create_netcomm;
--end mikel 06.15.2015

PROCEDURE bae2_copy_to_extract
   (p_prod_date DATE) AS
   TYPE cession_id_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.cession_id%TYPE;
   TYPE iss_cd_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.iss_cd%TYPE;
   TYPE policy_id_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.policy_id%TYPE;
   TYPE currency_cd_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.currency_cd%TYPE;
   TYPE currency_rt_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.currency_rt%TYPE;
   TYPE tk_up_type_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.tk_up_type%TYPE;
   TYPE item_no_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.item_no%TYPE;
   TYPE line_cd_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.line_cd%TYPE;
   TYPE acct_line_cd_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.acct_line_cd%TYPE;
   TYPE acct_subln_cd_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.acct_subline_cd%TYPE;
   TYPE share_cd_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.share_cd%TYPE;
   TYPE funds_held_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.funds_held%TYPE;
   TYPE premium_amt_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.premium_amt%TYPE;
   TYPE fc_prem_amt_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.fc_prem_amt%TYPE;
   TYPE commission_amt_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.commission_amt%TYPE;
   TYPE fc_comm_amt_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.fc_comm_amt%TYPE;
   TYPE tax_amt_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.tax_amt%TYPE;
   TYPE fc_tax_amt_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.fc_tax_amt%TYPE;
   TYPE trty_yy_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.trty_yy%TYPE;
   TYPE ri_cd_tab   IS TABLE OF GIAC_TREATY_BATCH_EXT.ri_cd%TYPE;
   TYPE peril_cd_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.peril_cd%TYPE;
   TYPE prem_vat_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.prem_vat%TYPE;--lina to handle vat on RI
   TYPE fc_prem_vat_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.fc_prem_vat%TYPE;--lina
   TYPE comm_vat_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.comm_vat%TYPE;--lina
   TYPE fc_comm_vat_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.fc_comm_vat%TYPE;--lina
   TYPE acct_intm_cd_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.acct_intm_cd%TYPE;
   TYPE acct_trty_type_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.acct_trty_type%TYPE;
   TYPE dist_no_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.dist_no%TYPE;
   TYPE due_to_ri_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.due_to_ri%TYPE;
   TYPE funds_held_amt_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.funds_held_amt%TYPE;
   TYPE ri_wholding_vat_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.ri_wholding_vat%TYPE;--lina to handle payments to be made on foreign RI
   TYPE fc_ri_wholding_vat_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.fc_ri_wholding_vat%TYPE;--lina to handle payments to be made on foreign RI
   TYPE local_foreign_sw_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.local_foreign_sw%TYPE;--lina
   TYPE prem_tax_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.prem_tax%TYPE;  ---judyann 07162008
   TYPE fc_prem_tax_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.fc_prem_tax%TYPE;  --judyann 07162008
   vv_cession_id  cession_id_tab;
   vv_iss_cd  iss_cd_tab;
   vv_policy_id  policy_id_tab;
   vv_currency_cd  currency_cd_tab;
   vv_currency_rt  currency_rt_tab;
   vv_tk_up_type  tk_up_type_tab;
   vv_item_no  item_no_tab;
   vv_line_cd  line_cd_tab;
   vv_acct_line_cd acct_line_cd_tab;
   vv_acct_subln_cd acct_subln_cd_tab;
   vv_share_cd  share_cd_tab;
   vv_funds_held  funds_held_tab;
   vv_premium_amt  premium_amt_tab;
   vv_fc_prem_amt  fc_prem_amt_tab;
   vv_commission_amt commission_amt_tab;
   vv_fc_comm_amt  fc_comm_amt_tab;
   vv_tax_amt  tax_amt_tab;
   vv_fc_tax_amt  fc_tax_amt_tab;
   vv_trty_yy  trty_yy_tab;
   vv_ri_cd   ri_cd_tab;
   vv_peril_cd  peril_cd_tab;
   vv_prem_vat   prem_vat_tab;--lina
   vv_fc_prem_vat   fc_prem_vat_tab;--lina
   vv_comm_vat   comm_vat_tab;--lina
   vv_fc_comm_vat  fc_comm_vat_tab;--lina
   vv_acct_intm_cd acct_intm_cd_tab;
   vv_acct_trty_type acct_trty_type_tab;
   vv_dist_no  dist_no_tab;
   vv_due_to_ri  due_to_ri_tab;
   vv_funds_held_amt funds_held_amt_tab;
   vv_ri_wholding_vat    ri_wholding_vat_tab;--lina
   vv_fc_ri_wholding_vat  fc_ri_wholding_vat_tab;--lina
   vv_local_foreign_sw     local_foreign_sw_tab;--lina
   vv_prem_tax    prem_tax_tab;  --judyann 07162008
   vv_fc_prem_tax  fc_prem_tax_tab;  --judyann 07162008
   v_trunc_table VARCHAR2(150);
   v_cession_id   GIAC_TREATY_BATCH_EXT.cession_id%TYPE;
BEGIN
   /*Truncate the extract table*/
   v_trunc_table := 'TRUNCATE TABLE CPI.GIAC_TREATY_BATCH_EXT DROP STORAGE';
   EXECUTE IMMEDIATE v_trunc_table;
   SELECT A.cession_id, A.iss_cd, A.policy_id, A.currency_cd, A.currency_rt, A.tk_up_type,
          A.item_no, A.line_cd, A.acct_line_cd, A.acct_subline_cd, A.share_cd, A.funds_held,
          DECODE(/*A.iss_cd*/A.POL_ISS_CD, 'RI', 5, b.acct_intm_cd) acct_intm_cd, A.acct_trty_type, A.dist_no, --modified by alfie 03152010
          A.premium_amt * 100 premium_amt, A.fc_prem_amt * 100 fc_prem_amt,
          A.commission_amt * 100 commission_amt, A.fc_comm_amt * 100 fc_comm_amt,
          A.tax_amt * 100 tax_amt, A.fc_tax_amt * 100 fc_tax_amt, A.trty_yy, A.ri_cd, A.peril_cd,
          A.prem_vat * 100 prem_vat, A.fc_prem_vat * 100 fc_prem_vat, --lina
          A.comm_vat * 100 comm_vat, A.fc_comm_vat * 100 fc_comm_vat, --lina
          A.ri_wholding_vat * 100 ri_wholding_vat,A.fc_ri_wholding_vat * 100 fc_ri_wholding_vat, --lina
          A.prem_tax, A.fc_prem_tax,  -- judyann 07162008
          (NVL(A.premium_amt,0) * (DECODE(NVL(A.funds_held,0),0,NVL(A.funds_held,0),NVL(A.funds_held,0)/100))) * 100 funds_held_amt,
          DECODE(Giacp.v('EXCLUDE_TRTY_VAT'),'Y',(((NVL(premium_amt,0) - NVL(commission_amt,0))
                                                  - (NVL(A.premium_amt,0) * (DECODE(NVL(A.funds_held,0),0,NVL(A.funds_held,0),NVL(A.funds_held,0)/100)))) * 100),
          ((((NVL(premium_amt,0)+ NVL(prem_vat,0) - NVL(prem_tax,0)) - (NVL(commission_amt,0) + NVL(comm_vat,0) + NVL(ri_wholding_vat,0)))
       - (NVL(A.premium_amt,0) * (DECODE(NVL(A.funds_held,0),0,NVL(A.funds_held,0),NVL(A.funds_held,0)/100)))) * 100)) due_to_ri, --lina
          a.local_Foreign_sw --lina
    BULK COLLECT INTO
          vv_cession_id,vv_iss_cd, vv_policy_id, vv_currency_cd, vv_currency_rt, vv_tk_up_type,
          vv_item_no, vv_line_cd, vv_acct_line_cd, vv_acct_subln_cd, vv_share_cd, vv_funds_held,
          vv_acct_intm_cd, vv_acct_trty_type, vv_dist_no,
          vv_premium_amt, vv_fc_prem_amt,
          vv_commission_amt, vv_fc_comm_amt,
          vv_tax_amt, vv_fc_tax_amt, vv_trty_yy, vv_ri_cd, vv_peril_cd,
          vv_prem_vat, vv_fc_prem_vat, --lina
          vv_comm_vat, vv_fc_comm_vat, --lina
          vv_ri_wholding_vat, vv_fc_ri_wholding_vat, --lina
       vv_prem_tax, vv_fc_prem_tax,  -- judyann 07162008
          vv_funds_held_amt,
          vv_due_to_ri,
    vv_local_foreign_sw --lina
     FROM giac_bae_giacb002_v A, giac_bae_pol_parent_intm_v b
    WHERE A.policy_id = b.policy_id(+)
   AND A.takeup_seq_no = B.takeup_seq_no --april 06102009
      AND TRUNC(acct_ent_date_pol) <= p_prod_date;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_cession_id.FIRST..vv_cession_id.LAST
         INSERT INTO GIAC_TREATY_BATCH_EXT(
            cession_id, iss_cd, policy_id, item_no, line_cd, acct_line_cd,
            acct_subline_cd, share_cd, trty_yy, ri_cd, peril_cd, currency_cd,
            currency_rt, tk_up_type, funds_held, premium_amt, fc_prem_amt,
            commission_amt, fc_comm_amt, tax_amt, fc_tax_amt, acct_intm_cd,
            acct_trty_type, dist_no, due_to_ri, funds_held_amt,
            prem_vat, fc_prem_vat, comm_vat, fc_comm_vat,
            ri_wholding_vat, fc_ri_wholding_vat,
   prem_tax, fc_prem_tax,
   local_foreign_sw)
         VALUES(
            vv_cession_id(mmb),vv_iss_cd(mmb),vv_policy_id(mmb),vv_item_no(mmb),vv_line_cd(mmb),vv_acct_line_cd(mmb),
            vv_acct_subln_cd(mmb),vv_share_cd(mmb),vv_trty_yy(mmb),vv_ri_cd(mmb),vv_peril_cd(mmb),vv_currency_cd(mmb),
            vv_currency_rt(mmb),vv_tk_up_type(mmb),vv_funds_held(mmb),vv_premium_amt(mmb),vv_fc_prem_amt(mmb),
            vv_commission_amt(mmb),vv_fc_comm_amt(mmb),vv_tax_amt(mmb),vv_fc_tax_amt(mmb),vv_acct_intm_cd(mmb),
            vv_acct_trty_type(mmb),vv_dist_no(mmb),vv_due_to_ri(mmb),vv_funds_held_amt(mmb),
            vv_prem_vat(mmb),vv_fc_prem_vat(mmb),vv_comm_vat(mmb),vv_fc_comm_vat(mmb),
            vv_ri_wholding_vat(mmb),vv_fc_ri_wholding_vat(mmb),
   vv_prem_tax(mmb),vv_fc_prem_tax(mmb),
   vv_local_foreign_sw(mmb));
   END IF;
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_COPY_TO_EXTRACT');
END bae2_copy_to_extract;

PROCEDURE bae2_copy_to_extract_reg
   (p_prod_date DATE) AS
   TYPE cession_id_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.cession_id%TYPE;
   TYPE iss_cd_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.iss_cd%TYPE;
   TYPE policy_id_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.policy_id%TYPE;
   TYPE currency_cd_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.currency_cd%TYPE;
   TYPE currency_rt_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.currency_rt%TYPE;
   TYPE tk_up_type_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.tk_up_type%TYPE;
   TYPE item_no_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.item_no%TYPE;
   TYPE line_cd_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.line_cd%TYPE;
   TYPE acct_line_cd_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.acct_line_cd%TYPE;
   TYPE acct_subln_cd_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.acct_subline_cd%TYPE;
   TYPE share_cd_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.share_cd%TYPE;
   TYPE funds_held_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.funds_held%TYPE;
   TYPE premium_amt_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.premium_amt%TYPE;
   TYPE fc_prem_amt_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.fc_prem_amt%TYPE;
   TYPE commission_amt_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.commission_amt%TYPE;
   TYPE fc_comm_amt_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.fc_comm_amt%TYPE;
   TYPE tax_amt_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.tax_amt%TYPE;
   TYPE fc_tax_amt_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.fc_tax_amt%TYPE;
   TYPE trty_yy_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.trty_yy%TYPE;
   TYPE ri_cd_tab   IS TABLE OF GIAC_TREATY_BATCH_EXT.ri_cd%TYPE;
   TYPE peril_cd_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.peril_cd%TYPE;
   TYPE prem_vat_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.prem_vat%TYPE;--lina
   TYPE fc_prem_vat_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.fc_prem_vat%TYPE;--lina
   TYPE comm_vat_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.comm_vat%TYPE;--lina
   TYPE fc_comm_vat_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.fc_comm_vat%TYPE;--lina
   TYPE acct_intm_cd_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.acct_intm_cd%TYPE;
   TYPE acct_trty_type_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.acct_trty_type%TYPE;
   TYPE dist_no_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.dist_no%TYPE;
   TYPE due_to_ri_tab  IS TABLE OF GIAC_TREATY_BATCH_EXT.due_to_ri%TYPE;
   TYPE funds_held_amt_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.funds_held_amt%TYPE;
   TYPE ri_wholding_vat_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.ri_wholding_vat%TYPE;--lina
   TYPE fc_ri_wholding_vat_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.fc_ri_wholding_vat%TYPE;--lina
   TYPE local_foreign_sw_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.local_foreign_sw%TYPE;--lina
   TYPE prem_tax_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.prem_tax%TYPE;  --judyann 07162008
   TYPE fc_prem_tax_tab IS TABLE OF GIAC_TREATY_BATCH_EXT.fc_prem_tax%TYPE;  --judyann 07162008
   vv_cession_id  cession_id_tab;
   vv_iss_cd  iss_cd_tab;
   vv_policy_id  policy_id_tab;
   vv_currency_cd  currency_cd_tab;
   vv_currency_rt  currency_rt_tab;
   vv_tk_up_type  tk_up_type_tab;
   vv_item_no  item_no_tab;
   vv_line_cd  line_cd_tab;
   vv_acct_line_cd acct_line_cd_tab;
   vv_acct_subln_cd acct_subln_cd_tab;
   vv_share_cd  share_cd_tab;
   vv_funds_held  funds_held_tab;
   vv_premium_amt  premium_amt_tab;
   vv_fc_prem_amt  fc_prem_amt_tab;
   vv_commission_amt commission_amt_tab;
   vv_fc_comm_amt  fc_comm_amt_tab;
   vv_tax_amt  tax_amt_tab;
   vv_fc_tax_amt  fc_tax_amt_tab;
   vv_trty_yy  trty_yy_tab;
   vv_ri_cd   ri_cd_tab;
   vv_peril_cd  peril_cd_tab;
   vv_prem_vat   prem_vat_tab;--lina
   vv_fc_prem_vat  fc_prem_vat_tab;--lina
   vv_comm_vat   comm_vat_tab;--lina
   vv_fc_comm_vat  fc_comm_vat_tab;--lina
   vv_acct_intm_cd acct_intm_cd_tab;
   vv_acct_trty_type acct_trty_type_tab;
   vv_dist_no  dist_no_tab;
   vv_due_to_ri  due_to_ri_tab;
   vv_funds_held_amt funds_held_amt_tab;
   vv_ri_wholding_vat   ri_wholding_vat_tab;--lina
   vv_fc_ri_wholding_vat   fc_ri_wholding_vat_tab;--lina
   vv_local_foreign_sw   local_foreign_sw_tab;--lina
   vv_prem_tax    prem_tax_tab;  --judyann 07162008
   vv_fc_prem_tax  fc_prem_tax_tab;  --judyann 07162008
   v_trunc_table VARCHAR2(150);
   v_cession_id   GIAC_TREATY_BATCH_EXT.cession_id%TYPE;
BEGIN
   /*Truncate the extract table*/
   v_trunc_table := 'TRUNCATE TABLE CPI.GIAC_TREATY_BATCH_EXT DROP STORAGE';
   EXECUTE IMMEDIATE v_trunc_table;
   SELECT A.cession_id, A.iss_cd, A.policy_id, A.currency_cd, A.currency_rt, A.tk_up_type,
          A.item_no, A.line_cd, A.acct_line_cd, A.acct_subline_cd, A.share_cd, A.funds_held,
          DECODE(/*A.iss_cd*/ a.pol_iss_cd, 'RI', 5, b.acct_intm_cd) acct_intm_cd, A.acct_trty_type, A.dist_no, --modified by alfie a.iss_cd to pol_iss_cd 03152010
          A.premium_amt*NVL(B.share_percentage,1) * 100 premium_amt, A.fc_prem_amt*NVL(B.share_percentage,1) * 100 fc_prem_amt,
          A.commission_amt*NVL(B.share_percentage,1) * 100 commission_amt, A.fc_comm_amt*NVL(B.share_percentage,1) * 100 fc_comm_amt,
          A.tax_amt*NVL(B.share_percentage,1) * 100 tax_amt, A.fc_tax_amt*NVL(B.share_percentage,1) * 100 fc_tax_amt, A.trty_yy, A.ri_cd, A.peril_cd,
          A.prem_vat*NVL(B.share_percentage,1) * 100 prem_vat, A.fc_prem_vat*NVL(B.share_percentage,1) * 100 fc_prem_vat, --lina
          A.comm_vat*NVL(B.share_percentage,1) * 100 comm_vat, A.fc_comm_vat*NVL(B.share_percentage,1) * 100 fc_comm_vat, --lina
          A.ri_wholding_vat*NVL(B.share_percentage,1) * 100 ri_wholding_vat,A.fc_ri_wholding_vat*NVL(B.share_percentage,1) * 100 fc_ri_wholding_vat, --lina
          A.prem_tax*NVL(B.share_percentage,1) prem_tax, A.fc_prem_tax*NVL(B.share_percentage,1) fc_prem_tax,  -- judyann 07162008
          (NVL(A.premium_amt,0) * (DECODE(NVL(A.funds_held,0),0,NVL(A.funds_held,0),NVL(A.funds_held,0)/100)))*NVL(B.share_percentage,1) * 100 funds_held_amt,
          DECODE(Giacp.v('EXCLUDE_TRTY_VAT'),'Y',(((NVL(premium_amt,0) - NVL(commission_amt,0))
                                                  - (NVL(A.premium_amt,0) * (DECODE(NVL(A.funds_held,0),0,NVL(A.funds_held,0),NVL(A.funds_held,0)/100)))) * 100),
          ((((NVL(premium_amt,0)+ NVL(prem_vat,0) - NVL(prem_tax,0)) - (NVL(commission_amt,0) + NVL(comm_vat,0) + NVL(ri_wholding_vat,0)))
       - (NVL(A.premium_amt,0) * (DECODE(NVL(A.funds_held,0),0,NVL(A.funds_held,0),NVL(A.funds_held,0)/100))))*NVL(B.share_percentage,1) * 100)) due_to_ri, --lina
    a.local_Foreign_sw --lina       -- added *nvl(B.share_percentage,1) to amounts adrel 08282009
   BULK COLLECT INTO
         vv_cession_id,vv_iss_cd, vv_policy_id, vv_currency_cd, vv_currency_rt, vv_tk_up_type,
         vv_item_no, vv_line_cd, vv_acct_line_cd, vv_acct_subln_cd, vv_share_cd, vv_funds_held,
         vv_acct_intm_cd, vv_acct_trty_type, vv_dist_no,
         vv_premium_amt, vv_fc_prem_amt,
         vv_commission_amt, vv_fc_comm_amt,
         vv_tax_amt, vv_fc_tax_amt, vv_trty_yy, vv_ri_cd, vv_peril_cd,
         vv_prem_vat, vv_fc_prem_vat, --lina
         vv_comm_vat, vv_fc_comm_vat, --lina
         vv_ri_wholding_vat, vv_fc_ri_wholding_vat, --lina
      vv_prem_tax, vv_fc_prem_tax,  -- judyann 07182008
         vv_funds_held_amt,
         vv_due_to_ri,
         vv_local_foreign_sw --lina
   FROM giac_bae_giacb002_v A, giac_bae_pol_parent_intm_v b
  WHERE A.policy_id = b.policy_id(+)
   AND A.takeup_seq_no = B.takeup_seq_no(+) --april 06102009
    AND A.reg_policy_sw = 'Y'
    AND TRUNC(acct_ent_date_pol) <= p_prod_date;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_cession_id.FIRST..vv_cession_id.LAST
         INSERT INTO GIAC_TREATY_BATCH_EXT(
            cession_id, iss_cd, policy_id, item_no, line_cd, acct_line_cd,
            acct_subline_cd, share_cd, trty_yy, ri_cd, peril_cd, currency_cd,
            currency_rt, tk_up_type, funds_held, premium_amt, fc_prem_amt,
            commission_amt, fc_comm_amt, tax_amt, fc_tax_amt, acct_intm_cd,
            acct_trty_type, dist_no, due_to_ri, funds_held_amt,
            prem_vat, fc_prem_vat, comm_vat, fc_comm_vat,
            ri_wholding_vat, fc_ri_wholding_vat,
   prem_tax, fc_prem_tax,
   local_foreign_sw)
         VALUES(
            vv_cession_id(mmb),vv_iss_cd(mmb),vv_policy_id(mmb),vv_item_no(mmb),vv_line_cd(mmb),vv_acct_line_cd(mmb),
            vv_acct_subln_cd(mmb),vv_share_cd(mmb),vv_trty_yy(mmb),vv_ri_cd(mmb),vv_peril_cd(mmb),vv_currency_cd(mmb),
            vv_currency_rt(mmb),vv_tk_up_type(mmb),vv_funds_held(mmb),vv_premium_amt(mmb),vv_fc_prem_amt(mmb),
            vv_commission_amt(mmb),vv_fc_comm_amt(mmb),vv_tax_amt(mmb),vv_fc_tax_amt(mmb),vv_acct_intm_cd(mmb),
            vv_acct_trty_type(mmb),vv_dist_no(mmb),vv_due_to_ri(mmb),vv_funds_held_amt(mmb),
            vv_prem_vat(mmb), vv_fc_prem_vat(mmb),vv_comm_vat(mmb),vv_fc_comm_vat(mmb),
            vv_ri_wholding_vat(mmb),vv_fc_ri_wholding_vat(mmb),
      vv_prem_tax(mmb),vv_fc_prem_tax(mmb),
   vv_local_foreign_sw(mmb));
   END IF;
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_COPY_TO_EXTRACT_REG');
END bae2_copy_to_extract_reg;

PROCEDURE bae2_copy_to_gtc
   (p_prod_date DATE) AS
   TYPE cession_id_tab  IS TABLE OF GIAC_TREATY_CESSIONS.cession_id%TYPE;
   TYPE cession_year_tab IS TABLE OF GIAC_TREATY_CESSIONS.cession_year%TYPE;
   TYPE cession_mm_tab  IS TABLE OF GIAC_TREATY_CESSIONS.cession_mm%TYPE;
   TYPE line_cd_tab  IS TABLE OF GIAC_TREATY_CESSIONS.line_cd%TYPE;
   TYPE treaty_yy_tab  IS TABLE OF GIAC_TREATY_CESSIONS.treaty_yy%TYPE;
   TYPE share_cd_tab  IS TABLE OF GIAC_TREATY_CESSIONS.share_cd%TYPE;
   TYPE ri_cd_tab   IS TABLE OF GIAC_TREATY_CESSIONS.ri_cd%TYPE;
   TYPE policy_id_tab  IS TABLE OF GIAC_TREATY_CESSIONS.policy_id%TYPE;
   TYPE item_no_tab  IS TABLE OF GIAC_TREATY_CESSIONS.item_no%TYPE;
   TYPE premium_amt_tab  IS TABLE OF GIAC_TREATY_CESSIONS.premium_amt%TYPE;
   TYPE prem_vat_tab  IS TABLE OF GIAC_TREATY_CESSIONS.prem_vat%TYPE;--LINA
   TYPE commission_amt_tab IS TABLE OF GIAC_TREATY_CESSIONS.commission_amt%TYPE;
   TYPE comm_vat_tab  IS TABLE OF GIAC_TREATY_CESSIONS.comm_vat%TYPE;--LINA
   TYPE tax_amt_tab  IS TABLE OF GIAC_TREATY_CESSIONS.tax_amt%TYPE;
   TYPE currency_cd_tab  IS TABLE OF GIAC_TREATY_CESSIONS.currency_cd%TYPE;
   TYPE fc_prem_amt_tab  IS TABLE OF GIAC_TREATY_CESSIONS.fc_prem_amt%TYPE;
   TYPE fc_prem_vat_tab  IS TABLE OF GIAC_TREATY_CESSIONS.fc_prem_vat%TYPE;--LINA
   TYPE fc_comm_amt_tab  IS TABLE OF GIAC_TREATY_CESSIONS.fc_comm_amt%TYPE;
   TYPE fc_comm_vat_tab  IS TABLE OF GIAC_TREATY_CESSIONS.fc_comm_vat%TYPE;--LINA
   TYPE fc_tax_amt_tab  IS TABLE OF GIAC_TREATY_CESSIONS.fc_tax_amt%TYPE;
   TYPE take_up_type_tab IS TABLE OF GIAC_TREATY_CESSIONS.take_up_type%TYPE;
   TYPE branch_cd_tab  IS TABLE OF GIAC_TREATY_CESSIONS.branch_cd%TYPE;
   TYPE gacc_tran_id_tab IS TABLE OF GIAC_TREATY_CESSIONS.gacc_tran_id%TYPE;
   TYPE cpi_rec_no_tab  IS TABLE OF GIAC_TREATY_CESSIONS.cpi_rec_no%TYPE;
   TYPE cpi_branch_cd_tab IS TABLE OF GIAC_TREATY_CESSIONS.cpi_branch_cd%TYPE;
   TYPE acct_ent_date_tab IS TABLE OF VARCHAR2(20);
   TYPE dist_no_tab  IS TABLE OF GIAC_TREATY_CESSIONS.dist_no%TYPE;
   TYPE ri_wholding_vat_tab  IS TABLE OF GIAC_TREATY_CESSIONS.ri_wholding_vat%TYPE;
   TYPE fc_ri_wholding_vat_tab  IS TABLE OF GIAC_TREATY_CESSIONS.fc_ri_wholding_vat%TYPE;
   TYPE local_foreign_sw_tab  IS TABLE OF GIAC_TREATY_CESSIONS.local_foreign_sw%TYPE;
   vv_cession_id  cession_id_tab;
   vv_cession_year cession_year_tab;
   vv_cession_mm  cession_mm_tab;
   vv_line_cd  line_cd_tab;
   vv_treaty_yy  treaty_yy_tab;
   vv_share_cd  share_cd_tab;
   vv_ri_cd   ri_cd_tab;
   vv_policy_id  policy_id_tab;
   vv_item_no  item_no_tab;
   vv_premium_amt  premium_amt_tab;
   vv_commission_amt commission_amt_tab;
   vv_tax_amt  tax_amt_tab;
   vv_currency_cd  currency_cd_tab;
   vv_fc_prem_amt  fc_prem_amt_tab;
   vv_fc_comm_amt  fc_comm_amt_tab;
   vv_fc_tax_amt  fc_tax_amt_tab;
   vv_take_up_type take_up_type_tab;
   vv_branch_cd  branch_cd_tab;
   vv_gacc_tran_id gacc_tran_id_tab;
   vv_cpi_rec_no  cpi_rec_no_tab;
   vv_cpi_branch_cd cpi_branch_cd_tab;
   vv_acct_ent_date acct_ent_date_tab;
   vv_dist_no  dist_no_tab;
   vv_prem_vat  prem_vat_tab;--lina
   vv_comm_vat  comm_vat_tab;--lina
   vv_fc_prem_vat fc_prem_vat_tab;--lina
   vv_fc_comm_vat   fc_comm_vat_tab;--lina
   vv_ri_wholding_vat  ri_wholding_vat_tab;--lina
   vv_local_foreign_sw   local_foreign_sw_tab;--lina
   vv_fc_ri_wholding_vat   fc_ri_wholding_vat_tab;--lina
   v_cess_year NUMBER(4);
   v_cess_mm   NUMBER(2);
BEGIN
   /*Set the cession year and the cession month*/
   v_cess_year := TO_NUMBER(TO_CHAR(p_prod_date,'YYYY'),9999);
   v_cess_mm   := TO_NUMBER(TO_CHAR(p_prod_date,'MM'),99);
   SELECT A.cession_id, v_cess_year cession_year, v_cess_mm cession_mm, line_cd, trty_yy treaty_yy,
          share_cd, ri_cd, policy_id, item_no,
          SUM(DECODE(A.tk_up_type,'N',premium_amt*-1/100,premium_amt/100)) premium_amt,
          SUM(DECODE(A.tk_up_type,'N',prem_vat*-1/100,premium_amt/100)) prem_vat,--lina
          SUM(DECODE(A.tk_up_type,'N',commission_amt*-1/100, commission_amt/100)) commission_amt,
          SUM(DECODE(A.tk_up_type,'N',comm_vat*-1/100, comm_vat/100)) comm_vat,--lina
          0 tax_amt, currency_cd,
          SUM(DECODE(A.tk_up_type,'N',fc_prem_amt*-1/100,fc_prem_amt/100)) fc_prem_amt,
          SUM(DECODE(A.tk_up_type,'N',fc_prem_vat*-1/100,fc_prem_vat/100)) fc_prem_vat,
          SUM(DECODE(A.tk_up_type,'N',fc_comm_amt*-1/100,fc_comm_amt/100)) fc_comm_amt,
          SUM(DECODE(A.tk_up_type,'N',fc_comm_vat*-1/100,fc_comm_vat/100)) fc_comm_vat,
          0 fc_tax_amt, A.tk_up_type take_up_type, A.iss_cd branch_cd,  b.tran_id gacc_tran_id,
          0 cpi_rec_no, 'HO' cpi_branch_cd,
          TO_CHAR(b.tran_date,'MM-DD-YYYY') acct_ent_date, A.dist_no,
          SUM(DECODE(A.tk_up_type,'N',ri_wholding_vat*-1/100,ri_wholding_vat/100)) ri_wholding_vat,
          SUM(DECODE(A.tk_up_type,'N',fc_ri_wholding_vat*-1/100,fc_ri_wholding_vat/100))fc_ri_wholding_vat,
          a.local_foreign_sw
     BULK COLLECT INTO
          vv_cession_id,vv_cession_year,vv_cession_mm,vv_line_cd,vv_treaty_yy,
          vv_share_cd,vv_ri_cd,vv_policy_id,vv_item_no,
          vv_premium_amt,
          vv_prem_vat,--lina
          vv_commission_amt,
          vv_comm_vat,--lina
          vv_tax_amt,vv_currency_cd,
          vv_fc_prem_amt,
          vv_fc_prem_vat,--lina
          vv_fc_comm_amt,
          vv_fc_comm_vat,--lina
          vv_fc_tax_amt,vv_take_up_type,vv_branch_cd,vv_gacc_tran_id,
          vv_cpi_rec_no,vv_cpi_branch_cd,
          vv_acct_ent_date,vv_dist_no,
          vv_ri_wholding_vat,
          vv_fc_ri_wholding_vat,
          vv_local_foreign_sw
     FROM GIAC_TREATY_BATCH_EXT A, GIAC_ACCTRANS  b
    WHERE A.iss_cd = b.gibr_branch_cd
      AND b.tran_flag = 'C'
      AND b.tran_class = 'UW'
      AND TRUNC(b.tran_date) = p_prod_date
    GROUP BY A.cession_id, A.line_cd, A.trty_yy,
             A.share_cd, A.ri_cd, A.policy_id, A.item_no,
             A.currency_cd, A.tk_up_type ,A.iss_cd, b.tran_id, A.dist_no , b.tran_date,A.local_foreign_sw;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_cession_id.FIRST..vv_cession_id.LAST
         INSERT INTO GIAC_TREATY_CESSIONS(
            cession_id,cession_year,cession_mm,line_cd,treaty_yy,
            share_cd,ri_cd,policy_id,item_no,
            premium_amt,commission_amt,tax_amt,currency_cd,
            fc_prem_amt,fc_comm_amt,fc_tax_amt,take_up_type,
            branch_cd,gacc_tran_id,cpi_rec_no,
            cpi_branch_cd,acct_ent_date,dist_no,
            prem_vat, comm_vat, fc_prem_vat, fc_comm_vat,
            ri_wholding_vat, fc_ri_wholding_vat, local_foreign_sw)
         VALUES(
            vv_cession_id(mmb),vv_cession_year(mmb),vv_cession_mm(mmb),vv_line_cd(mmb),vv_treaty_yy(mmb),
            vv_share_cd(mmb),vv_ri_cd(mmb),vv_policy_id(mmb),vv_item_no(mmb),
            vv_premium_amt(mmb),vv_commission_amt(mmb),vv_tax_amt(mmb),vv_currency_cd(mmb),
            vv_fc_prem_amt(mmb),vv_fc_comm_amt(mmb),vv_fc_tax_amt(mmb),vv_take_up_type(mmb),
            vv_branch_cd(mmb),vv_gacc_tran_id(mmb),vv_cpi_rec_no(mmb),
            vv_cpi_branch_cd(mmb),TO_DATE(vv_acct_ent_date(mmb),'MM-DD-YYYY'),vv_dist_no(mmb),
            vv_prem_vat (mmb), vv_comm_vat (mmb), vv_fc_prem_vat (mmb), vv_fc_comm_vat(mmb),
            vv_ri_wholding_vat(mmb),vv_fc_ri_wholding_vat(mmb), vv_local_foreign_sw(mmb));
   END IF;
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_COPY_TO_GTC');
END bae2_copy_to_gtc;

PROCEDURE bae2_copy_to_gtcd
   (p_prod_date DATE) AS
   TYPE cession_id_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.cession_id%TYPE;
   TYPE peril_cd_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.peril_cd%TYPE;
   TYPE premium_amt_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.premium_amt%TYPE;
   TYPE commission_amt_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.commission_amt%TYPE;
   TYPE tax_amt_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.tax_amt%TYPE;
   TYPE currency_cd_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.currency_cd%TYPE;
   TYPE fc_prem_amt_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.fc_prem_amt%TYPE;
   TYPE fc_comm_amt_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.fc_comm_amt%TYPE;
   TYPE fc_tax_amt_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.fc_tax_amt%TYPE;
   TYPE cpi_rec_no_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.cpi_rec_no%TYPE;
   TYPE cpi_branch_cd_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.cpi_branch_cd%TYPE;
   TYPE prem_vat_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.prem_vat%TYPE;
   TYPE comm_vat_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.comm_vat%TYPE;
   TYPE fc_prem_vat_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.fc_prem_vat%TYPE;
   TYPE fc_comm_vat_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.fc_comm_vat%TYPE;
   TYPE ri_wholding_vat_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.ri_wholding_vat%TYPE;
   TYPE fc_ri_wholding_vat_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.fc_ri_wholding_vat%TYPE;
   TYPE local_foreign_sw_tab IS TABLE OF GIAC_TREATY_CESSION_DTL.local_foreign_sw%TYPE;
   TYPE acct_ent_date_tab IS TABLE OF VARCHAR2(20);
   vv_cession_id  cession_id_tab;
   vv_peril_cd  peril_cd_tab;
   vv_premium_amt  premium_amt_tab;
   vv_commission_amt commission_amt_tab;
   vv_tax_amt  tax_amt_tab;
   vv_currency_cd  currency_cd_tab;
   vv_fc_prem_amt  fc_prem_amt_tab;
   vv_fc_comm_amt  fc_comm_amt_tab;
   vv_fc_tax_amt  fc_tax_amt_tab;
   vv_cpi_rec_no  cpi_rec_no_tab;
   vv_cpi_branch_cd cpi_branch_cd_tab;
   vv_prem_vat   prem_vat_tab;--lina
   vv_comm_vat   comm_vat_tab;--lina
   vv_fc_prem_vat       fc_prem_vat_tab;--lina
   vv_fc_comm_vat   fc_comm_vat_tab;--lina
   vv_ri_wholding_vat    ri_wholding_vat_tab;--lina
   vv_fc_ri_wholding_vat  fc_ri_wholding_vat_tab;--lina
   vv_local_foreign_sw   local_foreign_sw_tab;--lina
   vv_acct_ent_date acct_ent_date_tab;
BEGIN
   /*The order by clause was removed mike 04042002
   **Because it causes an error on the procedure
   **when it is compiled
   */
   SELECT cession_id, peril_cd, SUM(DECODE(tk_up_type,'N',premium_amt*-1/100,premium_amt/100)) premium_amt,
          SUM(DECODE(tk_up_type,'N',prem_vat*-1/100,prem_vat/100)) prem_vat,--lina
          SUM(DECODE(tk_up_type,'N',commission_amt*-1/100, commission_amt/100)) commission_amt,
          SUM(DECODE(tk_up_type,'N',comm_vat*-1/100, comm_vat/100)) comm_vat,--lina
          0 tax_amt, currency_cd,
          SUM(DECODE(tk_up_type,'N',fc_prem_amt*-1/100, fc_prem_amt/100)) fc_prem_amt,
          SUM(DECODE(tk_up_type,'N',fc_prem_vat*-1/100, fc_prem_vat/100)) fc_prem_vat,--lina
          SUM(DECODE(tk_up_type,'N',fc_comm_amt*-1/100, fc_comm_amt/100)) fc_comm_amt,
          SUM(DECODE(tk_up_type,'N',fc_comm_vat*-1/100, fc_comm_vat/100)) fc_comm_vat,--lina
          0 fc_tax_amt,
          0 cpi_rec_no, 'HO' cpi_branch_cd,
          TO_CHAR(p_prod_date,'MM-DD-YYYY') "ACCT_ENT_DATE",
          SUM(DECODE(tk_up_type,'N',ri_wholding_vat*-1/100,ri_wholding_vat/100)) ri_wholding_vat,
          SUM(DECODE(tk_up_type,'N',fc_ri_wholding_vat*-1/100,fc_ri_wholding_vat/100)) fc_ri_wholding_vat,
          local_foreign_sw
     BULK COLLECT INTO
          vv_cession_id, vv_peril_cd, vv_premium_amt,
          vv_prem_vat, vv_commission_amt,vv_comm_vat,
          vv_tax_amt, vv_currency_cd,vv_fc_prem_amt,
          vv_fc_prem_vat, vv_fc_comm_amt,vv_fc_comm_vat,
          vv_fc_tax_amt,vv_cpi_rec_no, vv_cpi_branch_cd,
          vv_acct_ent_date,
          vv_ri_wholding_vat, vv_fc_ri_wholding_vat, vv_local_foreign_sw
     FROM GIAC_TREATY_BATCH_EXT
  GROUP BY cession_id, peril_cd, currency_cd, local_foreign_sw;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_cession_id.FIRST..vv_cession_id.LAST
         INSERT INTO GIAC_TREATY_CESSION_DTL(
            cession_id,peril_cd,premium_amt,commission_amt,
            tax_amt,currency_cd,fc_prem_amt,fc_comm_amt,
            fc_tax_amt,cpi_rec_no,cpi_branch_cd,acct_ent_date,
            prem_vat, comm_vat, fc_prem_vat, fc_comm_vat,
            ri_wholding_vat,fc_ri_wholding_vat, local_foreign_sw)
         VALUES(
            vv_cession_id(mmb),vv_peril_cd(mmb),vv_premium_amt(mmb),vv_commission_amt(mmb),
            vv_tax_amt(mmb),vv_currency_cd(mmb),vv_fc_prem_amt(mmb),vv_fc_comm_amt(mmb),
            vv_fc_tax_amt(mmb),vv_cpi_rec_no(mmb),vv_cpi_branch_cd(mmb),
            TO_DATE(vv_acct_ent_date(mmb),'MM-DD-YYYY'),
            vv_prem_vat (mmb), vv_comm_vat(mmb), vv_fc_prem_vat(mmb), vv_fc_comm_vat(mmb),
            vv_ri_wholding_vat(mmb), vv_fc_ri_wholding_vat(mmb), vv_local_foreign_sw(mmb));
   END IF;
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_COPY_TO_GTCD');
END bae2_copy_to_gtcd;

PROCEDURE bae2_create_prem_ceded_proc
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_trty_type NUMBER,
    p_item_no   NUMBER) AS
   TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
   TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          b.gibr_branch_cd gacc_gibr_branch_cd, 1 acct_entry_id,
          c.gl_acct_id  , c.gl_acct_category ,c.gl_control_acct , c.gl_sub_acct_1,
          c.gl_sub_acct_2 , c.gl_sub_acct_3  ,c.gl_sub_acct_4 , c.gl_sub_acct_5  ,
          c.gl_sub_acct_6 , c.gl_sub_acct_7  ,
          /*TO_NUMBER(DECODE(c.gslt_sl_type_cd, 6, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||
          TO_CHAR(A.peril_cd,'FM00'),
          5, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||'00',
          2, TO_CHAR(A.ri_cd,'FM000000'), NULL )) sl_cd,*/ --comment out and replaced by codes below mikel 03.21.2016 AUII 5467
           TO_NUMBER (
                DECODE (
                   c.gslt_sl_type_cd,
                   6,   (a.acct_line_cd * 100000)
                      + (a.acct_subline_cd * 1000)
                      + NVL (a.peril_cd, 0),
                   5,    TO_CHAR (a.acct_line_cd, 'FM00')
                      || TO_CHAR (a.acct_subline_cd, 'FM00')
                      || '00',
                   2, TO_CHAR (a.ri_cd, 'FM000000'),
                   NULL)) sl_cd, --mikel 03.21.2016 AUII 5467
          DECODE(c.dr_cr_tag,'D',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.premium_amt),1,A.premium_amt /100, 0),
          DECODE(SIGN(A.premium_amt),1,0,A.premium_amt *-1/100)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.premium_amt),1,0,A.premium_amt *-1/100),
          DECODE(SIGN(A.premium_amt),1,A.premium_amt/100, 0))) debit_amt,
          DECODE(c.dr_cr_tag,'C',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.premium_amt),1,A.premium_amt/100,0),
          DECODE(SIGN(A.premium_amt),1,0,A.premium_amt*-1/100)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.premium_amt),1,0,A.premium_amt*-1/100),
          DECODE(SIGN(A.premium_amt),1,A.premium_amt/100, 0))) credit_amt,
          NULL generation_type, c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd ,
          b.user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update, NULL remarks
     BULK COLLECT INTO
          vv_tran_id, vv_fund_cd,
          vv_branch_cd, vv_acct_entry,
          vv_gl_id, vv_gl_categ, vv_gl_cont, vv_gl_sub1,
          vv_gl_sub2, vv_gl_sub3, vv_gl_sub4, vv_gl_sub5,
          vv_gl_sub6, vv_gl_sub7,
          vv_sl_cd,
          vv_debit_amt,
          vv_credit_amt,
          vv_gen_type, vv_sl_type_cd, vv_sl_src_cd,
          vv_user_id, vv_last_upd, vv_remarks
     FROM GIAC_TREATY_BATCH_EXT A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
    WHERE A.iss_cd = b.gibr_branch_cd
      AND tran_flag = 'C'
      AND tran_class = 'UW'
      AND NVL(A.premium_amt,0) != 0
      AND TRUNC(b.tran_date) = p_prod_date
      AND A.iss_cd <> DECODE(NVL(Giacp.v('SEPARATE_CESSIONS_GL'),'N'),'N','**','Y',Giisp.v('ISS_CD_RI'))   -- exclude inward policies if parameter is Y
      AND A.acct_line_cd = DECODE(p_line_dep,0,A.acct_line_cd,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
      AND A.acct_intm_cd = DECODE(p_intm_dep,0,A.acct_intm_cd,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
      AND A.acct_trty_type = DECODE(p_trty_type,0,A.acct_trty_type,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_trty_type)
      AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_CREATE_PREM_CEDED');
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20666,'OTHERS!!!');
END bae2_create_prem_ceded_proc;

PROCEDURE bae2_create_prem_retroced_proc   -- added by judyann 03292011; to handle separate GL entry for retrocessions
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_trty_type NUMBER,
    p_item_no   NUMBER) AS
   TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
   TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          b.gibr_branch_cd gacc_gibr_branch_cd, 1 acct_entry_id,
          c.gl_acct_id  , c.gl_acct_category ,c.gl_control_acct , c.gl_sub_acct_1,
          c.gl_sub_acct_2 , c.gl_sub_acct_3  ,c.gl_sub_acct_4 , c.gl_sub_acct_5  ,
          c.gl_sub_acct_6 , c.gl_sub_acct_7  ,
          /*TO_NUMBER(DECODE(c.gslt_sl_type_cd, 6, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||
          TO_CHAR(A.peril_cd,'FM00'),
          5, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||'00',
          2, TO_CHAR(A.ri_cd,'FM000000'), NULL )) sl_cd,*/  --comment out and replaced by codes below mikel 03.21.2016 AUII 5467
           TO_NUMBER (
                DECODE (
                   c.gslt_sl_type_cd,
                   6,   (a.acct_line_cd * 100000)
                      + (a.acct_subline_cd * 1000)
                      + NVL (a.peril_cd, 0),
                   5,    TO_CHAR (a.acct_line_cd, 'FM00')
                      || TO_CHAR (a.acct_subline_cd, 'FM00')
                      || '00',
                   2, TO_CHAR (a.ri_cd, 'FM000000'),
                   NULL)) sl_cd, --mikel 03.21.2016 AUII 5467
          DECODE(c.dr_cr_tag,'D',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.premium_amt),1,A.premium_amt /100, 0),
          DECODE(SIGN(A.premium_amt),1,0,A.premium_amt *-1/100)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.premium_amt),1,0,A.premium_amt *-1/100),
          DECODE(SIGN(A.premium_amt),1,A.premium_amt/100, 0))) debit_amt,
          DECODE(c.dr_cr_tag,'C',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.premium_amt),1,A.premium_amt/100,0),
          DECODE(SIGN(A.premium_amt),1,0,A.premium_amt*-1/100)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.premium_amt),1,0,A.premium_amt*-1/100),
          DECODE(SIGN(A.premium_amt),1,A.premium_amt/100, 0))) credit_amt,
          NULL generation_type, c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd ,
          b.user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update, NULL remarks
     BULK COLLECT INTO
          vv_tran_id, vv_fund_cd,
          vv_branch_cd, vv_acct_entry,
          vv_gl_id, vv_gl_categ, vv_gl_cont, vv_gl_sub1,
          vv_gl_sub2, vv_gl_sub3, vv_gl_sub4, vv_gl_sub5,
          vv_gl_sub6, vv_gl_sub7,
          vv_sl_cd,
          vv_debit_amt,
          vv_credit_amt,
          vv_gen_type, vv_sl_type_cd, vv_sl_src_cd,
          vv_user_id, vv_last_upd, vv_remarks
     FROM GIAC_TREATY_BATCH_EXT A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
    WHERE A.iss_cd = b.gibr_branch_cd
      AND tran_flag = 'C'
      AND tran_class = 'UW'
      AND NVL(A.premium_amt,0) != 0
      AND TRUNC(b.tran_date) = p_prod_date
      AND A.iss_cd = Giisp.v('ISS_CD_RI')   -- inward policies only
      AND A.acct_line_cd = DECODE(p_line_dep,0,A.acct_line_cd,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
      AND A.acct_intm_cd = DECODE(p_intm_dep,0,A.acct_intm_cd,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
      AND A.acct_trty_type = DECODE(p_trty_type,0,A.acct_trty_type,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_trty_type)
      AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_CREATE_PREM_RETROCED');
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20666,'OTHERS!!!');
END bae2_create_prem_retroced_proc;

PROCEDURE bae2_create_comm_inc_proc
   (p_prod_date DATE,
    p_line_cd   NUMBER,
    p_intm_cd   NUMBER,
    p_trty_type NUMBER,
    p_item_no   NUMBER) AS
    TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
    TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          b.gibr_branch_cd gacc_gibr_branch_cd, 1 acct_entry_id,
          c.gl_acct_id  , c.gl_acct_category ,c.gl_control_acct , c.gl_sub_acct_1,
          c.gl_sub_acct_2 , c.gl_sub_acct_3  ,c.gl_sub_acct_4 , c.gl_sub_acct_5,
          c.gl_sub_acct_6 , c.gl_sub_acct_7,
          /*TO_NUMBER(DECODE(NVL(c.gslt_sl_type_cd,'0'), 6, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||
          TO_CHAR(A.peril_cd,'FM00'),
          2, TO_CHAR(A.ri_cd,'FM000000'), NULL )) sl_cd,*/  --comment out and replaced by codes below mikel 03.21.2016 AUII 5467
           TO_NUMBER (
                DECODE (
                   c.gslt_sl_type_cd,
                   6,   (a.acct_line_cd * 100000)
                      + (a.acct_subline_cd * 1000)
                      + NVL (a.peril_cd, 0),
                   2, TO_CHAR (a.ri_cd, 'FM000000'),
                   NULL)) sl_cd, --mikel 03.21.2016 AUII 5467
          DECODE(c.dr_cr_tag,'D',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.commission_amt),1,A.commission_amt/100, 0),
          DECODE(SIGN(A.commission_amt),1,0,A.commission_amt/100*-1)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.commission_amt),1,0,A.commission_amt/100*-1),
          DECODE(SIGN(A.commission_amt),1,A.commission_amt/100, 0))) debit_amt,
          DECODE(c.dr_cr_tag,'C',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.commission_amt),1,A.commission_amt/100,0),
          DECODE(SIGN(A.commission_amt),1,0,A.commission_amt/100*-1)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.commission_amt),1,0,A.commission_amt/100*-1),
          DECODE(SIGN(A.commission_amt),1,A.commission_amt/100, 0))) credit_amt,
          NULL generation_type, c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd, b.user_id ,
          TO_CHAR(SYSDATE,'MM-DD-YYYY')  last_update, NULL remarks
     BULK COLLECT INTO
          vv_tran_id, vv_fund_cd,
          vv_branch_cd, vv_acct_entry,
          vv_gl_id, vv_gl_categ, vv_gl_cont, vv_gl_sub1,
          vv_gl_sub2, vv_gl_sub3, vv_gl_sub4, vv_gl_sub5,
          vv_gl_sub6, vv_gl_sub7,
          vv_sl_cd,
          vv_debit_amt,
          vv_credit_amt,
          vv_gen_type, vv_sl_type_cd, vv_sl_src_cd,
          vv_user_id, vv_last_upd, vv_remarks
     FROM GIAC_TREATY_BATCH_EXT A,GIAC_ACCTRANS b,GIAC_BATCH_ENTRIES c
    WHERE A.iss_cd = b.gibr_branch_cd
      AND tran_flag = 'C'
      AND tran_class = 'UW'
      AND NVL(A.commission_amt,0)  != 0
      AND TRUNC(b.tran_date) = p_prod_date
      AND A.iss_cd <> DECODE(NVL(giacp.v('SEPARATE_CESSIONS_GL'),'N'),'N','**','Y',giisp.v('ISS_CD_RI'))   -- exclude inward policies if parameter is Y
      AND A.acct_line_cd = DECODE(p_line_cd, 0 , A.acct_line_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
      AND A.acct_intm_cd = DECODE(p_intm_cd, 0 , A.acct_intm_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
      AND A.acct_trty_type = DECODE(p_trty_type, 0 , A.acct_trty_type, 1, c.gl_sub_acct_1,  2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_trty_type)
      AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_CREATE_COMM_INC');
END bae2_create_comm_inc_proc;

PROCEDURE bae2_create_comm_retro_proc   -- added by judyann 03292011; to handle separate GL entry for retrocessions
   (p_prod_date DATE,
    p_line_cd   NUMBER,
    p_intm_cd   NUMBER,
    p_trty_type NUMBER,
    p_item_no   NUMBER) AS
    TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
    TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          b.gibr_branch_cd gacc_gibr_branch_cd, 1 acct_entry_id,
          c.gl_acct_id  , c.gl_acct_category ,c.gl_control_acct , c.gl_sub_acct_1,
          c.gl_sub_acct_2 , c.gl_sub_acct_3  ,c.gl_sub_acct_4 , c.gl_sub_acct_5,
          c.gl_sub_acct_6 , c.gl_sub_acct_7,
          /*TO_NUMBER(DECODE(NVL(c.gslt_sl_type_cd,'0'), 6, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||
          TO_CHAR(A.peril_cd,'FM00'),
          2, TO_CHAR(A.ri_cd,'FM000000'), NULL )) sl_cd,*/  --comment out and replaced by codes below mikel 03.21.2016 AUII 5467
           TO_NUMBER (
                DECODE (
                   NVL (c.gslt_sl_type_cd, '0'),
                   6,   (a.acct_line_cd * 100000)
                      + (a.acct_subline_cd * 1000)
                      + NVL (a.peril_cd, 0),
                   2, TO_CHAR (a.ri_cd, 'FM000000'),
                   NULL)) sl_cd, --mikel 03.21.2016 AUII 5467
          DECODE(c.dr_cr_tag,'D',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.commission_amt),1,A.commission_amt/100, 0),
          DECODE(SIGN(A.commission_amt),1,0,A.commission_amt/100*-1)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.commission_amt),1,0,A.commission_amt/100*-1),
          DECODE(SIGN(A.commission_amt),1,A.commission_amt/100, 0))) debit_amt,
          DECODE(c.dr_cr_tag,'C',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.commission_amt),1,A.commission_amt/100,0),
          DECODE(SIGN(A.commission_amt),1,0,A.commission_amt/100*-1)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.commission_amt),1,0,A.commission_amt/100*-1),
          DECODE(SIGN(A.commission_amt),1,A.commission_amt/100, 0))) credit_amt,
          NULL generation_type, c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd, b.user_id ,
          TO_CHAR(SYSDATE,'MM-DD-YYYY')  last_update, NULL remarks
     BULK COLLECT INTO
          vv_tran_id, vv_fund_cd,
          vv_branch_cd, vv_acct_entry,
          vv_gl_id, vv_gl_categ, vv_gl_cont, vv_gl_sub1,
          vv_gl_sub2, vv_gl_sub3, vv_gl_sub4, vv_gl_sub5,
          vv_gl_sub6, vv_gl_sub7,
          vv_sl_cd,
          vv_debit_amt,
          vv_credit_amt,
          vv_gen_type, vv_sl_type_cd, vv_sl_src_cd,
          vv_user_id, vv_last_upd, vv_remarks
     FROM GIAC_TREATY_BATCH_EXT A,GIAC_ACCTRANS b,GIAC_BATCH_ENTRIES c
    WHERE A.iss_cd = b.gibr_branch_cd
      AND tran_flag = 'C'
      AND tran_class = 'UW'
      AND NVL(A.commission_amt,0)  != 0
      AND TRUNC(b.tran_date) = p_prod_date
      AND A.iss_cd = Giisp.v('ISS_CD_RI')   -- inward policies only
      AND A.acct_line_cd = DECODE(p_line_cd, 0 , A.acct_line_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
      AND A.acct_intm_cd = DECODE(p_intm_cd, 0 , A.acct_intm_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
      AND A.acct_trty_type = DECODE(p_trty_type, 0 , A.acct_trty_type, 1, c.gl_sub_acct_1,  2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_trty_type)
      AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_CREATE_COMM_RETRO');
END bae2_create_comm_retro_proc;

PROCEDURE bae2_create_due_to_treaty_proc
   (p_prod_date DATE,
    p_line_dep   NUMBER,
    p_intm_dep   NUMBER,
    p_trty_type  NUMBER,
    p_item_no    NUMBER) AS
   TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
   TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          b.gibr_branch_cd gacc_gibr_branch_cd, 1 acct_entry_id,
          c.gl_acct_id  , c.gl_acct_category , c.gl_control_acct , c.gl_sub_acct_1  ,
          c.gl_sub_acct_2 , c.gl_sub_acct_3  , c.gl_sub_acct_4 , c.gl_sub_acct_5  ,
          c.gl_sub_acct_6 , c.gl_sub_acct_7  ,
          /*TO_NUMBER(DECODE(c.gslt_sl_type_cd, 6, TO_CHAR(A.acct_line_cd,'FM00')|| TO_CHAR(A.acct_subline_cd,'FM00')|| TO_CHAR(A.peril_cd,'FM00'),
          2, TO_CHAR(A.ri_cd,'FM000000'), NULL )) sl_cd,*/  --comment out and replaced by codes below mikel 03.21.2016 AUII 5467
          TO_NUMBER (
                DECODE (
                   c.gslt_sl_type_cd,
                   6,   (a.acct_line_cd * 100000)
                      + (a.acct_subline_cd * 1000)
                      + NVL (a.peril_cd, 0),
                   2, TO_CHAR (a.ri_cd, 'FM000000'),
                   NULL)) sl_cd, --mikel 03.21.2016 AUII 5467
          DECODE(c.dr_cr_tag,'D',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.due_to_ri),1,A.due_to_ri/100, 0),
          DECODE(SIGN(A.due_to_ri),1,0,due_to_ri/100*-1)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.due_to_ri),1,0,due_to_ri/100*-1),
          DECODE(SIGN(A.due_to_ri),1,due_to_ri/100, 0))) debit_amt,
          DECODE(c.dr_cr_tag,'C',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.due_to_ri),1,due_to_ri/100,0),
          DECODE(SIGN(A.due_to_ri),1,0,due_to_ri/100*-1)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.due_to_ri),1,0,due_to_ri/100*-1),
          DECODE(SIGN(A.due_to_ri),1,due_to_ri/100, 0))) credit_amt,
          NULL generation_type, c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd ,
          b.user_id, TO_CHAR(SYSDATE,'MM-DD-YYYY')  last_update, NULL remarks
     BULK COLLECT INTO
          vv_tran_id, vv_fund_cd,
          vv_branch_cd, vv_acct_entry,
          vv_gl_id, vv_gl_categ, vv_gl_cont, vv_gl_sub1,
          vv_gl_sub2, vv_gl_sub3, vv_gl_sub4, vv_gl_sub5,
          vv_gl_sub6, vv_gl_sub7,
          vv_sl_cd,
          vv_debit_amt,
          vv_credit_amt,
          vv_gen_type, vv_sl_type_cd, vv_sl_src_cd,
          vv_user_id, vv_last_upd, vv_remarks
     FROM GIAC_TREATY_BATCH_EXT A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
    WHERE A.iss_cd = b.gibr_branch_cd
      AND tran_flag = 'C'
      AND tran_class = 'UW'
      AND NVL(due_to_ri,0) != 0
      AND TRUNC(b.tran_date) = p_prod_date
      AND A.acct_line_cd = DECODE(p_line_dep , 0 , A.acct_line_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
      AND A.acct_intm_cd = DECODE(p_intm_dep , 0 , A.acct_intm_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
      AND A.acct_trty_type = DECODE(p_trty_type , 0 , A.acct_trty_type, 1, c.gl_sub_acct_1,  2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_trty_type)
      AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_CREATE_DUE_TO_TREATY');
END bae2_create_due_to_treaty_proc;

PROCEDURE bae2_create_funds_held_proc
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_trty_type NUMBER,
    p_item_no   NUMBER) AS
   TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
   TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          b.gibr_branch_cd gacc_gibr_branch_cd, 1 acct_entry_id,
          c.gl_acct_id  , c.gl_acct_category ,c.gl_control_acct , c.gl_sub_acct_1  ,
          c.gl_sub_acct_2 , c.gl_sub_acct_3,c.gl_sub_acct_4 , c.gl_sub_acct_5  ,
          c.gl_sub_acct_6 , c.gl_sub_acct_7,
          /*TO_NUMBER(DECODE(c.gslt_sl_type_cd, 6, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||
          TO_CHAR(A.peril_cd,'FM00'),
          2, TO_CHAR(A.ri_cd,'FM000000'), NULL )) sl_cd,*/ --comment out and replaced by codes below mikel 03.21.2016 AUII 5467
          TO_NUMBER (
                DECODE (
                   c.gslt_sl_type_cd,
                   6,   (a.acct_line_cd * 100000)
                      + (a.acct_subline_cd * 1000)
                      + NVL (a.peril_cd, 0),
                   2, TO_CHAR (a.ri_cd, 'FM000000'),
                   NULL)) sl_cd, --mikel 03.21.2016 AUII 5467
          DECODE(c.dr_cr_tag,'D',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.funds_held_amt),1,funds_held_amt/100, 0),
          DECODE(SIGN(A.funds_held_amt),1,0,funds_held_amt/100*-1)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.funds_held_amt),1,0,funds_held_amt/100*-1),
          DECODE(SIGN(A.funds_held_amt),1,funds_held_amt/100, 0))) debit_amt,
          DECODE(c.dr_cr_tag,'C',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.funds_held_amt),1,funds_held_amt/100,0),
          DECODE(SIGN(A.funds_held_amt),1,0,funds_held_amt/100*-1)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.funds_held_amt),1,0,funds_held_amt/100*-1),
          DECODE(SIGN(A.funds_held_amt),1,funds_held_amt/100, 0))) credit_amt,
          NULL generation_type, c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd ,
          b.user_id , TO_CHAR(SYSDATE,'MM-DD-YYYY')  last_update,NULL remarks
     BULK COLLECT INTO
          vv_tran_id, vv_fund_cd,
          vv_branch_cd, vv_acct_entry,
          vv_gl_id, vv_gl_categ, vv_gl_cont, vv_gl_sub1,
          vv_gl_sub2, vv_gl_sub3, vv_gl_sub4, vv_gl_sub5,
          vv_gl_sub6, vv_gl_sub7,
          vv_sl_cd,
          vv_debit_amt,
          vv_credit_amt,
          vv_gen_type, vv_sl_type_cd, vv_sl_src_cd,
          vv_user_id, vv_last_upd, vv_remarks
     FROM GIAC_TREATY_BATCH_EXT A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
    WHERE A.iss_cd = b.gibr_branch_cd
      AND tran_flag = 'C' AND tran_class = 'UW' AND NVL(A.funds_held_amt,0) != 0
      AND TRUNC(b.tran_date) = p_prod_date
      AND A.acct_line_cd = DECODE(p_line_dep, 0 , A.acct_line_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
      AND A.acct_intm_cd = DECODE(p_intm_dep, 0 , A.acct_intm_cd, 1, c.gl_sub_acct_1, 2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
      AND A.acct_trty_type = DECODE(p_trty_type, 0 , A.acct_trty_type, 1, c.gl_sub_acct_1,  2, c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_trty_type)
      AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_CREATE_FUNDS_HELD');
END bae2_create_funds_held_proc;

PROCEDURE bae2_create_prem_vat_proc--lina
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_trty_type NUMBER,
    p_item_no   NUMBER) AS
   TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
   TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          b.gibr_branch_cd gacc_gibr_branch_cd, 1 acct_entry_id,
          c.gl_acct_id  , c.gl_acct_category ,c.gl_control_acct , c.gl_sub_acct_1,
          c.gl_sub_acct_2 , c.gl_sub_acct_3  ,c.gl_sub_acct_4 , c.gl_sub_acct_5  ,
          c.gl_sub_acct_6 , c.gl_sub_acct_7  ,
          /*TO_NUMBER(DECODE(c.gslt_sl_type_cd, 6, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||
          TO_CHAR(A.peril_cd,'FM00'),
          5, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||'00',
          2, TO_CHAR(A.ri_cd,'FM000000'), NULL )) sl_cd,*/  --comment out and replaced by codes below mikel 03.21.2016 AUII 5467
           TO_NUMBER (
                DECODE (
                   c.gslt_sl_type_cd,
                   6,   (a.acct_line_cd * 100000)
                      + (a.acct_subline_cd * 1000)
                      + NVL (a.peril_cd, 0),
                   5,    TO_CHAR (a.acct_line_cd, 'FM00')
                      || TO_CHAR (a.acct_subline_cd, 'FM00')
                      || '00',
                   2, TO_CHAR (a.ri_cd, 'FM000000'),
                   NULL)) sl_cd, --mikel 03.21.2016 AUII 5467
          DECODE(c.dr_cr_tag,'D',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.prem_vat),1,A.prem_vat /100, 0),
          DECODE(SIGN(A.prem_vat),1,0,A.prem_vat *-1/100)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.prem_vat),1,0,A.prem_vat *-1/100),
          DECODE(SIGN(A.prem_vat),1,A.prem_vat/100, 0))) debit_amt,
          DECODE(c.dr_cr_tag,'C',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.prem_vat),1,A.prem_vat/100,0),
          DECODE(SIGN(A.prem_vat),1,0,A.prem_vat*-1/100)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.prem_vat),1,0,A.prem_vat*-1/100),
          DECODE(SIGN(A.prem_vat),1,A.prem_vat/100, 0))) credit_amt,
          NULL generation_type, c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd ,
          b.user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update, NULL remarks
     BULK COLLECT INTO
          vv_tran_id, vv_fund_cd,
          vv_branch_cd, vv_acct_entry,
          vv_gl_id, vv_gl_categ, vv_gl_cont, vv_gl_sub1,
          vv_gl_sub2, vv_gl_sub3, vv_gl_sub4, vv_gl_sub5,
          vv_gl_sub6, vv_gl_sub7,
          vv_sl_cd,
          vv_debit_amt,
          vv_credit_amt,
          vv_gen_type, vv_sl_type_cd, vv_sl_src_cd,
          vv_user_id, vv_last_upd, vv_remarks
     FROM GIAC_TREATY_BATCH_EXT A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
    WHERE A.iss_cd = b.gibr_branch_cd
      AND tran_flag = 'C'
   AND tran_class = 'UW'
   AND NVL(A.premium_amt,0) != 0
      AND TRUNC(b.tran_date) = p_prod_date
      AND A.local_foreign_sw = 'L'
   AND A.acct_line_cd = DECODE(p_line_dep,0,A.acct_line_cd,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
      AND A.acct_intm_cd = DECODE(p_intm_dep,0,A.acct_intm_cd,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
      AND A.acct_trty_type = DECODE(p_trty_type,0,A.acct_trty_type,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_trty_type)
      AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_CREATE_PREM_VAT');
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20666,'OTHERS!!!');
END bae2_create_prem_vat_proc;

PROCEDURE bae2_create_comm_vat_proc--lina
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_trty_type NUMBER,
    p_item_no   NUMBER) AS
   TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
   TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          b.gibr_branch_cd gacc_gibr_branch_cd, 1 acct_entry_id,
          c.gl_acct_id  , c.gl_acct_category ,c.gl_control_acct , c.gl_sub_acct_1,
          c.gl_sub_acct_2 , c.gl_sub_acct_3  ,c.gl_sub_acct_4 , c.gl_sub_acct_5  ,
          c.gl_sub_acct_6 , c.gl_sub_acct_7  ,
          /*TO_NUMBER(DECODE(c.gslt_sl_type_cd, 6, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||
          TO_CHAR(A.peril_cd,'FM00'),
          5, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||'00',
          2, TO_CHAR(A.ri_cd,'FM000000'), NULL )) sl_cd,*/ --comment out and replaced by codes below mikel 03.21.2016 AUII 5467
           TO_NUMBER (
                DECODE (
                   c.gslt_sl_type_cd,
                   6,   (a.acct_line_cd * 100000)
                      + (a.acct_subline_cd * 1000)
                      + NVL (a.peril_cd, 0),
                   5,    TO_CHAR (a.acct_line_cd, 'FM00')
                      || TO_CHAR (a.acct_subline_cd, 'FM00')
                      || '00',
                   2, TO_CHAR (a.ri_cd, 'FM000000'),
                   NULL)) sl_cd, --mikel 03.21.2016 AUII 5467
          DECODE(c.dr_cr_tag,'D',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.comm_vat),1,A.comm_vat /100, 0),
          DECODE(SIGN(A.comm_vat),1,0,A.comm_vat *-1/100)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.comm_vat),1,0,A.comm_vat *-1/100),
          DECODE(SIGN(A.comm_vat),1,A.comm_vat/100, 0))) debit_amt,
          DECODE(c.dr_cr_tag,'C',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.comm_vat),1,A.comm_vat/100,0),
          DECODE(SIGN(A.comm_vat),1,0,A.comm_vat*-1/100)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.comm_vat),1,0,A.comm_vat*-1/100),
          DECODE(SIGN(A.comm_vat),1,A.comm_vat/100, 0))) credit_amt,
          NULL generation_type, c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd ,
          b.user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update, NULL remarks
     BULK COLLECT INTO
          vv_tran_id, vv_fund_cd,
          vv_branch_cd, vv_acct_entry,
          vv_gl_id, vv_gl_categ, vv_gl_cont, vv_gl_sub1,
          vv_gl_sub2, vv_gl_sub3, vv_gl_sub4, vv_gl_sub5,
          vv_gl_sub6, vv_gl_sub7,
          vv_sl_cd,
          vv_debit_amt,
          vv_credit_amt,
          vv_gen_type, vv_sl_type_cd, vv_sl_src_cd,
          vv_user_id, vv_last_upd, vv_remarks
     FROM GIAC_TREATY_BATCH_EXT A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
    WHERE A.iss_cd = b.gibr_branch_cd
      AND tran_flag = 'C'
   AND tran_class = 'UW'
   AND NVL(A.premium_amt,0) != 0
      AND TRUNC(b.tran_date) = p_prod_date
      AND A.acct_line_cd = DECODE(p_line_dep,0,A.acct_line_cd,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
      AND A.acct_intm_cd = DECODE(p_intm_dep,0,A.acct_intm_cd,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
      AND A.acct_trty_type = DECODE(p_trty_type,0,A.acct_trty_type,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_trty_type)
      AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_CREATE_COMM_VAT');
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20666,'OTHERS!!!');
END bae2_create_comm_vat_proc;

PROCEDURE bae2_create_def_cr_wvat_proc--lina
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_trty_type NUMBER,
    p_item_no   NUMBER) AS
   TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
   TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          b.gibr_branch_cd gacc_gibr_branch_cd, 1 acct_entry_id,
          c.gl_acct_id  , c.gl_acct_category ,c.gl_control_acct , c.gl_sub_acct_1,
          c.gl_sub_acct_2 , c.gl_sub_acct_3  ,c.gl_sub_acct_4 , c.gl_sub_acct_5  ,
          c.gl_sub_acct_6 , c.gl_sub_acct_7  ,
          /*TO_NUMBER(DECODE(c.gslt_sl_type_cd, 6, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||
          TO_CHAR(A.peril_cd,'FM00'),
          5, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||'00',
          2, TO_CHAR(A.ri_cd,'FM000000'), NULL )) sl_cd,*/  --comment out and replaced by codes below mikel 03.21.2016 AUII 5467
           TO_NUMBER (
                DECODE (
                   c.gslt_sl_type_cd,
                   6,   (a.acct_line_cd * 100000)
                      + (a.acct_subline_cd * 1000)
                      + NVL (a.peril_cd, 0),
                   5,    TO_CHAR (a.acct_line_cd, 'FM00')
                      || TO_CHAR (a.acct_subline_cd, 'FM00')
                      || '00',
                   2, TO_CHAR (a.ri_cd, 'FM000000'),
                   NULL)) sl_cd, --mikel 03.21.2016 AUII 5467
          DECODE(c.dr_cr_tag,'D',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.ri_wholding_vat),1,A.ri_wholding_vat /100, 0),
          DECODE(SIGN(A.ri_wholding_vat),1,0,A.ri_wholding_vat *-1/100)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.ri_wholding_vat),1,0,A.ri_wholding_vat *-1/100),
          DECODE(SIGN(A.ri_wholding_vat),1,A.ri_wholding_vat/100, 0))) debit_amt,
          DECODE(c.dr_cr_tag,'C',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.ri_wholding_vat),1,A.ri_wholding_vat/100,0),
          DECODE(SIGN(A.ri_wholding_vat),1,0,A.ri_wholding_vat*-1/100)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.ri_wholding_vat),1,0,A.ri_wholding_vat*-1/100),
          DECODE(SIGN(A.ri_wholding_vat),1,A.ri_wholding_vat/100, 0))) credit_amt,
          NULL generation_type, c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd ,
          b.user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update, NULL remarks
     BULK COLLECT INTO
          vv_tran_id, vv_fund_cd,
          vv_branch_cd, vv_acct_entry,
          vv_gl_id, vv_gl_categ, vv_gl_cont, vv_gl_sub1,
          vv_gl_sub2, vv_gl_sub3, vv_gl_sub4, vv_gl_sub5,
          vv_gl_sub6, vv_gl_sub7,
          vv_sl_cd,
          vv_debit_amt,
          vv_credit_amt,
          vv_gen_type, vv_sl_type_cd, vv_sl_src_cd,
          vv_user_id, vv_last_upd, vv_remarks
     FROM GIAC_TREATY_BATCH_EXT A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
    WHERE A.iss_cd = b.gibr_branch_cd
      AND tran_flag = 'C'
   AND tran_class = 'UW'
   AND NVL(A.premium_amt,0) != 0
      AND a.local_foreign_sw != 'L'
   AND TRUNC(b.tran_date) = p_prod_date
      AND A.acct_line_cd = DECODE(p_line_dep,0,A.acct_line_cd,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
      AND A.acct_intm_cd = DECODE(p_intm_dep,0,A.acct_intm_cd,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
      AND A.acct_trty_type = DECODE(p_trty_type,0,A.acct_trty_type,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_trty_type)
      AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_CREATE_DEF_CR_WVAT');
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20666,'OTHERS!!!');
END bae2_create_def_cr_wvat_proc;

PROCEDURE bae2_create_wvat_pay_proc--lina
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_trty_type NUMBER,
    p_item_no   NUMBER) AS
   TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
   TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          b.gibr_branch_cd gacc_gibr_branch_cd, 1 acct_entry_id,
          c.gl_acct_id  , c.gl_acct_category ,c.gl_control_acct , c.gl_sub_acct_1,
          c.gl_sub_acct_2 , c.gl_sub_acct_3  ,c.gl_sub_acct_4 , c.gl_sub_acct_5  ,
          c.gl_sub_acct_6 , c.gl_sub_acct_7  ,
          /*TO_NUMBER(DECODE(c.gslt_sl_type_cd, 6, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||
          TO_CHAR(A.peril_cd,'FM00'),
          5, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||'00',
          2, TO_CHAR(A.ri_cd,'FM000000'), NULL )) sl_cd,*/ --comment out and replaced by codes below mikel 03.21.2016 AUII 5467
           TO_NUMBER (
                DECODE (
                   c.gslt_sl_type_cd,
                   6,   (a.acct_line_cd * 100000)
                      + (a.acct_subline_cd * 1000)
                      + NVL (a.peril_cd, 0),
                   5,    TO_CHAR (a.acct_line_cd, 'FM00')
                      || TO_CHAR (a.acct_subline_cd, 'FM00')
                      || '00',
                   2, TO_CHAR (a.ri_cd, 'FM000000'),
                   NULL)) sl_cd, --mikel 03.21.2016 AUII 5467
          DECODE(c.dr_cr_tag,'D',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.ri_wholding_vat),1,A.ri_wholding_vat /100, 0),
          DECODE(SIGN(A.ri_wholding_vat),1,0,A.ri_wholding_vat *-1/100)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.ri_wholding_vat),1,0,A.ri_wholding_vat *-1/100),
          DECODE(SIGN(A.ri_wholding_vat),1,A.ri_wholding_vat/100, 0))) debit_amt,
          DECODE(c.dr_cr_tag,'C',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.ri_wholding_vat),1,A.ri_wholding_vat/100,0),
          DECODE(SIGN(A.ri_wholding_vat),1,0,A.ri_wholding_vat*-1/100)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.ri_wholding_vat),1,0,A.ri_wholding_vat*-1/100),
          DECODE(SIGN(A.ri_wholding_vat),1,A.ri_wholding_vat/100, 0))) credit_amt,
          NULL generation_type, c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd ,
          b.user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update, NULL remarks
     BULK COLLECT INTO
          vv_tran_id, vv_fund_cd,
          vv_branch_cd, vv_acct_entry,
          vv_gl_id, vv_gl_categ, vv_gl_cont, vv_gl_sub1,
          vv_gl_sub2, vv_gl_sub3, vv_gl_sub4, vv_gl_sub5,
          vv_gl_sub6, vv_gl_sub7,
          vv_sl_cd,
          vv_debit_amt,
          vv_credit_amt,
          vv_gen_type, vv_sl_type_cd, vv_sl_src_cd,
          vv_user_id, vv_last_upd, vv_remarks
     FROM GIAC_TREATY_BATCH_EXT A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
    WHERE A.iss_cd = b.gibr_branch_cd
      AND tran_flag = 'C'
   AND tran_class = 'UW'
   AND NVL(A.premium_amt,0) != 0
   AND a.local_foreign_sw != 'L'
      AND TRUNC(b.tran_date) = p_prod_date
      AND A.acct_line_cd = DECODE(p_line_dep,0,A.acct_line_cd,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
      AND A.acct_intm_cd = DECODE(p_intm_dep,0,A.acct_intm_cd,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
      AND A.acct_trty_type = DECODE(p_trty_type,0,A.acct_trty_type,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_trty_type)
      AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            vv_debit_amt(mmb), vv_credit_amt(mmb), vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_CREATE_WVAT_PAY');
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20666,'OTHERS!!!');
END bae2_create_wvat_pay_proc;

PROCEDURE bae2_create_prem_tax_proc  -- added by judyann 07162008; generation of acctg entries for premium tax
   (p_prod_date DATE,
    p_line_dep  NUMBER,
    p_intm_dep  NUMBER,
    p_trty_type NUMBER,
    p_item_no   NUMBER) AS
   TYPE tran_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_tran_id%TYPE;
   TYPE fund_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE;
    TYPE branch_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE;
    TYPE acct_entry_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.acct_entry_id%TYPE;
    TYPE gl_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_id%TYPE;
    TYPE gl_categ_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_acct_category%TYPE;
    TYPE gl_cont_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_control_acct%TYPE;
    TYPE gl_sub1_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    TYPE gl_sub2_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    TYPE gl_sub3_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    TYPE gl_sub4_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    TYPE gl_sub5_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    TYPE gl_sub6_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    TYPE gl_sub7_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
    TYPE sl_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_cd%TYPE;
    TYPE debit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.debit_amt%TYPE;
    TYPE credit_amt_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.credit_amt%TYPE;
    TYPE gen_type_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.generation_type%TYPE;
    TYPE sl_type_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_type_cd%TYPE;
    TYPE sl_src_cd_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.sl_source_cd%TYPE;
    TYPE user_id_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.user_id%TYPE;
    TYPE last_upd_tab IS TABLE OF VARCHAR2(20);
    TYPE remarks_tab IS TABLE OF GIAC_TEMP_ACCT_ENTRIES.remarks%TYPE;
    vv_tran_id  tran_id_tab;
    vv_fund_cd  fund_cd_tab;
    vv_branch_cd branch_cd_tab;
    vv_acct_entry acct_entry_tab;
    vv_gl_id  gl_id_tab;
    vv_gl_categ  gl_categ_tab;
    vv_gl_cont  gl_cont_tab;
    vv_gl_sub1  gl_sub1_tab;
    vv_gl_sub2  gl_sub2_tab;
    vv_gl_sub3  gl_sub3_tab;
    vv_gl_sub4  gl_sub4_tab;
    vv_gl_sub5  gl_sub5_tab;
    vv_gl_sub6  gl_sub6_tab;
    vv_gl_sub7  gl_sub7_tab;
    vv_sl_cd  sl_cd_tab;
    vv_debit_amt debit_amt_tab;
    vv_credit_amt credit_amt_tab;
    vv_gen_type  gen_type_tab;
    vv_sl_type_cd sl_type_cd_tab;
    vv_sl_src_cd sl_src_cd_tab;
    vv_user_id  user_id_tab;
    vv_last_upd  last_upd_tab;
    vv_remarks  remarks_tab;
BEGIN
   SELECT b.tran_id gacc_tran_id, b.gfun_fund_cd gacc_gfun_fund_cd,
          b.gibr_branch_cd gacc_gibr_branch_cd, 1 acct_entry_id,
          c.gl_acct_id  , c.gl_acct_category ,c.gl_control_acct , c.gl_sub_acct_1,
          c.gl_sub_acct_2 , c.gl_sub_acct_3  ,c.gl_sub_acct_4 , c.gl_sub_acct_5  ,
          c.gl_sub_acct_6 , c.gl_sub_acct_7  ,
          /*TO_NUMBER(DECODE(c.gslt_sl_type_cd, 6, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||
          TO_CHAR(A.peril_cd,'FM00'),
          5, TO_CHAR(A.acct_line_cd,'FM00')||
          TO_CHAR(A.acct_subline_cd,'FM00')||'00',
          2, TO_CHAR(A.ri_cd,'FM000000'), NULL )) sl_cd,*/  --comment out and replaced by codes below mikel 03.21.2016 AUII 5467
           TO_NUMBER (
                DECODE (
                   c.gslt_sl_type_cd,
                   6,   (a.acct_line_cd * 100000)
                      + (a.acct_subline_cd * 1000)
                      + NVL (a.peril_cd, 0),
                   5,    TO_CHAR (a.acct_line_cd, 'FM00')
                      || TO_CHAR (a.acct_subline_cd, 'FM00')
                      || '00',
                   2, TO_CHAR (a.ri_cd, 'FM000000'),
                   NULL)) sl_cd, --mikel 03.21.2016 AUII 5467
          /*DECODE(c.dr_cr_tag,'D',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.prem_tax),1,A.prem_tax /100, 0),
          DECODE(SIGN(A.prem_tax),1,0,A.prem_tax *-1/100)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.prem_tax),1,0,A.prem_tax *-1/100),
          DECODE(SIGN(A.prem_tax),1,A.prem_tax/100, 0))) debit_amt,*/ 
    0 debit_amt, .0048 credit_amt,
          /*DECODE(c.dr_cr_tag,'C',
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.prem_tax),1,A.prem_tax/100,0),
          DECODE(SIGN(A.prem_tax),1,0,A.prem_tax*-1/100)),
          DECODE(A.tk_up_type,'P',
          DECODE(SIGN(A.prem_tax),1,0,A.prem_tax*-1/100),
          DECODE(SIGN(A.prem_tax),1,A.prem_tax/100, 0))) credit_amt, */
          NULL generation_type, c.gslt_sl_type_cd sl_type_cd, 1 sl_source_cd ,
          b.user_id,TO_CHAR(SYSDATE,'MM-DD-YYYY') last_update, NULL remarks
     BULK COLLECT INTO
          vv_tran_id, vv_fund_cd,
          vv_branch_cd, vv_acct_entry,
          vv_gl_id, vv_gl_categ, vv_gl_cont, vv_gl_sub1,
          vv_gl_sub2, vv_gl_sub3, vv_gl_sub4, vv_gl_sub5,
          vv_gl_sub6, vv_gl_sub7,
          vv_sl_cd,
          vv_debit_amt,
          vv_credit_amt,
          vv_gen_type, vv_sl_type_cd, vv_sl_src_cd,
          vv_user_id, vv_last_upd, vv_remarks
     FROM GIAC_TREATY_BATCH_EXT A, GIAC_ACCTRANS b, GIAC_BATCH_ENTRIES c
    WHERE A.iss_cd = b.gibr_branch_cd
      AND tran_flag = 'C'
   AND tran_class = 'UW'
   AND NVL(A.premium_amt,0) != 0
   AND a.local_foreign_sw != 'L'
      AND TRUNC(b.tran_date) = p_prod_date
      AND A.acct_line_cd = DECODE(p_line_dep,0,A.acct_line_cd,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_line_cd)
      AND A.acct_intm_cd = DECODE(p_intm_dep,0,A.acct_intm_cd,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_intm_cd)
      AND A.acct_trty_type = DECODE(p_trty_type,0,A.acct_trty_type,1,c.gl_sub_acct_1,2,c.gl_sub_acct_2, 3, c.gl_sub_acct_3, 4, c.gl_sub_acct_4, 5, c.gl_sub_acct_5, 6, c.gl_sub_acct_6, 7, c.gl_sub_acct_7, A.acct_trty_type)
      AND c.item_no = p_item_no;
   IF SQL%FOUND THEN
      FORALL mmb IN vv_tran_id.FIRST..vv_tran_id.LAST
         INSERT INTO GIAC_TEMP_ACCT_ENTRIES(
            gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
            gl_acct_id, gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
            gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
            debit_amt, credit_amt, generation_type, sl_type_cd, sl_source_cd,
            user_id, last_update, remarks)
         VALUES(
            vv_tran_id(mmb), vv_fund_cd(mmb), vv_branch_cd(mmb), vv_acct_entry(mmb),
            vv_gl_id(mmb), vv_gl_categ(mmb), vv_gl_cont(mmb), vv_gl_sub1(mmb), vv_gl_sub2(mmb),
            vv_gl_sub3(mmb), vv_gl_sub4(mmb), vv_gl_sub5(mmb), vv_gl_sub6(mmb), vv_gl_sub7(mmb), vv_sl_cd(mmb),
            0, 0.48, --vv_debit_amt(mmb), vv_credit_amt(mmb),
   vv_gen_type(mmb), vv_sl_type_cd(mmb), vv_sl_src_cd(mmb),
            vv_user_id(mmb), TO_DATE(vv_last_upd(mmb),'MM-DD-YYYY'), vv_remarks(mmb));
   END IF;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001,'DUPLICATE VALUE ON BAE2_CREATE_PREM_TAX');
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20666,'OTHERS!!!');
END bae2_create_prem_tax_proc;

END; 
/