CREATE OR REPLACE PROCEDURE CPI.validate_invoice_info(
                       p_par_id         IN  GIPI_PARLIST.par_id%TYPE,
                  p_line_cd         IN  GIPI_PARLIST.line_cd%TYPE,
                  p_subline_cd     IN  GIPI_WPOLBAS.subline_cd%TYPE,
                  p_iss_cd         IN  GIPI_WPOLBAS.iss_cd%TYPE,
                  p_par_type     IN  GIPI_PARLIST.par_type%TYPE,
                       p_msg_alert    OUT VARCHAR2
                       )
        IS
  X               NUMBER;
  v_pay_flag      VARCHAR2(1);
  v_winst_exist   VARCHAR2(1);
  v_winst_exist2   VARCHAR2(1);
  v_wcomm_invoices   VARCHAR2(1);
  v_wcomm_invoices2   VARCHAR2(1);
  v_pay_tag          GIIS_PAYTERM.no_of_payt%TYPE;
  v_prem1         NUMBER(12,2) := 0;
  v_prem2         NUMBER(12,2) := 0;
  v_prem3          NUMBER(12,2) := 0; --gmi 09/26/05
  v_su_line       GIIS_LINE.line_cd%TYPE;    
  v_msg_alert      VARCHAR2(2000);
  v_open_flag      GIIS_SUBLINE.op_flag%TYPE;
  v_ri_cd          GIIS_ISSOURCE.iss_cd%TYPE;
  v_endt_tax       gipi_wendttext.endt_tax%TYPE; --benjo 09.26.2016 SR-5682
  
  CURSOR winvoice_cursor IS SELECT property,prem_amt,payt_terms
                              FROM GIPI_WINVOICE
                             WHERE par_id = p_par_id;
                             
  CURSOR c IS SELECT payt_terms,tax_amt
                FROM GIPI_WINVOICE
               WHERE GIPI_WINVOICE.par_id = p_par_id;
               
  CURSOR winstallment_cursor IS SELECT par_id
                FROM GIPI_WINVOICE
               WHERE par_id = p_par_id;
               
  CURSOR wcomm_invoices_cursor IS SELECT par_id
                FROM GIPI_WINVOICE
               WHERE par_id = p_par_id;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : validate_invoice_info program unit
  */
  --IF :gauge.process='Y' THEN
  --  :gauge.FILE := 'Validating Bill Information...';
  --ELSE
  --  :gauge.FILE := 'passing validate policy BILL INFO';
  --END IF;
  --vbx_counter;
  v_pay_flag := 'A';
  v_winst_exist := 'A';
  v_wcomm_invoices := 'A';
  v_ri_cd := giisp.v('ISS_CD_RI');
  X := 0;
  FOR su IN (
    SELECT param_value_v 
      FROM GIIS_PARAMETERS
     WHERE param_name = 'LINE_CODE_SU')
  LOOP
    v_su_line := su.param_value_v;
  END LOOP;
  
  FOR winvoice_cursor_rec IN winvoice_cursor LOOP
      v_prem1 := v_prem1 + NVL(winvoice_cursor_rec.prem_amt,0);
    IF p_line_cd = v_su_line THEN
      IF winvoice_cursor_rec.prem_amt IS NOT NULL THEN
         X := X + 1;
      END IF;
    ELSIF winvoice_cursor_rec.prem_amt IS NOT NULL AND
       (winvoice_cursor_rec.property IS NOT NULL) THEN
         BEGIN
           SELECT no_of_payt INTO v_pay_tag
             FROM GIIS_PAYTERM
            WHERE payt_terms = winvoice_cursor_rec.payt_terms;
         EXCEPTION
           WHEN TOO_MANY_ROWS THEN
                NULL;
           WHEN NO_DATA_FOUND THEN
                v_pay_flag := 'X';
                EXIT;
         END;
         X := X + 1;
    END IF; 
  END LOOP;
  
  IF v_pay_flag = 'X' THEN
     IF p_msg_alert IS NULL THEN
       p_msg_alert := 'Invalid or no payment term in invoice information.';
     END IF;
     --:gauge.FILE :='Invalid or no payment term in invoice information.';
     IF v_msg_alert IS NULL THEN
       recompute_items(p_par_id,p_line_cd,p_iss_cd,v_msg_alert);
     END IF;
     p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     --error_rtn;
  END IF;
  
  --koks 1.8.14: Validation if Par does not have record in gipi_winstallment
  FOR winstallment_cursor_rec IN winstallment_cursor LOOP
          BEGIN
                 SELECT 'X'
                   INTO v_winst_exist2
                   FROM gipi_winstallment
                  WHERE par_id = winstallment_cursor_rec.par_id;
              EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                        
                         v_winst_exist := 'X';

                 WHEN TOO_MANY_ROWS
                 THEN
                    NULL;
              END;

          
  END LOOP;
  
  if v_winst_exist = 'X' THEN
     IF p_msg_alert IS NULL THEN
       p_msg_alert := 'Missing payment information. Please re-enter payment term.';
     END IF;
     p_msg_alert := NVL(v_msg_alert,p_msg_alert);
  end if;
  
  --koks 1.8.14: Validation if Par does not have record in gipi_wcomm_invoices
  FOR wcomm_invoices_cursor_rec IN wcomm_invoices_cursor LOOP
          /* benjo 09.26.2016 SR-5682 */
          BEGIN
             SELECT NVL (endt_tax, 'N')
               INTO v_endt_tax
               FROM gipi_wendttext
              WHERE par_id = wcomm_invoices_cursor_rec.par_id;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_endt_tax := 'N';
          END;
          
          IF v_endt_tax <> 'Y' THEN --benjo 09.26.2016 SR-5682
              BEGIN
                 SELECT 'X'
                   INTO v_wcomm_invoices2
                   FROM gipi_wcomm_invoices  -- gipi_winstallment   grace 05.20.2016   change table to check missing intermediary
                  WHERE par_id = wcomm_invoices_cursor_rec.par_id;
              EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                        
                         v_wcomm_invoices := 'X';

                 WHEN TOO_MANY_ROWS
                 THEN
                    NULL;
              END;
          END IF;
          
  END LOOP;
  
  if v_wcomm_invoices = 'X' and p_iss_cd <> v_ri_cd THEN
     IF p_msg_alert IS NULL THEN
       p_msg_alert := 'Missing intermediary information. Please enter intermediary name.';
     END IF;
     p_msg_alert := NVL(v_msg_alert,p_msg_alert);
  end if;
  --koks
  
  BEGIN
    SELECT op_flag
      INTO v_open_flag
      FROM GIIS_SUBLINE
     WHERE line_cd    = p_line_cd 
       AND subline_cd = p_subline_cd;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
      NULL;
  END;
  
  IF X = 0 AND (p_par_type = 'P' AND NVL(v_open_flag,'N') <> 'Y') THEN
     IF p_msg_alert IS NULL THEN
       p_msg_alert := 'Invoice information not yet entered.';
     END IF;
     --:gauge.FILE :='Invoice information not yet entered.';
     IF v_msg_alert IS NULL THEN
       recompute_items(p_par_id,p_line_cd,p_iss_cd,v_msg_alert);
     END IF;
     p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     --error_rtn;
  END IF;
  SELECT SUM(NVL(prem_amt,0)) INTO v_prem2
    FROM GIPI_WITEM
   WHERE par_id = p_par_id;
  --**--gmi 09/26/05 --**-- 
  /*SELECT SUM(NVL(ann_prem_amt,0)) INTO v_prem3
    FROM gipi_wgrouped_items
   WHERE par_id = :postpar.par_id;*/
  --**-- gmi --**--   
  --IF ((v_prem1 <> v_prem2 AND v_prem2 <> 0) OR v_prem1 <> v_prem3 THEN --added condition gmi
      --NULL;
  --ELSE    
      --**--modified by gmi prin... 06.02.06--**--
  IF    v_prem1 <> v_prem2 THEN
     IF p_msg_alert IS NULL THEN
       p_msg_alert := 'Internal computation made an error, will create another bill.';
     END IF;
     --:gauge.FILE :='Sum of prem_amt in WITEM not equal to that in WINVOICE.';
     IF v_msg_alert IS NULL THEN
       recompute_items(p_par_id,p_line_cd,p_iss_cd,v_msg_alert);
     END IF;
     p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     --error_rtn;
  END IF;
  -- to enforce payment term entry for PAR's with invoice
  FOR A IN (SELECT   '1'
              FROM   GIIS_SUBLINE
             WHERE   line_cd    =  p_line_cd
               AND   subline_cd =  p_subline_cd 
               AND   op_flag    = 'Y') LOOP
    --validate_INVOICE_info2 ;
    FOR c_rec IN c LOOP
      IF c_rec.tax_amt > 0 THEN
         IF c_rec.payt_terms IS NULL THEN
            IF p_msg_alert IS NULL THEN
              p_msg_alert := 'Invoice Payment Terms must be entered first before posting THE PAR.';
            END IF;
            --:gauge.FILE := 'Invoice Payment Terms must be entered first before 
            --                posting THE PAR.' ;
            --error_rtn;
         END IF;
      END IF;
  END LOOP;
    EXIT;
  END LOOP;
  FOR A IN (SELECT '1'
              FROM GIPI_WITMPERL
             WHERE par_id = p_par_id)
  LOOP        
    IF v_msg_alert IS NULL THEN                
    VALIDATE_WCOMM_INVOICE(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_par_type, v_msg_alert);
    END IF;
    p_msg_alert := NVL(v_msg_alert,p_msg_alert);
    EXIT;
  END LOOP; 
 p_msg_alert := NVL(v_msg_alert,p_msg_alert);
END;
/


