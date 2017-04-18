DROP FUNCTION CPI.SET_EXIST_MSG;

CREATE OR REPLACE FUNCTION CPI.SET_EXIST_MSG(p_line_cd      GIPI_QUOTE.line_cd%TYPE,
                                             p_assd_no      GIPI_QUOTE.assd_no%TYPE,
                                             p_assd_name    GIPI_QUOTE.assd_name%TYPE) 
  RETURN VARCHAR2 IS
  v_quote_cnt       NUMBER          := 0;
  v_par_cnt         NUMBER          := 0;
  v_pol_cnt         NUMBER          := 0;
  v_alert_msg_txt   VARCHAR2(1000)  := 'SUCCESS';
BEGIN
  SELECT COUNT(*)
      INTO v_quote_cnt
      FROM gipi_quote
     WHERE 1=1
       AND line_cd = p_line_cd
       AND UPPER(TRIM(assd_name)) = UPPER(TRIM(p_assd_name));
       
    SELECT COUNT(*)
      INTO v_par_cnt
      FROM gipi_parlist 
     WHERE par_status NOT IN (98,99,10)
       AND line_cd = p_line_cd
       AND assd_no = p_assd_no;  

    SELECT COUNT(*)
      INTO v_pol_cnt
      FROM gipi_parlist 
     WHERE par_status = 10
       AND line_cd = p_line_cd
       AND assd_no = p_assd_no;
    IF v_quote_cnt <> 0 AND    v_par_cnt <> 0 AND    v_pol_cnt <> 0  THEN     
         v_alert_msg_txt := 'Assured is already existing in other Quotation/s, PAR/s and Policies.';          
    ELSIF v_quote_cnt = 0 AND    v_par_cnt <> 0 AND    v_pol_cnt <> 0  THEN     
         v_alert_msg_txt := 'Assured is already existing in other PAR/s and Policies.';
    ELSIF v_quote_cnt <> 0 AND    v_par_cnt = 0 AND    v_pol_cnt <> 0  THEN     
         v_alert_msg_txt := 'Assured is already existing in other Quotation/s and Policies.';
    ELSIF v_quote_cnt <> 0 AND    v_par_cnt <> 0 AND    v_pol_cnt = 0  THEN     
         v_alert_msg_txt := 'Assured is already existing in other Quotation/s and PAR/s.';
    ELSIF v_quote_cnt = 0 AND    v_par_cnt = 0 AND    v_pol_cnt <> 0  THEN     
         v_alert_msg_txt := 'Assured is already existing in Policy records.';
    ELSIF v_quote_cnt = 0 AND    v_par_cnt <> 0 AND    v_pol_cnt = 0  THEN
         v_alert_msg_txt := 'Assured is already existing in PAR records.';
    ELSIF v_quote_cnt <> 0 AND    v_par_cnt = 0 AND    v_pol_cnt = 0  THEN     
         v_alert_msg_txt := 'Assured is already existing in another Quotation.';              
    END IF;                                                                                         
    RETURN(v_alert_msg_txt);
END SET_EXIST_MSG;
/


