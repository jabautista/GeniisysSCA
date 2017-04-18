CREATE OR REPLACE FUNCTION CPI.GET_REF_NO (v_tran_id giac_acctrans.tran_id%TYPE)
/*
|| Author: unknown
||
|| Overview: Return the reference no for a given transaction id.
||           for COL - the or. no. /for DV - the dv no. /for JV and other transaction class
||           -  the tran_class concatanated with the tran_class_no
||
|| Major Modifications (when, who, why):
|| 11/08/2000 - RLU - Modified table source for tran class DV from check_no to
||                    dv_no to accomodate multiple checks
||
|| Major Modifications (when, who, why):
|| 07/07/2006 - Rochelle - Added tran class JV, CM, DM, and conditional statements for DV
|| 10/16/2012 - Udel - Fixed query on GET_DV_REF function if v_chk_rec is not Y (added tran_id filter)
|| 
*/
RETURN VARCHAR2
AS
  v_ref_no    VARCHAR2(60); --modified by alfie from varchar2(25) to varchar2(50) 03192010
  /* ---- returns the transaction class of a specified transaction ---- */
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
FUNCTION get_other_ref (v_tran_id giac_acctrans.tran_id%TYPE)
RETURN VARCHAR2
IS
     v_other_ref VARCHAR2(60) := NULL; --modified by alfie from varchar2(20) to varchar2(50) 03192010
BEGIN
   FOR other_ref IN (SELECT DECODE(A.tran_class, NULL, TO_CHAR(A.tran_year), A.tran_class
                          ||DECODE(A.tran_year, NULL, NULL,'-'||LTRIM(TO_CHAR(tran_year,'0000')))
                          ||DECODE(A.tran_month, NULL, NULL,'-'||LTRIM(TO_CHAR(tran_month,'00')))
                          ||DECODE(A.tran_seq_no, NULL, NULL, '-'||LTRIM(TO_CHAR(A.tran_seq_no, '000000')))) AS ref_no
                      FROM giac_acctrans A
                     WHERE tran_id = v_tran_id)
   LOOP
       v_other_ref := other_ref.ref_no;
       EXIT;
   END LOOP other_ref;
   RETURN (v_other_ref);
END get_other_ref;
/* ---- TRAN CLASS IS JV ---- */
FUNCTION get_jv_ref (v_tran_id  giac_acctrans.tran_id%TYPE)
RETURN VARCHAR2
IS
     v_jv_ref    VARCHAR2(60) := NULL; --modified by alfie from varchar2(20) to varchar2(50) 03192010
BEGIN
     /* benjo 04.24.2015 commented out and replaced with codes below
     FOR jv IN (SELECT DECODE(a.tran_class, NULL, TO_CHAR(a.tran_class_no), a.tran_class
                       ||DECODE(a.tran_class_no, NULL, NULL,'-'||LTRIM(TO_CHAR(a.tran_class_no,'0000000000')))) AS ref_no
                 FROM giac_acctrans a
                WHERE a.tran_id = v_tran_id) */
     FOR jv IN (SELECT A.gibr_branch_cd || '-' || A.tran_year || '-' || LTRIM (TO_CHAR (A.tran_month, '00')) || '-' || 
                       DECODE (A.jv_pref_suff, NULL, A.tran_class, A.jv_pref_suff) || '-' || 
                       LTRIM (TO_CHAR (DECODE (A.jv_no, NULL, A.tran_class_no, A.jv_no), '0000000000')) AS ref_no
                  FROM giac_acctrans A
                 WHERE A.tran_id = v_tran_id)
     LOOP
        v_jv_ref := jv.ref_no;
        EXIT;
     END LOOP jv;
     RETURN(v_jv_ref);
END get_jv_ref;
/* ---- IF TRAN CLASS IS COL/OR---- */
FUNCTION get_col_or_ref (v_tran_id  giac_acctrans.tran_id%TYPE)
RETURN VARCHAR2
IS
     v_col_or_ref VARCHAR2(60) := NULL; --modified by alfie from varchar2(20) to varchar2(50) 03192010
BEGIN
     FOR col_or IN (SELECT DECODE(A.or_pref_suf, NULL, TO_CHAR(A.or_no), A.or_pref_suf
                         ||DECODE(A.or_no, NULL, NULL,'-'||LTRIM(TO_CHAR(A.or_no,'0000000000')))) AS ref_no
                    FROM giac_order_of_payts A
                    WHERE gacc_tran_id = v_tran_id)
     LOOP
        v_col_or_ref := col_or.ref_no;
        EXIT;
     END LOOP col_or;
     --
     IF v_col_or_ref IS NULL THEN  --added by alfie to get the reference number of the cancelled (posted OR) 03232010
       v_col_or_ref := get_other_ref(v_tran_id);
     END IF; --ends here
     --
     RETURN(v_col_or_ref);
