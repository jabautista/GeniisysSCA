CREATE OR REPLACE PACKAGE BODY CPI.gipir923b_pkg
AS
/*

   (1)

   populate function


*/
   FUNCTION populate_gipir923b (
      p_iss_param    NUMBER,
      p_assd_no      gipi_uwreports_intm_ext.assd_no%TYPE,
      p_intm_no      gipi_uwreports_intm_ext.intm_no%TYPE,
      p_scope        gipi_uwreports_intm_ext.SCOPE%TYPE,
      p_subline_cd   gipi_uwreports_intm_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_intm_ext.line_cd%TYPE,
      p_iss_cd       gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_intm_type    gipi_uwreports_intm_ext.intm_type%TYPE,
      p_user_id      gipi_uwreports_intm_ext.user_id%TYPE -- marco - 02.06.2013 - added parameter
   )
      RETURN report_tab PIPELINED
   IS
      v_report   report_type;
       -- added codes for collection type of getting totals - jhing 07.29.2015 FGICWEB SR 17728
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
       
       v_count  NUMBER;   

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
   
      get_intm_type_totals ;  -- jhing 07.29.2015 FGICWEB 17728
      get_branch_totals ; 
   
      FOR i IN
         (SELECT   rownum,a.assd_no, a.assd_name, a.line_cd, a.line_name,
                   a.subline_cd, a.subline_name,
                   DECODE (p_iss_param, 1, NVL(a.cred_branch, a.iss_cd) , a.iss_cd) iss_cd,  -- jhing 07.29.2015 added NVL
                   a.iss_cd iss_cd2, a.issue_yy, a.pol_seq_no, a.renew_no,
                   a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date,
                   a.expiry_date, a.total_tsi, a.total_prem, a.evatprem,
                   a.lgt, a.doc_stamps, a.fst, a.other_taxes,
                   a.other_charges, a.param_date, a.from_date, a.TO_DATE,
                   a.SCOPE, a.user_id, a.policy_id, a.intm_name, a.intm_no,
                     a.total_prem
                   + a.evatprem
                   + a.lgt
                   + a.doc_stamps
                   + a.fst
                   + a.other_taxes total,
                   /*b.commission commission*/ a.comm_amt commission, /*b.ref_inv_no*/  -- jhing 07.29.2015 FGICWEB 17728 replaced with:   
                             a.iss_cd
                             || '-'
                             || a.prem_seq_no
                             || DECODE (NVL (a.ref_inv_no, ' '),
                                        ' ', ' ',
                                        ' / ' || a.ref_inv_no
                                       ) ref_inv_no, a.intm_type,
                   a.prem_share_amt
              FROM gipi_uwreports_intm_ext a /*,   -- jhing 07.29.2015 commented out 
                   (SELECT   c.policy_id,
                             SUM
                                (DECODE (c.ri_comm_amt * c.currency_rt,
                                         0, NVL (  b.commission_amt
                                                 * c.currency_rt,
                                                 0
                                                ),
                                         c.ri_comm_amt * c.currency_rt
                                        )
                                ) commission,
                                c.iss_cd
                             || '-'
                             || c.prem_seq_no
                             || DECODE (NVL (ref_inv_no, ' '),
                                        ' ', ' ',
                                        ' / ' || ref_inv_no
                                       ) ref_inv_no
                        FROM gipi_comm_invoice b, gipi_invoice c
                       WHERE b.policy_id = c.policy_id
                    GROUP BY c.policy_id,
                                c.iss_cd
                             || '-'
                             || c.prem_seq_no
                             || DECODE (NVL (ref_inv_no, ' '),
                                        ' ', ' ',
                                        ' / ' || ref_inv_no
                                       )) b
             WHERE a.policy_id = b.policy_id(+) */ 
               WHERE 1 = 1 
               AND a.user_id = p_user_id -- marco - 02.06.2013 - changed from user
               AND DECODE (p_iss_param, 1, NVL(a.cred_branch, a.iss_cd), a.iss_cd) = --benjo 10.28.2015 added nvl in cred_branch
                      NVL (p_iss_cd,
                           DECODE (p_iss_param, 1, NVL(a.cred_branch, a.iss_cd), a.iss_cd) --benjo 10.28.2015 added nvl in cred_branch
                          )
               AND a.line_cd = NVL (p_line_cd, a.line_cd)
               AND subline_cd = NVL (p_subline_cd, subline_cd)
               AND assd_no = NVL (p_assd_no, assd_no)
               AND intm_no = NVL (p_intm_no, intm_no)
               AND intm_type = NVL (p_intm_type, intm_type)
               AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                    OR (p_scope = 1 AND endt_seq_no = 0)
                    OR (p_scope = 2 AND endt_seq_no > 0)
                   )
               -- jhing 07.29.2015 removed security rights in the report. Security control is handled in extraction. 
               /* added security rights control by robert 01.02.14*/
              -- AND check_user_per_iss_cd2 (a.line_cd,DECODE (p_iss_param,1, a.cred_branch,a.iss_cd),'GIPIS901A', p_user_id) =1
              -- AND check_user_per_line2 (a.line_cd,DECODE (p_iss_param,1, a.cred_branch,a.iss_cd),'GIPIS901A', p_user_id) = 1
               /* robert 01.02.14 end of added code */
              -- end of commented out code jhing 07.29.2015  
          ORDER BY DECODE (p_iss_param,1,NVL(a.cred_branch,a.iss_cd),a.iss_cd), --benjo 10.28.2015 added nvl in cred_branch
                   a.intm_type,
                   a.intm_no,
                   a.line_cd,
                   subline_cd,
                   issue_yy,
                   pol_seq_no,
                   renew_no,
                   endt_seq_no)
      LOOP
         v_report.assd_no := i.assd_no;
         v_report.assd_name := i.assd_name;
         v_report.line_cd := i.line_cd;
         v_report.line_name := i.line_name;
         v_report.subline_cd := i.subline_cd;
         v_report.subline_name := i.subline_name;
         v_report.iss_cd := i.iss_cd;
         v_report.iss_cd2 := i.iss_cd2;
         v_report.issue_yy := i.issue_yy;
         v_report.pol_seq_no := i.pol_seq_no;
         v_report.renew_no := i.renew_no;
         v_report.endt_iss_cd := i.endt_iss_cd;
         v_report.endt_yy := i.endt_yy;
         v_report.endt_seq_no := i.endt_seq_no;
         v_report.incept_date := i.incept_date;
         v_report.expiry_date := i.expiry_date;
         v_report.total_tsi := i.total_tsi;
         v_report.total_prem := i.total_prem;
         v_report.evatprem := i.evatprem;
         v_report.lgt := i.lgt;
         v_report.doc_stamps := i.doc_stamps;
         v_report.fst := i.fst;
         v_report.other_taxes := i.other_taxes;
         v_report.other_charges := i.other_charges;
         v_report.param_date := i.param_date;
         v_report.from_date := i.from_date;
         v_report.TO_DATE := i.TO_DATE;
         v_report.SCOPE := i.SCOPE;
         v_report.user_id := i.user_id;
         v_report.intm_no := i.intm_no;
         v_report.intm_name := i.intm_no || '-' || i.intm_name;
         v_report.intm_type := i.intm_type;
         v_report.iss_name := gipir923b_pkg.cf_iss_nameformula (i.iss_cd);
         v_report.intm_desc :=
                              gipir923b_pkg.cf_intm_descformula (i.intm_type);
         v_report.commission := i.commission  ;   --- jhing 07.29.2015 replaced with: 
            /*gipir923b_pkg.cf_new_commissionformula (i.intm_no,
                                                    i.intm_type,
                                                    p_iss_param,
                                                    i.iss_cd,
                                                    i.line_cd,
                                                    i.subline_cd,
                                                    i.SCOPE,
                                                    i.user_id
                                                   );*/ 
         v_report.policy_id := i.policy_id;
         v_report.policy_no :=
            gipir923b_pkg.cf_policy_noformula (i.subline_cd,
                                               i.line_cd,
                                               i.iss_cd2, --i.iss_cd --replaced by john 12-21-2015;;0021060: UW Prod Report Printing Error #2
                                               i.issue_yy,
                                               i.pol_seq_no,
                                               i.renew_no,
                                               i.endt_iss_cd,
                                               i.endt_yy,
                                               i.endt_seq_no,
                                               i.incept_date,
                                               i.expiry_date,
                                               i.policy_id
                                              );
         v_report.total := i.total;
         v_report.prem_share_amt := i.prem_share_amt;
         v_report.ref_inv_no := i.ref_inv_no;
         
         IF GIISP.V('PRD_POL_CNT') = '1' THEN
            v_report.pol_count := 1;
         ELSIF GIISP.V('PRD_POL_CNT') = '2' THEN 
            IF i.endt_seq_no > 0  AND i.endt_seq_no <> NULL THEN
                v_report.pol_count := 0;
            ELSE 
                v_report.pol_count := 1;
            END IF;
         ELSIF NVL(GIISP.V('PRD_POL_CNT'), 1) = '3' THEN
            -- Edited by MarkS 7.4.2016 SR-21060
            IF i.endt_seq_no != 0 THEN
                FOR j IN (
                SELECT   rownum,a.assd_no, a.assd_name, a.line_cd, a.line_name,
                   a.subline_cd, a.subline_name,
                   DECODE (p_iss_param, 1, NVL(a.cred_branch, a.iss_cd) , a.iss_cd) iss_cd,  -- jhing 07.29.2015 added NVL
                   a.iss_cd iss_cd2, a.issue_yy, a.pol_seq_no, a.renew_no,
                   a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.incept_date,
                   a.expiry_date, a.total_tsi, a.total_prem, a.evatprem,
                   a.lgt, a.doc_stamps, a.fst, a.other_taxes,
                   a.other_charges, a.param_date, a.from_date, a.TO_DATE,
                   a.SCOPE, a.user_id, a.policy_id, a.intm_name, a.intm_no,
                     a.total_prem
                   + a.evatprem
                   + a.lgt
                   + a.doc_stamps
                   + a.fst
                   + a.other_taxes total,
                   /*b.commission commission*/ a.comm_amt commission, /*b.ref_inv_no*/  -- jhing 07.29.2015 FGICWEB 17728 replaced with:   
                             a.iss_cd
                             || '-'
                             || a.prem_seq_no
                             || DECODE (NVL (a.ref_inv_no, ' '),
                                        ' ', ' ',
                                        ' / ' || a.ref_inv_no
                                       ) ref_inv_no, a.intm_type,
                   a.prem_share_amt
                FROM gipi_uwreports_intm_ext a /*,   -- jhing 07.29.2015 commented out 
                   (SELECT   c.policy_id,
                             SUM
                                (DECODE (c.ri_comm_amt * c.currency_rt,
                                         0, NVL (  b.commission_amt
                                                 * c.currency_rt,
                                                 0
                                                ),
                                         c.ri_comm_amt * c.currency_rt
                                        )
                                ) commission,
                                c.iss_cd
                             || '-'
                             || c.prem_seq_no
                             || DECODE (NVL (ref_inv_no, ' '),
                                        ' ', ' ',
                                        ' / ' || ref_inv_no
                                       ) ref_inv_no
                        FROM gipi_comm_invoice b, gipi_invoice c
                       WHERE b.policy_id = c.policy_id
                    GROUP BY c.policy_id,
                                c.iss_cd
                             || '-'
                             || c.prem_seq_no
                             || DECODE (NVL (ref_inv_no, ' '),
                                        ' ', ' ',
                                        ' / ' || ref_inv_no
                                       )) b
             WHERE a.policy_id = b.policy_id(+) */ 
               WHERE 1 = 1 
               AND a.user_id = p_user_id -- marco - 02.06.2013 - changed from user
               AND DECODE (p_iss_param, 1, NVL(a.cred_branch, a.iss_cd), a.iss_cd) = --benjo 10.28.2015 added nvl in cred_branch
                      NVL (p_iss_cd,
                           DECODE (p_iss_param, 1, NVL(a.cred_branch, a.iss_cd), a.iss_cd) --benjo 10.28.2015 added nvl in cred_branch
                          )
               AND a.line_cd = NVL (p_line_cd, a.line_cd)
               AND subline_cd = NVL (p_subline_cd, subline_cd)
               AND assd_no = NVL (p_assd_no, assd_no)
               AND intm_no = NVL (p_intm_no, intm_no)
               AND intm_type = NVL (p_intm_type, intm_type)
               AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                    OR (p_scope = 1 AND endt_seq_no = 0)
                    OR (p_scope = 2 AND endt_seq_no > 0)
                   )
               -- jhing 07.29.2015 removed security rights in the report. Security control is handled in extraction. 
               /* added security rights control by robert 01.02.14*/
              -- AND check_user_per_iss_cd2 (a.line_cd,DECODE (p_iss_param,1, a.cred_branch,a.iss_cd),'GIPIS901A', p_user_id) =1
              -- AND check_user_per_line2 (a.line_cd,DECODE (p_iss_param,1, a.cred_branch,a.iss_cd),'GIPIS901A', p_user_id) = 1
               /* robert 01.02.14 end of added code */
              -- end of commented out code jhing 07.29.2015  
          ORDER BY DECODE (p_iss_param,1,NVL(a.cred_branch,a.iss_cd),a.iss_cd), --benjo 10.28.2015 added nvl in cred_branch
                   a.intm_type,
                   a.intm_no,
                   a.line_cd,
                   subline_cd,
                   issue_yy,
                   pol_seq_no,
                   renew_no,
                   endt_seq_no
            )
            LOOP
                IF j.endt_seq_no = 0 THEN
                    IF i.line_cd =  j.line_cd AND
                       i.subline_cd = j.subline_cd AND
                       i.issue_yy = j.issue_yy AND
                       i.pol_seq_no = j.pol_seq_no AND
                       i.renew_no = j.renew_no AND
                       i.endt_seq_no = j.endt_seq_no AND
                       i.iss_cd = j.iss_cd AND
                       check_unique_policy(i.policy_id,j.policy_id) = 'F' THEN
                           
                        v_report.pol_count := 1;
                    ELSE
                        v_report.pol_count := 0;
                    END IF;
                ELSE
                    v_report.pol_count := 0;
                END IF;
            END LOOP;                   
            ELSE
                v_report.pol_count := 1;
            END IF;
            
         
        ELSE
             v_report.pol_count := 1;
            -- END SR-21060
