DROP PROCEDURE CPI.POST_SAVE_GROUPED_ITEMS;

CREATE OR REPLACE PROCEDURE CPI.POST_SAVE_GROUPED_ITEMS(
    p_par_id            GIPI_WPOLBAS.par_id%TYPE,
    p_line_cd           GIPI_WPOLBAS.line_cd%TYPE,
    p_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE,
    p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
    p_issue_yy          GIPI_WPOLBAS.issue_yy%TYPE,
    p_pol_seq_no        GIPI_WPOLBAS.pol_seq_no%TYPE,
    p_renew_no          GIPI_WPOLBAS.renew_no%TYPE,
    p_prorate_flag      GIPI_WPOLBAS.prorate_flag%TYPE,
    p_comp_sw           GIPI_WPOLBAS.comp_sw%TYPE,
    p_endt_expiry_date  VARCHAR2,
    p_eff_date          VARCHAR2,
    p_short_rt_percent  GIPI_WPOLBAS.short_rt_percent%TYPE,
    p_endt_tax_sw       GIPI_WENDTTEXT.endt_tax%TYPE,
    p_pack_line_cd      GIPI_WITEM.pack_line_cd%TYPE,
    p_pack_subline_cd   GIPI_WITEM.pack_subline_cd%TYPE,
    p_par_status        GIPI_PARLIST.par_status%TYPE,
    p_pack_pol_flag     GIPI_WPOLBAS.pack_pol_flag%TYPE,
    p_user_id           GIIS_USERS.user_id%TYPE
)
IS
    p_exist             NUMBER;
    p_exist1            VARCHAR2(1) := 'N';
    p_exist2            VARCHAR2(1) := 'N';
    p_dist_no           NUMBER      := 0;
    v_exist             VARCHAR2(1) := 'N';
    v_counter           NUMBER;
    
    v_variable_counter  NUMBER := 0;
    
    v_pack_pol_flag     VARCHAR2(1) := 'N';
    p_count_a           NUMBER := 0;
    p_count_b           NUMBER := 0;
    v_expiry_date       GIPI_POLBASIC.expiry_date%TYPE;
    v_endt_type         GIPI_POLBASIC.endt_type%TYPE;
    
    b_exist             VARCHAR2(1) := 'N';
    v_tsi_amt           GIPI_WITEM.tsi_amt%TYPE := 0;
    v_ann_tsi_amt       GIPI_WITEM.ann_tsi_amt%TYPE := 0;
    v_prem_amt          GIPI_WITEM.prem_amt%TYPE := 0;
    p2_dist_no          GIUW_POL_DIST.dist_no%TYPE;
    
    v_par_status         gipi_parlist.par_status%TYPE;
    v_exist1              VARCHAR2(1) := 'N';
    v_exist2             VARCHAR2(1) := 'N';
   
    v_endt_expiry_date  GIPI_WPOLBAS.endt_expiry_date%TYPE;
    v_eff_date          GIPI_WPOLBAS.eff_date%TYPE;
    
    v_pack_par_id       GIPI_PARLIST.pack_par_id%TYPE := NULL;
