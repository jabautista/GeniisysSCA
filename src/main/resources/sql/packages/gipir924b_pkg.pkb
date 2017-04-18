CREATE OR REPLACE PACKAGE BODY CPI.GIPIR924B_PKG AS

    FUNCTION get_header_gipir924b (
        p_scope             gipi_uwreports_intm_ext.SCOPE%TYPE,
        p_user_id           gipi_uwreports_intm_ext.user_id%TYPE
    )
        RETURN header_tab PIPELINED 
    AS
        v_report    header_type;
        
    BEGIN
        v_report.cf_company := gipir924b_pkg.cf_companyformula;
        v_report.cf_company_address := gipir924b_pkg.cf_company_addressformula;
        v_report.cf_heading3 := gipir924b_pkg.cf_heading3formula (p_user_id);
        v_report.cf_based_on := gipir924b_pkg.cf_based_onformula (p_user_id, p_scope);
        PIPE ROW (v_report);
    END;
   
    FUNCTION cf_companyformula
        RETURN CHAR
    IS
        v_company_name   VARCHAR2 (150);
        
    BEGIN
        SELECT param_value_v
          INTO v_company_name
          FROM giis_parameters
         WHERE UPPER(param_name) = 'COMPANY_NAME';

        RETURN (v_company_name);
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
     EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
    END;
    
    FUNCTION cf_heading3formula (p_user_id gipi_uwreports_intm_ext.user_id%TYPE)
        RETURN CHAR
    IS
        v_param_date   NUMBER (1);
        v_from_date    DATE;
        v_to_date      DATE;
        heading3       VARCHAR2 (150);
        
    BEGIN
        SELECT DISTINCT param_date, from_date, TO_DATE
          INTO v_param_date, v_from_date, v_to_date
          FROM gipi_uwreports_intm_ext
         WHERE user_id = p_user_id;

        IF v_param_date IN (1, 2, 4) THEN
            IF v_from_date = v_to_date THEN
                heading3 := 'For '||TO_CHAR(v_from_date, 'fmMonth dd, yyyy');
            ELSE
                heading3 := 'For the Period of '||TO_CHAR(v_from_date, 'fmMonth dd, yyyy')||' to '||TO_CHAR(v_to_date, 'fmMonth dd, yyyy');
            END IF;
        ELSE
            IF TO_CHAR(v_from_date, 'MMYYYY') = TO_CHAR(v_to_date, 'MMYYYY') THEN
                heading3 := 'For the Month of '||TO_CHAR(v_from_date, 'fmMonth, yyyy');
            ELSE
                heading3 := 'For the Period of '||TO_CHAR(v_from_date, 'fmMonth dd, yyyy')||' to '||TO_CHAR(v_to_date, 'fmMonth dd, yyyy');
             END IF;
        END IF;

        RETURN (heading3);
    END;
    
    FUNCTION cf_based_onformula (
        p_user_id   gipi_uwreports_intm_ext.user_id%TYPE,
        p_scope     gipi_uwreports_intm_ext.SCOPE%TYPE
    )
        RETURN CHAR
    IS    
        v_param_date     NUMBER (1);
        v_based_on       VARCHAR2 (100);
        v_scope          NUMBER (1);
        v_policy_label   VARCHAR2 (300);
        
    BEGIN
        SELECT param_date
          INTO v_param_date
          FROM gipi_uwreports_intm_ext
         WHERE user_id = p_user_id AND ROWNUM = 1;

        IF v_param_date = 1 THEN
           v_based_on := 'Based on Issue Date';
        ELSIF v_param_date = 2 THEN
           v_based_on := 'Based on Inception Date';
        ELSIF v_param_date = 3 THEN
           v_based_on := 'Based on Booking month - year';
        ELSIF v_param_date = 4 THEN
           v_based_on := 'Based on Acctg Entry Date';
        END IF;

        v_scope := p_scope;

        IF v_scope = 1 THEN
            v_policy_label := v_based_on||' / '||'Policies Only';
        ELSIF v_scope = 2 THEN
            v_policy_label := v_based_on||' / '||'Endorsements Only';
        ELSIF v_scope = 3 THEN
            v_policy_label := v_based_on||' / '||'Policies and Endorsements';
        END IF;

        RETURN (v_policy_label);
    END;

    FUNCTION populate_gipir924b (
        p_intm_no           gipi_uwreports_intm_ext.intm_no%TYPE,
        p_assd_no           gipi_uwreports_intm_ext.assd_no%TYPE,
        p_scope             gipi_uwreports_intm_ext.scope%TYPE,
        p_subline_cd        gipi_uwreports_intm_ext.subline_cd%TYPE,
        p_line_cd           gipi_uwreports_intm_ext.line_cd%TYPE,
        p_iss_cd            gipi_uwreports_intm_ext.iss_cd%TYPE,
        p_iss_param         NUMBER,
        p_intm_type         gipi_uwreports_intm_ext.intm_type%TYPE,
        p_user_id           gipi_uwreports_intm_ext.user_id%TYPE -- marco - 02.06.2013 - added parameter
    )
        RETURN report_tab PIPELINED 
    IS    
        v_report            report_type;          

     -- added codes for collection type of getting totals - jhing 08.22.2015 FGICWEB SR 17728
       TYPE vindx_varray IS TABLE OF NUMBER
          INDEX BY VARCHAR2 (100);
          
          

       v_intmtype_totals    vindx_varray;
       v_idx_branch_totals  vindx_varray;
       
       v_intmtype_totals_tbl intm_type_totals_tab ;
       v_branch_totals_tbl branch_totals_tab ;  
       
       v_rec_index  NUMBER ;    
       v_rec_exists VARCHAR2(1);             
       
       v_grand_total_polcount       NUMBER := 0;
       v_grand_total_tsi            NUMBER := 0;
       v_grand_total_prem_amt       NUMBER := 0;
       v_grand_total_prem_amt_shr   NUMBER := 0;
       v_grand_total_evatprem       NUMBER := 0;
       v_grand_total_lgt            NUMBER := 0;
       v_grand_total_doc            NUMBER := 0;
       v_grand_total_fst            NUMBER := 0;
       v_grand_total_other          NUMBER := 0;
       v_grand_total_amtdue         NUMBER := 0;

       PROCEDURE get_intm_type_totals 
       IS
       BEGIN
      
        SELECT tx.intm_type,
                     tx.branch_cd,
                     SUM (tx.total_tsi) total_intm_tsi,
                     SUM (tx.total_prem) total_intm_prem,
                     SUM (tx.evatprem) total_intm_evatprem,
                     SUM (tx.lgt) total_intm_lgt,
                     SUM (tx.doc_stamps) total_intm_doc,
                     SUM (tx.fst) total_intm_fst,
                     SUM (tx.other_taxes) total_intm_other,
                     SUM (tx.total_amt_due) total_intm_amtdue,
                     SUM (tx.prem_share_amt) total_intm_prem_share_amt,
                     SUM (tx.comm_amt) total_intm_comm_amt,
                     gipir923b_pkg.get_totals_intmtype (p_iss_param,
                                                        p_assd_no,
                                                        p_intm_no,
                                                        p_scope,
                                                        p_subline_cd,
                                                        p_line_cd,
                                                        tx.branch_cd,
                                                        tx.intm_type,
                                                        p_user_id) pol_count
                     BULK COLLECT INTO v_intmtype_totals_tbl
                FROM (  SELECT a.intm_type,
                               DECODE (p_iss_param,
                                       1, NVL (a.cred_branch, a.iss_cd),
                                       a.iss_cd)
                                  branch_cd,
                               a.iss_cd,
                               a.prem_seq_no,
                               a.rec_type,
                               NVL (a.total_prem, 0) total_prem,
                               NVL (a.total_tsi, 0) total_tsi,
                               NVL (a.evatprem, 0) evatprem,
                               NVL (a.fst, 0) fst,
                               NVL (a.doc_stamps, 0) doc_stamps,
                               NVL (a.lgt, 0) lgt,
                               NVL (a.other_taxes, 0) other_taxes,
                                 NVL (a.total_prem, 0)
                               + NVL (a.evatprem, 0)
                               + NVL (a.fst, 0)
                               + NVL (a.doc_stamps, 0)
                               + NVL (a.lgt, 0)
                               + NVL (a.other_taxes, 0)
                                  total_amt_due,
                               SUM (NVL (a.comm_amt, 0)) comm_amt,
                               SUM (NVL (a.prem_share_amt, 0)) prem_share_amt
                          FROM gipi_uwreports_intm_ext a
                         WHERE     1 = 1
                               AND a.user_id = p_user_id
                               AND DECODE (p_iss_param,
                                           1, NVL (a.cred_branch, a.iss_cd),
                                           a.iss_cd) =
                                      NVL (
                                         p_iss_cd,
                                         DECODE (p_iss_param,
                                                 1, NVL (a.cred_branch, a.iss_cd),
                                                 a.iss_cd))
                               AND a.line_cd = NVL (p_line_cd, a.line_cd)
                               AND subline_cd = NVL (p_subline_cd, subline_cd)
                               AND assd_no = NVL (p_assd_no, assd_no)
                               AND intm_no = NVL (p_intm_no, intm_no)
                               AND intm_type = NVL (p_intm_type, intm_type)
                               AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                                    OR (p_scope = 1 AND endt_seq_no = 0)
                                    OR (p_scope = 2 AND endt_seq_no > 0))
                      GROUP BY a.intm_type,
                               DECODE (p_iss_param,
                                       1, NVL (a.cred_branch, a.iss_cd),
                                       a.iss_cd),
                               a.iss_cd,
                               a.prem_seq_no,
                               a.rec_type,
                               a.total_prem,
                               a.total_tsi,
                               a.evatprem,
                               a.fst,
                               a.doc_stamps,
                               a.lgt,
                               a.other_taxes) tx
            GROUP BY tx.intm_type, tx.branch_cd ;    
            
            
            IF SQL%FOUND THEN
            
               FOR idx IN v_intmtype_totals_tbl.FIRST .. v_intmtype_totals_tbl.LAST 
               LOOP
                 v_intmtype_totals(v_intmtype_totals_tbl(idx).intm_type || '-' || v_intmtype_totals_tbl(idx).branch_cd ) := idx;       
      
               END LOOP;            
            END IF;    
           

      END get_intm_type_totals;     
      
      
      
       PROCEDURE get_branch_totals  
       IS
       BEGIN
      
        SELECT   tx.branch_cd,
                     SUM (tx.total_tsi) total_intm_tsi,
                     SUM (tx.total_prem) total_intm_prem,
                     SUM (tx.evatprem) total_intm_evatprem,
                     SUM (tx.lgt) total_intm_lgt,
                     SUM (tx.doc_stamps) total_intm_doc,
                     SUM (tx.fst) total_intm_fst,
                     SUM (tx.other_taxes) total_intm_other,
                     SUM (tx.total_amt_due) total_intm_amtdue,
                     SUM (tx.prem_share_amt) total_intm_prem_share_amt,
                     SUM (tx.comm_amt) total_intm_comm_amt,
                     gipir923b_pkg.get_totals_branch_amts (p_iss_param,
                                                        p_assd_no,
                                                        p_intm_no,
                                                        p_scope,
                                                        p_subline_cd,
                                                        p_line_cd,
                                                        tx.branch_cd,
                                                        p_intm_type,
                                                        p_user_id) pol_count
                     BULK COLLECT INTO v_branch_totals_tbl
                FROM (  SELECT DECODE (p_iss_param,
                                       1, NVL (a.cred_branch, a.iss_cd),
                                       a.iss_cd)
                                  branch_cd,
                               a.iss_cd,
                               a.prem_seq_no,
                               a.rec_type,
                               NVL (a.total_prem, 0) total_prem,
                               NVL (a.total_tsi, 0) total_tsi,
                               NVL (a.evatprem, 0) evatprem,
                               NVL (a.fst, 0) fst,
                               NVL (a.doc_stamps, 0) doc_stamps,
                               NVL (a.lgt, 0) lgt,
                               NVL (a.other_taxes, 0) other_taxes,
                                 NVL (a.total_prem, 0)
                               + NVL (a.evatprem, 0)
                               + NVL (a.fst, 0)
                               + NVL (a.doc_stamps, 0)
                               + NVL (a.lgt, 0)
                               + NVL (a.other_taxes, 0)
                                  total_amt_due,
                               SUM (NVL (a.comm_amt, 0)) comm_amt,
                               SUM (NVL (a.prem_share_amt, 0)) prem_share_amt
                          FROM gipi_uwreports_intm_ext a
                         WHERE     1 = 1
                               AND a.user_id = p_user_id
                               AND DECODE (p_iss_param,
                                           1, NVL (a.cred_branch, a.iss_cd),
                                           a.iss_cd) =
                                      NVL (
                                         p_iss_cd,
                                         DECODE (p_iss_param,
                                                 1, NVL (a.cred_branch, a.iss_cd),
                                                 a.iss_cd))
                               AND a.line_cd = NVL (p_line_cd, a.line_cd)
                               AND subline_cd = NVL (p_subline_cd, subline_cd)
                               AND assd_no = NVL (p_assd_no, assd_no)
                               AND intm_no = NVL (p_intm_no, intm_no)
                               AND intm_type = NVL (p_intm_type, intm_type)
                               AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                                    OR (p_scope = 1 AND endt_seq_no = 0)
                                    OR (p_scope = 2 AND endt_seq_no > 0))
                      GROUP BY DECODE (p_iss_param,
                                       1, NVL (a.cred_branch, a.iss_cd),
                                       a.iss_cd),
                               a.iss_cd,
                               a.prem_seq_no,
                               a.rec_type,
                               a.total_prem,
                               a.total_tsi,
                               a.evatprem,
                               a.fst,
                               a.doc_stamps,
                               a.lgt,
                               a.other_taxes) tx
            GROUP BY  tx.branch_cd ;    
            
            
            IF SQL%FOUND THEN
            
               FOR idx IN v_branch_totals_tbl.FIRST .. v_branch_totals_tbl.LAST 
               LOOP
                 v_idx_branch_totals(v_branch_totals_tbl(idx).branch_cd ) := idx;       
                 v_grand_total_polcount      := nvl(v_grand_total_polcount,0) + NVL(v_branch_totals_tbl(idx).total_branch_policy_cnt,0) ;
                 v_grand_total_tsi           := NVL(v_grand_total_tsi,0) + NVL(v_branch_totals_tbl(idx).total_branch_tsi ,0) ;
                 v_grand_total_prem_amt      := NVL(v_grand_total_prem_amt       ,0) + NVL(v_branch_totals_tbl(idx).total_branch_prem ,0) ;
                 v_grand_total_prem_amt_shr  := NVL(v_grand_total_prem_amt_shr,0) + NVL(v_branch_totals_tbl(idx).total_branch_prem_share_amt ,0) ;
                 v_grand_total_evatprem      := NVL(v_grand_total_evatprem  ,0) + NVL(v_branch_totals_tbl(idx).total_branch_evatprem ,0) ;
                 v_grand_total_lgt           := NVL(v_grand_total_lgt,0) + NVL(v_branch_totals_tbl(idx).total_branch_lgt ,0) ;
                 v_grand_total_doc           := NVL(v_grand_total_doc  ,0) + NVL(v_branch_totals_tbl(idx).total_branch_doc ,0) ;
                 v_grand_total_fst           := NVL(v_grand_total_fst ,0) + NVL(v_branch_totals_tbl(idx).total_branch_fst ,0) ;
                 v_grand_total_other         := NVL(v_grand_total_other ,0) + NVL(v_branch_totals_tbl(idx).total_branch_other ,0) ;
                 v_grand_total_amtdue        := NVL(v_grand_total_amtdue    ,0) + NVL(v_branch_totals_tbl(idx).total_branch_amtdue ,0) ;                 
      
               END LOOP;            
            END IF;           

      END get_branch_totals;        
                
        BEGIN
       
          get_intm_type_totals ;  -- jhing 08.22.2015 FGICWEB 17728
          get_branch_totals ; 
        
            FOR i IN (SELECT a.LINE_CD, a.LINE_NAME, a.SUBLINE_CD, a.SUBLINE_NAME,
                             DECODE(p_iss_param, 1, NVL(a.CRED_BRANCH, a.iss_cd) , a.ISS_CD) ISS_CD,  -- jhing 08.22.2015 added nvl to branch and to all amounts 
                             SUM(NVL(a.TOTAL_TSI,0)) SUM_TOTAL_TSI, 
                             SUM(NVL(a.TOTAL_PREM,0)) SUM_TOTAL_PREM, 
                             SUM(NVL(a.EVATPREM,0)) SUM_EVATPREM, 
                             SUM(NVL(a.LGT,0)) SUM_LGT,
                             SUM(NVL(a.DOC_STAMPS,0)) SUM_DOC_STAMPS, 
                             SUM(NVL(a.FST,0)) SUM_FST, 
                             SUM(NVL(a.OTHER_TAXES,0)) SUM_OTHER_TAXES, 
                             SUM(NVL(a.OTHER_CHARGES,0)) SUM_OTHER_CHARGES,
                             a.PARAM_DATE, a.FROM_DATE, a.TO_DATE, a.SCOPE, a.USER_ID, a.INTM_NO, a.INTM_NAME,
                             SUM(NVL(a.TOTAL_PREM,0))+SUM(NVL(a.EVATPREM,0))+SUM(NVL(a.LGT,0))+SUM(NVL(a.DOC_STAMPS,0))+SUM(NVL(a.FST,0))+SUM(NVL(a.OTHER_TAXES,0))+SUM(NVL(a.OTHER_CHARGES,0)) TOTAL,
                             COUNT(DISTINCT a.POLICY_ID) POLCOUNT,   -- jhing 08.22.2015 added distinct 
                            -- SUM(d.COMMISSION) COMMISSION, 
                            SUM(NVL(a.comm_amt,0) ) COMMISSION, 
                             a.INTM_TYPE, 
                             SUM(NVL(a.PREM_SHARE_AMT,0)) PREM_SHARE_AMT,
                             a.endt_seq_no, 
                             a.issue_yy, a.pol_seq_no, a.renew_no,rownum,policy_id --ADDED by MarkS SR-21060 6.30.2016
                        FROM GIPI_UWREPORTS_INTM_EXT a /*,
                             (SELECT c.POLICY_ID,
                                     SUM(DECODE(c.RI_COMM_AMT * c.CURRENCY_RT, 0, NVL(b.COMMISSION_AMT * c.CURRENCY_RT, 0), c.RI_COMM_AMT * c.CURRENCY_RT)) COMMISSION
                                FROM GIPI_COMM_INVOICE b, GIPI_INVOICE c  
                               WHERE b.POLICY_ID = c.POLICY_ID
                               GROUP BY c.POLICY_ID) d 
                       WHERE a.policy_id=d.policy_id(+)
                         AND a.user_id = p_user_id -- marco - 02.06.2013 */
                         WHERE a.user_id = p_user_id 
                         AND ASSD_NO = NVL(p_assd_no,ASSD_NO)
                         AND INTM_NO = NVL(p_intm_no, INTM_NO)
                         AND INTM_TYPE = NVL(p_intm_type, INTM_TYPE)
                         AND DECODE(p_iss_param,1,NVL(a.cred_branch,a.iss_cd),a.iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,NVL(a.cred_branch,a.iss_cd),a.iss_cd))
                         AND a.LINE_CD = NVL(p_line_cd, a.LINE_CD)
                         AND SUBLINE_CD = NVL(p_subline_cd, SUBLINE_CD)
                         AND ((p_scope=3 AND endt_seq_no=endt_seq_no) OR (p_scope=1 AND endt_seq_no=0) OR (p_scope=2 AND endt_seq_no>0))
                         /* added security rights control by robert 01.02.14*/
                    /*     AND check_user_per_iss_cd2 (a.line_cd,DECODE (p_iss_param,1, a.cred_branch,a.iss_cd),'GIPIS901A', p_user_id) =1
                         AND check_user_per_line2 (a.line_cd,DECODE (p_iss_param,1, a.cred_branch,a.iss_cd),'GIPIS901A', p_user_id) = 1 */
                         /* robert 01.02.14 end of added code */
                       GROUP BY LINE_CD, LINE_NAME, SUBLINE_CD, SUBLINE_NAME,
                             DECODE(p_iss_param, 1, NVL(a.CRED_BRANCH,a.iss_cd), a.ISS_CD),
                             PARAM_DATE, a.FROM_DATE, a.TO_DATE, SCOPE, a.USER_ID,
                             INTM_NO, INTM_NAME, a.INTM_TYPE, 
                             a.endt_seq_no,
                             a.issue_yy, a.pol_seq_no, a.renew_no,rownum,policy_id -- Added by MarkS SR-21060 6.30.2016
                       ORDER BY DECODE(p_iss_param, 1, NVL(a.CRED_BRANCH,a.iss_cd), a.ISS_CD), INTM_TYPE, INTM_NO, INTM_NAME, LINE_NAME, SUBLINE_NAME)
                             
            LOOP                
                v_report.iss_name := gipir924b_pkg.cf_iss_nameFormula (i.iss_cd);
                v_report.intm_desc := gipir924b_pkg.cf_intm_descFormula (i.intm_type);
                v_report.intm_name := i.intm_name;
                v_report.line_name := i.line_name;
                v_report.subline_name := i.subline_name;
