DROP PROCEDURE CPI.GIPIS085_NEW_FORM_INSTANCE;

CREATE OR REPLACE PROCEDURE CPI.gipis085_new_form_instance (
	p_par_id                	IN  GIPI_PARLIST.par_id%TYPE,
	p_global_cancel_tag            IN  VARCHAR2,
    p_bancassurance_rec            OUT VARCHAR2,
    p_cancellation_type            OUT VARCHAR2,
    p_banca_btn_enabled            OUT VARCHAR2,
    p_banca_check_enabled        OUT VARCHAR2,
    p_var_banc_rate_sw            OUT VARCHAR2,
    p_var_override_whtax        OUT GIIS_PARAMETERS.param_value_v%TYPE,
    p_var_v_comm_update_tag        OUT GIIS_USERS.comm_update_tag%TYPE,
    p_var_v_param_show_comm        OUT GIAC_PARAMETERS.param_value_v%TYPE,
    p_var_endt_yy                OUT GIPI_WPOLBAS.endt_yy%TYPE,
    p_var_param_req_def_intm    OUT VARCHAR2,
    p_v_ora2010_sw                OUT VARCHAR2,
    p_v_validate_banca            OUT VARCHAR2,
    p_v_par_type                OUT GIPI_PARLIST.par_type%TYPE,
    p_v_endt_tax                OUT GIPI_WENDTTEXT.endt_tax%TYPE,
    p_v_pol_flag                OUT GIPI_WPOLBAS.pol_flag%TYPE,
    p_v_gipi_wpolnrep_exist        OUT VARCHAR2,
    p_v_lov_tag                    OUT VARCHAR2,
    p_v_wcominv_intm_no_lov        OUT VARCHAR2,
    p_v_allow_apply_sl_comm        OUT VARCHAR2,
    p_gipis085_b240                OUT GIPI_WCOMM_INVOICES_PKG.gipis085_b240_cur,
    p_wcomm_invoices            OUT GIPI_WCOMM_INVOICES_PKG.gipi_wcomm_invoices_cur,
    p_winvoice                    OUT GIPI_WINVOICE_PKG.gipi_winvoice_cur,
    p_wcomm_inv_perils            OUT GIPI_WCOMM_INV_PERILS_PKG.gipi_wcomm_inv_perils_cur,
    p_banc_type                    OUT GIIS_BANC_TYPE_PKG.giis_banc_type_cur,
    p_banc_type_dtl_list        OUT GIIS_BANC_TYPE_DTL_PKG.giis_banc_type_dtl_cur,
    p_item_grp_list                OUT GIPI_WCOMM_INVOICES_PKG.winvoice_item_grp_cur,
    p_intm_no                    OUT gipi_wcomm_invoices.intrmdry_intm_no%TYPE, 
    p_dsp_intm_name             OUT giis_intermediary.intm_name%TYPE,
    p_parent_intm_no            OUT gipi_wcomm_invoices.parent_intm_no%TYPE,
    p_parent_intm_name            OUT giis_intermediary.intm_name%TYPE,
    p_msg_alert                    OUT VARCHAR2)
AS
    v_banc_type_cd            GIPI_WPOLBAS.banc_type_cd%TYPE;
    v_gipis085_b240_cnt        NUMBER(1) := 1;
    v_wcomm_invoices_cnt    NUMBER(1) := 1;
    v_winvoice_cnt            NUMBER(1) := 1;
    v_wcomm_inv_perils_cnt    NUMBER(1) := 1;
    v_b240_assd_no            GIPI_PARLIST.assd_no%TYPE;
    v_b240_line_cd            GIPI_PARLIST.line_cd%TYPE;
    v_b240_par_type            GIPI_PARLIST.par_type%TYPE;
    v_wcominv_intm_no        GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE := NULL;
