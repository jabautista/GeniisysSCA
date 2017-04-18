CREATE OR REPLACE PACKAGE BODY CPI.GIRIR110_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   05.03.2013
     ** Referenced By:  GIRIR110 - Facultative Reinsurance Renewal Request
     **/
     
     FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2
     AS
        v_company_name    giis_parameters.param_name%TYPE;
     BEGIN
        FOR c IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME')
        LOOP
            v_company_name := c.param_value_v;
        END LOOP;
        RETURN(v_company_name);
     END CF_COMPANY_NAME;
     
     
     FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2
     AS
         v_company_address    VARCHAR2(500);
         TEXT_VALUE           VARCHAR2(2);     
     BEGIN
        FOR name IN (SELECT param_value_v
                       FROM giis_parameters
                      WHERE param_name = 'COMPANY_ADDR')
        LOOP
            v_company_address := name.param_value_v;
        END LOOP;
  
        FOR A IN (SELECT TEXT 
                    FROM GIIS_DOCUMENT
                   WHERE TITLE = 'PARAMETER_LETTERHEAD')
        LOOP
  	        TEXT_VALUE := a.text;
        END LOOP;	
  	
        IF TEXT_VALUE = 'Y' THEN
            RETURN(v_company_address);
        ELSE
  	        RETURN NULL;
        END IF;
     END CF_COMPANY_ADDRESS;
     
     
     FUNCTION CF_OPENING_PARAGRAPH
        RETURN VARCHAR2
     AS
        v_open_par      giis_document.text%TYPE;
     BEGIN
        begin
            select text
              into v_open_par
              from giis_document
             where title = 'OPENING_PARAGRAPH'
               and report_id = 'GIRIR110';
        exception
 	        when no_data_found then
 	            null;
        end;
        
        return(v_open_par);
     END CF_OPENING_PARAGRAPH;
     
     
     FUNCTION CF_ENDING_PARAGRAPH
        RETURN VARCHAR2
     AS
        v_close_par1      giis_document.text%TYPE;
        v_close_par2      giis_document.text%TYPE;
        v_close_par3      giis_document.text%TYPE;
        v_company_name    giis_document.text%TYPE;
        v_close_par4      giis_document.text%TYPE;
     BEGIN
        begin
            select text
              into v_close_par1      
              from giis_document
             where title = 'ENDING_PARAGRAPH1';
        exception
   	        when no_data_found then
   	            null;
        end;
        
        /*begin 
            select text
              into v_close_par2
              from giis_document
             where title = 'ENDING_PARAGRAPH2';
        exception
   	        when no_data_found then
   	            null;
        end;
   
        begin
            select text
              into v_close_par3      
              from giis_document
             where title = 'ENDING_PARAGRAPH3';
        exception
   	        when no_data_found then
   	        null;
        end;	   
        */ 
        
        begin
   	        select param_value_v
   	          into v_company_name
   	          from giis_parameters
   	         where param_name = 'COMPANY_NAME';
        exception
   	        when no_data_found then
   	            null;
        end;
        	   
        begin
            select text
              into v_close_par4      
              from giis_document
             where title = 'ENDING_PARAGRAPH4';
        exception
   	        when no_data_found then
   	            null;
        end;	
        
        return(v_close_par1);
     END CF_ENDING_PARAGRAPH;
     
     
     FUNCTION CF_ENDING_DATE
        RETURN VARCHAR2
     AS
        v_auth_sig      giis_document.text%type;
        v_date          giis_document.text%type;
     BEGIN
        begin
	        select text 
	          into v_auth_sig
	          from giis_document
	         where title='ENDING_PARAGRAPH4';
        exception
  	        when no_data_found then
  	        null;
        end;
        
        begin
	        select text 
	          into v_auth_sig
	          from giis_document
	         where title='CONFORM3';
        exception
  	        when no_data_found then
  	            null;
        end;
        
        return(v_auth_sig||' '||v_date); 	 
     END CF_ENDING_DATE;
     
     
     FUNCTION CF_CONFIRMATION
        RETURN VARCHAR2
     AS
        v_confirmation         giis_document.text%TYPE;
     BEGIN
        begin
	        select text
	          into v_confirmation
	          from giis_document
	         where title = 'CONFIRMATION';
        exception
  	        when no_data_found then
  	            null;
         end;
        return(v_confirmation);
     END CF_CONFIRMATION;
     
     
     FUNCTION CF_AUTH_SIG
        RETURN VARCHAR2
     AS
        v_auth_sig  giis_document.text%type;
     BEGIN
        for c in(select text
                   from giis_document
                  where title = 'ENDING_PARAGRAPH4')
        loop
  	        v_auth_sig := c.text;
  	        exit;
        end loop;
        return(v_auth_sig); 
     END CF_AUTH_SIG;
     
     
     FUNCTION CF_STATUS(
        p_policy_id     gipi_invoice.POLICY_ID%TYPE
     ) RETURN VARCHAR2
     AS
        v_stat varchar2(1);
        v_premium_amt number;
        v_pol_inv_prem number; -- analyn 2/2/2010 
        v_diff number;
     BEGIN
        --for i in -- removed by jayson 01.05.2011
		 /*(select sum(nvl((premium_amt),0)) premium_amt, SUM(nvl((prem_amt),0))pol_inv_prem, policy_id  
		      from giac_direct_prem_collns a, gipi_invoice b
		     where b140_iss_cd(+) = b.iss_cd
		       and b140_prem_seq_no(+) = b.prem_seq_no
		       and :policy_id = b.policy_id
		     --and b140_iss_cd = :iss_cd
		     group by policy_id*/ -- analyn 2/2/2010
		  /*SELECT SUM(NVL(a.premium_amt,0)) premium_amt,
	    		   SUM(NVL(b.prem_amt,0)) pol_inv_prem, 
	    		   c.line_cd ||'-'|| c.subline_cd || '-' || c.iss_cd || '-' || c.issue_yy || '-' || c.pol_seq_no policy_number
  		      FROM GIAC_DIRECT_PREM_COLLNS a,
  	  		       GIPI_INVOICE b,
	   			   GIPI_POLBASIC c
 			 WHERE a.b140_prem_seq_no(+) = b.prem_seq_no
   			   AND a.b140_iss_cd(+) = b.iss_cd
   			   AND b.policy_id = c.policy_id
   			   AND b.policy_id IN (SELECT policy_id
   	   		             	   	  	 FROM GIPI_POLBASIC
									WHERE line_cd || '-' || subline_cd || '-' || iss_cd || '-' || 
										        LTRIM(RTRIM(TO_CHAR(issue_yy, '09'))) || '-' || 
										        LTRIM(RTRIM(TO_CHAR(pol_seq_no, '0999999'))) ||'-'||
										        LTRIM(TO_CHAR(renew_no,'09')) = p_policy_no)
			 GROUP BY c.line_cd ||'-'|| c.subline_cd || '-' || c.iss_cd || '-' || c.issue_yy || '-' || c.pol_seq_no
		  )
		loop
			v_premium_amt := i.premium_amt;
			v_pol_inv_prem := i.pol_inv_prem; -- analyn 2/2/2010
			v_diff := i.pol_inv_prem - v_premium_amt;
		end loop;	*/ -- removed by jayson 01.05.2011
		
		-- START added by Jayson 01.05.2011 --
		-- to get correct value for v_diff --
        FOR a IN (SELECT iss_cd, prem_seq_no, prem_amt
		            FROM gipi_invoice
		           where policy_id = p_policy_id)
		LOOP
			v_pol_inv_prem := NVL(v_pol_inv_prem,0) + a.prem_amt;
			
			FOR b IN (SELECT z.premium_amt
				    	FROM giac_direct_prem_collns z, giac_acctrans x 
					   WHERE z.gacc_tran_id = x.tran_id
						 AND z.b140_iss_cd = a.iss_cd
						 AND z.b140_prem_seq_no = a.prem_seq_no
						 AND x.tran_flag <> 'D')
			LOOP
				v_premium_amt := NVL(v_premium_amt,0) + b.premium_amt;
			END LOOP;
		END LOOP;
        
        v_diff := NVL(v_pol_inv_prem,0) - NVL(v_premium_amt,0);
		-- START added by Jayson 01.05.2011 --
		
		if v_diff IS NULL OR v_diff = 0 then
			 v_stat := 'F';
		--elsif (v_diff < :prem_amt and v_diff <> 0) then
		elsif (v_diff < v_pol_inv_prem AND v_diff <> 0) then -- analyn 2/2/2010
			 v_stat := 'P';
		else 	
	        v_stat := 'N';
		end if;		
	    
        RETURN(v_stat);
     END CF_STATUS;
        
     
     FUNCTION CF_LOCATION(
        p_policy_id         gipi_vehicle.POLICY_ID%TYPE,
        p_line_name         GIIS_LINE.LINE_NAME%TYPE,
        p_line_cd           gipi_polbasic.LINE_CD%TYPE,
        p_assured_address   giis_assured.MAIL_ADDR3%TYPE
     ) RETURN VARCHAR2
     AS
        v_location        varchar2(200);
        v_mc_dtl          varchar2(200);
     BEGIN
        FOR clc IN (SELECT b.district_desc||decode(b.district_desc,null,' ','/')||a.block_no||' '||b.block_desc loc --a.loc_risk3 loc
                      FROM gipi_fireitem    a,
                           giis_block       b
                     WHERE a.policy_id = p_policy_id
                       AND a.block_id = b.block_id) 
        LOOP 
            v_location := LTRIM(clc.loc);
        END LOOP;
  
        FOR mc IN (select b.plate_no||'  '||b.model_year||'-'||c.car_company||' '||b.make dtl
                     from gipi_vehicle b, giis_mc_car_company c
                    where b.policy_id = p_policy_id
                      and b.car_company_cd = c.car_company_cd)
        LOOP  
  	        v_mc_dtl := mc.dtl;
        END LOOP;  
        
        IF p_line_name = 'FIRE' THEN
            RETURN(v_location);
        ELSIF p_line_cd = 'MC' THEN
  	        RETURN(v_mc_dtl);
        ELSE
            RETURN(p_assured_address);
        END IF;

        RETURN(v_location);
        
     END CF_LOCATION;
         
     
     /* F_2, F_ASSURED, F_BINDER, F_EXPIRY_DATE, F_LOCATION, 
        F_POLICY_NO, F_RI_POLICY_NO, F_STATUS format trigger
      */
     FUNCTION FIELDS_FORMATTRIGGER(
        p_endt_seq_no       GIPI_POLBASIC.ENDT_SEQ_NO%type,
        p_dist_no           GIUW_POL_DIST.DIST_NO%type,
        p_frps_seq_no       GIRI_DISTFRPS.FRPS_SEQ_NO%type,
        p_d050_ri_cd        GIRI_FRPS_RI.RI_CD%type,  
        p_policy_no         varchar
     ) RETURN VARCHAR2
     AS    
        v_count_dist_no     NUMBER;
	    v_dist_no           NUMBER;
	    v_min_frps_seq_no   NUMBER;
	    v_count_ri_cd       number; 
     BEGIN
        IF p_endt_seq_no = 0 THEN
            SELECT COUNT(dist_no), dist_no 
              INTO v_count_dist_no, v_dist_no 
              FROM GIRI_DISTFRPS 
             WHERE dist_no = p_dist_no 
             GROUP BY dist_no;
        
            IF v_count_dist_no > 1 THEN 
                SELECT MIN(frps_seq_no) 
                  INTO v_min_frps_seq_no 
                  FROM GIRI_DISTFRPS
                 WHERE dist_no = v_dist_no;
                    
                IF p_frps_seq_no =  v_min_frps_seq_no THEN
                    RETURN ('Y');
                END IF;
            ELSE
                RETURN ('Y');            
            END IF;
            -- return (TRUE);
        ELSE 
            SELECT COUNT(a.ri_cd) count_ri_cd 
              INTO v_count_ri_cd     
              FROM GIRI_FRPS_RI a, GIRI_DISTFRPS b
             WHERE a.line_cd = b.line_cd
               AND a.frps_yy = b.frps_yy
               AND a.frps_seq_no = b.frps_seq_no
               AND a.ri_cd = p_d050_ri_cd 
               AND b.dist_no IN (SELECT dist_no 
                                   FROM GIRI_DISTFRPS 
                                  WHERE dist_no IN (SELECT dist_no 
                                                      FROM GIUW_POL_DIST 
                                                     WHERE policy_id IN (SELECT policy_id 
                                                                           FROM GIPI_POLBASIC 
                                                                          WHERE line_cd || '-' || subline_cd || '-' || iss_cd || '-' || 
                                                                                LTRIM(RTRIM(TO_CHAR(issue_yy, '09'))) || '-' || 
                                                                                LTRIM(RTRIM(TO_CHAR(pol_seq_no, '0999999'))) ||'-'||
                                                                                LTRIM(TO_CHAR(renew_no,'09')) = p_policy_no) ) ) 
             GROUP BY a.ri_cd;
                       
             --SRW.MESSAGE (1, 'v_count_ri_cd = ' || v_count_ri_cd);
             IF v_count_ri_cd = 1 THEN
                RETURN('Y');
             END IF;
        END IF;
        
        RETURN ('N');
     END FIELDS_FORMATTRIGGER;
     
     
     FUNCTION get_report_details(
        p_reinsurer     GIIS_REINSURER.RI_SNAME%TYPE,
        p_line          GIIS_LINE.LINE_NAME%TYPE,
        p_expiry_month  VARCHAR2,
        p_expiry_year   NUMBER
    ) RETURN report_details_tab PIPELINED
    AS
        rep                      report_details_type;
        v_allow                  VARCHAR2(1) := 'N';
        v_show_summarized_policy VARCHAR2(1) := 'Y';
        v_rec_exist              VARCHAR2(1) := 'N';
    BEGIN
        rep.company_name        := CF_COMPANY_NAME;
        rep.company_address     := CF_COMPANY_ADDRESS;
        rep.paramdate           := 'For the Month of ' || UPPER(p_expiry_month) || ' ' || p_expiry_year;
        -- added by MarkS 04.20.2016 for SR-22068
        SELECT text
        INTO v_show_summarized_policy
        FROM cpi.giis_document
        WHERE report_id = 'GIRIR110' AND title = 'SHOW_SUMMARIZED_POLICY';
        rep.show_summarized_policy := v_show_summarized_policy;
        -- END SR-22068
        -- M_LETTERHEAD format trigger
        FOR a IN (SELECT text
                    FROM giis_document
                   WHERE title = 'PARAMETER_LETTERHEAD'
                     AND report_id = 'GIRIR110')
        LOOP
  	        v_allow := a.text;
        END LOOP;
        
        rep.print_letterhead    := v_allow;
        
        FOR i IN  ( SELECT a180.ri_cd ri_cd, a180.ri_name ri_name, a180.bill_address1 bill_address12,
                           a180.bill_address2 bill_address23, a180.bill_address3 bill_address34, a430.main_currency_cd currency_cd,
                           UPPER(NVL(a180.attention, 'REINSURANCE DEPARTMENT')) attention,
                           a430.currency_desc, b250.line_cd line_cd, a120.line_name,
                           TO_CHAR(b250.issue_date,'MM-DD-YYYY') issue_date,
                           b250.line_cd || '-' || b250.subline_cd || '-' || b250.iss_cd || '-' || LTRIM(RTRIM(TO_CHAR(b250.issue_yy, '09'))) || '-' || 
                              LTRIM(RTRIM(TO_CHAR(b250.pol_seq_no, '0999999'))) ||'-'|| LTRIM(TO_CHAR(b250.renew_no,'09'))  policy_no,
                           b250.policy_id policy_id,
                           LTRIM(b250.endt_iss_cd || '-' || LTRIM(RTRIM(TO_CHAR(b250.endt_yy, '09'))) || '-' || LTRIM(RTRIM(TO_CHAR(b250.endt_seq_no, '099999')))) endt_no,
                           b250.endt_seq_no,
                           d005.line_cd || '-' || LTRIM(TO_CHAR(d005.binder_yy,'09')) || '-' || LTRIM(TO_CHAR(d005.binder_seq_no,'09999')) binder,
                           TO_CHAR(c080.expiry_date,'MM-DD-YYYY') expiry_date,
                           a020.assd_name assured, a020.mail_addr3 assured_address, b250.incept_date,
                           b250.tsi_amt tsi, d060.tsi_amt sum_insured, d050.ri_tsi_amt ri_share,
                           d005.ri_tsi_amt binder_tsi, d005.ri_shr_pct pct_accepted, d050.remarks frps_ri_remarks,
                           d005.confirm_no, b.prem_amt, c080.dist_no dist_no, -- analyn 2.4.2010
                           d060.frps_seq_no frps_seq_no, -- analyn 2.4.2010  
                           d050.ri_cd d050_ri_cd, -- analyn 2.8.2010
                           a180.ri_sname -- added by MarkS 6.9.2016 SR-22068  
                      FROM giis_reinsurer  a180,
                           giri_frps_ri d050,
                           giri_distfrps d060,
                           giuw_pol_dist c080,
                           gipi_polbasic b250,
                           giis_line a120,
                           giis_assured a020,
                           giri_binder d005,
                           giis_currency a430,
                           gipi_parlist a,
                           gipi_invoice b
                     WHERE /*d005.binder_seq_no = (SELECT MIN(x.binder_seq_no)
                                                     FROM giri_binder x, gipi_polbasic y
                                                    WHERE y.line_cd = b250.line_cd
                                                      AND y.subline_cd = b250.subline_cd
                                                      AND y.iss_cd = b250.iss_cd
                                                      AND y.issue_yy =b250.issue_yy
                                                      AND y.pol_seq_no =b250.pol_seq_no
                                                      AND y.renew_no =b250.renew_no
                                                      AND x.policy_id = y.policy_id)
                       AND b250.policy_id = d005.policy_id    
                       AND*/ d050.ri_cd = a180.ri_cd
                       AND d060.line_cd = d050.line_cd
                       AND d060.frps_yy = d050.frps_yy
                       AND d060.frps_seq_no = d050.frps_seq_no
                       AND c080.dist_no = d060.dist_no
                       AND b250.policy_id = c080.policy_id
                       AND a120.line_cd = b250.line_cd
                       --AND a020.assd_no = b250.assd_no 
                       AND a020.assd_no = a.assd_no 
                       AND a.par_id = b250.par_id
                       AND d005.fnl_binder_id = d050.fnl_binder_id
                       AND d060.currency_cd = a430.main_currency_cd
                       AND d060.ri_flag = '2'
                       AND a120.line_name = NVL(UPPER(p_line), a120.line_name)
                       AND UPPER(a180.ri_sname) = UPPER(NVL(p_reinsurer, a180.ri_sname)) -- moved UPPER before the NVL to handle ri_sname with mixed cases // apollo cruz 03.31.2015
                       AND TO_CHAR(B250.expiry_date,'FMMONTH') = NVL(UPPER(p_expiry_month),TO_CHAR(B250.expiry_date,'FMMONTH'))
                       AND TO_CHAR(B250.expiry_date,'YYYY') = NVL(p_expiry_year,TO_CHAR(B250.expiry_date,'YYYY'))
                       AND b250.pol_flag IN ('1','2','3','X') -- edited by MarkS 04.28.2016 SR-22068 
                       AND nvl(d005.replaced_flag,'N') <> 'Y'
                       AND nvl(d050.reverse_sw,'N') <> 'Y'
                       AND b250.policy_id = b.policy_id
                     ORDER BY a180.ri_name, a120.line_name, a180.ri_cd, 
                              b250.line_cd, b250.subline_cd, b250.iss_cd, 
                              b250.issue_yy, b250.pol_seq_no, b250.renew_no, 
                              LTRIM(b250.endt_iss_cd || '-' || LTRIM(RTRIM(TO_CHAR(b250.endt_yy, '09'))) || '-' || LTRIM(RTRIM(TO_CHAR(b250.endt_seq_no, '099999')))) asc,
                              d005.line_cd, d005.binder_yy,
                              d005.binder_seq_no, a430.main_currency_cd, a430.currency_desc )
        LOOP
            rep.ri_cd                   := i.ri_cd;
            rep.ri_name                 := i.ri_name;
            rep.line_cd                 := i.line_cd;
            rep.line_name               := i.line_name;
            rep.bill_address12          := i.bill_address12;
            rep.bill_address23          := i.bill_address23;
            rep.bill_address34          := i.bill_address34;
            rep.issue_date              := i.issue_date;
            rep.cf_opening_paragraph    := CF_OPENING_PARAGRAPH;
            rep.cf_ending_paragraph     := CF_ENDING_PARAGRAPH;
            rep.cf_ending_date          := CF_ENDING_DATE;
            rep.cf_confirmation         := CF_CONFIRMATION;
            rep.cf_auth_sig             := CF_AUTH_SIG;
            rep.attention               := i.attention;
            rep.cf_status               := CF_STATUS(i.policy_id);
            rep.prem_amt                := i.prem_amt;
            rep.expiry_date             := i.expiry_date;
            rep.policy_no               := i.policy_no;
            rep.dist_no                 := i.dist_no;
            rep.endt_seq_no             := i.endt_seq_no;
            rep.endt_no                 := i.endt_no;
            rep.confirm_no              := i.confirm_no;
            rep.incept_date             := i.incept_date;
            rep.sum_insured             := i.sum_insured;
            rep.frps_ri_remarks         := i.frps_ri_remarks;
            rep.policy_id               := i.policy_id;
            rep.assured                 := i.assured;
            rep.cf_location             := CF_LOCATION(i.policy_id, i.line_name, i.line_cd, i.assured_address);
            rep.assured_address         := i.assured_address;
            rep.frps_seq_no             := i.frps_seq_no;
            rep.tsi                     := i.tsi;
            rep.d050_ri_cd              := i.d050_ri_cd;
            rep.pct_accepted            := i.pct_accepted;
            rep.binder                  := i.binder;
            rep.binder_tsi              := i.binder_tsi;
            -- added by MarkS 04.20.2016 for SR-22068
            IF v_show_summarized_policy ='Y' THEN
                rep.ri_share                := GET_TOTAL_RI_SHARE(i.policy_no,i.ri_sname,i.line_name,p_expiry_month,p_expiry_year); -- i.ri_share -- edited by MarkS 4.20.2016 SR-22068
            ELSE
                rep.ri_share := i.ri_share;
            END IF;
            -- END SR-22068
             
            rep.currency_cd             := i.currency_cd;
            rep.currency_desc           := i.currency_desc;
            rep.print_fields            := FIELDS_FORMATTRIGGER(i.endt_seq_no, i.dist_no, i.frps_seq_no, i.d050_ri_cd, i.policy_no);
                         
            v_rec_exist := 'Y';
            
            PIPE ROW(rep);
        END LOOP;
        
        IF v_rec_exist = 'N' THEN
            PIPE ROW(rep);
        END IF;
    END get_report_details;
    
    FUNCTION GET_TOTAL_RI_SHARE( 
        p_policy_no     VARCHAR2,
        p_reinsurer     GIIS_REINSURER.RI_SNAME%TYPE,
        p_line          GIIS_LINE.LINE_NAME%TYPE,
        p_expiry_month  VARCHAR2,
        p_expiry_year   NUMBER
        ) 
    RETURN NUMBER IS
        v_ri_share GIRI_FRPS_RI.RI_TSI_AMT%type;   
    BEGIN
        SELECT SUM(ri_share)
            INTO v_ri_share
        FROM (SELECT b250.line_cd || '-' || b250.subline_cd || '-' || b250.iss_cd || '-' || LTRIM(RTRIM(TO_CHAR(b250.issue_yy, '09'))) || '-' || 
                     LTRIM(RTRIM(TO_CHAR(b250.pol_seq_no, '0999999'))) ||'-'|| LTRIM(TO_CHAR(b250.renew_no,'09'))  policy_no,
                     b250.policy_id policy_id,
                     LTRIM(b250.endt_iss_cd || '-' || LTRIM(RTRIM(TO_CHAR(b250.endt_yy, '09'))) || '-' || LTRIM(RTRIM(TO_CHAR(b250.endt_seq_no, '099999')))) endt_no,
                     b250.endt_seq_no,
                     TO_CHAR(c080.expiry_date,'MM-DD-YYYY') expiry_date,b250.incept_date, d050.ri_tsi_amt ri_share          
              FROM giis_reinsurer  a180,
                   giri_frps_ri d050,
                   giri_distfrps d060,
                   giuw_pol_dist c080,
                   gipi_polbasic b250,
                   giis_line a120,
                   giis_assured a020,
                   giri_binder d005,
                   giis_currency a430,
                   gipi_parlist a,
                   gipi_invoice b
              WHERE d050.ri_cd = a180.ri_cd
                  AND d060.line_cd = d050.line_cd
                  AND d060.frps_yy = d050.frps_yy
                  AND d060.frps_seq_no = d050.frps_seq_no
                  AND c080.dist_no = d060.dist_no
                  AND b250.policy_id = c080.policy_id
                  AND a120.line_cd = b250.line_cd                      
                  AND a020.assd_no = a.assd_no 
                  AND a.par_id = b250.par_id
                  AND d005.fnl_binder_id = d050.fnl_binder_id
                  AND d060.currency_cd = a430.main_currency_cd
                  AND d060.ri_flag = '2'
                  AND a120.line_name = NVL(UPPER(p_line), a120.line_name)
                  AND UPPER(a180.ri_sname) = UPPER(NVL(p_reinsurer, a180.ri_sname)) 
                  AND TO_CHAR(B250.expiry_date,'FMMONTH') = NVL(UPPER(p_expiry_month),TO_CHAR(B250.expiry_date,'FMMONTH'))
                  AND TO_CHAR(B250.expiry_date,'YYYY') = NVL(p_expiry_year,TO_CHAR(B250.expiry_date,'YYYY'))
                  AND b250.pol_flag IN ('1','2','3','X') 
                  AND nvl(d005.replaced_flag,'N') <> 'Y'
                  AND nvl(d050.reverse_sw,'N') <> 'Y'
                  AND b250.policy_id = b.policy_id
                  AND (b250.line_cd || '-' || b250.subline_cd || '-' || b250.iss_cd || '-' || LTRIM(RTRIM(TO_CHAR(b250.issue_yy, '09'))) || '-' || 
                      LTRIM(RTRIM(TO_CHAR(b250.pol_seq_no, '0999999'))) ||'-'|| LTRIM(TO_CHAR(b250.renew_no,'09'))) =p_policy_no
              ORDER BY a180.ri_name, a120.line_name, a180.ri_cd, 
                  b250.line_cd, b250.subline_cd, b250.iss_cd, 
                  b250.issue_yy, b250.pol_seq_no, b250.renew_no, 
                  LTRIM(b250.endt_iss_cd || '-' || LTRIM(RTRIM(TO_CHAR(b250.endt_yy, '09'))) || '-' || LTRIM(RTRIM(TO_CHAR(b250.endt_seq_no, '099999')))) desc,
                  d005.line_cd, d005.binder_yy,
                  d005.binder_seq_no, a430.main_currency_cd, a430.currency_desc);
        RETURN v_ri_share;
     END GET_TOTAL_RI_SHARE;
END GIRIR110_PKG;
/
