DROP PROCEDURE CPI.CREATE_PACK_WINVOICE1;

CREATE OR REPLACE PROCEDURE CPI.CREATE_PACK_WINVOICE1 (
    p_par_id     IN GIPI_PARLIST.par_id%TYPE,
    p_line_cd     IN GIPI_PARLIST.line_cd%TYPE,
    p_iss_cd     IN GIPI_PARLIST.iss_cd%TYPE,
    p_msg_alert    OUT VARCHAR2)
AS
    /*
    **  Created by        : Emman
    **  Date Created     : 11.30.2010
    **  Reference By     : (GIPIS031A - Package Endt Basic Information)
    **  Description     : Used by item-peril module to create an initial value for invoice module.
    **                    : Taxes selection from maintenace tables are also performed. (Original Description)
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
             currency_rt,         takeup_seq_no)
        VALUES
            (p_par_id,            1,
             v_cod,               NULL,
             0,                   0,            
             NULL,                p_assd_name,
             NULL,                0,
             0,                   prev_currency_cd,
             prev_currency_rt,    1);
         --A.R.C. 11.21.2006         
           DELETE FROM GIPI_PACK_WINV_TAX
            WHERE pack_par_id = p_par_id;
           DELETE FROM GIPI_PACK_WINVPERL
            WHERE pack_par_id = p_par_id;
           DELETE FROM GIPI_PACK_WINSTALLMENT
            WHERE pack_par_id = p_par_id;
           DELETE FROM GIPI_PACK_WINVOICE
            WHERE pack_par_id = p_par_id;     
         INSERT INTO GIPI_PACK_WINVOICE(pack_par_id, item_grp, prem_amt, tax_amt, ri_comm_amt, other_charges, bond_tsi_amt, ri_comm_vat)
              SELECT p_par_id, item_grp, SUM(prem_amt), SUM(tax_amt), SUM(ri_comm_amt), SUM(other_charges), SUM(bond_tsi_amt), SUM(ri_comm_vat)
                    FROM GIPI_WINVOICE A
                   WHERE EXISTS (SELECT 1
                                   FROM GIPI_PARLIST gp
                                         WHERE gp.par_id = A.par_id
                                            AND gp.pack_par_id = p_par_id
                                            AND gp.par_status NOT IN (98,99))
                  GROUP BY p_par_id, item_grp;
            FOR gw IN (SELECT item_grp, payt_terms, prem_seq_no, 'VARIOUS' property, insured, due_date, notarial_fee, currency_cd, currency_rt, remarks, ref_inv_no, policy_currency, bond_rate, pay_type, card_name, card_no, approval_cd, expiry_date
                         FROM GIPI_WINVOICE A
                                    WHERE EXISTS (SELECT 1
                                                    FROM GIPI_PARLIST gp
                                                         WHERE gp.par_id = A.par_id
                                                             AND gp.pack_par_id = p_par_id 
                                                             AND gp.par_status NOT IN (98,99)) )
            LOOP
              UPDATE GIPI_PACK_WINVOICE
                 SET payt_terms = gw.payt_terms, 
                           prem_seq_no = gw.prem_seq_no, 
                             property = gw.property, 
                             insured = gw.insured, 
                             due_date = gw.due_date, 
                             notarial_fee = gw.notarial_fee, 
                             currency_cd = gw.currency_cd, 
                             currency_rt = gw.currency_rt, 
                             remarks = gw.remarks, 
                             ref_inv_no = gw.ref_inv_no, 
                             policy_currency = gw.policy_currency, 
                             bond_rate = gw.bond_rate, 
                             pay_type = gw.pay_type, 
                             card_name = gw.card_name, 
                             card_no = gw.card_no, 
                             approval_cd = gw.approval_cd, 
                             expiry_date = gw.expiry_date 
               WHERE pack_par_id = p_par_id
                 AND item_grp = gw.item_grp;       
            END LOOP;
             
        COMMIT;
      END;
    
    <<RAISE_FORM_TRIGGER_FAILURE>>
    NULL;
END CREATE_PACK_WINVOICE1;
/