BEGIN
    v_endt_expiry_date := TO_DATE(p_endt_expiry_date, 'mm-dd-yyyy');
    v_eff_date := TO_DATE(p_eff_date, 'mm-dd-yyyy');
    
    BEGIN
        SELECT SUM(tsi_amt * currency_rt),
               SUM(ann_tsi_amt * currency_rt),
               SUM(prem_amt * currency_rt)
          INTO v_tsi_amt,
               v_ann_tsi_amt,
               v_prem_amt
          FROM GIPI_WITEM
         WHERE par_id = p_par_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Pls. be adviced that there are no items for this PAR.');
    END;
    
    FOR A1 IN (SELECT dist_no
                 FROM GIUW_POL_DIST
                WHERE par_id = p_par_id)
    LOOP
        p_dist_no := a1.dist_no;
        EXIT;
    END LOOP;

    GIPI_PARHIST_PKG.set_gipi_parhist(p_par_id, p_user_id, NULL, '4');
    
    CHANGE_ITEM_GRP(p_par_id, p_pack_pol_flag); -- marco - 02.21.2013 - added
    
    IF NVL(p_endt_tax_sw, 'N') != 'Y' THEN
        DELETE_BILL(p_par_id);
    END IF;
    
    UPDATE_GIPI_WPOLBAS_GIPIS065(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_prorate_flag, p_comp_sw,
                                 v_endt_expiry_date, v_eff_date, p_short_rt_percent);
                                 
    FOR A2 IN (SELECT DISTINCT 1
                 FROM GIPI_WITEM
                WHERE par_id = p_par_id)
    LOOP
        BEGIN
            BEGIN
                SELECT DISTINCT 1
                  INTO b_exist
                  FROM GIUW_POLICYDS
                 WHERE dist_no = p_dist_no;
                 
                 IF SQL%FOUND THEN
                    FOR A IN (SELECT a.pre_binder_id, b.line_cd, a.frps_yy, a.frps_seq_no
                                FROM GIRI_WFRPS_RI a, GIRI_WDISTFRPS b
                               WHERE a.line_cd = b.line_cd
                                 AND a.frps_yy = b.frps_yy
                                 AND a.frps_seq_no = b.frps_seq_no
                                 AND b.dist_no = p_dist_no)
                    LOOP
                        DELETE giri_wbinder_peril
                         WHERE pre_binder_id = a.pre_binder_id;

                        DELETE giri_wbinder
                         WHERE pre_binder_id = a.pre_binder_id;

                        DELETE giri_wfrps_peril_grp
                         WHERE line_cd = a.line_cd
                           AND frps_yy = a.frps_yy
                           AND frps_seq_no = a.frps_seq_no;

                        DELETE giri_wfrperil
                         WHERE line_cd = a.line_cd
                           AND frps_yy = a.frps_yy
                           AND frps_seq_no = a.frps_seq_no;

                        DELETE giri_wfrps_ri
                         WHERE line_cd = a.line_cd
                           AND frps_yy = a.frps_yy
                           AND frps_seq_no = a.frps_seq_no;
                    END LOOP;
                    
                    DELETE giri_wdistfrps
                     WHERE dist_no = p_dist_no;
                     
                    DELETE_WORKING_DIST_TABLES(p_dist_no);
                    DELETE_MAIN_DIST_TABLES(p_dist_no);
                    
                    UPDATE GIUW_POL_DIST
                       SET user_id = p_user_id,
                           last_upd_date = SYSDATE,
                           dist_type = NULL,
                           dist_flag = '1'
                     WHERE par_id  = p_par_id
                       AND dist_no = p_dist_no;
                 END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
            
            FOR c1_rec IN(SELECT DISTINCT frps_yy,
                                 frps_seq_no
                            FROM GIRI_WDISTFRPS
                           WHERE dist_no = p_dist_no)
            LOOP
                DELETE GIRI_WFRPERIL
                 WHERE frps_yy = C1_rec.frps_yy
                   AND frps_seq_no = C1_rec.frps_seq_no;
                DELETE GIRI_WFRPS_RI
                 WHERE frps_yy = C1_rec.frps_yy
                   AND frps_seq_no = C1_rec.frps_seq_no;
                DELETE GIRI_WDISTFRPS
                 WHERE dist_no = p_dist_no;
            END LOOP;
            
            FOR C2_rec IN(SELECT DISTINCT frps_yy,
                                 frps_seq_no
                            FROM GIRI_DISTFRPS
                           WHERE dist_no = p_dist_no) 
            LOOP
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#This PAR has corresponding records in the posted tables for RI. Could not proceed.');
            END LOOP;
            
            DELETE_WORKING_DIST_TABLES(p_dist_no);
            
            UPDATE GIUW_POL_DIST
               SET tsi_amt = NVL(v_tsi_amt,0),
                   prem_amt = NVL(v_prem_amt,0),
                   ann_tsi_amt = NVL(v_ann_tsi_amt,0),
                   last_upd_date = SYSDATE,
                   user_id = p_user_id
             WHERE par_id = p_par_id
               AND dist_no = p_dist_no;
            
            BEGIN
                SELECT eff_date,
                       expiry_date,
                       endt_type
                  INTO v_eff_date,
                       v_expiry_date,
                       v_endt_type
                  FROM GIPI_WPOLBAS
                 WHERE par_id = p_par_id;
            END;
            
            BEGIN
                SELECT POL_DIST_DIST_NO_S.NEXTVAL
                  INTO p2_dist_no
                  FROM DUAL;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No row in table SYS.DUAL.');
            END;

            /*INSERT INTO GIUW_POL_DIST(dist_no, par_id, policy_id, endt_type, tsi_amt,
                                      prem_amt, ann_tsi_amt, dist_flag, redist_flag,
                                      eff_date, expiry_date, create_date, user_id,
                                      last_upd_date, auto_dist)
            VALUES (p2_dist_no,p_par_id,NULL,v_endt_type,NVL(v_tsi_amt,0),
                   NVL(v_prem_amt,0),NVL(v_ann_tsi_amt,0),1,1,
                   v_eff_date,v_expiry_date, SYSDATE, p_user_id,
                   SYSDATE, 'N');*/
        END;
        
        p_exist1 := 'Y';
        EXIT;
    END LOOP;
    
    IF NVL(p_endt_tax_sw,'N') != 'Y' THEN
        FOR A3 IN (SELECT DISTINCT 1
                     FROM GIPI_WITMPERL
                    WHERE par_id = p_par_id)
        LOOP
            BEGIN
                DELETE FROM GIPI_ORIG_COMM_INV_PERIL
                 WHERE par_id = p_par_id;
                DELETE FROM GIPI_ORIG_COMM_INVOICE
                 WHERE par_id = p_par_id;
                DELETE FROM GIPI_ORIG_INVPERL
                 WHERE par_id = p_par_id;
                DELETE FROM GIPI_ORIG_INV_TAX
                 WHERE par_id = p_par_id;
                DELETE FROM GIPI_ORIG_INVOICE
                 WHERE par_id = p_par_id;
                DELETE FROM GIPI_ORIG_ITMPERIL
                 WHERE par_id = p_par_id;
                DELETE FROM GIPI_CO_INSURER
                 WHERE par_id = p_par_id;
                DELETE FROM GIPI_MAIN_CO_INS
                 WHERE par_id = p_par_id;
            END;
            
            CREATE_WINVOICE(0,0,0, p_par_id, p_line_cd, p_iss_cd);
            p_exist2 := 'Y';
            EXIT;
        END LOOP;
    END IF;
    
    FOR A4 IN (SELECT item_no
                 FROM GIPI_WITEM
                WHERE par_id = p_par_id)
    LOOP
        v_exist := 'Y';
        EXIT;
    END LOOP;
    
    IF p_exist1 = 'N' THEN
        FOR C1_rec IN(SELECT DISTINCT frps_yy,
                             frps_seq_no
                        FROM GIRI_WDISTFRPS
                       WHERE dist_no = p_dist_no)
        LOOP
            DELETE GIRI_WFRPERIL
             WHERE frps_yy = C1_rec.frps_yy
               AND frps_seq_no = C1_rec.frps_seq_no;
            DELETE GIRI_WFRPS_RI
             WHERE frps_yy = C1_rec.frps_yy
               AND frps_seq_no = C1_rec.frps_seq_no;
            DELETE GIRI_WDISTFRPS
             WHERE dist_no = p_dist_no;
        END LOOP;
        FOR C2_rec IN(SELECT DISTINCT frps_yy,
                             frps_seq_no
                        FROM GIRI_DISTFRPS
                       WHERE dist_no = p_dist_no)
        LOOP
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#This PAR has corresponding records in the posted tables for RI. Could not proceed.');
        END LOOP;
        DELETE GIUW_WITEMPERILDS_DTL
         WHERE dist_no = p_dist_no;
        DELETE GIUW_WPERILDS_DTL
         WHERE dist_no = p_dist_no;
        DELETE GIUW_WITEMDS_DTL
         WHERE dist_no = p_dist_no;
        DELETE GIUW_WPOLICYDS_DTL
         WHERE dist_no = p_dist_no;
        DELETE GIUW_WITEMPERILDS
         WHERE dist_no = p_dist_no;
        DELETE GIUW_WPERILDS
         WHERE dist_no = p_dist_no;
        DELETE GIUW_WITEMDS
         WHERE dist_no = p_dist_no;
        DELETE GIUW_WPOLICYDS
         WHERE dist_no = p_dist_no;
        DELETE GIUW_POL_DIST
         WHERE dist_no = p_dist_no; 
    END IF;
    
    IF (p_exist2 = 'N' AND nvl(p_endt_tax_sw,'N') != 'Y') THEN
        BEGIN
            DELETE GIPI_WINVPERL
             WHERE par_id = p_par_id;
            DELETE GIPI_WINV_TAX
             WHERE par_id = p_par_id;
            DELETE GIPI_WINVOICE
             WHERE par_id = p_par_id;
        END;
    END IF;
    
    BEGIN
        SELECT dist_no
          INTO p_dist_no
          FROM GIUW_POL_DIST
         WHERE par_id =  p_par_id;
         
       GIPIS065_CHANGES_IN_PAR_STATUS(p_par_id,p_dist_no,p_line_cd, p_endt_tax_sw, p_par_status, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy,
                                      p_pol_seq_no, p_renew_no, p_prorate_flag, p_comp_sw, v_endt_expiry_date, v_eff_date, p_short_rt_percent, p_user_id);
        
       IF p_par_status = 3 OR p_par_status is NULL THEN
            NULL;
        ELSIF p_par_status > 3 THEN
            NULL;
        ELSIF p_par_status < 3 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#You are not granted access to this form. The changes that you have made '||
                                            'will not be committed to the database.');
       END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            GIPIS065_CHANGES_IN_PAR_STATUS(p_par_id,p_dist_no,p_line_cd, p_endt_tax_sw, p_par_status, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy,
                                      p_pol_seq_no, p_renew_no, p_prorate_flag, p_comp_sw, v_endt_expiry_date, v_eff_date, p_short_rt_percent, p_user_id);
        WHEN TOO_MANY_ROWS THEN
            NULL;
    END;
    
    BEGIN
        FOR A1 IN(SELECT par_status
                    FROM GIPI_PARLIST
                   WHERE par_id = p_par_id)
        LOOP
            v_par_status := a1.par_status;
        END LOOP;
        
        FOR B IN (SELECT 1
                    FROM GIPI_WINVOICE
                   WHERE par_id = p_par_id)
        LOOP
            v_exist1 := 'Y';
            EXIT;
        END LOOP;
        
        FOR C IN (SELECT 1
                    FROM GIPI_WINV_TAX
                   WHERE par_id = p_par_id)
        LOOP
            v_exist2 := 'Y';
            EXIT;
        END LOOP;
        
        /* IF v_par_status = 3 THEN 
            NULL;
        ELSIF v_par_status = 4 THEN
            BEGIN
                SELECT COUNT(*)
                  INTO v_variable_counter
                  FROM GIPI_WITEM A
                 WHERE par_id = p_par_id
                   AND rec_flag = 'A'
                   AND NOT EXISTS (SELECT '1'
                                     FROM GIPI_WITMPERL
                                    WHERE par_id = p_par_id
                                      AND item_no = A.item_no);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_variable_counter := 0;
            END;
            
            IF v_variable_counter > 0 THEN
                NULL;
            ELSE
                --IF NVL(p_endt_tax_sw,'N') != 'Y' THEN
                --    NULL;
                --ELSE
                    IF v_exist2 = 'N' THEN
                        UPDATE GIPI_PARLIST
        	               SET par_status = 5
        	             WHERE par_id = p_par_id;
                    ELSE
                        UPDATE GIPI_PARLIST
        	               SET par_status = 6
        	             WHERE par_id = p_par_id;
                    END IF;
                --END IF;
            END IF;
        ELSIF v_par_status = 5 THEN
            NULL;
        ELSIF v_par_status = 6 THEN
            NULL;
        END IF; */
    END;
    
    IF p_pack_pol_flag = 'Y' THEN
        FOR a1 IN(SELECT item_no
		            FROM GIPI_WITEM
		           WHERE par_id = p_par_id
		             AND pack_line_cd = p_pack_line_cd
		             AND pack_subline_cd = p_pack_subline_cd)
        LOOP
            p_count_a := p_count_a + 1;
            
            FOR b1 IN(SELECT '1'
                        FROM GIPI_WACCIDENT_ITEM
                       WHERE par_id = p_par_id
		                 AND item_no = a1.item_no)
            LOOP
                p_count_b := p_count_b + 1; 
            END LOOP;
        END LOOP;
        
        IF p_count_a = p_count_b THEN
            UPDATE GIPI_WPACK_LINE_SUBLINE
               SET item_tag = 'Y'
             WHERE par_id = p_par_id
               AND pack_line_cd = p_pack_line_cd
               AND pack_subline_cd = p_pack_subline_cd;
        ELSE
            UPDATE GIPI_WPACK_LINE_SUBLINE
               SET item_tag = 'N'
             WHERE par_id = p_par_id
               AND pack_line_cd = p_pack_line_cd
               AND pack_subline_cd = p_pack_subline_cd;
        END IF;
    END IF;
    
    BEGIN
        SELECT pack_par_id
          INTO v_pack_par_id
          FROM GIPI_PARLIST
         WHERE par_id = p_par_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_pack_par_id := NULL;
    END;
    
    IF NVL(p_pack_pol_flag, 'N') = 'Y' AND v_pack_par_id IS NOT NULL THEN
	    SET_PACKAGE_MENU(v_pack_par_id);
    END IF;
    
    GIPIS039_CREATE_INVOICE_ITEM(p_par_id, p_line_cd, p_iss_cd);
END;
/


