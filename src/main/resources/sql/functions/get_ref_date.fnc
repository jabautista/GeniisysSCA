DROP FUNCTION CPI.GET_REF_DATE;

CREATE OR REPLACE FUNCTION CPI."GET_REF_DATE" (v_tran_id giac_acctrans.tran_id%TYPE)
/*
|| Author: unknown
||
|| Overview: Return the reference date for a given transaction id.
||
*/
RETURN DATE
AS
  v_ref_date    DATE;
  FUNCTION get_tran_class (v_gacc_tran_id  giac_acctrans.tran_id%TYPE)
  RETURN VARCHAR2
  IS
     v_tran_class     giac_acctrans.tran_class%TYPE:= NULL;
  BEGIN
    FOR CLASS IN (SELECT tran_class
                  FROM giac_acctrans
                  WHERE tran_id = v_gacc_tran_id)
    LOOP
       v_tran_class := CLASS.tran_class;
       EXIT;
    END LOOP CLASS;
    RETURN(v_tran_class);
  END get_tran_class;
/* ---- TRAN CLASS IS NONE OF THE BELOW ---- */
FUNCTION get_other_ref_date (v_tran_id giac_acctrans.tran_id%TYPE)
RETURN DATE
IS
     v_other_ref_date   DATE;
BEGIN
   FOR other_ref IN (SELECT tran_date ref_date
                      FROM giac_acctrans a
                     WHERE tran_id = v_tran_id)
   LOOP
       v_other_ref_date := other_ref.ref_date;
       EXIT;
   END LOOP other_ref;
   RETURN (v_other_ref_date);
END get_other_ref_date;
/* ---- TRAN CLASS IS JV ---- */
FUNCTION get_jv_ref_date (v_tran_id  giac_acctrans.tran_id%TYPE)
RETURN DATE
IS
     v_jv_ref_date    DATE;
BEGIN
     FOR jv IN (SELECT tran_date ref_date
                 FROM giac_acctrans a
                WHERE a.tran_id = v_tran_id)
     LOOP
        v_jv_ref_date := jv.ref_date;
        EXIT;
     END LOOP jv;
     RETURN(v_jv_ref_date);
END get_jv_ref_date;
/* ---- IF TRAN CLASS IS COL/OR---- */
FUNCTION get_col_or_ref_date (v_tran_id  giac_acctrans.tran_id%TYPE)
RETURN DATE
IS
     v_col_or_ref_date  DATE;
BEGIN
     FOR col_or IN (SELECT or_date ref_date
                    FROM giac_order_of_payts a
                    WHERE gacc_tran_id = v_tran_id)
     LOOP
        v_col_or_ref_date := col_or.ref_date;
        EXIT;
     END LOOP col_or;
     --
     IF v_col_or_ref_date IS NULL THEN
       v_col_or_ref_date := get_other_ref_date(v_tran_id);
     END IF; --ends here
     --
     RETURN(v_col_or_ref_date);
END get_col_or_ref_date;
/* ---- IF TRAN CLASS IS DV ---- */
FUNCTION get_dv_ref_date (v_tran_id giac_acctrans.tran_id%TYPE)
RETURN DATE
IS
     v_dv_ref_date  DATE;
     v_chk_rec      VARCHAR2(1) := 'N';
BEGIN
     FOR exst IN (SELECT 1
                  FROM giac_disb_vouchers
                  WHERE gacc_tran_id = v_tran_id)
     LOOP
       v_chk_rec :='Y';
       EXIT;
     END LOOP;
     /* ---- TRAN CLASS IS DV with record ---- */
     IF v_chk_rec = 'Y' THEN
             FOR dv IN(SELECT dv_print_date ref_date
                      FROM giac_disb_vouchers a
                      WHERE gacc_tran_id = v_tran_id)
            LOOP
               v_dv_ref_date := dv.ref_date;
               EXIT;
            END LOOP dv;
     /* ---- TRAN CLASS IS DV without record */
     ELSE
            FOR dv IN(SELECT request_date ref_date
                      FROM giac_payt_requests a, giac_payt_requests_dtl c
                       WHERE a.ref_id = c.gprq_ref_id
                         AND c.tran_id = v_tran_id)
             LOOP
               v_dv_ref_date := dv.ref_date;
               EXIT;
            END LOOP dv;
     END IF;
     RETURN(v_dv_ref_date);
END get_dv_ref_date;
/* ---- TRAN CLASS IS CM or DM ---- */
FUNCTION get_cm_dm_date (v_tran_id giac_acctrans.tran_id%TYPE)
RETURN DATE
IS
    v_cm_dm_ref_date    DATE;
BEGIN
   FOR cm_dm IN (SELECT memo_date ref_date
                  FROM giac_cm_dm a
                 WHERE gacc_tran_id = v_tran_id)
   LOOP
       v_cm_dm_ref_date := cm_dm.ref_date;
       EXIT;
   END LOOP cm_dm;
   RETURN(v_cm_dm_ref_date);
END get_cm_dm_date;
/* MAIN PROCEDURE*/
FUNCTION get_reference_date (v_tran_id  giac_acctrans.tran_id%TYPE)
RETURN DATE
IS
     v_ref_date     DATE;
     v_jv         giac_acctrans.tran_class%TYPE := 'JV';
     v_col_or     giac_acctrans.tran_class%TYPE := 'COL';
     v_dv         giac_acctrans.tran_class%TYPE := 'DV';
     v_cm         giac_acctrans.tran_class%TYPE := 'CM';
     v_dm         giac_acctrans.tran_class%TYPE := 'DM';
     v_tran_class giac_acctrans.tran_class%TYPE := NULL;
BEGIN
    v_tran_class := get_tran_class(v_tran_id);
    /* ---- IF TRAN CLASS IS JV ---- */
    IF v_tran_class = v_jv
    THEN v_ref_date := get_jv_ref_date(v_tran_id);
    /* ---- IF TRAN CLASS IS DV ---- */
    ELSIF v_tran_class = v_dv
    THEN v_ref_date := get_dv_ref_date(v_tran_id);
    /* ---- IF TRAN CLASS IS COL/OR --- */
    ELSIF v_tran_class = v_col_or
    THEN v_ref_date := get_col_or_ref_date(v_tran_id);
    /* ---- IF TRAN CLASS IS CM --- */
    ELSIF v_tran_class = v_cm
    THEN v_ref_date := get_cm_dm_date(v_tran_id);
    /* ---- IF TRAN CLASS IS DM --- */
    ELSIF v_tran_class = v_dm
    THEN v_ref_date := get_cm_dm_date(v_tran_id);
    /* ---- OTHER TRAN CLASS--- */
    ELSE v_ref_date := get_other_ref_date(v_tran_id);
    END IF;
    RETURN(v_ref_date);
END get_reference_date;
BEGIN
  v_ref_date := get_reference_date(v_tran_id);
  RETURN v_ref_date;
END get_ref_date;
/


