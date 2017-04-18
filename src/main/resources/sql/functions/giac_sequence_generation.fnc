DROP FUNCTION CPI.GIAC_SEQUENCE_GENERATION;

CREATE OR REPLACE FUNCTION CPI.GIAC_SEQUENCE_GENERATION (
  fund    VARCHAR2 default 'GIF',
  branch  VARCHAR2 default 'HO',
  field   VARCHAR2 default 'OP_NO',
  v_year  NUMBER,
  v_month NUMBER)
RETURN NUMBER IS
    v_seq_no   NUMBER;
    v_seq_no2  NUMBER;
BEGIN
  SELECT seq_no
    INTO v_seq_no
    FROM giac_sequences
   WHERE fund_cd = fund
     AND branch_cd = branch
     AND field_name = field
     AND tran_year = v_year
     AND tran_mm = v_month
     FOR UPDATE;
  UPDATE giac_sequences
     SET seq_no = v_seq_no + 1
   WHERE fund_cd = fund
     AND branch_cd = branch
     AND field_name = field
     AND tran_year = v_year
     AND tran_mm = v_month;
  return v_seq_no;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
     BEGIN
        v_seq_no  := 1;
 v_seq_no2 := v_seq_no + 1;
        INSERT INTO giac_sequences
            (fund_cd, branch_cd, field_name, tran_mm,
      tran_year,seq_no,remarks)
        VALUES
            (fund, branch, field, v_month,
             v_year, v_seq_no2, field||' Sequence record generated by application');
        return v_seq_no;
     END;
end;
/

