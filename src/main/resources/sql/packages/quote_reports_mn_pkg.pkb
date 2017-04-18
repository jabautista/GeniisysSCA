CREATE OR REPLACE PACKAGE BODY CPI.QUOTE_REPORTS_MN_PKG AS
/******************************************************************************
   NAME:       QUOTE_REPORTS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        5/20/2010             1. Created this package.
******************************************************************************/

  FUNCTION get_quote_details_mn_flt(p_quote_id NUMBER)
    RETURN mn_quote_details_tab PIPELINED IS
    
    v_mn_quote_detail mn_quote_details_type;
        
  BEGIN
    FOR A IN (SELECT DISTINCT A.assd_name assd_name, A.address1, A.address2, A.address3,
                       TO_CHAR(A.incept_date, 'fmMonth DD, YYYY') incept_date,
                       TO_CHAR(A.expiry_date, 'fmMonth DD, YYYY') expiry_date,
                                  A.HEADER, A.footer, A.user_id, A.line_cd, A.subline_cd
                 FROM gipi_quote A
                WHERE quote_id = p_quote_id)
    LOOP
      v_mn_quote_detail.assd_name            := A.assd_name;
      v_mn_quote_detail.assd_add1            := A.address1;
      v_mn_quote_detail.assd_add2            := A.address2;
      v_mn_quote_detail.assd_add3            := A.address3;
      v_mn_quote_detail.incept                := A.incept_date;
      v_mn_quote_detail.expiry                := A.expiry_date;
      v_mn_quote_detail.HEADER                := A.HEADER; 
      v_mn_quote_detail.footer                := A.footer;
      v_mn_quote_detail.user_id                := A.user_id;
      v_mn_quote_detail.line_cd                := A.line_cd;
      v_mn_quote_detail.subline_cd            := A.subline_cd;
    END LOOP;
       
     FOR c IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||quotation_no||'-'||proposal_no quote_no
                     FROM gipi_quote
                  WHERE quote_id = p_quote_id)
    LOOP
      v_mn_quote_detail.quote_no := c.quote_no;
    END LOOP;                      
    
    -- period of insurance
    SELECT NVL(to_char(incept_date,'Month dd, yyyy')||'   to   '||to_char(expiry_date,'Month dd, yyyy'), '') period
      INTO v_mn_quote_detail.period
        FROM gipi_quote
     WHERE quote_id = p_quote_id;
    
    
    --v_mn_quote_detail.contact            := :cg$ctrl.dsp_contact_no;
    v_mn_quote_detail.title              := 'Attention';
    v_mn_quote_detail.title1             := 'Proposed Item Insured';
    v_mn_quote_detail.title5             := 'From :';
    v_mn_quote_detail.title6             := 'To :';
    v_mn_quote_detail.title7             := 'Period of Insurance';
    v_mn_quote_detail.title8             := 'Perils Insured';
    v_mn_quote_detail.title9             := 'Deductible/s';
    v_mn_quote_detail.title10             := 'Insuring Condition/s';  
    v_mn_quote_detail.title11             := 'PHP';    
    --v_mn_quote_detail.attn_name         := :CG$CTRL.dsp_attention;
    --v_mn_quote_detail.position             := :CG$CTRL.dsp_position;
    --v_mn_quote_detail.user                 := :CG$CTRL.CGU$USER;
    v_mn_quote_detail.end_remarks         := 'Very truly yours,';
     --v_mn_quote_detail.signatory           := :CG$CTRL.dsp_signatory;
     --v_mn_quote_detail.designation         := :CG$CTRL.dsp_designation;
    
    --logo_name
      BEGIN
        SELECT param_value_v
          INTO v_mn_quote_detail.logo_file
          FROM giis_parameters  
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;

    PIPE ROW(v_mn_quote_detail);
    RETURN;
    
  END get_quote_details_mn_flt;
  
  -- compute total premium due
  FUNCTION compute_total_prem_due(p_quote_id NUMBER, p_line_cd VARCHAR2) 
    RETURN NUMBER IS
    
    v_total_prem_due NUMBER := 0;
    
  BEGIN
  
         FOR i IN (SELECT prem_amt * currency_rate prem_amt
                   FROM gipi_quote_item
                  WHERE quote_id = p_quote_id)
       LOOP
         v_total_prem_due := v_total_prem_due + i.prem_amt;
       END LOOP;
    
       FOR i IN (SELECT b.tax_cd, E.tax_desc, SUM(DISTINCT b.tax_amt) tax_amt
                   FROM gipi_quote_invoice A,
                        gipi_quote_invtax b,
                        gipi_quote_item c,
                        gipi_quote d,
                        giis_tax_charges E
                  WHERE c.currency_cd = A.currency_cd
                    AND d.quote_id = p_quote_id
                    AND A.quote_inv_no = b.quote_inv_no
                    AND A.quote_id = c.quote_id
                    AND A.quote_id = d.quote_id
                    AND b.iss_cd = A.iss_cd
                    AND b.iss_cd = E.iss_cd
                    AND b.line_cd = E.line_cd
                    AND b.tax_cd = E.tax_cd
                    AND E.line_cd = p_line_cd
               GROUP BY b.tax_cd, E.tax_desc)
       LOOP
          v_total_prem_due := v_total_prem_due + i.tax_amt;
       END LOOP;
         
         RETURN v_total_prem_due;
  END compute_total_prem_due;
  
  FUNCTION get_deductibles_mn_flt(p_quote_id NUMBER, p_line_cd VARCHAR2, p_subline_cd VARCHAR2) 
    RETURN mn_deductible_tab PIPELINED IS
    
    deductible mn_deductible_type; 
    
  BEGIN
         FOR i IN (SELECT b.deductible_title ded_title,
                           A.deductible_text,
                        LTRIM(TO_CHAR(A.deductible_rt,'999,999,999,999.99'),' ') ded_rate,
                        LTRIM(TO_CHAR(A.deductible_amt,'999,999,999,999.99'),' ') ded_amt
                     FROM gipi_quote_deductibles A, 
                          giis_deductible_desc b,
                          gipi_quote_item c
                   WHERE A.ded_deductible_cd = b.deductible_cd
                       AND A.quote_id = p_quote_id
                       AND b.line_cd = p_line_cd
                       AND b.subline_cd = p_subline_cd
                       AND A.item_no = c.item_no
                       AND A.quote_id = c.quote_id)
                    
        LOOP
        
          IF i.deductible_text IS NULL THEN
             deductible.text := ' ';
           ELSE
              deductible.text := ' - '||i.deductible_text;
           END IF;
          
          IF i.ded_rate IS NULL THEN
             deductible.deduct := i.ded_amt;
           ELSE
             deductible.deduct := (i.ded_rate||'%');
           END IF;
        
          deductible.title       := '('||i.ded_title||')';
          
          PIPE ROW(deductible);
        END LOOP;
        
        RETURN;
  END;
  
  /* FGIC */
  FUNCTION get_quote_details_mn_fgic(p_quote_id NUMBER) RETURN mn_quote_details_tab PIPELINED IS
  
    v_mn_quote_detail mn_quote_details_type;
  
  BEGIN
  
    FOR A IN (SELECT DISTINCT A.assd_name assd_name, A.address1, A.address2, A.address3,
                       TO_CHAR(A.incept_date, 'fmMonth DD, YYYY') incept_date,
                       TO_CHAR(A.expiry_date, 'fmMonth DD, YYYY') expiry_date,
                       A.HEADER, A.footer, A.user_id, A.line_cd, A.subline_cd
                FROM gipi_quote A
               WHERE quote_id = p_quote_id)
    LOOP
      v_mn_quote_detail.assd_name            := A.assd_name;
      v_mn_quote_detail.assd_add1            := A.address1;
      v_mn_quote_detail.assd_add2            := A.address2;
      v_mn_quote_detail.assd_add3            := A.address3;
      v_mn_quote_detail.incept                := A.incept_date;
      v_mn_quote_detail.expiry                := A.expiry_date;
      v_mn_quote_detail.HEADER                := A.HEADER;
      v_mn_quote_detail.footer                := A.footer;
      v_mn_quote_detail.user_id                := A.user_id;
      v_mn_quote_detail.line_cd                := A.line_cd;
      v_mn_quote_detail.subline_cd            := A.subline_cd;
    END LOOP;
    
    FOR c IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||quotation_no||'-'||proposal_no quote_no
                     FROM gipi_quote
                  WHERE quote_id = p_quote_id)
    LOOP
      v_mn_quote_detail.quote_no := c.quote_no;
    END LOOP;
    
    v_mn_quote_detail.title              := 'Attention';
    v_mn_quote_detail.title1             := 'Interest Insured';
    v_mn_quote_detail.title2             := 'Limit of Liability';
    v_mn_quote_detail.title3             := 'Vessel / Conveyance';
    v_mn_quote_detail.title4             := 'Voyage';
    v_mn_quote_detail.title5             := 'From :';
    v_mn_quote_detail.title6             := 'To :';
    v_mn_quote_detail.title7             := 'ETD / ETA';
    v_mn_quote_detail.title8             := 'Coverage';
    v_mn_quote_detail.title9             := 'Deductible';
    v_mn_quote_detail.title10            := 'Insuring Condition';  
    v_mn_quote_detail.title11            := 'PHP';
    v_mn_quote_detail.end_remarks        := 'Very truly yours,';
    
    --logo_name
      BEGIN
        SELECT param_value_v
          INTO v_mn_quote_detail.logo_file
          FROM giis_parameters  
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
    
    PIPE ROW(v_mn_quote_detail);
    RETURN;
  END;
  /* end of FGIC */
  
  
  /* CIC */
  FUNCTION get_quote_details_mn_cic(p_quote_id NUMBER) RETURN mn_quote_details_tab PIPELINED IS
  
    v_mn_quote_detail mn_quote_details_type;
      
  BEGIN
  
    FOR A IN (SELECT DISTINCT A.assd_name assd_name, A.address1, A.address2, A.address3,
                      A.HEADER, A.footer, A.user_id, A.line_cd, A.subline_cd
                 FROM gipi_quote A
                WHERE quote_id = p_quote_id)
    LOOP
      v_mn_quote_detail.assd_name            := A.assd_name;
      v_mn_quote_detail.assd_add1            := A.address1;
      v_mn_quote_detail.assd_add2            := A.address2;
       v_mn_quote_detail.assd_add3            := A.address3;
       v_mn_quote_detail.HEADER                := A.HEADER;
       v_mn_quote_detail.footer                := A.footer;
      v_mn_quote_detail.user_id                := A.user_id;
      v_mn_quote_detail.line_cd                := A.line_cd;
      v_mn_quote_detail.subline_cd            := A.subline_cd;
    END LOOP;
       
     FOR c IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||quotation_no||'-'||proposal_no quote_no
                    FROM gipi_quote
                  WHERE quote_id = p_quote_id)
    LOOP
      v_mn_quote_detail.quote_no := c.quote_no;
    END LOOP;
  
      v_mn_quote_detail.title              := 'Attention';
    v_mn_quote_detail.title1             := 'Interest Insured';
    v_mn_quote_detail.title2             := 'Limit of Liability';
    v_mn_quote_detail.title3             := 'Vessel / Conveyance';
    v_mn_quote_detail.title4             := 'Voyage';
    v_mn_quote_detail.title5            := 'From';
    v_mn_quote_detail.title6            := 'To';
    v_mn_quote_detail.title7             := 'ETD / ETA';
    v_mn_quote_detail.title8            := 'Peril';
    v_mn_quote_detail.title9            := 'Deductible';
    v_mn_quote_detail.title10             := 'Warranties and Clauses';
    v_mn_quote_detail.title11             := '$';
    v_mn_quote_detail.end_remarks         := 'Sincerely Yours,';
    
    --logo_name
      BEGIN
        SELECT param_value_v
          INTO v_mn_quote_detail.logo_file
          FROM giis_parameters  
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
  
    PIPE ROW(v_mn_quote_detail);
    RETURN;
    
  END;
  /* end of CIC */  

  /* SEICI */
  FUNCTION get_quote_details_mn_seici(p_quote_id NUMBER) RETURN mn_quote_details_tab PIPELINED IS
  
    v_mn_quote_detail mn_quote_details_type;
  
  BEGIN
    
    FOR c IN (SELECT A.line_cd||'-'||A.subline_cd||'-'||A.iss_cd||'-'||A.quotation_yy||'-'||A.quotation_no||'-'||A.proposal_no quote_no, 
                     A.assd_name, A.HEADER, A.footer, to_char(A.accept_dt, 'fmDD Month YYYY') accept_date, 
                     A.remarks, A.line_cd, A.subline_cd, A.address1, A.address2, A.address3, A.user_id, b.subline_name
                     FROM gipi_quote A,
                     giis_subline b
                  WHERE A.quote_id = p_quote_id
                 AND A.subline_cd = b.subline_cd)
    LOOP
      v_mn_quote_detail.quote_no              := c.quote_no;
      v_mn_quote_detail.assd_name             := c.assd_name;
      v_mn_quote_detail.HEADER                 := c.HEADER;
      v_mn_quote_detail.footer                   := c.footer;
      v_mn_quote_detail.accept_dt             := c.accept_date;     
      v_mn_quote_detail.remarks                := c.remarks;      
      v_mn_quote_detail.line_cd              := c.line_cd;
      v_mn_quote_detail.subline_cd            := c.subline_cd;
      v_mn_quote_detail.subline_name        := c.subline_name || ' INSURANCE QUOTATION';
      v_mn_quote_detail.user_id                  := c.user_id;
    END LOOP;
    
    --logo_name
      BEGIN
        SELECT param_value_v
          INTO v_mn_quote_detail.logo_file
          FROM giis_parameters  
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
    
    PIPE ROW(v_mn_quote_detail);
    RETURN;
    
  END;
  /* end of SEICI */
  
  /* UAC*/
  FUNCTION get_quote_details_mn_uac(p_quote_id NUMBER) RETURN mn_quote_details_tab PIPELINED IS
  
    v_mn_quote_detail mn_quote_details_type; 
  
  BEGIN
  
    FOR A IN (SELECT DISTINCT A.assd_name assd_name, A.address1, A.address2, A.address3,
                      TO_CHAR(A.incept_date, 'fmMonth DD, YYYY') incept_date,
                      TO_CHAR(A.expiry_date, 'fmMonth DD, YYYY') expiry_date,
                      A.HEADER, A.footer,
                      A.remarks, A.user_id, A.line_cd, A.subline_cd
                 FROM gipi_quote A
                WHERE quote_id = p_quote_id)
    LOOP
      v_mn_quote_detail.assd_name            := A.assd_name;
      v_mn_quote_detail.assd_add1            := A.address1;
      v_mn_quote_detail.assd_add2            := A.address2;
      v_mn_quote_detail.assd_add3            := A.address3;
      v_mn_quote_detail.incept                := A.incept_date;
      v_mn_quote_detail.expiry                := A.expiry_date;
      v_mn_quote_detail.HEADER                := A.HEADER;
      v_mn_quote_detail.footer                := A.footer;
      v_mn_quote_detail.remarks               := A.remarks;
      v_mn_quote_detail.user_id                := A.user_id;
      v_mn_quote_detail.line_cd                := A.line_cd;
      v_mn_quote_detail.subline_cd            := A.subline_cd;
    END LOOP;
    
    FOR c IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||quotation_no||'-'||proposal_no quote_no
                    FROM gipi_quote
                  WHERE quote_id = p_quote_id)
    LOOP
      v_mn_quote_detail.quote_no := c.quote_no;
    END LOOP;
  
    v_mn_quote_detail.title              := 'Attention';
    v_mn_quote_detail.title1             := 'Interest Insured';
    v_mn_quote_detail.title2             := 'Limit of Liability';
    v_mn_quote_detail.title3             := 'Vessel / Conveyance';
    v_mn_quote_detail.title4             := 'Voyage';
    v_mn_quote_detail.title5             := 'From :';
    v_mn_quote_detail.title6             := 'To :';
    v_mn_quote_detail.title7             := 'ETD / ETA';
    v_mn_quote_detail.title8             := 'Coverage';
    v_mn_quote_detail.title9             := 'Deductible';
    v_mn_quote_detail.title10             := 'Insuring Condition';  
    v_mn_quote_detail.title11             := 'PHP';
    v_mn_quote_detail.end_remarks         := 'Very truly yours,';
    
    --logo_name
      BEGIN
        SELECT param_value_v
          INTO v_mn_quote_detail.logo_file
          FROM giis_parameters  
         WHERE param_name = 'LOGO_FILE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
  
    PIPE ROW(v_mn_quote_detail);
    RETURN;
   
  END;
  /* end of UAC */


