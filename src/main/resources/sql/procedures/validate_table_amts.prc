DROP PROCEDURE CPI.VALIDATE_TABLE_AMTS;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_TABLE_AMTS(
                       p_par_id            IN  GIPI_PARLIST.par_id%TYPE,
                       p_MSG_ALERT        OUT VARCHAR2
                       )
        IS
        v_item_no VARCHAR2(100);
        v_item_cnt NUMBER := 0;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : VALIDATE_TABLE_AMTS program unit
  **  Modified By : Gzelle 05.16.2014 GIPIS207
  */
  --check for discrepancy between peril and item table premium amount
  
  FOR A IN (SELECT ROUND(SUM(NVL(b.prem_amt,0)),2) peril_prem, 
                                   ROUND(NVL(a.prem_amt,0),2) item_prem, a.item_no
              FROM GIPI_WITEM a, GIPI_WITMPERL b
             WHERE a.par_id = p_par_id
               AND a.par_id = b.par_id 
               AND a.item_no = b.item_no
           GROUP BY a.prem_amt, a.item_no
           ORDER BY a.item_no)
  LOOP
      IF a.peril_prem <> a.item_prem THEN
        v_item_no := v_item_no||TO_CHAR(a.item_no)||', ';
        v_item_cnt := v_item_cnt + 1;
        IF v_item_cnt > 1
        THEN
            p_MSG_ALERT := 'There is a discrepancy between the premium amounts in item and '||
                         'peril table for item nos. '|| SUBSTR(v_item_no,1,INSTR(v_item_no,',',-1)-1)||'. To correct this error '||
                         'please recreate item and it''s corresponding peril(s).';
        ELSE
            p_MSG_ALERT := 'There is a discrepancy between the premium amounts in item and '||
                         'peril table for item no. '|| SUBSTR(v_item_no,1,INSTR(v_item_no,',',-1)-1)||'. To correct this error '||
                         'please recreate item and it''s corresponding peril(s).';
        END IF;
           --error_rtn;          
      END IF;
  END LOOP;     
  v_item_cnt := 0;
  v_item_no  := null;
  --check for discrepancy between peril and item table TSI amount
  FOR A IN (SELECT ROUND(SUM(NVL(b.tsi_amt,0)),2) peril_tsi, 
                   ROUND(NVL(a.tsi_amt,0),2) item_tsi, a.item_no
              FROM GIPI_WITEM a, GIPI_WITMPERL b, GIIS_PERIL c
             WHERE a.par_id = p_par_id
               AND a.par_id = b.par_id 
               AND a.item_no = b.item_no               
               AND b.line_cd = c.line_cd
               AND b.peril_cd = c.peril_cd
               AND c.peril_type = 'B'
           GROUP BY a.tsi_amt, a.item_no
           ORDER BY a.item_no)
  LOOP
      IF a.peril_tsi <> a.item_tsi THEN
        v_item_no := v_item_no||TO_CHAR(a.item_no)||', ';
        v_item_cnt := v_item_cnt + 1;
        IF v_item_cnt > 1
        THEN
           p_MSG_ALERT := 'There is a discrepancy between the TSI amounts in item and '||
             'peril table for item nos. '||SUBSTR(v_item_no,1,INSTR(v_item_no,',',-1)-1)||'. To correct this error '||
             'please recreate item and it''s corresponding peril(s).';
        ELSE
           p_MSG_ALERT := 'There is a discrepancy between the TSI amounts in item and '||
             'peril table for item no. '|| SUBSTR(v_item_no,1,INSTR(v_item_no,',',-1)-1)||'. To correct this error '||
             'please recreate item and it''s corresponding peril(s).';
        END IF;
           --error_rtn;          
      END IF;
  END LOOP;               
  --check for discrepancy between polbasic and item table TSI and premium amounts
  FOR A IN (SELECT ROUND(SUM(NVL(b.tsi_amt,0)* NVL(b.currency_rt,1)),2) item_tsi,
                   ROUND(SUM(NVL(b.prem_amt,0)* NVL(b.currency_rt,1)),2) item_prem,
                   NVL(a.tsi_amt,0) pol_tsi, NVL(a.prem_amt,0) pol_prem
              FROM GIPI_WPOLBAS a, GIPI_WITEM b
             WHERE a.par_id = p_par_id
               AND a.par_id = b.par_id                
           GROUP BY a.tsi_amt, a.prem_amt)
  LOOP
      IF a.pol_tsi <> a.item_tsi THEN
           p_MSG_ALERT := 'There is a discrepancy between the TSI amounts in item and '||
                     'polbasic table . To correct this error please recreate item(s) and it''s corresponding peril(s).';
           --error_rtn;          
      END IF;
      IF a.pol_prem <> a.item_prem THEN
           p_MSG_ALERT := 'There is a discrepancy between the premium amounts in item and '||
                     'polbasic table . To correct this error please recreate item(s) and it''s corresponding peril(s).';
           --error_rtn;          
      END IF;
  END LOOP;                       
END;
/