END get_col_or_ref;
/* ---- IF TRAN CLASS IS DV ---- */
FUNCTION get_dv_ref (v_tran_id giac_acctrans.tran_id%TYPE)
RETURN VARCHAR2
IS
     v_dv_ref VARCHAR2(60) := NULL; --modified by alfie from varchar2(20) to varchar2(50) 03192010
     v_chk_rec VARCHAR2(1) := 'N';
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
             FOR dv IN(SELECT DECODE(A.dv_pref, NULL, TO_CHAR(A.dv_no), A.dv_pref
                             ||DECODE(A.dv_no, NULL, NULL,'-'||LTRIM(TO_CHAR(A.dv_no,'0000000000')))) AS ref_no
                      FROM giac_disb_vouchers A
                      WHERE gacc_tran_id = v_tran_id)
            LOOP
               v_dv_ref := dv.ref_no;
               EXIT;
            END LOOP dv;
     /* ---- TRAN CLASS IS DV without record */
     ELSE
            FOR dv IN(SELECT DECODE(A.document_cd, NULL, TO_CHAR(A.doc_year), A.document_cd
                                ||'-'|| A.branch_cd
                           ||DECODE(A.doc_year, NULL, NULL, '-'||LTRIM(TO_CHAR(A.doc_year, '0000')))
                           ||DECODE(A.doc_mm, NULL, NULL, '-'||LTRIM(TO_CHAR(A.doc_mm, '00')))
                           ||DECODE(A.doc_seq_no, NULL, NULL, '-'||LTRIM(TO_CHAR(A.doc_seq_no, '000000')))) AS ref_no
                        FROM giac_payt_requests A, giac_payt_requests_dtl c
                       WHERE A.ref_id = c.gprq_ref_id
                         AND c.tran_id = v_tran_id)
             LOOP
               v_dv_ref := dv.ref_no;
               EXIT;
            END LOOP dv;
     END IF;
     RETURN(v_dv_ref);
END get_dv_ref;
/* ---- TRAN CLASS IS CM or DM ---- */
FUNCTION get_cm_dm (v_tran_id giac_acctrans.tran_id%TYPE)
RETURN VARCHAR2
IS
    v_cm_dm_ref VARCHAR2(60) := NULL; --modified by alfie from varchar2(20) to varchar2(50) 03192010
BEGIN
   FOR cm_dm IN (SELECT DECODE(A.memo_type, NULL, TO_CHAR(A.memo_year), A.memo_type
                      ||DECODE(A.memo_year, NULL, NULL,'-'||LTRIM(TO_CHAR(A.memo_year,'0000')))
                      ||DECODE(A.memo_seq_no, NULL, NULL, '-'||LTRIM(TO_CHAR(A.memo_seq_no, '000000')))) AS ref_no
                  FROM giac_cm_dm A
                 WHERE gacc_tran_id = v_tran_id)
   LOOP
       v_cm_dm_ref := cm_dm.ref_no;
       EXIT;
   END LOOP cm_dm;
   RETURN(v_cm_dm_ref);
END get_cm_dm;
/* MAIN PROCEDURE*/
FUNCTION get_reference_no (v_tran_id  giac_acctrans.tran_id%TYPE)
RETURN VARCHAR2
IS
     v_ref_no     VARCHAR2(60) := NULL; --modified by alfie from varchar2(50) to varchar2(50) 03192010
     v_jv         giac_acctrans.tran_class%TYPE := 'JV';
     v_col_or     giac_acctrans.tran_class%TYPE := 'COL';
     v_dv         giac_acctrans.tran_class%TYPE := 'DV';
     /*
     v_cm         giac_acctrans.tran_class%TYPE := 'CM';
     v_dm           giac_acctrans.tran_class%TYPE := 'DM';*/
     v_memo_sw    NUMBER := 0; --reymon 01112013
     v_tran_class giac_acctrans.tran_class%TYPE := NULL;
BEGIN
   
    v_tran_class := get_tran_class(v_tran_id);
    --added by reymon 01112013 to check if tran_class is for memo
    BEGIN
        SELECT DISTINCT 1
          INTO v_memo_sw
          FROM cg_ref_codes
         WHERE rv_domain LIKE '%GIAC_CM_DM.MEMO_TYPE%'
           AND rv_low_value = v_tran_class;
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
            v_memo_sw := 0;
    END;
    --end 01112013
    /* ---- IF TRAN CLASS IS JV ---- */
    IF v_tran_class = v_jv
    THEN v_ref_no := get_jv_ref(v_tran_id);
    /* ---- IF TRAN CLASS IS DV ---- */
    ELSIF v_tran_class = v_dv
    THEN v_ref_no := get_dv_ref(v_tran_id);
    /* ---- IF TRAN CLASS IS COL/OR --- */
    ELSIF v_tran_class = v_col_or
    THEN v_ref_no := get_col_or_ref(v_tran_id);
    ELSIF v_memo_sw = 1 --added by reymon 01112013 if the tran_class is for memo
    THEN v_ref_no := get_cm_dm(v_tran_id);
    /* ---- IF TRAN CLASS IS CM --- */
    /* commented out by reymon 01112013
    ELSIF v_tran_class = v_cm
    THEN v_ref_no := get_cm_dm(v_tran_id);
    */
    /* ---- IF TRAN CLASS IS DM --- */
    /*
    ELSIF v_tran_class = v_dm
    THEN v_ref_no := get_cm_dm(v_tran_id);*/
    /* ---- OTHER TRAN CLASS--- */
    --end of comment 01112013
    --ELSE v_ref_no := get_col_or_ref(v_tran_id); commented by alfie
    ELSE v_ref_no := get_other_ref(v_tran_id); --get the other reference numbers such as REV, etc 03182010
    END IF;
    RETURN(v_ref_no);
END get_reference_no;
BEGIN
  v_ref_no := get_reference_no(v_tran_id);
  RETURN v_ref_no;
END get_ref_no;
/