/*****************ADDED*BY*WINDELL***********05*09*2011**************MARINECARGOQUOTE***********/     
/*   Added by    : Windell Valle
**   Date Created: May 09, 2011
**   Last Revised: May 09, 2011
**   Description : Populate Marine Cargo Quotation
**   Client(s)   : UCPB,...
*/
  
 FUNCTION get_quote_details_mn_ucpb(p_quote_id NUMBER)
    RETURN mn_quote_details_tab PIPELINED IS
    
    v_mn_quote_detail mn_quote_details_type;
    v_count      NUMBER := 0;
        
  BEGIN
    FOR A IN (SELECT
                     line_cd||'-'||subline_cd||'-'||iss_cd||'-'||quotation_yy||'-'||quotation_no||'-'||proposal_no quote_no, 
                     assd_name,
                     HEADER,
                     footer,
                     to_char(accept_dt, 'fmMonth DD, YYYY') accept_date,
                     remarks,
                     iss_cd,
                     line_cd,
                     subline_cd,                     
                     address1, address2, address3,
                     decode(address3,NULL,decode(address2,NULL,address1,address1||chr(10)||Address2),
                                        decode(address2,NULL,address1,address1||chr(10)||Address2)||chr(10)||address3) address,
                     TO_CHAR(incept_date, 'fmMonth DD, YYYY') incept_date,
                     TO_CHAR(expiry_date, 'fmMonth DD, YYYY') expiry_date,
                     to_char(to_date(substr(trunc(to_char(valid_date - sysdate)), length(trunc(to_char(valid_date - sysdate)))-2, 3), 'j'), 'jsp')||' ('||trunc(to_char(valid_date - sysdate))||')' valid_days,
                     user_id
                     FROM gipi_quote 
               WHERE quote_id = p_quote_id)     
               
    LOOP
      v_mn_quote_detail.quote_no             := A.quote_no;
      v_mn_quote_detail.assd_name            := A.assd_name;
      v_mn_quote_detail.assd_add             := A.address;
      v_mn_quote_detail.assd_add1            := A.address1;
      v_mn_quote_detail.assd_add2            := A.address2;
      v_mn_quote_detail.assd_add3            := A.address3;
      v_mn_quote_detail.accept_dt            := A.accept_date;
      v_mn_quote_detail.incept               := A.incept_date;
      v_mn_quote_detail.expiry               := A.expiry_date;
      v_mn_quote_detail.HEADER               := A.HEADER; 
      v_mn_quote_detail.footer               := A.footer;
      v_mn_quote_detail.user_id              := A.user_id;
      v_mn_quote_detail.iss_cd               := A.iss_cd;
      v_mn_quote_detail.line_cd              := A.line_cd;
      v_mn_quote_detail.subline_cd           := A.subline_cd; 
      v_mn_quote_detail.remarks              := A.remarks; 
      v_mn_quote_detail.valid_days           := A.valid_days;
            
    --* subline name
    BEGIN
       SELECT subline_name
         INTO v_mn_quote_detail.subline_name
         FROM giis_subline
        WHERE line_cd = A.line_cd
          AND subline_cd = A.subline_cd;
    END;
    --* subline name  

    END LOOP;      
    
    BEGIN
             
      FOR A IN (SELECT COUNT(DISTINCT item_no) cnt
                  FROM gipi_quote_item
                 WHERE quote_id = p_quote_id) 
      LOOP
        v_count := A.cnt;
      END LOOP;
      FOR X IN (SELECT vessel_name
                     FROM gipi_quote_cargo A,
                       giis_vessel b
                 WHERE A.vessel_cd = b.vessel_cd
                   AND A.quote_id = p_quote_id)
       LOOP
         IF v_count > 1 THEN
            v_mn_quote_detail.vessel_name := 'Various';
         ELSE   
            v_mn_quote_detail.vessel_name := x.vessel_name;
         END IF;             
       END LOOP;             
    END;
  
    BEGIN
      SELECT param_value_v
        INTO v_mn_quote_detail.logo_file
        FROM giis_parameters  
       WHERE param_name = 'LOGO_FILE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
    END;
      
      
    PIPE ROW(v_mn_quote_detail);
    RETURN;
       
  END get_quote_details_mn_ucpb; 
  
  
  FUNCTION get_items_mn_ucpb(p_quote_id NUMBER)
     RETURN mn_items_tab PIPELINED IS
     
     v_mn_items   mn_items_type;
     v_count      NUMBER := 0;      
  BEGIN
    FOR A IN (SELECT COUNT(DISTINCT item_no) cnt
                FROM gipi_quote_item
               WHERE quote_id = p_quote_id) 
    LOOP
      v_count := A.cnt;
    END LOOP;
    FOR i IN ( SELECT DISTINCT item_title, nvl(item_desc,' ') item_desc
                 FROM gipi_quote_item
                WHERE quote_id = p_quote_id
                ORDER BY item_title ) 
    LOOP
      IF v_count > 1 THEN
         v_mn_items.item_title := 'Various';
      ELSE
         v_mn_items.item_title := i.item_title;
      END IF;   
      v_mn_items.item_desc := i.item_desc;
      
      PIPE ROW(v_mn_items);  
    END LOOP;  
         
    RETURN;
    
  END get_items_mn_ucpb;
  
  
  FUNCTION get_curr_mn(p_quote_id NUMBER) --* Get currency short name
    RETURN mn_curr_tab PIPELINED IS
    
    v_mn_curr   mn_curr_type;
    
   BEGIN
     FOR c IN (SELECT DISTINCT 
                      b.short_name
                 FROM gipi_quote_item A, giis_currency b
                WHERE 1=1
                  AND A.currency_cd = b.main_currency_cd
                  AND A.quote_id = p_quote_id
              )
     LOOP
       v_mn_curr.currency_name := c.short_name;   
     
     END LOOP; 
     
    PIPE ROW(v_mn_curr);
    RETURN; 
              
   END;   
  
    
   FUNCTION get_signatory_mn(p_quote_id NUMBER, p_iss_cd VARCHAR2)
  RETURN marine_signatory_tab PIPELINED IS
      v_sig    marine_signatory_type;
      v_line   gipi_quote.line_cd%TYPE;
  BEGIN
    FOR A IN (SELECT line_cd
                FROM gipi_quote
               WHERE quote_id = p_quote_id)
    LOOP             
      v_line := A.line_cd;
    END LOOP; 
     FOR sig IN (SELECT SIGNATORY,DESIGNATION, b.remarks, current_signatory_sw
                           FROM GIIS_SIGNATORY A,GIIS_SIGNATORY_NAMES B
                     WHERE NVL(A.REPORT_ID,'MN_QUOTE') = 'MN_QUOTE'
                       AND nvl(A.iss_cd,p_iss_cd) = p_iss_cd --
                       AND nvl(A.line_cd, v_line)= v_line
                       AND current_signatory_sw = 'Y'     
                       AND A.signatory_id = b.signatory_id )
      LOOP
          v_sig.sig_name     := sig.signatory;
          v_sig.sig_des      := sig.designation; 
          v_sig.sig_remarks  := sig.remarks; 
          v_sig.sig_sw       := sig.current_signatory_sw;   
      END LOOP; 
    PIPE ROW(v_sig);
    RETURN;    
  END;
  
    
  FUNCTION get_geo_lim_mn_ucpb(p_quote_id NUMBER)
    RETURN mn_geo_lim_tab PIPELINED IS
    
    v_mn_geo_lim   mn_geo_lim_type;
    v_count      NUMBER := 0;      
  BEGIN
    FOR A IN (SELECT COUNT(DISTINCT item_no) cnt
                FROM gipi_quote_item
               WHERE quote_id = p_quote_id) 
    LOOP
      v_count := A.cnt;
    END LOOP;
    
    FOR T IN ( SELECT geog_desc
                 FROM gipi_quote_cargo A,
                      giis_geog_class b
                WHERE A.geog_cd (+)= b.geog_cd
                  AND quote_id = p_quote_id)
     LOOP
       IF v_count > 1 THEN
          v_mn_geo_lim.geog_limit := 'VARIOUS';
       ELSE
          v_mn_geo_lim.geog_limit := T.geog_desc;
       END IF;     
       PIPE ROW(v_mn_geo_lim);
     END LOOP; 
     
    
    RETURN; 
              
   END; 
  
 
