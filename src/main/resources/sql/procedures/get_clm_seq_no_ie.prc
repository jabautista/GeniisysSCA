DROP PROCEDURE CPI.GET_CLM_SEQ_NO_IE;

CREATE OR REPLACE PROCEDURE CPI.get_clm_seq_no_ie(varline_cd IN VARCHAR2, varsubline_cd IN VARCHAR2, variss_cd IN VARCHAR2, clm_seq_no OUT NUMBER)
/*revised by johnO*/
/* create and assign a claim sequence number. */
 IS
/* the values to be passed to the following variables will determine if
** line_cd, subline_cd, iss_cd, clm_yy (issue_yy) will unique or not.
** by Pia, 021502. */
  v_line_cd     GIIS_LINE.line_cd%TYPE;       --holds value of line_cd selected from table.
  v_subline_cd  GIIS_SUBLINE.subline_cd%TYPE; --holds value of subline_cd selected from table.
  v_iss_cd      GIIS_ISSOURCE.iss_cd%TYPE;     --holds value of iss_cd selected from table.
  v_clm_yy      GICL_CLAIMS.clm_yy%TYPE;      --holds value of issue_yy selected from table.
  BEGIN
   /* select values from giis_company_seq to declared variables.
   ** by Pia, 021502. */
   BEGIN
    SELECT DECODE(line_cd, 'Y',varline_cd,'**') line_cd,
           DECODE(subline_cd, 'Y', varsubline_cd, '**') subline_cd,
           DECODE(iss_cd, 'Y', variss_cd, '**') iss_cd,
           DECODE(issue_yy, 'Y', TO_NUMBER(TO_CHAR(SYSDATE, 'Y')), -1)issue_yy
      INTO v_line_cd, v_subline_cd, v_iss_cd, v_clm_yy
      FROM GIIS_COMPANY_SEQ
     WHERE pol_clm_seq = 'C';
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       v_line_cd    := varline_cd;
       v_subline_cd := varsubline_cd;
       v_iss_cd     := variss_cd;
       v_clm_yy     := TO_NUMBER(TO_CHAR(SYSDATE, 'Y'));
   END;
    SELECT clm_seq_no + 1
      INTO clm_seq_no
      FROM GIIS_CLM_SEQ a
     WHERE a.line_cd    = v_line_cd
       AND a.subline_cd = v_subline_cd
       AND a.iss_cd     = v_iss_cd
       AND a.clm_yy     = v_clm_yy;
    UPDATE GIIS_CLM_SEQ a
       SET clm_seq_no   = clm_seq_no + 1
     WHERE a.line_cd    = v_line_cd
       AND a.subline_cd = v_subline_cd
       AND a.iss_cd     = v_iss_cd
       AND a.clm_yy     = v_clm_yy;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      INSERT INTO GIIS_CLM_SEQ(line_cd,subline_cd,iss_cd,clm_yy,clm_seq_no)
           VALUES(v_line_cd, v_subline_cd, v_iss_cd, v_clm_yy, 1);
      clm_seq_no := 1;
  END Get_Clm_seq_no_ie;
/


