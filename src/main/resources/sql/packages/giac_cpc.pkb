CREATE OR REPLACE PACKAGE BODY CPI.Giac_Cpc
/*
|| Major Modifications (when, who, what):
|| 10/18/200 - RLU - Create package body (this procedures used to be a program unit in forms)
||
*/
AS
/* ----------------------------- PRIVATE MODULES ----------------------------- */
  v_cut_off_dt   DATE;
  v_start_dt     DATE;
  /* ---------- function returns the first day of the year ---------- */
  FUNCTION first_of_year(v_tran_year NUMBER)
  RETURN DATE
  IS
    v_first   DATE;
  BEGIN
     v_first := trunc(to_date(v_tran_year,'YYYY'),'YEAR');
     RETURN(v_first);
  END first_of_year;
  /* ---------- function returns the last day of the year ---------- */
  FUNCTION last_of_year(v_tran_year NUMBER)
  RETURN DATE
  IS
    v_last     DATE;
  BEGIN
    v_last := add_months(trunc(to_date(v_tran_year,'YYYY'),'YEAR')-1,12);
    RETURN(v_last);
  END last_of_year;
  /* ---------- procedure populates required parameter dates ---------- */
  PROCEDURE get_dates(v_tran_year NUMBER) IS
  BEGIN
     v_cut_off_dt := last_of_year(v_tran_year);
     v_start_dt   := first_of_year(v_tran_year);
  END get_dates;
/* ----------------------------- PUBLIC MODULES ----------------------------- */
/* ---------- Populates the losses paid extract table ---------- */
PROCEDURE loss_pd_ext  (v_tran_year  IN   giac_loss_pd_ext.tran_year%TYPE)
IS
  BEGIN
     get_dates(v_tran_year);
     DELETE FROM giac_loss_pd_ext
      WHERE tran_year = v_tran_year;
     INSERT INTO giac_loss_pd_ext
     (intm_no,          line_cd,         claim_id,
      policy_id,        assd_no,         loss_pd,
      loss_exp_pd,      check_date,      check_pref_suf,
      check_no,         tran_year
     )
    SELECT a.intrmdry_intm_no,        b.line_cd,
           c.claim_id,                b.policy_id,
           i.assd_no,                 decode(d.e200_exp_cd,'00',d.disbursement_amt,0),
           decode(d.e200_exp_cd,'00',0,d.disbursement_amt),
           e.check_date,              e.check_pref_suf,
           e.check_no, v_tran_year
      FROM gipi_comm_invoice a,
           gipi_polbasic     b,
           gicl_claims       c,
           giac_direct_claim_payts d,
           giac_disb_vouchers e,
           giac_acctrans f,
           giis_line g,
           giis_intermediary h,
           gipi_parlist i
     WHERE a.policy_id = b.policy_id
       AND b.par_id    = i.par_id
       AND b.policy_id = c.policy_id
       AND c.claim_id  = d.claim_id
       AND d.gacc_tran_id = e.gacc_tran_id
       AND d.gacc_tran_id = f.tran_id
       AND f.tran_flag <> 'D'
       AND d.gacc_tran_id NOT IN (SELECT a.gacc_tran_id
  	       		            FROM giac_reversals a, giac_acctrans b
			           WHERE a.reversing_tran_id = b.tran_id
				     AND b.tran_flag         <> 'D')
       AND trunc(e.check_date) >= v_start_dt --TO_DATE('01-JAN-1999','DD-MON-YYYY')
       AND trunc(e.check_date) <= v_cut_off_dt  --TO_DATE('31-DEC-1999','DD-MON-YYYY')
       AND b.line_cd = g.line_cd
       AND g.prof_comm_tag = 'Y'
       AND a.intrmdry_intm_no = h.intm_no
       AND h.lic_tag = 'Y';
  END loss_pd_ext;
