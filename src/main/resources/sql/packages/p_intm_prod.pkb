CREATE OR REPLACE PACKAGE BODY CPI.P_Intm_Prod
/* rollie 13jan2005 @ CPI QUAD
** This package will hold all the procedures and functions that will
** handle the extraction of production by intermediary
*/
/* Modified By  : Sherwin
** Date Modified: 091407
** Modifications: Used functions Check_User_Per_Iss_Cd2 and Check_User_Per_Line2
**       to filter Iss_cd and Line_cd for specific User.
*/
AS
  PROCEDURE EXTRACT(
     p_iss_cd       IN VARCHAR2,
   p_intm_no    IN NUMBER,
   p_line_cd    IN VARCHAR2,
   p_date_param   IN NUMBER, /*  1 - based on issue_date
                    2 - based on incept_date
            3 - based on booking_month
            4 - based on acct_ent_date */
            p_from_date    IN DATE,
   p_to_date      IN DATE,
   p_iss_param    IN NUMBER /* 1 - based on cred_branch
                2 - based on iss_cd*/
   )
    AS
 TYPE v_iss_cd_tab     IS TABLE OF GIIS_ISSOURCE.iss_cd%TYPE;
 TYPE v_intm_no_tab        IS TABLE OF GIIS_INTERMEDIARY.intm_no%TYPE;
 TYPE v_intm_name_tab      IS TABLE OF GIIS_INTERMEDIARY.intm_name%TYPE;
 TYPE v_line_cd_tab        IS TABLE OF GIIS_LINE.line_cd%TYPE;
 TYPE v_share_type_tab    IS TABLE OF GIIS_DIST_SHARE.share_type%TYPE;
 TYPE v_acct_trty_type_tab IS TABLE OF GIIS_DIST_SHARE.acct_trty_type%TYPE;
 TYPE v_prem_amt_tab    IS TABLE OF GIUW_POLICYDS_DTL.dist_prem%TYPE;
 v_iss_cd      v_iss_cd_tab;
 v_intm_no      v_intm_no_tab;
 v_intm_name      v_intm_name_tab;
 v_line_cd      v_line_cd_tab;
 v_share_type     v_share_type_tab;
 v_acct_trty_type    v_acct_trty_type_tab;
 v_prem_amt        v_prem_amt_tab;
 v_cred_branch     v_iss_cd_tab;
 v_iss_cd_2      v_iss_cd_tab;
 v_intm_no_2      v_intm_no_tab;
 v_intm_name_2     v_intm_name_tab;
 v_line_cd_2      v_line_cd_tab;
 v_share_type_2     v_share_type_tab;
 v_acct_trty_type_2    v_acct_trty_type_tab;
  BEGIN
    DELETE FROM GIXX_INTM_PROD_EXT
  WHERE user_id = USER;
 COMMIT;
 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS'));
    SELECT f.intm_no,f.intm_name,DECODE(p_iss_param,1,NVL(A.cred_branch,A.iss_cd),A.iss_cd),
     A.line_cd,e.share_type,e.acct_trty_type,SUM(C.dist_prem)
    BULK COLLECT INTO
        v_intm_no,v_intm_name,v_iss_cd,
       v_line_cd,v_share_type,v_acct_trty_type,v_prem_amt
   FROM GIPI_POLBASIC A,
        GIUW_POL_DIST b,
     GIUW_POLICYDS_DTL C,
     GIPI_COMM_INVOICE d,
     GIIS_INTERMEDIARY f,
     GIIS_DIST_SHARE e
 WHERE 1 = 1
   AND Check_Date_Policy(p_date_param,
         p_from_date,
       p_to_date,
       A.issue_date,
       A.eff_date,
       A.acct_ent_date,
       A.spld_acct_ent_date,
       A.booking_mth,
       A.booking_year) = 1
   AND A.par_id = b.par_id
   AND b.dist_no = C.dist_no
   AND d.policy_id = A.policy_id
   AND d.intrmdry_intm_no = f.intm_no
   AND C.line_cd = e.line_cd
   AND C.share_cd = e.share_cd
   AND b.dist_flag=3
   AND f.intm_no = NVL(p_intm_no,f.intm_no)
   AND C.line_cd = NVL(p_line_cd,A.line_cd)
   AND DECODE(p_iss_param,1,NVL(A.cred_branch,A.iss_cd),A.iss_cd)   =
        NVL(p_iss_cd,DECODE(p_iss_param,1,NVL(A.cred_branch,A.iss_cd),A.iss_cd))
