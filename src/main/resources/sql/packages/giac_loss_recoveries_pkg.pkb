CREATE OR REPLACE PACKAGE BODY CPI.GIAC_LOSS_RECOVERIES_PKG
AS
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-05-2010 
    **  Reference By : (GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  get records in GIAC_LOSS_RECOVERIES table 
    */    
    FUNCTION get_giac_loss_recoveries(p_gacc_tran_id    giac_loss_recoveries.gacc_tran_id%TYPE)
    RETURN giac_loss_recoveries_tab PIPELINED IS
        v_loss  giac_loss_recoveries_type;
    BEGIN
        FOR rec IN (SELECT a.gacc_tran_id,        a.transaction_type,       a.claim_id,
                           a.recovery_id,         a.payor_class_cd,         a.payor_cd,
                           a.collection_amt,      a.currency_cd,            a.convert_rate,
                           a.foreign_curr_amt,    a.or_print_tag,           a.remarks,
                           a.cpi_rec_no,          a.cpi_branch_cd,          a.user_id,
                           a.last_update,         a.acct_ent_tag
                      FROM giac_loss_recoveries a
                     WHERE a.gacc_tran_id = p_gacc_tran_id)
        LOOP
            v_loss.gacc_tran_id                 := rec.gacc_tran_id;        
            v_loss.transaction_type             := rec.transaction_type;       
            v_loss.claim_id                     := rec.claim_id;  
            v_loss.recovery_id                  := rec.recovery_id;          
            v_loss.payor_class_cd               := rec.payor_class_cd;         
            v_loss.payor_cd                     := rec.payor_cd;  
            v_loss.collection_amt               := rec.collection_amt;    
            v_loss.currency_cd                  := rec.currency_cd;          
            v_loss.convert_rate                 := rec.convert_rate;  
            v_loss.foreign_curr_amt             := rec.foreign_curr_amt;   
            v_loss.or_print_tag                 := rec.or_print_tag;           
            v_loss.remarks                      := rec.remarks;  
            v_loss.cpi_rec_no                   := rec.cpi_rec_no;         
            v_loss.cpi_branch_cd                := rec.cpi_branch_cd;          
            v_loss.user_id                      := rec.user_id;  
            v_loss.last_update                  := rec.last_update;         
            v_loss.acct_ent_tag                 := rec.acct_ent_tag; 
            FOR tran IN (SELECT substr(RV_MEANING,1,15)  RV_MEANING
                           FROM CG_REF_CODES
                          WHERE RV_DOMAIN = 'GIAC_LOSS_RECOVERIES.TRANSACTION_TYPE'
                            AND RV_LOW_VALUE = v_loss.transaction_type)
            LOOP
                v_loss.transaction_type_desc := tran.rv_meaning;
            END LOOP;  
            FOR r IN (SELECT a.line_cd line_cd, a.iss_cd iss_cd, a.rec_year rec_year, a.rec_seq_no rec_seq_no,  
                             b.line_cd line_cd1, b.subline_cd subline_cd1, b.iss_cd iss_cd1, 
                             b.clm_yy clm_yy, b.clm_seq_no clm_seq_no, 
                             b.line_cd line_cd2, b.subline_cd subline_cd2, b.pol_iss_cd pol_iss_cd, 
                             b.issue_yy issue_yy, b.pol_seq_no pol_seq_no, b.renew_no renew_no, 
                             b.dsp_loss_date dsp_loss_date, b.assured_name assured_name, 
                             a.rec_type_cd rec_type_cd, c.rec_type_desc rec_type_desc, 
                             decode(e.payee_first_name, null, e.payee_last_name, 
                                    e.payee_last_name||', '||e.payee_first_name||' '||e.payee_middle_name) payor, 
                             f.class_desc class_desc, h.currency_desc currency_desc
                        FROM gicl_clm_recovery a, gicl_claims b, giis_recovery_type c, gicl_recovery_payor d, 
                             giis_payees e, giis_payee_class f, giis_currency h --,giac_currency g 
                       WHERE a.claim_id = b.claim_id 
                         AND a.rec_type_cd = c.rec_type_cd
                         AND a.recovery_id = d.recovery_id
                         AND a.recovery_id = v_loss.recovery_id
                         AND a.claim_id = v_loss.claim_id 
                         And a.claim_id = b.claim_id  
                         AND d.payor_class_cd = e.payee_class_cd
                         AND d.payor_cd =  e.payee_no
                         AND d.payor_class_cd = v_loss.payor_class_cd
                         AND d.payor_cd = v_loss.payor_cd
                         AND d.payor_class_cd = f.payee_class_cd
                         --AND g.main_currency_cd = h.main_currency_cd       
                         --AND g.main_currency_cd = :glre.currency_cd
                         AND h.main_currency_cd = v_loss.currency_cd)
                      LOOP
                        v_loss.line_cd              := r.line_cd;
                        v_loss.iss_cd               := r.iss_cd;
                        v_loss.rec_year             := r.rec_year;
                        v_loss.rec_seq_no           := to_char(r.rec_seq_no,'009');
                        --v_loss.dsp_line_cd        := r.line_cd1;
                        --v_loss.dsp_subline_cd     := r.subline_cd1;
                        --v_loss.dsp_iss_cd         := r.iss_cd1;
                        --v_loss.dsp_clm_yy         := r.clm_yy;
                        --v_loss.dsp_clm_seq_no     := r.clm_seq_no;
                        v_loss.dsp_claim_no         := r.line_cd1||'-'||r.subline_cd1||'-'||r.iss_cd1||'-'||to_char(r.clm_yy,'09')||'-'||to_char(r.clm_seq_no,'09999');
                        --v_loss.dsp_line_cd1       := r.line_cd2;
                        --v_loss.dsp_subline_cd1    := r.subline_cd2;
                        --v_loss.dsp_pol_iss_cd     := r.pol_iss_cd;
                        --v_loss.dsp_issue_yy       := r.issue_yy;
                        --v_loss.dsp_pol_seq_no     := r.pol_seq_no;
                        --v_loss.dsp_renew_no       := r.renew_no;
                        v_loss.dsp_policy_no        := r.line_cd2||'-'||r.subline_cd2||'-'||r.pol_iss_cd||'-'||to_char(r.issue_yy,'09')||'-'||to_char(r.pol_seq_no,'09999')||'-'||to_char(r.renew_no,'09');     
                        v_loss.dsp_loss_date        := TO_CHAR(r.dsp_loss_date, 'MM-DD-RRRR');  -- shan 06.14.2013 TO_CHAR for PHILFIRE-QA SR-13432
                        v_loss.dsp_assured_name     := r.assured_name;
                        v_loss.rec_type_cd          := r.rec_type_cd;
                        v_loss.rec_type_desc        := r.rec_type_desc;
                        v_loss.payor_name           := r.payor;
                        v_loss.payor_class_desc     := r.class_desc;
                        v_loss.dsp_currency_desc    := r.currency_desc;
                      END LOOP;
        PIPE ROW(v_loss);
        END LOOP;
    RETURN;    
    END;    

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-06-2010 
    **  Reference By : (GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  RECOVERY_TRAN_TYPE1 record group 
    */  
    FUNCTION get_recovery_no_list(p_keyword     VARCHAR,
								  p_user_id 	giis_users.user_id%TYPE)
        RETURN recovery_no_list_tab PIPELINED IS
        v_list      recovery_no_list_type;
    BEGIN
        FOR r IN (SELECT a.line_cd line_cd, a.iss_cd iss_cd, a.rec_year rec_year,
                           TO_CHAR (a.rec_seq_no, '099') rec_seq_no, b.claim_id claim_id,
                           b.line_cd dsp_line_cd, b.subline_cd dsp_subline_cd,
                           b.iss_cd dsp_iss_cd, b.clm_yy dsp_clm_yy, b.clm_seq_no dsp_clm_seq_no,
                           b.line_cd dsp_line_cd1, b.subline_cd dsp_subline_cd1,
                           b.pol_iss_cd dsp_pol_iss_cd, b.issue_yy dsp_issue_yy,
                           b.pol_seq_no dsp_pol_seq_no, b.renew_no dsp_renew_no,
                           b.loss_date dsp_loss_date, b.assured_name dsp_assured_name,
                           a.recovery_id recovery_id, a.rec_type_cd, c.rec_type_desc,
                           d.payor_class_cd, e.class_desc, d.payor_cd,
                           DECODE (f.payee_first_name,
                                   NULL, f.payee_last_name,
                                      f.payee_last_name
                                   || ', '
                                   || f.payee_first_name
                                   || ' '
                                   || f.payee_middle_name
                                  ) payor_name
                      FROM gicl_clm_recovery a,
                           gicl_claims b,
                           giis_recovery_type c,
                           gicl_recovery_payor d,
                           giis_payee_class e,
                           giis_payees f
                     WHERE a.claim_id = b.claim_id
                       AND a.rec_type_cd = c.rec_type_cd
                       AND d.claim_id = a.claim_id
                       AND d.recovery_id = a.recovery_id
                       AND d.payor_class_cd = e.payee_class_cd
                       AND d.payor_cd = f.payee_no
                       AND d.payor_class_cd = f.payee_class_cd
                       AND e.payee_class_cd = f.payee_class_cd
                       AND a.cancel_tag IS NULL
                       AND GIAC_LOSS_RECOVERIES_PKG.check_collection_amt(a.recovery_id, b.claim_id) <> 0
                       AND check_user_per_iss_cd_acctg2(NULL, a.iss_cd, 'GIACS010', p_user_id) = 1)
					        --AND check_user_per_iss_cd2(a.line_cd,a.iss_cd,'GIACS010',p_user_id) = 1) --added by steven 1.26.2013;base on SR 0012042
                       --AND UPPER(b.iss_cd) LIKE NVL(UPPER(p_keyword),b.iss_cd))
        LOOP
            v_list.line_cd              := r.line_cd;
            v_list.iss_cd               := r.iss_cd;
            v_list.rec_year             := r.rec_year;
            v_list.rec_seq_no           := to_char(r.rec_seq_no,'009');
            v_list.claim_id             := r.claim_id;
            --v_loss.dsp_line_cd        := r.line_cd1;
            --v_loss.dsp_subline_cd     := r.subline_cd1;
            --v_loss.dsp_iss_cd         := r.iss_cd1;
            --v_loss.dsp_clm_yy         := r.clm_yy;
            --v_loss.dsp_clm_seq_no     := r.clm_seq_no;
            v_list.dsp_claim_no         := r.dsp_line_cd||'-'||r.dsp_subline_cd||'-'||r.dsp_iss_cd||'-'||to_char(r.dsp_clm_yy,'09')||'-'||to_char(r.dsp_clm_seq_no,'09999');
            --v_loss.dsp_line_cd1       := r.line_cd2;
            --v_loss.dsp_subline_cd1    := r.subline_cd2;
            --v_loss.dsp_pol_iss_cd     := r.pol_iss_cd;
            --v_loss.dsp_issue_yy       := r.issue_yy;
            --v_loss.dsp_pol_seq_no     := r.pol_seq_no;
            --v_loss.dsp_renew_no       := r.renew_no;
            v_list.dsp_policy_no        := r.dsp_line_cd1||'-'||r.dsp_subline_cd1||'-'||r.dsp_pol_iss_cd||'-'||to_char(r.dsp_issue_yy,'09')||'-'||to_char(r.dsp_pol_seq_no,'09999')||'-'||to_char(r.dsp_renew_no,'09');     
            v_list.dsp_loss_date        := r.dsp_loss_date;
            v_list.dsp_assured_name     := r.dsp_assured_name;
            v_list.recovery_id          := r.recovery_id;
            v_list.rec_type_cd          := r.rec_type_cd;
            v_list.rec_type_desc        := r.rec_type_desc;
            v_list.payor_name           := r.payor_name;
            v_list.payor_cd             := r.payor_cd;
            v_list.payor_class_desc     := r.class_desc;
            v_list.payor_class_cd       := r.payor_class_cd;
            --v_list.dsp_currency_desc    := r.currency_desc;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;                       
    END;
    
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-06-2010 
    **  Reference By : (GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  RECOVERY_TRAN_TYPE2 record group 
    */       
    FUNCTION get_recovery_no_list2(p_keyword    VARCHAR,
								   p_user_id 	giis_users.user_id%TYPE)
        RETURN recovery_no_list_tab PIPELINED IS
        v_list      recovery_no_list_type;
    BEGIN
        FOR r IN (SELECT a.line_cd line_cd, a.iss_cd iss_cd, a.rec_year rec_year,
                         TO_CHAR (a.rec_seq_no, '099') rec_seq_no, b.claim_id claim_id,
                         b.line_cd dsp_line_cd, b.subline_cd dsp_subline_cd,
                         b.iss_cd dsp_iss_cd, b.clm_yy dsp_clm_yy, b.clm_seq_no dsp_clm_seq_no,
                         b.line_cd dsp_line_cd1, b.subline_cd dsp_subline_cd1,
                         b.pol_iss_cd dsp_pol_iss_cd, b.issue_yy dsp_issue_yy,
                         b.pol_seq_no dsp_pol_seq_no, b.renew_no dsp_renew_no,
                         b.loss_date dsp_loss_date, b.assured_name dsp_assured_name,
                         a.recovery_id recovery_id, a.rec_type_cd, c.rec_type_desc,
                         d.payor_class_cd, e.class_desc, d.payor_cd,
                         DECODE (f.payee_first_name,
                                 NULL, f.payee_last_name,
                                    f.payee_last_name
                                 || ', '
                                 || f.payee_first_name
                                 || ' '
                                 || f.payee_middle_name
                                ) payor_name
                    FROM gicl_clm_recovery a,
                         gicl_claims b,
                         giis_recovery_type c,
                         gicl_recovery_payor d,
                         giis_payee_class e,
                         giis_payees f
                   WHERE a.claim_id = b.claim_id
                     AND a.rec_type_cd = c.rec_type_cd
                     /* AND EXISTS ( -- bonok :: 10.8.2015 :: UCPB SR 20463 :: commented out
                            SELECT   claim_id, recovery_id, payor_class_cd, payor_cd,
                                     SUM (collection_amt)
                                FROM giac_loss_recoveries x
                               WHERE x.recovery_id = a.recovery_id
                                 AND x.claim_id = a.claim_id
                                 AND x.payor_class_cd = d.payor_class_cd
                                 AND x.payor_cd = d.payor_cd
                              HAVING SUM (collection_amt) > 0
                            GROUP BY claim_id, recovery_id, payor_class_cd, payor_cd) */
                     AND EXISTS ( -- bonok :: 10.8.2015 :: UCPB SR 20463 :: to consider deleted JVs
                            SELECT   claim_id, recovery_id, payor_class_cd, payor_cd,
                                     SUM (collection_amt)
                                FROM giac_loss_recoveries x, giac_acctrans gacc
                               WHERE x.recovery_id = a.recovery_id
                                 AND x.claim_id = a.claim_id
                                 AND x.payor_class_cd = d.payor_class_cd
                                 AND x.payor_cd = d.payor_cd
                                 AND x.gacc_tran_id = gacc.tran_id
                                 AND gacc.tran_flag <> 'D'
                                 AND NOT EXISTS (SELECT '1'
                                                   FROM giac_reversals xx, giac_acctrans y
                                                  WHERE xx.reversing_tran_id = y.tran_id
                                                    AND xx.gacc_tran_id = x.gacc_tran_id
                                                    AND y.tran_flag <> 'D')--)
                                                    GROUP BY claim_id, recovery_id, payor_class_cd, payor_cd) --sherry for GENQA SR#5218, KB 2090 12.09.2015
                     AND d.claim_id = a.claim_id
                     AND d.recovery_id = a.recovery_id
                     AND d.payor_class_cd = e.payee_class_cd
                     AND d.payor_cd = f.payee_no
                     AND d.payor_class_cd = f.payee_class_cd
                     AND e.payee_class_cd = f.payee_class_cd
                     AND check_user_per_iss_cd_acctg2(NULL, a.iss_cd, 'GIACS010', p_user_id) = 1)
					      --AND check_user_per_iss_cd2(a.line_cd,a.iss_cd,'GIACS010',p_user_id) = 1) --added by steven 1.26.2013;base on SR 0012042
        LOOP
            v_list.line_cd              := r.line_cd;
            v_list.iss_cd               := r.iss_cd;
            v_list.rec_year             := r.rec_year;
            v_list.rec_seq_no           := to_char(r.rec_seq_no,'009');
            v_list.claim_id             := r.claim_id;
            --v_loss.dsp_line_cd        := r.line_cd1;
            --v_loss.dsp_subline_cd     := r.subline_cd1;
            --v_loss.dsp_iss_cd         := r.iss_cd1;
            --v_loss.dsp_clm_yy         := r.clm_yy;
            --v_loss.dsp_clm_seq_no     := r.clm_seq_no;
            v_list.dsp_claim_no         := r.dsp_line_cd||'-'||r.dsp_subline_cd||'-'||r.dsp_iss_cd||'-'||to_char(r.dsp_clm_yy,'09')||'-'||to_char(r.dsp_clm_seq_no,'09999');
            --v_loss.dsp_line_cd1       := r.line_cd2;
            --v_loss.dsp_subline_cd1    := r.subline_cd2;
            --v_loss.dsp_pol_iss_cd     := r.pol_iss_cd;
            --v_loss.dsp_issue_yy       := r.issue_yy;
            --v_loss.dsp_pol_seq_no     := r.pol_seq_no;
            --v_loss.dsp_renew_no       := r.renew_no;
            v_list.dsp_policy_no        := r.dsp_line_cd1||'-'||r.dsp_subline_cd1||'-'||r.dsp_pol_iss_cd||'-'||to_char(r.dsp_issue_yy,'09')||'-'||to_char(r.dsp_pol_seq_no,'09999')||'-'||to_char(r.dsp_renew_no,'09');     
            v_list.dsp_loss_date        := r.dsp_loss_date;
            v_list.dsp_assured_name     := r.dsp_assured_name;
            v_list.recovery_id          := r.recovery_id;
            v_list.rec_type_cd          := r.rec_type_cd;
            v_list.rec_type_desc        := r.rec_type_desc;
            v_list.payor_name           := r.payor_name;
            v_list.payor_cd             := r.payor_cd;
            v_list.payor_class_desc     := r.class_desc;
            v_list.payor_class_cd       := r.payor_class_cd;
            --v_list.dsp_currency_desc    := r.currency_desc;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;                       
    END;
    
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-08-2010 
    **  Reference By : (GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  getting sum of collection amount 
    */   
    
    FUNCTION get_recovery_no_list3(
                p_line_cd     gicl_clm_recovery.line_cd%TYPE,
        		p_iss_cd      gicl_clm_recovery.iss_cd%TYPE,
		        p_rec_year    gicl_clm_recovery.rec_year%TYPE,
		        p_rec_seq_no  gicl_clm_recovery.rec_seq_no%TYPE,
                p_payor_cd    gicl_recovery_payor.payor_cd%TYPE,
                p_payor_class gicl_recovery_payor.payor_class_cd%TYPE)
        RETURN recovery_no_list_tab PIPELINED IS
        v_list      recovery_no_list_type;
    BEGIN
        FOR r IN (SELECT a.line_cd line_cd, a.iss_cd iss_cd, a.rec_year rec_year,
                           TO_CHAR (a.rec_seq_no, '099') rec_seq_no, b.claim_id claim_id,
                           b.line_cd dsp_line_cd, b.subline_cd dsp_subline_cd,
                           b.iss_cd dsp_iss_cd, b.clm_yy dsp_clm_yy, b.clm_seq_no dsp_clm_seq_no,
                           b.line_cd dsp_line_cd1, b.subline_cd dsp_subline_cd1,
                           b.pol_iss_cd dsp_pol_iss_cd, b.issue_yy dsp_issue_yy,
                           b.pol_seq_no dsp_pol_seq_no, b.renew_no dsp_renew_no,
                           b.loss_date dsp_loss_date, b.assured_name dsp_assured_name,
                           a.recovery_id recovery_id, a.rec_type_cd, c.rec_type_desc,
                           d.payor_class_cd, e.class_desc, d.payor_cd,
                           DECODE (f.payee_first_name,
                                   NULL, f.payee_last_name,
                                      f.payee_last_name
                                   || ', '
                                   || f.payee_first_name
                                   || ' '
                                   || f.payee_middle_name
                                  ) payor_name
                      FROM gicl_clm_recovery a,
                           gicl_claims b,
                           giis_recovery_type c,
                           gicl_recovery_payor d,
                           giis_payee_class e,
                           giis_payees f
                     WHERE a.claim_id = b.claim_id
                       AND a.rec_type_cd = c.rec_type_cd
                       AND d.claim_id = a.claim_id
                       AND d.recovery_id = a.recovery_id
                       AND d.payor_class_cd = e.payee_class_cd
                       AND d.payor_cd = f.payee_no
                       AND d.payor_class_cd = f.payee_class_cd
                       AND e.payee_class_cd = f.payee_class_cd
                       AND a.cancel_tag IS NULL
                       AND a.line_cd = p_line_cd
                       AND a.iss_cd = p_iss_cd
                       AND a.rec_year = p_rec_year
                       AND a.rec_seq_no = p_rec_seq_no
                       AND d.payor_cd = p_payor_cd
                       AND d.payor_class_cd = p_payor_class)
        LOOP
            v_list.line_cd              := r.line_cd;
            v_list.iss_cd               := r.iss_cd;
            v_list.rec_year             := r.rec_year;
            v_list.rec_seq_no           := to_char(r.rec_seq_no,'009');
            v_list.claim_id             := r.claim_id;
            --v_loss.dsp_line_cd        := r.line_cd1;
            --v_loss.dsp_subline_cd     := r.subline_cd1;
            --v_loss.dsp_iss_cd         := r.iss_cd1;
            --v_loss.dsp_clm_yy         := r.clm_yy;
            --v_loss.dsp_clm_seq_no     := r.clm_seq_no;
            v_list.dsp_claim_no         := r.dsp_line_cd||'-'||r.dsp_subline_cd||'-'||r.dsp_iss_cd||'-'||to_char(r.dsp_clm_yy,'09')||'-'||to_char(r.dsp_clm_seq_no,'09999');
            --v_loss.dsp_line_cd1       := r.line_cd2;
            --v_loss.dsp_subline_cd1    := r.subline_cd2;
            --v_loss.dsp_pol_iss_cd     := r.pol_iss_cd;
            --v_loss.dsp_issue_yy       := r.issue_yy;
            --v_loss.dsp_pol_seq_no     := r.pol_seq_no;
            --v_loss.dsp_renew_no       := r.renew_no;
            v_list.dsp_policy_no        := r.dsp_line_cd1||'-'||r.dsp_subline_cd1||'-'||r.dsp_pol_iss_cd||'-'||to_char(r.dsp_issue_yy,'09')||'-'||to_char(r.dsp_pol_seq_no,'09999')||'-'||to_char(r.dsp_renew_no,'09');     
            v_list.dsp_loss_date        := r.dsp_loss_date;
            v_list.dsp_assured_name     := r.dsp_assured_name;
            v_list.recovery_id          := r.recovery_id;
            v_list.rec_type_cd          := r.rec_type_cd;
            v_list.rec_type_desc        := r.rec_type_desc;
            v_list.payor_name           := r.payor_name;
            v_list.payor_cd             := r.payor_cd;
            v_list.payor_class_desc     := r.class_desc;
            v_list.payor_class_cd       := r.payor_class_cd;
            --v_list.dsp_currency_desc    := r.currency_desc;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;                       
    END;
    
    FUNCTION get_recovery_no_list4(p_line_cd     gicl_clm_recovery.line_cd%TYPE,
        		p_iss_cd      gicl_clm_recovery.iss_cd%TYPE,
		        p_rec_year    gicl_clm_recovery.rec_year%TYPE,
		        p_rec_seq_no  gicl_clm_recovery.rec_seq_no%TYPE,
                p_payor_cd    gicl_recovery_payor.payor_cd%TYPE,
                p_payor_class gicl_recovery_payor.payor_class_cd%TYPE)
        RETURN recovery_no_list_tab PIPELINED IS
        v_list      recovery_no_list_type;
    BEGIN
        FOR r IN (SELECT a.line_cd line_cd, a.iss_cd iss_cd, a.rec_year rec_year,
                         TO_CHAR (a.rec_seq_no, '099') rec_seq_no, b.claim_id claim_id,
                         b.line_cd dsp_line_cd, b.subline_cd dsp_subline_cd,
                         b.iss_cd dsp_iss_cd, b.clm_yy dsp_clm_yy, b.clm_seq_no dsp_clm_seq_no,
                         b.line_cd dsp_line_cd1, b.subline_cd dsp_subline_cd1,
                         b.pol_iss_cd dsp_pol_iss_cd, b.issue_yy dsp_issue_yy,
                         b.pol_seq_no dsp_pol_seq_no, b.renew_no dsp_renew_no,
                         b.loss_date dsp_loss_date, b.assured_name dsp_assured_name,
                         a.recovery_id recovery_id, a.rec_type_cd, c.rec_type_desc,
                         d.payor_class_cd, e.class_desc, d.payor_cd,
                         DECODE (f.payee_first_name,
                                 NULL, f.payee_last_name,
                                    f.payee_last_name
                                 || ', '
                                 || f.payee_first_name
                                 || ' '
                                 || f.payee_middle_name
                                ) payor_name
                    FROM gicl_clm_recovery a,
                         gicl_claims b,
                         giis_recovery_type c,
                         gicl_recovery_payor d,
                         giis_payee_class e,
                         giis_payees f
                   WHERE a.claim_id = b.claim_id
                     AND a.rec_type_cd = c.rec_type_cd
                     AND EXISTS (
                            SELECT   claim_id, recovery_id, payor_class_cd, payor_cd,
                                     SUM (collection_amt)
                                FROM giac_loss_recoveries x
                               WHERE x.recovery_id = a.recovery_id
                                 AND x.claim_id = a.claim_id
                                 AND x.payor_class_cd = d.payor_class_cd
                                 AND x.payor_cd = d.payor_cd
                              HAVING SUM (collection_amt) > 0
                            GROUP BY claim_id, recovery_id, payor_class_cd, payor_cd)
                     AND d.claim_id = a.claim_id
                     AND d.recovery_id = a.recovery_id
                     AND d.payor_class_cd = e.payee_class_cd
                     AND d.payor_cd = f.payee_no
                     AND d.payor_class_cd = f.payee_class_cd
                     AND e.payee_class_cd = f.payee_class_cd
		             AND a.line_cd = p_line_cd
                     AND a.iss_cd = p_iss_cd
                     AND a.rec_year = p_rec_year
                     AND a.rec_seq_no = p_rec_seq_no
		             AND d.payor_cd = p_payor_cd
                     AND d.payor_class_cd = p_payor_class)
        LOOP
            v_list.line_cd              := r.line_cd;
            v_list.iss_cd               := r.iss_cd;
            v_list.rec_year             := r.rec_year;
            v_list.rec_seq_no           := to_char(r.rec_seq_no,'009');
            v_list.claim_id             := r.claim_id;
            --v_loss.dsp_line_cd        := r.line_cd1;
            --v_loss.dsp_subline_cd     := r.subline_cd1;
            --v_loss.dsp_iss_cd         := r.iss_cd1;
            --v_loss.dsp_clm_yy         := r.clm_yy;
            --v_loss.dsp_clm_seq_no     := r.clm_seq_no;
            v_list.dsp_claim_no         := r.dsp_line_cd||'-'||r.dsp_subline_cd||'-'||r.dsp_iss_cd||'-'||to_char(r.dsp_clm_yy,'09')||'-'||to_char(r.dsp_clm_seq_no,'09999');
            --v_loss.dsp_line_cd1       := r.line_cd2;
            --v_loss.dsp_subline_cd1    := r.subline_cd2;
            --v_loss.dsp_pol_iss_cd     := r.pol_iss_cd;
            --v_loss.dsp_issue_yy       := r.issue_yy;
            --v_loss.dsp_pol_seq_no     := r.pol_seq_no;
            --v_loss.dsp_renew_no       := r.renew_no;
            v_list.dsp_policy_no        := r.dsp_line_cd1||'-'||r.dsp_subline_cd1||'-'||r.dsp_pol_iss_cd||'-'||to_char(r.dsp_issue_yy,'09')||'-'||to_char(r.dsp_pol_seq_no,'09999')||'-'||to_char(r.dsp_renew_no,'09');     
            v_list.dsp_loss_date        := r.dsp_loss_date;
            v_list.dsp_assured_name     := r.dsp_assured_name;
            v_list.recovery_id          := r.recovery_id;
            v_list.rec_type_cd          := r.rec_type_cd;
            v_list.rec_type_desc        := r.rec_type_desc;
            v_list.payor_name           := r.payor_name;
            v_list.payor_cd             := r.payor_cd;
            v_list.payor_class_desc     := r.class_desc;
            v_list.payor_class_cd       := r.payor_class_cd;
            --v_list.dsp_currency_desc    := r.currency_desc;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;                       
    END;
    
    FUNCTION get_payor_name(
                p_line_cd     gicl_clm_recovery.line_cd%TYPE,
        		p_iss_cd      gicl_clm_recovery.iss_cd%TYPE,
		        p_rec_year    gicl_clm_recovery.rec_year%TYPE,
		        p_rec_seq_no  gicl_clm_recovery.rec_seq_no%TYPE)
    RETURN payor_name_list_tab PIPELINED IS
        v_payor_name	payor_name_list_type;

    BEGIN
        FOR i IN (SELECT d.payor_class_cd, 
			             e.class_desc, 
			             d.payor_cd,
			             DECODE (f.payee_first_name,
                                   NULL, f.payee_last_name,
                                      f.payee_last_name
                                   || ', '
                                   || f.payee_first_name
                                   || ' '
                                   || f.payee_middle_name
                                  ) payor_name
                      FROM gicl_clm_recovery a,
                           gicl_claims b,
                           giis_recovery_type c,
                           gicl_recovery_payor d,
                           giis_payee_class e,
                           giis_payees f
                     WHERE a.claim_id = b.claim_id
                       AND a.rec_type_cd = c.rec_type_cd
                       AND d.claim_id = a.claim_id
                       AND d.recovery_id = a.recovery_id
                       AND d.payor_class_cd = e.payee_class_cd
                       AND d.payor_cd = f.payee_no
                       AND d.payor_class_cd = f.payee_class_cd
                       AND e.payee_class_cd = f.payee_class_cd
                       AND a.cancel_tag IS NULL
                       AND a.line_cd = p_line_cd
                       AND a.iss_cd = p_iss_cd
                       AND a.rec_year = p_rec_year
                       AND a.rec_seq_no = p_rec_seq_no)

        LOOP
            v_payor_name.payor_class_cd := i.payor_class_cd;
            v_payor_name.class_desc     := i.class_desc;
            v_payor_name.payor_cd       := i.payor_cd;
            v_payor_name.payor_name     := i.payor_name;
            PIPE ROW(v_payor_name);
        END LOOP;
    END;
    
    FUNCTION get_payor_name2(
                p_line_cd     gicl_clm_recovery.line_cd%TYPE,
        		p_iss_cd      gicl_clm_recovery.iss_cd%TYPE,
		        p_rec_year    gicl_clm_recovery.rec_year%TYPE,
		        p_rec_seq_no  gicl_clm_recovery.rec_seq_no%TYPE)
    RETURN payor_name_list_tab PIPELINED IS
        v_payor_name	payor_name_list_type;

    BEGIN
        FOR i IN (SELECT d.payor_class_cd, 
			             e.class_desc, 
			             d.payor_cd,
                         DECODE (f.payee_first_name,
                                 NULL, f.payee_last_name,
                                    f.payee_last_name
                                 || ', '
                                 || f.payee_first_name
                                 || ' '
                                 || f.payee_middle_name
                                ) payor_name
                    FROM gicl_clm_recovery a,
                         gicl_claims b,
                         giis_recovery_type c,
                         gicl_recovery_payor d,
                         giis_payee_class e,
                         giis_payees f
                   WHERE a.claim_id = b.claim_id
                     AND a.rec_type_cd = c.rec_type_cd
                     AND EXISTS (
                            SELECT   claim_id, recovery_id, payor_class_cd, payor_cd,
                                     SUM (collection_amt)
                                FROM giac_loss_recoveries x
                               WHERE x.recovery_id = a.recovery_id
                                 AND x.claim_id = a.claim_id
                                 AND x.payor_class_cd = d.payor_class_cd
                                 AND x.payor_cd = d.payor_cd
                              HAVING SUM (collection_amt) > 0
                            GROUP BY claim_id, recovery_id, payor_class_cd, payor_cd)
                     AND d.claim_id = a.claim_id
                     AND d.recovery_id = a.recovery_id
                     AND d.payor_class_cd = e.payee_class_cd
                     AND d.payor_cd = f.payee_no
                     AND d.payor_class_cd = f.payee_class_cd
                     AND e.payee_class_cd = f.payee_class_cd
                     AND a.line_cd = p_line_cd
                     AND a.iss_cd = p_iss_cd
                     AND a.rec_year = p_rec_year
                     AND a.rec_seq_no = p_rec_seq_no)
        LOOP
            v_payor_name.payor_class_cd := i.payor_class_cd;
            v_payor_name.class_desc     := i.class_desc;
            v_payor_name.payor_cd       := i.payor_cd;
            v_payor_name.payor_name     := i.payor_name;
            PIPE ROW(v_payor_name);
        END LOOP;
    END;
        

    PROCEDURE get_sum_colln_amt(
                p_collection_amt        giac_loss_recoveries.collection_amt%TYPE,
                p_recovery_id           giac_loss_recoveries.recovery_id%TYPE,
                p_claim_id              giac_loss_recoveries.claim_id%TYPE,
                p_payor_class_cd        giac_loss_recoveries.payor_class_cd%TYPE,
                p_payor_cd              giac_loss_recoveries.payor_cd%TYPE,
                p_msg_alert        OUT  VARCHAR2,
                p_sum              OUT  NUMBER 
                ) 
            IS
    BEGIN
        SELECT SUM (collection_amt)
          INTO p_sum
          FROM giac_loss_recoveries x
         WHERE x.recovery_id = p_recovery_id
           AND x.claim_id = p_claim_id
           AND x.payor_class_cd = p_payor_class_cd
           AND x.payor_cd = p_payor_cd
        HAVING SUM (collection_amt) > 0;

        IF p_sum < ABS (p_collection_amt) THEN
           p_msg_alert := 'Maximum reversible amount is '||LTRIM(TO_CHAR (p_sum, '999,999,999,990.09')) || '.';
        END IF;  
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
         NULL;
    END;

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-11-2010 
    **  Reference By : (GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  to get the currency 
    */ 
    PROCEDURE get_currency (
        p_recovery_id          IN  giac_loss_recoveries.recovery_id%TYPE,
        p_claim_id             IN  giac_loss_recoveries.claim_id%TYPE,
        p_dsp_loss_date        IN  VARCHAR2,
        p_collection_amt       IN  giac_loss_recoveries.collection_amt%TYPE,
        p_currency_cd          OUT giac_loss_recoveries.currency_cd%TYPE,
        p_convert_rate         OUT giac_loss_recoveries.convert_rate%TYPE,
        p_dsp_currency_desc    OUT giis_currency.currency_desc%TYPE,
        p_foreign_curr_amt     OUT giac_loss_recoveries.foreign_curr_amt%TYPE,
        p_msg_alert            OUT VARCHAR2                       
        ) IS
      v_exist       NUMBER;
    BEGIN
         SELECT COUNT (currency_cd)
           INTO v_exist
           FROM gicl_clm_recovery
          WHERE recovery_id = p_recovery_id AND claim_id = p_claim_id;

         IF v_exist <> 0 THEN
            FOR c IN  (SELECT currency_cd
                         FROM gicl_clm_recovery
                        WHERE recovery_id = p_recovery_id
                          AND claim_id = p_claim_id)
            LOOP
               p_currency_cd := c.currency_cd;
               BEGIN
                SELECT DISTINCT a.currency_rt, b.currency_desc
                  INTO p_convert_rate, p_dsp_currency_desc
                  FROM giac_currency a, giis_currency b
                 WHERE a.effectivity_date <= to_date(p_dsp_loss_date,'mm-dd-yyyy')
                   AND (a.inactivity_date IS NULL OR
                        a.inactivity_date > to_date(p_dsp_loss_date,'mm-dd-yyyy'))
                   AND a.main_currency_cd = b.main_currency_cd
                   AND a.main_currency_cd = c.currency_cd;
                 EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        BEGIN
                          SELECT DISTINCT b.currency_rt, b.currency_desc
                            INTO p_convert_rate, p_dsp_currency_desc
                            FROM giac_currency a, giis_currency b
                           WHERE a.inactivity_date IS NULL
                             AND a.main_currency_cd (+) = b.main_currency_cd
                             AND b.main_currency_cd = c.currency_cd;
                        EXCEPTION     
                        WHEN NO_DATA_FOUND THEN   
                            p_msg_alert := 'Error: Currency code not exist. Please contact your system administrator.';
                            RETURN;
                        WHEN TOO_MANY_ROWS THEN
                            p_msg_alert := 'Error: Too many rows. Please contact your system administrator.';
                            RETURN;
                        END;    
                    WHEN TOO_MANY_ROWS THEN
                      p_msg_alert := 'Error: Too many rows. Please contact your system administrator.';
                      RETURN;
               END; 
               p_foreign_curr_amt  := NVL(p_collection_amt,0)/NVL(p_convert_rate,1); 
            END LOOP;
         ELSIF v_exist = 0 THEN
            FOR a1 IN (SELECT main_currency_cd, currency_rt, currency_desc
	                     FROM giis_currency 
	                    WHERE main_currency_cd IN (SELECT param_value_n
		                                             FROM giac_parameters 
			                                        WHERE param_name = 'CURRENCY_CD'))
            LOOP 
                p_currency_cd       := a1.main_currency_cd;
                p_convert_rate      := a1.currency_rt;
                p_dsp_currency_desc := a1.currency_desc;
                --variables.def_foreign_curr_amt := NVL(:glre.collection_amt,0)/NVL(:glre.convert_rate,1);
                p_foreign_curr_amt  := NVL(p_collection_amt,0)/NVL(a1.currency_rt,1);
            EXIT;
            END LOOP;
         END IF;
    END;

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-12-2010 
    **  Reference By : (GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  validate the currency code
    */ 
    PROCEDURE validate_currency_code (
        p_dsp_loss_date        IN  VARCHAR2,
        p_collection_amt       IN  giac_loss_recoveries.collection_amt%TYPE,
        p_currency_cd          IN  giac_loss_recoveries.currency_cd%TYPE,
        p_convert_rate         OUT giac_loss_recoveries.convert_rate%TYPE,
        p_dsp_currency_desc    OUT giis_currency.currency_desc%TYPE,
        p_foreign_curr_amt     OUT giac_loss_recoveries.foreign_curr_amt%TYPE,
        p_msg_alert            OUT VARCHAR2                       
        ) IS
    BEGIN
        BEGIN
        SELECT DISTINCT a.currency_rt, b.currency_desc
          INTO p_convert_rate, p_dsp_currency_desc
          FROM giac_currency a, giis_currency b
         WHERE a.effectivity_date <= to_date(p_dsp_loss_date,'mm-dd-yyyy')
           AND (a.inactivity_date IS NULL OR
                a.inactivity_date > to_date(p_dsp_loss_date,'mm-dd-yyyy'))
           AND a.main_currency_cd = b.main_currency_cd
           AND a.main_currency_cd = p_currency_cd;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                BEGIN
                SELECT DISTINCT b.currency_rt, b.currency_desc
                  INTO p_convert_rate, p_dsp_currency_desc
                  FROM giac_currency a, giis_currency b
                 WHERE a.inactivity_date IS NULL
                   AND a.main_currency_cd (+) = b.main_currency_cd
                   AND b.main_currency_cd = p_currency_cd;
                EXCEPTION   
                WHEN NO_DATA_FOUND THEN   
                    p_msg_alert := 'Error: Currency code not exist. Please contact your system administrator.';
                    RETURN;
                WHEN TOO_MANY_ROWS THEN
                    p_msg_alert := 'Error: Too many rows. Please contact your system administrator.';
                    RETURN;
                END;   
            WHEN TOO_MANY_ROWS THEN
                p_msg_alert := 'Error: Too many rows. Please contact your system administrator.';
                RETURN;
        END;
        p_foreign_curr_amt  := NVL(p_collection_amt,0)/NVL(p_convert_rate,1);
    END;
   
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-12-2010 
    **  Reference By : (GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  validate before delete
    */ 
    FUNCTION validate_before_deletion(
      p_claim_id                 giac_loss_recoveries.claim_id%TYPE,
      p_gacc_tran_id             giac_loss_recoveries.gacc_tran_id%TYPE
    )
    RETURN VARCHAR2 IS
     dummy    	    VARCHAR2(1);    
     v_msg_alert    VARCHAR2(3200) := ''; 
    BEGIN
        SELECT '1'
            INTO dummy
            FROM giac_loss_recoveries
           WHERE transaction_type = 2
             AND claim_id = p_claim_id
             AND (rev_gacc_tran_id = p_gacc_tran_id OR rev_gacc_tran_id IS NULL); --marco - 10.01.2014 - added condition
       
          IF SQL%FOUND THEN
             v_msg_alert := 'Delete not allowed. A refund transaction exists for this record.';
             RETURN v_msg_alert;
          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
             v_msg_alert := '';
             RETURN v_msg_alert;
          WHEN TOO_MANY_ROWS THEN
             v_msg_alert := 'Delete not allowed. A refund transaction exists for this record.';
             RETURN v_msg_alert;
    END;
    
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-12-2010 
    **  Reference By : (GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  get the tran flag 
    */     
    FUNCTION get_tran_flag(p_gacc_tran_id    giac_loss_recoveries.gacc_tran_id%TYPE)
    RETURN VARCHAR2 IS
      v_tran_flag   giac_acctrans.tran_flag%TYPE;
    BEGIN
        FOR tr IN (SELECT tran_flag 
              FROM giac_acctrans
             WHERE tran_id = p_gacc_tran_id)
        LOOP
            v_tran_flag := tr.tran_flag;
        END LOOP;
    RETURN nvl(v_tran_flag,'');
    END;
    
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-12-2010 
    **  Reference By : GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  delete records in giac_loss_recoveries table 
    */    
    PROCEDURE del_giac_loss_recoveries(
        p_gacc_tran_id           giac_loss_recoveries.gacc_tran_id%TYPE,
        p_claim_id               giac_loss_recoveries.claim_id%TYPE,
        p_recovery_id            giac_loss_recoveries.recovery_id%TYPE,
        p_payor_class_cd         giac_loss_recoveries.payor_class_cd%TYPE,
        p_payor_cd               giac_loss_recoveries.payor_cd%TYPE
        ) IS
    BEGIN
        DELETE giac_loss_recoveries
         WHERE gacc_tran_id = p_gacc_tran_id
           AND claim_id = p_claim_id
           AND recovery_id = p_recovery_id
           AND payor_class_cd = p_payor_class_cd
           AND payor_cd = p_payor_cd;
    END;
    
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-12-2010 
    **  Reference By : GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  insert records in giac_loss_recoveries table 
    */      
    PROCEDURE set_giac_loss_recoveries(
        p_gacc_tran_id                giac_loss_recoveries.gacc_tran_id%TYPE,
        p_transaction_type            giac_loss_recoveries.transaction_type%TYPE,
        p_claim_id                    giac_loss_recoveries.claim_id%TYPE,
        p_recovery_id                 giac_loss_recoveries.recovery_id%TYPE,
        p_payor_class_cd              giac_loss_recoveries.payor_class_cd%TYPE,
        p_payor_cd                    giac_loss_recoveries.payor_cd%TYPE,
        p_collection_amt              giac_loss_recoveries.collection_amt%TYPE,
        p_currency_cd                 giac_loss_recoveries.currency_cd%TYPE,
        p_convert_rate                giac_loss_recoveries.convert_rate%TYPE,
        p_foreign_curr_amt            giac_loss_recoveries.foreign_curr_amt%TYPE,
        p_or_print_tag                giac_loss_recoveries.or_print_tag%TYPE,
        p_remarks                     giac_loss_recoveries.remarks%TYPE,
        p_cpi_rec_no                  giac_loss_recoveries.cpi_rec_no%TYPE,
        p_cpi_branch_cd               giac_loss_recoveries.cpi_branch_cd%TYPE,
        p_user_id                     giac_loss_recoveries.user_id%TYPE,
        p_last_update                 giac_loss_recoveries.last_update%TYPE,
        p_acct_ent_tag                giac_loss_recoveries.acct_ent_tag%TYPE
        ) IS 
        v_gacc_tran_id                giac_loss_recoveries.gacc_tran_id%TYPE;
    BEGIN
        --marco - 09.30.2014
        IF p_transaction_type = 2 THEN
            BEGIN
               SELECT gacc_tran_id
                 INTO v_gacc_tran_id
                 FROM GIAC_LOSS_RECOVERIES
                WHERE claim_id = p_claim_id
                  AND recovery_id = p_recovery_id
                  AND payor_class_cd = p_payor_class_cd
                  AND payor_cd = p_payor_cd;
            EXCEPTION
               WHEN OTHERS THEN
                  v_gacc_tran_id := NULL;
            END;
        END IF;
            
        MERGE INTO giac_loss_recoveries
        USING dual
           ON (gacc_tran_id = p_gacc_tran_id
          AND claim_id = p_claim_id
          AND recovery_id = p_recovery_id
          AND payor_class_cd = p_payor_class_cd
          AND payor_cd = p_payor_cd)
           WHEN NOT MATCHED THEN
                INSERT(gacc_tran_id,        transaction_type,       claim_id,
                       recovery_id,         payor_class_cd,         payor_cd,
                       collection_amt,      currency_cd,            convert_rate,
                       foreign_curr_amt,    or_print_tag,           remarks,
                       cpi_rec_no,          cpi_branch_cd,          user_id,
                       last_update,         acct_ent_tag,           rev_gacc_tran_id)
                VALUES(p_gacc_tran_id,      p_transaction_type,     p_claim_id,
                       p_recovery_id,       p_payor_class_cd,       p_payor_cd,
                       p_collection_amt,    p_currency_cd,          p_convert_rate,
                       p_foreign_curr_amt,  p_or_print_tag,         p_remarks,
                       p_cpi_rec_no,        p_cpi_branch_cd,        p_user_id,
                       SYSDATE,             p_acct_ent_tag,         v_gacc_tran_id) --marco - 09.30.2014 - added v_gacc_tran_id
           WHEN MATCHED THEN
                UPDATE  
                   SET transaction_type     = p_transaction_type,       
                       collection_amt       = p_collection_amt,      
                       currency_cd          = p_currency_cd,            
                       convert_rate         = p_convert_rate,
                       foreign_curr_amt     = p_foreign_curr_amt,    
                       or_print_tag         = p_or_print_tag,           
                       remarks              = p_remarks,
                       cpi_rec_no           = p_cpi_rec_no,          
                       cpi_branch_cd        = p_cpi_branch_cd,          
                       user_id              = p_user_id,
                       last_update          = SYSDATE,         
                       acct_ent_tag         = p_acct_ent_tag;    
    END;
   
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-13-2010 
    **  Reference By : GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  DEL_UPD_RECOVERY program unit 
    */ 
    --editted by lara beltran 02-07-2014
    PROCEDURE del_upd_recovery (
       p_gacc_tran_id     giac_loss_recoveries.gacc_tran_id%TYPE,
       p_claim_id         giac_loss_recoveries.claim_id%TYPE,
       p_recovery_id      giac_loss_recoveries.recovery_id%TYPE,
       p_payor_class_cd   giac_loss_recoveries.payor_class_cd%TYPE,
       p_payor_cd         giac_loss_recoveries.payor_cd%TYPE
       --p_collection_amt   giac_loss_recoveries.collection_amt%TYPE
    )
    IS
       v_coll_amt     giac_loss_recoveries.collection_amt%TYPE   := 0;
       v_local_curr   NUMBER (2)                                 := giacp.n ('CURRENCY_CD');
       v_curr_cd      gicl_clm_recovery.currency_cd%TYPE;
    BEGIN
       FOR p IN (SELECT   a.claim_id, a.recovery_id, a.payor_class_cd,
                          a.payor_cd, SUM (a.collection_amt) coll_amt,
                          b.currency_cd, SUM (a.foreign_curr_amt) foreign_amt
                     FROM giac_loss_recoveries a, gicl_clm_recovery b
                    WHERE gacc_tran_id = p_gacc_tran_id --:GLOBAL.cg$giop_gacc_tran_id
                      AND a.claim_id = p_claim_id
                      AND a.recovery_id = p_recovery_id
                      AND a.payor_class_cd = p_payor_class_cd
                      AND a.payor_cd = p_payor_cd
                      AND a.claim_id = b.claim_id
                      AND b.recovery_id = a.recovery_id
                 GROUP BY a.claim_id,
                          a.recovery_id,
                          a.payor_class_cd,
                          a.payor_cd,
                          b.currency_cd)
       LOOP
          IF p.currency_cd = v_local_curr
          THEN
             v_coll_amt := p.coll_amt;
          ELSE
             v_coll_amt := p.foreign_amt;
          END IF;

          DELETE FROM gicl_recovery_payt
                WHERE claim_id = p_claim_id
                  AND recovery_id = p_recovery_id
                  AND payor_class_cd = p_payor_class_cd
                  AND payor_cd = p_payor_cd
                  AND acct_tran_id = p_gacc_tran_id;

          UPDATE gicl_clm_recovery
             SET recovered_amt = NVL (recovered_amt, 0) - v_coll_amt
           WHERE claim_id = p_claim_id AND recovery_id = p_recovery_id;

          UPDATE gicl_recovery_payor
             SET recovered_amt = NVL (recovered_amt, 0) - v_coll_amt
           WHERE claim_id = p_claim_id
             AND recovery_id = p_recovery_id
             AND payor_class_cd = p_payor_class_cd
             AND payor_cd = p_payor_cd;
       END LOOP;
    END;
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-13-2010 
    **  Reference By : GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  INSERT_RECOVERY_PAYT program unit 
    */  
    PROCEDURE INSERT_RECOVERY_PAYT (
        p_gacc_tran_id          giac_loss_recoveries.gacc_tran_id%TYPE,
        p_claim_id              gicl_clm_recovery.claim_id%type,
        p_recovery_id           gicl_clm_recovery.recovery_id%type,
        p_payor_class_cd        gicl_recovery_payor.payor_class_cd%type,
        p_payor_cd              gicl_recovery_payor.payor_cd%type,  
        p_collection_amt        giac_loss_recoveries.collection_amt%type
        ) IS
      v_payt_id     gicl_recovery_payt.recovery_payt_id%type;
    BEGIN
      FOR i iN (SELECT NVL(MAX(recovery_payt_id),0) + 1 recovery_payt_id
                  FROM gicl_recovery_payt
                 WHERE claim_id = p_claim_id
                   AND recovery_id = p_recovery_id)   
      LOOP
        v_payt_id := i.recovery_payt_id;

        INSERT INTO gicl_recovery_payt 
                   (recovery_id, recovery_payt_id, claim_id, 
                    payor_class_cd, payor_cd, recovered_amt,
                    acct_tran_id, tran_date) 
            VALUES (p_recovery_id, v_payt_id, p_claim_id,
                    p_payor_class_cd, p_payor_cd, p_collection_amt,
                    p_gacc_tran_id, SYSDATE);  
      END LOOP;
    END;

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-13-2010 
    **  Reference By : GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  UPDATE_RECOVERY_PAYOR program unit 
    */  
    PROCEDURE UPDATE_RECOVERY_PAYOR (
        p_claim_id        gicl_clm_recovery.claim_id%type,
        p_recovery_id     gicl_clm_recovery.recovery_id%type,
        p_payor_class_cd  gicl_recovery_payor.payor_class_cd%type,
        p_payor_cd        gicl_recovery_payor.payor_cd%type,  
        p_collection_amt  giac_loss_recoveries.collection_amt%type
        ) IS
    BEGIN 
      UPDATE gicl_recovery_payor
         SET recovered_amt = NVL(recovered_amt,0) + p_collection_amt
       WHERE claim_id = p_claim_id
         AND recovery_id = p_recovery_id     
         AND payor_class_cd = p_payor_class_cd
         AND payor_cd = p_payor_cd;
    END;

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-13-2010 
    **  Reference By : GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  UPDATE_CLM_RECOVERY program unit 
    */ 
    PROCEDURE UPDATE_CLM_RECOVERY (
        p_claim_id       gicl_clm_recovery.claim_id%type,
        p_recovery_id    gicl_clm_recovery.recovery_id%type,
        p_collection_amt giac_loss_recoveries.collection_amt%type
        ) IS
    BEGIN
      UPDATE gicl_clm_recovery
         SET recovered_amt = NVL(recovered_amt,0) + p_collection_amt
       WHERE claim_id = p_claim_id
         AND recovery_id = p_recovery_id;
    END;

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-13-2010 
    **  Reference By :  GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  post-insert form trigger on GIACS010 
	**  Modified by  :  Lara Beltran - 12/10/2013 SR 931
    */     
   PROCEDURE post_insert_giacs010(
       p_gacc_tran_id           giac_loss_recoveries.gacc_tran_id%TYPE,
       p_claim_id               giac_loss_recoveries.claim_id%TYPE,
       p_recovery_id            giac_loss_recoveries.recovery_id%TYPE,
       p_payor_class_cd         giac_loss_recoveries.payor_class_cd%TYPE,
       p_payor_cd               giac_loss_recoveries.payor_cd%TYPE
       ) IS
    v_coll_amt giac_loss_recoveries.collection_amt%type := 0; 
    v_local_curr NUMBER(2) := giacp.n ('CURRENCY_CD');
    v_curr_cd gicl_clm_recovery.currency_cd%TYPE;
   BEGIN
     FOR p IN (SELECT a.claim_id, a.recovery_id, a.payor_class_cd,
                      a.payor_cd, SUM(a.collection_amt) coll_amt,
                        b.currency_cd, SUM(a.foreign_curr_amt) foreign_amt 
                 FROM giac_loss_recoveries a, gicl_clm_recovery b
                WHERE gacc_tran_id = p_gacc_tran_id --:GLOBAL.cg$giop_gacc_tran_id
                  AND a.claim_id = p_claim_id
                  AND a.recovery_id = p_recovery_id
                  AND a.payor_class_cd = p_payor_class_cd
                  AND a.payor_cd = p_payor_cd
                  AND a.claim_id = b.claim_id 
                  AND b.recovery_id = a.recovery_id
                GROUP BY a.claim_id, a.recovery_id, a.payor_class_cd, a.payor_cd, b.currency_cd)
     LOOP
        IF p.currency_cd = v_local_curr THEN 
            v_coll_amt := p.coll_amt;
        ELSE
            v_coll_amt := p.foreign_amt;
        END IF;

       insert_recovery_payt (p_gacc_tran_id, p.claim_id, p.recovery_id, p.payor_class_cd,
                             p.payor_cd, v_coll_amt);
       update_recovery_payor (p.claim_id, p.recovery_id, p.payor_class_cd,
                              p.payor_cd, v_coll_amt); 
       update_clm_recovery (p.claim_id, p.recovery_id, v_coll_amt);
     END LOOP;
   END;
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-14-2010 
    **  Reference By : GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  aeg_insert_update_acct_entries program unit 
    */ 
    PROCEDURE aeg_insert_update_acct_entries (
       iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
       iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
       iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
       iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
       iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
       iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
       iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
       iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
       iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
       iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
       iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
       iuae_generation_type    giac_acct_entries.generation_type%TYPE,
       iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
       iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
       iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
       p_gacc_branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
       p_gacc_fund_cd          giac_acctrans.gfun_fund_cd%TYPE,
       p_gacc_tran_id          giac_acctrans.tran_id%TYPE,
       p_user_id               giis_users.user_id%TYPE)
    IS
       iuae_acct_entry_id            giac_acct_entries.acct_entry_id%TYPE;
    BEGIN
       SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
         INTO iuae_acct_entry_id
         FROM giac_acct_entries
        WHERE gacc_gibr_branch_cd = p_gacc_branch_cd
          AND gacc_gfun_fund_cd = p_gacc_fund_cd
          AND gacc_tran_id = p_gacc_tran_id
          AND sl_cd = iuae_sl_cd
          AND gl_acct_id = iuae_gl_acct_id
          AND gl_sub_acct_1 = iuae_gl_sub_acct_1
          AND gl_sub_acct_2 = iuae_gl_sub_acct_2
          AND gl_sub_acct_3 = iuae_gl_sub_acct_3
          AND gl_sub_acct_4 = iuae_gl_sub_acct_4
          AND gl_sub_acct_5 = iuae_gl_sub_acct_5
          AND gl_sub_acct_6 = iuae_gl_sub_acct_6
          AND gl_sub_acct_7 = iuae_gl_sub_acct_7;

       IF NVL (iuae_acct_entry_id, 0) = 0 THEN
          iuae_acct_entry_id := NVL (iuae_acct_entry_id, 0) + 1;

          INSERT INTO giac_acct_entries
                      (gacc_tran_id,
                       gacc_gfun_fund_cd,
                       gacc_gibr_branch_cd,
                       acct_entry_id,
                       gl_acct_id,
                       gl_acct_category,
                       gl_control_acct,
                       gl_sub_acct_1,
                       gl_sub_acct_2,
                       gl_sub_acct_3,
                       gl_sub_acct_4,
                       gl_sub_acct_5,
                       gl_sub_acct_6,
                       gl_sub_acct_7,
                       sl_cd,
                       sl_type_cd,
                       debit_amt,
                       credit_amt,
                       generation_type,
                       user_id,
                       last_update)
               VALUES (p_gacc_tran_id,
                       p_gacc_fund_cd,
                       p_gacc_branch_cd,
                       iuae_acct_entry_id,
                       iuae_gl_acct_id,
                       iuae_gl_acct_category,
                       iuae_gl_control_acct,
                       iuae_gl_sub_acct_1,
                       iuae_gl_sub_acct_2,
                       iuae_gl_sub_acct_3,
                       iuae_gl_sub_acct_4,
                       iuae_gl_sub_acct_5,
                       iuae_gl_sub_acct_6,
                       iuae_gl_sub_acct_7,
                       iuae_sl_cd,
                       iuae_sl_type_cd,
                       iuae_debit_amt,
                       iuae_credit_amt,
                       iuae_generation_type,
                       p_user_id,
                       SYSDATE);
       ELSE
          UPDATE giac_acct_entries
             SET debit_amt = debit_amt + iuae_debit_amt,
                 credit_amt = credit_amt + iuae_credit_amt
           WHERE sl_cd = iuae_sl_cd
             AND generation_type = iuae_generation_type
             AND gl_acct_id = iuae_gl_acct_id
             AND gacc_gibr_branch_cd = p_gacc_branch_cd
             AND gacc_gfun_fund_cd = p_gacc_fund_cd
             AND gacc_tran_id = p_gacc_tran_id;
       END IF;
    END;

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-14-2010 
    **  Reference By : GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  aeg_create_acct_entries program unit 
    */ 
    PROCEDURE aeg_create_acct_entries (
       aeg_sl_cd                giac_acct_entries.sl_cd%TYPE,
       aeg_module_id            giac_module_entries.module_id%TYPE,
       aeg_item_no              giac_module_entries.item_no%TYPE,
       aeg_iss_cd               gicl_claims.iss_cd%TYPE,
       aeg_line_cd              gipi_polbasic.line_cd%TYPE,
       aeg_acct_amt             giac_loss_recoveries.collection_amt%TYPE,
       aeg_gen_type             giac_acct_entries.generation_type%TYPE,
       p_gacc_branch_cd         giac_acctrans.gibr_branch_cd%TYPE,
       p_gacc_fund_cd           giac_acctrans.gfun_fund_cd%TYPE,
       p_gacc_tran_id           giac_acctrans.tran_id%TYPE,
       p_user_id                giis_users.user_id%TYPE,
       p_claim_id               gicl_basic_intm_v1.claim_id%TYPE,
       p_msg_alert          OUT VARCHAR2)
    IS
       ws_gl_acct_category           giac_acct_entries.gl_acct_category%TYPE;
       ws_gl_control_acct            giac_acct_entries.gl_control_acct%TYPE;
       ws_gl_sub_acct_1              giac_acct_entries.gl_sub_acct_1%TYPE;
       ws_gl_sub_acct_2              giac_acct_entries.gl_sub_acct_2%TYPE;
       ws_gl_sub_acct_3              giac_acct_entries.gl_sub_acct_3%TYPE;
       ws_gl_sub_acct_4              giac_acct_entries.gl_sub_acct_4%TYPE;
       ws_gl_sub_acct_5              giac_acct_entries.gl_sub_acct_5%TYPE;
       ws_gl_sub_acct_6              giac_acct_entries.gl_sub_acct_6%TYPE;
       ws_gl_sub_acct_7              giac_acct_entries.gl_sub_acct_7%TYPE;
       ws_pol_type_tag               giac_module_entries.pol_type_tag%TYPE;
       ws_intm_type_level            giac_module_entries.intm_type_level%TYPE;
       ws_old_new_acct_level         giac_module_entries.old_new_acct_level%TYPE;
       ws_line_dep_level             giac_module_entries.line_dependency_level%TYPE;
       ws_dr_cr_tag                  giac_module_entries.dr_cr_tag%TYPE;
       ws_acct_intm_cd               giis_intm_type.acct_intm_cd%TYPE;
       ws_line_cd                    gipi_polbasic.line_cd%TYPE;
       ws_iss_cd                     gipi_polbasic.iss_cd%TYPE;
       ws_old_acct_cd                giac_acct_entries.gl_sub_acct_2%TYPE;
       ws_new_acct_cd                giac_acct_entries.gl_sub_acct_2%TYPE;
       pt_gl_sub_acct_1              giac_acct_entries.gl_sub_acct_1%TYPE;
       pt_gl_sub_acct_2              giac_acct_entries.gl_sub_acct_2%TYPE;
       pt_gl_sub_acct_3              giac_acct_entries.gl_sub_acct_3%TYPE;
       pt_gl_sub_acct_4              giac_acct_entries.gl_sub_acct_4%TYPE;
       pt_gl_sub_acct_5              giac_acct_entries.gl_sub_acct_5%TYPE;
       pt_gl_sub_acct_6              giac_acct_entries.gl_sub_acct_6%TYPE;
       pt_gl_sub_acct_7              giac_acct_entries.gl_sub_acct_7%TYPE;
       ws_debit_amt                  giac_acct_entries.debit_amt%TYPE;
       ws_credit_amt                 giac_acct_entries.credit_amt%TYPE;
       ws_gl_acct_id                 giac_acct_entries.gl_acct_id%TYPE;
       v_sl_type                     giac_chart_of_accts.gslt_sl_type_cd%TYPE;
       v_sl_cd                       giac_acct_entries.sl_cd%TYPE;
    BEGIN
       /**************************************************************************
       *                                                                         *
       * Populate the GL Account Code used in every transactions.                *
       *                                                                         *
       **************************************************************************/
       BEGIN
          SELECT        gl_acct_category, gl_control_acct,
                        gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                        gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                        gl_sub_acct_7, pol_type_tag, intm_type_level,
                        old_new_acct_level, dr_cr_tag, line_dependency_level
                   INTO ws_gl_acct_category, ws_gl_control_acct,
                        ws_gl_sub_acct_1, ws_gl_sub_acct_2, ws_gl_sub_acct_3,
                        ws_gl_sub_acct_4, ws_gl_sub_acct_5, ws_gl_sub_acct_6,
                        ws_gl_sub_acct_7, ws_pol_type_tag, ws_intm_type_level,
                        ws_old_new_acct_level, ws_dr_cr_tag, ws_line_dep_level
                   FROM giac_module_entries
                  WHERE module_id = aeg_module_id AND item_no = aeg_item_no
          FOR UPDATE OF gl_sub_acct_1;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             p_msg_alert := 'No data found in giac_module_entries.';
             RETURN;
       END;

       /**************************************************************************
       *                                                                         *
       * Validate the INTM_TYPE_LEVEL value which indicates the segment of the   *
       * GL account code that holds the intermediary type.                       *
       *                                                                         *
       **************************************************************************/
       IF ws_intm_type_level != 0 THEN
          giac_acct_entries_pkg.aeg_check_level(
             ws_intm_type_level,
             ws_acct_intm_cd,
             ws_gl_sub_acct_1,
             ws_gl_sub_acct_2,
             ws_gl_sub_acct_3,
             ws_gl_sub_acct_4,
             ws_gl_sub_acct_5,
             ws_gl_sub_acct_6,
             ws_gl_sub_acct_7);
       END IF;

       /**************************************************************************
       *                                                                         *
       * Validate the LINE_DEPENDENCY_LEVEL value which indicates the segment of *
       * the GL account code that holds the line number.                         *
       *                                                                         *
       **************************************************************************/
       IF ws_line_dep_level != 0 THEN
          BEGIN
             SELECT acct_line_cd
               INTO ws_line_cd
               FROM giis_line
              WHERE line_cd = aeg_line_cd;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                p_msg_alert := 'No data found in giis_line.';
                RETURN;
          END;

          giac_acct_entries_pkg.aeg_check_level (
             ws_line_dep_level,
             ws_line_cd,
             ws_gl_sub_acct_1,
             ws_gl_sub_acct_2,
             ws_gl_sub_acct_3,
             ws_gl_sub_acct_4,
             ws_gl_sub_acct_5,
             ws_gl_sub_acct_6,
             ws_gl_sub_acct_7);
       END IF;

       /**************************************************************************
       *                                                                         *
       * Validate the OLD_NEW_ACCT_LEVEL value which indicates the segment of    *
       * the GL account code that holds the old and new account values.          *
       *                                                                         *
       **************************************************************************/
       IF ws_old_new_acct_level != 0 THEN
          BEGIN
             BEGIN
                SELECT param_value_v
                  INTO ws_iss_cd
                  FROM giac_parameters
                 WHERE param_name = 'OLD_ISS_CD';
             END;

             BEGIN
                SELECT param_value_n
                  INTO ws_old_acct_cd
                  FROM giac_parameters
                 WHERE param_name = 'OLD_ACCT_CD';
             END;

             BEGIN
                SELECT param_value_n
                  INTO ws_new_acct_cd
                  FROM giac_parameters
                 WHERE param_name = 'NEW_ACCT_CD';
             END;

             IF aeg_iss_cd = ws_iss_cd THEN
                giac_acct_entries_pkg.aeg_check_level (
                   ws_old_new_acct_level,
                   ws_old_acct_cd,
                   ws_gl_sub_acct_1,
                   ws_gl_sub_acct_2,
                   ws_gl_sub_acct_3,
                   ws_gl_sub_acct_4,
                   ws_gl_sub_acct_5,
                   ws_gl_sub_acct_6,
                   ws_gl_sub_acct_7);
             ELSE
                giac_acct_entries_pkg.aeg_check_level (
                   ws_old_new_acct_level,
                   ws_new_acct_cd,
                   ws_gl_sub_acct_1,
                   ws_gl_sub_acct_2,
                   ws_gl_sub_acct_3,
                   ws_gl_sub_acct_4,
                   ws_gl_sub_acct_5,
                   ws_gl_sub_acct_6,
                   ws_gl_sub_acct_7);
             END IF;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                p_msg_alert := 'No data found in giac_parameters.';
                RETURN;
          END;
       END IF;

      /**************************************************************************
      *                                                                         *
      * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
      *                                                                         *
      **************************************************************************/
       giac_acct_entries_pkg.aeg_check_chart_of_accts (
          ws_gl_acct_category,
          ws_gl_control_acct,
          ws_gl_sub_acct_1,
          ws_gl_sub_acct_2,
          ws_gl_sub_acct_3,
          ws_gl_sub_acct_4,
          ws_gl_sub_acct_5,
          ws_gl_sub_acct_6,
          ws_gl_sub_acct_7,
          ws_gl_acct_id,
          p_msg_alert);

       /****************************************************************************
       *                                                                           *
       * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
       * debit-credit tag to determine whether the positive amount will be debited *
       * or credited.                                                              *
       *                                                                           *
       ****************************************************************************/
       IF ws_dr_cr_tag = 'D' THEN
          IF aeg_acct_amt > 0 THEN
             ws_debit_amt := ABS (aeg_acct_amt);
             ws_credit_amt := 0;
          ELSE
             ws_debit_amt := 0;
             ws_credit_amt := ABS (aeg_acct_amt);
          END IF;
       ELSE
          IF aeg_acct_amt > 0 THEN
             ws_debit_amt := 0;
             ws_credit_amt := ABS (aeg_acct_amt);
          ELSE
             ws_debit_amt := ABS (aeg_acct_amt);
             ws_credit_amt := 0;
          END IF;
       END IF;

       /****************************************************************************
       *                                                                           *
       * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
       * same transaction id.  Insert the record if it does not exists else update *
       * the existing record.                                                      *
       *                                                                           *
       ****************************************************************************/
       v_sl_cd := aeg_sl_cd;
       BEGIN
          BEGIN
             SELECT gslt_sl_type_cd
               INTO v_sl_type
               FROM giac_chart_of_accts
              WHERE gl_acct_id = ws_gl_acct_id;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                v_sl_type := NULL;
          END;
       END;

       IF giacp.v ('INTM_SL_TYPE') = v_sl_type THEN
          FOR i IN (SELECT intrmdry_intm_no
                      FROM gicl_basic_intm_v1
                     WHERE claim_id = p_claim_id)
          LOOP
            v_sl_cd := i.intrmdry_intm_no;     
          END LOOP;     
       ELSIF giacp.v ('ASSD_SL_TYPE') = v_sl_type THEN
          NULL; -- AEG_SL_CD BY DEFAULT = ASSD_NO (SET IN AEG_PARAMETERS)
       ELSE
          v_sl_cd := NULL; --SET TO NULL IF NO SL_TYPE_CD HAS BEEN SET UP IN CHART OF ACCTS
       END IF;
       aeg_insert_update_acct_entries (
          ws_gl_acct_category,
          ws_gl_control_acct,
          ws_gl_sub_acct_1,
          ws_gl_sub_acct_2,
          ws_gl_sub_acct_3,
          ws_gl_sub_acct_4,
          ws_gl_sub_acct_5,
          ws_gl_sub_acct_6,
          ws_gl_sub_acct_7,
          v_sl_cd,
          v_sl_type,
          aeg_gen_type,
          ws_gl_acct_id,
          ws_debit_amt,
          ws_credit_amt,
          p_gacc_branch_cd,
          p_gacc_fund_cd,
          p_gacc_tran_id,
          p_user_id);
    END;

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-14-2010 
    **  Reference By : GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  aeg_parameters program unit 
    */ 
    PROCEDURE aeg_parameters (
        p_module_name            giac_modules.module_name%TYPE,
        p_gacc_branch_cd         giac_acctrans.gibr_branch_cd%TYPE,
        p_gacc_fund_cd           giac_acctrans.gfun_fund_cd%TYPE,
        p_gacc_tran_id           giac_acctrans.tran_id%TYPE,
        p_user_id                giis_users.user_id%TYPE,
        p_claim_id               gicl_basic_intm_v1.claim_id%TYPE,
        p_msg_alert          OUT VARCHAR2)
    IS
      CURSOR rcvry_cur IS
        SELECT a.iss_cd, a.line_cd, a.assd_no, b.collection_amt
          FROM gicl_claims a, giac_loss_recoveries b
         WHERE a.claim_id = b.claim_id
           AND b.gacc_tran_id = p_gacc_tran_id
           AND b.acct_ent_tag = 'Y';           --added by judyann 04212003
      
      v_module_id       giac_modules.module_id%TYPE;
      v_gen_type        giac_modules.generation_type%TYPE;
      v_item_no         GIAC_MODULE_ENTRIES.item_no%TYPE := 1;
    BEGIN
        BEGIN
           SELECT module_id, generation_type
             INTO v_module_id, v_gen_type
             FROM giac_modules
            WHERE module_name = p_module_name;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            p_msg_alert := 'No data found in GIAC MODULES.';
            RETURN;
        END;

        giac_acct_entries_pkg.aeg_delete_acct_entries(p_gacc_tran_id, v_gen_type);

        FOR rcvry_rec IN rcvry_cur
        LOOP
          aeg_create_acct_entries (rcvry_rec.assd_no, 
                                   v_module_id,
                                   v_item_no, 
                                   rcvry_rec.iss_cd,
                                   rcvry_rec.line_cd, 
                                   rcvry_rec.collection_amt,
                                   v_gen_type,
                                   p_gacc_branch_cd,
                                   p_gacc_fund_cd,
                                   p_gacc_tran_id,
                                   p_user_id,
                                   p_claim_id,
                                   p_msg_alert);
        END LOOP;
    END;
    
   FUNCTION check_collection_amt(
      p_recovery_id           giac_loss_recoveries.recovery_id%TYPE,
      p_claim_id              giac_loss_recoveries.claim_id%TYPE
   )
     RETURN VARCHAR2
   IS
   BEGIN
      FOR a IN(SELECT recoverable_amt * convert_rate recoverable_amt
                 FROM gicl_clm_recovery 
                WHERE claim_id = p_claim_id
                  AND recovery_id = p_recovery_id)
      LOOP
         FOR b IN(SELECT NVL(SUM(NVL(a100.collection_amt,0)),0) total_rec
                    FROM giac_loss_recoveries a100,
                         giac_acctrans b100
                   WHERE a100.gacc_tran_id = b100.tran_id
                     AND a100.transaction_type IN (1,2)
                     AND b100.tran_flag != 'D'
                     AND NOT EXISTS (SELECT 1
                                       FROM giac_acctrans c100,
                                            giac_reversals d100
                                      WHERE d100.gacc_tran_id = b100.tran_id
                                        AND c100.tran_id    = d100.reversing_tran_id
                                        AND c100.tran_flag != 'D')
                     AND a100.claim_id = p_claim_id)
         LOOP
            RETURN NVL(a.recoverable_amt, 0) - NVL(b.total_rec, 0);
         END LOOP;
      END LOOP;
   END;
   
   FUNCTION get_payor_name_tran1(
      p_line_cd               gicl_clm_recovery.line_cd%TYPE,
      p_iss_cd                gicl_clm_recovery.iss_cd%TYPE,
      p_rec_year              gicl_clm_recovery.rec_year%TYPE,
      p_rec_seq_no            gicl_clm_recovery.rec_seq_no%TYPE,
      p_user_id               giis_users.user_id%TYPE
   )
     RETURN payor_name_list_tab PIPELINED
   IS
      v_payor_name	         payor_name_list_type;
   BEGIN
      FOR i IN (SELECT d.payor_class_cd, e.class_desc, d.payor_cd,
			              DECODE (f.payee_first_name, NULL, f.payee_last_name,
                                f.payee_last_name
                             || ', '
                             || f.payee_first_name
                             || ' '
                             || f.payee_middle_name
                            ) payor_name
                  FROM gicl_clm_recovery a,
                       gicl_claims b,
                       giis_recovery_type c,
                       gicl_recovery_payor d,
                       giis_payee_class e,
                       giis_payees f
                 WHERE a.claim_id = b.claim_id
                   AND a.rec_type_cd = c.rec_type_cd
                   AND d.claim_id = a.claim_id
                   AND d.recovery_id = a.recovery_id
                   AND d.payor_class_cd = e.payee_class_cd
                   AND d.payor_cd = f.payee_no
                   AND d.payor_class_cd = f.payee_class_cd
                   AND e.payee_class_cd = f.payee_class_cd
                   AND a.cancel_tag IS NULL
                   AND a.line_cd = p_line_cd
                   AND a.iss_cd = p_iss_cd
                   AND a.rec_year = p_rec_year
                   AND a.rec_seq_no = p_rec_seq_no
                   AND GIAC_LOSS_RECOVERIES_PKG.check_collection_amt(a.recovery_id, b.claim_id) <> 0
                   AND check_user_per_iss_cd_acctg2(NULL, a.iss_cd, 'GIACS010', p_user_id) = 1)
      LOOP
         v_payor_name.payor_class_cd := i.payor_class_cd;
         v_payor_name.class_desc := i.class_desc;
         v_payor_name.payor_cd := i.payor_cd;
         v_payor_name.payor_name := i.payor_name;
         PIPE ROW(v_payor_name);
      END LOOP;
   END;

END;
/