--                v_report.polcount := i.polcount;
                v_report.total_tsi := i.sum_total_tsi;
                v_report.total_prem := i.sum_total_prem;
                v_report.prem_share_amt := i.prem_share_amt;
                v_report.evatprem := i.sum_evatprem;
                v_report.lgt := i.sum_lgt;
                v_report.doc_stamps := i.sum_doc_stamps;
                v_report.fst := i.sum_fst;
                v_report.other_taxes := i.sum_other_taxes;
                v_report.other_charges := i.sum_other_charges;
                v_report.total := i.total;
               -- v_report.commission := gipir924b_pkg.cf_new_commissionFormula(i.intm_no, i.intm_type, p_iss_param, i.iss_cd, i.line_cd, i.subline_cd, i.scope, p_user_id); -- jhing 08.22.2015 FGICWEB 17728 replaced with : 
               v_report.commission := i.commission ; 
               v_report.intm_no := i.intm_no;
               
             v_rec_exists := 'N';
             IF v_intmtype_totals.exists (i.intm_type || '-' || i.iss_cd) THEN
                v_rec_exists := 'Y';
             END IF; 
         
             IF v_rec_exists = 'Y' THEN
                v_rec_index  := v_intmtype_totals (i.intm_type || '-' || i.iss_cd) ;
                v_report.total_intm_tsi := v_intmtype_totals_tbl(v_rec_index).total_intm_tsi;
                v_report.total_intm_prem := v_intmtype_totals_tbl(v_rec_index).total_intm_prem;
                v_report.total_intm_prem_shr := v_intmtype_totals_tbl(v_rec_index).total_intm_prem_share_amt;
                v_report.total_intm_evatprem := v_intmtype_totals_tbl(v_rec_index).total_intm_evatprem;
                v_report.total_intm_lgt := v_intmtype_totals_tbl(v_rec_index).total_intm_lgt;
                v_report.total_intm_doc := v_intmtype_totals_tbl(v_rec_index).total_intm_doc;
                v_report.total_intm_fst := v_intmtype_totals_tbl(v_rec_index).total_intm_fst;
                v_report.total_intm_other := v_intmtype_totals_tbl(v_rec_index).total_intm_other;
                v_report.total_intm_amtdue := v_intmtype_totals_tbl(v_rec_index).total_intm_amtdue;
                v_report.total_polcount_intm := v_intmtype_totals_tbl(v_rec_index).total_intm_policy_cnt;
             END IF;   
             
             
              --- branch totals 
         v_rec_exists := 'N';
         IF v_idx_branch_totals.exists (i.iss_cd) THEN
            v_rec_exists := 'Y';
         END IF; 
         
         IF v_rec_exists = 'Y' THEN
            v_rec_index  := v_idx_branch_totals   ( i.iss_cd) ;
            v_report.total_branch_tsi := v_branch_totals_tbl (v_rec_index).total_branch_tsi;
            v_report.total_branch_prem := v_branch_totals_tbl (v_rec_index).total_branch_prem;
            v_report.total_branch_prem_shr := v_branch_totals_tbl (v_rec_index).total_branch_prem_share_amt;
            v_report.total_branch_evatprem := v_branch_totals_tbl (v_rec_index).total_branch_evatprem;
            v_report.total_branch_lgt := v_branch_totals_tbl (v_rec_index).total_branch_lgt;
            v_report.total_branch_doc := v_branch_totals_tbl (v_rec_index).total_branch_doc;
            v_report.total_branch_fst := v_branch_totals_tbl (v_rec_index).total_branch_fst;
            v_report.total_branch_other := v_branch_totals_tbl (v_rec_index).total_branch_other;
            v_report.total_branch_amtdue := v_branch_totals_tbl (v_rec_index).total_branch_amtdue;
            v_report.total_polcount_branch := v_branch_totals_tbl (v_rec_index).total_branch_policy_cnt;
         END IF;        
         
          -- populate grand totals
         v_report.total_polcount_grand :=  v_grand_total_polcount ;
         v_report.total_grand_tsi      :=  v_grand_total_tsi  ;
         v_report.total_grand_prem     :=  v_grand_total_prem_amt ;
         v_report.total_grand_prem_shr :=  v_grand_total_prem_amt_shr ;
         v_report.total_grand_evatprem :=  v_grand_total_evatprem ;
         v_report.total_grand_lgt      :=  v_grand_total_lgt  ;
         v_report.total_grand_doc      :=  v_grand_total_doc ;
         v_report.total_grand_fst      :=  v_grand_total_fst  ;
         v_report.total_grand_other    :=  v_grand_total_other  ;
         v_report.total_grand_amtdue   :=  v_grand_total_amtdue ;           
         
         -- jhing 08.22.2015 FGICWEB 17728 commented out old query for amounts                        
              /*  v_report.total_polcount_intm := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, i.intm_type, 'POLCOUNT', p_user_id);
                v_report.total_polcount_branch := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, p_intm_type, 'POLCOUNT', p_user_id);
                v_report.total_polcount_grand := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, p_iss_cd, p_iss_param, p_intm_type, 'POLCOUNT', p_user_id);         
                
                v_report.total_intm_tsi := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, i.intm_type, 'TSI', p_user_id);
                v_report.total_branch_tsi := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, p_intm_type, 'TSI', p_user_id);
                v_report.total_grand_tsi := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, p_iss_cd, p_iss_param, p_intm_type, 'TSI', p_user_id);
                
                v_report.total_intm_prem := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, i.intm_type, 'PREM', p_user_id);
                v_report.total_branch_prem := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, p_intm_type, 'PREM', p_user_id);
                v_report.total_grand_prem := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, p_iss_cd, p_iss_param, p_intm_type, 'PREM', p_user_id);
                
                v_report.total_intm_evatprem := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, i.intm_type, 'EVATPREM', p_user_id);
                v_report.total_branch_evatprem := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, p_intm_type, 'EVATPREM', p_user_id);
                v_report.total_grand_evatprem := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, p_iss_cd, p_iss_param, p_intm_type, 'EVATPREM', p_user_id);

                v_report.total_intm_lgt := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, i.intm_type, 'LGT', p_user_id);
                v_report.total_branch_lgt := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, p_intm_type, 'LGT', p_user_id);
                v_report.total_grand_lgt := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, p_iss_cd, p_iss_param, p_intm_type, 'LGT', p_user_id);
                                                
                v_report.total_intm_doc := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, i.intm_type, 'DOC_STAMPS', p_user_id);
                v_report.total_branch_doc := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, p_intm_type, 'DOC_STAMPS', p_user_id);
                v_report.total_grand_doc := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, p_iss_cd, p_iss_param, p_intm_type, 'DOC_STAMPS', p_user_id);
                
                v_report.total_intm_fst := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, i.intm_type, 'FST', p_user_id);
                v_report.total_branch_fst := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, p_intm_type, 'FST', p_user_id);
                v_report.total_grand_fst := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, p_iss_cd, p_iss_param, p_intm_type, 'FST', p_user_id);
                
                v_report.total_intm_other := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, i.intm_type, 'OTHER', p_user_id);
                v_report.total_branch_other := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, p_intm_type, 'OTHER', p_user_id);
                v_report.total_grand_other := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, p_iss_cd, p_iss_param, p_intm_type, 'OTHER', p_user_id);
                
                v_report.total_intm_amtdue := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, i.intm_type, 'AMTDUE', p_user_id);
                v_report.total_branch_amtdue := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, i.iss_cd, p_iss_param, p_intm_type, 'AMTDUE', p_user_id);
                v_report.total_grand_amtdue := gipir924b_pkg.cf_totals_per_groupFormula(p_intm_no, p_assd_no, i.scope, p_subline_cd, p_line_cd, p_iss_cd, p_iss_param, p_intm_type, 'AMTDUE', p_user_id);
               */   
               
               --added by john; handling of policy count      

               IF NVL(GIISP.V('PRD_POL_CNT'), 1) = 1 THEN
                    v_report.polcount := i.polcount;
               ELSIF NVL(GIISP.V('PRD_POL_CNT'), 1) = 2 THEN
                  -- ADDED by MarkS SR-21060 
                   IF i.endt_seq_no != 0 THEN
                       v_report.polcount := 0;
                   ELSE 
                       v_report.polcount := 1;
                   END IF;
                  -- END SR-21060
               
