CREATE OR REPLACE PACKAGE BODY CPI.GIPIS190_PKG
AS
   FUNCTION get_disc_surc_list(
      p_line_cd               gipi_polbasic.line_cd%TYPE,
      p_disc_sw               VARCHAR2,
      p_surc_sw               VARCHAR2,
      p_module_id             giis_modules.module_id%TYPE,
      p_user_id               giis_users.user_id%TYPE
   ) RETURN disc_surc_list_tab PIPELINED AS
      v_list                  disc_surc_list_type;
      v_where                 VARCHAR2(5000) := NULL;
      
      TYPE v_type IS RECORD (
         policy_no            VARCHAR2(50),
         endt_no              VARCHAR2(25),
         disc_amt             gipi_peril_discount.disc_amt%TYPE,      
         surc_amt             gipi_peril_discount.surcharge_amt%TYPE,
         prem_amt             gipi_polbasic.prem_amt%TYPE,
         tsi_amt              gipi_polbasic.tsi_amt%TYPE,
         assd_no              giis_assured.assd_no%TYPE,
         policy_id            gipi_polbasic.policy_id%TYPE,
         cred_branch          gipi_polbasic.cred_branch%TYPE
      );

      TYPE v_tab IS TABLE OF v_type;

      v_list_bulk   v_tab;
   BEGIN
      v_where := ' AND b250.line_cd = NVL('''||p_line_cd||''', b250.line_cd) 
                   AND check_user_per_iss_cd2(b250.line_cd, b250.iss_cd, '''||p_module_id||''', '''||p_user_id||''') = 1 ';
                   
      IF p_disc_sw = '1' THEN
         v_where := v_where || ' AND b250.policy_id IN (SELECT policy_id FROM gipi_polbasic_discount WHERE disc_amt > 0)' ;
      ELSIF p_disc_sw = '2' THEN
         v_where := v_where || ' AND b250.policy_id IN (SELECT policy_id FROM gipi_item_discount WHERE disc_amt > 0)' ;
      ELSIF p_disc_sw = '3' THEN
         v_where := v_where || ' AND b250.policy_id IN (SELECT policy_id FROM gipi_peril_discount WHERE level_tag = ''1'' AND disc_amt > 0)' ;
      ELSIF p_disc_sw = '5' THEN  
         v_where := v_where || ' AND b250.policy_id NOT IN (SELECT policy_id FROM gipi_peril_discount WHERE disc_amt > 0)' ;
      END IF;
      
      IF p_surc_sw = '1' THEN
    	   v_where := v_where || ' AND b250.policy_id IN (SELECT policy_id FROM gipi_polbasic_discount WHERE surcharge_amt > 0)' ;
  	   ELSIF p_surc_sw = '2' THEN
  		   v_where := v_where || ' AND b250.policy_id IN (SELECT policy_id FROM gipi_item_discount WHERE surcharge_amt > 0)' ;
  	   ELSIF p_surc_sw = '3' THEN
  		   v_where := v_where || ' AND b250.policy_id IN (SELECT policy_id FROM gipi_peril_discount WHERE level_tag = ''1'' AND surcharge_amt > 0)' ;
  	   ELSIF p_surc_sw = '5' THEN
    	   v_where := v_where || ' AND b250.policy_id NOT IN (SELECT policy_id FROM gipi_peril_discount WHERE surcharge_amt > 0)' ;
  	   END IF;
      
      v_where := v_where || ' GROUP BY b250.policy_id,b250.line_cd,b250.subline_cd,b250.iss_cd,b250.cred_branch,b250.issue_yy,b250.pol_seq_no,b250.renew_no,b250.endt_iss_cd,
                              b250.endt_yy,b250.endt_seq_no,b250.assd_no,b250.prem_amt,b250.tsi_amt ';

      EXECUTE IMMEDIATE 'SELECT b250.line_cd||''-''||b250.subline_cd||''-''||b250.iss_cd||''-''||LTRIM(TO_CHAR(b250.issue_yy, ''09''))
                                ||''-''||LTRIM(TO_CHAR(b250.pol_seq_no, ''0999999''))||''-''||LTRIM(TO_CHAR(b250.renew_no, ''09'')) "policy_no", 
                                DECODE(NVL(b250.endt_seq_no, 0), 0, '''', 
                                                                    b250.endt_iss_cd||''-''||LTRIM(TO_CHAR(b250.endt_yy, ''09''))||''-''||LTRIM(TO_CHAR(b250.endt_seq_no, ''099999''))) "endt_no",
                                SUM(c.disc_amt) "disc_amt", SUM(c.surcharge_amt) "surc_amt", b250.tsi_amt, b250.prem_amt, b250.assd_no, b250.policy_id, b250.cred_branch
                           FROM gipi_polbasic b250, gipi_peril_discount c 
                          WHERE b250.policy_id = c.policy_id '
                                || v_where
                        
      BULK COLLECT INTO v_list_bulk;
   
      IF v_list_bulk.LAST > 0 THEN
         FOR i IN v_list_bulk.FIRST .. v_list_bulk.LAST
         LOOP
            v_list.policy_id := v_list_bulk(i).policy_id;
            v_list.policy_no := v_list_bulk(i).policy_no;
            v_list.endt_no   := v_list_bulk(i).endt_no;
            v_list.disc_amt  := v_list_bulk(i).disc_amt;
            v_list.surc_amt  := v_list_bulk(i).surc_amt;
            v_list.prem_amt  := v_list_bulk(i).prem_amt;
            v_list.tsi_amt   := v_list_bulk(i).tsi_amt;
            v_list.cred_branch := v_list_bulk(i).cred_branch;
            
            FOR j IN (SELECT assd_name
                        FROM giis_assured
                       WHERE assd_no = v_list_bulk(i).assd_no)
            LOOP
               v_list.assd_name := j.assd_name;
            END LOOP;
            
            get_disc_surc_sw(v_list_bulk(i).policy_id, v_list.disc_sw, v_list.surc_sw);
            
            PIPE ROW(v_list);
         END LOOP;
      END IF;
         
      RETURN;
   END;
   
   FUNCTION get_disc_surc_details(
      p_policy_id             gipi_polbasic.policy_id%TYPE,
      p_type                  VARCHAR2
   ) RETURN disc_surc_detail_tab PIPELINED AS
      v_list               disc_surc_detail_type;
   BEGIN
      IF p_type = 'itm' THEN
         FOR i IN (SELECT *
                     FROM gipi_item_discount
                    WHERE policy_id = p_policy_id)
         LOOP
            v_list.sequence := TO_CHAR(i.sequence, '09999');
            v_list.item_no := TO_CHAR(i.item_no, '09999');                     
            v_list.disc_amt := i.disc_amt;
            v_list.disc_rt := i.disc_rt;
            v_list.surc_amt := i.surcharge_amt;
            v_list.surc_rt := i.surcharge_rt;
            v_list.net_prem_amt := i.net_prem_amt;
            v_list.net_gross_tag := i.net_gross_tag;
            v_list.remarks := i.remarks;
            
            PIPE ROW(v_list);
         END LOOP;
      ELSIF p_type = 'prl' THEN
         FOR i IN (SELECT *
                     FROM gipi_peril_discount
                    WHERE level_tag = '1'
                      AND policy_id = p_policy_id)
         LOOP
            v_list.sequence := TO_CHAR(i.sequence, '09999');
            v_list.item_no := TO_CHAR(i.item_no, '09999');              
            v_list.disc_amt := i.disc_amt;
            v_list.disc_rt := i.disc_rt;
            v_list.surc_amt := i.surcharge_amt;
            v_list.surc_rt := i.surcharge_rt;
            v_list.net_prem_amt := i.net_prem_amt;
            v_list.net_gross_tag := i.net_gross_tag;
            v_list.remarks := i.remarks;
            
            FOR a IN (SELECT peril_name 
                        FROM giis_peril
                       WHERE line_cd = i.line_cd
                         AND peril_cd  = i.peril_cd)
            LOOP
               v_list.peril_name := a.peril_name;
            END LOOP;
            
            PIPE ROW(v_list);
         END LOOP;
      ELSIF p_type = 'pol' THEN
         FOR i IN (SELECT *
                     FROM gipi_polbasic_discount
                    WHERE policy_id = p_policy_id)
         LOOP
            v_list.sequence := TO_CHAR(i.sequence, '09999');             
            v_list.disc_amt := i.disc_amt;
            v_list.disc_rt := i.disc_rt;
            v_list.surc_amt := i.surcharge_amt;
            v_list.surc_rt := i.surcharge_rt;
            v_list.net_prem_amt := i.net_prem_amt;
            v_list.net_gross_tag := i.net_gross_tag;
            v_list.remarks := i.remarks;
            
            PIPE ROW(v_list);
         END LOOP;
      END IF;
   END;  
   
   FUNCTION get_gipis190_line_lov(
      p_module_id          giis_modules.module_id%TYPE,
      p_user_id            giis_users.user_id%TYPE,
      p_find_text          VARCHAR2
    ) RETURN line_listing_tab PIPELINED
    IS
      v_line      line_listing_type;
   BEGIN
      FOR rec IN (SELECT line_cd, line_name
                    FROM giis_line
                   WHERE check_user_per_iss_cd2(line_cd,NULL,p_module_id, p_user_id) = 1
                     AND (UPPER(line_cd) LIKE '%' || UPPER(NVL(p_find_text, line_cd)) || '%'
				              OR UPPER(line_name) LIKE '%' || UPPER(NVL(p_find_text, line_name)) || '%')
                   ORDER BY line_name)
      LOOP
         v_line.line_cd := rec.line_cd;
         v_line.line_name := rec.line_name;
           
         PIPE ROW(v_line);
      END LOOP;
   END;    
   
   PROCEDURE get_disc_surc_sw(
      p_policy_id             IN gipi_polbasic_discount.policy_id%TYPE,
      p_disc_sw               OUT VARCHAR2,
      p_surc_sw               OUT VARCHAR2
   ) AS
      v_pol_disc    NUMBER(12,2)  := 0;
      v_pol_surc    NUMBER(12,2)  := 0;
	   v_itm_disc    NUMBER(12,2)  := 0;
      v_itm_surc    NUMBER(12,2)  := 0;
	   v_prl_disc    NUMBER(12,2)  := 0;
      v_prl_surc    NUMBER(12,2)  := 0;
   BEGIN
      FOR disc_sw1 IN (SELECT SUM(NVL(disc_amt,0)) disc_amt
                         FROM gipi_polbasic_discount
                        WHERE policy_id = p_policy_id)
      LOOP
         IF disc_sw1.disc_amt > 0 THEN
            p_disc_sw := '1';
            v_pol_disc := disc_sw1.disc_amt;
         END IF;
      END LOOP;                         
  
      FOR disc_sw2 IN (SELECT SUM(NVL(disc_amt,0)) disc_amt
                         FROM gipi_item_discount
                        WHERE policy_id = p_policy_id)
      LOOP
         v_itm_disc := NVL(disc_sw2.disc_amt,0);
         IF v_pol_disc > 0 AND disc_sw2.disc_amt > 0 THEN
            p_disc_sw := '4';
         ELSIF v_pol_disc = 0 AND disc_sw2.disc_amt > 0 THEN
       	   p_disc_sw := '2';       	
         END IF;
      END LOOP;
	  
	
  	   FOR disc_sw3 IN (SELECT SUM(NVL(disc_amt,0)) disc_amt
 				             FROM gipi_peril_discount
               			WHERE policy_id = p_policy_id
              				  AND level_tag = '1')
		LOOP
		   v_prl_disc := NVL(disc_sw3.disc_amt,0);
 			IF v_prl_disc > 0 AND p_disc_sw = '2' THEN 
            p_disc_sw := '4';     
 			ELSIF v_prl_disc > 0 AND v_pol_disc = 0 AND v_itm_disc = 0 THEN
 				p_disc_sw := '3';     
 			ELSIF v_prl_disc = 0 AND v_pol_disc = 0 AND v_itm_disc = 0 THEN
 				p_disc_sw := '5';      				 
 		 	END IF;
 		END LOOP;  
      
      FOR surc_sw1 IN (SELECT SUM(NVL(surcharge_amt,0)) surc_amt
                         FROM gipi_polbasic_discount
                        WHERE policy_id = p_policy_id)
      LOOP
    	   IF surc_sw1.surc_amt > 0 THEN
    	      p_surc_sw := '1';
    	      v_pol_surc    := surc_sw1.surc_amt;
    	   END IF;
      END LOOP;                          

      FOR surc_sw2 IN (SELECT SUM(NVL(surcharge_amt,0)) surc_amt
                         FROM gipi_item_discount
                        WHERE policy_id = p_policy_id)
      LOOP
			v_itm_surc := NVL(surc_sw2.surc_amt,0);
         IF v_pol_surc > 0 AND v_itm_surc > 0 THEN
       	   p_surc_sw := '4';
         ELSIF v_pol_surc = 0 AND v_itm_surc > 0 THEN
       	   p_surc_sw := '2';       	
         END IF;
      END LOOP;
  
  	   FOR surc_sw3 IN (SELECT SUM(NVL(surcharge_amt,0)) surc_amt
 				             FROM gipi_peril_discount
               			WHERE policy_id = p_policy_id
              				  AND level_tag = '1')
		LOOP
			v_prl_surc := NVL(surc_sw3.surc_amt,0);
 			IF v_prl_surc > 0 AND p_surc_sw = '2' THEN 
            p_surc_sw := '4';     
 			ELSIF v_prl_surc > 0 AND v_pol_surc = 0 AND v_itm_surc = 0 THEN
 				p_surc_sw := '3';     
 			ELSIF v_prl_surc = 0 AND v_pol_surc = 0 AND v_itm_surc = 0 THEN
 				p_surc_sw := '5';      				 
 		 	END IF;
 		END LOOP;                                        
   END;              
END;
/