--           SELECT COUNT(*)
--             INTO v_count
--             FROM gipi_uwreports_intm_ext x
--            WHERE x.user_id = p_user_id
--              AND DECODE (p_iss_param, 1, NVL (x.cred_branch, x.iss_cd), x.iss_cd) =
--                     NVL (p_iss_cd,
--                          DECODE (p_iss_param, 1, NVL (cred_branch, iss_cd), iss_cd)
--                         )
--              AND line_cd = NVL (p_line_cd, line_cd)
--              AND subline_cd = NVL (p_subline_cd, subline_cd)
--              AND assd_no = NVL (p_assd_no, assd_no)
--              AND intm_no = NVL (p_intm_no, intm_no)
--              AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
--                   OR (p_scope = 1 AND endt_seq_no = 0)
--                   OR (p_scope = 2 AND endt_seq_no > 0)
--                  )
--              AND ISS_CD = i.iss_cd
--              AND ISSUE_YY = i.issue_yy
--              AND POL_SEQ_NO = i.pol_seq_no
--              AND RENEW_NO = i.renew_no;
--              
--            IF v_count > 1 THEN
--                IF i.endt_seq_no = 0 THEN
--                    v_report.pol_count := 1;
--                ELSE 
--                    v_report.pol_count := 0;
--                END IF;
--            ELSE
--                v_report.pol_count := 1;
--            END IF;   
                  
         END IF;
         
         -- intermediary type totals     
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
         -- jhing 07.29.2015 commented out original codes for the totals FGICWEB 17728
         /* v_report.total_polcount_intm :=
            gipir923b_pkg.cf_intm_type_totalsformula (p_intm_no,
                                                      p_assd_no,
                                                      i.SCOPE,
                                                      p_subline_cd,
                                                      p_line_cd,
                                                      i.iss_cd2,
                                                      i.iss_cd,
                                                      p_iss_param,
                                                      i.intm_type,
                                                      'POLCOUNT',
                                                      i.user_id
                                                     );
         v_report.total_polcount_branch :=
            gipir923b_pkg.cf_branch_totalsformula (p_intm_no,
                                                   p_assd_no,
                                                   i.SCOPE,
                                                   p_subline_cd,
                                                   p_line_cd,
                                                   i.iss_cd2,
                                                   i.iss_cd,
                                                   p_iss_param,
                                                   p_intm_type,
                                                   'POLCOUNT',
                                                   i.user_id
                                                  );
         v_report.total_polcount_grand :=
            gipir923b_pkg.cf_grand_totalsformula (p_intm_no,
                                                  p_assd_no,
                                                  i.SCOPE,
                                                  p_subline_cd,
                                                  p_line_cd,
                                                  i.iss_cd2,
                                                  p_iss_cd,
                                                  p_iss_param,
                                                  p_intm_type,
                                                  'POLCOUNT',
                                                  i.user_id
                                                 );
         v_report.total_intm_tsi :=
            gipir923b_pkg.cf_intm_type_totalsformula (p_intm_no,
                                                      p_assd_no,
                                                      i.SCOPE,
                                                      p_subline_cd,
                                                      p_line_cd,
                                                      i.iss_cd2,
                                                      i.iss_cd,
                                                      p_iss_param,
                                                      i.intm_type,
                                                      'TSI',
                                                      i.user_id
                                                     );
         v_report.total_branch_tsi :=
            gipir923b_pkg.cf_branch_totalsformula (p_intm_no,
                                                   p_assd_no,
                                                   i.SCOPE,
                                                   p_subline_cd,
                                                   p_line_cd,
                                                   i.iss_cd2,
                                                   i.iss_cd,
                                                   p_iss_param,
                                                   p_intm_type,
                                                   'TSI',
                                                   i.user_id
                                                  );
         v_report.total_grand_tsi :=
            gipir923b_pkg.cf_grand_totalsformula (p_intm_no,
                                                  p_assd_no,
                                                  i.SCOPE,
                                                  p_subline_cd,
                                                  p_line_cd,
                                                  i.iss_cd2,
                                                  p_iss_cd,
                                                  p_iss_param,
                                                  p_intm_type,
                                                  'TSI',
                                                  i.user_id
                                                 );
         v_report.total_intm_prem :=
            gipir923b_pkg.cf_intm_type_totalsformula (p_intm_no,
                                                      p_assd_no,
                                                      i.SCOPE,
                                                      p_subline_cd,
                                                      p_line_cd,
                                                      i.iss_cd2,
                                                      i.iss_cd,
                                                      p_iss_param,
                                                      i.intm_type,
                                                      'PREM',
                                                      i.user_id
                                                     );
         v_report.total_branch_prem :=
            gipir923b_pkg.cf_branch_totalsformula (p_intm_no,
                                                   p_assd_no,
                                                   i.SCOPE,
                                                   p_subline_cd,
                                                   p_line_cd,
                                                   i.iss_cd2,
                                                   i.iss_cd,
                                                   p_iss_param,
                                                   p_intm_type,
                                                   'PREM',
                                                   i.user_id
                                                  );
         v_report.total_grand_prem :=
            gipir923b_pkg.cf_grand_totalsformula (p_intm_no,
                                                  p_assd_no,
                                                  i.SCOPE,
                                                  p_subline_cd,
                                                  p_line_cd,
                                                  i.iss_cd2,
                                                  p_iss_cd,
                                                  p_iss_param,
                                                  p_intm_type,
                                                  'PREM',
                                                  i.user_id
                                                 );
         v_report.total_intm_evatprem :=
            gipir923b_pkg.cf_intm_type_totalsformula (p_intm_no,
                                                      p_assd_no,
                                                      i.SCOPE,
                                                      p_subline_cd,
                                                      p_line_cd,
                                                      i.iss_cd2,
                                                      i.iss_cd,
                                                      p_iss_param,
                                                      i.intm_type,
                                                      'EVATPREM',
                                                      i.user_id
                                                     );
         v_report.total_branch_evatprem :=
            gipir923b_pkg.cf_branch_totalsformula (p_intm_no,
                                                   p_assd_no,
                                                   i.SCOPE,
                                                   p_subline_cd,
                                                   p_line_cd,
                                                   i.iss_cd2,
                                                   i.iss_cd,
                                                   p_iss_param,
                                                   p_intm_type,
                                                   'EVATPREM',
                                                   i.user_id
                                                  );
         v_report.total_grand_evatprem :=
            gipir923b_pkg.cf_grand_totalsformula (p_intm_no,
                                                  p_assd_no,
                                                  i.SCOPE,
                                                  p_subline_cd,
                                                  p_line_cd,
                                                  i.iss_cd2,
                                                  p_iss_cd,
                                                  p_iss_param,
                                                  p_intm_type,
                                                  'EVATPREM',
                                                  i.user_id
                                                 );
         v_report.total_intm_lgt :=
            gipir923b_pkg.cf_intm_type_totalsformula (p_intm_no,
                                                      p_assd_no,
                                                      i.SCOPE,
                                                      p_subline_cd,
                                                      p_line_cd,
                                                      i.iss_cd2,
                                                      i.iss_cd,
                                                      p_iss_param,
                                                      i.intm_type,
                                                      'LGT',
                                                      i.user_id
                                                     );
         v_report.total_branch_lgt :=
            gipir923b_pkg.cf_branch_totalsformula (p_intm_no,
                                                   p_assd_no,
                                                   i.SCOPE,
                                                   p_subline_cd,
                                                   p_line_cd,
                                                   i.iss_cd2,
                                                   i.iss_cd,
                                                   p_iss_param,
                                                   p_intm_type,
                                                   'LGT',
                                                   i.user_id
                                                  );
         v_report.total_grand_lgt :=
            gipir923b_pkg.cf_grand_totalsformula (p_intm_no,
                                                  p_assd_no,
                                                  i.SCOPE,
                                                  p_subline_cd,
                                                  p_line_cd,
                                                  i.iss_cd2,
                                                  p_iss_cd,
                                                  p_iss_param,
                                                  p_intm_type,
                                                  'LGT',
                                                  i.user_id
                                                 );
         v_report.total_intm_doc :=
            gipir923b_pkg.cf_intm_type_totalsformula (p_intm_no,
                                                      p_assd_no,
                                                      i.SCOPE,
                                                      p_subline_cd,
                                                      p_line_cd,
                                                      i.iss_cd2,
                                                      i.iss_cd,
                                                      p_iss_param,
                                                      i.intm_type,
                                                      'DOC_STAMPS',
                                                      i.user_id
                                                     );
         v_report.total_branch_doc :=
            gipir923b_pkg.cf_branch_totalsformula (p_intm_no,
                                                   p_assd_no,
                                                   i.SCOPE,
                                                   p_subline_cd,
                                                   p_line_cd,
                                                   i.iss_cd2,
                                                   i.iss_cd,
                                                   p_iss_param,
                                                   p_intm_type,
                                                   'DOC_STAMPS',
                                                   i.user_id
                                                  );
         v_report.total_grand_doc :=
            gipir923b_pkg.cf_grand_totalsformula (p_intm_no,
                                                  p_assd_no,
                                                  i.SCOPE,
                                                  p_subline_cd,
                                                  p_line_cd,
                                                  i.iss_cd2,
                                                  p_iss_cd,
                                                  p_iss_param,
                                                  p_intm_type,
                                                  'DOC_STAMPS',
                                                  i.user_id
                                                 );
         v_report.total_intm_fst :=
            gipir923b_pkg.cf_intm_type_totalsformula (p_intm_no,
                                                      p_assd_no,
                                                      i.SCOPE,
                                                      p_subline_cd,
                                                      p_line_cd,
                                                      i.iss_cd2,
                                                      i.iss_cd,
                                                      p_iss_param,
                                                      i.intm_type,
                                                      'FST',
                                                      i.user_id
                                                     );
         v_report.total_branch_fst :=
            gipir923b_pkg.cf_branch_totalsformula (p_intm_no,
                                                   p_assd_no,
                                                   i.SCOPE,
                                                   p_subline_cd,
                                                   p_line_cd,
                                                   i.iss_cd2,
                                                   i.iss_cd,
                                                   p_iss_param,
                                                   p_intm_type,
                                                   'FST',
                                                   i.user_id
                                                  );
         v_report.total_grand_fst :=
            gipir923b_pkg.cf_grand_totalsformula (p_intm_no,
                                                  p_assd_no,
                                                  i.SCOPE,
                                                  p_subline_cd,
                                                  p_line_cd,
                                                  i.iss_cd2,
                                                  p_iss_cd,
                                                  p_iss_param,
                                                  p_intm_type,
                                                  'FST',
                                                  i.user_id
                                                 );
         v_report.total_intm_other :=
            gipir923b_pkg.cf_intm_type_totalsformula (p_intm_no,
                                                      p_assd_no,
                                                      i.SCOPE,
                                                      p_subline_cd,
                                                      p_line_cd,
                                                      i.iss_cd2,
                                                      i.iss_cd,
                                                      p_iss_param,
                                                      i.intm_type,
                                                      'OTHER',
                                                      i.user_id
                                                     );
         v_report.total_branch_other :=
            gipir923b_pkg.cf_branch_totalsformula (p_intm_no,
                                                   p_assd_no,
                                                   i.SCOPE,
                                                   p_subline_cd,
                                                   p_line_cd,
                                                   i.iss_cd2,
                                                   i.iss_cd,
                                                   p_iss_param,
                                                   p_intm_type,
                                                   'OTHER',
                                                   i.user_id
                                                  );
         v_report.total_grand_other :=
            gipir923b_pkg.cf_grand_totalsformula (p_intm_no,
                                                  p_assd_no,
                                                  i.SCOPE,
                                                  p_subline_cd,
                                                  p_line_cd,
                                                  i.iss_cd2,
                                                  p_iss_cd,
                                                  p_iss_param,
                                                  p_intm_type,
                                                  'OTHER',
                                                  i.user_id
                                                 );
         v_report.total_intm_amtdue :=
            gipir923b_pkg.cf_intm_type_totalsformula (p_intm_no,
                                                      p_assd_no,
                                                      i.SCOPE,
                                                      p_subline_cd,
                                                      p_line_cd,
                                                      i.iss_cd2,
                                                      i.iss_cd,
                                                      p_iss_param,
                                                      i.intm_type,
                                                      'AMTDUE',
                                                      i.user_id
                                                     );
         v_report.total_branch_amtdue :=
            gipir923b_pkg.cf_branch_totalsformula (p_intm_no,
                                                   p_assd_no,
                                                   i.SCOPE,
                                                   p_subline_cd,
                                                   p_line_cd,
                                                   i.iss_cd2,
                                                   i.iss_cd,
                                                   p_iss_param,
                                                   p_intm_type,
                                                   'AMTDUE',
                                                   i.user_id
                                                  );
         v_report.total_grand_amtdue :=
            gipir923b_pkg.cf_grand_totalsformula (p_intm_no,
                                                  p_assd_no,
                                                  i.SCOPE,
                                                  p_subline_cd,
                                                  p_line_cd,
                                                  i.iss_cd2,
                                                  p_iss_cd,
                                                  p_iss_param,
                                                  p_intm_type,
                                                  'AMTDUE',
                                                  i.user_id
                                                 ); */
         PIPE ROW (v_report);
      END LOOP;
   END populate_gipir923b;

