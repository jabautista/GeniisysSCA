DROP PROCEDURE CPI.POPULATE_PACKAGE_PERILS;

CREATE OR REPLACE PROCEDURE CPI.populate_package_perils(
    p_item_grp      NUMBER,
    p_new_par_id    gipi_witmperl.par_id%TYPE,
    p_proc_intm_no  giis_intermediary.intm_no%TYPE,
    p_dsp_iss_cd    giis_intm_special_rate.iss_cd%TYPE,
    p_msg       OUT VARCHAR2   
)
IS
  v_peril_name             giis_peril.peril_name%type;
  v_total_commission       gipi_wcomm_invoices.commission_amt%type;
  v_total_wholding_tax     gipi_wcomm_invoices.wholding_tax%type;
  v_total_premium_amt      gipi_wcomm_invoices.premium_amt%type;
  v_total_net_commission   gipi_wcomm_invoices.commission_amt%type;
  v_dummy                  VARCHAR2(1);
  v_share_percentage       gipi_wcomm_invoices.share_percentage%TYPE;
  v_iss_cd                 giis_parameters.param_value_v%TYPE;
  v_rate                   giis_peril.intm_comm_rt%TYPE;

BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-17-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : populate_package_perils program unit 
  */
  FOR rec IN (SELECT a.item_no item_no, b.pack_line_cd pack_line_cd, 
                     a.peril_cd peril_cd, a.prem_amt prem_amt,b.item_grp
                FROM gipi_witmperl a, gipi_witem b
               WHERE a.par_id   = b.par_id
                 AND a.item_no  = b.item_no
                 AND a.par_id   = p_new_par_id 
                 AND a.item_no  = p_item_grp ) 
  LOOP
    BEGIN
      --IF :SYSTEM.RECORD_STATUS <> 'NEW' THEN
        --   NEXT_RECORD;
        --END IF;
        BEGIN
          SELECT param_value_v
            INTO v_iss_cd
            FROM giis_parameters
           WHERE param_name = 'HO';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            p_msg := 'Parameter HO does not exist in giis parameters.';
        END;
      GET_PACKAGE_INTM_RATE(rec.item_no, rec.pack_line_cd, rec.peril_cd, rec.item_grp, p_proc_intm_no, p_new_par_id, p_dsp_iss_cd, v_iss_cd, v_rate);

      DECLARE
        X      gipi_wcomm_invoices.share_percentage%TYPE := 0;
      BEGIN
        FOR temp IN (SELECT SHARE_PERCENTAGE
                       FROM GIPI_WCOMM_INVOICES
                        WHERE ITEM_GRP = p_item_grp 
                          AND PAR_ID = p_new_par_id) LOOP
              X := X + TEMP.SHARE_PERCENTAGE;
        END LOOP;
          v_share_percentage := 100 - x ;
      END;

      IF v_rate IS NOT NULL THEN
         BEGIN
           SELECT peril_name
             INTO v_peril_name
             FROM giis_peril
            WHERE peril_cd = rec.peril_cd
              AND line_cd  = rec.pack_line_cd;    
                   
           UPDATE gipi_wcomm_inv_perils
              SET peril_cd = rec.peril_cd,
                    premium_amt = rec.prem_amt * NVL(v_share_percentage,0)/100,
                    commission_rt = v_rate
            WHERE par_id = p_new_par_id
              AND item_grp = p_item_grp;      
           EXCEPTION
             WHEN NO_DATA_FOUND THEN 
               NULL;
           END;
        END IF;  
    END;
  END LOOP;
  --FIRST_RECORD;
END;
/