--                  BEGIN
--                       SELECT COUNT (DISTINCT policy_id)
--                         INTO v_report.polcount
--                         FROM gipi_uwreports_intm_ext
--                        WHERE user_id = p_user_id
--                          AND DECODE (p_iss_param, 1, NVL (cred_branch, iss_cd), iss_cd) =
--                                 NVL (p_iss_cd,
--                                      DECODE (p_iss_param, 1, NVL (cred_branch, iss_cd), iss_cd)
--                                     )
--                          AND line_cd = NVL (p_line_cd, line_cd)
--                          AND subline_cd = NVL (p_subline_cd, subline_cd)
--                          AND assd_no = NVL (p_assd_no, assd_no)
--                          AND intm_no = NVL (p_intm_no, intm_no)
--                          AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
--                               OR (p_scope = 1 AND endt_seq_no = 0)
--                               OR (p_scope = 2 AND endt_seq_no > 0))
--                          AND endt_seq_no = 0;
--                   END;    
               ELSIF NVL(GIISP.V('PRD_POL_CNT'), 1) = 3 THEN
               -- ADDED by MarkS 6.30.2016 SR-21060 
                   v_report.polcount := 1;
                   FOR j IN (SELECT a.LINE_CD, a.LINE_NAME, a.SUBLINE_CD, a.SUBLINE_NAME,
                             DECODE(p_iss_param, 1, NVL(a.CRED_BRANCH, a.iss_cd) , a.ISS_CD) ISS_CD,  -- jhing 08.22.2015 added nvl to branch and to all amounts 
                             SUM(NVL(a.TOTAL_TSI,0)) SUM_TOTAL_TSI, 
                             SUM(NVL(a.TOTAL_PREM,0)) SUM_TOTAL_PREM, 
                             SUM(NVL(a.EVATPREM,0)) SUM_EVATPREM, 
                             SUM(NVL(a.LGT,0)) SUM_LGT,
                             SUM(NVL(a.DOC_STAMPS,0)) SUM_DOC_STAMPS, 
                             SUM(NVL(a.FST,0)) SUM_FST, 
                             SUM(NVL(a.OTHER_TAXES,0)) SUM_OTHER_TAXES, 
                             SUM(NVL(a.OTHER_CHARGES,0)) SUM_OTHER_CHARGES,
                             a.PARAM_DATE, a.FROM_DATE, a.TO_DATE, a.SCOPE, a.USER_ID, a.INTM_NO, a.INTM_NAME,
                             SUM(NVL(a.TOTAL_PREM,0))+SUM(NVL(a.EVATPREM,0))+SUM(NVL(a.LGT,0))+SUM(NVL(a.DOC_STAMPS,0))+SUM(NVL(a.FST,0))+SUM(NVL(a.OTHER_TAXES,0))+SUM(NVL(a.OTHER_CHARGES,0)) TOTAL,
                             COUNT(DISTINCT a.POLICY_ID) POLCOUNT,   -- jhing 08.22.2015 added distinct 
                            -- SUM(d.COMMISSION) COMMISSION, 
                            SUM(NVL(a.comm_amt,0) ) COMMISSION, 
                             a.INTM_TYPE, 
                             SUM(NVL(a.PREM_SHARE_AMT,0)) PREM_SHARE_AMT,
                             endt_seq_no, issue_yy, pol_seq_no, renew_no,rownum,policy_id --ADDED by MarkS SR-21060 6.30.2016
                        FROM GIPI_UWREPORTS_INTM_EXT a /*,
                             (SELECT c.POLICY_ID,
                                     SUM(DECODE(c.RI_COMM_AMT * c.CURRENCY_RT, 0, NVL(b.COMMISSION_AMT * c.CURRENCY_RT, 0), c.RI_COMM_AMT * c.CURRENCY_RT)) COMMISSION
                                FROM GIPI_COMM_INVOICE b, GIPI_INVOICE c  
                               WHERE b.POLICY_ID = c.POLICY_ID
                               GROUP BY c.POLICY_ID) d 
                       WHERE a.policy_id=d.policy_id(+)
                         AND a.user_id = p_user_id -- marco - 02.06.2013 */
                         WHERE a.user_id = p_user_id 
                         AND ASSD_NO = NVL(p_assd_no,ASSD_NO)
                         AND INTM_NO = NVL(p_intm_no, INTM_NO)
                         AND INTM_TYPE = NVL(p_intm_type, INTM_TYPE)
                         AND DECODE(p_iss_param,1,NVL(a.cred_branch,a.iss_cd),a.iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,NVL(a.cred_branch,a.iss_cd),a.iss_cd))
                         AND a.LINE_CD = NVL(p_line_cd, a.LINE_CD)
                         AND SUBLINE_CD = NVL(p_subline_cd, SUBLINE_CD)
                         AND ((p_scope=3 AND endt_seq_no=endt_seq_no) OR (p_scope=1 AND endt_seq_no=0) OR (p_scope=2 AND endt_seq_no>0))
                         /* added security rights control by robert 01.02.14*/
                    /*     AND check_user_per_iss_cd2 (a.line_cd,DECODE (p_iss_param,1, a.cred_branch,a.iss_cd),'GIPIS901A', p_user_id) =1
                         AND check_user_per_line2 (a.line_cd,DECODE (p_iss_param,1, a.cred_branch,a.iss_cd),'GIPIS901A', p_user_id) = 1 */
                         /* robert 01.02.14 end of added code */
                       GROUP BY LINE_CD, LINE_NAME, SUBLINE_CD, SUBLINE_NAME,
                             DECODE(p_iss_param, 1, NVL(a.CRED_BRANCH,a.iss_cd), a.ISS_CD),
                             PARAM_DATE, a.FROM_DATE, a.TO_DATE, SCOPE, a.USER_ID,
                             INTM_NO, INTM_NAME, a.INTM_TYPE, 
                             endt_seq_no, issue_yy, pol_seq_no, renew_no,rownum,policy_id -- Added by MarkS SR-21060 6.30.2016
                       ORDER BY DECODE(p_iss_param, 1, NVL(a.CRED_BRANCH,a.iss_cd), a.ISS_CD), INTM_TYPE, INTM_NO, INTM_NAME, LINE_NAME, SUBLINE_NAME
                   )
                   LOOP
                       IF I.ROWNUM > J.ROWNUM THEN
                           IF i.line_cd =  j.line_cd AND
                               i.subline_cd = j.subline_cd AND
                               i.issue_yy = j.issue_yy AND
                               i.pol_seq_no = j.pol_seq_no AND
                               i.renew_no = j.renew_no AND
                               i.endt_seq_no = j.endt_seq_no AND
                               i.iss_cd = j.iss_cd AND
                               check_unique_policy(i.policy_id,j.policy_id) = 'T' THEN
                               v_report.polcount := 0;
                           ELSE
                               v_report.polcount := 1;
                           END IF;
                       ELSE
                           EXIT;
                       END IF;
                   END LOOP;                            
            ELSE
                v_report.polcount := 1;
            --END SR-21060 