/* ---------- Populates the losses reserve extract table ---------- */
PROCEDURE loss_res_ext (v_tran_year   IN giac_loss_res_ext.tran_year%TYPE)
IS
 v_tot_amt        gicl_claims.loss_res_amt%TYPE := 0;
 v_loss_res_amt   gicl_claims.loss_res_amt%TYPE := 0;
 v_exist	  VARCHAR2(1) := 'N';
 CURSOR loss_res(v_cut_off_dt DATE) IS
    SELECT DISTINCT a.intrmdry_intm_no,
           b.line_cd,
           c.loss_res_amt,
           e.check_date,
           c.claim_id,
	   b.policy_id,
           i.assd_no,
	   c.clm_file_date
      FROM gipi_comm_invoice a,
           gipi_polbasic     b,
           gicl_claims       c,
           giac_direct_claim_payts d,
           giac_disb_vouchers e,
           giac_acctrans f,
           giis_line g,
           giis_intermediary h,
  	   gipi_parlist i
     WHERE a.policy_id    = b.policy_id
       AND b.par_id       = i.par_id
       AND b.policy_id    = c.policy_id
       AND c.claim_id     = d.claim_id
       AND d.gacc_tran_id = e.gacc_tran_id
       AND d.gacc_tran_id = f.tran_id
       AND f.tran_flag    <> 'D'
       AND d.gacc_tran_id NOT IN (
              			SELECT a.gacc_tran_id
                		FROM 	giac_reversals a,
                     			giac_acctrans  b
               			WHERE a.reversing_tran_id = b.tran_id
         			AND b.tran_flag         <> 'D')
       AND trunc(e.check_date)    >= v_cut_off_dt --TO_DATE('31-DEC-1999','DD-MON-YYYY')
       AND trunc(c.clm_file_date) <= v_cut_off_dt --TO_DATE('31-DEC-1999','DD-MON-YYYY')
       AND b.line_cd               = g.line_cd
       AND g.prof_comm_tag         = 'Y'
       AND a.intrmdry_intm_no      = h.intm_no
       AND h.lic_tag               = 'Y'
     ORDER BY 1,2,3;
 CURSOR disb_res (v_start_dt   DATE,
                  v_cut_off_dt DATE,
                  v_claim_id   gicl_claims.claim_id%TYPE ) IS
      SELECT d.disbursement_amt
        FROM gipi_comm_invoice a,
             gipi_polbasic     b,
             gicl_claims       c,
             giac_direct_claim_payts d,
             giac_disb_vouchers e,
             giac_acctrans f,
             giis_line g,
             giis_intermediary h
       WHERE a.policy_id = b.policy_id
         AND b.policy_id = c.policy_id
         AND c.claim_id  = d.claim_id
         AND d.gacc_tran_id = e.gacc_tran_id
         AND d.gacc_tran_id = f.tran_id
         AND f.tran_flag <> 'D'
         AND d.gacc_tran_id NOT IN (SELECT a.gacc_tran_id
                                    FROM giac_reversals a, giac_acctrans b
                                    WHERE a.reversing_tran_id = b.tran_id
                                    AND b.tran_flag <> 'D')
         AND trunc(e.check_date) >= v_start_dt -- TO_DATE('01-JAN-1999','DD-MON-YYYY')
         AND trunc(e.check_date) <= v_cut_off_dt --TO_DATE('31-DEC-1999','DD-MON-YYYY')
         AND b.line_cd = g.line_cd
         AND g.prof_comm_tag = 'Y'
         AND a.intrmdry_intm_no = h.intm_no
         AND h.lic_tag = 'Y'
         AND c.claim_id = v_claim_id;
 CURSOR exist_res (v_intrmdry_intm_no giis_intermediary.intm_no%TYPE,
                   v_line_cd          giis_line.line_cd%TYPE,
                   v_claim_id         gicl_claims.claim_id%TYPE) IS
        SELECT 'a'
          FROM giac_loss_res_ext
         WHERE intm_no  = v_intrmdry_intm_no
           AND line_cd  = v_line_cd
           AND claim_id = v_claim_id;
    v_count NUMBER;
  BEGIN
     get_dates(v_tran_year);
     DELETE FROM giac_loss_res_ext
      WHERE tran_year = v_tran_year;
     FOR loss IN loss_res(v_cut_off_dt)
     LOOP
        FOR disb IN disb_res(v_start_dt, v_cut_off_dt, loss.claim_id)
        LOOP
           v_tot_amt   := nvl(v_tot_amt,0) + nvl(disb.disbursement_amt,0);
        END LOOP disb;
        v_loss_res_amt   :=  nvl(loss.loss_res_amt,0) - nvl(v_tot_amt,0);
        FOR exist IN exist_res(loss.intrmdry_intm_no, loss.line_cd, loss.claim_id)
        LOOP
           v_exist := 'Y';
        END LOOP;
        IF v_exist = 'N'
        THEN
           INSERT INTO  giac_loss_res_ext (
              intm_no,	       	line_cd,	claim_id,
              policy_id, 	assd_no,	loss_reserve,
              date_filed,	cut_off_dt,     tran_year)
           VALUES (
              loss.intrmdry_intm_no, loss.line_cd,   loss.claim_id,
              loss.policy_id,	    loss.assd_no,    v_loss_res_amt,
              loss.clm_file_date,    v_cut_off_dt,   v_tran_year);
        ELSE
           v_exist := 'N';
        END IF;
        v_loss_res_amt   := 0;
        v_tot_amt        := 0;
     END LOOP loss;
  END loss_res_ext;
