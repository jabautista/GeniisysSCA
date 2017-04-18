CREATE OR REPLACE PACKAGE BODY CPI.GIACS296_PKG
AS

    /** Created By:     Shan Bati
     ** Date Created:   07.02.2013
     ** Referenced By:  GIACS296 - Statement of Account - Outward Facultative Binders
     **/
    
    PROCEDURE extract_records(
        p_as_of_date    IN  DATE,
        p_cut_off_date  IN  DATE,
        p_ri_cd         IN  GIRI_BINDER.RI_CD%type,
        p_line_cd       IN  GIRI_BINDER.LINE_CD%type,
        p_user          IN  GIAC_OUTFACUL_SOA_EXT.USER_ID%type,
        p_count         OUT NUMBER      -- SR-3876, 3879 : shan 08.27.2015
    )
    AS
        v_extract_date   DATE := SYSDATE;
        v_row_counter    PLS_INTEGER := 0;
        v_column_no      PLS_INTEGER := 0;
        v_lprem_amt      giac_outfacul_soa_ext.lprem_amt%TYPE;
        v_lprem_vat      giac_outfacul_soa_ext.lprem_vat%TYPE; 
        v_lcomm_amt      giac_outfacul_soa_ext.lcomm_amt%TYPE;
        v_lcomm_vat      giac_outfacul_soa_ext.lcomm_vat%TYPE;
        v_lwholding_vat  giac_outfacul_soa_ext.lwholding_vat%TYPE;
        v_lnet_due       giac_outfacul_soa_ext.lnet_due%TYPE;
        v_fprem_amt      giac_outfacul_soa_ext.fprem_amt%TYPE;
        v_fprem_vat      giac_outfacul_soa_ext.fprem_vat%TYPE; 
        v_fcomm_amt      giac_outfacul_soa_ext.fcomm_amt%TYPE;
        v_fcomm_vat      giac_outfacul_soa_ext.fcomm_vat%TYPE;
        v_fwholding_vat  giac_outfacul_soa_ext.fwholding_vat%TYPE;
        v_fnet_due       giac_outfacul_soa_ext.fnet_due%TYPE;
        v_balance        giac_outfacul_soa_ext.prem_bal%TYPE;--v1.1
        v_loss_tag       giac_outfacul_soa_ext.loss_tag%TYPE;--v1.1
        v_intm_name      giac_outfacul_soa_ext.intm_name%TYPE;--v1.1
        v_ptax_amount	 NUMBER (12, 2 );                            -- jhing 06/08/2011 -- holds total prem_amt + tax_amt per policy to be used in retrieving balance premium of the policy
        v_collection_amt giac_direct_prem_collns.collection_amt%TYPE;-- jhing 06/08/2011 -- holds total collection per policy to be used in retrieving balance premium of the policy
        --optimization markS SR 5864 1/26.2017
        TYPE GIAC_OUTFACUL_SOA                                                                                                                                                                                            
               IS TABLE OF GIAC_OUTFACUL_SOA_EXT%ROWTYPE
               INDEX BY PLS_INTEGER;
        extrated_SOA GIAC_OUTFACUL_SOA;
      --end opti 
    BEGIN
        DELETE giac_outfacul_soa_ext
         WHERE user_id = P_USER;
         
        FOR rec IN (SELECT a.policy_id,
                           a.subline_cd, a.issue_yy, a.pol_seq_no, a.renew_no, TRUNC(e.eff_date /*e.binder_date --erica080613 PPW should be based on eff_date instead of binder_date*/ ) 
                           + NVL(d.prem_warr_days,0) PPW,
                           (a.line_cd ||'-'|| a.subline_cd ||'-'|| a.iss_cd ||'-' 
                            || ltrim(to_char(a.issue_yy,'09')) ||'-'|| ltrim(to_char(a.pol_seq_no,'0999999'))||to_char(a.renew_no,'09') 
                            || decode(nvl(a.endt_seq_no,0),0, NULL, '-'|| a.endt_iss_cd ||'-' 
                            || ltrim(to_char(a.endt_yy,'09')) ||'-'|| ltrim(to_char(a.endt_seq_no,'099999')) 
                            || a.endt_type ) ) policy_no, 
                           c.currency_cd, 
                           c.currency_rt, 
                           e.ri_cd, 
                           e.fnl_binder_id, 
                           e.line_cd,
                           e.line_cd||'-'||e.binder_yy||'-'||e.binder_seq_no binder_no, 
                           trunc(e.binder_date) binder_date, 
                           trunc(e.eff_date) eff_date, 
                           e.acc_ent_date booking_date, 
                           nvl(e.ri_prem_amt,0) * c.currency_rt - nvl(g.prem_amt,0) lprem_amt,  
                           nvl(e.ri_prem_vat,0) * c.currency_rt - nvl(g.prem_vat,0) lprem_vat, 
                           nvl(e.ri_comm_amt,0) * c.currency_rt - nvl(g.comm_amt,0) lcomm_amt, 
                           nvl(e.ri_comm_vat,0) * c.currency_rt - nvl(g.comm_vat,0) lcomm_vat,  
                           nvl(e.ri_wholding_vat,0) * c.currency_rt - nvl(g.wholding_vat,0) lwholding_vat, 
                           nvl(e.ri_prem_amt,0) - nvl(g.prem_amt,0)/c.currency_rt fprem_amt, 
                           nvl(e.ri_prem_vat,0) - nvl(g.prem_vat,0)/c.currency_rt fprem_vat, 
                           nvl(e.ri_comm_amt,0) - nvl(g.comm_amt,0)/c.currency_rt fcomm_amt, 
                           nvl(e.ri_comm_vat,0) - nvl(g.comm_vat,0)/c.currency_rt fcomm_vat, 
                           nvl(e.ri_wholding_vat,0) - nvl(g.wholding_vat,0)/c.currency_rt fwholding_vat,
                           f.ri_name,
                           --GET_ASSD_NAME(a.assd_no) assd_name--v1.1 --commented out optimization markS SR 5864 1/26.2017
                           --optimization markS SR 5864 1/26.2017
                          (SELECT assd_name
                                         FROM giis_assured
                                     WHERE assd_no = a.assd_no) assd_name,        --v1.1
                                     (SELECT CASE WHEN EXISTS (SELECT null
                                               FROM gicl_claims aa, gipi_polbasic bb
                                              WHERE aa.line_cd     = bb.line_cd
                                                AND aa.subline_cd  = bb.subline_cd
                                                AND aa.pol_iss_cd  = bb.iss_cd
                                                AND aa.issue_yy    = bb.issue_yy
                                                AND aa.pol_seq_no  = bb.pol_seq_no
                                                AND aa.renew_no    = bb.renew_no
                                                AND b.policy_id   = a.policy_id
                                                AND aa.clm_stat_cd NOT IN ('CC','DN','WD')
                                            )
                                    THEN 'Y'
                                    ELSE 'N'
                                    END
                                    FROM dual) loss_tag, --added by MarkS optimizaion SR-5864 1/30/2017 
                                    (
                                        (SELECT SUM(ROUND((NVL(prem_amt , 0) + NVL(tax_amt, 0 )) * nvl(currency_rt, 1 ) , 2)) 
                                                  FROM gipi_invoice 
                                         WHERE policy_id = a.policy_id) - (SELECT NVL(SUM(gdpc.collection_amt),0)
                                                                              FROM giac_acctrans gacc,
                                                                                   giac_direct_prem_collns gdpc ,
                                                                                   gipi_invoice giv
                                                                             WHERE gacc.tran_id             = gdpc.gacc_tran_id
                                                                               AND gdpc.b140_iss_cd         = giv.iss_cd
                                                                               AND gdpc.b140_prem_seq_no    = giv.prem_seq_no
                                                                               AND giv.policy_id            = a.policy_id
                                                                               AND gacc.tran_flag          <> 'D'
                                                                               AND NOT EXISTS(SELECT 1
                                                                                                FROM giac_reversals gr,
                                                                                                     giac_acctrans ga
                                                                                               WHERE gr.reversing_tran_id = ga.tran_id                                 
                                                                                                 AND gr.gacc_tran_id = gdpc.gacc_tran_id   
                                                                                                 AND ga.tran_flag<>'D')   
                                                                               AND trunc(gacc.tran_date) <= p_cut_off_date
                                                                             GROUP BY giv.policy_id)
                                    ) balance --added by MarkS optimizaion SR-5864 1/30/2017 
                           --h.iss_cd, h.prem_seq_no, NVL((h.prem_amt+h.tax_amt)*h.currency_rt,0) ptax_amt--v1.1    -- jhing 06/08/2011 removed from the field list since gipi_invoice is removed from the join 
                      FROM (SELECT d010_fnl_binder_id fnl_binder_id, sum(prem_amt) prem_amt, 
                                   sum(prem_vat) prem_vat, sum(comm_amt) comm_amt, 
                                   sum(comm_vat) comm_vat, sum(wholding_vat) wholding_vat
                              FROM giac_acctrans gacc, giac_outfacul_prem_payts gofp
                             WHERE gacc.tran_id = gofp.gacc_tran_id             
                               AND gacc.tran_flag <> 'D'
                               AND NOT EXISTS(SELECT 1
                                                FROM giac_reversals gr,
                                                     giac_acctrans ga
                                               WHERE gr.reversing_tran_id = ga.tran_id
                                                 AND ga.tran_id = gofp.gacc_tran_id
                                                 AND ga.tran_flag<>'D')
                               -- jhing 06/08/2011 added the condition to remove transactions that are in giac_reversals that causes fully paid binders to have a negative balance
                               -- modification made in relation to FLT PRF 6647 - discrepancies between GIACR296 and GIACR106
                               AND gacc.tran_id NOT IN( SELECT gr.gacc_tran_id                 
                                                          FROM giac_reversals gr,
                                                               giac_acctrans ga    
                                                         WHERE gr.reversing_tran_id = ga.tran_id
                                                           AND gr.gacc_tran_id = gofp.gacc_tran_id
                                                           AND ga.tran_flag<>'D')     
                               -- jhing 06/06/2011   -- end of inserted condition                
                               AND trunc(gacc.tran_date) <= p_cut_off_date
                             GROUP BY d010_fnl_binder_id) g,                             
                           giis_reinsurer f, 
                           gipi_polbasic a, 
                           -- gipi_invoice h,--v1.1   --jhing 06/08/2011 -- removed the table from the join to address discrepancy in FLT 6647 (GIACR106 vs GIACR296) caused by policies with multiple invoices (net due is multiplied by the number of invoices)
                           giuw_pol_dist b, 
                           giri_distfrps c, 
                           giri_frps_ri d, 
                           giri_binder e
                     WHERE 1=1 
                       AND e.fnl_binder_id  = g.fnl_binder_id (+)
                       AND a.policy_id = b.policy_id
                       -- AND a.policy_id = h.policy_id--v1.1   --jhing 06/08/2011 -- removed the condition since gipi_invoice is removed from the join 
                       AND b.dist_no = c.dist_no 
                       AND c.line_cd = d.line_cd 
                       AND c.frps_yy = d.frps_yy 
                       AND c.frps_seq_no = d.frps_seq_no 
                       AND d.fnl_binder_id = e.fnl_binder_id
                       AND d.ri_cd  = NVL(p_ri_cd,d.ri_cd) --alfie 04152010
                       AND e.ri_cd = d.ri_cd --alfie 04152010
                       AND e.ri_cd = f.ri_cd 
                       AND (b.dist_flag NOT IN (4,5) AND d.reverse_sw <> 'Y'AND nvl(e.replaced_flag,'X') <> 'Y')
                       AND trunc(e.eff_date) <= p_as_of_date
                       --AND e.acc_ent_date IS NOT NULL
                       AND e.acc_ent_date <= p_as_of_date --alfie 04152010
                       --AND e.ri_cd = nvl(p_ri_cd,e.ri_cd) 
                       AND e.line_cd = nvl(p_line_cd,e.line_cd)
                       AND EXISTS (SELECT 'X'
                                      FROM TABLE (security_access.get_branch_line ('AC',
                                                                                   'GIACS296',
                                                                                   p_user
                                                                                  )
                                                 )
                                     WHERE branch_cd = a.iss_cd)               --optimization markS SR 5864 1/26.2017
                        --AND check_user_per_iss_cd_acctg2(null, a.iss_cd, 'GIACS296', p_user) = 1 --commented out optimization markS SR 5864 1/26.2017
                        )   /* vondanix 3/19/13 -- Access Rights */
        LOOP     
            v_lprem_amt      := rec.lprem_amt;
            v_lprem_vat      := rec.lprem_vat;
            v_lcomm_amt      := rec.lcomm_amt;
            v_lcomm_vat      := rec.lcomm_vat;
            v_lwholding_vat  := rec.lwholding_vat;
            v_fprem_amt      := rec.fprem_amt;
            v_fprem_vat      := rec.fprem_vat;
            v_fcomm_amt      := rec.fcomm_amt;
            v_fcomm_vat      := rec.fcomm_vat;
            v_fwholding_vat  := rec.fwholding_vat;
            v_lnet_due := (v_lprem_amt + v_lprem_vat) - (v_lcomm_amt + v_lcomm_vat + v_lwholding_vat);
            v_fnet_due := (v_fprem_amt + v_fprem_vat) - (v_fcomm_amt + v_fcomm_vat + v_fwholding_vat);
            
            --v1.1 - (i,ii,iii)
            /* jhing 06/08/2011 -- original query before modification to address issues with policies with multiple invoices (one of the discrepancies in FLT PRF 6647 )
            --modification made to address FLT PRF 6647 
                              
            --i. get the balance premium of the policy
            BEGIN
              SELECT rec.ptax_amt-NVL(SUM(gdpc.collection_amt),0)
                INTO v_balance
                FROM giac_acctrans gacc,
                     giac_direct_prem_collns gdpc
               WHERE gacc.tran_id             = gdpc.gacc_tran_id
                 AND gdpc.b140_iss_cd         = rec.iss_cd
                 AND gdpc.b140_prem_seq_no    = rec.prem_seq_no
                 AND gacc.tran_flag          <> 'D'
                 AND NOT EXISTS(SELECT 1
                                  FROM giac_reversals gr,
                                       giac_acctrans ga
                                 WHERE gr.reversing_tran_id = ga.tran_id
                                   AND ga.tran_id = gdpc.gacc_tran_id
                                   AND ga.tran_flag<>'D')   
                 AND trunc(gacc.tran_date) <= p_cut_off_date
               GROUP BY gdpc.b140_iss_cd, gdpc.b140_prem_seq_no;
            EXCEPTION
              WHEN no_data_found THEN
                v_balance := rec.ptax_amt;
            END;
            */
            
            --jhing 06/08/2011 -- modified --i. get the balance premium of the policy  
            -- modification is made to address discrepancies in the report of GIACR296 and GIACR106 (FLT PRF 6647) caused by policies with multiple invoices
            --optimization markS SR 5864 1/26.2017 moved to main query 