--                   BEGIN
--                       SELECT COUNT (pol_count)
--                         INTO v_report.polcount
--                         FROM (SELECT DISTINCT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
--                                               renew_no, 1 pol_count
--                                          FROM gipi_uwreports_intm_ext
--                                         WHERE user_id = p_user_id
--                                           AND DECODE (p_iss_param,
--                                                       1, NVL (cred_branch, iss_cd),
--                                                       iss_cd
--                                                      ) =
--                                                  NVL (p_iss_cd,
--                                                       DECODE (p_iss_param,
--                                                               1, NVL (cred_branch, iss_cd),
--                                                               iss_cd
--                                                              )
--                                                      )
--                                           AND line_cd = NVL (p_line_cd, line_cd)
--                                           AND subline_cd = NVL (p_subline_cd, subline_cd)
--                                           AND assd_no = NVL (p_assd_no, assd_no)
--                                           AND intm_no = NVL (p_intm_no, intm_no)
--                                           AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
--                                                OR (p_scope = 1 AND endt_seq_no = 0)
--                                                OR (p_scope = 2 AND endt_seq_no > 0)
--                                               ));
--                                               
--                   END;   
               END IF;
               
               
                PIPE ROW(v_report);
            END LOOP;
                             
        END populate_gipir924b;
        
    FUNCTION cf_iss_nameFormula (p_iss_cd giis_issource.iss_cd%TYPE) 
        RETURN CHAR 
    IS
        v_iss_name      VARCHAR2(50);
        
    BEGIN
        BEGIN
            SELECT iss_name
              INTO v_iss_name
              FROM giis_issource
             WHERE iss_cd = p_iss_cd;
         EXCEPTION
              WHEN no_data_found OR too_many_rows THEN NULL;
        END;
        
        RETURN(p_iss_cd||' - '||v_iss_name);  
    END;

    FUNCTION cf_intm_descFormula (p_intm_type giis_intm_type.intm_type%TYPE)
        RETURN CHAR
    IS
        v_intm_desc     VARCHAR2(50);
        
     BEGIN
        SELECT intm_desc
            INTO v_intm_desc
            FROM giis_intm_type
           WHERE intm_type = p_intm_type;
         
        RETURN(v_intm_desc);
     END;
     

    FUNCTION cf_new_commissionFormula (
        p_intm_no           gipi_uwreports_intm_ext.intm_no%TYPE,
        p_intm_type         gipi_uwreports_intm_ext.intm_type%TYPE,
        p_iss_param         NUMBER,
        p_iss_cd            gipi_uwreports_intm_ext.iss_cd%TYPE,
        p_line_cd           gipi_uwreports_intm_ext.line_cd%TYPE,
        p_subline_cd        gipi_uwreports_intm_ext.subline_cd%TYPE,
        p_scope             gipi_uwreports_intm_ext.scope%TYPE,
        p_user_id           gipi_uwreports_intm_ext.user_id%TYPE -- marco - 02.06.2013 - added parameter
    )
        RETURN NUMBER
    IS
        v_to_date           DATE;
        v_fund_cd           giac_new_comm_inv.fund_cd%TYPE;
        v_branch_cd         giac_new_comm_inv.branch_cd%TYPE;
        v_commission        number(20,2);
        v_commission_amt    number(20,2);
        v_comm_amt          number(20,2);
        
    BEGIN
      
      SELECT DISTINCT to_date 
        INTO v_to_date
        FROM gipi_uwreports_intm_ext 
       WHERE user_id = p_user_id;   
       
      v_fund_cd := giacp.v('FUND_CD');
      v_branch_cd := giacp.v('BRANCH_CD'); 
       
      FOR rc IN (SELECT b.intrmdry_intm_no, b.iss_cd, b.prem_seq_no, c.ri_comm_amt, c.currency_rt, b.commission_amt
                   FROM gipi_comm_invoice  b,   
                        gipi_invoice c,
                        gipi_uwreports_intm_ext a
                  WHERE a.policy_id  = b.policy_id
                    AND a.policy_id  = c.policy_id
                    AND a.user_id    = p_user_id
                    AND intm_no = p_intm_no
                    AND intm_no = b.intrmdry_intm_no
                    AND intm_type = p_intm_type
                    AND DECODE(p_iss_param,1,NVL(a.cred_branch,a.iss_cd),a.iss_cd) = p_iss_cd --benjo 10.28.2015 added nvl in cred_branch
                    AND a.line_cd = p_line_cd
                    AND subline_cd = p_subline_cd
                    AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                     OR  (p_scope=1 AND endt_seq_no=0)
                     OR  (p_scope=2 AND endt_seq_no>0)) )
                    
       LOOP
          IF (rc.ri_comm_amt * rc.currency_rt) = 0 THEN
            v_commission_amt := rc.commission_amt;
                FOR c1 IN (SELECT acct_ent_date, commission_amt, comm_rec_id, intm_no 
                             FROM giac_new_comm_inv
                            WHERE iss_cd = rc.iss_cd
                              AND prem_seq_no = rc.prem_seq_no
                              AND fund_cd = v_fund_cd
                              AND branch_cd = v_branch_cd
                              AND tran_flag = 'P'
                              AND NVL(delete_sw,'N') = 'N'
                            ORDER BY comm_rec_id DESC)
              LOOP
                IF c1.acct_ent_date > v_to_date THEN
                    FOR c2 IN (SELECT commission_amt 
                                 FROM giac_prev_comm_inv
                                WHERE fund_cd = v_fund_cd
                                  AND branch_cd = v_branch_cd
                                  AND comm_rec_id = c1.comm_rec_id
                                  AND intm_no = c1.intm_no)
                    LOOP
                        v_commission_amt := c2.commission_amt;
                    END LOOP;
                ELSE  
                    v_commission_amt := c1.commission_amt;
                END IF;
                EXIT;
              END LOOP;
            v_comm_amt := NVL(v_commission_amt * rc.currency_rt,0);
          ELSE
            v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
          END IF;    
            v_commission := NVL(v_commission,0) + v_comm_amt;
       END LOOP;          
       RETURN (v_commission);
    END;
    
    FUNCTION cf_totals_per_groupFormula (
        p_intm_no           gipi_uwreports_intm_ext.intm_no%TYPE,
        p_assd_no           gipi_uwreports_intm_ext.assd_no%TYPE,
        p_scope             gipi_uwreports_intm_ext.scope%TYPE,
        p_subline_cd        gipi_uwreports_intm_ext.subline_cd%TYPE,
        p_line_cd           gipi_uwreports_intm_ext.line_cd%TYPE,
        p_iss_cd            gipi_uwreports_intm_ext.iss_cd%TYPE,
        p_iss_param         NUMBER,
        p_intm_type         gipi_uwreports_intm_ext.intm_type%TYPE,
        p_column_invoker    VARCHAR2,
        p_user_id           gipi_uwreports_intm_ext.user_id%TYPE -- marco - 02.06.2013 - added parameter
    ) 
        RETURN NUMBER 
    IS
        v_inand_tsi_amt        gipi_uwreports_intm_ext.TOTAL_TSI%type;
        v_inand_prem_amt       gipi_uwreports_intm_ext.TOTAL_PREM%type;
        v_inand_evatprem       gipi_uwreports_intm_ext.EVATPREM%type;
        v_inand_lgt            gipi_uwreports_intm_ext.lgt%type;
        v_inand_doc_stamps     gipi_uwreports_intm_ext.doc_stamps%type;
        v_inand_fst            gipi_uwreports_intm_ext.fst%type;
        v_inand_other_taxes    gipi_uwreports_intm_ext.other_charges%type;
        v_inand_amtdue         gipi_uwreports_intm_ext.TOTAL_TSI%type;
        v_inand_polcount       NUMBER;
        v_result               NUMBER;

    BEGIN
        v_inand_tsi_amt := 0;
        v_inand_prem_amt := 0;
        v_inand_evatprem := 0;
        v_inand_lgt := 0;
        v_inand_doc_stamps := 0;
        v_inand_fst := 0;
        v_inand_other_taxes := 0;
        v_inand_amtdue := 0;
        v_inand_polcount := 0;
        
        FOR x IN (SELECT total_tsi, total_prem, evatprem, lgt, doc_stamps, fst, other_taxes, 
                         TOTAL_PREM+EVATPREM+LGT+DOC_STAMPS+FST+OTHER_TAXES+OTHER_CHARGES amtdue, policy_id
                    FROM gipi_uwreports_intm_ext
                   WHERE intm_type = NVL(p_intm_type,intm_type)
                      AND iss_cd = NVL(p_iss_cd, iss_cd)
                     AND user_id = p_user_id
                     AND ASSD_NO = NVL(p_assd_no,ASSD_NO)
                     AND INTM_NO = NVL(p_intm_no, INTM_NO)
                     AND DECODE(p_iss_param,1,NVL(cred_branch,iss_cd),iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,NVL(cred_branch,iss_cd),iss_cd)) --benjo 10.28.2015 added nvl in cred_branch
                     AND LINE_CD = NVL(p_line_cd, LINE_CD)
                     AND SUBLINE_CD = NVL(p_subline_cd, SUBLINE_CD)
                     AND ((3=nvl(p_scope,3) AND endt_seq_no=endt_seq_no)
                      OR (p_scope=1 AND endt_seq_no=0)
                      OR (p_scope=2 AND endt_seq_no>0))
                   GROUP BY policy_id, total_tsi, total_prem, evatprem, lgt, doc_stamps, fst, other_taxes, 
                         TOTAL_PREM+EVATPREM+LGT+DOC_STAMPS+FST+OTHER_TAXES+OTHER_CHARGES )
        
        LOOP
            v_inand_tsi_amt     := v_inand_tsi_amt     + x.total_tsi;
            v_inand_prem_amt    := v_inand_prem_amt    + x.total_prem;
            v_inand_evatprem    := v_inand_evatprem    + x.evatprem;
            v_inand_lgt         := v_inand_lgt         + x.lgt;
            v_inand_doc_stamps  := v_inand_doc_stamps  + x.doc_stamps;
            v_inand_fst         := v_inand_fst         + x.fst;
            v_inand_other_taxes := v_inand_other_taxes + x.other_taxes;
            v_inand_amtdue      := v_inand_amtdue      + x.amtdue;
            v_inand_polcount    := v_inand_polcount    + 1;
        END LOOP;
        
        IF p_column_invoker = 'TSI' THEN
            v_result := v_inand_tsi_amt;
        ELSIF p_column_invoker = 'PREM' THEN
            v_result := v_inand_prem_amt;
        ELSIF p_column_invoker = 'EVATPREM' THEN
            v_result := v_inand_evatprem;
        ELSIF p_column_invoker = 'LGT' THEN
            v_result := v_inand_lgt;
        ELSIF p_column_invoker = 'DOC_STAMPS' THEN
            v_result := v_inand_doc_stamps;
        ELSIF p_column_invoker = 'FST' THEN
            v_result := v_inand_fst;
        ELSIF p_column_invoker = 'OTHER' THEN
            v_result := v_inand_other_taxes;
        ELSIF p_column_invoker = 'AMTDUE' THEN
            v_result := v_inand_amtdue;
        ELSIF p_column_invoker = 'POLCOUNT' THEN
            v_result := v_inand_polcount;
        
        END IF;
        
        RETURN (v_result);
    END;
    FUNCTION check_unique_policy(pol_id_i GIPI_UWREPORTS_INTM_EXT.policy_id%TYPE,pol_id_j GIPI_UWREPORTS_INTM_EXT.policy_id%TYPE) 
   RETURN CHAR 
   IS
	v_acct_ent_date_i DATE;
    v_acct_ent_date_j DATE;
    v_incept_date_i DATE;
    v_incept_date_j DATE;
    v_issue_date_i DATE;
    v_issue_date_j DATE;
	BEGIN
    
		BEGIN
			SELECT acct_ent_date, incept_date, issue_date
			  INTO v_acct_ent_date_i, v_incept_date_i, v_issue_date_i
			  FROM gipi_polbasic
			 WHERE policy_id = pol_id_i;
			EXCEPTION
			   WHEN NO_DATA_FOUND or TOO_MANY_ROWS THEN
				 NULL;
	  	END;
        
        BEGIN
			SELECT acct_ent_date, incept_date, issue_date
			  INTO v_acct_ent_date_j, v_incept_date_j, v_issue_date_j
			  FROM gipi_polbasic
			 WHERE policy_id = pol_id_i;
			EXCEPTION
			   WHEN NO_DATA_FOUND or TOO_MANY_ROWS THEN
				 NULL;
	  	END;
        
      IF NVL(v_acct_ent_date_i,TO_DATE('01-JAN-2000','DD-MON-YYYY')) = NVL(v_acct_ent_date_j,TO_DATE('01-JAN-2000','DD-MON-YYYY')) AND 
          NVL(v_incept_date_i,TO_DATE('01-JAN-2000','DD-MON-YYYY')) = NVL(v_incept_date_j,TO_DATE('01-JAN-2000','DD-MON-YYYY')) 
          AND NVL(v_issue_date_i,TO_DATE('01-JAN-2000','DD-MON-YYYY')) = NVL(v_issue_date_j,TO_DATE('01-JAN-2000','DD-MON-YYYY')) THEN
          RETURN('T');
      ELSE
          RETURN('F');
      END IF;   
	    
	END;

END GIPIR924B_PKG;
/
