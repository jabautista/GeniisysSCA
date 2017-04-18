DROP PROCEDURE CPI.EXTRACT_COMM_EXPENSE;

CREATE OR REPLACE PROCEDURE CPI.extract_comm_expense 
  (p_from     DATE,
   p_to       DATE,
   p_line_cd  giis_line.line_cd%TYPE,
   p_user     VARCHAR2 
  )
AS
/*Modified by:    Vincent
  Date Modified:  041105
  Modification:   added cred_branch in extraction,
                  user_id and last_update in insert
                  replaced acct_ent_date in delete with user_id  
  Created by:	  Vincent
  Date created:   022105
  Description:	  extract records into giac_comm_expense_ext for the specified dates
*/
  TYPE policy_id_tab            IS TABLE OF gipi_polbasic.policy_id%TYPE;
  TYPE assd_no_tab              IS TABLE OF gipi_parlist.assd_no%TYPE;
  TYPE incept_date_tab          IS TABLE OF gipi_polbasic.incept_date%TYPE;
  TYPE acct_ent_date_tab        IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
  TYPE peril_cd_tab             IS TABLE OF gipi_comm_inv_peril.peril_cd%TYPE;
  TYPE premium_amt_tab          IS TABLE OF gipi_comm_inv_peril.premium_amt%TYPE;
  TYPE commission_amt_tab       IS TABLE OF gipi_comm_inv_peril.commission_amt%TYPE;
  TYPE line_cd_tab              IS TABLE OF gipi_polbasic.line_cd%TYPE;
  TYPE iss_cd_tab               IS TABLE OF gipi_polbasic.iss_cd%TYPE;
  TYPE cred_branch_tab          IS TABLE OF gipi_polbasic.cred_branch%TYPE;
  vv_policy_id                  policy_id_tab;
  vv_assd_no                    assd_no_tab;
  vv_incept_date                incept_date_tab;
  vv_acct_ent_date              acct_ent_date_tab;
  vv_peril_cd                   peril_cd_tab;
  vv_premium_amt                premium_amt_tab;
  vv_commission_amt             commission_amt_tab;
  vv_line_cd                    line_cd_tab;
  vv_iss_cd                     iss_cd_tab;
  vv_cred_branch                cred_branch_tab;
BEGIN
  --delete records for the specified user
  DELETE FROM giac_comm_expense_ext
   WHERE user_id = p_user;
  COMMIT;
  --retrieve/extract records
  SELECT policy_id, assd_no, incept_date, acct_ent_date,
         peril_cd, premium_amt,  commission_amt, line_cd, iss_cd, cred_branch
  BULK COLLECT
    INTO vv_policy_id,
         vv_assd_no,
         vv_incept_date,
         vv_acct_ent_date,
         vv_peril_cd,
         vv_premium_amt,
         vv_commission_amt,
         vv_line_cd,
         vv_iss_cd,
         vv_cred_branch
    FROM (SELECT a.policy_id, b.assd_no, a.incept_date, a.acct_ent_date,
                 d.peril_cd, sum(d.premium_amt) premium_amt, sum(d.commission_amt) commission_amt,
                 a.line_cd, a.iss_cd,
                 a.cred_branch
            FROM gipi_polbasic a,
                 gipi_parlist b,
                 gipi_comm_invoice c,
                 gipi_comm_inv_peril d
           WHERE a.policy_id = c.policy_id
             AND c.iss_cd	= d.iss_cd
             AND c.prem_seq_no = d.prem_seq_no
             AND a.par_id = b.par_id
             AND a.pol_flag != '5'
             AND a.acct_ent_date BETWEEN p_from AND p_to
             AND a.policy_id > 0
             AND a.line_cd = nvl(p_line_cd, a.line_cd)
           GROUP BY a.policy_id, b.assd_no, a.incept_date, a.acct_ent_date,
                 d.peril_cd, a.line_cd, a.iss_cd, a.cred_branch
           UNION
          SELECT a.policy_id, b.assd_no, a.incept_date, a.acct_ent_date,
                 c.peril_cd, sum(c.prem_amt), sum(c.ri_comm_amt), a.line_cd, a.iss_cd,
                 a.cred_branch
            FROM gipi_polbasic a,
                 gipi_parlist b,
                 gipi_itmperil c
           WHERE a.policy_id = c.policy_id
             AND a.par_id = b.par_id
             AND a.pol_flag != '5'
             AND a.acct_ent_date BETWEEN p_from AND p_to
             AND a.iss_cd = 'RI'
             AND a.line_cd = nvl(p_line_cd, a.line_cd)
           GROUP BY a.policy_id, b.assd_no, a.incept_date, a.acct_ent_date,
                 c.peril_cd, a.line_cd, a.iss_cd, a.cred_branch);
  --insert records in giac_comm_expense_ext
  IF SQL% FOUND THEN
    FORALL i IN vv_policy_id.FIRST..vv_policy_id.LAST
      INSERT INTO giac_comm_expense_ext
        (policy_id,            assd_no,                incept_date,           acct_ent_date,         peril_cd,
         prem_amt,             comm_amt,               line_cd,               iss_cd,                cred_branch,
         user_id,              last_update)
      VALUES
        (vv_policy_id(i),      vv_assd_no(i),          vv_incept_date(i),     vv_acct_ent_date(i),   vv_peril_cd(i),
         vv_premium_amt(i),    vv_commission_amt(i),   vv_line_cd(i),         vv_iss_cd(i),          vv_cred_branch(i),
         p_user,               sysdate);
  END IF;
  COMMIT;
END extract_comm_expense;
/


