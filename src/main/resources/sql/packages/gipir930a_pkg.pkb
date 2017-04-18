CREATE OR REPLACE PACKAGE BODY CPI.GIPIR930A_PKG
AS
       
    FUNCTION CF_companyFormula 
        RETURN Char 
    IS
        V_COMPANY_NAME VARCHAR2(150);
        begin
          select param_value_v
            into v_company_name
            from giis_parameters
           where UPPER(param_name) = 'COMPANY_NAME';

    RETURN(V_COMPANY_NAME);

    END;
    
   FUNCTION cf_company_addressformula
      RETURN CHAR
   IS
      v_address   VARCHAR2 (500);
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_address);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         RETURN (v_address);
   END;    
    
    FUNCTION CF_based_onFormula (
        p_scope     NUMBER,
        p_user_id   gipi_uwreports_ri_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
    )
        RETURN Char 
    IS
        v_param_date  number(1);
        v_based_on varchar2(100);
        v_scope number(1);
        v_policy_label varchar2(100);

    BEGIN
        BEGIN
          SELECT param_date
            INTO v_param_date
            FROM gipi_uwreports_ri_ext
           WHERE user_id = p_user_id
             AND rownum = 1;
        /*exception
        when no_data_found or too_many_rows then
        null;*/
        END;
      
       
              
        if v_param_date = 1 then
            v_based_on := 'Based on Issue Date';
        elsif v_param_date = 2 then
            v_based_on := 'Based on Inception Date';
        elsif v_param_date = 3 then
            v_based_on := 'Based on Booking month - year';
        elsif v_param_date = 4 then
            v_based_on := 'Based on Acctg Entry Date';
        end if;
          
        v_scope:= p_scope;
         
        if v_scope = 1 then
            v_policy_label := v_based_on || '/'||'Policies Only';
        elsif v_scope = 2 then
            v_policy_label := v_based_on || '/' ||'Endorsements Only';
        elsif v_scope = 3 then
            v_policy_label := v_based_on || '/' ||'Policies and Endorsements';
        end if;      
        
        RETURN(v_policy_label);  
              
    END;
    
    FUNCTION CF_heading3Formula(
        p_user_id   gipi_uwreports_ri_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
    )
        RETURN Char 
    IS
        v_param_date number(1);
        v_from_date date;
        v_to_date date;
        heading3 varchar2(150);
     BEGIN
          BEGIN
              SELECT distinct param_date, from_date, to_date 
                INTO v_param_date, v_from_date, v_to_date
                FROM gipi_uwreports_RI_ext  
               WHERE user_id = p_user_id;
          --exception
            --    when no_data_found or too_many_rows then
            --    null;
          END;
            
          if v_param_date in (1,2,4) then
            if v_from_date = v_to_date then
                heading3 := 'For '||to_char(v_from_date,'fmMonth dd, yyyy');
            else 
                heading3 := 'For the period of '||to_char(v_from_date,'fmMonth dd, yyyy')||' to '
                                    ||to_char(v_to_date,'fmMonth dd, yyyy');
            end if;
          else
            if v_from_date = v_to_date then
                heading3 := 'For the month of '||to_char(v_from_date,'fmMonth, yyyy');
            else 
                heading3 := 'For the period of '||to_char(v_from_date,'fmMonth, yyyy')||' to '
                                    ||to_char(v_to_date,'fmMonth, yyyy');
            end if;

          end if;
        
        RETURN(heading3);
        
     END;
        
    FUNCTION get_gipir930a_header(
         p_scope         NUMBER,
         p_user_id       gipi_uwreports_ri_ext.user_id%TYPE
    )
        RETURN gipir930a_header_tab PIPELINED
    IS
        v_header_tab        gipir930a_header_type;
    BEGIN
        v_header_tab.company            := GIPIR930A_PKG.CF_companyFormula;
        v_header_tab.company_address    := GIPIR930A_PKG.cf_company_addressformula;  --Halley 01.28.14
        v_header_tab.based_on           := GIPIR930A_PKG.CF_based_onFormula(p_scope, p_user_id);
        v_header_tab.heading3           := GIPIR930A_PKG.CF_heading3Formula(p_user_id);
        
        PIPE ROW(v_header_tab);
                  
    END;    --end of get_gipir930a_header function    
        
    
    --================================================================================================================================
    
    FUNCTION CF_iss_headerFormula (
        p_iss_param gipi_uwreports_ri_ext.CRED_BRANCH%TYPE
    )
        RETURN Char 
    IS
    BEGIN
    
      IF p_iss_param = 1 THEN
         RETURN ('Crediting Branch :');
      ELSIF p_iss_param = 2 THEN
         RETURN ('Issue Source     :');
      ELSE 
         RETURN NULL;
      END IF;
      
    END;
    
    
    FUNCTION CF_iss_nameFormula  (
        p_iss_cd gipi_uwreports_ri_ext.ISS_CD%TYPE
    )
        RETURN Char 
    IS
        v_iss_name giis_issource.iss_name%type;
    BEGIN
        BEGIN
            select INITCAP(iss_name) iss_name
              into v_iss_name
              from giis_issource
             where iss_cd = p_iss_cd;
        EXCEPTION
            WHEN no_data_found or too_many_rows then
            NULL;
        END;
        RETURN(v_iss_name);
    END;
    
    FUNCTION CF_reinsuredFormula(
        p_line_cd       gipi_uwreports_ri_ext.LINE_CD%TYPE,
        p_subline_cd    gipi_uwreports_ri_ext.SUBLINE_CD%TYPE,
        p_iss_cd        gipi_uwreports_ri_ext.ISS_CD%TYPE,
        p_iss_param     gipi_uwreports_ri_ext.CRED_BRANCH%TYPE,
        p_scope         NUMBER,
        p_user_id       gipi_uwreports_ri_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
    ) 
        RETURN Number 
    IS
    v_reinsured  GIPI_UWREPORTS_RI_EXT.sum_reinsured%TYPE:=0;
    BEGIN
        FOR c1 IN (SELECT DISTINCT frps_line_cd, frps_yy, frps_seq_no, ri_cd
                     FROM GIPI_UWREPORTS_RI_EXT
                  WHERE user_id = p_user_id
                                    AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                                     OR  (p_scope=1 AND endt_seq_no=0)
                                     OR  (p_scope=2 AND endt_seq_no>0))                 
                                    AND line_cd = p_line_cd
                                    AND subline_cd = p_subline_cd
                    AND decode(p_iss_param,1,cred_branch,iss_cd) = p_iss_cd)
        LOOP
          FOR c2 IN (SELECT SUM(a.ri_tsi_amt * b.currency_rt) ri_tsi_amt
                       FROM giis_peril c, giri_distfrps b, giri_frperil a
                      WHERE b.line_cd = a.line_cd
                      AND b.frps_yy = a.frps_yy
                      AND b.frps_seq_no = a.frps_seq_no
                                        AND a.line_cd = c.line_cd
                                        AND a.peril_cd = c.peril_cd 
                                        AND c.peril_type = 'B'                   
                      AND a.line_cd = c1.frps_line_cd 
                        AND a.frps_yy = c1.frps_yy 
                        AND a.frps_seq_no = c1.frps_seq_no
                        AND a.ri_cd = c1.ri_cd)
          LOOP
            v_reinsured := v_reinsured + c2.ri_tsi_amt;
          END LOOP;
        END LOOP;      
        RETURN(v_reinsured);
    END;


    PROCEDURE CF_TSI_PREMFormula (
        p_line_cd        gipi_uwreports_ri_ext.LINE_CD%TYPE,
        p_subline_cd     gipi_uwreports_ri_ext.SUBLINE_CD%TYPE,
        p_iss_cd         gipi_uwreports_ri_ext.ISS_CD%TYPE,
        p_iss_param      gipi_uwreports_ri_ext.CRED_BRANCH%TYPE,
        p_scope          NUMBER,
        v_total_si   OUT GIPI_UWREPORTS_RI_EXT.total_si%TYPE,
        v_total_prem OUT GIPI_UWREPORTS_RI_EXT.total_prem%TYPE,
        p_user_id        GIPI_UWREPORTS_RI_EXT.user_id%TYPE -- marco - 02.05.2013 - added parameter
    ) 
    IS
    BEGIN    
        FOR c1 IN (SELECT DISTINCT policy_id, dist_no
                     FROM GIPI_UWREPORTS_RI_EXT
                  WHERE user_id = p_user_id
                                    AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                                     OR  (p_scope=1 AND endt_seq_no=0)
                                     OR  (p_scope=2 AND endt_seq_no>0))                 
                                    AND line_cd = p_line_cd
                                    AND subline_cd = p_subline_cd
                    AND decode(p_iss_param,1,cred_branch,iss_cd) = p_iss_cd)
        LOOP
          FOR c2 IN (SELECT tsi_amt, prem_amt 
                       FROM giuw_pol_dist
                      WHERE dist_no = c1.dist_no)
          LOOP
            v_total_si := NVL(v_total_si,0) + c2.tsi_amt;
            v_total_prem := NVL(v_total_prem,0) + c2.prem_amt;
            EXIT;
          END LOOP;
        END LOOP;      
        
    END;

    FUNCTION CF_vat_titleFormula 
        RETURN Char 
    IS
      var1 varchar2(20);
    BEGIN
      select giisp.v('VAT_TITLE')
        into var1
        from dual;
      
      return (var1);
    END;
    

    FUNCTION populate_gipir930a_report (
        p_iss_cd        gipi_uwreports_ri_ext.ISS_CD%TYPE,
        p_line_cd       gipi_uwreports_ri_ext.LINE_CD%TYPE,
        p_subline_cd    gipi_uwreports_ri_ext.SUBLINE_CD%TYPE,
        p_iss_param     gipi_uwreports_ri_ext.CRED_BRANCH%TYPE,
        p_scope         NUMBER,
        p_user_id       gipi_uwreports_ri_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
    ) 
        RETURN gipir930a_report_tab PIPELINED
    IS
        v_rep_tab             gipir930a_report_type;    
    
       
        v_iss_name            giis_issource.iss_name%TYPE;
        v_total_si            gipi_uwreports_ri_ext.TOTAL_SI%TYPE;
        v_total_prem          gipi_uwreports_ri_ext.TOTAL_PREM%TYPE;
        v_reinsured           gipi_uwreports_ri_ext.SUM_REINSURED%TYPE := 0;
    BEGIN
        /*======== iss_header ========*/
        v_rep_tab.iss_header := GIPIR930A_PKG.CF_ISS_HEADERFORMULA(p_iss_param);        
        v_rep_tab.vat_title  := GIPIR930A_PKG.CF_VAT_TITLEFORMULA;
        