--         BEGIN 
--                -- get tax_amount from invoice 
--                BEGIN 
--                    SELECT SUM(ROUND((NVL(prem_amt , 0) + NVL(tax_amt, 0 )) * nvl(currency_rt, 1 ) , 2)) 
--                      INTO v_ptax_amount 
--                      FROM gipi_invoice 
--                     WHERE policy_id = rec.policy_id ; 
--                END;
--              
--                -- get collection_amt 
--                BEGIN
--                    SELECT NVL(SUM(gdpc.collection_amt),0)
--                      INTO v_collection_amt
--                      FROM giac_acctrans gacc,
--                           giac_direct_prem_collns gdpc ,
--                           gipi_invoice giv
--                     WHERE gacc.tran_id             = gdpc.gacc_tran_id
--                       AND gdpc.b140_iss_cd         = giv.iss_cd
--                       AND gdpc.b140_prem_seq_no    = giv.prem_seq_no
--                       AND giv.policy_id            = rec.policy_id
--                       AND gacc.tran_flag          <> 'D'
--                       AND NOT EXISTS(SELECT 1
--                                        FROM giac_reversals gr,
--                                             giac_acctrans ga
--                                       WHERE gr.reversing_tran_id = ga.tran_id                                 
--                                         --AND ga.tran_id = gdpc.gacc_tran_id   -- jhing 08/02/2011 : FLT PRF 7410 : commented out and replaced with  : 
--                                         AND gr.gacc_tran_id = gdpc.gacc_tran_id  -- to prevent reversed transactions to be retrieved for collection 
--                                         AND ga.tran_flag<>'D')   
--                       AND trunc(gacc.tran_date) <= p_cut_off_date
--                       --Commented out optimization markS SR 5864 1/26.2017
--                       --AND check_user_per_iss_cd_acctg2(null, giv.iss_cd, 'GIACS296', p_user) = 1   /* vondanix 3/19/13 -- Access Rights */
--                     GROUP BY giv.policy_id;
--                EXCEPTION 
--                    WHEN no_data_found THEN 
--                        v_collection_amt := 0 ;
--                END;  
--            
--                v_balance := v_ptax_amount - v_collection_amt ; 
--         END; 
         --optimization markS SR 5864 1/26.2017 moved to main query end    
            --ii. check if the policy has an existing claim
            --optimization markS SR 5864 1/26.2017
