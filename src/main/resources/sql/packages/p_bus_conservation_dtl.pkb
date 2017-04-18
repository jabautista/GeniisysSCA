CREATE OR REPLACE PACKAGE BODY CPI.P_Bus_Conservation_Dtl AS
  PROCEDURE get_data(
    p_line_cd     IN VARCHAR2,
    p_subline_cd  IN VARCHAR2,
    p_iss_cd      IN VARCHAR2,
    p_intm_no     IN NUMBER,
 p_from_date   IN DATE,
    p_to_date     IN DATE,
 p_del_table   IN VARCHAR2)
  AS
    TYPE line_tab        IS TABLE OF gipi_polbasic.line_cd%TYPE;
 TYPE subline_tab   IS TABLE OF gipi_polbasic.subline_cd%TYPE;
 TYPE iss_tab        IS TABLE OF gipi_polbasic.iss_cd%TYPE;
 TYPE issue_yy_tab    IS TABLE OF gipi_polbasic.issue_yy%TYPE;
 TYPE pol_seq_no_tab  IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;
 TYPE renew_tab      IS TABLE OF gipi_polbasic.renew_no%TYPE;
 TYPE policy_tab      IS TABLE OF giex_ren_ratio_dtl.policy_id%TYPE;
 TYPE prem_tab      IS TABLE OF giex_ren_ratio_dtl.prem_amt%TYPE;
 TYPE assd_tab     IS TABLE OF giex_ren_ratio_dtl.assd_no%TYPE;
 TYPE intm_tab      IS TABLE OF giex_ren_ratio_dtl.intm_no%TYPE;
 TYPE exp_month_tab  IS TABLE OF giex_ren_ratio_dtl.MONTH%TYPE;
 TYPE exp_year_tab  IS TABLE OF giex_ren_ratio_dtl.YEAR%TYPE;
 TYPE renewal_tab  IS TABLE OF giex_ren_ratio_dtl.renewal_tag%TYPE;
 TYPE region_tab   IS TABLE OF giex_ren_ratio_dtl.region_cd%TYPE;
 TYPE pol_flag_tab  IS TABLE OF gipi_polbasic.pol_flag%TYPE;
 TYPE renew_prem_tab  IS TABLE OF gipi_polbasic.prem_amt%TYPE;
 vv_line_cd   line_tab;
 vv_subline_cd  subline_tab;
 vv_iss_cd   iss_tab;
 vv_issue_yy   issue_yy_tab;
 vv_pol_seq_no  pol_seq_no_tab;
 vv_renew_no   renew_tab;
 vv_policy_id  policy_tab;
 vv_prem_amt      prem_tab;
 vv_assd_no   assd_tab;
 vv_intm_no   intm_tab;
 vv_exp_month  exp_month_tab;
 vv_exp_year   exp_year_tab;
 vv_renewal_tag   renewal_tab;
 vv_region_cd  region_tab;
    vv_renew_prem    renew_prem_tab;
 v_ri_cd       gipi_polbasic.iss_cd%TYPE;
 v_count    NUMBER;
 vv_expiry_year  exp_year_tab;
 vv_expiry_month  exp_month_tab;
 vv_pol_flag      pol_flag_tab ;
  BEGIN
    v_ri_cd := Giisp.v('ISS_CD_RI');
 IF v_ri_cd IS NULL THEN
       RAISE_APPLICATION_ERROR(2220,INITCAP('RI CODE HAS NOT BEEN SET UP IN GIIS_PARAMETERS.'));
    END IF;
 /* getting template for list of expired policy */
 SELECT /*+ INDEX (x POLBASIC_U1) */ DISTINCT
        x.line_cd,
     x.subline_cd,
     x.iss_cd,
     x.issue_yy,
     x.pol_seq_no,
     x.renew_no,
     TO_CHAR(x.expiry_date,'YYYY') expiry_year,
     TO_CHAR(x.expiry_date,'MM') expiry_month
    BULK COLLECT INTO
        vv_line_cd,
     vv_subline_cd,
     vv_iss_cd,
     vv_issue_yy,
     vv_pol_seq_no,
     vv_renew_no,
     vv_expiry_year,
     vv_expiry_month
   FROM gipi_polbasic x
  WHERE trunc(x.expiry_date) BETWEEN p_from_date AND p_to_date   -- aaron 021708
    AND x.iss_cd <> v_ri_cd
    AND endt_seq_no = (SELECT /*+ INDEX (a POLBASIC_U1) */ MAX(endt_seq_no) endt_seq_no
                         FROM gipi_polbasic a
                           WHERE a.line_cd    = x.line_cd
                             AND a.subline_cd = x.subline_cd
                             AND a.iss_cd     = x.iss_cd
                             AND a.issue_yy   = x.issue_yy
                             AND a.pol_seq_no = x.pol_seq_no
                             AND a.renew_no   = x.renew_no);
  --commented by Jerome Sept 25, 2006 - for optimization, replaced with subquery above - Get_Endt_Seq_No(line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no);
  IF NOT SQL%NOTFOUND THEN
    IF p_del_table = 'Y' THEN /* Y = delete old records of giex_ren_ratio_dtl
                 N = additional records for giex_ren_ratio_dtl*/
    DELETE FROM giex_ren_ratio_dtl
         WHERE user_id = USER;
      COMMIT;
    DELETE FROM expiry_polbasic
         WHERE user_id = USER;
          FORALL cnt IN vv_line_cd.FIRST..vv_line_cd.LAST
         INSERT INTO expiry_polbasic
        (line_cd,      subline_cd,    iss_cd,
      issue_yy,     pol_seq_no,    renew_no,
      expiry_year,       expiry_month,    user_id, last_update)
      VALUES
        (vv_line_cd(cnt),   vv_subline_cd(cnt),   vv_iss_cd(cnt),
      vv_issue_yy(cnt),   vv_pol_seq_no(cnt),   vv_renew_no(cnt),
      vv_expiry_year(cnt), vv_expiry_month(cnt), USER, SYSDATE);
     ELSE
       DELETE FROM expiry_polbasic_retro
         WHERE user_id = USER;
          FORALL cnt IN vv_line_cd.FIRST..vv_line_cd.LAST
         INSERT INTO expiry_polbasic_retro
        (line_cd,      subline_cd,    iss_cd,
      issue_yy,     pol_seq_no,    renew_no,
      expiry_year,    expiry_month,    user_id,last_update)
      VALUES
        (vv_line_cd(cnt),   vv_subline_cd(cnt),   vv_iss_cd(cnt),
      vv_issue_yy(cnt),   vv_pol_seq_no(cnt),   vv_renew_no(cnt),
      vv_expiry_year(cnt), vv_expiry_month(cnt), USER, SYSDATE);
     END IF;
   END IF;
  COMMIT;
    DBMS_OUTPUT.PUT_LINE('START TEMP END:'||TO_CHAR(SYSDATE,'HH:MM:SS'));
 IF p_del_table = 'Y' THEN
    SELECT DISTINCT a.line_cd          line_cd,
          a.subline_cd       subline_cd,
        a.iss_cd           iss_cd,
     a.issue_yy         issue_yy,
     a.pol_seq_no       pol_seq_no,
     a.renew_no         renew_no,
             a.policy_id        policy_id,
     a.prem_amt    prem_amt,
        c.assd_no    assd_no,
        d.intrmdry_intm_no intm_no,
           get_renew_tag(a.policy_id)  renewal_tag,
        NVL(a.region_cd,e.region_cd),
    --    TO_NUMBER(f.expiry_year),
    --    TO_NUMBER(f.expiry_month),
        get_expiry_year(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
         a.pol_seq_no, a.renew_no),
         get_expiry_month(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
               a.pol_seq_no, a.renew_no),
        a.pol_flag,
     get_prem_of_renew(a.line_cd,a.subline_cd,
                       a.iss_cd,a.issue_yy,
           a.pol_seq_no, a.renew_no) renew_prem
        BULK COLLECT INTO
           vv_line_cd,
        vv_subline_cd,
        vv_iss_cd,
     vv_issue_yy,
     vv_pol_seq_no,
     vv_renew_no,
           vv_policy_id,
        vv_prem_amt,
        vv_assd_no,
        vv_intm_no,
        vv_renewal_tag,
        vv_region_cd,
        vv_exp_year,
        vv_exp_month,
     vv_pol_flag,
     vv_renew_prem
         FROM gipi_polbasic a,
              giis_subline b,
        gipi_parlist c,
        gipi_comm_invoice d,
        giis_issource e,
        expiry_polbasic f
        WHERE 1 = 1
       AND a.line_cd     = f.line_cd
          AND a.subline_cd  = f.subline_cd
       AND a.iss_cd      = f.iss_cd
       AND a.issue_yy    = f.issue_yy
       AND a.pol_seq_no  = f.pol_seq_no
       AND a.renew_no    = f.renew_no
       AND f.user_id     = USER
      -- AND a.pol_flag    IN ('1','2','3')
   AND a.pol_flag  NOT  IN ('4','5')
         -- AND a.iss_cd      <> 'RI'
          AND a.endt_seq_no = 0
          AND a.expiry_tag  = 'N'
          AND b.op_flag     = 'N'
          AND a.line_cd     = b.line_cd
       AND a.subline_cd  = b.subline_cd
       AND a.par_id      = c.par_id
       AND d.iss_cd  = a.iss_cd
       AND a.iss_cd      = e.iss_cd
       AND d.policy_id   = a.policy_id
       AND a.line_cd     = NVL(p_line_cd,a.line_cd)
       AND b.subline_cd  = NVL(p_subline_cd,b.subline_cd)
       AND a.iss_cd      = NVL(p_iss_cd,a.iss_cd)
       AND d.intrmdry_intm_no = NVL(p_intm_no,d.intrmdry_intm_no);
 ELSE
    SELECT a.line_cd          line_cd,
       a.subline_cd       subline_cd,
        a.iss_cd           iss_cd,
        a.issue_yy         issue_yy,
     a.pol_seq_no       pol_seq_no,
     a.renew_no         renew_no,
          a.policy_id        policy_id,
           a.prem_amt       prem_amt,
     c.assd_no    assd_no,
     d.intrmdry_intm_no intm_no,
        get_renew_tag(a.policy_id)  renewal_tag,
      NVL(a.region_cd,e.region_cd),
  --    TO_NUMBER(f.expiry_year),
  --    TO_NUMBER(f.expiry_month),
         get_expiry_year(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
         a.pol_seq_no, a.renew_no),
          get_expiry_month(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
               a.pol_seq_no, a.renew_no),
      a.pol_flag,
         get_prem_of_renew(a.line_cd,a.subline_cd,
                        a.iss_cd,a.issue_yy,
            a.pol_seq_no, a.renew_no) renew_prem
   BULK COLLECT INTO
         vv_line_cd,
      vv_subline_cd,
      vv_iss_cd,
         vv_issue_yy,
      vv_pol_seq_no,
      vv_renew_no,
         vv_policy_id,
      vv_prem_amt,
      vv_assd_no,
      vv_intm_no,
      vv_renewal_tag,
      vv_region_cd,
      vv_exp_year,
      vv_exp_month,
      vv_pol_flag,
      vv_renew_prem
      FROM gipi_polbasic a,
            giis_subline b,
      gipi_parlist c,
      gipi_comm_invoice d,
      giis_issource e,
      expiry_polbasic_retro f
      WHERE 1 = 1
     AND a.line_cd     = f.line_cd
        AND a.subline_cd  = f.subline_cd
     AND a.iss_cd      = f.iss_cd
     AND a.issue_yy    = f.issue_yy
     AND a.pol_seq_no  = f.pol_seq_no
     AND a.renew_no    = f.renew_no
     AND f.user_id     = USER
