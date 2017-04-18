DROP PROCEDURE CPI.GENERATE_RN_NO_GIEXS006;

CREATE OR REPLACE PROCEDURE CPI.generate_rn_no_giexs006
   ( p_line_cd  gipi_polbasic.line_cd%TYPE,
     p_subline_cd gipi_polbasic.subline_cd%TYPE,
     p_iss_cd  gipi_polbasic.iss_cd%TYPE,
     p_intm_no  giex_expiry.intm_no%TYPE,
     p_line_cd2  gipi_polbasic.line_cd%TYPE,
     p_subline_cd2 gipi_polbasic.subline_cd%TYPE,
     p_iss_cd2  gipi_polbasic.iss_cd%TYPE,
     p_issue_yy  gipi_polbasic.issue_yy%TYPE,
     p_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
     p_renew_no  gipi_polbasic.renew_no%TYPE,
     p_fr_date  DATE,
     p_to_date  DATE )
IS
  p_exist   VARCHAR2(1) := 'N';
  p_rn_seq_no    NUMBER := 9999999;
  v_rn_seq_no  giex_rn_no.rn_seq_no%TYPE;
  v_last_rn_seq_no  giex_rn_no.rn_seq_no%TYPE;
  v_line_cd  gipi_polbasic.line_cd%TYPE;
  v_iss_cd  gipi_polbasic.iss_cd%TYPE;
  v_rn_yy  giex_rn_no.rn_yy%TYPE;
  v_rownum  NUMBER;
  v_prev_rownum   NUMBER;
  v_count  NUMBER :=0;
  v_insert  VARCHAR2(1):='N';
  TYPE NUMBER_VARRAY IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
  TYPE STRING_VARRAY IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
  t_policy_id  NUMBER_VARRAY;
  t_line_cd  STRING_VARRAY;
  t_iss_cd  STRING_VARRAY;
  t_rn_yy  NUMBER_VARRAY;
  t_rn_seq_no  NUMBER_VARRAY;
  CURSOR EXP_POL IS
 SELECT a.policy_id, a.line_cd, a.iss_cd, 
TO_NUMBER(TO_CHAR(a.extract_date,'YY')) rn_yy
   FROM giex_expiry a
         WHERE NOT EXISTS (SELECT '1'
        FROM giex_rn_no b
       WHERE b.policy_id = a.policy_id)
    AND a.line_cd   = NVL(p_line_cd,NVL(p_line_cd2,a.line_cd))
     AND a.subline_cd   = 
NVL(p_subline_cd,NVL(p_subline_cd2,a.subline_cd))
    AND a.iss_cd   = NVL(p_iss_cd,NVL(p_iss_cd2,a.iss_cd))
    AND a.issue_yy  = NVL(p_issue_yy,a.issue_yy)
    AND a.pol_seq_no  = NVL(p_pol_seq_no,a.pol_seq_no)
    AND a.renew_no  = NVL(p_renew_no,a.renew_no)
    AND NVL(a.intm_no,0)  = NVL(p_intm_no,NVL(a.intm_no,0))
    AND TRUNC(a.expiry_date) >= NVL(p_fr_date,TRUNC(a.expiry_date))
    AND TRUNC(a.expiry_date) <= NVL(p_to_date,TRUNC(a.expiry_date))
    AND a.renew_flag  = '2'
    AND NVL(a.PACK_POLICY_ID,0) = 0 --added by gmi 
  ORDER BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, 
a.renew_no;
BEGIN
  FOR E IN EXP_POL LOOP
     v_count := v_count + 1;
     FOR A1 IN (
        SELECT rn_seq_no ,rownum
          FROM giis_rn_seq
         WHERE line_cd    =  e.line_cd
    AND iss_cd     =  e.iss_cd
           AND rn_yy      =  e.rn_yy
           FOR UPDATE OF rn_seq_no)
     LOOP
        IF v_insert = 'Y' THEN
           IF v_rn_seq_no is not null THEN
              UPDATE giis_rn_seq
                 SET rn_seq_no = v_last_rn_seq_no
               WHERE rownum     = v_prev_rownum;
           END IF;
    v_insert := 'N';
 END IF;
        IF a1.rownum <> v_rownum THEN
           IF v_rn_seq_no is not null THEN
              UPDATE giis_rn_seq
                 SET rn_seq_no = v_rn_seq_no
               WHERE rownum     = v_rownum;
           END IF;
    v_insert := 'N';
 END IF;
        IF a1.rownum <> v_rownum THEN
           IF a1.rn_seq_no < p_rn_seq_no THEN
       v_rn_seq_no := a1.rn_seq_no;
              p_exist := 'Y';
           ELSE
              v_rn_seq_no := 0;
              p_exist := 'Y';
           END IF;
        ELSE
           p_exist := 'Y';
        END IF;
        v_rownum := a1.rownum;
     END LOOP;
     v_prev_rownum := v_rownum;
     v_last_rn_seq_no := v_rn_seq_no;
     IF p_exist = 'N' THEN
        v_rn_seq_no := 0;
        INSERT INTO giis_rn_seq
           (line_cd,   iss_cd,   rn_yy,   rn_seq_no    )
        VALUES
           (e.line_cd, e.iss_cd, e.rn_yy, v_rn_seq_no  ) ;
        FOR A2 IN ( SELECT rn_seq_no ,rownum
               FROM giis_rn_seq
                   WHERE line_cd =  e.line_cd
                AND iss_cd  =  e.iss_cd
                    AND rn_yy   =  e.rn_yy) LOOP
     v_rownum := a2.rownum;
 END LOOP;
 IF v_count <> 1 THEN
    v_insert := 'Y';
 END IF;
     END IF;
     v_rn_seq_no := v_rn_seq_no + 1;
     v_line_cd  := e.line_cd;
     v_iss_cd  := e.iss_cd;
     v_rn_yy     := e.rn_yy;
     t_policy_id(v_count) := e.policy_id;
     t_line_cd(v_count)   := v_line_cd;
     t_iss_cd(v_count)    := v_iss_cd;
     t_rn_yy(v_count)     := v_rn_yy;
     t_rn_seq_no(v_count) := v_rn_seq_no;
     p_exist := 'N';
  END LOOP;
  IF v_count <> 1 THEN
     UPDATE giis_rn_seq
        SET rn_seq_no = v_last_rn_seq_no
      WHERE rownum     = v_prev_rownum;
  END IF;
  UPDATE giis_rn_seq
     SET rn_seq_no = v_rn_seq_no
   WHERE rownum     = v_rownum;
  IF t_policy_id.exists(1) THEN
     FOR INDX IN t_policy_id.FIRST..t_policy_id.LAST LOOP
        INSERT INTO giex_rn_no
         (policy_id,         line_cd,  iss_cd,
     rn_yy,             rn_seq_no)
   VALUES
         (t_policy_id(indx), t_line_cd(indx), t_iss_cd(indx),
       t_rn_yy(indx),     t_rn_seq_no(indx));
     END LOOP;
  END IF;
  COMMIT;
END;
/


