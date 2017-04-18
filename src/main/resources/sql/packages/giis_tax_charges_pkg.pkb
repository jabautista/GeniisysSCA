CREATE OR REPLACE PACKAGE BODY CPI.Giis_Tax_Charges_Pkg AS

  FUNCTION get_tax_list (p_line_cd   GIIS_TAX_CHARGES.line_cd%TYPE,
                         p_iss_cd    GIIS_TAX_CHARGES.iss_cd%TYPE,
       p_quote_id  GIPI_QUOTE.quote_id%TYPE)     
    RETURN tax_list_tab PIPELINED IS
 
 v_tax  tax_list_type;
 
  BEGIN
    FOR i IN (
  SELECT a.tax_cd, a.line_cd, a.iss_cd, a.tax_desc, a.rate, a.peril_sw, a.tax_id, a.allocation_tag, a.primary_sw
      FROM GIIS_TAX_CHARGES a
   WHERE iss_cd = p_iss_cd 
     AND line_cd = p_line_cd
       AND a.eff_start_date <= (SELECT NVL(incept_date, SYSDATE) 
                  FROM GIPI_QUOTE
           WHERE quote_id = p_quote_id)                   
       AND a.eff_end_date >= (SELECT NVL(incept_date, SYSDATE) 
                  FROM GIPI_QUOTE
           WHERE quote_id = p_quote_id)
  ORDER BY tax_desc)
 LOOP
  v_tax.tax_cd   := i.tax_cd;
  v_tax.line_cd   := i.line_cd;
  v_tax.iss_cd   := i.iss_cd;
  v_tax.tax_desc   := i.tax_desc;
  v_tax.rate    := i.rate;
  v_tax.peril_sw   := i.peril_sw;
  v_tax.tax_id   := i.tax_id;
  v_tax.allocation_tag := i.allocation_tag;
  v_tax.primary_sw  := i.primary_sw; --added by cris 02/01/10 for checking required taxes
   PIPE ROW(v_tax);
 END LOOP;
 
    RETURN;
  END get_tax_list;

  /* CREATED BY ANTHONY SANTOS Nov 11, 2010
   * ModuleId: GIPIS017B
   * Get Tax List for Bond line code
  */
  FUNCTION get_bond_tax_list (p_line_cd   GIIS_TAX_CHARGES.line_cd%TYPE,
                              p_iss_cd    GIIS_TAX_CHARGES.iss_cd%TYPE,
                              p_par_id  gipi_wpolbas.par_id%TYPE,
                              p_vat_tag   GIIS_ASSURED.vat_tag%TYPE)     
    RETURN tax_list_tab PIPELINED IS
 
   v_tax  tax_list_type;
   vat_cd GIIS_TAX_CHARGES.tax_cd%TYPE; 
   --added new variables by jhing 11.09.2014
   v_eff_date gipi_wpolbas.eff_date%TYPE ; 
   v_issue_date gipi_wpolbas.issue_date%TYPE ;
   v_incept_date gipi_wpolbas.incept_date%TYPE; 
   v_sum_premium  gipi_winvoice.prem_amt%TYPE;
   v_docstamps_cd  giac_parameters.param_value_n%TYPE := giacp.n('DOC_STAMPS'); 
   v_allow_neg_dst giis_parameters.param_value_v%TYPE := NVL (giisp.v ('ALLOW_NEGATIVE_DST'), 'Y')  ; 
   v_exist    varchar2(1);
 
  BEGIN
   --belle 10.30.2012 to hide vat record in LOV when vat exempt
    IF p_vat_tag = 1 THEN
        vat_cd := GIACP.N('EVAT');
    END IF; 
    
    -- jhing 11.09.2014 retrieved dates from gipi_wpolbas
    FOR polbas in (SELECT a.eff_date , a.issue_date , a.incept_date
                    FROM gipi_wpolbas a WHERE a.par_id = p_par_id )
    LOOP
        v_eff_date := polbas.eff_date ;
        v_issue_date := polbas.issue_date;
        v_incept_date := polbas.incept_date;
    END LOOP;
    
    -- jhing 11.11.2014 added code to query sum premium
    v_sum_premium := 0 ; 
     FOR itmgrp IN (SELECT SUM(nvl(a.prem_amt,0)) prem_amt
            FROM gipi_witmperl a 
                WHERE a.par_id = p_par_id )
     LOOP
        v_sum_premium := itmgrp.prem_amt;
     END LOOP;

    FOR i IN (SELECT a.tax_cd, a.line_cd, a.iss_cd, a.tax_desc, NVL(a.rate,0) rate , a.peril_sw, a.tax_id, DECODE(a.allocation_tag,'N','F',NULL,'F',a.allocation_tag) allocation_tag /* jhing 11.09.2014 added decode to prevent check constraint for bonds when alloc = N ; added NVL to rate*/
                    , a.primary_sw, a.no_rate_tag, a.tax_amount, a.tax_type , a.takeup_alloc_tag
                FROM GIIS_TAX_CHARGES a
               WHERE iss_cd = p_iss_cd 
                 AND line_cd = p_line_cd
                 AND pol_endt_sw in ('B','P') 
                 /*AND a.eff_start_date <= (SELECT eff_date
                                            from gipi_wpolbas
                                           where par_id = p_par_id)                   
                 AND a.eff_end_date >= (SELECT eff_date
                                          from gipi_wpolbas
                                         where par_id = p_par_id)*/ -- commented out and replaced with the same condition from regular policy par issuance (non-bonds) for consistency of tax computation
                 -- jhing 11.09.2014 new condition :
                 AND (   (    a.eff_start_date <=
                       NVL (v_eff_date, v_incept_date)
                     AND a.eff_end_date >=
                       NVL (v_eff_date, v_incept_date)
                     AND NVL (a.issue_date_tag, 'N') = 'N'
                                    )
                     OR (    a.eff_start_date <= v_issue_date
                       AND a.eff_end_date >= v_issue_date
                       AND NVL (a.issue_date_tag, 'N') = 'Y'
                     )
                  )
                 AND NVL(a.expired_sw,'N') = 'N'  -- jhing 11.09.2014 added NVL
                 AND a.tax_cd <> NVL(vat_cd, 0) --belle 10.30.2012
               ORDER BY tax_desc)
     LOOP
          v_exist := 'Y'; 
          v_tax.tax_cd   := i.tax_cd;
          v_tax.line_cd   := i.line_cd;
          v_tax.iss_cd   := i.iss_cd;
          v_tax.tax_desc   := i.tax_desc;
          v_tax.rate    := i.rate;
          v_tax.peril_sw   := i.peril_sw;
          v_tax.tax_id   := i.tax_id;
          v_tax.allocation_tag := i.allocation_tag;
          v_tax.primary_sw  := i.primary_sw; --added by cris 02/01/10 for checking required taxes
          v_tax.no_rate_tag  := i.no_rate_tag;
          v_tax.tax_amount := i.tax_amount;     --added by Gzelle 10302014
          v_tax.tax_type   := i.tax_type;
          v_tax.takeup_alloc_tag := i.takeup_alloc_tag ; -- added by jhing 11.09.2014
          
            -- jhing 11.10.2014 added code to restrict display of DST for negative premium 
          IF v_tax.tax_cd = v_docstamps_cd AND v_sum_premium < 0 AND v_allow_neg_dst = 'N' THEN
             v_exist := 'N'; 
          END IF;          
          
          IF v_exist = 'Y'
          THEN
            PIPE ROW(v_tax);
          END IF;
     END LOOP;
 
    RETURN;
  END get_bond_tax_list;


