DROP PROCEDURE CPI.CHECK_PACK_POLICY_GROUP;

CREATE OR REPLACE PROCEDURE CPI.CHECK_PACK_POLICY_GROUP(
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_rg_count        OUT  NUMBER,
    p_rg_pol_flag     OUT  gipi_wpolbas.pol_flag%TYPE,    
    p_rg_policy_id    OUT  gipi_polbasic.policy_id%TYPE,
    p_rg_endt_seq_no  OUT  gipi_polbasic.endt_seq_no%TYPE,
    p_row             OUT  NUMBER,
    p_msg             OUT  VARCHAR2
) 
IS
   --rg_id           RECORDGROUP;
   --rg_name         VARCHAR2(30) := p_name;
   --v_query         VARCHAR2(2000);   
   --v_errors        NUMBER;
   --rg_count        NUMBER;
   --rg_col1         VARCHAR2(50) := rg_name || '.POLICY_ID';
   --rg_col2         VARCHAR2(50) := rg_name || '.endt_seq_no';
   --rg_col3         VARCHAR2(50) := rg_name || '.pol_flag';
   --rg_endt_seq_no  gipi_polbasic.endt_seq_no%TYPE;
   --rg_pol_flag     gipi_wpolbas.pol_flag%TYPE;
   --rg_policy_id    gipi_polbasic.policy_id%TYPE;
   v_row           NUMBER := 0;
   v_line_cd       gipi_polbasic.line_cd%TYPE;
   v_subline_cd    gipi_polbasic.subline_cd%TYPE;
   v_iss_cd        gipi_polbasic.iss_cd%TYPE;
   v_issue_yy      gipi_polbasic.issue_yy%TYPE;
   v_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE;
   v_renew_no      gipi_polbasic.renew_no%TYPE;
   v_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE;
   v_sw            VARCHAR2(1) := 'N';
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-17-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : CHECK_PACK_POLICY_GROUP program unit 
  */
  FOR A IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
              FROM gipi_pack_polbasic
             WHERE pack_policy_id = p_old_pol_id)
  LOOP
    v_line_cd       := a.line_cd;
    v_subline_cd    := a.subline_cd;
    v_iss_cd        := a.iss_cd;
    v_issue_yy      := a.issue_yy;
    v_pol_seq_no    := a.pol_seq_no;
    v_renew_no      := a.renew_no;
    v_sw            := 'Y';
    EXIT;
  END LOOP;
  
  IF v_sw = 'N' THEN
     p_msg := 'There is no record in gipi_pack_polbasic for pack_policy_id ' || 
                to_char(p_old_pol_id);
  END IF;
  
  IF NVL(p_proc_summary_sw,'N') = 'N'  THEN
    SELECT COUNT(*)
      INTO p_rg_count
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
       AND NVL(endt_seq_no,0) = 0;
  ELSIF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
    SELECT COUNT(*)
      INTO p_rg_count
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
       AND pol_flag In ('1','2','3');
  END IF;
  
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
            p_rg_pol_flag    := b.pol_flag;      
            p_rg_policy_id   := b.policy_id;
            p_rg_endt_seq_no := b.endt_seq_no;
            p_row            := v_row  + 1;
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
                AND NVL(endt_seq_no,0) = 0
              ORDER BY eff_date, endt_seq_no)
        LOOP
            p_rg_pol_flag    := b.pol_flag;      
            p_rg_policy_id   := b.policy_id;
            p_rg_endt_seq_no := b.endt_seq_no;
            p_row            := v_row  + 1;
        END LOOP;
   END IF;
   
  
  /*v_query :=  'SELECT pack_policy_id policy_id, nvl(endt_seq_no,0) endt_seq_no, pol_flag '
            ||'  FROM gipi_pack_polbasic '
            ||' WHERE line_cd     =  ' || ''''||v_line_cd ||''''
            ||'   AND subline_cd  = ' || ''''||v_subline_cd ||''''
            ||'   AND iss_cd      = ' || ''''||v_iss_cd ||''''
            ||'   AND issue_yy    = ' || to_char(v_issue_yy)
            ||'   AND pol_seq_no  = ' || to_char(v_pol_seq_no)
            ||'   AND renew_no    = ' || to_char(v_renew_no)
            ||'   AND (
                                        endt_seq_no = 0 OR 
                                         (endt_seq_no > 0 AND 
                                          TRUNC(endt_expiry_date) >= TRUNC(expiry_date))
                                       )' --added by gmi
            ||'   AND pol_flag In (''1'',''2'',''3'') ';
  IF NVL(variables.proc_summary_sw,'N') = 'N'  THEN
     v_query := v_query 
             || '   AND NVL(endt_seq_no,0) = 0 ' ;
  END IF;
     v_query := v_query 
             || ' ORDER BY eff_date, endt_seq_no '; 
    
   rg_id  := FIND_GROUP(rg_name);
   IF ID_NULL(rg_id) THEN
      rg_id     := CREATE_GROUP_FROM_QUERY(rg_name,v_query);
      v_errors  := POPULATE_GROUP(rg_id);
      rg_count  := GET_GROUP_ROW_COUNT(rg_id);
      v_row := 0;
      FOR A2 IN 1.. rg_count LOOP
             v_row :=  v_row  + 1;
             rg_pol_flag    := GET_GROUP_CHAR_CELL(rg_col3,v_row);      
                rg_policy_id := GET_GROUP_NUMBER_CELL(rg_col1,v_row);
                rg_endt_seq_no := GET_GROUP_NUMBER_CELL(rg_col2,v_row);
      END LOOP;       
      rg_count  := GET_GROUP_ROW_COUNT(rg_id);
      IF v_errors NOT IN (1403, 0) THEN
         MESSAGE('ORA-' || TO_CHAR(v_errors) || ' error encountered while populating ' ||
                 'record group ' || rg_name || '.', NO_ACKNOWLEDGE);
         RAISE FORM_TRIGGER_FAILURE;
      END IF;
  END IF;*/
  
END;
/


