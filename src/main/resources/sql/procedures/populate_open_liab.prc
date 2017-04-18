DROP PROCEDURE CPI.POPULATE_OPEN_LIAB;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_OPEN_LIAB(
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wopen_liab.par_id%TYPE,
    p_msg             OUT  VARCHAR2
)  
IS
  v_policy_id           
  gipi_polbasic.policy_id%TYPE;
  v_limit_liability     gipi_wopen_liab.limit_liability%TYPE;
  v_voy_limit           gipi_wopen_liab.voy_limit%TYPE;
  v_prem_tag            gipi_wopen_liab.prem_tag%TYPE;
  v_with_invoice_tag    gipi_wopen_liab.with_invoice_tag%TYPE;
  v_currency_cd         gipi_wopen_liab.currency_cd%TYPE;
  v_currency_rt         gipi_wopen_liab.currency_rt%TYPE;
  v_geog_cd             gipi_wopen_liab.geog_cd%TYPE;
  --rg_id                 RECORDGROUP;
  rg_count              NUMBER;
  rg_name               VARCHAR2(30) := 'GROUP_POLICY';  
  rg_col                VARCHAR2(50) := rg_name || '.policy_id';
  exist                 VARCHAR2(1) := 'N';
  
  x_line_cd             gipi_polbasic.line_cd%TYPE;
  x_subline_cd          gipi_polbasic.subline_cd%TYPE;
  x_iss_cd              gipi_polbasic.iss_cd%TYPE;
  x_issue_yy            gipi_polbasic.issue_yy%TYPE;
  x_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
  x_renew_no            gipi_polbasic.renew_no%TYPE;
BEGIN 
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-24-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_OPEN_LIAB program unit 
  */

   GET_POLICY_GROUP_RECORD(rg_name, p_old_pol_id, p_proc_summary_sw, x_line_cd, x_subline_cd, x_iss_cd, x_issue_yy, x_pol_seq_no, x_renew_no, p_msg);
   IF NVL(p_proc_summary_sw,'N') = 'N'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
                AND NVL(endt_seq_no,0) = 0
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        v_policy_id   := b.policy_id;
        FOR open_liab IN 
         ( SELECT limit_liability,       voy_limit,       prem_tag,
                  with_invoice_tag,      currency_cd,     currency_rt, 
                  geog_cd
             FROM gipi_open_liab
            WHERE policy_id = v_policy_id
          ) LOOP     
              exist := 'Y';
              v_limit_liability  := NVL(open_liab.limit_liability,0) +  NVL(v_limit_liability,0);
              v_voy_limit        := NVL(open_liab.voy_limit, v_voy_limit);
              v_prem_tag         := NVL(open_liab.prem_tag, v_prem_tag);
              v_with_invoice_tag := NVL(open_liab.with_invoice_tag, v_with_invoice_tag);
              v_currency_cd      := NVL(open_liab.currency_cd, v_currency_cd);
              v_currency_rt      := NVL(open_liab.currency_rt, v_currency_rt);
              v_geog_cd          := NVL(open_liab.geog_cd, v_geog_cd);
          END LOOP; 
     END LOOP;
   ELSIF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        v_policy_id   := b.policy_id;
        FOR open_liab IN 
         ( SELECT limit_liability,       voy_limit,       prem_tag,
                  with_invoice_tag,      currency_cd,     currency_rt, 
                  geog_cd
             FROM gipi_open_liab
            WHERE policy_id = v_policy_id
          ) LOOP     
              exist := 'Y';
              v_limit_liability  := NVL(open_liab.limit_liability,0) +  NVL(v_limit_liability,0);
              v_voy_limit        := NVL(open_liab.voy_limit, v_voy_limit);
              v_prem_tag         := NVL(open_liab.prem_tag, v_prem_tag);
              v_with_invoice_tag := NVL(open_liab.with_invoice_tag, v_with_invoice_tag);
              v_currency_cd      := NVL(open_liab.currency_cd, v_currency_cd);
              v_currency_rt      := NVL(open_liab.currency_rt, v_currency_rt);
              v_geog_cd          := NVL(open_liab.geog_cd, v_geog_cd);
          END LOOP;
     END LOOP;
   END IF;      
  IF NVL(exist, 'N') = 'Y' THEN
     --CLEAR_MESSAGE;
     --MESSAGE('Copying open policy''s limits of liabilities ...',NO_ACKNOWLEDGE);
     --SYNCHRONIZE; 
     INSERT INTO gipi_wopen_liab( 
                 par_id,                geog_cd,        rec_flag,
                 limit_liability,       voy_limit,      prem_tag,
                 with_invoice_tag,      currency_cd,    currency_rt)                      
         VALUES( p_new_par_id,          v_geog_cd,     'A',
                 v_limit_liability,     v_voy_limit,    v_prem_tag,
                 v_with_invoice_tag,    v_currency_cd,  v_currency_rt);      
  END IF;  
END;
/


