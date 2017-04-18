CREATE OR REPLACE PACKAGE BODY CPI.QUOTE_REPORTS_CA_PKG AS
/******************************************************************************
   NAME:       QUOTE_REPORTS_CA_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/02/2010   irwin        Created this package.
******************************************************************************/

---- Most of the casualty report files will use the same functions in this package. If there is a big difference in requirements,
---- the client name will be appended on the function to specify the usage.   
  
  FUNCTION get_quote_details_ca(p_quote_id NUMBER)
    RETURN ca_quote_details_tab PIPELINED IS
    
    v_ca_quote_detail ca_quote_details_type;
    v_tot_prem_amT  GIPI_QUOTE_ITMPERIL.PREM_AMT%TYPE;
    v_tot_tax_amt    GIPI_INV_TAX.TAX_AMT%TYPE;
    v_tsi_amt_seici VARCHAR2(50);    
  BEGIN

   FOR A IN (SELECT DISTINCT A.assd_name assd_name, A.address1, A.address2, A.address3, A.line_cd, A.subline_cd, a.assd_no,
                        TO_CHAR(A.incept_date, 'fmMonth DD, YYYY') incept_date,
                        TO_CHAR(A.expiry_date, 'fmMonth DD, YYYY') expiry_date,
                       TO_CHAR(A.accept_dt, 'fmDD Month YYYY') accept_date,
                        A.HEADER, 
                       A.footer,
                       A.remarks,
                       b.subline_name,
                       d.industry_nm
                   FROM gipi_quote A,
                       GIIS_SUBLINE b,
                       giis_assured c, giis_industry d
                  WHERE quote_id = p_quote_id
                       AND A.line_cd = b.line_cd
                       AND A.subline_cd = b.subline_cd
                       AND A.assd_no = c.assd_no(+)
                       AND c.industry_cd = d.industry_cd(+)
                       )            
    LOOP
      v_ca_quote_detail.assd_name            := A.assd_name;
      v_ca_quote_detail.assd_add1            := A.address1;
      v_ca_quote_detail.assd_add2            := A.address2;
      v_ca_quote_detail.assd_add3            := A.address3;
      v_ca_quote_detail.incept               := A.incept_date;
      v_ca_quote_detail.expiry               := A.expiry_date;
      v_ca_quote_detail.HEADER               := A.HEADER; 
      v_ca_quote_detail.footer               := A.footer;
      v_ca_quote_detail.line_cd              := A.line_cd;
      V_CA_QUOTE_DETAIL.SUBLINE_CD           := A.subline_cd;
      v_ca_quote_detail.subline_name         := A.subline_name;
      V_CA_QUOTE_DETAIL.accept_date             := A.accept_date;
      V_CA_QUOTE_DETAIL.remarks              := A.remarks;
      
      --GET QUOTE NO.  
      FOR A IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||quotation_no||'-'||proposal_no quote_no
                  FROM gipi_quote
                    WHERE quote_id = p_quote_id)
      LOOP
          v_ca_quote_detail.quote_num := A.quote_no;
      END LOOP;   
      
      --GET PREMIUM
      
      FOR E IN (SELECT SUM(prem_amt * currency_rate) prem_amt, SUM(A.tsi_amt * b.currency_rt) tsi_amt,
                           -- TO_CHAR(SUM(a.tsi_amt * b.currency_rt), '999,999,999,999.99') tsi_amt_seici,
                                     SUM(prem_amt * currency_rate) prem_amt1,
                                     b.short_name
                                FROM gipi_quote_item A,
                                   giis_currency b
                             WHERE quote_id = p_quote_id
                             AND A.currency_cd = b.main_currency_cd
                             GROUP BY b.short_name)
        LOOP
            v_ca_quote_detail.currency := E.short_name;        
            v_ca_quote_detail.tsi_amt     := E.tsi_amt;
            v_ca_quote_detail.prem_amt    := E.prem_amt;
            v_ca_quote_detail.prem1    := E.prem_amt1;
            v_ca_quote_detail.tsi_amt_seici :=  LTRIM(TO_CHAR(E.tsi_amt, '999,999,999,999.99'));
            --prem1    := e.prem_amt1;
        END LOOP;

        --v_ca_quote_detail.tsi_amt_seici     := v_ca_quote_detail.currency||LTRIM(v_tsi_amt_seici)||' combined single limit/ annual agregate';     
      
        BEGIN 
        SELECT SUM(DISTINCT b.tax_amt * A.currency_rt)tax
          INTO v_tot_tax_amt
          FROM gipi_quote_invoice A,
               gipi_quote_invtax b,
               gipi_quote_item c,
               gipi_quote d
         WHERE c.currency_cd = A.currency_cd
           AND d.quote_id = p_quote_id 
           AND A.quote_inv_no = b.quote_inv_no 
           AND d.quote_id = c.quote_id 
           AND A.quote_id = d.quote_id 
           AND b.iss_cd = A.iss_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
    
      v_ca_quote_detail.tot_prem              := NVL(v_ca_quote_detail.prem1, 0) + NVL(v_tot_tax_amt, 0);
      
      ----- FOR SEICI PREMIUM---
      
      FOR K IN (SELECT LTRIM(TO_CHAR(NVL(A.prem_amt,0)+ NVL(A.tax_amt,0), '999,999,999,999.99')) total
                            FROM gipi_quote_invoice A
                         WHERE A.quote_id = p_quote_id)    
      LOOP
        v_ca_quote_detail.tot_prem_seici:= K.total;
      END LOOP;
      
      --logo_name
      BEGIN
        SELECT param_value_v
          INTO v_ca_quote_detail.logo_file
          FROM giis_parameters  
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
       
      PIPE ROW(v_ca_quote_detail);
    END LOOP;
    
    RETURN;
  END get_quote_details_ca;
 
  FUNCTION get_quote_item(p_quote_id        NUMBER)
    RETURN quote_item_tab PIPELINED IS
    v_item quote_item_type;
    v_peril_exist VARCHAR2(1) := 'N';
    
    BEGIN 
    FOR A IN (SELECT A.item_title item_title, a.item_desc,  A.item_no
                  FROM gipi_quote_item A,
                       giis_currency b
                  WHERE quote_id = p_quote_id
                  AND A.currency_cd = b.main_currency_cd)
      LOOP
        v_item.item_title := A.item_title || ' ' || a.item_desc  ;
        v_item.item_no    := A.item_no;
       -- v_item.row_num    := a.rownum;
       
       FOR G IN (SELECT c.peril_name, (A.tsi_amt * b.currency_rate)wrd_rate , NVL(c.peril_lname, c.peril_name) peril_lname
       
                    FROM gipi_quote_itmperil A,
                         gipi_quote_item b,
                         giis_peril c
                   WHERE A.quote_id = p_quote_id
                 AND A.item_no = v_item.item_no
                 AND b.item_no = v_item.item_no
                 AND A.quote_id = b.quote_id
                 AND A.peril_cd = c.peril_cd
                          AND c.line_cd = 'CA')   
          LOOP
            v_item.peril_name := G.peril_name;
            v_item.wrd_rate    := G.wrd_rate;
            v_item.peril_lname:= G.peril_lname;
          END LOOP;
       PIPE ROW(v_item); 
      END LOOP;
      
           
    RETURN; 
  END get_quote_item;
  
  FUNCTION get_quote_ca_item(p_quote_id NUMBER, p_item_no NUMBER) 
    RETURN quote_ca_item_tab PIPELINED IS
    v_ca_item quote_ca_item_type;
    
    BEGIN  
      FOR G IN (SELECT A.LOCATION, b.item_no
                                      FROM gipi_quote_ca_item A, 
                                           gipi_quote_item b
                                      WHERE A.quote_id = p_quote_id
                                        AND A.quote_id = b.quote_id
                                        AND A.item_no = b.item_no
                                        AND A.item_no = p_item_no)
         LOOP
            v_ca_item.LOCATION := G.LOCATION;
            PIPE ROW(v_ca_item);
      END LOOP;  
    RETURN;
  END get_quote_ca_item;
  
  FUNCTION get_quote_peril_item(p_quote_id NUMBER, p_line_cd GIPI_QUOTE.line_cd%TYPE, p_item_no NUMBER)
  RETURN quote_peril_item_tab PIPELINED IS
  
    v_peril_item quote_peril_item_type;
    v_count3 number;
    
    BEGIN
    BEGIN
        v_count3:=0;
       v_peril_item.v_count1 := 0;          
        SELECT COUNT(A.tsi_amt)
          INTO v_peril_item.v_count1 
          FROM gipi_quote_itmperil A,
         gipi_quote_item b,
         giis_peril c
       WHERE A.quote_id = p_quote_id
         AND A.item_no = b.item_no
         AND A.quote_id = b.quote_id
         AND A.peril_cd = c.peril_cd
                 AND c.line_cd = 'CA';
      END;           
     -- IF v_peril_item.v_count1 >0 THEN  */
           
      FOR G IN (SELECT c.peril_name, (A.tsi_amt * b.currency_rate) tsi, c.peril_lname
                    FROM gipi_quote_itmperil A,
                         gipi_quote_item b,
                         giis_peril c
                   WHERE A.quote_id = p_quote_id
                 AND A.item_no = b.item_no
                 AND A.quote_id = b.quote_id
                 AND A.peril_cd = c.peril_cd
                          AND c.line_cd = 'CA')
                    
                  
      LOOP
        v_peril_item.peril_name := G.peril_name;
        v_peril_item.peril_lname := G.peril_lname;
        v_peril_item.tsi_amt    := G.tsi;
        PIPE ROW(v_peril_item);
      END LOOP;
      
    RETURN;
  END get_quote_peril_item;
         
  FUNCTION get_quote_deductible(p_quote_id NUMBER, p_line_cd GIPI_QUOTE.line_cd%TYPE, p_subline_cd GIPI_QUOTE.subline_cd%TYPE) 
  RETURN quote_deductible_item_tab PIPELINED IS
   
   v_deductible_item quote_deductible_item_type;
    
    BEGIN
    /* 
    bmq 06/06/2011  - Added filter in the select script to make sure that values retrieved are only those that aer desired.
    */
      FOR n IN (SELECT b.deductible_title ded_title,
                                       A.deductible_rt ded_rate,
                                       A.deductible_text,
                        LTRIM(TO_CHAR(A.deductible_amt,'999,999,999,999.99'),' ') ded_amt
                           FROM gipi_quote_deductibles A, 
                                giis_deductible_desc b,
                                gipi_quote_item c,
                                gipi_quote d            -- bmq 06/06/2011
                           WHERE A.ded_deductible_cd = b.deductible_cd
                             AND A.quote_id = p_quote_id
                             AND b.line_cd = NVL(p_line_cd, b.line_cd)
                             AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
                             AND A.item_no = c.item_no
                             and a.quote_id = d.quote_id            -- bmq
                             and c.quote_id = d.quote_id            -- bmq
                             and b.line_cd = d.line_cd              -- bmq
                             and b.subline_cd = d.subline_cd        -- bmq
                             AND A.quote_id = c.quote_id
                             )
                          
                          
       LOOP
            v_deductible_item.ded_title := n.ded_title;
            v_deductible_item.ded_text  := n.deductible_text;
            --v_deductible_item.ded_rt := n.ded_rate;
            --v_deductible_item.ded_amt := n.ded_amt;
            IF v_deductible_item.ded_text IS NULL THEN  
              v_deductible_item.ded_text := ' ';
              ELSE
              v_deductible_item.ded_text := '-'||' '||v_deductible_item.ded_text;
            END IF;     
         PIPE ROW(v_deductible_item);
       END LOOP;
       IF v_deductible_item.ded_text IS NULL THEN  
         v_deductible_item.ded_text := ' ';
       ELSE
         v_deductible_item.ded_text := '-'||' '||v_deductible_item.ded_text;
       END IF;         
        /*        
         IF v_ded_rt IS NULL THEN
           v_deduct := v_ded_amt;
         ELSE
           v_deduct := (v_ded_rt||'%');
         END IF;*/
      RETURN;   
      END  get_quote_deductible;
      
  FUNCTION get_ca_quote_invtax(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
  RETURN quote_invtax_tab PIPELINED IS
    v_tax  quote_invtax_type;
  BEGIN
    FOR i IN (SELECT b.tax_cd, E.tax_desc, SUM(DISTINCT b.tax_amt) tax_amt
                FROM gipi_quote_invoice A,
                     gipi_quote_invtax b,
                        gipi_quote_item c,
                        gipi_quote d,
                        giis_tax_charges E
                WHERE c.currency_cd = A.currency_cd
                 AND d.quote_id = P_QUOTE_ID
                    AND A.quote_inv_no = b.quote_inv_no
                    AND A.quote_id = c.quote_id
                    AND A.quote_id = d.quote_id
                    AND b.iss_cd = A.iss_cd
                    AND b.iss_cd = E.iss_cd
                    AND b.line_cd = E.line_cd
                    AND b.tax_cd = E.tax_cd
                    AND E.line_cd = 'CA'
               GROUP BY  b.tax_cd, E.tax_desc)
    LOOP
      v_tax.tax_cd      := i.tax_cd;
      v_tax.tax_desc := i.tax_desc;
      v_tax.tax_amt  := i.tax_amt;
      PIPE ROW(v_tax);
    END LOOP;
    RETURN;
    
  END get_ca_quote_invtax;
  
  FUNCTION get_ca_quote_warranty(p_quote_id    GIPI_QUOTE.quote_id%TYPE)
  RETURN ca_quote_warranty_tab PIPELINED IS
  
    v_war  ca_quote_warranty_type;
    text VARCHAR2(5000);
  BEGIN
    --warranty
     FOR warr IN ( SELECT wc_title, print_sw
                 FROM gipi_quote_wc
                WHERE quote_id = p_quote_id
               ORDER BY    print_seq_no)
     LOOP
         v_war.warranty := warr.wc_title;
         v_war.print_sw := warr.print_sw;    
        IF v_war.print_sw = 'Y' THEN
           v_war.warranty := warr.wc_title;
        ELSE
            v_war.warranty := '';
        END IF;
                 
      PIPE ROW(v_war);   
     END LOOP;
   
     
     RETURN;
   END get_ca_quote_warranty;
   
   FUNCTION get_ca_quote_warranty_text(p_quote_id GIPI_QUOTE.quote_id%TYPE, p_warranty GIPI_QUOTE_WC.wc_text01%TYPE)
   RETURN ca_quote_warranty_text_tab PIPELINED IS
   
    v_war  ca_quote_warranty_text_type;
    text VARCHAR2(5000);
  BEGIN
    
       FOR A IN (SELECT A.wc_text01||A.wc_text02||A.wc_text03|| A.wc_text04||A.wc_text05||
                           A.wc_text06||
                           A.wc_text07||
                           A.wc_text08||
                           A.wc_text09||
                           A.wc_text10||
                           A.wc_text11||
                           A.wc_text12||
                           A.wc_text13||
                           A.wc_text14||
                           A.wc_text15||
                           A.wc_text16||
                           A.wc_text17 war_text       
                      FROM giis_warrcla A,
                                   gipi_quote_wc b
                     WHERE b.quote_id = p_quote_id
                       AND A.line_cd = b.line_cd
                       AND A.main_wc_cd = b.wc_cd
                       AND b.print_sw = 'Y'
                       AND b.wc_title = p_warranty
                  ORDER BY b.print_seq_no)  
              LOOP
                 v_war.warranty_text := A.war_text;
              END LOOP;
      PIPE ROW(v_war);   
     RETURN;
  END;
  
  ----------CIC------------
  
  FUNCTION get_quote_item_cic(p_quote_id NUMBER, p_subline_cd GIPI_QUOTE.subline_cd%TYPE)
  RETURN quote_item_cic_tab PIPELINED IS
  
    v_item quote_item_cic_type;
  
  BEGIN
  
    FOR i IN (SELECT item_title, item_no
        FROM gipi_quote_item
       WHERE quote_id = p_quote_id)
    LOOP
      v_item.item_title := i.item_title;
      v_item.item_no := i.item_no;
      
      
      --- item tsi
      FOR E IN (SELECT (A.tsi_amt * b.currency_rt)tsi_amt,
                            prem_amt*currency_rate prem_amt, b.short_name
                            --TO_CHAR(SUM(prem_amt * currency_rate), '999,999,999,999.99') prem_amt
                                        --SUM(prem_amt * currency_rate) prem_amt1
                                  FROM gipi_quote_item A,
                                       giis_currency b
                                WHERE quote_id = p_quote_id
                               AND A.currency_cd = b.main_currency_cd
                               AND A.item_no = v_item.item_no)
        LOOP
                  v_item.item_tsi     := E.tsi_amt;
                v_item.currency     := E.short_name;
                  --v_prem    := v_prem+e.prem_amt;
                  --v_prem1    := e.prem_amt1;
        END LOOP;
      
      --item perils
      
      FOR K IN (SELECT --'Item' xitem,a.item_no item_no,
                        b.peril_name peril_name,
                        A.tsi_amt tsi_amt
                FROM  giis_peril b,
                          gipi_quote_itmperil A,
                              gipi_quote c,
                              gipi_quote_item d      
                      WHERE A.peril_cd = b.peril_cd
                        AND A.quote_id = c.quote_id
                          AND A.quote_id = p_quote_id
                          AND b.line_cd  = c.line_cd
                          AND A.item_no = d.item_no
                          AND A.quote_id = d.quote_id
                          AND A.item_no = i.item_no
                     ORDER BY A.item_no, b.peril_name
                     )
      LOOP
        v_item.peril_name := K.peril_name;
        v_item.item_peril_tsi := K.tsi_amt;
      END LOOP;    
      
      
                  
      PIPE ROW(v_item);
    END LOOP;
    RETURN;
  END get_quote_item_cic;  
  
  FUNCTION get_quote_deductible_cic(p_quote_id NUMBER, p_subline_cd GIPI_QUOTE.subline_cd%TYPE, p_item_no GIPI_QUOTE_item.item_no%TYPE) 
  RETURN quote_deductible_item_cic_tab PIPELINED IS
  
   v_item quote_deductible_item_cic_type;
  BEGIN  
  
  FOR l IN ( SELECT b.deductible_text ded_text,
                            A.deductible_rt ded_rate,
                            A.deductible_text,
                LTRIM(TO_CHAR(A.deductible_amt,'999,999,999,999.99'),' ') ded_amt
                 FROM gipi_quote_deductibles A, 
                      giis_deductible_desc b,
                      gipi_quote_item c
                  WHERE A.ded_deductible_cd = b.deductible_cd
                  AND A.quote_id = p_quote_id
                  AND b.line_cd = 'CA'
                  AND b.subline_cd = p_subline_cd
                  AND A.item_no = c.item_no
                  AND A.quote_id = c.quote_id
                  AND A.item_no = p_item_no)
  LOOP
    v_item.ded_text := l.ded_text;
    IF v_item.ded_text IS NULL THEN  
         v_item.ded_text := ' ';
       ELSE
         v_item.ded_text := '-'||' '||v_item.ded_text;
      END IF;  
    PIPE ROW(v_item);
  END LOOP;
  RETURN;
  END get_quote_deductible_cic;
  
  -----------------seici----------
  
  ------get location
  FUNCTION get_quote_ca_item_seici(p_quote_id NUMBER) 
  RETURN quote_ca_item_seici_tab PIPELINED IS
    v_item quote_ca_item_seici_type;
    BEGIN
      
        v_item.LOCATION := NULL;
        FOR G IN (SELECT DISTINCT A.LOCATION, A.limit_of_liability lol
                                FROM gipi_quote_ca_item A, 
                                     gipi_quote_item b
                             WHERE A.quote_id = p_quote_id
                                 AND A.quote_id = b.quote_id
                                 AND A.item_no = b.item_no
                                 /*AND a.item_no = v_item_no*/)    LOOP
            v_item.col := ': ';
            v_item.v_title2 := 'LOCATION OF RISK';  
            v_item.v_title3 := 'COVERAGE';    
                          
            IF v_item.LOCATION IS NOT NULL THEN
                v_item.LOCATION := G.LOCATION;
            ELSE
                v_item.LOCATION := G.LOCATION;
            END IF;        
            v_item.coverage := G.lol;
            
            IF v_item.LOCATION IS NULL THEN
              V_ITEM.coverage :=' ';
              v_item.col := ' ';
              v_item.v_title2 := ' ';
              v_item.v_title3 :=' ';  
            END IF;  
            
        END LOOP;
        PIPE ROW(v_item);
    RETURN;
    END get_quote_ca_item_seici;
    ---------get deductible
    FUNCTION get_quote_deductible_sei(p_quote_id NUMBER, p_subline_cd GIPI_QUOTE.subline_cd%TYPE) 
    RETURN quote_deductible_item_sei_tab PIPELINED IS
      v_item quote_deductible_item_sei_type;
      v_deductibles VARCHAR2(100);
      v_peril_ded   VARCHAR2(100);
      v_chk         VARCHAR2(10);
    BEGIN
      FOR peril IN (SELECT A.peril_cd, decode(b.peril_name, NULL, NULL, b.peril_name) peril_name,item_no--vj 042007
                 FROM gipi_quote_itmperil A, giis_peril b 
                                WHERE A.peril_cd = b.peril_cd
                                  AND b.line_cd = 'CA'
                                  AND (b.subline_cd = p_subline_cd OR b.subline_cd IS NULL)
                                  AND A.quote_id = p_quote_id)
     LOOP
          v_deductibles := NULL;
          v_peril_ded := NULL;
          v_chk := 'N';
        FOR ded IN (SELECT decode(deductible_text, NULL , NULL, deductible_text) deductible_text --030807: display null decode(deductible_text, null , '-', deductible_text) deductible_text
                        FROM gipi_quote_deductibles
                                     WHERE quote_id = p_quote_id
                                      AND  peril_cd = peril.peril_cd
                                      AND  item_no = peril.item_no--vj 042007
                                     ORDER BY deductible_text)
          LOOP  
            v_chk := 'Y';    
                  IF v_deductibles IS NULL THEN 
                     v_deductibles := ded.deductible_text;
                  ELSE 
                    v_deductibles  := v_deductibles||chr(10)||ded.deductible_text;     
                  END IF;    
            --v_chk_ded :=1;
          END LOOP;--ded 
          --display perils  if deductibles and deductible text are not null 
          IF v_chk = 'Y' THEN 
            v_peril_ded := peril.peril_name||chr(10)||v_deductibles ;
          ELSIF v_chk = 'N' THEN 
            v_peril_ded := NULL;
          END IF;
        
          IF v_item.peril_name IS NULL THEN 
          v_item.peril_name := v_peril_ded;
           ELSIF 
             v_item.peril_name IS NOT NULL AND v_deductibles IS NOT NULL THEN 
             v_item.peril_name := v_item.peril_name||chr(10)||v_peril_ded;
          END IF;
          
          v_item.col := ': ';
          v_item.v_title6 := 'DEDUCTIBLE';  
            
          IF v_item.peril_name IS NULL THEN
              v_item.col := ' ';
              v_item.v_title6 :=' ';  
            END IF;                    
            
     PIPE ROW(v_item);         
     END LOOP;
     RETURN; 
    END get_quote_deductible_sei;


  FUNCTION get_quote_details_ca_ucpb (p_quote_id NUMBER, p_item_no NUMBER)----------CASUALTY_QUOTE_UCPB---------------gino 5.9.11
                                                 
   RETURN ca_quote_details_ucpb_tab PIPELINED
  IS
    v_ca_quote_detail_ucpb   ca_quote_details_ucpb_type;
    v_the_same  	  VARCHAR2(1); --added by steven 1.24.2013
    v_short_name_temp VARCHAR2(10) := NULL; --added by steven 1.24.2013
  BEGIN
	--added by steven 1.24.2013; to check if it has different currency 
		 FOR j IN (SELECT c.short_name 
					 FROM gipi_quote_item A, giis_currency c
					WHERE A.quote_id = p_quote_id
					  AND A.currency_cd = c.main_currency_cd)
			 LOOP
				IF v_short_name_temp is NULL THEN
					v_short_name_temp := j.short_name;
					v_the_same := 'Y';
				ELSE
					IF v_short_name_temp = j.short_name THEN
						v_short_name_temp := j.short_name;
						v_the_same := 'Y';
					ELSE
						v_short_name_temp := 'PHP';
						v_the_same := 'N';
						EXIT;
					END IF;
				END IF;
		 END LOOP;
   FOR A IN (SELECT DISTINCT A.assd_name, c.designation, --f.LOCATION,
                             --f.interest_on_premises,  
                             A.tsi_amt, A.prem_amt,
							 H.tsi_amt tsi_amt_per_item, H.prem_amt prem_amt_per_item, H.currency_rate, --added by steven 1.25.2013;for the quotation report in marketing,when it has multiple currency.
                             d.industry_nm  industry,
            /*              (SELECT SUM (deductible_amt) deductible_amt
                                FROM gipi_quote_deductibles
                               WHERE quote_id = p_quote_id) deductible_amt,
              bmq 06/06/2011 created separate script to get deductibles                */    
                             A.valid_date, A.quote_id,
                             E.subline_name, A.iss_cd,
                                A.line_cd
                             || '-'
                             || A.subline_cd
                             || '-'
                             || iss_cd
                             || '-'
                             || quotation_yy
                             || '-'
                             || LTRIM (TO_CHAR (quotation_no, '0000009'))
                             || '-'
                             || LTRIM (TO_CHAR (proposal_no, '09')) quote_no,
                             HEADER, footer, incept_date, expiry_date,
                             accept_dt,
                                address1
                             || CHR (10)
                             || address2
                             || CHR (10)
                             || address3 address,
                             A.remarks, A.line_cd--, f.item_no
                             , h.item_no, h.item_title, h.item_desc
                             , j.coverage_desc, a.subline_cd
                        FROM gipi_quote A,
                             giis_line b,
                             giis_assured c,
                             giis_industry d,               -- bmq  06/06/2011 
                             --giis_users d,
                             giis_subline E,
                             --gipi_quote_ca_item f,         
                             gipi_quote_item H,                   -- bmq 06/06/2011
                             giis_coverage  J                -- bmq 06/06/2011 
                       WHERE 1=1--A.quote_id = f.quote_id(+)
                         AND A.line_cd = b.line_cd(+)
                         AND A.assd_no = c.assd_no(+)
                         --AND A.user_id = d.user_id(+)
                         AND A.line_cd = E.line_cd(+)
                         AND A.line_cd = b.line_cd(+)
                         AND A.subline_cd = E.subline_cd(+)
                         --AND A.quote_id = f.quote_id(+)
                         AND c.industry_cd = d.industry_cd(+)
                         AND A.quote_id = h.quote_id(+)
                         --AND f.item_no = h.item_no
                         AND h.coverage_cd = j.coverage_cd(+) 
                         AND A.quote_id = p_quote_id
                         )
                         --AND f.item_no = nvl(p_item_no, f.item_no))
   LOOP
      v_ca_quote_detail_ucpb.assd_name := A.assd_name;
      v_ca_quote_detail_ucpb.designation := A.designation;
      v_ca_quote_detail_ucpb.assd_industry  := A.industry;
      FOR ca_item in (select location, interest_on_premises
                            from gipi_quote_ca_item
                           where quote_id   = p_quote_id
                             and item_no    = A.item_no)
        LOOP
            v_ca_quote_detail_ucpb.LOCATION := ca_item.LOCATION;
            v_ca_quote_detail_ucpb.interest_on_premises := ca_item.interest_on_premises;       
        END LOOP;
		--added by steven 1.25.2013 
      IF v_the_same = 'N' THEN
			v_ca_quote_detail_ucpb.tsi_amt_per_item := A.tsi_amt_per_item * A.currency_rate;
			v_ca_quote_detail_ucpb.prem_amt_per_item := A.prem_amt_per_item * A.currency_rate;
	  ELSE
	  		v_ca_quote_detail_ucpb.tsi_amt_per_item := A.tsi_amt_per_item;
			v_ca_quote_detail_ucpb.prem_amt_per_item := A.prem_amt_per_item;
	  END IF;
	  v_ca_quote_detail_ucpb.short_name2 := INITCAP(v_short_name_temp);
	  
      v_ca_quote_detail_ucpb.tsi_amt := A.tsi_amt;
      v_ca_quote_detail_ucpb.prem_amt := A.prem_amt;
      v_ca_quote_detail_ucpb.item_title :=  A.item_title;
      v_ca_quote_detail_ucpb.item_desc  :=  NVL(A.item_desc,' ');
      v_ca_quote_detail_ucpb.coverage   :=  A.coverage_desc;
      v_ca_quote_detail_ucpb.item_no    :=  A.item_no;
