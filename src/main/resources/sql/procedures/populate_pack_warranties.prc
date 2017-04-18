DROP PROCEDURE CPI.POPULATE_PACK_WARRANTIES;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_PACK_WARRANTIES(
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_pack_wpolwc.pack_par_id%TYPE,
    p_msg             OUT  VARCHAR2
) 
IS
  --rg_id               RECORDGROUP;
  rg_name             VARCHAR2(30) := 'GROUP_PACK_POLICY';
  rg_count            NUMBER;
  rg_count2           NUMBER;
  rg_col              VARCHAR2(50) := rg_name || '.policy_id';
  v_row               NUMBER;
  v_policy_id         gipi_polbasic.policy_id%TYPE;
  v_endt_id           gipi_polbasic.policy_id%TYPE;
  item_exist          VARCHAR2(1) := 'N';
  exist1              VARCHAR2(1) := 'N';
  
  v_line_cd       gipi_polbasic.line_cd%TYPE;
  v_subline_cd    gipi_polbasic.subline_cd%TYPE;
  v_iss_cd        gipi_polbasic.iss_cd%TYPE;
  v_issue_yy      gipi_polbasic.issue_yy%TYPE;
  v_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE;
  v_renew_no      gipi_polbasic.renew_no%TYPE;
BEGIN 
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-20-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_PACK_WARRANTIES program unit 
  */
  GET_POLICY_GROUP_RECORD(rg_name, p_old_pol_id, p_proc_summary_sw, v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, p_msg);
   IF NVL(p_proc_summary_sw,'N') = 'N'  THEN
    FOR b IN(SELECT pack_policy_id policy_id, nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_pack_polbasic
              WHERE line_cd     =  v_line_cd
                AND subline_cd  =  v_subline_cd
                AND iss_cd      =  v_iss_cd
                AND issue_yy    =  to_char(v_issue_yy)
                AND pol_seq_no  =  to_char(v_pol_seq_no)
                AND renew_no    =  to_char(v_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
                AND NVL(endt_seq_no,0) = 0
              ORDER BY eff_date, endt_seq_no)
        LOOP  
            v_policy_id   := b.policy_id;    
             FOR wc IN (
                 SELECT line_cd, wc_cd, swc_seq_no, print_seq_no, wc_title,
                        wc_text01,wc_text02,wc_text03,wc_text04,
                        wc_text05,wc_text06,wc_text07,wc_text08,
                        wc_text09,wc_text10,wc_text11,wc_text12,
                        wc_text13,wc_text14,wc_text15,wc_text16,
                        wc_text17,wc_remarks, change_tag, print_sw
                   FROM gipi_pack_polwc
                  WHERE pack_policy_id = v_policy_id)
             LOOP
                  item_exist := 'N';
                  FOR CHK IN (SELECT '1'
                                FROM gipi_pack_wpolwc
                               WHERE pack_par_id = p_new_par_id 
                                 AND line_cd = wc.line_cd
                                 AND wc_cd  = wc.wc_cd
                                 AND swc_seq_no = wc.swc_seq_no)
                  LOOP 
                     item_exist := 'Y';
                  END LOOP;
                          
                 IF item_exist = 'N' THEN
                    FOR b1 IN(SELECT pack_policy_id policy_id, nvl(endt_seq_no,0) endt_seq_no, pol_flag
                               FROM gipi_pack_polbasic
                              WHERE line_cd     =  v_line_cd
                                AND subline_cd  =  v_subline_cd
                                AND iss_cd      =  v_iss_cd
                                AND issue_yy    =  to_char(v_issue_yy)
                                AND pol_seq_no  =  to_char(v_pol_seq_no)
                                AND renew_no    =  to_char(v_renew_no)
                                AND (endt_seq_no = 0 OR 
                                    (endt_seq_no > 0 AND 
                                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                                AND pol_flag In ('1','2','3')
                                AND NVL(endt_seq_no,0) = 0
                              ORDER BY eff_date, endt_seq_no)
                     LOOP      
                          v_endt_id  := b1.policy_id;
                          FOR wc2 IN ( SELECT print_seq_no, wc_title,
                                              wc_text01,wc_text02,wc_text03,wc_text04,
                                              wc_text05,wc_text06,wc_text07,wc_text08,
                                              wc_text09,wc_text10,wc_text11,wc_text12,
                                              wc_text13,wc_text14,wc_text15,wc_text16,
                                              wc_text17,wc_remarks, change_tag,
                                              print_sw
                                         FROM gipi_pack_polwc
                                        WHERE pack_policy_id = v_endt_id
                                          AND line_cd = wc.line_cd
                                          AND wc_cd  = wc.wc_cd
                                          AND swc_seq_no = wc.swc_seq_no)
                          LOOP
                              wc.change_tag := wc2.change_tag;
                              wc.wc_title   := wc2.wc_title; 
                              wc.wc_text01  := wc2.wc_text01;
                              wc.wc_text02  := wc2.wc_text02;
                              wc.wc_text03  := wc2.wc_text03;
                              wc.wc_text04  := wc2.wc_text04;
                              wc.wc_text05  := wc2.wc_text05;
                              wc.wc_text06  := wc2.wc_text06;
                              wc.wc_text07  := wc2.wc_text07;
                              wc.wc_text08  := wc2.wc_text08;
                              wc.wc_text09  := wc2.wc_text09;
                              wc.wc_text10  := wc2.wc_text10;
                              wc.wc_text11  := wc2.wc_text11;
                              wc.wc_text12  := wc2.wc_text12;
                              wc.wc_text13  := wc2.wc_text13;
                              wc.wc_text14  := wc2.wc_text14;
                              wc.wc_text15  := wc2.wc_text15;
                              wc.wc_text16  := wc2.wc_text16;
                              wc.wc_text17  := wc2.wc_text17;
                              wc.wc_remarks := NVL(wc2.wc_remarks, wc.wc_remarks);
                              wc.print_sw   := NVL(wc2.print_sw, wc.print_sw);
                          END LOOP;
                     END LOOP;
                    INSERT INTO gipi_pack_wpolwc(
                           pack_par_id,            line_cd,   
                           swc_seq_no,             print_seq_no,
                           wc_title,               wc_text01, 
                           wc_text02,              wc_text03,
                           wc_text04,              wc_text05,
                           wc_text06,              wc_text07,
                           wc_text08,              wc_text09,
                           wc_text10,              wc_text11,
                           wc_text12,              wc_text13,
                           wc_text14,              wc_text15,
                           wc_text16,              wc_text17,
                           wc_remarks,             wc_cd,
                           change_tag,             print_sw)        
                     VALUES(p_new_par_id,          wc.line_cd, 
                           wc.swc_seq_no,          wc.print_seq_no,
                           wc.wc_title,            wc.wc_text01,
                           wc.wc_text02,           wc.wc_text03,
                           wc.wc_text04,           wc.wc_text05, 
                           wc.wc_text06,           wc.wc_text07,
                           wc.wc_text08,           wc.wc_text09, 
                           wc.wc_text10,           wc.wc_text11,
                           wc.wc_text12,           wc.wc_text13, 
                           wc.wc_text14,           wc.wc_text15,
                           wc.wc_text16,           wc.wc_text17, 
                           wc.wc_remarks,          wc.wc_cd,
                           wc.change_tag,          wc.print_sw);
                     --CLEAR_MESSAGE;
                     --MESSAGE('Copying package warranties and clauses info ...',NO_ACKNOWLEDGE);
                     --SYNCHRONIZE;
                 END IF;      
             END LOOP;
        END LOOP;
   ELSIF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
    FOR b IN(SELECT pack_policy_id policy_id, nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_pack_polbasic
              WHERE line_cd     =  v_line_cd
                AND subline_cd  =  v_subline_cd
                AND iss_cd      =  v_iss_cd
                AND issue_yy    =  to_char(v_issue_yy)
                AND pol_seq_no  =  to_char(v_pol_seq_no)
                AND renew_no    =  to_char(v_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
              ORDER BY eff_date, endt_seq_no)
        LOOP  
            v_policy_id   := b.policy_id;
            --v_row        := row_no + 1;      
             FOR wc IN (
                 SELECT line_cd, wc_cd, swc_seq_no, print_seq_no, wc_title,
                        wc_text01,wc_text02,wc_text03,wc_text04,
                        wc_text05,wc_text06,wc_text07,wc_text08,
                        wc_text09,wc_text10,wc_text11,wc_text12,
                        wc_text13,wc_text14,wc_text15,wc_text16,
                        wc_text17,wc_remarks, change_tag, print_sw
                   FROM gipi_pack_polwc
                  WHERE pack_policy_id = v_policy_id)
             LOOP
                  item_exist := 'N';
                  FOR CHK IN (SELECT '1'
                                FROM gipi_pack_wpolwc
                               WHERE pack_par_id = p_new_par_id 
                                 AND line_cd = wc.line_cd
                                 AND wc_cd  = wc.wc_cd
                                 AND swc_seq_no = wc.swc_seq_no)
                  LOOP 
                     item_exist := 'Y';
                  END LOOP;
                          
                 IF item_exist = 'N' THEN
                    FOR b1 IN(SELECT pack_policy_id policy_id, nvl(endt_seq_no,0) endt_seq_no, pol_flag
                               FROM gipi_pack_polbasic
                              WHERE line_cd     =  v_line_cd
                                AND subline_cd  =  v_subline_cd
                                AND iss_cd      =  v_iss_cd
                                AND issue_yy    =  to_char(v_issue_yy)
                                AND pol_seq_no  =  to_char(v_pol_seq_no)
                                AND renew_no    =  to_char(v_renew_no)
                                AND (endt_seq_no = 0 OR 
                                    (endt_seq_no > 0 AND 
                                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                                AND pol_flag In ('1','2','3')
                              ORDER BY eff_date, endt_seq_no)
                     LOOP      
                          v_endt_id  := b1.policy_id;
                          FOR wc2 IN ( SELECT print_seq_no, wc_title,
                                              wc_text01,wc_text02,wc_text03,wc_text04,
                                              wc_text05,wc_text06,wc_text07,wc_text08,
                                              wc_text09,wc_text10,wc_text11,wc_text12,
                                              wc_text13,wc_text14,wc_text15,wc_text16,
                                              wc_text17,wc_remarks, change_tag,
                                              print_sw
                                         FROM gipi_pack_polwc
                                        WHERE pack_policy_id = v_endt_id
                                          AND line_cd = wc.line_cd
                                          AND wc_cd  = wc.wc_cd
                                          AND swc_seq_no = wc.swc_seq_no)
                          LOOP
                              wc.change_tag := wc2.change_tag;
                              wc.wc_title   := wc2.wc_title; 
                              wc.wc_text01  := wc2.wc_text01;
                              wc.wc_text02  := wc2.wc_text02;
                              wc.wc_text03  := wc2.wc_text03;
                              wc.wc_text04  := wc2.wc_text04;
                              wc.wc_text05  := wc2.wc_text05;
                              wc.wc_text06  := wc2.wc_text06;
                              wc.wc_text07  := wc2.wc_text07;
                              wc.wc_text08  := wc2.wc_text08;
                              wc.wc_text09  := wc2.wc_text09;
                              wc.wc_text10  := wc2.wc_text10;
                              wc.wc_text11  := wc2.wc_text11;
                              wc.wc_text12  := wc2.wc_text12;
                              wc.wc_text13  := wc2.wc_text13;
                              wc.wc_text14  := wc2.wc_text14;
                              wc.wc_text15  := wc2.wc_text15;
                              wc.wc_text16  := wc2.wc_text16;
                              wc.wc_text17  := wc2.wc_text17;
                              wc.wc_remarks := NVL(wc2.wc_remarks, wc.wc_remarks);
                              wc.print_sw   := NVL(wc2.print_sw, wc.print_sw);
                          END LOOP;
                     END LOOP; 
                    INSERT INTO gipi_pack_wpolwc(
                           pack_par_id,                 line_cd,   
                           swc_seq_no,             print_seq_no,
                           wc_title,               wc_text01, 
                           wc_text02,              wc_text03,
                           wc_text04,              wc_text05,
                           wc_text06,              wc_text07,
                           wc_text08,              wc_text09,
                           wc_text10,              wc_text11,
                           wc_text12,              wc_text13,
                           wc_text14,              wc_text15,
                           wc_text16,              wc_text17,
                           wc_remarks,             wc_cd,
                           change_tag,             print_sw)        
                     VALUES(p_new_par_id,          wc.line_cd, 
                           wc.swc_seq_no,          wc.print_seq_no,
                           wc.wc_title,            wc.wc_text01,
                           wc.wc_text02,           wc.wc_text03,
                           wc.wc_text04,           wc.wc_text05, 
                           wc.wc_text06,           wc.wc_text07,
                           wc.wc_text08,           wc.wc_text09, 
                           wc.wc_text10,           wc.wc_text11,
                           wc.wc_text12,           wc.wc_text13, 
                           wc.wc_text14,           wc.wc_text15,
                           wc.wc_text16,           wc.wc_text17, 
                           wc.wc_remarks,          wc.wc_cd,
                           wc.change_tag,          wc.print_sw);
                     --CLEAR_MESSAGE;
                     --MESSAGE('Copying package warranties and clauses info ...',NO_ACKNOWLEDGE);
                     --SYNCHRONIZE;
                 END IF;      
             END LOOP;
        END LOOP;
   END IF;   
END;
/


