DROP PROCEDURE CPI.CREATE_WINVOICE1_ENDT_ITMPERL;

CREATE OR REPLACE PROCEDURE CPI.create_winvoice1_endt_itmperl(p_par_id  IN NUMBER,
                                                          p_line_cd IN VARCHAR2,
                                                          p_iss_cd  IN VARCHAR2) IS
                                                          
    /*
    **  Created by		: Menandro G.C. Robes
	**  Date Created 	: July 1, 2010
	**  Reference By 	: (GIPIS097 - Endt Item Peril Information)
	**  Description 	: Used by item-peril module to create an initial value for invoice module.
	**					: Taxes selection from maintenace tables are also performed. (Original Description)
	*/                                                          

CURSOR a1 IS
   SELECT NVL(eff_date,incept_date), issue_date, place_cd
     FROM gipi_wpolbas
    WHERE par_id  =  p_par_id;

  comm_amt_per_group  GIPI_WINVOICE.ri_comm_amt%TYPE;
  prem_amt_per_peril  GIPI_WINVOICE.prem_amt%TYPE;
  prem_amt_per_group  GIPI_WINVOICE.prem_amt%TYPE;
  tax_amt_per_peril   GIPI_WINVOICE.tax_amt%TYPE;
  tax_amt_per_group1  GIPI_WINVOICE.tax_amt%TYPE;
  tax_amt_per_group2  GIPI_WINVOICE.tax_amt%TYPE;
  p_tax_amt           REAL;
  prev_item_grp       GIPI_WINVOICE.item_grp%TYPE;
  prev_currency_cd    GIPI_WINVOICE.currency_cd%TYPE;
  prev_currency_rt    GIPI_WINVOICE.currency_rt%TYPE;
  p_assd_name         GIIS_ASSURED.assd_name%TYPE;
  dummy               VARCHAR2(1);
  p_issue_date        GIPI_WPOLBAS.issue_date%TYPE;
  p_eff_date          GIPI_WPOLBAS.eff_date%TYPE;
  p_place_cd          GIPI_WPOLBAS.place_cd%TYPE;
  p_pack              GIPI_WPOLBAS.pack_pol_flag%TYPE;
  v_cod               giis_parameters.param_value_v%TYPE;

BEGIN
  OPEN a1;
  FETCH a1
   INTO p_eff_date,
        p_issue_date,
        p_place_cd;
  CLOSE a1;
  
/** commented - deletion from the following tables are done in the delete_bill procedure called before this procedure **/
--  DELETE FROM gipi_winstallment
--   WHERE par_id = p_par_id;
--  DELETE FROM gipi_wcomm_inv_perils
--   WHERE par_id = p_par_id;
--  DELETE FROM gipi_wcomm_invoices
--   WHERE par_id = p_par_id;
--  DELETE FROM gipi_winvperl
--   WHERE par_id = p_par_id;
--  DELETE FROM gipi_wpackage_inv_tax
--   WHERE par_id = p_par_id;
--  DELETE FROM gipi_winv_tax
--   WHERE par_id = p_par_id;
--  DELETE FROM gipi_winvoice
--   WHERE par_id = p_par_id;

  BEGIN
    FOR A1 IN (
      SELECT SUBSTR(b.assd_name,1,30) ASSD_NAME
        FROM gipi_parlist a, giis_assured b
       WHERE a.assd_no    =  b.assd_no
         AND a.par_id     =  p_par_id
         AND a.line_cd    =  p_line_cd)
    LOOP
        p_assd_name  := A1.assd_name;
    END LOOP;
    IF p_assd_name IS NULL THEN
       p_assd_name := 'Null';
    END IF;
  END;
  FOR A IN (
    SELECT pack_pol_flag
      FROM gipi_wpolbas
     WHERE par_id  =  p_par_id)
  LOOP
    p_pack  :=  A.pack_pol_flag;
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
       prev_currency_cd := b.main_currency_cd;
       prev_currency_rt := b.currency_rt;
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
         NULL,                p_assd_name,
         NULL,                0,
         0,                   prev_currency_cd,
         prev_currency_rt);
             
  END;
END;
/