--      v_ca_quote_detail_ucpb.deductible_amt := NVL (A.deductible_amt, 0);

      v_ca_quote_detail_ucpb.valid_date :=
               NVL (TO_CHAR (A.valid_date, 'fmMonth dd, yyyy'), '__________');
      v_ca_quote_detail_ucpb.quote_id := A.quote_id;
      v_ca_quote_detail_ucpb.subline_name := A.subline_name;
      v_ca_quote_detail_ucpb.iss_cd := A.iss_cd;
      v_ca_quote_detail_ucpb.quote_no := A.quote_no;
      v_ca_quote_detail_ucpb.HEADER := A.HEADER;
      v_ca_quote_detail_ucpb.footer := A.footer;
      v_ca_quote_detail_ucpb.incept_date :=
                                  TO_CHAR (A.incept_date, 'fmMonth dd, yyyy');
      v_ca_quote_detail_ucpb.expiry_date :=
                                  TO_CHAR (A.expiry_date, 'fmMonth dd, yyyy');
      v_ca_quote_detail_ucpb.accept_dt :=
                                    TO_CHAR (A.accept_dt, 'fmMonth dd, yyyy');
      v_ca_quote_detail_ucpb.address := A.address;
      v_ca_quote_detail_ucpb.remarks := A.remarks;
      v_ca_quote_detail_ucpb.line_cd := A.line_cd;
      --v_ca_quote_detail_ucpb.item_no := A.item_no;
      
      v_ca_quote_detail_ucpb.subline_cd := A.subline_cd;
            
      PIPE ROW (v_ca_quote_detail_ucpb);
   END LOOP;