/*commented out and changed by reymon 05252012
   AND Check_User_Per_Iss_Cd2(NULL,DECODE(p_iss_param,1,NVL(A.cred_branch,A.iss_cd),A.iss_cd),'GIACS275',USER) = 1     --rochelle, 10262007
   AND Check_User_Per_Line2(A.line_cd,NULL,'GIACS275',USER) = 1       --sherwin 091407*/
   AND check_user_per_iss_cd_acctg (NULL, DECODE(p_iss_param,1,NVL(A.cred_branch,A.iss_cd),A.iss_cd), 'GIACS235') = 1
 GROUP BY f.intm_no,f.intm_name,DECODE(p_iss_param,1,NVL(A.cred_branch,A.iss_cd),A.iss_cd),
     A.line_cd,e.share_type,e.acct_trty_type;
 IF SQL%FOUND THEN
   FORALL cnt IN v_intm_no.FIRST..v_intm_no.LAST
        INSERT INTO GIXX_INTM_PROD_EXT (
          intm_cd,
      intm_name,
      iss_cd,
      line_cd,
      share_type,
      acct_trty_type,
      prem_amt,
      user_id,
      last_update,
      iss_param)
      VALUES (v_intm_no(cnt),
       v_intm_name(cnt),
      v_iss_cd(cnt),
      v_line_cd(cnt),
      v_share_type(cnt),
      v_acct_trty_type(cnt),
      v_prem_amt(cnt),
      USER,
      SYSDATE,
      p_iss_param);
     COMMIT;
 END IF;
 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS'));