FUNCTION get_tsi_mn_ucpb(p_quote_id NUMBER)
    RETURN mn_tsi_tab PIPELINED IS
    
    v_mn_tsi   mn_tsi_type;
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
						v_short_name_temp := 'PHP';
						v_the_same := 'N';
						EXIT;
					END IF;
				END IF;
		 END LOOP;
	  
     FOR T IN (SELECT SUM(tsi_amt) tsi_amt,A.currency_rate
                 FROM gipi_quote_item A
                WHERE quote_id = p_quote_id
				GROUP BY A.currency_rate
                   
              )
     LOOP
	 	IF v_the_same = 'N' THEN
			v_tsi_amt := v_tsi_amt + (T.tsi_amt * T.currency_rate);
		ELSE
			v_tsi_amt := v_tsi_amt + T.tsi_amt;
		END IF;
     END LOOP; 
	 v_mn_tsi.short_name  := v_short_name_temp; --added by steven 1.24.2013
	 v_mn_tsi.tsi_amt_chr := LTRIM(TO_CHAR(v_tsi_amt, '9,999,999,999,999,999.99'));
     
    PIPE ROW(v_mn_tsi);
    RETURN; 
              
   END;
  

FUNCTION get_deductible_mn_ucpb(p_quote_id NUMBER, p_line_cd VARCHAR2, p_subline_cd VARCHAR2)
    RETURN mn_deductibles_tab PIPELINED IS
    
    v_mn_deductible   mn_deductibles_type;
    
   BEGIN   
     FOR pd IN (   SELECT DISTINCT                         
                        decode(c.deductible_text, NULL , NULL, deductible_text) deductible_text
                   FROM gipi_quote_itmperil A, giis_peril b, gipi_quote_deductibles c
                  WHERE A.peril_cd = b.peril_cd (+)
                    AND A.peril_cd = c.peril_cd (+)
                    AND A.item_no  = c.item_no  (+)
                    AND A.quote_id = c.quote_id (+)
                    AND (b.subline_cd = p_subline_cd OR b.subline_cd IS NULL)
                    AND b.line_cd = p_line_cd
                    AND A.quote_id = p_quote_id 
                    AND deductible_text IS NOT NULL                                      
               ORDER BY deductible_text
              )
     LOOP        
        
        v_mn_deductible.deductible_text := pd.deductible_text;        
      
        PIPE ROW(v_mn_deductible);   
     END LOOP;      
    
    RETURN;  
          
   END;


  FUNCTION get_peril_mn_ucpb(p_quote_id NUMBER)
    RETURN mn_peril_tab PIPELINED IS
    
    v_mn_peril   mn_peril_type;
    
   BEGIN   
     FOR pr IN ( /*SELECT A.item_no, nvl(peril_lname, peril_name) peril_name, A.prem_rt
                   FROM gipi_quote_itmperil A, giis_peril b
                  WHERE A.peril_cd = b.peril_cd (+)
                    AND A.quote_id = p_quote_id
                  ORDER BY A.item_no*/
                  
                  -- andrew - 02.19.2013 - modified query
                  SELECT A.item_no, b.peril_name, A.prem_rt
                   FROM gipi_quote_itmperil A, giis_peril b
                  WHERE A.peril_cd = b.peril_cd
                    AND b.line_cd = giisp.v('LINE_CODE_MN') 
                    AND A.quote_id = p_quote_id
                  ORDER BY A.item_no
              )
     LOOP        
        v_mn_peril.item_no := pr.item_no;  
        v_mn_peril.peril_rate := pr.prem_rt;        
        v_mn_peril.peril_name := pr.peril_name;    
        
        PIPE ROW(v_mn_peril);   
     END LOOP;      
    
    RETURN;  
          
   END;
  
  
    FUNCTION get_wc_mn_ucpb(p_quote_id NUMBER)
    RETURN mn_wc_tab PIPELINED IS
    
    v_mn_wc   mn_wc_type;
    
   BEGIN
     FOR wc IN (SELECT wc_title
                  FROM gipi_quote_wc
                 WHERE quote_id = p_quote_id
              )
     LOOP
       v_mn_wc.wc_title := wc.wc_title;   
       PIPE ROW(v_mn_wc);
     END LOOP;      
    
    RETURN;  
          
   END; 
/*****************ADDED*BY*WINDELL***********05*09*2011**************MARINECARGOQUOTE***********/  
END QUOTE_REPORTS_MN_PKG;
/