-- ------------------------------------------------------------------------------------------------
/*
   (2)
   FUNCTION TO GET HEADER
   INCLUDES:
      COMPANY NAME
      COMPANY ADDRESS
      HEADING3
      BASED_ON
*/
   FUNCTION get_header_gipir923b (
      p_scope     gipi_uwreports_intm_ext.SCOPE%TYPE,
      p_user_id   gipi_uwreports_intm_ext.user_id%TYPE
   )
      RETURN header_tab PIPELINED
   AS
      v_report   header_type;
   BEGIN
      v_report.cf_company := gipir923b_pkg.cf_companyformula;
      v_report.cf_company_address := gipir923b_pkg.cf_company_addressformula;
      v_report.cf_heading3 := gipir923b_pkg.cf_heading3formula (p_user_id);
      v_report.cf_based_on :=
                        gipir923b_pkg.cf_based_onformula (p_user_id, p_scope);
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
       WHERE UPPER (param_name) = 'COMPANY_NAME';

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
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   FUNCTION cf_heading3formula (
      p_user_id   gipi_uwreports_intm_ext.user_id%TYPE
   )
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

      IF v_param_date IN (1, 2, 4)
      THEN
         IF v_from_date = v_to_date
         THEN
            heading3 := 'For ' || TO_CHAR (v_from_date, 'fmMonth dd, yyyy');
         ELSE
            heading3 :=
                  'For the Period of '
               || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
               || ' to '
               || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
         END IF;
      ELSE
         IF TO_CHAR (v_from_date, 'MMYYYY') = TO_CHAR (v_to_date, 'MMYYYY')
         THEN
            heading3 :=
                'For the Month of ' || TO_CHAR (v_from_date, 'fmMonth, yyyy');
         ELSE
            heading3 :=
                  'For the Period of '
               || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
               || ' to '
               || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
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

      IF v_param_date = 1
      THEN
         v_based_on := 'Based on Issue Date';
      ELSIF v_param_date = 2
      THEN
         v_based_on := 'Based on Inception Date';
      ELSIF v_param_date = 3
      THEN
         v_based_on := 'Based on Booking month - year';
      ELSIF v_param_date = 4
      THEN
         v_based_on := 'Based on Acctg Entry Date';
      END IF;

      v_scope := p_scope;

      IF v_scope = 1
      THEN
         v_policy_label := v_based_on || ' / ' || 'Policy Only';
      ELSIF v_scope = 2
      THEN
         v_policy_label := v_based_on || ' / ' || 'Endorsement Only';
      ELSIF v_scope = 3
      THEN
         v_policy_label := v_based_on || ' / ' || 'Policies and Endorsements';
      END IF;

      RETURN (v_policy_label);
   END;