/** rollie 17JAN2005
 getting the dummy data needed for the report**/
   SELECT DISTINCT f.intm_no,f.intm_name,A.iss_cd,C.line_cd,b.share_type,DECODE(share_type,'2',b.acct_trty_type,NULL) acct_trty_type
   BULK COLLECT INTO
       v_intm_no_2,
     v_intm_name_2,
     v_iss_cd_2,
     v_line_cd_2,
     v_share_type_2,
     v_acct_trty_type_2
      FROM GIIS_INTERMEDIARY f,
     GIIS_ISSOURCE A,
     GIIS_LINE C,
     (SELECT DISTINCT b.trty_lname share_name_title,share_type share_type,DECODE(share_type,'2',A.acct_trty_type,NULL) acct_trty_type
           FROM GIIS_DIST_SHARE A,
           GIIS_CA_TRTY_TYPE b
       WHERE A.acct_trty_type = b.ca_trty_type
      AND  share_type='2'
      UNION ALL
        SELECT UPPER(rv_meaning) share_name_title,rv_low_value share_type,NULL
         FROM CG_REF_CODES
       WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE'
           AND rv_low_value <> '2' ) b
     WHERE 1 = 1
    AND NOT EXISTS ( SELECT 'X'
                  FROM GIXX_INTM_PROD_EXT z
       WHERE f.intm_no = z.intm_cd
         AND A.iss_cd  = z.iss_cd
         AND C.line_cd = z.line_cd
         AND b.share_type = z.share_type
         AND NVL(b.acct_trty_type,99) = NVL(z.acct_trty_type,99)
         AND user_id = USER)
       AND EXISTS ( SELECT 'Y'
                FROM GIXX_INTM_PROD_EXT z
      WHERE f.intm_no = z.intm_cd
        AND A.iss_cd  = z.iss_cd
        AND C.line_cd = z.line_cd
        AND user_id = USER);
    IF SQL%FOUND THEN
   FORALL cnt IN v_intm_no_2.FIRST..v_intm_no_2.LAST
        INSERT INTO GIXX_INTM_PROD_EXT (
          intm_cd,
      intm_name,
      iss_cd,
      line_cd,
      share_type,
      acct_trty_type,
      prem_amt,
      user_id,
      last_update,
      iss_param)
      VALUES (v_intm_no_2(cnt),
       v_intm_name_2(cnt),
      v_iss_cd_2(cnt),
      v_line_cd_2(cnt),
      v_share_type_2(cnt),
      v_acct_trty_type_2(cnt),
      0,
      USER,
      SYSDATE,
      p_iss_param);
     COMMIT;
 END IF;
 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS'));
  END;
  FUNCTION Check_Date_Policy
   /** rollie 19july2004
   *** get the dates of certain policy
   **/
   (p_param_date     NUMBER,
    p_from_date     DATE,
    p_to_date         DATE,
  p_issue_date     DATE,
   p_eff_date      DATE,
   p_acct_ent_date   DATE,
   p_spld_acct     DATE,
   p_booking_mth     GIPI_POLBASIC.booking_mth%TYPE,
   p_booking_year    GIPI_POLBASIC.booking_year%TYPE)
   RETURN NUMBER IS
     v_check_date NUMBER(1) := 0;
   BEGIN
     IF p_param_date = 1 THEN ---based on issue_date
        IF TRUNC(p_issue_date) BETWEEN p_from_date AND p_to_date THEN
           v_check_date := 1;
      END IF;
     ELSIF p_param_date = 2 THEN --based on incept_date
        IF TRUNC(p_eff_date) BETWEEN p_from_date AND p_to_date THEN
           v_check_date := 1;
        END IF;
    ELSIF p_param_date = 3 THEN --based on booking mth/yr
        IF LAST_DAY ( TO_DATE ( p_booking_mth || ',' || TO_CHAR(p_booking_year),'FMMONTH,YYYY'))
           BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date) THEN
           v_check_date := 1;
        END IF;
     ELSIF p_param_date = 4 AND p_acct_ent_date IS NOT NULL THEN --based on acct_ent_date
        IF TRUNC (p_acct_ent_date) BETWEEN p_from_date AND p_to_date THEN
           IF TRUNC (p_spld_acct) BETWEEN p_from_date AND p_to_date
        AND p_spld_acct IS NOT NULL THEN
        v_check_date := 0;
     ELSE
              v_check_date := 1;
     END IF;
        END IF;
     END IF;
     RETURN (v_check_date);
   END;
   
   PROCEDURE extract_intm_prod_colln (
      p_branch_param   NUMBER,
      p_branch_cd      gipi_polbasic.iss_cd%TYPE,
      p_line_cd        giis_line.line_cd%TYPE,
      p_intm_no        giis_intermediary.intm_no%TYPE,
      p_param_date     NUMBER,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_user_id        giis_users.user_id%TYPE,
      p_count      OUT NUMBER
   )
   IS
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
      
      DELETE FROM GIAC_INTM_PROD_COLLN_EXT
       WHERE user_id = p_user_id;
       
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
         AND (TRUNC (gp.issue_date) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy')
              OR
              DECODE (p_param_date, 1, 0, 1) = 1)
         AND (TRUNC (gp.eff_date) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy')
              OR
              DECODE (p_param_date, 2, 0, 1) = 1)
         AND (LAST_DAY (
                TO_DATE (
                  gp.booking_mth || ',' || TO_CHAR (gp.booking_year),'FMMONTH,YYYY'))
           BETWEEN LAST_DAY (TO_DATE(p_from_date, 'mm-dd-yyyy')) AND LAST_DAY (TO_DATE(p_to_date, 'mm-dd-yyyy'))
              OR
              DECODE (p_param_date, 3, 0, 1) = 1)
         AND ((TRUNC (gp.acct_ent_date) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy')
               OR
               NVL (TRUNC (gp.spld_acct_ent_date), TO_DATE(p_to_date, 'mm-dd-yyyy') + 1) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy'))
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
                                                 TO_DATE(p_from_date, 'mm-dd-yyyy'),
                                                 TO_DATE(p_to_date, 'mm-dd-yyyy')),1) = 1
         AND gp.policy_id = gci.policy_id
         AND A.par_id = gp.par_id
         AND NVL (gp.endt_type, 'A') = 'A'
         AND gp.line_cd = NVL (p_line_cd, gp.line_cd)
         AND gp.iss_cd <> Giacp.v ('RI_ISS_CD')
         AND DECODE(p_branch_param,1,NVL(gp.cred_branch,gp.iss_cd),gp.iss_cd) =
                    NVL(p_branch_cd,DECODE(p_branch_param,1,NVL(gp.cred_branch,gp.iss_cd),gp.iss_cd))
      AND Check_User_Per_Iss_Cd2(NULL,DECODE(p_branch_param,1,NVL(gp.cred_branch,gp.iss_cd),gp.iss_cd) ,'GIACS275',p_user_id) = 1         --rochelle, 10262007
      AND Check_User_Per_Line2(gp.line_cd, NULL,'GIACS275',p_user_id) = 1;             --sherwin 091407
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
             p_user_id,
       SYSDATE);
      END IF;
      --COMMIT;
      
      SELECT COUNT(*)
        INTO p_count
        FROM giac_intm_prod_colln_ext
       WHERE user_id = p_user_id; 
       
   END extract_intm_prod_colln;
   
   PROCEDURE extract_web (
       p_iss_cd       IN   VARCHAR2,
       p_intm_no      IN   VARCHAR2,
       p_line_cd      IN   VARCHAR2,
       p_date_param   IN   VARCHAR2,
       p_from_date    IN   VARCHAR2,
       p_to_date      IN   VARCHAR2,
       p_iss_param    IN   VARCHAR2,
       p_user_id      IN   VARCHAR2,
       p_count        OUT  NUMBER
    )
    IS
       TYPE v_iss_cd_tab IS TABLE OF giis_issource.iss_cd%TYPE;
       TYPE v_intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;
       TYPE v_intm_name_tab IS TABLE OF giis_intermediary.intm_name%TYPE;
       TYPE v_line_cd_tab IS TABLE OF giis_line.line_cd%TYPE;
       TYPE v_share_type_tab IS TABLE OF giis_dist_share.share_type%TYPE;
       TYPE v_acct_trty_type_tab IS TABLE OF giis_dist_share.acct_trty_type%TYPE;
       TYPE v_prem_amt_tab IS TABLE OF giuw_policyds_dtl.dist_prem%TYPE;
       v_iss_cd             v_iss_cd_tab;
       v_intm_no            v_intm_no_tab;
       v_intm_name          v_intm_name_tab;
       v_line_cd            v_line_cd_tab;
       v_share_type         v_share_type_tab;
       v_acct_trty_type     v_acct_trty_type_tab;
       v_prem_amt           v_prem_amt_tab;
       v_cred_branch        v_iss_cd_tab;
       v_iss_cd_2           v_iss_cd_tab;
       v_intm_no_2          v_intm_no_tab;
       v_intm_name_2        v_intm_name_tab;
       v_line_cd_2          v_line_cd_tab;
       v_share_type_2       v_share_type_tab;
       v_acct_trty_type_2   v_acct_trty_type_tab;
    BEGIN
       DELETE FROM gixx_intm_prod_ext
             WHERE user_id = p_user_id;

       COMMIT;

       SELECT   f.intm_no, f.intm_name,
                DECODE (p_iss_param, 1, NVL (a.cred_branch, a.iss_cd), a.iss_cd),
                a.line_cd, e.share_type, e.acct_trty_type, SUM (c.dist_prem)
       BULK COLLECT INTO v_intm_no, v_intm_name,
                v_iss_cd,
                v_line_cd, v_share_type, v_acct_trty_type, v_prem_amt
           FROM gipi_polbasic a,
                giuw_pol_dist b,
                giuw_policyds_dtl c,
                gipi_comm_invoice d,
                giis_intermediary f,
                giis_dist_share e
          WHERE 1 = 1
            AND check_date_policy (p_date_param,
                                   TO_DATE(p_from_date, 'mm-dd-yyyy'),
                                   TO_DATE(p_to_date, 'mm-dd-yyyy'),
                                   a.issue_date,
                                   a.eff_date,
                                   a.acct_ent_date,
                                   a.spld_acct_ent_date,
                                   a.booking_mth,
                                   a.booking_year
                                  ) = 1
            AND a.par_id = b.par_id
            AND b.dist_no = c.dist_no
            AND d.policy_id = a.policy_id
            AND d.intrmdry_intm_no = f.intm_no
            AND c.line_cd = e.line_cd
            AND c.share_cd = e.share_cd
            AND b.dist_flag = 3
            AND f.intm_no = NVL (p_intm_no, f.intm_no)
            AND c.line_cd = NVL (p_line_cd, a.line_cd)
            AND DECODE (p_iss_param, 1, NVL (a.cred_branch, a.iss_cd), a.iss_cd) =
                   NVL (p_iss_cd,
                        DECODE (p_iss_param,
                                1, NVL (a.cred_branch, a.iss_cd),
                                a.iss_cd
                               )
                       )
    /*commented out and changed by reymon 05252012
       AND Check_User_Per_Iss_Cd2(NULL,DECODE(p_iss_param,1,NVL(A.cred_branch,A.iss_cd),A.iss_cd),'GIACS275',USER) = 1     --rochelle, 10262007
       AND Check_User_Per_Line2(A.line_cd,NULL,'GIACS275',USER) = 1       --sherwin 091407*/
            AND check_user_per_iss_cd_acctg2 (NULL, DECODE (p_iss_param, 1, NVL (a.cred_branch, a.iss_cd), a.iss_cd), 'GIACS235', p_user_id) = 1
       GROUP BY f.intm_no,
                f.intm_name,
                DECODE (p_iss_param, 1, NVL (a.cred_branch, a.iss_cd), a.iss_cd),
                a.line_cd,
                e.share_type,
                e.acct_trty_type;

       IF SQL%FOUND
       THEN
          FORALL cnt IN v_intm_no.FIRST .. v_intm_no.LAST
             INSERT INTO gixx_intm_prod_ext
                         (intm_cd, intm_name, iss_cd,
                          line_cd, share_type,
                          acct_trty_type, prem_amt, user_id,
                          last_update, iss_param
                         )
                  VALUES (v_intm_no (cnt), v_intm_name (cnt), v_iss_cd (cnt),
                          v_line_cd (cnt), v_share_type (cnt),
                          v_acct_trty_type (cnt), v_prem_amt (cnt), p_user_id,
                          SYSDATE, p_iss_param
                         );
          COMMIT;
       END IF;

