CREATE OR REPLACE PACKAGE BODY CPI.Giis_Reinsurer_Pkg AS
  
/********************************** FUNCTION 1 ************************************
  MODULE:  GIACS008 
  RECORD GROUP NAME: LOV_REINSURER 
***********************************************************************************/ 
  FUNCTION get_reinsurer_list RETURN reinsurer_list_tab PIPELINED IS
     v_reinsurer reinsurer_list_type;
  BEGIN
         FOR i IN (SELECT DISTINCT c.ri_cd, c.ri_name, c.ri_sname, E.transaction_type
                       FROM gipi_invoice A,
                           giri_inpolbas b,
                        giis_reinsurer c,
                        giac_aging_ri_soa_details d,
                        giac_inwfacul_prem_collns E
                  WHERE A.prem_seq_no = d.prem_seq_no
                    AND A.policy_id = b.policy_id
                    AND d.a180_ri_cd = c.ri_cd
                    --AND e.transaction_type IN TO_NUMBER (:GLOBAL.tr_type) 
                    AND E.a180_ri_cd IN (d.a180_ri_cd, c.ri_cd)
                    /*Added by pjsantos 11/23/2016, for optimization GENQA 5846*/
                    AND d.a180_ri_cd = E.a180_ri_cd
                    AND e.inst_no = d.inst_no
                    AND e.b140_prem_seq_no = a.prem_seq_no 
                    AND e.b140_iss_cd = a.iss_cd
                    --pjsantos end
                  ORDER BY c.ri_name)
       LOOP
         v_reinsurer.ri_cd                := i.ri_cd;
         v_reinsurer.ri_name              := i.ri_name;
         v_reinsurer.ri_sname              := i.ri_sname;
         v_reinsurer.transaction_type     := i.transaction_type;
         
         PIPE ROW(v_reinsurer);
       END LOOP;        
  RETURN;
  END get_reinsurer_list;
  
/********************************** FUNCTION 2 ************************************
  MODULE:  GIACS008 
  RECORD GROUP NAME: LOV_REINSURER2 
***********************************************************************************/ 
  FUNCTION get_reinsurer_list2 RETURN reinsurer_list_tab PIPELINED IS
       v_reinsurer reinsurer_list_type;
  BEGIN
         FOR i IN (SELECT DISTINCT c.ri_cd, c.ri_name, c.ri_sname
                      FROM gipi_invoice A,
                           giri_inpolbas b,
                           giis_reinsurer c,
                        giac_aging_ri_soa_details d
                  WHERE A.prem_seq_no = d.prem_seq_no
                    AND A.policy_id = b.policy_id
                    AND d.a180_ri_cd = c.ri_cd
                    AND d.a180_ri_cd = b.ri_cd -- added by pjsantos 11/23/2016 for optimization, GENQA 5846
                     ORDER BY c.ri_name)
       LOOP
         v_reinsurer.ri_cd                := i.ri_cd;
         v_reinsurer.ri_name              := i.ri_name;
         v_reinsurer.ri_sname              := i.ri_sname;
         
         PIPE ROW(v_reinsurer);
       END LOOP;        
  RETURN;
  END get_reinsurer_list2;
  
/********************************** FUNCTION 3 ************************************
  MODULE:  GIACS009 
  RECORD GROUP NAME: LOV_REINSURERS_1_1 to LOV_REINSURERS_1_3
***********************************************************************************/ 
  FUNCTION get_reinsurer_list3(p_share_type     gicl_advs_fla.share_type%TYPE)
  RETURN reinsurer_list_tab PIPELINED IS
       v_reinsurer reinsurer_list_type;
  BEGIN
         FOR i IN (SELECT DISTINCT a180.ri_cd ri_cd, a180.ri_name ri_name
                   FROM giis_reinsurer a180
                  WHERE a180.ri_cd IN (
                           SELECT e150.ri_cd
                             FROM gicl_advs_fla e150
                            WHERE a180.ri_cd = e150.ri_cd
                              AND e150.share_type = p_share_type
                              AND (e150.cancel_tag <> 'Y' OR e150.cancel_tag IS NULL))
                  ORDER BY upper(ri_name))
       LOOP
         v_reinsurer.ri_cd                := i.ri_cd;
         v_reinsurer.ri_name              := i.ri_name;
         --v_reinsurer.ri_sname              := i.ri_sname;
         PIPE ROW(v_reinsurer);
       END LOOP;        
  RETURN;
  END get_reinsurer_list3;
  
