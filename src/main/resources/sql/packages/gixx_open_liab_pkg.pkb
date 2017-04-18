CREATE OR REPLACE PACKAGE BODY CPI.GIXX_OPEN_LIAB_PKG AS

  FUNCTION get_pol_doc_opliab(p_extract_id		  GIXX_OPEN_LIAB.extract_id%TYPE)
    RETURN pol_doc_openliab_tab PIPELINED IS
	v_opliab					pol_doc_openliab_type;
  BEGIN
    FOR i IN (SELECT A.EXTRACT_ID EXTRACT_ID,
					 LTRIM(TO_CHAR(A.LIMIT_LIABILITY * A.CURRENCY_RT, '9,999,999,999,999,990.99')) OPLIAB_LIMIT_LIAB,
					 LTRIM(TO_CHAR(A.LIMIT_LIABILITY, '9,999,999,999,999,990.99')) OPLIAB_LIMIT_LIAB1,
				     A.CURRENCY_CD OPLIAB_CURRENCY_CD,	
					 A.VOY_LIMIT OPLIAB_VOYAGE_LIMIT,
					 B.GEOG_DESC OPLIAB_GEOG_DESC,
				     A.GEOG_CD OPLIAB_GEOG_CD
				FROM GIXX_OPEN_LIAB A, GIIS_GEOG_CLASS B
			   WHERE A.GEOG_CD = B.GEOG_CD
				 AND A.EXTRACT_ID = p_extract_id)
	LOOP
	  v_opliab.extract_id 		   := i.extract_id;
	  v_opliab.opliab_limit_liab   := i.opliab_limit_liab;
	  v_opliab.opliab_limit_liab1  := i.opliab_limit_liab1;
	  v_opliab.opliab_currency_cd  := i.opliab_currency_cd;
	  v_opliab.opliab_voyage_limit := i.opliab_voyage_limit;
	  v_opliab.opliab_geog_desc    := i.opliab_geog_desc;
	  v_opliab.opliab_geog_cd 	   := i.opliab_geog_cd;
	  v_opliab.f_cargo_class_desc  := GIXX_OPEN_LIAB_PKG.CF_CARGO_CLASS_DESC(i.extract_id, i.opliab_geog_cd);
	  v_opliab.prem_rate_exists    := GIXX_OPEN_PERIL_PKG.prem_rate_exists(p_extract_id);
	  v_opliab.prem_rate_exists2   := GIXX_OPEN_PERIL_PKG.prem_rate_exists2(p_extract_id);
	  PIPE ROW(v_opliab);
	END LOOP;
	RETURN;
  END get_pol_doc_opliab;
  
  FUNCTION CF_CARGO_CLASS_DESC(p_extract_id		GIXX_OPEN_LIAB.extract_id%TYPE,
							   p_geog_cd		GIXX_OPEN_LIAB.geog_cd%TYPE) 
	RETURN VARCHAR2 IS
	v_count      NUMBER(2) := 1;
	v_cargo_desc varchar2(1000);
  begin
	  FOR a IN (
	    SELECT b.cargo_class_desc cargo_class_desc        
	      FROM gixx_open_cargo a, 
	           giis_cargo_class b
	     WHERE a.cargo_class_cd = b.cargo_class_cd
	       AND a.geog_cd        = p_geog_cd
	       AND a.extract_id     = p_extract_id)
	  LOOP
	  
	  	 	IF v_count = 1 THEN   	 			
	  		 v_count      := v_count + 1;  		
	  		 v_cargo_desc := a.cargo_class_desc; 	 		 		 	
	  	 	ELSE
	   		 v_cargo_desc := v_cargo_desc || (chr(10)) || a.cargo_class_desc;
	  	END IF;
	  END LOOP;
	  RETURN (v_cargo_desc);
  end;
  
  
  
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 11, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves open liability information
  */
  FUNCTION get_open_liab(
    p_extract_id    gixx_open_liab.extract_id%TYPE,
    p_iss_cd        gipi_polbasic.iss_cd%TYPE,
    p_line_cd       gipi_polbasic.line_cd%TYPE,
    p_subline_cd    gipi_polbasic.subline_cd%TYPE,
    p_issue_yy      gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no      gipi_polbasic.renew_no%TYPE
  ) RETURN open_liab_tab PIPELINED
  IS
    v_open_liab     open_liab_type;
  BEGIN
        FOR rec IN (SELECT extract_id, geog_cd,
                           voy_limit, currency_cd, currency_rt,
                           limit_liability, with_invoice_tag
                      FROM gixx_open_liab
                     WHERE extract_id = p_extract_id)
        LOOP
            v_open_liab.extract_id := rec.extract_id;
            v_open_liab.geog_cd := rec.geog_cd;
            v_open_liab.voy_limit := rec.voy_limit;
--            v_open_liab.currency_cd := rec.currency_cd;
--            v_open_liab.currency_rt := rec.currency_rt;
            v_open_liab.limit_liability := rec.limit_liability;
            v_open_liab.with_invoice_tag :=  rec.with_invoice_tag;
        
            FOR a IN (SELECT geog_desc
                        FROM giis_geog_class
                       WHERE geog_cd = rec.geog_cd)
            LOOP
                v_open_liab.geog_desc := a.geog_desc;
            END LOOP;
            
            FOR b IN (SELECT currency_cd, currency_rt
                        FROM gipi_open_liab
                       WHERE policy_id IN (SELECT policy_id
                                             FROM gipi_polbasic
                                            WHERE line_cd = p_line_cd
                                              AND subline_cd = p_subline_cd
                                              AND iss_cd = p_iss_cd
                                              AND issue_yy = p_issue_yy
                                              AND pol_seq_no = p_pol_seq_no)
                         AND geog_cd = rec.geog_cd)
            LOOP
                v_open_liab.currency_cd := b.currency_cd;
                v_open_liab.currency_rt := b.currency_rt;
            END LOOP;
            
            FOR c IN (SELECT currency_desc
                        FROM giis_currency
                       WHERE main_currency_cd = v_open_liab.currency_cd)
           LOOP
              v_open_liab.currency_desc := c.currency_desc;
           END LOOP;
        
            PIPE ROW(v_open_liab);
        END LOOP;
  END get_open_liab;

END GIXX_OPEN_LIAB_PKG;
/


