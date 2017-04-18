DROP PROCEDURE CPI.MY_EXTRACT_INCEPT_DATE;

CREATE OR REPLACE PROCEDURE CPI.My_Extract_Incept_Date
  (a IN VARCHAR2, b IN VARCHAR2,c_in IN VARCHAR2, d IN VARCHAR2, e IN VARCHAR2, f IN VARCHAR2, my_incept_date OUT DATE)
 --RETURN DATE
    IS
  v_incept_date       gipi_polbasic.incept_date%TYPE;
BEGIN
  FOR a1 IN
    (SELECT incept_date
       FROM gipi_polbasic
      WHERE line_cd              = a
        AND subline_cd           = b
        AND iss_cd               = c_in
        AND issue_yy             = d
        AND pol_seq_no           = e
        AND renew_no             = f
        AND pol_flag IN ('1','2','3','X')
        AND NVL(endt_seq_no,0) = 0)
  LOOP
    v_incept_date  := a1.incept_date;
    EXIT;
  END LOOP;
  FOR b1 IN
    (SELECT incept_date, endt_seq_no
       FROM gipi_polbasic
      WHERE line_cd              = a
        AND subline_cd           = b
        AND iss_cd               = c_in
        AND issue_yy             = d
        AND pol_seq_no           = e
        AND renew_no             = f
        AND pol_flag           IN ('1','2','3','X')
        AND eff_date           <= SYSDATE
        AND NVL(endt_seq_no,0) > 0
        AND incept_date        <> v_incept_date
        AND expiry_date         = endt_expiry_date
      ORDER BY eff_date DESC, endt_seq_no DESC)
  LOOP
    v_incept_date := b1.incept_date;
    FOR c IN
      (SELECT incept_date
         FROM gipi_polbasic
        WHERE line_cd              = a
          AND subline_cd           = b
          AND iss_cd               = c_in
          AND issue_yy             = d
          AND pol_seq_no           = e
          AND renew_no             = f
          AND pol_flag             IN ('1','2','3','X')
          AND eff_date             <= SYSDATE
          AND NVL(endt_seq_no,0)   > 0
          AND incept_date          <> b1.incept_date
          AND expiry_date          = endt_expiry_date
          AND NVL(back_stat,5)     = 2
          AND NVL(endt_seq_no,0)   > b1.endt_seq_no
        ORDER BY endt_seq_no DESC)
    LOOP
      v_incept_date  := c.incept_date;
      EXIT;
    END LOOP;
    EXIT;
  END LOOP;
  --RETURN v_incept_date;
  my_incept_date  := v_incept_date;
END;
/