--            v_loss_tag := 'N';
--            FOR i IN (SELECT claim_id
--                        FROM gicl_claims a, gipi_polbasic b
--                        --, gipi_invoice c    -- jhing 06/08/2011 -- removed gipi_invoice from the join query due to revisions made to rec cursor in order to prevent policies with multiple invoices to be retrieved multiple times 
--                       WHERE 1=1
--                         AND a.line_cd     = b.line_cd
--                         AND a.subline_cd  = b.subline_cd
--                         AND a.pol_iss_cd  = b.iss_cd
--                         AND a.issue_yy    = b.issue_yy
--                         AND a.pol_seq_no  = b.pol_seq_no
--                         AND a.renew_no    = b.renew_no
--                         --AND b.policy_id   = c.policy_id     --jhing 06/08/2011  -- commented out the condition since gipi_invoice is removed from the join query 
--                         --AND c.iss_cd      = rec.iss_cd      --jhing 06/08/2011  -- commented out the condition since gipi_invoice is removed from the join query 
--                         --AND c.prem_seq_no = rec.prem_seq_no -- jhing 06/08/2011 -- commented out the condition since gipi_invoice is removed from the join query 
--                         AND b.policy_id   = rec.policy_id     -- jhing 06/08/2011 -- added the condition to relate the query to the rec cursor using policy_id
--                         AND a.clm_stat_cd NOT IN ('CC','DN','WD')
--                         --AND check_user_per_iss_cd_acctg2(null, b.iss_cd, 'GIACS296', p_user) = 1
--                         )   /* vondanix 3/19/13 -- Access Rights */
--            LOOP
--                v_loss_tag := 'Y';
--            END LOOP;