END get_quote_details_ca_ucpb;
 FUNCTION get_quote_tax_ca_ucpb(p_quote_id NUMBER)
 RETURN quote_ca_tax_tab PIPELINED IS
 v_tax    quote_ca_tax_type;
 v_the_same  	 VARCHAR2(1); --added by steven 1.24.2013
 v_short_name_temp VARCHAR2(10) := NULL; --added by steven 1.24.2013
 BEGIN
 	--added by steven 1.24.2013; to check if it has different currency 
		 FOR j IN (SELECT c.short_name 
					 FROM gipi_quote_item A, giis_currency c
					WHERE A.quote_id = p_quote_id
					  AND A.currency_cd = c.main_currency_cd)
			 LOOP
				IF v_short_name_temp is NULL THEN
					v_short_name_temp := j.short_name;
					v_the_same := 'Y';
				ELSE
					IF v_short_name_temp = j.short_name THEN
						v_short_name_temp := j.short_name;
						v_the_same := 'Y';
					ELSE
						v_short_name_temp := 'PHP';
						v_the_same := 'N';
						EXIT;
					END IF;
				END IF;
		 END LOOP;
	
   FOR c IN (SELECT DISTINCT b.tax_desc,
   					 SUM(A.tax_amt) orig_tax_amt, --added by steven 1.25.2013
                     ROUND(SUM(A.tax_amt * c.currency_rt),2) tax_amt,
                     ROUND(SUM(c.prem_amt * c.currency_rt),2) prem_amt,
                     --c.prem_amt+c.tax_amt total,
                     --E.short_name,
                     SEQUENCE
                 FROM gipi_quote_invtax A, giis_tax_charges b, gipi_quote_invoice c--, gipi_quote d--, giis_currency E
                WHERE 1 = 1 --b.line_cd = d.line_cd
                  AND b.tax_cd = A.tax_cd
                  AND b.iss_cd = c.iss_cd
                  AND A.iss_cd = c.iss_cd
                  AND A.quote_inv_no = c.quote_inv_no
                  AND NVL (b.expired_sw, 'N') = 'N'
                  AND c.quote_id = p_quote_id
                  --AND c.quote_id = d.quote_id
                  --AND c.currency_cd = E.main_currency_cd
                  AND A.line_cd = b.line_cd
               GROUP BY c.quote_id, b.tax_desc, sequence
               order by sequence)
   LOOP
   		IF v_the_same = 'N' THEN
			v_tax.orig_tax_amt := c.tax_amt;
		ELSE
			v_tax.orig_tax_amt := c.orig_tax_amt;
		END IF;
         v_tax.tax_desc   := c.tax_desc;
         v_tax.tax_amt    := c.tax_amt;
         v_tax.prem_amt   := c.prem_amt;
         --v_tax.short_name := c.short_name;
         v_tax.total      := NVL(c.tax_amt, 0) + NVL(c.prem_amt, 0);
         
         BEGIN
            SELECT short_name INTO v_tax.short_name
                FROM giis_currency
                WHERE currency_rt = 1
                AND rownum = 1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;         
         END;

         PIPE ROW(v_tax);
   END LOOP;
   RETURN; 
 END ;
 
  FUNCTION get_casualty_signatory(p_line_cd VARCHAR2, p_iss_cd VARCHAR2)
  RETURN casualty_signatory_tab PIPELINED IS
      v_sig    casualty_signatory_type;
      v_count number:=0;
  BEGIN
  
     FOR sig IN (SELECT SIGNATORY,DESIGNATION
                           FROM GIIS_SIGNATORY A,GIIS_SIGNATORY_NAMES B
                     WHERE 1=1
                       AND nvl(A.iss_cd,p_iss_cd) = p_iss_cd
                       AND current_signatory_sw = 'Y'     
                       AND A.signatory_id = b.signatory_id 
                       AND A.line_cd = p_line_cd)
      LOOP
          v_count:=v_count+1;
          v_sig.sig_name := sig.signatory;
          v_sig.sig_des := sig.designation;
      PIPE ROW(v_sig);     
      END LOOP;
      IF v_count=0 THEN
          v_sig.sig_name := '____________';
          v_sig.sig_des :=  '____________';
      PIPE ROW(v_sig);
      END IF;  
    
    RETURN;    
  END;
  
  FUNCTION get_quote_peril_item_ucpb(p_quote_id NUMBER, p_line_cd GIPI_QUOTE.line_cd%TYPE, p_item_no NUMBER)
  RETURN quote_peril_item_ucpb_tab PIPELINED IS
  
    v_peril_item quote_peril_item_ucpb_type;
	v_the_same  	 VARCHAR2(1); --added by steven 1.24.2013
	v_short_name_temp VARCHAR2(10) := NULL; --added by steven 1.24.2013
	v_tsi_amt		 gipi_quote_item.tsi_amt%TYPE := 0; --added by steven 1.24.2013
	

    BEGIN
		 --added by steven 1.24.2013; to check if it has different currency 
		 FOR j IN (SELECT c.short_name 
					 FROM gipi_quote_item A, giis_currency c
					WHERE A.quote_id = p_quote_id
					  AND A.currency_cd = c.main_currency_cd)
			 LOOP
				IF v_short_name_temp is NULL THEN
					v_short_name_temp := j.short_name;
					v_the_same := 'Y';
				ELSE
					IF v_short_name_temp = j.short_name THEN
						v_short_name_temp := j.short_name;
						v_the_same := 'Y';
					ELSE
						v_short_name_temp := 'Php';
						v_the_same := 'N';
						EXIT;
					END IF;
				END IF;
		 END LOOP;
      FOR G IN (SELECT b.currency_rate,c.peril_name, A.tsi_amt/* * b.currency_rate*/ tsi, c.peril_lname
                        , initcap(f.short_name) short_name        --- bmq 06/06/2011
                  FROM gipi_quote_itmperil A,
                       gipi_quote_item b,
                       giis_peril c,
                       giis_currency f         -- bmq 06/06/2011
                 WHERE A.quote_id = p_quote_id
                   AND A.item_no = b.item_no
                   AND A.quote_id = b.quote_id
                   AND A.peril_cd = c.peril_cd
                   AND A.item_no = nvl(p_item_no, A.item_no)
                   AND c.line_cd = p_line_cd        --bmq
                   AND b.currency_cd = f.main_currency_cd      -- bmq 06/06/2011
                   )
                    
                  
      LOOP
        v_peril_item.peril_name := G.peril_name;
        v_peril_item.peril_lname := G.peril_lname;
		v_peril_item.short_name := INITCAP(v_short_name_temp); 
		IF v_the_same = 'N' THEN
			v_tsi_amt := NVL(G.tsi,0) * G.currency_rate;
		ELSE
			v_tsi_amt    :=NVL(G.tsi,0);
		END IF;
       v_peril_item.tsi_amt  := to_char(v_tsi_amt, '999,999,999,999.00');
	   
        PIPE ROW(v_peril_item);
      END LOOP;
      
    RETURN;
  END get_quote_peril_item_ucpb;---------------------CASUALTY_QUOTE_UCPB--------------------end gino 5.9.11


  function get_quote_deductible_ucpb(p_quote_id number, p_item_no number)
    return quote_deductible_ucpb_tab pipelined
    is
    v_ded_ucpb      quote_deductible_ucpb_type;
  begin
    for ded in (select b.deductible_title ded_title,
                                       a.deductible_rt ded_rt,
                                       a.deductible_text ded_text,
                                       a.deductible_amt ded_amt,
                                       a.item_no,
                                       a.peril_cd
                           from gipi_quote_deductibles a, 
                                giis_deductible_desc b,
                                gipi_quote d            
                           WHERE 
                            A.ded_deductible_cd = b.deductible_cd
                             and b.line_cd = d.line_cd              
                             and b.subline_cd = d.subline_cd        
                             and a.quote_id = d.quote_id
                             AND a.quote_id = p_quote_id
                             and A.item_no = p_item_no                             
                             )
        loop
            v_ded_ucpb.ded_title    := ded.ded_title;
            v_ded_ucpb.ded_text     := ded.ded_text;
            v_ded_ucpb.item_no      := ded.item_no;
            v_ded_ucpb.peril_cd     := ded.peril_cd;
            v_ded_ucpb.ded_amt      := ded.ded_amt;
            v_ded_ucpb.ded_rt       := ded.ded_rt;
            pipe row(v_ded_ucpb);
        end loop;
     return;
  end;              -- bmq 06/10/2011
END QUOTE_REPORTS_CA_PKG;
/


