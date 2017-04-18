DROP FUNCTION CPI.GET_PACK_POL_NO_GIRIS006;

CREATE OR REPLACE FUNCTION CPI.get_pack_pol_no_GIRIS006 (
    p_line_cd      gipi_polbasic.line_cd%TYPE,
    p_iss_cd       gipi_polbasic.iss_cd%TYPE,
    p_par_yy       gipi_parlist.par_yy%TYPE,
    p_par_seq_no   gipi_parlist.par_seq_no%TYPE,
    p_quote_seq_no gipi_parlist.quote_seq_no%TYPE
    )
RETURN VARCHAR2 IS
    v_pack_pol_no VARCHAR2(50):= NULL;
    
    BEGIN
        FOR a IN (SELECT par_status, par_id
                    FROM gipi_parlist 
                   WHERE line_cd = p_line_cd
                     AND iss_cd = p_iss_cd
                     AND par_yy = p_par_yy  
                     AND par_seq_no = p_par_seq_no
                     AND quote_seq_no = p_quote_seq_no)
        LOOP
           IF a.par_status = 10 THEN
             FOR c1 IN (SELECT pack_policy_id
                          FROM gipi_polbasic  
                         WHERE par_id = a.par_id)
             LOOP 
               FOR c2 IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||TO_CHAR(issue_yy,'09')||'-'||TO_CHAR(pol_seq_no,'000009')||'-'||TO_CHAR(renew_no,'09') pack_pol_no
                  FROM gipi_pack_polbasic
                 WHERE pack_policy_id = c1.pack_policy_id)
                 
               loop
                 v_pack_pol_no := c2.pack_pol_no;
               end loop;
             
             END LOOP;
           ELSE 
            FOR c1 IN (SELECT pack_par_id
                          FROM gipi_wpolbas  
                         WHERE par_id = a.par_id)
             LOOP 
               FOR c2 IN (SELECT line_cd||'-'||iss_cd||'-'||TO_CHAR(par_yy,'09')||'-'||TO_CHAR(par_seq_no,'000009') pack_par_no
                  FROM gipi_pack_parlist
                 WHERE pack_par_id = c1.pack_par_id)
                 
               loop
                 v_pack_pol_no := c2.pack_par_no;
               end loop;
             
             END LOOP;
            
           END IF;
        END LOOP;
        
        RETURN (v_pack_pol_no);
    END;
/