-- ------------------------------------------------------------------------------------------------

   -- ------------------------------------------------------------------------------------------------

   /*
      (3 -4)
         FUNCTION TO GET ISS_CD + ISS_NAME
   */
   FUNCTION cf_iss_nameformula (p_iss_cd giis_issource.iss_cd%TYPE)
      RETURN CHAR
   IS
      v_iss_name   VARCHAR2 (50);
   BEGIN
      BEGIN
         SELECT iss_name
           INTO v_iss_name
           FROM giis_issource
          WHERE iss_cd = p_iss_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            NULL;
      END;

      RETURN (p_iss_cd || ' - ' || v_iss_name);
   END;

-- ------------------------------------------------------------------------------------------------

   -- ------------------------------------------------------------------------------------------------

   /*
      (5)



   */
   FUNCTION cf_intm_descformula (p_intm_type giis_intm_type.intm_type%TYPE)
      RETURN CHAR
   IS
      v_intm_desc   VARCHAR2 (50);
   BEGIN
      SELECT intm_desc
        INTO v_intm_desc
        FROM giis_intm_type
       WHERE intm_type = p_intm_type;

      RETURN (v_intm_desc);
   END;

-- ------------------------------------------------------------------------------------------------

   -- ------------------------------------------------------------------------------------------------

   /*
      (6)


   */
   FUNCTION cf_new_commissionformula (
      p_intm_no      gipi_uwreports_intm_ext.intm_no%TYPE,
      p_intm_type    gipi_uwreports_intm_ext.intm_type%TYPE,
      p_iss_param    gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_iss_cd       gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_line_cd      gipi_uwreports_intm_ext.line_cd%TYPE,
      p_subline_cd   gipi_uwreports_intm_ext.subline_cd%TYPE,
      p_scope        gipi_uwreports_intm_ext.SCOPE%TYPE,
      p_user_id      gipi_uwreports_intm_ext.user_id%TYPE
   )
      RETURN NUMBER
   IS
      v_to_date          DATE;
      v_fund_cd          giac_new_comm_inv.fund_cd%TYPE;
      v_branch_cd        giac_new_comm_inv.branch_cd%TYPE;
      v_commission       NUMBER (20, 2);
      v_commission_amt   NUMBER (20, 2);
      v_comm_amt         NUMBER (20, 2);
   BEGIN
      SELECT DISTINCT TO_DATE
                 INTO v_to_date
                 FROM gipi_uwreports_intm_ext
                WHERE user_id = p_user_id;

      v_fund_cd := giacp.v ('FUND_CD');
      v_branch_cd := giacp.v ('BRANCH_CD');

      FOR rc IN (SELECT b.intrmdry_intm_no, b.iss_cd, b.prem_seq_no,
                        c.ri_comm_amt, c.currency_rt, b.commission_amt
                   FROM gipi_comm_invoice b,
                        gipi_invoice c,
                        gipi_uwreports_intm_ext a
                  WHERE a.policy_id = b.policy_id
                    AND a.policy_id = c.policy_id
                    AND a.user_id = p_user_id
                    AND intm_no = p_intm_no
                    AND intm_no = b.intrmdry_intm_no
                    AND intm_type = p_intm_type
                    AND DECODE (p_iss_param, 1, NVL(a.cred_branch, a.iss_cd), a.iss_cd) = --benjo 10.28.2015 added nvl in cred_branch
                                                                      p_iss_cd
                    AND a.line_cd = p_line_cd
                    AND subline_cd = p_subline_cd
                    AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                         OR (p_scope = 1 AND endt_seq_no = 0)
                         OR (p_scope = 2 AND endt_seq_no > 0)
                        ))
      LOOP
         IF (rc.ri_comm_amt * rc.currency_rt) = 0
         THEN
            v_commission_amt := rc.commission_amt;

            FOR c1 IN (SELECT   acct_ent_date, commission_amt, comm_rec_id,
                                intm_no
                           FROM giac_new_comm_inv
                          WHERE iss_cd = rc.iss_cd
                            AND prem_seq_no = rc.prem_seq_no
                            AND fund_cd = v_fund_cd
                            AND branch_cd = v_branch_cd
                            AND tran_flag = 'P'
                            AND NVL (delete_sw, 'N') = 'N'
                       ORDER BY comm_rec_id DESC)
            LOOP
               IF c1.acct_ent_date > v_to_date
               THEN
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

            v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
         ELSE
            v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
         END IF;

         v_commission := NVL (v_commission, 0) + v_comm_amt;
      END LOOP;

      RETURN (v_commission);
   END;