/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS026 
  RECORD GROUP NAME: PACKAGE 
***********************************************************************************/

  FUNCTION get_package_tax_list(p_par_id   GIPI_WITEM.par_id%TYPE,
             p_item_grp    GIPI_WITEM.item_grp%TYPE,
        p_iss_cd   GIIS_TAX_CHARGES.iss_cd%TYPE)
 RETURN tax_list_tab PIPELINED IS
 
 v_tax  tax_list_type;
 
  BEGIN
    FOR i IN (
  SELECT a.tax_cd, a.line_cd, a.iss_cd, a.tax_desc, a.rate, a.peril_sw, a.tax_id, a.allocation_tag, a.primary_sw
    FROM GIIS_TAX_CHARGES a
   WHERE EXISTS (SELECT 'a' 
              FROM GIPI_WITEM 
           WHERE par_id       = p_par_id 
             AND item_grp     = p_item_grp 
        AND pack_line_cd = a.line_cd 
         GROUP BY pack_line_cd) 
     AND iss_cd = p_iss_cd 
       AND a.pol_endt_sw IN ('B','P') 
       AND ((a.eff_start_date <= (SELECT NVL(eff_date,incept_date) 
                 FROM GIPI_WPOLBAS
             WHERE par_id = p_par_id)
                       AND NVL(a.issue_date_tag,'N') = 'N') 
                        OR (a.eff_start_date <= (SELECT issue_date 
                           FROM GIPI_WPOLBAS
                    WHERE par_id = p_par_id)
                        AND NVL(a.issue_date_tag,'N') = 'Y'))
   ORDER BY tax_cd)
 LOOP
  v_tax.tax_cd   := i.tax_cd;
  v_tax.line_cd   := i.line_cd;
  v_tax.iss_cd   := i.iss_cd;
  v_tax.tax_desc   := i.tax_desc;
  v_tax.rate    := i.rate;
  v_tax.peril_sw   := i.peril_sw;
  v_tax.tax_id   := i.tax_id;
  v_tax.allocation_tag := i.allocation_tag;
  v_tax.primary_sw  := i.primary_sw; --added by cris 02/01/10 for checking required taxes
   PIPE ROW(v_tax);
 END LOOP;
 
    RETURN;
  END get_package_tax_list;
  

