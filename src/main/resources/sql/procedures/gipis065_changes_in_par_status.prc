DROP PROCEDURE CPI.GIPIS065_CHANGES_IN_PAR_STATUS;

CREATE OR REPLACE PROCEDURE CPI.GIPIS065_CHANGES_IN_PAR_STATUS(
    p_par_id            GIPI_PARLIST.par_id%TYPE,
    ps_dist_no          GIUW_POL_DIST.dist_no%TYPE,
    ps_line_cd          GIPI_PARLIST.line_cd%TYPE,
    p_endt_tax_sw       GIPI_WENDTTEXT.endt_tax%TYPE,
    p_par_status        GIPI_PARLIST.par_status%TYPE,
    p_line_cd           GIPI_WPOLBAS.line_cd%TYPE,
    p_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE,
    p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
    p_issue_yy          GIPI_WPOLBAS.subline_cd%TYPE,
    p_pol_seq_no        GIPI_WPOLBAS.subline_cd%TYPE,
    p_renew_no          GIPI_WPOLBAS.subline_cd%TYPE,
    p_prorate_flag      GIPI_WPOLBAS.prorate_flag%TYPE,
    p_comp_sw           GIPI_WPOLBAS.comp_sw%TYPE,
    p_endt_expiry_date  GIPI_WPOLBAS.endt_expiry_date%TYPE,
    p_eff_date          GIPI_WPOLBAS.eff_date%TYPE,
    p_short_rt_percent  GIPI_WPOLBAS.short_rt_percent%TYPE,
    p_user_id           GIIS_USERS.user_id%TYPE
)
IS
    a_item          VARCHAR2(1)  := 'N';
    c_item          VARCHAR2(1)  := 'N';  
    a_perl          VARCHAR2(1)  := 'N';
    c_perl          VARCHAR2(1)  := 'N';
    
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
    pv_eff_date         GIPI_WPOLBAS.eff_date%TYPE;
    p_place_cd          GIPI_WPOLBAS.place_cd%TYPE;
    p_pack              GIPI_WPOLBAS.pack_pol_flag%TYPE;
    v_cod               giis_parameters.param_value_v%TYPE;
BEGIN
    FOR A1 IN (SELECT b480.item_no item_no
                 FROM gipi_witem b480
                WHERE b480.par_id = p_par_id
                  AND b480.rec_flag = 'A' )
    LOOP
        a_perl := 'N';
        a_item := 'Y';
        FOR A2 IN (SELECT '1'
                     FROM GIPI_WITMPERL cv001
                    WHERE cv001.par_id = p_par_id
                      AND cv001.item_no = a1.item_no)
        LOOP
            a_perl := 'Y';
            EXIT;
        END LOOP;
        
        IF a_perl = 'N' THEN
            EXIT;
        END IF;
    END LOOP;
    
    IF a_item = 'N' THEN
        FOR A1 IN (SELECT '1'
                     FROM GIPI_WITEM b480
                    WHERE b480.par_id = p_par_id)
        LOOP
            c_item := 'Y';
            FOR A2 IN (SELECT '1' 
                         FROM GIPI_WITMPERL
                        WHERE par_id = p_par_id)
            LOOP
                c_perl  := 'Y';
                EXIT;
            END LOOP;
            EXIT;
        END LOOP;
    END IF;
    
    GIPIS039_CREATE_INVOICE_ITEM(p_par_id, p_line_cd, p_iss_cd);
   -- GIPIS065_CREATE_DIST_ITEM2(p_par_id, ps_dist_no, p_user_id);  -- jhing 11.05.2014 replaced with a call to cr_bill_dist which almost does the exact thing :
   CR_BILL_DIST.GET_TSI ( p_par_id );  
    
    IF a_item = 'N' AND c_perl = 'N' AND NVL(p_endt_tax_sw,'N') = 'Y' THEN
        IF c_item = 'Y' THEN
            UPDATE GIPI_PARLIST
               SET par_status = 4
             WHERE par_id = p_par_id;
        ELSE
            BEGIN
                SELECT NVL(eff_date,incept_date), issue_date, place_cd
                  INTO pv_eff_date, p_issue_date, p_place_cd
                  FROM GIPI_WPOLBAS
                 WHERE par_id = p_par_id;
                 
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
                    FOR A1 IN (SELECT SUBSTR(b.assd_name,1,30) ASSD_NAME
                                 FROM GIPI_PARLIST a,
                                      GIIS_ASSURED b
                                WHERE a.assd_no = b.assd_no
                                  AND a.par_id = p_par_id
                                  AND a.line_cd = p_line_cd)
                    LOOP
                        p_assd_name  := A1.assd_name;
                    END LOOP;
                    IF p_assd_name IS NULL THEN
                        p_assd_name := 'Null';
                    END IF;
                END;
                
                FOR A IN (SELECT pack_pol_flag
                            FROM GIPI_WPOLBAS
                           WHERE par_id = p_par_id)
                LOOP
                    p_pack := A.pack_pol_flag;
                    EXIT;
                END LOOP;
                 
                BEGIN
                    FOR A IN (SELECT param_value_v
                                FROM GIIS_PARAMETERS
                               WHERE param_name = 'CASH ON DELIVERY')
                    LOOP   
                        v_cod := a.param_value_v;
                        EXIT;
                    END LOOP;
                               	
                    FOR B IN (SELECT main_currency_cd, currency_rt
                                FROM GIAC_PARAMETERS A,
                                     GIIS_CURRENCY B
                               WHERE param_name = 'DEFAULT_CURRENCY')
                    LOOP
                        prev_currency_cd := b.main_currency_cd;
                        prev_currency_rt := b.currency_rt;
                        EXIT;
                    END LOOP;       
                        	            
                    INSERT INTO GIPI_WINVOICE
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
            
            UPDATE GIPI_PARLIST
               SET par_status = 5
             WHERE par_id = p_par_id;
        END IF;
    ELSIF a_perl = 'Y' OR c_perl = 'Y' THEN
        UPDATE GIPI_PARLIST
           SET par_status = 5
         WHERE par_id = p_par_id;
    ELSIF a_item = 'Y' OR c_item = 'Y' THEN
        UPDATE GIPI_PARLIST
           SET par_status = 4
         WHERE par_id = p_par_id;
    ELSE
        UPDATE GIPI_PARLIST
           SET par_status = 3
         WHERE par_id = p_par_id;
    END IF;
    UPDATE_GIPI_WPOLBAS_GIPIS065(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_prorate_flag, p_comp_sw,
                                 p_endt_expiry_date, p_eff_date, p_short_rt_percent);
END;
/