--       DBMS_OUTPUT.put_line (TO_CHAR (SYSDATE, 'HH:MI:SS'));

    /** rollie 17JAN2005
     getting the dummy data needed for the report**/
       SELECT DISTINCT f.intm_no, f.intm_name, a.iss_cd, c.line_cd,
                       b.share_type,
                       DECODE (share_type, '2', b.acct_trty_type, NULL)
                                                                   acct_trty_type
       BULK COLLECT INTO v_intm_no_2, v_intm_name_2, v_iss_cd_2, v_line_cd_2,
                       v_share_type_2,
                       v_acct_trty_type_2
                  FROM giis_intermediary f,
                       giis_issource a,
                       giis_line c,
                       (SELECT DISTINCT b.trty_lname share_name_title,
                                        share_type share_type,
                                        DECODE (share_type,
                                                '2', a.acct_trty_type,
                                                NULL
                                               ) acct_trty_type
                                   FROM giis_dist_share a, giis_ca_trty_type b
                                  WHERE a.acct_trty_type = b.ca_trty_type
                                    AND share_type = '2'
                        UNION ALL
                        SELECT UPPER (rv_meaning) share_name_title,
                               rv_low_value share_type, NULL
                          FROM cg_ref_codes
                         WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE'
                           AND rv_low_value <> '2') b
                 WHERE 1 = 1
                   AND NOT EXISTS (
                          SELECT 'X'
                            FROM gixx_intm_prod_ext z
                           WHERE f.intm_no = z.intm_cd
                             AND a.iss_cd = z.iss_cd
                             AND c.line_cd = z.line_cd
                             AND b.share_type = z.share_type
                             AND NVL (b.acct_trty_type, 99) =
                                                        NVL (z.acct_trty_type, 99)
                             AND user_id = p_user_id)
                   AND EXISTS (
                          SELECT 'Y'
                            FROM gixx_intm_prod_ext z
                           WHERE f.intm_no = z.intm_cd
                             AND a.iss_cd = z.iss_cd
                             AND c.line_cd = z.line_cd
                             AND user_id = p_user_id);

       IF SQL%FOUND
       THEN
          FORALL cnt IN v_intm_no_2.FIRST .. v_intm_no_2.LAST
             INSERT INTO gixx_intm_prod_ext
                         (intm_cd, intm_name,
                          iss_cd, line_cd,
                          share_type, acct_trty_type, prem_amt,
                          user_id, last_update, iss_param
                         )
                  VALUES (v_intm_no_2 (cnt), v_intm_name_2 (cnt),
                          v_iss_cd_2 (cnt), v_line_cd_2 (cnt),
                          v_share_type_2 (cnt), v_acct_trty_type_2 (cnt), 0,
                          p_user_id, SYSDATE, p_iss_param
                         );
--          COMMIT;
       END IF;
       
       SELECT COUNT(*)
         INTO p_count
         FROM gixx_intm_prod_ext
        WHERE user_id = p_user_id; 
       
    END extract_web;
   
END P_Intm_Prod;
/