/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS026 
  RECORD GROUP NAME: POLICY 
***********************************************************************************/

  FUNCTION get_policy_tax_list(p_line_cd   GIIS_TAX_CHARGES.line_cd%TYPE,
               p_iss_cd      GIIS_TAX_CHARGES.iss_cd%TYPE,
          p_par_id     GIPI_WPOLBAS.par_id%TYPE)
 RETURN tax_list_tab PIPELINED IS
 
 v_tax  tax_list_type;
 
  BEGIN
    FOR i IN (
  SELECT a.tax_cd, a.line_cd, a.iss_cd, a.tax_desc, a.rate, a.peril_sw, a.tax_id, a.allocation_tag, a.primary_sw
    FROM GIIS_TAX_CHARGES a 
   WHERE a.line_cd = p_line_cd 
     AND a.iss_cd  = p_iss_cd 
       AND a.pol_endt_sw IN ('B','P')  
       AND ((a.eff_start_date <= (SELECT NVL(eff_date, incept_date)  
                       FROM GIPI_WPOLBAS
                       WHERE par_id = p_par_id)
                    AND NVL(a.issue_date_tag,'N') = 'N') 
                        OR (a.eff_start_date <= (SELECT issue_date 
                                FROM GIPI_WPOLBAS
                              WHERE par_id = p_par_id)
                           AND NVL(a.issue_date_tag,'N') = 'Y'))
      ORDER BY tax_cd)
 LOOP
  v_tax.tax_cd   := i.tax_cd;
  v_tax.line_cd   := i.line_cd;
  v_tax.iss_cd   := i.iss_cd;
  v_tax.tax_desc   := i.tax_desc;
  v_tax.rate    := i.rate;
  v_tax.peril_sw   := i.peril_sw;
  v_tax.tax_id   := i.tax_id;
  v_tax.allocation_tag := i.allocation_tag;
  v_tax.primary_sw  := i.primary_sw; --added by cris 02/01/10 for checking required taxes
   PIPE ROW(v_tax);
 END LOOP;
 
    RETURN;
  END get_policy_tax_list;
  
  