--     AND a.pol_flag IN ('1','2','3')
     AND a.pol_flag  NOT  IN ('4','5')
--        AND a.iss_cd     <> 'RI'
        AND a.endt_seq_no = 0
        AND a.expiry_tag  = 'N'
        AND b.op_flag     = 'N'
        AND a.line_cd     = b.line_cd
     AND a.subline_cd  = b.subline_cd
     AND a.par_id      = c.par_id
     AND d.iss_cd   = a.iss_cd
     AND a.iss_cd      = e.iss_cd
     AND d.policy_id   = a.policy_id
     AND a.line_cd     = NVL(p_line_cd,a.line_cd)
     AND b.subline_cd  = NVL(p_subline_cd,b.subline_cd)
     AND a.iss_cd      = NVL(p_iss_cd,a.iss_cd)
     AND d.intrmdry_intm_no = NVL(p_intm_no,d.intrmdry_intm_no);
    END IF;
 IF NOT SQL%NOTFOUND THEN
       FORALL cnt IN vv_line_cd.FIRST..vv_line_cd.LAST
    INSERT INTO giex_ren_ratio_dtl
      (line_cd,      subline_cd,    iss_cd,
    issue_yy,            pol_seq_no,         renew_no,
    policy_id,     prem_amt,     assd_no,
    intm_no,         MONTH,      YEAR,
    renewal_tag,        user_id,        last_update,
    region_cd,     pol_flag,           prem_renew_amt)
    VALUES
      (vv_line_cd(cnt),   vv_subline_cd(cnt), vv_iss_cd(cnt),
    vv_issue_yy(cnt),    vv_pol_seq_no(cnt), vv_renew_no(cnt),
    vv_policy_id(cnt),   vv_prem_amt(cnt),   vv_assd_no(cnt),
    vv_intm_no(cnt),     vv_exp_month(cnt),  vv_exp_year(cnt)  ,
    vv_renewal_tag(cnt), USER,      SYSDATE,
    vv_region_cd(cnt),   vv_pol_flag(cnt),   vv_renew_prem(cnt));
 END IF;
 COMMIT;
  DBMS_OUTPUT.PUT_LINE('FINISH :'||TO_CHAR(SYSDATE,'HH:MM:SS'));
  END;
  FUNCTION get_renew_tag(
  /** rollie 24 june 2004
  *** validates if policy is renewed
  **/
   p_policy_id     gipi_polbasic.policy_id%TYPE)
  RETURN VARCHAR2 AS
    v_renew_tag   VARCHAR2(1):= 'N';
  BEGIN
    FOR a IN (
   SELECT 'RENEWED'
     FROM gipi_polnrep b
    WHERE b.old_policy_id = p_policy_id)
 LOOP
   v_renew_tag := 'Y';
 END LOOP;
 RETURN (v_renew_tag);
  END;
  FUNCTION Check_Date(
  /** rollie 18 Feb 2004
  *** date parameter of the last endorsement of policy
  *** must not be within the date given, else it will
  *** be exluded
  **/
 p_line_cd     gipi_polbasic.line_cd%TYPE,
 p_subline_cd gipi_polbasic.subline_cd%TYPE,
    p_iss_cd     gipi_polbasic.iss_cd%TYPE,
 p_issue_yy     gipi_polbasic.issue_yy%TYPE,
 p_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
 p_renew_no     gipi_polbasic.renew_no%TYPE,
 p_from_date     DATE,
 p_to_date     DATE)
  RETURN DATE AS
   v_check_date  DATE;
  BEGIN
 FOR a IN (
      SELECT a.expiry_date expiry_date
        FROM gipi_polbasic a
    WHERE a.line_cd     = p_line_cd
      AND a.subline_cd  = p_subline_cd
       AND a.iss_cd      = p_iss_cd
      AND a.issue_yy    = p_issue_yy
      AND a.pol_seq_no  = p_pol_seq_no
      AND a.renew_no    = p_renew_no
      AND a.endt_seq_no = (SELECT MAX(b.endt_seq_no)
                          FROM gipi_polbasic b
           WHERE a.line_cd     = b.line_cd
             AND a.subline_cd  = b.subline_cd
               AND a.iss_cd      = b.iss_cd
              AND a.issue_yy    = b.issue_yy
              AND a.pol_seq_no  = b.pol_seq_no
              AND a.renew_no    = b.renew_no))
      LOOP
  v_check_date := a.expiry_date;
  EXIT;
      END LOOP;
   RETURN v_check_date;
  END;
  FUNCTION get_expiry_year(
  /** rollie 15 june 2004
  *** get the expiry month of latest endt
  **/
 p_line_cd     gipi_polbasic.line_cd%TYPE,
 p_subline_cd gipi_polbasic.subline_cd%TYPE,
    p_iss_cd     gipi_polbasic.iss_cd%TYPE,
 p_issue_yy     gipi_polbasic.issue_yy%TYPE,
 p_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
 p_renew_no     gipi_polbasic.renew_no%TYPE)
  RETURN NUMBER AS
   v_year          NUMBER(4):=0;
  BEGIN
    FOR a IN (
   SELECT TO_NUMBER(TO_CHAR(a.expiry_date,'YYYY')) expiry_date
--     INTO v_year
        FROM gipi_polbasic a
    WHERE a.line_cd     = p_line_cd
      AND a.subline_cd  = p_subline_cd
       AND a.iss_cd      = p_iss_cd
      AND a.issue_yy    = p_issue_yy
      AND a.pol_seq_no  = p_pol_seq_no
      AND a.renew_no    = p_renew_no
      AND a.endt_seq_no = (SELECT MAX(b.endt_seq_no)
                          FROM gipi_polbasic b
          WHERE a.line_cd     = b.line_cd
            AND a.subline_cd  = b.subline_cd
              AND a.iss_cd      = b.iss_cd
             AND a.issue_yy    = b.issue_yy
             AND a.pol_seq_no  = b.pol_seq_no
             AND a.renew_no    = b.renew_no))
 LOOP
   v_year := a.expiry_date;
   EXIT;
 END LOOP;
    RETURN v_year;
  END;
  FUNCTION get_expiry_month(
  /** rollie 15 june 2004
  *** get the expiry month of latest endt
  **/
 p_line_cd     gipi_polbasic.line_cd%TYPE,
 p_subline_cd gipi_polbasic.subline_cd%TYPE,
    p_iss_cd     gipi_polbasic.iss_cd%TYPE,
 p_issue_yy     gipi_polbasic.issue_yy%TYPE,
 p_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
 p_renew_no     gipi_polbasic.renew_no%TYPE)
  RETURN NUMBER AS
   v_month          NUMBER(2):=0;
  BEGIN
    FOR a IN (
   SELECT TO_NUMBER(TO_CHAR(a.expiry_date,'MM'))   expiry_date
--        INTO v_year
     FROM gipi_polbasic a
    WHERE a.line_cd     = p_line_cd
      AND a.subline_cd  = p_subline_cd
       AND a.iss_cd      = p_iss_cd
      AND a.issue_yy    = p_issue_yy
      AND a.pol_seq_no  = p_pol_seq_no
      AND a.renew_no    = p_renew_no
      AND a.endt_seq_no = (SELECT MAX(b.endt_seq_no)
                          FROM gipi_polbasic b
          WHERE a.line_cd     = b.line_cd
            AND a.subline_cd  = b.subline_cd
              AND a.iss_cd      = b.iss_cd
             AND a.issue_yy    = b.issue_yy
             AND a.pol_seq_no  = b.pol_seq_no
             AND a.renew_no    = b.renew_no))
    LOOP
   v_month := a.expiry_date;
   EXIT;
 END LOOP;
    RETURN v_month;
  END;
  FUNCTION get_prem_of_renew(
  /* rollie 21 june 2004
  ** to get the prem of policy if it is renewed
  **/
   p_line_cd     gipi_polbasic.line_cd%TYPE,
 p_subline_cd gipi_polbasic.subline_cd%TYPE,
    p_iss_cd     gipi_polbasic.iss_cd%TYPE,
 p_issue_yy     gipi_polbasic.issue_yy%TYPE,
 p_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
 p_renew_no      gipi_polbasic.renew_no%TYPE)
  RETURN NUMBER AS
    v_prem_renew NUMBER(18,2) := 0;
  BEGIN
   SELECT SUM(a.prem_amt)
   INTO v_prem_renew
      FROM gipi_polbasic a
     WHERE a.policy_id IN (SELECT b.new_policy_id
                       FROM gipi_polnrep b, gipi_polbasic c
                WHERE b.old_policy_id = c.policy_id
         AND c.line_cd     = p_line_cd
         AND c.subline_cd  = p_subline_cd
         AND c.iss_cd      = p_iss_cd
         AND c.issue_yy    = p_issue_yy
         AND c.pol_seq_no  = p_pol_seq_no
         AND c.renew_no    = p_renew_no)
  AND pol_flag NOT IN ('4','5');    --added BY GMI 09/26/06
 RETURN v_prem_renew;
  END;
  FUNCTION Get_Endt_Seq_No(
    /** rollie 02/18/04
    *** get the latest endorsement number of a policy
    **/
    p_line_cd     gipi_polbasic.line_cd%TYPE,
    p_subline_cd  gipi_polbasic.subline_cd%TYPE,
    p_iss_cd      gipi_polbasic.iss_cd%TYPE,
 p_issue_yy    gipi_polbasic.issue_yy%TYPE,
 p_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE,
 p_renew_no    gipi_polbasic.renew_no%TYPE)
  RETURN NUMBER AS
    v_endt_seq_no gipi_polbasic.endt_seq_no%TYPE;
  BEGIN
    FOR a IN (
   SELECT endt_seq_no
        FROM gipi_polbasic a
       WHERE a.line_cd    = p_line_cd
         AND a.subline_cd = p_subline_cd
         AND a.iss_cd     = p_iss_cd
         AND a.issue_yy   = p_issue_yy
         AND a.pol_seq_no = p_pol_seq_no
         AND a.renew_no   = p_renew_no)
 LOOP
   v_endt_seq_no := a.endt_seq_no;
 END LOOP;
    RETURN (v_endt_seq_no);
  END;
END;
/


DROP PACKAGE BODY CPI.P_BUS_CONSERVATION_DTL;