--            v_loss_tag := 'N';
            
--            SELECT CASE WHEN EXISTS (SELECT claim_id
--                                       FROM gicl_claims a, gipi_polbasic b
--                                      WHERE a.line_cd     = b.line_cd
--                                        AND a.subline_cd  = b.subline_cd
--                                        AND a.pol_iss_cd  = b.iss_cd
--                                        AND a.issue_yy    = b.issue_yy
--                                        AND a.pol_seq_no  = b.pol_seq_no
--                                        AND a.renew_no    = b.renew_no
--                                        AND b.policy_id   = rec.policy_id
--                                        AND a.clm_stat_cd NOT IN ('CC','DN','WD')
--                                        AND check_user_per_iss_cd_acctg2(null, b.iss_cd, 'GIACS296', p_user) = 1
--                                    )
--                        THEN 'Y'
--                        ELSE 'N'
--                        END
--              INTO v_loss_tag
--              FROM dual;
--optimization markS SR 5864 1/26.2017
            
            --iii. get intermediary name    
            -- JHING 06/08/2011 original query prior to modification  
            /*
            BEGIN
              SELECT GET_INTM_NAME(intrmdry_intm_no)
                INTO v_intm_name
                FROM gipi_comm_invoice a, gipi_invoice b
               WHERE a.policy_id   = b.policy_id
                 AND a.iss_cd      = b.iss_cd
                 AND a.prem_seq_no = b.prem_seq_no
                 AND a.iss_cd       = rec.iss_cd
                 AND a.prem_seq_no  = rec.prem_seq_no;
            EXCEPTION
              WHEN no_data_found THEN
                v_intm_name := '';
            END;
            */ 
            
            --jhing 06/08/2011 modified --iii. get intermediary name
            -- modification is made to address policies with multiple invoices which has a possibility of having multiple intm 
            BEGIN  
                v_intm_name := null;
                FOR c1 in (SELECT DISTINCT GET_INTM_NAME(intrmdry_intm_no) intm_name
                             FROM gipi_comm_invoice a
                            WHERE a.policy_id   = rec.policy_id
                            ORDER BY 1 ) 
                LOOP
                    IF v_intm_name is not null THEN 
                        v_intm_name := v_intm_name || '/' || chr(10) ; 
                        v_intm_name :=  v_intm_name ||  ltrim(rtrim(c1.intm_name)) ;
                    ELSE 
                        v_intm_name := rtrim(ltrim(c1.intm_name));
                    END IF ;   
                END LOOP;      
            EXCEPTION 
                WHEN others THEN                 
                    v_intm_name := '';                 
            END;   
            --jhing 06/08/2011 end of restructured --iii. get intermediary name
            
            --end v1.1
      
            BEGIN
              SELECT column_no
                INTO v_column_no
                FROM giis_report_aging
               WHERE report_id = 'GIACR296'
			     --added by robert SR 20709 11.06.15
			     --added by MarkS SR-22127 copied from SR the solution of mam grace
			     AND (branch_cd IN (
                         SELECT b.grp_iss_cd
                         FROM giis_users a, giis_user_grp_hdr b
                         WHERE a.user_grp = b.user_grp AND a.user_id = p_user) 
                     OR branch_cd IS NULL) -- added by grace
                 --end SR-22127
				 --end robert SR 20709 11.06.15 
                 AND p_cut_off_date - rec.eff_date BETWEEN min_days AND max_days;
            EXCEPTION 
                WHEN no_data_found THEN
                  --RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#No column number found giis_report_aging.'); //replaced by codes below --robert SR 20709 11.06.15
				  RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#E#No setup found in Report Aging Maintenance for this report.');
            END;
            
            IF v_lnet_due != 0 THEN --alfie 04152010