/********************************** FUNCTION 3 ************************************
  MODULE: GIPIS026 
  RECORD GROUP NAME: TAX_ISSUE_PLACE 
***********************************************************************************/

  FUNCTION get_tax_issue_place_list(p_line_cd GIIS_TAX_CHARGES.line_cd%TYPE,
                 p_iss_cd GIIS_TAX_CHARGES.iss_cd%TYPE,
         p_place_cd  GIIS_TAX_ISSUE_PLACE.place_cd%TYPE,
         p_par_id   GIPI_WPOLBAS.par_id%TYPE)
 RETURN tax_list_tab PIPELINED IS
 
 v_tax  tax_list_type;
 
  BEGIN
    FOR i IN (
  SELECT DISTINCT a.tax_cd, a.line_cd, a.iss_cd, NVL(b.rate, a.rate) rate, a.tax_id, 
         a.tax_desc, a.peril_sw, a.allocation_tag, a.primary_sw
    FROM GIIS_TAX_ISSUE_PLACE b, GIIS_TAX_CHARGES a
   WHERE a.line_cd     = p_line_cd 
     AND a.iss_cd   = p_iss_cd 
       AND b.line_cd  (+)= a.line_cd
     AND b.iss_cd   (+)= a.iss_cd
       AND b.tax_cd   (+)= a.tax_cd
       AND b.place_cd (+)= p_place_cd
       AND a.pol_endt_sw IN ('B','P') 
       AND ((a.eff_start_date <= (SELECT NVL(eff_date, incept_date)
                                    FROM GIPI_WPOLBAS
                                  WHERE par_id = p_par_id)
                     AND NVL(a.issue_date_tag,'N') = 'N') 
                  OR (a.eff_start_date <= (SELECT issue_date
                                                                  FROM GIPI_WPOLBAS
                                                              WHERE par_id = p_par_id)
                           AND NVL(a.issue_date_tag,'N') = 'Y'))
  ORDER BY tax_cd)
 LOOP
  v_tax.tax_cd   := i.tax_cd;
  v_tax.line_cd   := i.line_cd;
  v_tax.iss_cd   := i.iss_cd;
  v_tax.tax_desc   := i.tax_desc;
  v_tax.rate    := i.rate;
  v_tax.peril_sw   := i.peril_sw;
  v_tax.tax_id   := i.tax_id;
  v_tax.allocation_tag := i.allocation_tag;
  v_tax.primary_sw  := i.primary_sw; --added by cris 02/01/10 for checking required taxes
   PIPE ROW(v_tax);
 END LOOP;
 
    RETURN;
  END get_tax_issue_place_list;    


