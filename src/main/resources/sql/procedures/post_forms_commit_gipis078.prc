DROP PROCEDURE CPI.POST_FORMS_COMMIT_GIPIS078;

CREATE OR REPLACE PROCEDURE CPI.POST_FORMS_COMMIT_GIPIS078(
    p_par_id            GIPI_WOPEN_LIAB.par_id%TYPE,
    p_limit_liability   GIPI_WOPEN_LIAB.limit_liability%TYPE,
    p_currency_cd       GIPI_WOPEN_LIAB.currency_cd%TYPE,
    p_currency_rt       GIPI_WOPEN_LIAB.currency_rt%TYPE,
    p_line_cd           GIPI_WPOLBAS.line_cd%TYPE,
    p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
    p_user_id           GIPI_WPOLBAS.user_id%TYPE
)
IS
/*
**  Created by   : Marco Paolo Rebong
**  Date Created : November 08, 2012
**  Reference By : GIPIS078 - Enter Cargo Limit of Liability Endorsement Information
**  Description  : POST-FORMS-COMMIT trigger from GIPIS078
*/
    
    p_exist2            NUMBER;
    v_witem_exists      VARCHAR2(1);
    v_item_no           GIPI_WITEM.item_no%TYPE := NULL;
BEGIN
    GIPI_WITEM_PKG.insert_into_gipi_witem(p_par_id, p_limit_liability, p_currency_cd, p_currency_rt);
    
    BEGIN
        SELECT DISTINCT 1
          INTO p_exist2
          FROM GIPI_WOPEN_PERIL
         WHERE par_id = p_par_id;
         
        GIPI_WITMPERL_PKG.insert_into_gipi_witmperl(p_par_id, p_limit_liability, p_line_cd, p_iss_cd, p_user_id);
        
        FOR a1 IN(SELECT dist_no
                    FROM GIUW_POL_DIST
                   WHERE par_id = p_par_id)         
        LOOP
     	    CREATE_DISTRIBUTION_GIPIS078(p_par_id, a1.dist_no, p_user_id);
     	    EXIT;
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            GIPI_WINVPERL_PKG.del_gipi_winvperl_1(p_par_id);
            GIPI_WINV_TAX_PKG.del_gipi_winv_tax_1(p_par_id);
            GIPI_WINSTALLMENT_PKG.del_gipi_winstallment_1(p_par_id);
            GIPI_WCOMM_INV_PERILS_PKG.del_gipi_wcomm_inv_perils1(p_par_id);
            GIPI_WCOMM_INVOICES_PKG.del_gipi_wcomm_invoices_1(p_par_id);
            GIPI_WINVOICE_PKG.del_gipi_winvoice1(p_par_id);
            
            FOR b1 IN(SELECT dist_no
                        FROM GIUW_POL_DIST
                       WHERE par_id = p_par_id)
            LOOP
                GIUW_WPERILDS_DTL_PKG.del_giuw_wperilds_dtl(b1.dist_no);
                GIUW_WITEMDS_DTL_PKG.del_giuw_witemds_dtl(b1.dist_no);
                GIUW_WPOLICYDS_DTL_PKG.del_giuw_wpolicyds_dtl(b1.dist_no);
                GIUW_WPERILDS_PKG.del_giuw_wperilds(b1.dist_no);
                GIUW_WITEMDS_PKG.del_giuw_witemds(b1.dist_no);
                GIUW_WPOLICYDS_PKG.del_giuw_wpolicyds(b1.dist_no);
                
                FOR c1 IN(SELECT frps_seq_no, frps_yy
                            FROM GIRI_WDISTFRPS
                           WHERE dist_no = b1.dist_no)
                LOOP
                    GIRI_WDISTFRPS_PKG.del_giri_wdistfrps1(c1.frps_seq_no, c1.frps_yy);
                END LOOP;
                
                GIUW_POL_DIST_PKG.del_giuw_pol_dist(b1.dist_no);
            END LOOP;
            
            GIPI_WITMPERL_PKG.del_gipi_witmperl2(p_par_id);
            GIPI_WITEM_PKG.del_all_gipi_witem(p_par_id);
            
            FOR a IN (SELECT par_id, par_status
                        FROM GIPI_PARLIST
                       WHERE par_id = p_par_id
                         FOR UPDATE OF par_id, par_status)
            LOOP
                UPDATE GIPI_PARLIST
                   SET par_status = 3
                 WHERE par_id = a.par_id;
                 EXIT;
            END LOOP;
    END;
    
    BEGIN
        SELECT 'Y'
          INTO v_witem_exists
          FROM GIPI_WITEM
         WHERE par_id = p_par_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_witem_exists := 'N';
    END;
    
    IF v_witem_exists = 'Y' THEN
        UPD_GIPI_WPOLBAS(p_par_id);
    END IF;
    
END;
/


