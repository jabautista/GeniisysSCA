DROP PROCEDURE CPI.INSERT_INTO_WVES_ACCU;

CREATE OR REPLACE PROCEDURE CPI.insert_into_wves_accu (P_PAR_ID IN NUMBER) IS
  p_line_cd       gipi_parlist.line_cd%type;
  p_iss_cd        gipi_parlist.iss_cd%type;
  p_eff_date      gipi_wpolbas.eff_date%type;
  p_subline_cd   gipi_wpolbas.subline_cd%type;
  p_issue_yy     gipi_wpolbas.issue_yy%type;
  p_pol_seq_no   gipi_wpolbas.pol_seq_no%type;
  p_exist2        NUMBER;
  p_exist         NUMBER;
--  record_number   NUMBER  :=  1;
  CURSOR A IS
     SELECT    item_no,
               ann_tsi_amt
       FROM    gipi_witem
      WHERE    par_id   =  p_par_id;
  CURSOR B(p_item_no  gipi_witem.item_no%TYPE) IS
     SELECT    a.vessel_cd,
               a.eta,
               a.etd
       FROM    gipi_wcargo a, giis_vessel b
      WHERE    a.par_id      =  p_par_id
        AND    a.item_no     =  p_item_no
        AND    a.vessel_cd   =  b.vessel_cd
        AND    b.vessel_flag = 'V';
BEGIN
  FOR L IN (
     SELECT line_cd, iss_cd
       FROM gipi_parlist
      WHERE par_id = p_par_id)
  LOOP
    p_line_cd   := l.line_cd;
    p_iss_cd    := l.iss_cd;
  END LOOP;
  FOR T IN (
     SELECT subline_cd,pol_seq_no,eff_date
       FROM gipi_wpolbas
      WHERE par_id  = p_par_id
        AND line_cd = p_line_cd
        AND iss_cd  = p_iss_cd)
  LOOP
    p_subline_cd  := T.subline_cd;
    p_pol_seq_no  := T.pol_seq_no;
    p_eff_date    := T.eff_date;
  END LOOP;
  FOR D IN (
     SELECT   1
       FROM   giis_subline
      WHERE   line_cd        =  p_line_cd
        AND   subline_cd     =  p_subline_cd
        AND   op_flag        =  'N')
  LOOP
    DELETE   gipi_wves_accumulation
     WHERE   par_id   =  p_par_id;
  FOR A1 IN A LOOP                       -- Loop used for gipi_item
     p_exist      := NULL;
     FOR B1 IN B(A1.item_no) LOOP        -- Loop used for cargo
       p_exist    := 1;
       p_exist2   :=  NULL;
        FOR C1 IN (
           SELECT   1
             FROM   gipi_wves_accumulation
            WHERE   par_id   =  p_par_id
              AND   item_no  =  A1.item_no) LOOP  -- Loop used to insert record
              DELETE   gipi_wves_accumulation
               WHERE   par_id   =  p_par_id
                 AND   item_no  =  A1.item_no;
        END LOOP;
            INSERT INTO   gipi_wves_accumulation
              (vessel_cd,par_id,item_no,eta,etd,tsi_amt,rec_flag,eff_date)
            VALUES
              (B1.vessel_cd,p_par_id,A1.item_no,B1.eta,
               B1.etd,A1.ann_tsi_amt,'A',p_eff_date);
     END LOOP;
     IF p_exist IS NULL THEN
                FOR C2 IN (
                   SELECT  vessel_cd,eta,etd,item_no,tsi_amt
                     FROM  gipi_ves_accumulation
                    WHERE  line_cd     =   p_line_cd
                      AND  subline_cd  =   p_subline_cd
                      AND  iss_cd      =   p_iss_cd
                      AND  issue_yy    =   p_issue_yy
                      AND  pol_seq_no  =   p_pol_seq_no
                      AND  item_no     =   A1.item_no
                 ORDER BY  eff_date DESC) LOOP
                 INSERT INTO   gipi_wves_accumulation
                   (vessel_cd,par_id,item_no,eta,etd,tsi_amt,rec_flag,eff_date)
                 VALUES
                   (C2.vessel_cd,p_par_id,A1.item_no,C2.eta,
                    C2.etd,A1.ann_tsi_amt,'A',p_eff_date);
                 EXIT;
                END LOOP;
     END IF;
  END LOOP;
  END LOOP;
END;
/


