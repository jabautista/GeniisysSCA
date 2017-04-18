DROP PROCEDURE CPI.UPDATE_PACK_POLBAS;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_PACK_POLBAS(
    p_new_par_id    gipi_pack_wpolbas.pack_par_id%TYPE
)
IS
  v_no_itm        gipi_wpolbas.no_of_items%TYPE;
  v_tsi_amt       gipi_wpolbas.tsi_amt%TYPE;
  v_prem_amt      gipi_wpolbas.prem_amt%TYPE;
  v_ann_prem_amt  gipi_wpolbas.prem_amt%TYPE;
  v_ann_prem_amt1 gipi_wpolbas.prem_amt%TYPE;
  v_ann_tsi_amt   gipi_wpolbas.ann_tsi_amt%TYPE;
  v_tsi_amt1      gipi_wpolbas.tsi_amt%TYPE;
  v_prem_amt1     gipi_wpolbas.prem_amt%TYPE;
  v_ann_tsi_amt1  gipi_wpolbas.ann_tsi_amt%TYPE;
  v_dep_pct       NUMBER(3,2) := Giisp.n('MC_DEP_PCT')/100;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-17-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : UPDATE_PACK_POLBAS program unit 
  */
  FOR item IN ( 
       SELECT item_no, currency_rt
         FROM gipi_witem a
        WHERE EXISTS (SELECT 1
                         FROM gipi_wpolbas x
                        WHERE pack_par_id = p_new_par_id
                          AND a.par_id    = x.par_id) 
        ORDER BY item_no) 
  LOOP
    v_prem_amt1 := 0;
    v_tsi_amt1  := 0;    
    v_ann_tsi_amt1 := 0;
      FOR peril IN ( 
        SELECT a.item_no, a.tsi_amt, a.prem_amt, b.line_cd line_cd, b.peril_cd peril_cd,
             NVL(a.ann_prem_amt, a.prem_amt) ann_prem_amt, b.peril_type,a.prem_rt
          FROM gipi_witmperl a, giis_peril b
         WHERE a.line_cd  = b.line_cd
           AND a.peril_cd = b.peril_cd
           AND a.item_no  = item.item_no
           AND EXISTS (SELECT 1
                         FROM gipi_wpolbas x
                        WHERE pack_par_id = p_new_par_id
                          AND a.par_id    = x.par_id) )
      LOOP                 
      v_prem_amt1     := NVL(v_prem_amt1,0) + peril.prem_amt;
      v_ann_prem_amt1 := NVL(v_ann_prem_amt1,0) + peril.ann_prem_amt;  
      IF peril.peril_type = 'B' THEN
         v_tsi_amt1      := NVL(v_tsi_amt1,0)  + peril.tsi_amt;
         v_ann_tsi_amt1  := NVL(v_ann_tsi_amt1,0)  + peril.tsi_amt;
      END IF;    
      /*FOR a IN (
        SELECT '1'                
                  FROM giex_dep_perl b
               WHERE b.line_cd  = peril.line_cd
                 AND b.peril_cd = peril.peril_cd
                 AND Giisp.v('AUTO_COMPUTE_MC_DEP') = 'Y')
          LOOP            
              v_tsi_amt1      := v_tsi_amt1 - (v_tsi_amt1*v_dep_pct);
                v_ann_tsi_amt1  := v_tsi_amt1 - (v_tsi_amt1*v_dep_pct);
                v_prem_amt1     := v_tsi_amt1 * (peril.prem_rt/100);
                v_ann_prem_amt1 := v_tsi_amt1 * (peril.prem_rt/100);
            END LOOP;*/
      END LOOP;
      /*UPDATE gipi_witem 
         SET prem_amt     = v_prem_amt1,
             ann_prem_amt = v_ann_prem_amt1,
             tsi_amt      = v_tsi_amt1,
             ann_tsi_amt  = v_ann_tsi_amt1
       WHERE item_no = item.item_no
         AND par_id  = variables.new_par_id;   */
     v_no_itm      := NVL(v_no_itm,0)   + 1;
     v_prem_amt    := NVL(v_prem_amt,0) + (v_prem_amt1 * item.currency_rt);
     v_ann_prem_amt:= NVL(v_ann_prem_amt,0) + (v_ann_prem_amt1 * item.currency_rt);   
     v_tsi_amt     := NVL(v_tsi_amt,0) + (v_tsi_amt1 * item.currency_rt);
     v_ann_tsi_amt := NVL(v_ann_tsi_amt,0) + (v_ann_tsi_amt1 * item.currency_rt);
     --message(v_tsi_amt||'-'||variables.new_par_id);pause;
  END LOOP; 
  --forms_ddl('COMMIT');
  UPDATE gipi_pack_wpolbas
     SET prem_amt     = v_prem_amt,
         tsi_amt      = v_tsi_amt,
         no_of_items  = v_no_itm, 
         ann_tsi_amt  = v_ann_tsi_amt,
         ann_prem_amt = v_ann_prem_amt
   WHERE pack_par_id  = p_new_par_id;   
   
   --forms_ddl('COMMIT');
   --message(v_tsi_amt);pause;
END;
/


