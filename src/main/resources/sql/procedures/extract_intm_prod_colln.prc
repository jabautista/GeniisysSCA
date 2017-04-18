DROP PROCEDURE CPI.EXTRACT_INTM_PROD_COLLN;

CREATE OR REPLACE PROCEDURE CPI.Extract_Intm_Prod_Colln
  (p_branch_param  NUMBER,
   p_branch_cd     GIPI_POLBASIC.iss_cd%TYPE,
   p_line_cd       GIIS_LINE.line_cd%TYPE,
   p_intm_no       GIIS_INTERMEDIARY.intm_no%TYPE,
   p_param_date    NUMBER,
   p_from_date     DATE,
   p_to_date       DATE
  )
AS
/*
  Created by: Vincent
  Date created: 092305
  Description:  Extracts records for Intermediary Production Subsidiary Ledger
*/
/* Modified by:   Sherwin
** Date Modified: 091407
** Modifications: Used functions Check_User_Per_Iss_Cd2 and Check_User_Per_Line2
**       to filter Iss_cd and Line_cd for specific User.
*/
  TYPE branch_cd_tab            IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
  TYPE line_cd_tab              IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
  TYPE intm_no_tab              IS TABLE OF GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE;
  TYPE policy_id_tab            IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
  TYPE policy_no_tab            IS TABLE OF VARCHAR2(50);
  TYPE assd_no_tab              IS TABLE OF GIPI_PARLIST.assd_no%TYPE;
  TYPE incept_date_tab          IS TABLE OF GIPI_POLBASIC.incept_date%TYPE;
  TYPE iss_cd_tab               IS TABLE OF GIPI_COMM_INVOICE.iss_cd%TYPE;
  TYPE prem_seq_no_tab          IS TABLE OF GIPI_COMM_INVOICE.prem_seq_no%TYPE;
  TYPE share_percentage_tab     IS TABLE OF GIPI_COMM_INVOICE.share_percentage%TYPE;
  TYPE premium_amt_tab          IS TABLE OF GIPI_COMM_INVOICE.premium_amt%TYPE;
  TYPE tax_amt_tab              IS TABLE OF GIPI_INVOICE.tax_amt%TYPE;
  vv_branch_cd                  branch_cd_tab;
  vv_line_cd                    line_cd_tab;
  vv_intm_no                    intm_no_tab;
  vv_policy_id                  policy_id_tab;
  vv_policy_no                  policy_no_tab;
  vv_assd_no                    assd_no_tab;
  vv_incept_date                incept_date_tab;
  vv_iss_cd                     iss_cd_tab;
  vv_prem_seq_no                prem_seq_no_tab;
  vv_share_percentage           share_percentage_tab;
  vv_premium_amt                premium_amt_tab;
  vv_tax_amt                    tax_amt_tab;