/* ---------- Populates the premiums paid extract table ---------- */
PROCEDURE prem_pd_ext (v_tran_year IN giac_prem_pd_ext.tran_year%TYPE)
IS
  GO             VARCHAR2(1);
  prof_basic     NUMBER(25,9) := 0;
  prof_allied    NUMBER(25,9) := 0;
  v_line_cd      giis_line.line_cd%TYPE;
  ws_intm        NUMBER(9);
  policy         VARCHAR2(50);
  i_date         DATE;
  e_date         DATE;
  v_delete       VARCHAR2(1) := 'N';
  CURSOR one(v_tran_year giac_prem_pd_ext.tran_year%TYPE)
  IS
    SELECT a.policy_id,
           a.a150_line_cd line_cd,
           a.a020_assd_no assd_no,
           max(a.full_paid_dt) paydate
      FROM giac_aging_soa_details a
     WHERE EXISTS (SELECT 'x'
                     FROM giis_line b,
                          giis_subline c
                    WHERE b.line_cd = c.line_cd
                      AND b.line_cd = a.a150_line_cd
                      AND b.prof_comm_tag = 'Y'
                      AND c.prof_comm_tag = 'Y')
     GROUP BY a.policy_id,
           a.a150_line_cd,
           a.a020_assd_no
    HAVING to_char(max(full_paid_dt),'yyyy') = v_tran_year
       AND sum(balance_amt_due) = 0;
  CURSOR three(v_policy_id gipi_polbasic.policy_id%TYPE)
  IS
     SELECT a.intrmdry_intm_no intm,
            b.lic_tag
       FROM gipi_comm_invoice a,
            giis_intermediary b
      WHERE a.policy_id = v_policy_id
        AND a.intrmdry_intm_no = b.intm_no;
  CURSOR four (v_policy_id  gipi_polbasic.policy_id%TYPE,
               v_ws_intm_no giis_intermediary.intm_no%TYPE,
               v_line_cd    giis_line.line_cd%TYPE)
  IS
    SELECT a.peril_cd,
           sum(a.premium_amt) premium,
           b.prof_comm_tag
      FROM gipi_comm_inv_peril a,
           giis_peril b
     WHERE a.policy_id = v_policy_id
       AND a.intrmdry_intm_no = v_ws_intm_no
       AND a.peril_cd  = b.peril_cd
       AND b.line_cd = v_line_cd
     GROUP BY a.peril_cd,
           b.prof_comm_tag;
  FUNCTION get_incept_date (v_policy_id gipi_polbasic.policy_id%TYPE)
  RETURN DATE
  IS
     v_incept_date   DATE;
  BEGIN
     FOR rec IN (SELECT incept_date
                   FROM gipi_polbasic
                  WHERE policy_id = v_policy_id)
     LOOP
        v_incept_date := rec.incept_date;
        EXIT;
     END LOOP rec;
     RETURN(v_incept_date);
  END get_incept_date;
  FUNCTION get_expiry_date (v_policy_id gipi_polbasic.policy_id%TYPE)
  RETURN DATE
  IS
     v_expiry_date   DATE;
  BEGIN
     FOR rec IN (SELECT expiry_date
                   FROM gipi_polbasic
                  WHERE policy_id = v_policy_id)
     LOOP
        v_expiry_date := rec.expiry_date;
        EXIT;
     END LOOP rec;
     RETURN(v_expiry_date);
  END get_expiry_date;
BEGIN
  DELETE FROM giac_prem_pd_ext
   WHERE tran_year = v_tran_year;
  FOR j IN one(v_tran_year)
  LOOP
     FOR jdc IN three(j.policy_id)
     LOOP
        IF jdc.lic_tag = 'Y'
        THEN
           GO := 'Y';
           ws_intm := jdc.intm;
        ELSE
           GO := 'N';
        END IF;
        EXIT;
     END LOOP jdc;
     IF GO = 'Y'
     THEN
        policy := Get_Policy_No(j.policy_id);
        i_date := get_incept_date(j.policy_id);
        e_date := get_expiry_date(j.policy_id);
        FOR sean IN four(j.policy_id, ws_intm, j.line_cd)
        LOOP
           IF sean.prof_comm_tag = 'Y'
           THEN
              prof_basic := prof_basic + sean.premium;
           ELSE
              prof_allied := prof_allied + sean.premium;
           END IF;
        END LOOP sean;
        INSERT INTO giac_prem_pd_ext( intm_no
                                     ,line_cd
                                     ,policy_id
                                     ,policy_no
                                     ,assd_no
                                     ,incept_date
                                     ,expiry_date
                                     ,full_paid_dt
                                     ,ref_no
                                     ,prem_basic
                                     ,prem_allied
	                             ,tran_year)
                              VALUES( ws_intm
                                     ,j.line_cd
                                     ,j.policy_id
                                     ,policy
                                     ,j.assd_no
                                     ,i_date
                                     ,e_date
                                     ,j.paydate
                                     ,'.'
                                     ,prof_basic
                                     ,prof_allied
                                     ,v_tran_year);
        prof_basic  := 0;
        prof_allied := 0;
        policy      := NULL;
        ws_intm     := NULL;
        GO          := NULL;
        i_date      := NULL;
        e_date      := NULL;
     END IF;
  END LOOP j;
--EXCEPTION WHEN OTHERS THEN
 --       RAISE_APPLICATION_ERROR(-20001, SQLERRM);
END prem_pd_ext;
END Giac_Cpc;
/


DROP PACKAGE BODY CPI.GIAC_CPC;

