DROP PROCEDURE CPI.GIPIS060_CREATE_WINVOICE1;

CREATE OR REPLACE PROCEDURE CPI.gipis060_create_winvoice1(p_par_id IN NUMBER,
                           p_line_cd IN VARCHAR2,
                           p_iss_cd IN VARCHAR2) IS
--
-- Used by item-peril module to create an initial value for invoice module.
-- Taxes selection from maintenace tables are also performed.
--
CURSOR a1 IS
   SELECT NVL(eff_date,incept_date), issue_date, place_cd
     FROM gipi_wpolbas
    WHERE par_id  =  p_par_id;

  v_comm_amt_per_group  GIPI_WINVOICE.ri_comm_amt%TYPE;
  v_prem_amt_per_peril  GIPI_WINVOICE.prem_amt%TYPE;
  v_prem_amt_per_group  GIPI_WINVOICE.prem_amt%TYPE;
  v_tax_amt_per_peril   GIPI_WINVOICE.tax_amt%TYPE;
  v_tax_amt_per_group1  GIPI_WINVOICE.tax_amt%TYPE;
  v_tax_amt_per_group2  GIPI_WINVOICE.tax_amt%TYPE;
  v_p_tax_amt           REAL;
  v_prev_item_grp       GIPI_WINVOICE.item_grp%TYPE;
  v_prev_currency_cd    GIPI_WINVOICE.currency_cd%TYPE;
  v_prev_currency_rt    GIPI_WINVOICE.currency_rt%TYPE;
  v_assd_name         GIIS_ASSURED.assd_name%TYPE;
  v_dummy               VARCHAR2(1);
  v_issue_date        GIPI_WPOLBAS.issue_date%TYPE;
  v_eff_date          GIPI_WPOLBAS.eff_date%TYPE;
  v_place_cd          GIPI_WPOLBAS.place_cd%TYPE;
  v_pack              GIPI_WPOLBAS.pack_pol_flag%TYPE;
  v_cod               giis_parameters.param_value_v%TYPE;

BEGIN
  OPEN a1;
  FETCH a1
   INTO v_eff_date,
        v_issue_date,
        v_place_cd;
  CLOSE a1;
  DELETE FROM gipi_winstallment
   WHERE par_id = p_par_id;
  DELETE FROM gipi_wcomm_inv_perils
   WHERE par_id = p_par_id;
  DELETE FROM gipi_wcomm_invoices
   WHERE par_id = p_par_id;
  DELETE FROM gipi_winvperl
   WHERE par_id = p_par_id;
  DELETE FROM gipi_wpackage_inv_tax
   WHERE par_id = p_par_id;
  DELETE FROM gipi_winv_tax
   WHERE par_id = p_par_id;
  DELETE FROM gipi_winvoice
   WHERE par_id = p_par_id;
  BEGIN
    FOR A1 IN (
      SELECT SUBSTR(b.assd_name,1,30) ASSD_NAME
        FROM gipi_parlist a, giis_assured b
       WHERE a.assd_no    =  b.assd_no
         AND a.par_id     =  p_par_id
         AND a.line_cd    =  p_line_cd)
    LOOP
        v_assd_name  := A1.assd_name;
    END LOOP;
    IF v_assd_name IS NULL THEN
       v_assd_name := 'Null';
    END IF;
  END;
  FOR A IN (
    SELECT pack_pol_flag
      FROM gipi_wpolbas
     WHERE par_id  =  p_par_id)
  LOOP
    v_pack  :=  A.pack_pol_flag;
    EXIT;
  END LOOP;
  BEGIN
    FOR A IN (SELECT param_value_v
                FROM giis_parameters
               WHERE param_name = 'CASH ON DELIVERY') LOOP   
       v_cod := a.param_value_v;
       EXIT;
    END LOOP;           	
    FOR B IN (SELECT main_currency_cd, currency_rt
                FROM giac_parameters A, giis_currency B
               WHERE param_name = 'DEFAULT_CURRENCY') LOOP
       v_prev_currency_cd := b.main_currency_cd;
       v_prev_currency_rt := b.currency_rt;
       EXIT;
    END LOOP;           	            
    INSERT INTO  gipi_winvoice
        (par_id,              item_grp,
         payt_terms,          prem_seq_no,
         prem_amt,            tax_amt,
         property,            insured,
         due_date,            notarial_fee,
         ri_comm_amt,         currency_cd,
         currency_rt)
    VALUES
        (p_par_id,            1,
         v_cod,               NULL,
         0,                   0,            
         NULL,                v_assd_name,
         NULL,                0,
         0,                   v_prev_currency_cd,
         v_prev_currency_rt);
             
  END;
END;
/