BEGIN
  --delete records for the specified user
  DELETE FROM GIAC_INTM_PROD_COLLN_EXT
   WHERE user_id = USER ;
  --retrieve/extract records
  SELECT DECODE(p_branch_param,1,NVL(gp.cred_branch,gp.iss_cd),gp.iss_cd) branch_cd,
         gp.line_cd line_cd,
         gci.intrmdry_intm_no intm_no,
         gp.policy_id policy_id,
         gp.line_cd || '-' || gp.subline_cd || '-' || gp.iss_cd || '-'
           || LTRIM (TO_CHAR (gp.issue_yy, '09')) || '-'
           || LTRIM (TO_CHAR (gp.pol_seq_no, '0999999')) || '-'
           || LTRIM (TO_CHAR (gp.renew_no, '09'))
           || DECODE (NVL (gp.endt_seq_no, 0), 0, '',
                      ' / ' || gp.endt_iss_cd || '-'
                      || LTRIM (TO_CHAR (gp.endt_yy, '09')) || '-'
                      || LTRIM (TO_CHAR (gp.endt_seq_no, '9999999'))) policy_no,
         A.assd_no,
         gp.incept_date,
         gci.iss_cd,
         gci.prem_seq_no,
         gci.share_percentage,
         gci.premium_amt * ginv.currency_rt
           * DECODE(p_param_date,4,DECODE(TRUNC(gp.spld_acct_ent_date),TRUNC(gp.acct_ent_date),0,NULL,1,-1),1) premium_amt,
         NVL(ginv.tax_amt,0) * (gci.share_percentage/100) * ginv.currency_rt
           * DECODE(p_param_date,4,DECODE(TRUNC(gp.spld_acct_ent_date),TRUNC(gp.acct_ent_date),0,NULL,1,-1),1) tax_amt
  BULK COLLECT
    INTO vv_branch_cd,
         vv_line_cd,
         vv_intm_no,
         vv_policy_id,
         vv_policy_no,
         vv_assd_no,
         vv_incept_date,
         vv_iss_cd,
         vv_prem_seq_no,
         vv_share_percentage,
         vv_premium_amt,
         vv_tax_amt
    FROM GIPI_POLBASIC gp,
         GIPI_PARLIST A,
         (SELECT intrmdry_intm_no, iss_cd, prem_seq_no, policy_id, share_percentage, premium_amt
            FROM GIPI_COMM_INVOICE A
           WHERE NOT EXISTS (SELECT 'X'
                               FROM GIPI_COMM_INV_DTL b
                              WHERE b.intrmdry_intm_no = A.intrmdry_intm_no
                                AND b.iss_cd = A.iss_cd
                                AND b.prem_seq_no = A.prem_seq_no)
          UNION ALL
          SELECT A.intrmdry_intm_no, A.iss_cd, A.prem_seq_no, A.policy_id, b.share_percentage, b.premium_amt
            FROM GIPI_COMM_INVOICE A, GIPI_COMM_INV_DTL b
           WHERE b.intrmdry_intm_no = A.intrmdry_intm_no
             AND b.iss_cd = A.iss_cd
             AND b.prem_seq_no = A.prem_seq_no) gci,
         GIPI_INVOICE ginv
   WHERE 1 = 1
     AND gci.iss_cd = ginv.iss_cd
     AND gci.prem_seq_no = ginv.prem_seq_no
     AND gci.intrmdry_intm_no = NVL (p_intm_no, gci.intrmdry_intm_no)
     AND (gp.pol_flag != '5'
          OR DECODE
         (p_param_date, 4, 1, 0) = 1)
     AND (TRUNC (gp.issue_date) BETWEEN p_from_date AND p_to_date
          OR
          DECODE (p_param_date, 1, 0, 1) = 1)
     AND (TRUNC (gp.eff_date) BETWEEN p_from_date AND p_to_date
          OR
          DECODE (p_param_date, 2, 0, 1) = 1)
     AND (LAST_DAY (
            TO_DATE (
              gp.booking_mth || ',' || TO_CHAR (gp.booking_year),'FMMONTH,YYYY'))
       BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date)
          OR
          DECODE (p_param_date, 3, 0, 1) = 1)
     AND ((TRUNC (gp.acct_ent_date) BETWEEN p_from_date AND p_to_date
           OR
           NVL (TRUNC (gp.spld_acct_ent_date), p_to_date + 1) BETWEEN p_from_date AND p_to_date)
          OR
    DECODE (p_param_date, 4, 0, 1) = 1)
     AND DECODE (gp.pol_flag,'4', Check_Date(NULL,
                                             gp.line_cd,
                                             gp.subline_cd,
                                             gp.iss_cd,
                                             gp.issue_yy,
                                             gp.pol_seq_no,
                                             gp.renew_no,
                                             p_param_date,
                                             p_from_date,
                                             p_to_date),1) = 1
     AND gp.policy_id = gci.policy_id
     AND A.par_id = gp.par_id
     AND NVL (gp.endt_type, 'A') = 'A'
     AND gp.line_cd = NVL (p_line_cd, gp.line_cd)
     AND gp.iss_cd <> Giacp.v ('RI_ISS_CD')
     AND DECODE(p_branch_param,1,NVL(gp.cred_branch,gp.iss_cd),gp.iss_cd) =
                NVL(p_branch_cd,DECODE(p_branch_param,1,NVL(gp.cred_branch,gp.iss_cd),gp.iss_cd))
/* commented out and changed by reymon 05252012
  AND Check_User_Per_Iss_Cd2(NULL,DECODE(p_branch_param,1,NVL(gp.cred_branch,gp.iss_cd),gp.iss_cd) ,'GIACS275',USER) = 1         --rochelle, 10262007
  AND Check_User_Per_Line2(gp.line_cd, NULL,'GIACS275',USER) = 1;             --sherwin 091407*/
     AND check_user_per_iss_cd_acctg (NULL, DECODE(p_branch_param,1,NVL(gp.cred_branch,gp.iss_cd),gp.iss_cd), 'GIACS235') = 1;
  --insert records into giac_intm_prod_colln_ext
  IF SQL% FOUND THEN
    FORALL i IN vv_branch_cd.FIRST..vv_branch_cd.LAST
      INSERT INTO GIAC_INTM_PROD_COLLN_EXT
        (branch_cd,
         line_cd,
         intm_no,
         policy_id,
         policy_no,
         assd_no,
   incept_date,
         iss_cd,
         prem_seq_no,
         share_percentage,
         premium_amt,
         tax_amt,
         user_id,
   last_update)
      VALUES
        (vv_branch_cd(i),
         vv_line_cd(i),
         vv_intm_no(i),
         vv_policy_id(i),
         vv_policy_no(i),
         vv_assd_no(i),
         vv_incept_date(i),
         vv_iss_cd(i),
         vv_prem_seq_no(i),
         vv_share_percentage(i),
         vv_premium_amt(i),
         vv_tax_amt(i),
         USER,
   SYSDATE);
  END IF;
  COMMIT;
END Extract_Intm_Prod_Colln;
/