--        FOR rep IN (SELECT line_cd, subline_cd, DECODE(p_iss_param,1,cred_branch,iss_cd) iss_cd, INITCAP(line_name) line_name, INITCAP(subline_name) subline_name, 
--                           SUM(NVL(total_si,0)) TSI, SUM(NVL(total_prem,0))PREM, 
--                           SUM(NVL(sum_reinsured,0)) REINSURED, SUM(NVL(share_premium,0)) SHARE_PREM,  SUM(NVL(ri_comm_amt,0)) RI_COMM,  
--                           SUM(NVL(net_due,0)) NET_DUE, COUNT( DISTINCT BINDER_NO) BINDER_COUNT, sum(NVL(ri_prem_vat,0)) RI_PREM_VAT,
--                           SUM(NVL(ri_comm_vat,0)) RI_COMM_VAT,
--                           SUM(NVL(ri_wholding_vat,0)) RI_WHOLDING_VAT,
--                                       SUM(NVL(ri_premium_tax,0)) RI_PREMIUM_TAX
--                      FROM gipi_uwreports_ri_ext
--                     WHERE user_id = p_user_id
--                       --AND iss_cd =NVL( :p_iss_cd, iss_cd)
--                       AND DECODE(p_iss_param,1,cred_branch,iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,1,cred_branch,iss_cd))
--                       AND line_cd =NVL( p_line_cd, line_cd)
--                       AND subline_cd =NVL( p_subline_cd, subline_cd)
--                       AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
--                        OR  (p_scope=1 AND endt_seq_no=0)
--                        OR  (p_scope=2 AND endt_seq_no>0))
--                        /* added security rights control by robert 01.02.14*/
--                       AND check_user_per_iss_cd2 (line_cd,DECODE (p_iss_param,1, cred_branch,iss_cd),'GIPIS901A', p_user_id) =1
--                       AND check_user_per_line2 (line_cd,DECODE (p_iss_param,1, cred_branch,iss_cd),'GIPIS901A', p_user_id) = 1
--                        /* robert 01.02.14 end of added code */
--                     GROUP BY line_cd, subline_cd, DECODE(p_iss_param,1,cred_branch,iss_cd), line_name, subline_name  
--                     ORDER BY iss_cd)

       /* modified by apollo cruz 
        * 05.26.2015
        * AFPGEN-IMPLEM-SR 0004410 
        * for proper computation of amounts */

        FOR rep IN (SELECT   line_cd, subline_cd, iss_cd, line_name, subline_name, SUM (tsi) tsi,
                             SUM (prem) prem, SUM (reinsured) reinsured,
                             SUM (share_prem) share_prem, SUM (ri_comm) ri_comm,
                             SUM (net_due) net_due, --SUM (binder_count) binder_count, --commented out by MarkS 11.28.2016 SR5854
                             SUM (ri_prem_vat) ri_prem_vat, SUM (ri_comm_vat) ri_comm_vat,
                             SUM (ri_wholding_vat) ri_wholding_vat,
                             SUM (ri_premium_tax) ri_premium_tax
                        FROM (SELECT   line_cd, subline_cd,
                                       DECODE (p_iss_param, 1, NVL(cred_branch, iss_cd), iss_cd) iss_cd,
                                       INITCAP (line_name) line_name,
                                       INITCAP (subline_name) subline_name, NVL (total_si, 0) tsi,
                                       NVL (total_prem, 0) prem,
                                       SUM (NVL (sum_reinsured, 0)) reinsured,
                                       SUM (NVL (share_premium, 0)) share_prem,
                                       SUM (NVL (ri_comm_amt, 0)) ri_comm,
                                       SUM (NVL (net_due, 0)) net_due,
                                       --COUNT (DISTINCT binder_no) binder_count, --commented out by MarkS 11.28.2016 SR5854
                                       SUM (NVL (ri_prem_vat, 0)) ri_prem_vat,
                                       SUM (NVL (ri_comm_vat, 0)) ri_comm_vat,
                                       SUM (NVL (ri_wholding_vat, 0)) ri_wholding_vat,
                                       SUM (NVL (ri_premium_tax, 0)) ri_premium_tax
                                  FROM gipi_uwreports_ri_ext
                                 WHERE user_id = p_user_id
                                   AND DECODE (p_iss_param, 1, NVL(cred_branch, iss_cd), iss_cd) =
                                          NVL (p_iss_cd,
                                               DECODE (p_iss_param, 1, NVL(cred_branch, iss_cd), iss_cd)
                                              )
                                   AND line_cd = NVL (p_line_cd, line_cd)
                                   AND subline_cd = NVL (p_subline_cd, subline_cd)
                                   AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                                        OR (p_scope = 1 AND endt_seq_no = 0)
                                        OR (p_scope = 2 AND endt_seq_no > 0)
                                       )
                              GROUP BY line_cd,
                                       subline_cd,
                                       DECODE (p_iss_param, 1, NVL(cred_branch, iss_cd), iss_cd),
                                       line_name,
                                       subline_name,
                                       frps_line_cd,
                                       frps_yy,
                                       frps_seq_no,
                                       NVL(total_si, 0),
                                       NVL(total_prem, 0))
                    GROUP BY line_cd, subline_cd, iss_cd, line_name, subline_name
                    ORDER BY iss_cd) 
        LOOP       
        
            /*======== iss_name ========*/     
            v_iss_name := GIPIR930A_PKG.CF_ISS_NAMEFORMULA(rep.iss_cd);            
            
            /*======== tsi_prem ========*/
            --GIPIR930A_PKG.CF_TSI_PREMFORMULA(rep.line_cd, rep.subline_cd, rep.iss_cd, p_iss_param, p_scope, v_total_si, v_total_prem, p_user_id);
            --apollo cruz 05.26.2015 AFPGEN-IMPLEM-SR 0004410 - commented out the codes above, as per ma'am jhing, amounts must be based on the extract table only

            /*======== CF_reinsured ========*/
            --v_reinsured := GIPIR930A_PKG.CF_REINSUREDFORMULA(rep.line_cd, rep.subline_cd, rep.iss_cd, p_iss_param, p_scope, p_user_id);
            --apollo cruz 05.26.2015 AFPGEN-IMPLEM-SR 0004410 - commented out the codes above, as per ma'am jhing, amounts must be based on the extract table only
            
                        
            v_rep_tab.iss_cd                := rep.iss_cd;
            v_rep_tab.iss_name              := v_iss_name;
            v_rep_tab.line_cd               := rep.line_cd;
            v_rep_tab.line_name             := rep.line_name;            
            v_rep_tab.subline_cd            := rep.subline_cd;
            v_rep_tab.subline_name          := rep.subline_name;
            
            --v_rep_tab.binder_count          := rep.binder_count;
            -- apollo cruz 05.26.2015
            -- AFPGEN-IMPLEM-SR 0004410
            -- modified counting of binders
            BEGIN
               SELECT COUNT (DISTINCT binder_no)
                 INTO v_rep_tab.binder_count
                 FROM gipi_uwreports_ri_ext
                WHERE user_id = p_user_id
                  AND DECODE (p_iss_param, 1, NVL(cred_branch, iss_cd), iss_cd) = rep.iss_cd
                  AND line_cd = rep.line_cd
                  AND subline_cd = rep.subline_cd
                  AND ((p_scope = 3 AND endt_seq_no = endt_seq_no)
                        OR (p_scope = 1 AND endt_seq_no = 0)
                        OR (p_scope = 2 AND endt_seq_no > 0)
                      )
             GROUP BY DECODE (p_iss_param, 1, NVL(cred_branch, iss_cd), iss_cd), line_cd, subline_cd; -- (GROUP BY iss_cd, line_cd, subline_cd;)edited by out by MarkS 11.28.2016 SR5854
            EXCEPTION WHEN NO_DATA_FOUND THEN
               v_rep_tab.binder_count := 0;         
            END;         
            
            
            v_rep_tab.tsi                   := rep.tsi;--NVL(v_total_si, '0'); --apollo cruz 05.26.2015 AFPGEN-IMPLEM-SR 0004410
            v_rep_tab.prem                  := rep.prem;--NVL(v_total_prem, '0'); --changed v_total_si,v_total_prem and v_reinsured
            v_rep_tab.reinsured             := rep.reinsured;--v_reinsured; --  to rep.tsi, rep.prem and rep.reinsured
            v_rep_tab.share_prem            := rep.share_prem;
            v_rep_tab.ri_prem_vat           := rep.ri_prem_vat;
            v_rep_tab.ri_comm               := rep.ri_comm;
            v_rep_tab.ri_comm_vat           := rep.ri_comm_vat;
            v_rep_tab.ri_wholding_vat       := rep.ri_wholding_vat;
            v_rep_tab.ri_premium_tax        := rep.ri_premium_tax;
            v_rep_tab.net_due               := rep.net_due; 
            
            PIPE ROW(v_rep_tab);
        END LOOP;   --end of loop 
        
        
    END;    --end of populate_gipir930a_report function
    
END;    --end of package body
/