BEGIN
    p_v_lov_tag := 'UNFILTERED';
    p_msg_alert := 'SUCCESS';
    p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';
    -- The main records
    -- B240 (GIPI_PARLIST
    BEGIN
        OPEN p_gipis085_b240 FOR
            SELECT a.par_id, a.line_cd, a.iss_cd, a.par_yy,
                   a.par_seq_no, a.quote_seq_no, d.line_cd||' - '||d.iss_cd||' - '||to_char(d.par_yy,'09')||' - '||to_char(d.par_seq_no,'099999')||' - '||to_char(d.quote_seq_no,'09') dsp_pack_par_no,
                   a.line_cd || ' - ' || a.iss_cd || ' - ' || to_char(a.par_yy,'09') || ' - ' || to_char(a.par_seq_no,'099999') || ' - ' || to_char(a.quote_seq_no,'09') drv_par_seq_no,
                   b.pol_flag, a.assd_no, c.assd_name dsp_assd_name, a.par_status,
                   b.endt_yy nb_endt_yy, a.par_type, a.pack_par_id, b.subline_cd
              FROM GIPI_PARLIST a, GIPI_WPOLBAS b, GIIS_ASSURED c, GIPI_PACK_PARLIST d
             WHERE a.par_id = p_par_id
               AND b.par_id (+) = a.par_id
               AND c.assd_no (+) = a.assd_no
               AND d.pack_par_id (+) = a.pack_par_id;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
             v_gipis085_b240_cnt := 0;
    END;
    
    -- GIPI_WCOMM_INVOICES
    BEGIN
        OPEN p_wcomm_invoices FOR
             SELECT * 
                 FROM TABLE(GIPI_WCOMM_INVOICES_PKG.get_gipi_wcomm_invoices2(p_par_id))
           ORDER BY item_grp, intrmdry_intm_no;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_wcomm_invoices_cnt := 0;
    END;
    
    -- GIPI_WINVOICES
    BEGIN
        OPEN p_winvoice FOR
             SELECT * 
               FROM TABLE(Gipi_Winvoice_Pkg.get_gipi_winvoice2(p_par_id));
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_winvoice_cnt := 0;
    END;
    
    -- for the display of item grp and takeup seq no
    BEGIN
      OPEN p_item_grp_list FOR
        SELECT DISTINCT item_grp 
          FROM TABLE(Gipi_Winvoice_Pkg.get_gipi_winvoice2(p_par_id))
      ORDER BY item_grp;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             NULL;
    END;
    
    -- GIPI_WCOMM_INV_PERILS
    BEGIN
        OPEN p_wcomm_inv_perils FOR
             SELECT * 
                 FROM TABLE(GIPI_WCOMM_INV_PERILS_PKG.get_gipi_wcomm_inv_perils2(p_par_id));
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_wcomm_inv_perils_cnt := 0;
    END;
    
    -- basic item field values
    IF v_wcomm_invoices_cnt > 0 THEN
       FOR i IN (SELECT intrmdry_intm_no
                     FROM TABLE(GIPI_WCOMM_INVOICES_PKG.get_gipi_wcomm_invoices2(p_par_id))
                  WHERE ROWNUM = 1)
       LOOP
              v_wcominv_intm_no := i.intrmdry_intm_no;
       END LOOP;
       
       FOR i IN (SELECT line_cd, assd_no, par_type
                          FROM GIPI_PARLIST
                  WHERE par_id = p_par_id)
       LOOP
              v_b240_line_cd  := i.line_cd;
           v_b240_assd_no  := i.assd_no;
           v_b240_par_type := i.par_type;
       END LOOP;
    END IF;
    
    BEGIN
        SELECT nvl(endt_yy,0)
          INTO p_var_endt_yy
            FROM gipi_wpolbas
        WHERE par_id = p_par_id;        
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    END;
    
    /* GET_DEFAULT_ASSURED_INTM */
    
    DECLARE        
        DUMMY  NUMBER;
        DUMMY2 GIIS_ASSURED_INTM.INTM_NO%TYPE;
        CTR NUMBER:=0;
        v_pol_flag    GIPI_WPOLBAS.pol_flag%TYPE;
    BEGIN
         IF v_b240_par_type = 'P' THEN
            BEGIN
               SELECT 1
                INTO DUMMY 
                FROM gipi_wcomm_invoices
               WHERE par_id = p_par_id;
     
            BEGIN
              SELECT INTM_NO 
                INTO DUMMY2
                FROM giis_assured_intm
               WHERE assd_no = v_b240_assd_no
                 AND line_cd = v_b240_line_cd;
    
              FOR V1 IN (SELECT INTM_NO 
                           FROM giis_assured_intm
                          WHERE assd_no = v_b240_assd_no
                            AND line_cd =  v_b240_line_cd) 
              LOOP
                IF v_wcominv_intm_no IS NOT NULL AND V1.INTM_NO = v_wcominv_intm_no THEN
                    p_v_lov_tag := 'FILTERED';
                    p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';
                ELSIF v_wcominv_intm_no IS NOT NULL AND V1.INTM_NO!=v_wcominv_intm_no THEN
                    p_v_lov_tag := 'UNFILTERED';  
                    p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';   
                END IF;
              END LOOP;
       
            EXCEPTION
              WHEN NO_DATA_FOUND THEN 
                     p_v_lov_tag := 'UNFILTERED';
                  p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';          
              WHEN TOO_MANY_ROWS THEN
                p_v_lov_tag := 'FILTERED';
                p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';
            END;   
     
          EXCEPTION    
            WHEN no_data_found THEN
              IF p_v_pol_flag = '2' THEN
                 FOR intm IN (SELECT a.intrmdry_intm_no 
                                FROM gipi_comm_invoice a, gipi_polbasic b, gipi_wpolnrep c
                               WHERE c.par_id    = p_par_id
                                 AND b.policy_id = c.old_policy_id
                                 AND b.policy_id = a.policy_id)
                 LOOP
                   CTR:=CTR+1;
                 END LOOP;                
              ELSE
                 FOR V1 IN(SELECT INTM_NO
                             FROM GIIS_ASSURED_INTM
                            WHERE ASSD_NO=v_b240_assd_no
                              AND LINE_cD=v_b240_line_cd)
                 LOOP
                   CTR:=CTR+1;
                 END LOOP;
              END IF;
              IF CTR>1 THEN 
                 p_v_lov_tag := 'FILTERED';
                 p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';                                 
              ELSIF CTR=1 THEN
                    --DEFAULT_INTRMDRY;
                   --run function on creation of new record on jsp
                   NULL;
              ELSIF CTR = 0 THEN           
                    p_var_param_req_def_intm := giac_parameters_pkg.v('REQ_DEF_INTM');
                    IF p_var_param_req_def_intm = 'Y' THEN
                           --p_msg_alert := 'There is no default intermediary for this assured.';
                        p_msg_alert := 'NO_DEFAULT_INTM';                             
                        p_v_lov_tag := 'UNFILTERED';
                        RETURN;                                                   
                    ELSE
                       p_v_lov_tag := 'UNFILTERED';
                      p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';
                     END IF;
                  END IF;    
            WHEN too_many_rows then
              FOR V1 IN (SELECT INTM_NO 
                           FROM giis_assured_intm
                          WHERE assd_no = v_b240_assd_no
                            AND line_cd = v_b240_line_cd) 
              LOOP
                 IF v_wcominv_intm_no IS NOT NULL AND V1.INTM_NO=v_wcominv_intm_no THEN
                      p_v_lov_tag := 'FILTERED';
                      p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';
                 ELSIF v_wcominv_intm_no IS NOT NULL AND DUMMY2!=v_wcominv_intm_no THEN
                    p_v_lov_tag := 'UNFILTERED';
                    p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';          
                 END IF;            
              END LOOP;      
          END;
       ELSE   
          BEGIN
              SELECT 1
                INTO DUMMY 
                FROM gipi_wcomm_invoices
               WHERE par_id = p_par_id;
            BEGIN
              select a.intrmdry_intm_no
                into dummy2 
               from gipi_comm_invoice a, 
                    gipi_wpolbas b, gipi_polbasic c                             
              Where b.par_id = p_par_id 
                and b.line_cd = c.line_cd 
                and b.subline_cd = c.subline_cd 
                and b.iss_cd = c.iss_cd 
                and b.issue_yy = c.issue_yy 
                and b.pol_seq_no = c.pol_seq_no
                and b.renew_no=c.renew_no 
                and c.policy_id = a.policy_id;
    
              FOR V1 IN (select a.intrmdry_intm_no 
                           from gipi_comm_invoice a, 
                                gipi_wpolbas b, gipi_polbasic c                             
                          Where b.par_id = p_par_id 
                            and b.line_cd = c.line_cd 
                            and b.subline_cd = c.subline_cd 
                            and b.iss_cd = c.iss_cd 
                            and b.issue_yy = c.issue_yy 
                            and b.pol_seq_no = c.pol_seq_no
                            and b.renew_no=c.renew_no 
                            and c.policy_id = a.policy_id) 
              LOOP
                 IF v_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO=v_wcominv_intm_no THEN
                      p_v_lov_tag := 'FILTERED';
                      p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
                 ELSIF v_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO!=v_wcominv_intm_no THEN
                    p_v_lov_tag := 'UNFILTERED';
                    p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';          
                 END IF;            
              END LOOP;      
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                      p_v_lov_tag := 'UNFILTERED';
                       p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';              
              WHEN TOO_MANY_ROWS THEN
                   p_v_lov_tag := 'FILTERED';
                   p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
            END;
          EXCEPTION  
            WHEN no_data_found THEN
                 FOR V1 IN(select distinct a.intrmdry_intm_no 
                             from gipi_comm_invoice a, 
                                  gipi_wpolbas b, 
                                  gipi_polbasic c                             
                            Where b.par_id = p_par_id 
                              and b.line_cd = c.line_cd 
                              and b.subline_cd = c.subline_cd 
                              and b.iss_cd = c.iss_cd 
                              and b.issue_yy = c.issue_yy 
                              and b.pol_seq_no = c.pol_seq_no
                              and b.renew_no=c.renew_no 
                              and c.policy_id = a.policy_id
                              and a.policy_id = nvl(b.cancelled_endt_id,c.policy_id))
                 LOOP
                   CTR:=CTR+1;
                 END LOOP;
                 IF CTR>1 THEN 
                    p_v_lov_tag := 'FILTERED';
                    p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
                 ELSIF CTR=1 THEN 
                     --  DEFAULT_INTRMDRY;
                    GIPIS085_DEFAULT_INTRMDRY(p_par_id, p_intm_no, p_dsp_intm_name, p_parent_intm_no);
                    -- get parent_intm_name
                    p_parent_intm_name := NULL;
                    
                    FOR intm IN (SELECT intm_name
                                   FROM giis_intermediary
                                  WHERE intm_no = p_parent_intm_no)
                    LOOP
                        p_parent_intm_name := intm.intm_name;
                    END LOOP;
                    
                    IF p_parent_intm_name IS NULL THEN
                       p_parent_intm_name := p_dsp_intm_name;
                    END IF;
                     
                    NULL;
                 ELSIF CTR = 0 THEN
                      p_var_param_req_def_intm := giac_parameters_pkg.v('REQ_DEF_INTM');  
                       IF p_var_param_req_def_intm = 'Y' THEN 
                              --p_msg_alert := 'There is no default intermediary for this assured.';
                         p_msg_alert := 'NO_DEFAULT_INTM';                                                                                                   
                            p_v_lov_tag := 'UNFILTERED';                                                   
                       ELSE
                       p_v_lov_tag := 'UNFILTERED';
                         p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';      
                       END IF;
                 END IF;          
               when too_many_rows then
                 FOR V1 IN (select a.intrmdry_intm_no 
                              from gipi_comm_invoice a, 
                                   gipi_wpolbas b, gipi_polbasic c                             
                             Where b.par_id = p_par_id 
                               and b.line_cd = c.line_cd 
                               and b.subline_cd = c.subline_cd 
                               and b.iss_cd = c.iss_cd 
                               and b.issue_yy = c.issue_yy 
                               and b.pol_seq_no = c.pol_seq_no
                               and b.renew_no=c.renew_no 
                               and c.policy_id = a.policy_id) 
                 LOOP
                    IF v_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO=v_wcominv_intm_no THEN
                         p_v_lov_tag := 'FILTERED';
                            p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
                    ELSIF v_wcominv_intm_no IS NOT NULL AND DUMMY2!=v_wcominv_intm_no THEN
                       p_v_lov_tag := 'UNFILTERED';
                         p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';   
                    END IF;            
                 END LOOP;      
           END;
       END IF;
    END;
    
    /* End of GET_DEFAULT_ASSURED_INTM */
    
    BEGIN
         p_v_ora2010_sw := giis_parameters_pkg.v('ORA2010_SW');
         p_v_validate_banca := BANCASSURANCE.validate_bancassurance(p_par_id);
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
               NULL;
    END;
    
    BEGIN
        SELECT banc_type_cd
          INTO v_banc_type_cd 
          FROM GIPI_WPOLBAS 
         WHERE par_id = p_par_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             NULL;
    END;

    BEGIN
         IF p_v_ora2010_sw = 'Y' AND p_v_validate_banca = 'Y' THEN
            IF v_wcominv_intm_no IS NULL THEN
               --p_message := 'This is a bancassurance record. Please check the list of intermediaries.');
               p_bancassurance_rec := 'Y';
                /*IF ALERT_BUTTON = alert_button1    THEN                             
                   animate_popup('BANC_WINDOW', 'Bancassurance', 'BANC_CANVAS', 'BANCA','show');   
                END IF*/
            END IF;
            
        ELSE
            --set_item_property('BANCA_B.banca_but',visible, property_FALSE);
            p_banca_btn_enabled := 'N';    
        END IF;
    END; --end
    
    p_var_banc_rate_sw := 'N';
    BEGIN --for new bancassurance checkbox and button
         IF p_v_ora2010_sw = 'Y' THEN
              --set_item_property('WCOMINV.banca_check',visible, property_true);
             --set_item_property('BANCA_B.banca_but',visible, property_true);
              p_banca_check_enabled := 'Y';
              p_banca_btn_enabled := 'Y';
         ELSE
                 --set_item_property('WCOMINV.banca_check',visible, property_FALSE);
             --set_item_property('BANCA_B.banca_but',visible, property_FALSE);
             p_banca_check_enabled := 'N';
             p_banca_btn_enabled := 'N';
         END IF;
    END;
    
    -- get par_type and endt_tax
    FOR tp IN (
      SELECT par_type
          FROM gipi_parlist
         WHERE par_id = p_par_id)
      LOOP 
        p_v_par_type := tp.par_type;
    END LOOP;
          
    FOR endttax IN (
        SELECT endt_tax    
          FROM gipi_wendttext
         WHERE par_id = p_par_id)
    LOOP
       p_v_endt_tax := endttax.endt_tax;
    END LOOP;
    
    -- get pol_flag
    BEGIN
        SELECT pol_flag
            INTO p_v_pol_flag
            FROM GIPI_WPOLBAS
          WHERE par_id = p_par_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_v_pol_flag := 1;
    END;
    
    DECLARE
            v_partype    GIPI_parlist.par_type%type;
            v_pol_flag    gipi_wpolbas.pol_flag%type;
    BEGIN
        BEGIN
            SELECT par_type
              INTO v_partype
              FROM gipi_parlist
             WHERE par_id = p_par_id;
        END;
        BEGIN
            SELECT pol_flag
              INTO v_pol_flag
              FROM gipi_wpolbas
             WHERE par_id = p_par_id;
        END;
        IF v_partype = 'E' THEN
            IF v_pol_flag = 4 or nvl(p_global_cancel_tag, 'N') = 'Y' THEN
                /*-- mark jm 01.05.09 to allow updates based on enabled property starts here */    
                --msg_alert('This is a cancellation type of endorsement, update/s of any details will not be allowed.', 'W', FALSE);
                p_cancellation_type := 'Y';
            END IF;
        END IF;
        
        OPEN p_banc_type FOR
          SELECT banc_type_cd, banc_type_desc, rate, user_id, last_update
            FROM GIIS_BANC_TYPE
           WHERE banc_type_cd = NVL(v_banc_type_cd, '');
           
        OPEN p_banc_type_dtl_list FOR
          SELECT a.item_no, a.intm_no, b.intm_name, a.intm_type, a.fixed_tag, a.banc_type_cd, c.intm_desc intm_type_desc, a.share_percentage,
                      d.intm_no parent_intm_no, d.intm_name parent_intm_name
              FROM GIIS_BANC_TYPE_DTL a, GIIS_INTERMEDIARY b, GIIS_INTM_TYPE c, GIIS_INTERMEDIARY d
           WHERE a.banc_type_cd = NVL(v_banc_type_cd, '')
             AND a.intm_no = b.intm_no
             AND a.intm_type = c.intm_type
             AND b.parent_intm_no = d.intm_no (+)
        ORDER BY a.intm_no;
        
        -- other variables
        p_v_gipi_wpolnrep_exist := 'N';
        FOR a IN (SELECT 1 
                    FROM GIPI_WPOLNREP
                   WHERE par_id = p_par_id)
        LOOP
          p_v_gipi_wpolnrep_exist := 'Y';
        END LOOP;
        
        -- other variables (for enhancement)
        BEGIN
            SELECT GIIS_PARAMETERS_PKG.v('OVERRIDE_COMM_WHTAX')
              INTO p_var_override_whtax
              FROM DUAL;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 NULL;
        END;
          
        BEGIN
            SELECT comm_update_tag
              INTO p_var_v_comm_update_tag   
              FROM giis_users
               WHERE USER_ID = NVL(giis_users_pkg.app_user, USER);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 NULL;
        END;
         
         FOR i IN (SELECT PARAM_VALUE_V
                     FROM giac_parameters
                    WHERE param_name = 'SHOW_COMM_AMT')
         LOOP
            p_var_v_param_show_comm := i.param_value_v;
         END LOOP;
          
         BEGIN
               SELECT Giisp.v('ALLOW_APPLY_SLIDING_COMM')
                INTO p_v_allow_apply_sl_comm
                FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 NULL;
         END;
    END;
END gipis085_new_form_instance;
/