-- ------------------------------------------------------------------------------------------------

   -- ------------------------------------------------------------------------------------------------

   /*
      (7)


   */
   FUNCTION cf_policy_noformula (
      p_subline_cd    gipi_uwreports_intm_ext.subline_cd%TYPE,
      p_line_cd       gipi_uwreports_intm_ext.line_cd%TYPE,
      p_iss_cd        gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_issue_yy      gipi_uwreports_intm_ext.issue_yy%TYPE,
      p_pol_seq_no    gipi_uwreports_intm_ext.pol_seq_no%TYPE,
      p_renew_no      gipi_uwreports_intm_ext.renew_no%TYPE,
      p_endt_iss_cd   gipi_uwreports_intm_ext.endt_iss_cd%TYPE,
      p_endt_yy       gipi_uwreports_intm_ext.endt_yy%TYPE,
      p_endt_seq_no   gipi_uwreports_intm_ext.endt_seq_no%TYPE,
      p_incept_date   gipi_uwreports_intm_ext.incept_date%TYPE,
      p_expiry_date   gipi_uwreports_intm_ext.expiry_date%TYPE,
      p_policy_id     gipi_uwreports_intm_ext.policy_id%TYPE
   )
      RETURN CHAR
   IS
      v_policy_no    VARCHAR2 (150);
      v_endt_no      VARCHAR2 (100);
      v_ref_pol_no   VARCHAR2 (100) := NULL;
   BEGIN
      v_policy_no :=
            p_line_cd
         || '-'
         || p_subline_cd
         || '-'
         || LTRIM (p_iss_cd)
         || '-'
         || LTRIM (TO_CHAR (p_issue_yy, '09'))
         || '-'
         || TO_CHAR (p_pol_seq_no, 'FM0000000')
         || '-'
         || LTRIM (TO_CHAR (p_renew_no, '09'));

      IF p_endt_seq_no <> 0
      THEN
         v_endt_no :=
               p_endt_iss_cd
            || '-'
            || LTRIM (TO_CHAR (p_endt_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (p_endt_seq_no));
      END IF;

      BEGIN
         SELECT ref_pol_no
           INTO v_ref_pol_no
           FROM gipi_polbasic
          WHERE policy_id = p_policy_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF v_ref_pol_no IS NOT NULL
      THEN
         v_ref_pol_no := '/' || v_ref_pol_no;
      END IF;

      RETURN (v_policy_no || ' ' || v_endt_no || v_ref_pol_no);
   END;

-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

   /*

      (8)

   */
   FUNCTION cf_branch_totalsformula (
      p_intm_no          gipi_uwreports_intm_ext.intm_no%TYPE,
      p_assd_no          gipi_uwreports_intm_ext.assd_no%TYPE,
      p_scope            gipi_uwreports_intm_ext.SCOPE%TYPE,
      p_subline_cd       gipi_uwreports_intm_ext.subline_cd%TYPE,
      p_line_cd          gipi_uwreports_intm_ext.line_cd%TYPE,
      p_iss_cd2          gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_iss_cd           gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_iss_param        gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_intm_type        gipi_uwreports_intm_ext.intm_type%TYPE,
      p_column_invoker   VARCHAR2,
      p_user_id          gipi_uwreports_intm_ext.user_id%TYPE
   )
      RETURN NUMBER
   IS
      v_bgrand_tsi_amt       gipi_uwreports_intm_ext.total_tsi%TYPE;
      v_bgrand_prem_amt      gipi_uwreports_intm_ext.total_prem%TYPE;
      v_bgrand_evatprem      gipi_uwreports_intm_ext.evatprem%TYPE;
      v_bgrand_lgt           gipi_uwreports_intm_ext.lgt%TYPE;
      v_bgrand_doc_stamps    gipi_uwreports_intm_ext.doc_stamps%TYPE;
      v_bgrand_fst           gipi_uwreports_intm_ext.fst%TYPE;
      v_bgrand_other_taxes   gipi_uwreports_intm_ext.other_taxes%TYPE;
      v_bgrand_amtdue        gipi_uwreports_intm_ext.total_tsi%TYPE;
      v_bgrand_polcount      NUMBER (4);
      v_result               VARCHAR2 (50);
   BEGIN
      v_bgrand_tsi_amt := 0;
      v_bgrand_prem_amt := 0;
      v_bgrand_evatprem := 0;
      v_bgrand_lgt := 0;
      v_bgrand_doc_stamps := 0;
      v_bgrand_fst := 0;
      v_bgrand_other_taxes := 0;
      v_bgrand_amtdue := 0;
      v_bgrand_polcount := 0;

      FOR x IN (SELECT   total_tsi, total_prem, evatprem, lgt, doc_stamps,
                         fst, other_taxes,
                           total_prem
                         + evatprem
                         + lgt
                         + doc_stamps
                         + fst
                         + other_taxes amtdue,
                         policy_id
                    FROM gipi_uwreports_intm_ext
                   WHERE user_id = p_user_id
                     AND iss_cd = NVL (p_iss_cd2, iss_cd)
                     AND assd_no = NVL (p_assd_no, assd_no)
                     AND intm_no = NVL (p_intm_no, intm_no)
                     AND intm_type = NVL (p_intm_type, intm_type)
                     AND DECODE (p_iss_param, 1, NVL(cred_branch, iss_cd), iss_cd) = --benjo 10.28.2015 added nvl in cred_branch
                            NVL (p_iss_cd,
                                 DECODE (p_iss_param, 1, NVL(cred_branch, iss_cd), iss_cd) --benjo 10.28.2015 added nvl in cred_branch
                                )
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND (   (    3 = NVL (p_scope, 3)
                              AND endt_seq_no = endt_seq_no
                             )
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0)
                         )
                GROUP BY policy_id,
                         total_tsi,
                         total_prem,
                         evatprem,
                         lgt,
                         doc_stamps,
                         fst,
                         other_taxes,
                           total_prem
                         + evatprem
                         + lgt
                         + doc_stamps
                         + fst
                         + other_taxes)
      LOOP
         v_bgrand_tsi_amt := v_bgrand_tsi_amt + x.total_tsi;
         v_bgrand_prem_amt := v_bgrand_prem_amt + x.total_prem;
         v_bgrand_evatprem := v_bgrand_evatprem + x.evatprem;
         v_bgrand_lgt := v_bgrand_lgt + x.lgt;
         v_bgrand_doc_stamps := v_bgrand_doc_stamps + x.doc_stamps;
         v_bgrand_fst := v_bgrand_fst + x.fst;
         v_bgrand_other_taxes := v_bgrand_other_taxes + x.other_taxes;
         v_bgrand_amtdue := v_bgrand_amtdue + x.amtdue;
         v_bgrand_polcount := v_bgrand_polcount + 1;
      END LOOP;

      IF p_column_invoker = 'TSI'
      THEN
         v_result := v_bgrand_tsi_amt;
      ELSIF p_column_invoker = 'PREM'
      THEN
         v_result := v_bgrand_prem_amt;
      ELSIF p_column_invoker = 'EVATPREM'
      THEN
         v_result := v_bgrand_evatprem;
      ELSIF p_column_invoker = 'LGT'
      THEN
         v_result := v_bgrand_lgt;
      ELSIF p_column_invoker = 'DOC_STAMPS'
      THEN
         v_result := v_bgrand_doc_stamps;
      ELSIF p_column_invoker = 'FST'
      THEN
         v_result := v_bgrand_fst;
      ELSIF p_column_invoker = 'OTHER'
      THEN
         v_result := v_bgrand_other_taxes;
      ELSIF p_column_invoker = 'AMTDUE'
      THEN
         v_result := v_bgrand_amtdue;
      ELSIF p_column_invoker = 'POLCOUNT'
      THEN
         v_result := v_bgrand_polcount;
      END IF;

      RETURN (v_result);
   END;