/********************************** FUNCTION 4 ************************************
  MODULE:  GIACS009 
  RECORD GROUP NAME: LOV_REINSURERS_2_1 to LOV_REINSURERS_2_3
***********************************************************************************/ 
  FUNCTION get_reinsurer_list4(p_share_type     giac_loss_ri_collns.share_type%TYPE)
  RETURN reinsurer_list_tab PIPELINED IS
       v_reinsurer reinsurer_list_type;
  BEGIN
         FOR i IN (SELECT DISTINCT b.ri_cd, b.ri_name
                   FROM giac_loss_ri_collns A, giis_reinsurer b, giac_acctrans c
                  WHERE A.a180_ri_cd = b.ri_cd
                    AND A.gacc_tran_id = c.tran_id
                    AND c.tran_flag <> 'D'
                    AND A.share_type = p_share_type
                    AND NOT EXISTS (
                           SELECT '1'
                             FROM giac_reversals d, giac_acctrans E
                            WHERE E.tran_id = d.reversing_tran_id
                              AND d.gacc_tran_id = c.tran_id
                              AND E.tran_flag <> 'D')
                  ORDER BY upper(ri_name))
       LOOP
         v_reinsurer.ri_cd                := i.ri_cd;
         v_reinsurer.ri_name              := i.ri_name;
         --v_reinsurer.ri_sname              := i.ri_sname;
         PIPE ROW(v_reinsurer);
       END LOOP;        
  RETURN;
  END get_reinsurer_list4;
  
  /********************************** FUNCTION 1 ************************************
  MODULE:  GIACS026
  RECORD GROUP NAME: CGFK$GIPD_RI_NO
  ***********************************************************************************/ 
  FUNCTION get_reinsurer_list5(p_keyword    VARCHAR2)
    RETURN reinsurer_list_tab_2 PIPELINED IS
     v_reinsurer reinsurer_list_type_2;
  BEGIN
         FOR i IN (SELECT ri_cd, ri_name, ri_sname
                          FROM GIIS_REINSURER
                  WHERE ri_cd LIKE '%'||p_keyword||'%'
                     OR ri_name LIKE '%'||p_keyword||'%')
       LOOP
         v_reinsurer.ri_cd                := i.ri_cd;
         v_reinsurer.ri_name              := i.ri_name;
         v_reinsurer.ri_sname              := i.ri_sname;
         
         PIPE ROW(v_reinsurer);
       END LOOP;        
  RETURN;
  END get_reinsurer_list5;

    /*
    **  Created by      : D.Alcantara
    **  Date Created    : 04.28.2011
    **  Reference By    : (GIPIS153 - Enter Co-Insurer)
    **  Description     : Retrieves list for reinsurer lov
    */  
  FUNCTION get_reinsurer_list6(p_ri_name VARCHAR2, p_keyword VARCHAR2)
    RETURN reinsurer_list_tab_2 PIPELINED IS
     v_reinsurer reinsurer_list_type_2;
  BEGIN
         FOR i IN (SELECT ri_cd, ri_name, ri_sname
                          FROM GIIS_REINSURER
                  WHERE UPPER(ri_sname) LIKE NVL (UPPER (p_keyword), '%%')
                     OR upper(ri_name) LIKE NVL (UPPER (p_keyword), '%%')
                     ORDER BY ri_name, ri_sname)
                     --OR ri_sname LIKE '%'||UPPER(p_ri_name)||'%'
                     --OR ri_name LIKE '%'||UPPER(p_ri_name)||'%')
       LOOP
         v_reinsurer.ri_cd                := i.ri_cd;
         v_reinsurer.ri_name              := i.ri_name;
         v_reinsurer.ri_sname              := i.ri_sname;
         
         PIPE ROW(v_reinsurer);
       END LOOP;        
  RETURN;
  END get_reinsurer_list6;
  
  
  FUNCTION get_insurer_sname(p_ri_cd    GIIS_REINSURER.ri_cd%TYPE)
    RETURN VARCHAR2 IS
    v_sname     GIIS_REINSURER.ri_sname%TYPE;
  BEGIN
    BEGIN
        SELECT ri_sname
            INTO v_sname
        FROM giis_reinsurer
            WHERE ri_cd = p_ri_cd;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_sname := '';        
    END;
        
    RETURN v_sname;
  END get_insurer_sname;    
  
  
    /*
    **  Created by      : Jerome Orio  
    **  Date Created    : 07.01.2011
    **  Reference By    : (GIRIS001-Create RI Placement)
    **  Description     : Retrieves list for reinsurer lov
    */  
  FUNCTION get_reinsurer_list7
    RETURN reinsurer_main_list_tab PIPELINED IS
     v_list reinsurer_main_list_type;
  BEGIN
       FOR i IN (SELECT ri_cd,          ri_name,        ri_sname,
                        bill_address1,  bill_address2,  bill_address3
                   FROM GIIS_REINSURER
                  ORDER BY ri_sname)
       LOOP
         v_list.ri_cd                   := i.ri_cd;
         v_list.ri_name                 := i.ri_name;
         v_list.ri_sname                := i.ri_sname;
         v_list.bill_address1           := i.bill_address1;   
         v_list.bill_address2           := i.bill_address2;
         v_list.bill_address3           := i.bill_address3;
         PIPE ROW(v_list);
       END LOOP;        
  RETURN;
  END get_reinsurer_list7;
      
    FUNCTION get_input_vat_rt (v_ri_cd    IN    GIIS_REINSURER.ri_cd%TYPE) RETURN NUMBER IS
      v_input_vat                GIIS_REINSURER.input_vat_rate%TYPE := 0;
    BEGIN
      FOR A IN (SELECT input_vat_rate
                  FROM giis_reinsurer
                 WHERE ri_cd = v_ri_cd)
      LOOP
        v_input_vat := a.input_vat_rate;
        EXIT;
      END LOOP;
      RETURN(v_input_vat);
    END;
    
    /*
    **  Created by      : Robert Virrey  
    **  Date Created    : 01.04.2012
    **  Reference By    : (GIUTS024 Generate Binder (Non-Affecting Endorsement))
    **  Description     : Retrieves list for reinsurer lov
    */  
  FUNCTION get_reinsurer_list8(
    p_line_cd           gipi_polbasic.line_cd%TYPE,
    p_subline_cd        gipi_polbasic.subline_cd%TYPE,
    p_iss_cd            gipi_polbasic.iss_cd%TYPE,
    p_issue_yy          gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no          gipi_polbasic.renew_no%TYPE,
    p_policy_id         giri_endttext.policy_id%TYPE,
    p_ri_cd             giri_frps_ri.ri_cd%TYPE
  )
  RETURN reinsurer_list_tab_2 PIPELINED 
  IS
     v_reinsurer reinsurer_list_type_2;
  BEGIN
       FOR i IN   (SELECT DISTINCT e.ri_cd ri_cd, f.ri_name
                    FROM gipi_polbasic b, giuw_pol_dist c, giri_distfrps d, giri_frps_ri e, giis_reinsurer f
                   WHERE b.line_cd      = p_line_cd
                     AND b.subline_cd   = p_subline_cd
                     AND b.iss_cd       = p_iss_cd
                     AND b.issue_yy     = p_issue_yy
                     AND b.pol_seq_no   = p_pol_seq_no
                     AND b.renew_no     = p_renew_no
                     AND b.pol_flag     IN ('1','2','3')
                     AND b.policy_id    = c.policy_id
                     AND c.dist_no      = d.dist_no
                     AND d.line_cd      = e.line_cd
                     AND d.frps_yy      = e.frps_yy
                     AND d.frps_seq_no  = e.frps_seq_no
                     AND d.ri_flag      <> '4'
                     AND e.reverse_sw   = 'N'
                     AND e.ri_cd        = f.ri_cd
                     AND (NOT EXISTS ( SELECT g.ri_cd
                                        FROM giri_endttext g
                                       WHERE g.policy_id    = p_policy_id
                                         AND g.ri_cd        = e.ri_cd ) 
                                          OR e.ri_cd = NVL(p_ri_cd,0)))
       LOOP
         v_reinsurer.ri_cd                   := i.ri_cd;
         v_reinsurer.ri_name                 := i.ri_name;
         PIPE ROW(v_reinsurer);
       END LOOP;        
       RETURN;
  END get_reinsurer_list8;
  
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.21.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the ri_name and ri_sname from GIIS_REINSURER
    **                  with the given ri_cd
    */
       
    FUNCTION get_reinsurer_by_ri_cd(p_ri_cd   GIIS_REINSURER.ri_cd%TYPE)
    RETURN reinsurer_list_tab_2 PIPELINED AS

    v_reinsurer reinsurer_list_type_2;

    BEGIN
        FOR get_ri IN (SELECT ri_cd, ri_name, ri_sname
                         FROM GIIS_REINSURER
                        WHERE ri_cd = p_ri_cd)
        LOOP
          v_reinsurer.ri_cd := get_ri.ri_cd;
          v_reinsurer.ri_name := get_ri.ri_name;
          v_reinsurer.ri_sname := get_ri.ri_sname;
          PIPE ROW(v_reinsurer);
          RETURN;         
        END LOOP;
        
    END;
    
     /*
    **  Created by    : Steven P. Ramirez
    **  Date Created  : 05.17.2012
    **  Reference By  : GIACS019 - Out Facul Premium Payments
    **  Description   : Gets the ri_name and ri_cd from GIIS_REINSURER
    */
    
    FUNCTION get_reinsurer_list9
    RETURN reinsurer_list_tab_2 PIPELINED IS
     v_reinsurer reinsurer_list_type_2;
  BEGIN
         FOR i IN (SELECT DISTINCT b.ri_cd, b.ri_name
                      FROM giri_binder a, giis_reinsurer b
                     WHERE a.ri_cd = b.ri_cd
                     ORDER BY b.ri_name)
       LOOP
         v_reinsurer.ri_cd                := i.ri_cd;
         v_reinsurer.ri_name              := i.ri_name;
         PIPE ROW(v_reinsurer);
       END LOOP;        
  RETURN;
  END get_reinsurer_list9;
  
       /*
    **  Created by    : Steven P. Ramirez
    **  Date Created  : 12.14.2012
    **  Reference By  : GIACS026 - Premium Deposit
    **  Description   : Gets the ri_name and ri_cd from GIIS_REINSURER
    */
    
    FUNCTION get_reinsurer_list10
    RETURN reinsurer_list_tab_2 PIPELINED IS
     v_reinsurer reinsurer_list_type_2;
  BEGIN
         FOR i IN (SELECT ri_cd, ri_name 
                     FROM giis_reinsurer 
                    ORDER by ri_name)
       LOOP
         v_reinsurer.ri_cd                := i.ri_cd;
         v_reinsurer.ri_name              := i.ri_name;
         PIPE ROW(v_reinsurer);
       END LOOP;        
  RETURN;
  END get_reinsurer_list10;
  
    FUNCTION get_cedant_lov 
    RETURN reinsurer_list_tab_3 PIPELINED AS
     v_reinsurer reinsurer_list_type_3;
  BEGIN
        FOR i IN (SELECT DISTINCT a.ri_cd, b.ri_name
                    FROM giis_reinsurer b, gicl_claims a
                    WHERE a.ri_cd = b.ri_cd
                    ORDER BY b.ri_name)
     LOOP
        v_reinsurer.ri_cd   := i.ri_cd;
        v_reinsurer.ri_name := i.ri_name;
        PIPE ROW(v_reinsurer);
     END LOOP;
  END get_cedant_lov;
  /*
    **  Created by    : Paul Joseph Diaz
    **  Date Created  : 01.30.2013
    **  Reference By  : GIACS267- Claim listing per Ceding Company
    **  Description   : Gets the ri_name from GIIS_REINSURER base from ri_cd from GICL_CLAIMS
    */

    
    
    /*
    **  Created by    : Marie Kris Felipe
    **  Date Created  : 09.20.2013
    **  Reference By  : GICLS200 - Outstanding and Paid Claims per Catastrophic Event
    **  Description   : Retrieves LOV for RI
    */
    FUNCTION get_reinsurer_lov
        RETURN reinsurer_list_tab_3 PIPELINED
    IS
        v_ri   reinsurer_list_type_3;     
    BEGIN
    
        FOR rec IN (SELECT DISTINCT a.ri_cd, a.ri_name
                      FROM giis_reinsurer a,
                           gicl_os_pd_clm_rids_extr b,
                           gicl_os_pd_clm_ds_extr c
                     WHERE a.ri_cd = b.ri_cd
                       AND b.session_id = c.session_id
                       AND b.os_pd_rec_id = c.os_pd_rec_id
                       AND b.os_pd_ds_rec_id = c.os_pd_ds_rec_id
                       AND c.share_type = 4
                     ORDER BY a.ri_cd, a.ri_name)
        LOOP
            v_ri.ri_cd := rec.ri_cd;
            v_ri.ri_name := rec.ri_name;
            PIPE ROW(v_ri);
        END LOOP;
    END get_reinsurer_lov;
    
      
END Giis_Reinsurer_Pkg;
/