/********************************** FUNCTION 4 ************************************
  MODULE: GIIMM002 
  RECORD GROUP NAME: RG_TAX_CHARGES 
***********************************************************************************/  
  
  FUNCTION get_tax_charges_list (p_line_cd      GIIS_TAX_CHARGES.line_cd%TYPE,
                            p_iss_cd       GIIS_TAX_CHARGES.iss_cd%TYPE,
          p_incept_date  GIIS_TAX_CHARGES.eff_start_date%TYPE) 
    RETURN tax_list_tab PIPELINED IS
 
 v_tax  tax_list_type;
 
  BEGIN
    FOR i IN (
  SELECT tax_cd, tax_desc, rate, tax_id, line_cd, iss_cd, peril_sw, allocation_tag, primary_sw
    FROM GIIS_TAX_CHARGES
   WHERE line_cd = p_line_cd
     AND iss_cd = p_iss_cd
     AND eff_start_date <= p_incept_date
   ORDER BY tax_cd)
 LOOP
  v_tax.tax_cd   := i.tax_cd;
  v_tax.line_cd   := i.line_cd;
  v_tax.iss_cd   := i.iss_cd;
  v_tax.tax_desc   := i.tax_desc;
  v_tax.rate    := i.rate;
  v_tax.peril_sw   := i.peril_sw;
  v_tax.tax_id   := i.tax_id;
  v_tax.allocation_tag := i.allocation_tag;
  v_tax.primary_sw  := i.primary_sw; --added by cris 02/01/10 for checking required taxes
   PIPE ROW(v_tax);
 END LOOP;
 
    RETURN;
  END get_tax_charges_list;
  

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : June 6, 2011
**  Reference By  : GIIMM002 - Package Quotation Information
**  Description   : Function giis_tax_charges list of values 
*/

    FUNCTION get_quote_tax_charges_list (p_line_cd   	GIIS_TAX_CHARGES.line_cd%TYPE,
                                         p_iss_cd    	GIIS_TAX_CHARGES.iss_cd%TYPE,
                                         p_quote_id  	GIPI_QUOTE.quote_id%TYPE,
                                         p_find_text	VARCHAR2) 
    RETURN tax_list_tab PIPELINED AS

     v_tax  tax_list_type;
     v_vat_tag GIIS_ASSURED.vat_tag%type; --added by steven 11.9.2012 
     v_tax_cd  giac_parameters.param_value_n%type; --added by steven 11.9.2012 
    BEGIN
        v_vat_tag := 'X';
        BEGIN --added by steven 11.9.2012 
            SELECT giacp.n('EVAT') 
                INTO v_tax_cd
                FROM dual;
                
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                    v_tax_cd := NULL;
        END;
        
        FOR j IN (SELECT a.vat_tag      --added by steven 11.9.2012 When Assured is Vat Exempt, VAT cannot be selected from the tax description LOV
                    FROM GIIS_ASSURED a,GIPI_QUOTE b
                    WHERE b.quote_id = p_quote_id
                    AND a.assd_no = b.assd_no)
                    LOOP
                         IF(j.vat_tag = '1') THEN
                            v_vat_tag := j.vat_tag;
                         END IF;
                    END LOOP;
        
        FOR i IN (SELECT a.tax_cd, a.line_cd, a.iss_cd, a.tax_desc, 
                         a.rate, a.peril_sw, a.tax_id, a.allocation_tag, 
                         a.primary_sw
                  FROM GIIS_TAX_CHARGES a
                  WHERE iss_cd = p_iss_cd 
                  AND line_cd =  p_line_cd
                  AND a.eff_start_date <= (SELECT NVL(incept_date, SYSDATE) 
                                           FROM GIPI_QUOTE
                                           WHERE quote_id = p_quote_id) 
                  AND UPPER(a.tax_desc) LIKE (UPPER(NVL(p_find_text, '%%')))                                           
                  ORDER BY tax_desc)
     LOOP
        IF(v_vat_tag = 'X' OR  i.tax_cd != v_tax_cd) THEN --added by steven 11.9.2012 
           v_tax.tax_cd   	    := i.tax_cd;
           v_tax.line_cd   	    := i.line_cd;
           v_tax.iss_cd         := i.iss_cd;
           v_tax.tax_desc  	    := i.tax_desc;
           v_tax.rate    	    := i.rate;
           v_tax.peril_sw  	    := i.peril_sw;
           v_tax.tax_id   	    := i.tax_id;
           v_tax.allocation_tag := i.allocation_tag;
           v_tax.primary_sw  	:= i.primary_sw;
           v_tax.peril_cd  	    := get_tax_peril_cd(i.line_cd, i.iss_cd, i.tax_cd, i.peril_sw);
            PIPE ROW(v_tax);
        END IF;
     END LOOP;
        
        RETURN;
     
     END get_quote_tax_charges_list; 
     
    /*
    **  Created by       : Robert Virrey
    **  Date Created     : 02.24.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : Retrieves tax list of values
    */
    FUNCTION get_tax_list2 (
        p_line_cd   	GIIS_TAX_CHARGES.line_cd%TYPE,
        p_iss_cd    	GIIS_TAX_CHARGES.iss_cd%TYPE,
        p_policy_id  	gipi_polbasic.policy_id%TYPE
    ) 
    RETURN tax_list_tab PIPELINED 
    AS
     v_tax  tax_list_type;
    BEGIN
        FOR i IN (SELECT a230.tax_cd tax_cd ,a230.line_cd line_cd ,a230.iss_cd iss_cd ,
                         a230.tax_desc tax_desc ,a230.rate rate ,a230.peril_sw peril_sw ,
                         a230.tax_id tax_id ,a230.allocation_tag tax_allocation,
                         a230.primary_sw, a230.no_rate_tag --added by joanne 01.18.14
                    FROM giis_tax_charges a230 
                   WHERE a230.line_cd = p_line_cd 
                     AND a230.iss_cd = p_iss_cd 
                     AND a230.pol_endt_sw IN ('B','P')  
                     AND NVL(a230.expired_sw,'N') = 'N'
                     AND a230.eff_start_date <= (SELECT NVL(endt_expiry_date,expiry_date)
                                                   FROM gipi_polbasic
                                                  WHERE policy_id = p_policy_id)
                     /*AND a230.eff_end_date >= (SELECT ADD_MONTHS(NVL(endt_expiry_date,expiry_date),12) 
                                                 FROM gipi_polbasic
                                                WHERE policy_id = p_policy_id) comment by joanne 01.1.14, tax should be included regardless of its expiry date*/
                     AND a230.eff_end_date >= (SELECT NVL(endt_expiry_date,expiry_date)
                                                 FROM gipi_polbasic
                                                WHERE policy_id = p_policy_id) --added  by joanne 01.31.14, include tax within policy period only     
                 ORDER BY tax_cd)
       LOOP
          v_tax.tax_cd   		 := i.tax_cd;
          v_tax.line_cd   	     := i.line_cd;
          v_tax.iss_cd   		 := i.iss_cd;
          v_tax.tax_desc  	     := i.tax_desc;
          v_tax.rate    		 := i.rate;
          v_tax.peril_sw  	     := i.peril_sw;
          v_tax.tax_id   		 := i.tax_id;
          v_tax.allocation_tag   := i.tax_allocation;
          v_tax.primary_sw       := i.primary_sw;      
          v_tax.no_rate_tag      := i.no_rate_tag;  
          PIPE ROW(v_tax);
       END LOOP;
       RETURN;
     END get_tax_list2;
  
    FUNCTION get_tax_charges_lov (
        p_line_cd           GIIS_TAX_CHARGES.line_cd%TYPE,
        p_iss_cd            GIIS_TAX_CHARGES.iss_cd%TYPE,
        p_quote_id          GIPI_QUOTE.quote_id%TYPE,
        p_prem_amt          GIPI_QUOTE_ITMPERIL.prem_amt%TYPE,
        p_currency_rate     GIPI_QUOTE_ITEM.currency_rate%TYPE,
        /*p_tax_cd_list       VARCHAR2,
        p_tax_cd_count      NUMBER, remove by steven 12/06/2012*/
        p_keyword           VARCHAR2
    ) 
    RETURN tax_list_tab2 PIPELINED IS
        v_tax               tax_list_type2;
        v_prem_amt          GIPI_QUOTE_ITMPERIL.prem_amt%TYPE;
        v_tax_amount        GIIS_TAX_CHARGES.tax_amount%TYPE;
        v_temp_tax          GIPI_QUOTE_INVTAX.tax_amt%TYPE; -- marco - 08.31.2012
        v_incept_date       GIPI_QUOTE.incept_date%TYPE;
        v_expiry_date       GIPI_QUOTE.expiry_date%TYPE;
        v_assd_no           GIPI_QUOTE.assd_no%TYPE;
        v_vat_tag           GIIS_ASSURED.vat_tag%TYPE;        
    BEGIN
        BEGIN
            SELECT incept_date, expiry_date, assd_no
              INTO v_incept_date, v_expiry_date, v_assd_no
              FROM GIPI_QUOTE
             WHERE quote_id = p_quote_id;
        END;
        
        BEGIN
            SELECT vat_tag
              INTO v_vat_tag
              FROM GIIS_ASSURED
             WHERE assd_no = v_assd_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_vat_tag := 0;
        END;
    
        FOR i IN(SELECT tax_cd, tax_desc, rate, tax_id, line_cd, iss_cd, peril_sw, allocation_tag, primary_sw, no_rate_tag, tax_type, tax_amount
                   FROM GIIS_TAX_CHARGES
                  WHERE line_cd = p_line_cd
                    AND iss_cd = p_iss_cd
                    AND TRUNC(eff_start_date) <= TRUNC(v_incept_date)
                    AND TRUNC(eff_end_date) >= TRUNC(v_expiry_date) -- marco - 09.21.2012
                    AND 'Y' = DECODE(tax_cd, /*GIISP.n('EVAT')*/ GIACP.n('EVAT'), DECODE(v_vat_tag, 1, 'N', 'Y'), 'Y') -- marco - 09.21.2012
                    /*AND tax_cd NOT IN(SELECT *
                                        FROM TABLE(GIIS_TAX_CHARGES_PKG.get_tax_cd_list(p_tax_cd_list, p_tax_cd_count))) remove by steven 12/06/2012 added the NOT IN in the ibatis*/
                    AND UPPER(tax_desc) LIKE UPPER(NVL(p_keyword, tax_desc))
                  ORDER BY tax_cd)
        LOOP
            IF i.peril_sw = 'Y' THEN
                FOR v IN(SELECT peril_cd
                           FROM GIIS_TAX_PERIL
                          WHERE iss_cd = i.iss_cd
                            AND line_cd = i.line_cd
                            AND tax_cd = i.tax_cd)
                LOOP
                    FOR m IN(SELECT prem_amt
                               FROM GIPI_QUOTE_ITMPERIL
                              WHERE quote_id = p_quote_id
                                AND peril_cd = v.peril_cd)
                    LOOP
                        v_prem_amt := v_prem_amt + m.prem_amt;
                    END LOOP;
                END LOOP;
                v_tax.tax_amt := v_prem_amt * (i.rate / 100);
            ELSE
                --v_tax.tax_amt := p_prem_amt * (i.rate / 100);
                
                -- marco - 08.31.2012 - modified to include tax enhancement
                IF i.tax_type = 'A' THEN
                    v_tax.tax_amt := ROUND(i.tax_amount / NVL(p_currency_rate, 1), 2);          
                ELSIF i.tax_type = 'N' THEN
                    BEGIN
                        SELECT tax_amount  
                          INTO v_temp_tax
                          FROM GIIS_TAX_RANGE
                         WHERE iss_cd = p_iss_cd
                           AND line_cd = p_line_cd
                           AND tax_cd = i.tax_cd
                           AND tax_id = i.tax_id
                           AND p_prem_amt * NVL(p_currency_rate, 1) BETWEEN min_value and max_value;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            v_temp_tax := 0;
                    END;
                    v_tax.tax_amt := ROUND(v_temp_tax / NVL(p_currency_rate, 1), 2);
                    
                    v_tax.tax_amt := ROUND(v_tax.tax_amt / NVL(p_currency_rate, 1), 2);          
                ELSE
                    v_tax.tax_amt := p_prem_amt * (i.rate / 100);
                END IF;
                -- end of tax enhancement
            END IF;
        
            v_tax.tax_amt := NVL(v_tax.tax_amt, 0);
            v_tax.tax_cd   := i.tax_cd;
            v_tax.line_cd   := i.line_cd;
            v_tax.iss_cd   := i.iss_cd;
            v_tax.tax_desc   := i.tax_desc;
            v_tax.rate    := NVL(i.rate, 0);
            v_tax.peril_sw   := i.peril_sw;
            v_tax.tax_id   := i.tax_id;
            v_tax.allocation_tag := i.allocation_tag;
            v_tax.primary_sw  := i.primary_sw;
            v_tax.no_rate_tag := i.no_rate_tag;
            PIPE ROW(v_tax);
        END LOOP;
        RETURN;
    END get_tax_charges_lov;
  
    FUNCTION get_tax_cd_list(
        p_tax_cd_list       VARCHAR2,
        p_tax_cd_count      NUMBER
    )
    RETURN tax_cd_tab PIPELINED AS
        v_tax           tax_cd_type;
    BEGIN
        FOR i IN 1..p_tax_cd_count
        LOOP
            v_tax.tax_cd := SUBSTR(p_tax_cd_list, INSTR(p_tax_cd_list, ',', 1, i)+1, (INSTR(p_tax_cd_list, ',', 1, i+1) - INSTR(p_tax_cd_list, ',', 1, i))-1);
            PIPE ROW(v_tax);
        END LOOP;
    END;

   /*Added by Gzelle 10282014*/
   FUNCTION get_giis_tax_charges (
      p_line_cd   giis_tax_charges.line_cd%TYPE,
      p_iss_cd    giis_tax_charges.iss_cd%TYPE
   )
      RETURN tax_list_tab3 PIPELINED
   IS
      v_tax   tax_list_type3;
   BEGIN
      FOR i IN
         (SELECT b.tax_id, b.tax_cd, b.tax_desc, b.no_rate_tag, b.tax_type
            FROM giis_tax_charges b
           WHERE b.iss_cd = p_iss_cd
             AND b.line_cd = p_line_cd)
      LOOP
         v_tax.tax_id       := i.tax_id;
         v_tax.tax_cd       := i.tax_cd;
         v_tax.tax_desc     := i.tax_desc;
         v_tax.tax_type     := i.tax_type;
         v_tax.no_rate_tag  := i.no_rate_tag;
         PIPE ROW (v_tax);
      END LOOP;

      RETURN;
   END get_giis_tax_charges;    

END Giis_Tax_Charges_Pkg;
/