-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
/*

   (9)

*/
   FUNCTION cf_intm_type_totalsformula (
      p_intm_no          gipi_uwreports_intm_ext.intm_no%TYPE,
      p_assd_no          gipi_uwreports_intm_ext.assd_no%TYPE,
      p_scope            gipi_uwreports_intm_ext.SCOPE%TYPE,
      p_subline_cd       gipi_uwreports_intm_ext.subline_cd%TYPE,
      p_line_cd          gipi_uwreports_intm_ext.line_cd%TYPE,
      p_iss_cd2          gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_iss_cd           gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_iss_param        gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_intm_type        gipi_uwreports_intm_ext.intm_type%TYPE,
      p_column_invoker   VARCHAR2,
      p_user_id          gipi_uwreports_intm_ext.user_id%TYPE
   )
      RETURN NUMBER
   IS
      v_bgran_tsi_amt       gipi_uwreports_intm_ext.total_tsi%TYPE;
      v_bgran_prem_amt      gipi_uwreports_intm_ext.total_prem%TYPE;
      v_bgran_evatprem      gipi_uwreports_intm_ext.evatprem%TYPE;
      v_bgran_lgt           gipi_uwreports_intm_ext.lgt%TYPE;
      v_bgran_doc_stamps    gipi_uwreports_intm_ext.doc_stamps%TYPE;
      v_bgran_fst           gipi_uwreports_intm_ext.fst%TYPE;
      v_bgran_other_taxes   gipi_uwreports_intm_ext.other_taxes%TYPE;
      v_bgran_amtdue        gipi_uwreports_intm_ext.total_tsi%TYPE;
      v_bgran_polcount      NUMBER (4);
      v_result              VARCHAR2 (50);
   BEGIN
      v_bgran_tsi_amt := 0;
      v_bgran_prem_amt := 0;
      v_bgran_evatprem := 0;
      v_bgran_lgt := 0;
      v_bgran_doc_stamps := 0;
      v_bgran_fst := 0;
      v_bgran_other_taxes := 0;
      v_bgran_amtdue := 0;
      v_bgran_polcount := 0;

      FOR x IN (SELECT   total_tsi, total_prem, evatprem, lgt, doc_stamps,
                         fst, other_taxes,
                           total_prem
                         + evatprem
                         + lgt
                         + doc_stamps
                         + fst
                         + other_taxes amtdue,
                         policy_id
                    FROM gipi_uwreports_intm_ext
                   WHERE intm_type = NVL (p_intm_type, intm_type)
                     AND iss_cd = NVL (p_iss_cd2, iss_cd)
                     AND user_id = p_user_id
                     AND assd_no = NVL (p_assd_no, assd_no)
                     AND intm_no = NVL (p_intm_no, intm_no)
                     AND DECODE (p_iss_param, 1, NVL(cred_branch, iss_cd), iss_cd) = --benjo 10.28.2015 added nvl in cred_branch
                            NVL (p_iss_cd,
                                 DECODE (p_iss_param, NVL(cred_branch, iss_cd), iss_cd) --benjo 10.28.2015 added nvl in cred_branch
                                )
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND (   (    3 = NVL (p_scope, 3)
                              AND endt_seq_no = endt_seq_no
                             )
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0)
                         )
                GROUP BY policy_id,
                         total_tsi,
                         total_prem,
                         evatprem,
                         lgt,
                         doc_stamps,
                         fst,
                         other_taxes,
                           total_prem
                         + evatprem
                         + lgt
                         + doc_stamps
                         + fst
                         + other_taxes)
      LOOP
         v_bgran_tsi_amt := v_bgran_tsi_amt + x.total_tsi;
         v_bgran_prem_amt := v_bgran_prem_amt + x.total_prem;
         v_bgran_evatprem := v_bgran_evatprem + x.evatprem;
         v_bgran_lgt := v_bgran_lgt + x.lgt;
         v_bgran_doc_stamps := v_bgran_doc_stamps + x.doc_stamps;
         v_bgran_fst := v_bgran_fst + x.fst;
         v_bgran_other_taxes := v_bgran_other_taxes + x.other_taxes;
         v_bgran_amtdue := v_bgran_amtdue + x.amtdue;
         v_bgran_polcount := v_bgran_polcount + 1;
      END LOOP;

      IF p_column_invoker = 'TSI'
      THEN
         v_result := v_bgran_tsi_amt;
      ELSIF p_column_invoker = 'PREM'
      THEN
         v_result := v_bgran_prem_amt;
      ELSIF p_column_invoker = 'EVATPREM'
      THEN
         v_result := v_bgran_evatprem;
      ELSIF p_column_invoker = 'LGT'
      THEN
         v_result := v_bgran_lgt;
      ELSIF p_column_invoker = 'DOC_STAMPS'
      THEN
         v_result := v_bgran_doc_stamps;
      ELSIF p_column_invoker = 'FST'
      THEN
         v_result := v_bgran_fst;
      ELSIF p_column_invoker = 'OTHER'
      THEN
         v_result := v_bgran_other_taxes;
      ELSIF p_column_invoker = 'AMTDUE'
      THEN
         v_result := v_bgran_amtdue;
      ELSIF p_column_invoker = 'POLCOUNT'
      THEN
         v_result := v_bgran_polcount;
      END IF;

      RETURN (v_result);
   END;