--                INSERT INTO giac_outfacul_soa_ext    
--                    (ri_cd,              ri_name,        line_cd,          policy_id,          policy_no, 
--                     fnl_binder_id,      binder_no,      binder_date,      eff_date,           booking_date, 
--                     lprem_amt,          lprem_vat,      lcomm_amt,        lcomm_vat,          lwholding_vat, 
--                     lnet_due,           fprem_amt,      fprem_vat,        fcomm_amt,          fcomm_vat, 
--                     fwholding_vat,      fnet_due,       as_of_date,       cut_off_date,       user_id, 
--                     extract_date,       column_no,      currency_cd,      currency_rt,
--                     assd_name,          prem_bal,       loss_tag,         intm_name, ppw)--v1.1
--               VALUES         
--                    (rec.ri_cd,          rec.ri_name,    rec.line_cd,      rec.policy_id,      rec.policy_no, 
--                     rec.fnl_binder_id,  rec.binder_no,  rec.binder_date,  rec.eff_date,       rec.booking_date, 
--                     v_lprem_amt,        v_lprem_vat,    v_lcomm_amt,      v_lcomm_vat,        v_lwholding_vat, 
--                     v_lnet_due,         v_fprem_amt,    v_fprem_vat,      v_fcomm_amt,        v_fcomm_vat, 
--                     v_fwholding_vat,    v_fnet_due,     p_as_of_date,     p_cut_off_date,     P_USER, 
--                     v_extract_date,     v_column_no,    rec.currency_cd,  rec.currency_rt,
--                     rec.assd_name,      v_balance,      v_loss_tag,       v_intm_name, rec.ppw);--v1.1
--                     
                
            v_row_counter := v_row_counter + 1;
            extrated_SOA(v_row_counter).ri_cd := rec.ri_cd;
            extrated_SOA(v_row_counter).ri_name := rec.ri_name;
            extrated_SOA(v_row_counter).line_cd := rec.line_cd;
            extrated_SOA(v_row_counter).policy_id := rec.policy_id;
            extrated_SOA(v_row_counter).policy_no := rec.policy_no;
            extrated_SOA(v_row_counter).fnl_binder_id := rec.fnl_binder_id;
            extrated_SOA(v_row_counter).binder_no := rec.binder_no;
            extrated_SOA(v_row_counter).binder_date := rec.binder_date;
            extrated_SOA(v_row_counter).eff_date := rec.eff_date;
            extrated_SOA(v_row_counter).booking_date := rec.booking_date;
            extrated_SOA(v_row_counter).lprem_amt := v_lprem_amt;
            extrated_SOA(v_row_counter).lprem_vat := v_lprem_vat;
            extrated_SOA(v_row_counter).lcomm_amt := v_lcomm_amt;
            extrated_SOA(v_row_counter).lcomm_vat := v_lcomm_vat;
            extrated_SOA(v_row_counter).lwholding_vat := v_lwholding_vat;
            extrated_SOA(v_row_counter).lnet_due := v_lnet_due;
            extrated_SOA(v_row_counter).fprem_amt := v_fprem_amt;
            extrated_SOA(v_row_counter).fprem_vat := v_fprem_vat;
            extrated_SOA(v_row_counter).fcomm_amt := v_fcomm_amt;
            extrated_SOA(v_row_counter).fcomm_vat := v_fcomm_vat;
            extrated_SOA(v_row_counter).fwholding_vat := v_fwholding_vat;
            extrated_SOA(v_row_counter).fnet_due := v_fnet_due;
            extrated_SOA(v_row_counter).fwholding_vat := v_fwholding_vat;
            extrated_SOA(v_row_counter).fnet_due := v_fnet_due;
            extrated_SOA(v_row_counter).as_of_date := p_as_of_date;
            extrated_SOA(v_row_counter).cut_off_date := p_cut_off_date;
            extrated_SOA(v_row_counter).user_id := p_user;
            extrated_SOA(v_row_counter).extract_date := v_extract_date;
            extrated_SOA(v_row_counter).column_no := v_column_no;
            extrated_SOA(v_row_counter).currency_cd := rec.currency_cd;
            extrated_SOA(v_row_counter).currency_rt := rec.currency_rt;
            extrated_SOA(v_row_counter).assd_name := rec.assd_name;
            extrated_SOA(v_row_counter).prem_bal := rec.balance; --v_balance --edited by MarkS SR5864 1/30/2017
            extrated_SOA(v_row_counter).loss_tag := rec.loss_tag; --v_loss_tag; -edited by MarkS SR5864 1/30/2017
            extrated_SOA(v_row_counter).intm_name := v_intm_name;
            extrated_SOA(v_row_counter).ppw := rec.ppw;       
            END IF;
        END LOOP;
          
        /*IF v_row_counter = 0 THEN 
            RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#There were 0 records extracted for the dates specified.');
        ELSE*/
            --RAISE_APPLICATION_ERROR('-20001','Geniisys Exception#I#Extraction finished! '||to_char(v_row_counter)|| ' records extracted.');   -- SR-3876, 3879 : shan 08.27.2015
            FORALL i IN extrated_SOA.first .. extrated_SOA.last
                INSERT INTO giac_outfacul_soa_ext VALUES extrated_SOA(i);
            p_count := v_row_counter;
            
            COMMIT;
        --END IF;
        
    
    END extract_records;
    

END GIACS296_PKG;
/


