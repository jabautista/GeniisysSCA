CREATE OR REPLACE PACKAGE BODY CPI.GIUTS032_PKG
AS
    FUNCTION get_giuts032_pol_lov
    (
            p_line_cd       VARCHAR2,
            p_subline_cd    VARCHAR2,
            p_iss_cd        VARCHAR2,
            p_issue_yy      VARCHAR2,
            p_pol_seq_no    VARCHAR2,
            p_renew_no      VARCHAR2,
            p_user_id       giis_users.user_id%TYPE
    )
            RETURN giuts032_pol_lov_tab PIPELINED
    IS
        v_list giuts032_pol_lov_type;
        v_line_cd    VARCHAR2(2);
    BEGIN
        v_line_cd := giisp.v('LINE_CODE_MC');
    
        FOR i IN(  
                SELECT policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy, endt_seq_no, assd_no,
                       incept_date, expiry_date, eff_date, endt_expiry_date
                  FROM GIPI_POLBASIC
                 WHERE check_user_per_line2(line_cd, iss_cd, 'GIUTS032', p_user_id) = 1
                   AND check_user_per_iss_cd2(line_cd, iss_cd, 'GIUTS032', p_user_id) = 1
                   --AND line_cd = v_line_cd    Comment out by Sam 06.24.2014
                   AND line_cd IN(SELECT DECODE (menu_line_cd, NULL, line_cd, line_cd)
                                    FROM giis_line
                                   WHERE (menu_line_cd = v_line_cd OR line_cd = v_line_cd)
                                     AND line_cd = NVL (p_line_cd, line_cd)) --Added by Sam 06.24.2014
                   AND pol_flag <> '5'
                   AND line_cd = NVL(p_line_cd,line_cd)
                   AND subline_cd = NVL(p_subline_cd,subline_cd)
                   AND iss_cd = NVL(p_iss_cd, iss_cd)
                   AND issue_yy = NVL(p_issue_yy, issue_yy)
                   AND pol_seq_no = NVL(p_pol_seq_no, pol_seq_no)
                   AND renew_no = NVL(p_renew_no, renew_no)
               )
        LOOP
            v_list.policy_id         := i.policy_id;       
            v_list.line_cd           := i.line_cd;         
            v_list.subline_cd        := i.subline_cd;      
            v_list.iss_cd            := i.iss_cd;          
            v_list.issue_yy          := i.issue_yy;        
            v_list.pol_seq_no        := i.pol_seq_no;      
            v_list.renew_no          := i.renew_no;        
            v_list.endt_iss_cd       := i.endt_iss_cd;     
            v_list.endt_yy           := i.endt_yy;         
            v_list.endt_seq_no       := i.endt_seq_no;     
            v_list.assd_no           := i.assd_no;         
            v_list.assd_name         := GET_ASSD_NAME(i.assd_no);       
            v_list.incept_date       := i.incept_date;     
            v_list.expiry_date       := i.expiry_date;     
            v_list.eff_date          := i.eff_date;        
            v_list.endt_expiry_date  := i.endt_expiry_date;
            
            IF v_list.endt_seq_no = 0 THEN
                v_list.endt_iss_cd       := '';     
                v_list.endt_yy           := '';       
                v_list.endt_seq_no       := '';
            END IF;
            
            PIPE ROW(v_list);
        END LOOP;
        RETURN;
     
    END get_giuts032_pol_lov;
    
    FUNCTION get_giuts032_table(
        p_policy_id     VARCHAR2
    )
    RETURN giuts032_table_tab PIPELINED
    IS
        v_list giuts032_table_type;
    BEGIN
        FOR i IN(  
                SELECT a.policy_id, a.item_no, a.item_title, b.mv_file_no
                  FROM gipi_item a, gipi_vehicle b, gipi_polbasic c
                 WHERE a.policy_id = b.policy_id 
                   AND a.item_no = b.item_no
                   AND a.policy_id = p_policy_id
                   AND a.policy_id = C.policy_id 
                   AND LINE_CD = giisp.v('LINE_CODE_MC')
               )
        LOOP
            v_list.policy_id          := i.policy_id;       
            v_list.item_no            := i.item_no;         
            v_list.item_title         := i.item_title;      
            v_list.mv_file_no         := i.mv_file_no;          
            
            PIPE ROW(v_list);
        END LOOP;
        RETURN;
     
    END get_giuts032_table;
    
    
   PROCEDURE save_update_mv_file_number (p_mv_file_number VARCHAR2, p_policy_id VARCHAR2, p_item_no VARCHAR2)
   IS
   BEGIN
      UPDATE gipi_vehicle
         SET mv_file_no = p_mv_file_number
       WHERE policy_id  = p_policy_id
         AND item_no    = p_item_no;
   END;
END;
/