-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

   /*
      (10)


   */
   FUNCTION cf_grand_totalsformula (
      p_intm_no          gipi_uwreports_intm_ext.intm_no%TYPE,
      p_assd_no          gipi_uwreports_intm_ext.assd_no%TYPE,
      p_scope            gipi_uwreports_intm_ext.SCOPE%TYPE,
      p_subline_cd       gipi_uwreports_intm_ext.subline_cd%TYPE,
      p_line_cd          gipi_uwreports_intm_ext.line_cd%TYPE,
      p_iss_cd2          gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_iss_cd           gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_iss_param        gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_intm_type        gipi_uwreports_intm_ext.intm_type%TYPE,
      p_column_invoker   VARCHAR2,
      p_user_id          gipi_uwreports_intm_ext.user_id%TYPE
   )
      RETURN NUMBER
   IS
      v_grand_tsi_amt       gipi_uwreports_intm_ext.total_tsi%TYPE;
      v_grand_prem_amt      gipi_uwreports_intm_ext.total_prem%TYPE;
      v_grand_evatprem      gipi_uwreports_intm_ext.evatprem%TYPE;
      v_grand_lgt           gipi_uwreports_intm_ext.lgt%TYPE;
      v_grand_doc_stamps    gipi_uwreports_intm_ext.doc_stamps%TYPE;
      v_grand_fst           gipi_uwreports_intm_ext.fst%TYPE;
      v_grand_other_taxes   gipi_uwreports_intm_ext.other_taxes%TYPE;
      v_grand_amtdue        gipi_uwreports_intm_ext.total_tsi%TYPE;
      v_grand_polcount      NUMBER (4);
      v_result              VARCHAR2 (50);
   BEGIN
      v_grand_tsi_amt := 0;
      v_grand_prem_amt := 0;
      v_grand_evatprem := 0;
      v_grand_lgt := 0;
      v_grand_doc_stamps := 0;
      v_grand_fst := 0;
      v_grand_other_taxes := 0;
      v_grand_amtdue := 0;
      v_grand_polcount := 0;

      FOR x IN (SELECT   total_tsi, total_prem, evatprem, lgt, doc_stamps,
                         fst, other_taxes,
                           total_prem
                         + evatprem
                         + lgt
                         + doc_stamps
                         + fst
                         + other_taxes amtdue,
                         policy_id
                    FROM gipi_uwreports_intm_ext
                   WHERE user_id = p_user_id
                     AND assd_no = NVL (p_assd_no, assd_no)
                     AND intm_no = NVL (p_intm_no, intm_no)
                     AND intm_type = NVL (p_intm_type, intm_type)
                     AND iss_cd = NVL (p_iss_cd, iss_cd)
                     AND DECODE (p_iss_param, 1, NVL(cred_branch, iss_cd), iss_cd) = --benjo 10.28.2015 added nvl in cred_branch
                            NVL (p_iss_cd,
                                 DECODE (p_iss_param, 1, NVL(cred_branch, iss_cd), iss_cd) --benjo 10.28.2015 added nvl in cred_branch
                                )
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND (   (    3 = NVL (p_scope, 3)
                              AND endt_seq_no = endt_seq_no
                             )
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0)
                         )
                GROUP BY policy_id,
                         total_tsi,
                         total_prem,
                         evatprem,
                         lgt,
                         doc_stamps,
                         fst,
                         other_taxes,
                           total_prem
                         + evatprem
                         + lgt
                         + doc_stamps
                         + fst
                         + other_taxes)
      LOOP
         v_grand_tsi_amt := v_grand_tsi_amt + x.total_tsi;
         v_grand_prem_amt := v_grand_prem_amt + x.total_prem;
         v_grand_evatprem := v_grand_evatprem + x.evatprem;
         v_grand_lgt := v_grand_lgt + x.lgt;
         v_grand_doc_stamps := v_grand_doc_stamps + x.doc_stamps;
         v_grand_fst := v_grand_fst + x.fst;
         v_grand_other_taxes := v_grand_other_taxes + x.other_taxes;
         v_grand_amtdue := v_grand_amtdue + x.amtdue;
         v_grand_polcount := v_grand_polcount + 1;
      END LOOP;

      IF p_column_invoker = 'TSI'
      THEN
         v_result := v_grand_tsi_amt;
      ELSIF p_column_invoker = 'PREM'
      THEN
         v_result := v_grand_prem_amt;
      ELSIF p_column_invoker = 'EVATPREM'
      THEN
         v_result := v_grand_evatprem;
      ELSIF p_column_invoker = 'LGT'
      THEN
         v_result := v_grand_lgt;
      ELSIF p_column_invoker = 'DOC_STAMPS'
      THEN
         v_result := v_grand_doc_stamps;
      ELSIF p_column_invoker = 'FST'
      THEN
         v_result := v_grand_fst;
      ELSIF p_column_invoker = 'OTHER'
      THEN
         v_result := v_grand_other_taxes;
      ELSIF p_column_invoker = 'AMTDUE'
      THEN
         v_result := v_grand_amtdue;
      ELSIF p_column_invoker = 'POLCOUNT'
      THEN
         v_result := v_grand_polcount;
      END IF;

      RETURN (v_result);
   END;
   
    FUNCTION get_totals_intmtype (
       p_iss_param     NUMBER,
       p_assd_no       gipi_uwreports_intm_ext.assd_no%TYPE,
       p_intm_no       gipi_uwreports_intm_ext.intm_no%TYPE,
       p_scope         gipi_uwreports_intm_ext.scope%TYPE,
       p_subline_cd    gipi_uwreports_intm_ext.subline_cd%TYPE,
       p_line_cd       gipi_uwreports_intm_ext.line_cd%TYPE,
       p_iss_cd        gipi_uwreports_intm_ext.iss_cd%TYPE,
       p_intm_type     gipi_uwreports_intm_ext.intm_type%TYPE,
       p_user_id       gipi_uwreports_intm_ext.user_id%TYPE)
       RETURN NUMBER
    IS
       v_pol_count   NUMBER := 0;
    BEGIN
       FOR rec
          IN (  SELECT COUNT (DISTINCT a.policy_id) pol_count
                  FROM gipi_uwreports_intm_ext a
                 WHERE     1 = 1
                       AND a.user_id = p_user_id
                       AND a.intm_type = p_intm_type
                       AND DECODE (p_iss_param,
                                   1, NVL (a.cred_branch, a.iss_cd),
                                   a.iss_cd) = p_iss_cd
                       AND a.line_cd = NVL (p_line_cd, a.line_cd)
                       AND subline_cd = NVL (p_subline_cd, subline_cd)
                       AND assd_no = NVL (p_assd_no, assd_no)
                       AND intm_no = NVL (p_intm_no, intm_no)
                       AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                            OR (p_scope = 1 AND endt_seq_no = 0)
                            OR (p_scope = 2 AND endt_seq_no > 0))
              GROUP BY a.intm_type,
                       DECODE (p_iss_param,
                               1, NVL (a.cred_branch, a.iss_cd),
                               a.iss_cd))
       LOOP
          v_pol_count := rec.pol_count;
          EXIT;
       END LOOP;

       RETURN v_pol_count;
    END get_totals_intmtype;    
    
    
    FUNCTION get_totals_branch_amts (
       p_iss_param     NUMBER,
       p_assd_no       gipi_uwreports_intm_ext.assd_no%TYPE,
       p_intm_no       gipi_uwreports_intm_ext.intm_no%TYPE,
       p_scope         gipi_uwreports_intm_ext.scope%TYPE,
       p_subline_cd    gipi_uwreports_intm_ext.subline_cd%TYPE,
       p_line_cd       gipi_uwreports_intm_ext.line_cd%TYPE,
       p_iss_cd        gipi_uwreports_intm_ext.iss_cd%TYPE,
       p_intm_type     gipi_uwreports_intm_ext.intm_type%TYPE,
       p_user_id       gipi_uwreports_intm_ext.user_id%TYPE)
       RETURN NUMBER
    IS
       v_pol_count   NUMBER := 0;
    BEGIN
       FOR rec
          IN (  SELECT COUNT (DISTINCT a.policy_id) pol_count
                  FROM gipi_uwreports_intm_ext a
                 WHERE     1 = 1
                       AND a.user_id = p_user_id
                       AND a.intm_type = NVL(p_intm_type, a.intm_type)
                       AND DECODE (p_iss_param,
                                   1, NVL (a.cred_branch, a.iss_cd),
                                   a.iss_cd) = p_iss_cd
                       AND a.line_cd = NVL (p_line_cd, a.line_cd)
                       AND subline_cd = NVL (p_subline_cd, subline_cd)
                       AND assd_no = NVL (p_assd_no, assd_no)
                       AND intm_no = NVL (p_intm_no, intm_no)
                       AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                            OR (p_scope = 1 AND endt_seq_no = 0)
                            OR (p_scope = 2 AND endt_seq_no > 0))
              GROUP BY DECODE (p_iss_param,
                               1, NVL (a.cred_branch, a.iss_cd),
                               a.iss_cd))
       LOOP
          v_pol_count := rec.pol_count;
          EXIT;
       END LOOP;

       RETURN v_pol_count;
    END get_totals_branch_amts;
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
			SELECT TRUNC(acct_ent_date), TRUNC(incept_date), TRUNC(issue_date)
			  INTO v_acct_ent_date_i, v_incept_date_i, v_issue_date_i
			  FROM gipi_polbasic
			 WHERE policy_id = pol_id_i;
			EXCEPTION
			   WHEN NO_DATA_FOUND or TOO_MANY_ROWS THEN
				 NULL;
	  	END;
        
        BEGIN
			SELECT TRUNC(acct_ent_date), TRUNC(incept_date), TRUNC(issue_date)
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
-- ------------------------------------------------------------------------------------------------
END gipir923b_pkg;
/
