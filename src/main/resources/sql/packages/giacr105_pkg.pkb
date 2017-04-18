CREATE OR REPLACE PACKAGE BODY CPI.giacr105_pkg
AS
   FUNCTION get_giacr105_records (
      p_ri_cd       giri_binder.ri_cd%TYPE,
      p_line_cd     giri_binder.line_cd%TYPE,
      p_date_type   VARCHAR2,
      p_date_from   DATE,
      p_date_to     DATE
   )
      RETURN giacr105_records_tab PIPELINED
   IS
      v_rec         giacr105_records_type;
      v_coll        NUMBER;
      v_not_exist   BOOLEAN               := TRUE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_rec.cf_company
           FROM giis_parameters
          WHERE UPPER (param_name) = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_rec.cf_company_address
           FROM giis_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.cf_company := NULL;
      END;

      IF p_date_type = '1'
      THEN
         v_rec.cf_basis := 'Based on Issue Date';
      ELSIF p_date_type = '2'
      THEN
         v_rec.cf_basis := 'Based on Effectivity Date';
      ELSIF p_date_type = '3'
      THEN
         v_rec.cf_basis := 'Based on Accounting Entry Date';
      ELSIF p_date_type = '4'
      THEN
         v_rec.cf_basis := 'Based on Booking Date';
      END IF;

      v_rec.cf_from_date := TO_CHAR (p_date_from, 'FMMonth DD, YYYY');
      v_rec.cf_to_date := TO_CHAR (p_date_to, 'FMMonth DD, YYYY');

      FOR i IN
         (
-- JHING 06/02/2011 select statements for positive records
--Note dummy2 is a field that is used by the report to distinguish between reversal and non-reversal records when the result set of this query is joined with the result set of the Q_2 query for the computation of balances
--frps_seq_no and frps_yy are also retrieved as field list, this allows the report to display reused binders in multiple frps/distribution group
          SELECT gp.pol_flag, gr.ri_name, gl.line_name, (gp.eff_date) eff_dt,
                    get_policy_no (gp.policy_id)
                 || DECODE (gp.ref_pol_no,
                            NULL, NULL,
                            ' / ' || gp.ref_pol_no
                           ) policy_no,
                 DECODE (gp.ref_pol_no,
                         NULL, NULL,
                         gp.ref_pol_no
                        ) ref_pol_no,
                    giv.iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (giv.prem_seq_no, '0000000')) invoice_no,
                 gi.ri_policy_no,
                    gi.ri_policy_no
                 || DECODE (gi.ri_policy_no, NULL, NULL, ' /') ri_policy_no2,
                 gi.ri_binder_no, gia.assd_name, gp.tsi_amt,
                 ROUND (NVL (giv.prem_amt, 0) * NVL (currency_rt, 1),
                        2
                       ) gross_premium,
                 NVL (giv.ri_comm_amt, 0) * giv.currency_rt ri_commission,
                 (  ROUND (NVL (giv.prem_amt, 0) * NVL (giv.currency_rt, 1),
                           2)
                  + ROUND (NVL (giv.tax_amt, 0) * NVL (giv.currency_rt, 1), 2)
                  - ROUND (NVL (giv.ri_comm_amt, 0) * NVL (giv.currency_rt, 1),
                           2
                          )
                  - ROUND (NVL (giv.ri_comm_vat, 0) * NVL (giv.currency_rt, 1),
                           2
                          )
                 ) net_premium,
                 garsd.prem_seq_no, garsd.a180_ri_cd, garsd.inst_no,
                 NVL (gipc.collection_amt, 0) gipc_collection_amt,
                 gipc.gacc_tran_id gacc_tran_id,
                 ROUND (NVL (giv.tax_amt, 0) * NVL (giv.currency_rt, 1),
                        2
                       ) evat,
                 ROUND (NVL (giv.ri_comm_vat, 0) * NVL (giv.currency_rt, 1),
                        2
                       ) vat,
                 gp.issue_date,
                 gp.policy_id pol_id                 
            FROM giac_aging_ri_soa_details garsd,
                 giis_line gl,
                 giis_reinsurer gr,
                 giri_inpolbas gi,
                 gipi_invoice giv,
                 gipi_polbasic gp,
                 giis_assured gia,
                 (SELECT gipc.gacc_tran_id, gipc.b140_iss_cd,
                         gipc.b140_prem_seq_no, gipc.a180_ri_cd,
                         gipc.collection_amt, gipc.inst_no
                    FROM giac_inwfacul_prem_collns gipc, giac_acctrans apr
                   WHERE gipc.gacc_tran_id = apr.tran_id
                     AND apr.tran_flag != 'D'
                     AND NOT EXISTS (
                            SELECT 'X'
                              FROM giac_reversals gr, giac_acctrans ga
                             WHERE gr.reversing_tran_id = ga.tran_id
                               AND gipc.gacc_tran_id = ga.tran_id
                               AND ga.tran_flag != 'D')) gipc
           WHERE garsd.a180_ri_cd = gr.ri_cd
             AND garsd.prem_seq_no = giv.prem_seq_no
             AND garsd.a150_line_cd = gl.line_cd
             AND garsd.a180_ri_cd = gi.ri_cd
             AND gi.policy_id = giv.policy_id
             AND gi.policy_id = gp.policy_id
             AND garsd.prem_seq_no = gipc.b140_prem_seq_no(+)
             AND garsd.a180_ri_cd = gipc.a180_ri_cd(+)
             AND garsd.inst_no = gipc.inst_no(+)
             AND gipc.b140_iss_cd(+) = 'RI'
             AND giv.iss_cd = 'RI'
             AND gia.assd_no = gp.assd_no
             AND garsd.a180_ri_cd = NVL (p_ri_cd, garsd.a180_ri_cd)
             AND garsd.a150_line_cd = NVL (p_line_cd, garsd.a150_line_cd)
             AND gp.pol_flag <> '5' -- robert GENQA 5269 -- changed from 5 to '5'
             AND DECODE (p_date_type,
                         '1', TRUNC (gp.issue_date),
                         '2', TRUNC (gp.eff_date),
                         '3', TRUNC (gp.acct_ent_date),
                         '4', LAST_DAY (TO_DATE (   booking_mth
                                                 || ','
                                                 || TO_CHAR (booking_year),
                                                 'FMMONTH,YYYY'
                                                )
                                       )
                        ) BETWEEN p_date_from AND p_date_to
          UNION
          SELECT gp.pol_flag, gr.ri_name, gl.line_name, (gp.eff_date) eff_dt,
                    get_policy_no (gp.policy_id)
                 || DECODE (gp.ref_pol_no,
                            NULL, NULL,
                            ' / ' || gp.ref_pol_no
                           ) policy_no,
                 DECODE (gp.ref_pol_no,
                         NULL, NULL,
                         gp.ref_pol_no
                        ) ref_pol_no,
                    giv.iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (giv.prem_seq_no, '0000000')) invoice_no,
                 gi.ri_policy_no,
                    gi.ri_policy_no
                 || DECODE (gi.ri_policy_no, NULL, NULL, ' /') ri_policy_no2,
                 gi.ri_binder_no, gia.assd_name, gp.tsi_amt,
                 ROUND (NVL (giv.prem_amt, 0) * NVL (currency_rt, 1),
                        2
                       ) gross_premium,
                 NVL (giv.ri_comm_amt, 0) * giv.currency_rt ri_commission,
                 (  ROUND (NVL (giv.prem_amt, 0) * NVL (giv.currency_rt, 1),
                           2)
                  + ROUND (NVL (giv.tax_amt, 0) * NVL (giv.currency_rt, 1), 2)
                  - ROUND (NVL (giv.ri_comm_amt, 0) * NVL (giv.currency_rt, 1),
                           2
                          )
                  - ROUND (NVL (giv.ri_comm_vat, 0) * NVL (giv.currency_rt, 1),
                           2
                          )
                 ) net_premium,
                 garsd.prem_seq_no, garsd.a180_ri_cd, garsd.inst_no,
                 - (gipc.collection_amt) gipc_collection_amt,
                 gipc.gacc_tran_id gacc_tran_id,
                 ROUND (NVL (giv.tax_amt, 0) * NVL (giv.currency_rt, 1),
                        2
                       ) evat,
                 ROUND (NVL (giv.ri_comm_vat, 0) * NVL (giv.currency_rt, 1),
                        2
                       ) vat,
                 gp.issue_date,
                 gp.policy_id pol_id
            FROM giac_aging_ri_soa_details garsd,
                 giis_line gl,
                 giis_reinsurer gr,
                 giri_inpolbas gi,
                 gipi_invoice giv,
                 gipi_polbasic gp,
                 giac_inwfacul_prem_collns gipc,
                 giac_order_of_payts gop,
                 giis_assured gia,
                 giac_acctrans ga
           WHERE garsd.a180_ri_cd = gr.ri_cd
             AND garsd.prem_seq_no = giv.prem_seq_no
             AND garsd.a150_line_cd = gl.line_cd
             AND garsd.a180_ri_cd = gi.ri_cd
             AND gi.policy_id = giv.policy_id
             AND gi.policy_id = gp.policy_id
             AND garsd.prem_seq_no = gipc.b140_prem_seq_no
             AND garsd.a180_ri_cd = gipc.a180_ri_cd
             AND garsd.inst_no = gipc.inst_no
             AND gipc.b140_iss_cd = 'RI'
             AND giv.iss_cd = 'RI'
             AND gia.assd_no = gp.assd_no
             AND garsd.a180_ri_cd = NVL (p_ri_cd, garsd.a180_ri_cd)
             AND garsd.a150_line_cd = NVL (p_line_cd, garsd.a150_line_cd)
             AND gipc.gacc_tran_id = gop.gacc_tran_id
             AND gop.or_flag = 'C'
             AND gipc.gacc_tran_id = ga.tran_id
             AND ga.tran_flag != 'D'
             AND NOT EXISTS (
                    SELECT 'X'
                      FROM giac_reversals gr, giac_acctrans ga
                     WHERE gr.reversing_tran_id = ga.tran_id
                       AND gipc.gacc_tran_id = ga.tran_id
                       AND ga.tran_flag = 'D')
             AND gp.pol_flag <> '5'  -- robert GENQA 5269 -- changed from 5 to '5'
             AND DECODE (p_date_type,
                         '1', TRUNC (gp.issue_date),
                         '2', TRUNC (gp.eff_date),
                         '3', TRUNC (gp.acct_ent_date),
                         '4', LAST_DAY (TO_DATE (   booking_mth
                                                 || ','
                                                 || TO_CHAR (booking_year),
                                                 'FMMONTH,YYYY'
                                                )
                                       )
                        ) BETWEEN p_date_from AND p_date_to
    ORDER BY ri_name,
             line_name,
             policy_no,
             pol_id,
             eff_dt,
             ref_pol_no,
             ri_policy_no,
             gacc_tran_id,
             gipc_collection_amt DESC)
      LOOP
             v_not_exist := FALSE;
             v_rec.ri_name := i.ri_name;
             v_rec.line_name := i.line_name;
         
         IF v_rec.pol_id = i.pol_id AND v_rec.prem_seq_no = i.prem_seq_no
         THEN
             v_rec.policy_no := NULL;
             v_rec.issue_date := NULL;
             v_rec.incept_date := NULL;
             v_rec.invoice_no := NULL;
             v_rec.policy_id := NULL;
             v_rec.binder_id := NULL;
             v_rec.assured := NULL;
             v_rec.amt_insured := NULL;
             v_rec.prem := NULL;
             v_rec.ri_prem_vat := NULL;
             v_rec.comm := NULL;
             v_rec.ri_comm_vat := NULL;
             v_rec.net_prem := NULL;
             v_rec.balance := NULL;             
         ELSE     
             v_rec.policy_no := i.policy_no;
             v_rec.issue_date := i.issue_date;
             v_rec.incept_date := i.eff_dt;
             v_rec.invoice_no := i.invoice_no;
             v_rec.policy_id := i.ri_policy_no2;
             v_rec.binder_id := i.ri_binder_no;
             v_rec.assured := i.assd_name;
             v_rec.amt_insured := i.tsi_amt;
             v_rec.prem := i.gross_premium;
             v_rec.ri_prem_vat := i.evat;
             v_rec.comm := i.ri_commission;
             v_rec.ri_comm_vat := i.vat;
             v_rec.net_prem := i.net_premium;
             v_rec.prem_seq_no := i.prem_seq_no;                          

             
             BEGIN
               SELECT SUM(a.collection_amt)
                 INTO v_coll
                 FROM giac_inwfacul_prem_collns a, giac_acctrans b
                WHERE a.b140_prem_seq_no = i.prem_seq_no
                  AND a.gacc_tran_id = b.tran_id
                  AND b.tran_flag != 'D'
                  AND NOT EXISTS (SELECT 'X'
                                    FROM giac_reversals x, giac_acctrans y
                                   WHERE x.reversing_tran_id = y.tran_id
                                     AND x.gacc_tran_id = b.tran_id
                                     AND y.tran_flag = 'D');
                
             v_rec.balance := v_rec.net_prem - NVL(v_coll, 0);
             END;                         
         END IF;
                                               
             v_rec.tran_id := i.gacc_tran_id;
             v_rec.pol_id := i.pol_id;
         
      PIPE ROW (v_rec);   
      END LOOP;

      IF v_not_exist
      THEN
         PIPE ROW (v_rec);
      END IF;
      
   END;
   
   -- jhing 01.31.2016 added new function which will be called by the main jasper report - GENQA 5269
    FUNCTION get_giacr105_records_v2 (p_ri_cd        giri_binder.ri_cd%TYPE,
                                      p_line_cd      giri_binder.line_cd%TYPE,
                                      p_date_type    VARCHAR2,
                                      p_date_from    DATE,
                                      p_date_to      DATE,
                                      p_user_id      VARCHAR2,
                                      p_module_id    VARCHAR2)
       RETURN giacr105_records_tab
       PIPELINED
    IS
       v_rec              giacr105_records_type;
       v_coll             NUMBER;
       v_not_exist        BOOLEAN := TRUE;
       v_tsi_amt          gipi_polbasic.tsi_amt%TYPE;
       v_cntPayt          NUMBER;
       v_collection_amt   giac_inwfacul_prem_collns.collection_amt%TYPE;
       v_balance_due      NUMBER (16, 2);
    BEGIN
       BEGIN
          SELECT param_value_v
            INTO v_rec.cf_company
            FROM giis_parameters
           WHERE UPPER (param_name) = 'COMPANY_NAME';
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_rec.cf_company := NULL;
       END;

       BEGIN
          SELECT param_value_v
            INTO v_rec.cf_company_address
            FROM giis_parameters
           WHERE param_name = 'COMPANY_ADDRESS';
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_rec.cf_company := NULL;
       END;

       IF p_date_type = '1'
       THEN
          v_rec.cf_basis := 'Based on Issue Date';
       ELSIF p_date_type = '2'
       THEN
          v_rec.cf_basis := 'Based on Effectivity Date';
       ELSIF p_date_type = '3'
       THEN
          v_rec.cf_basis := 'Based on Accounting Entry Date';
       ELSIF p_date_type = '4'
       THEN
          v_rec.cf_basis := 'Based on Booking Date';
       END IF;

       v_rec.cf_from_date := TO_CHAR (p_date_from, 'FMMonth DD, YYYY');
       v_rec.cf_to_date := TO_CHAR (p_date_to, 'FMMonth DD, YYYY');

       FOR i
          IN (SELECT gp.pol_flag,
                     gr.ri_cd,
                     gr.ri_name,
                     gl.line_name,
                     (gp.eff_date) eff_dt,
                        gp.line_cd
                     || '-'
                     || gp.subline_cd
                     || '-'
                     || gp.iss_cd
                     || '-'
                     || gp.issue_yy
                     || '-'
                     || LTRIM (TO_CHAR (gp.pol_seq_no, '0000000'))
                     || '-'
                     || LTRIM (TO_CHAR (gp.renew_no, '00'))
                     || DECODE (
                           gp.endt_seq_no,
                           0, NULL,
                              '/'
                           || gp.endt_iss_cd
                           || '-'
                           || gp.endt_yy
                           || '-'
                           || LTRIM (TO_CHAR (gp.endt_seq_no, '000000')))
                        policy_no,
                     DECODE (gp.ref_pol_no, NULL, NULL, gp.ref_pol_no) ref_pol_no,
                     giv.iss_cd || '-' || giv.prem_seq_no invoice_no,
                     gi.ri_policy_no,
                        gi.ri_policy_no
                     || DECODE (gi.ri_policy_no, NULL, NULL, ' /')
                        ri_policy_no2,
                     gi.ri_binder_no,
                     gia.assd_name,
                     gp.tsi_amt,
                     ROUND (NVL (giv.prem_amt, 0) * NVL (currency_rt, 1), 2)
                        gross_premium,
                     NVL (giv.ri_comm_amt, 0) * giv.currency_rt ri_commission,
                     (  ROUND (NVL (giv.prem_amt, 0) * NVL (giv.currency_rt, 1),
                               2)
                      + ROUND (NVL (giv.tax_amt, 0) * NVL (giv.currency_rt, 1),
                               2)
                      - ROUND (
                           NVL (giv.ri_comm_amt, 0) * NVL (giv.currency_rt, 1),
                           2)
                      - ROUND (
                           NVL (giv.ri_comm_vat, 0) * NVL (giv.currency_rt, 1),
                           2))
                        net_premium,
                     ROUND (NVL (giv.tax_amt, 0) * NVL (giv.currency_rt, 1), 2)
                        evat,
                     ROUND (NVL (giv.ri_comm_vat, 0) * NVL (giv.currency_rt, 1),
                            2)
                        vat,
                     gp.issue_date,
                     giv.iss_cd,
                     giv.prem_seq_no,
                     gp.line_cd
                FROM giis_line gl,
                     giis_reinsurer gr,
                     giri_inpolbas gi,
                     gipi_invoice giv,
                     gipi_polbasic gp,
                     giis_assured gia
               WHERE     gi.ri_cd = gr.ri_cd
                     AND gp.line_cd = gl.line_cd
                     AND gia.assd_no = gp.assd_no
                     AND gi.policy_id = giv.policy_id
                     AND gi.policy_id = gp.policy_id
                     AND giv.iss_cd = giisp.v ('ISS_CD_RI')
                     --AND gp.pol_flag <> '5' --Deo [08.10.2016]: modified condition for including spoiled policies
                     AND (   gp.pol_flag <> '5'
                          OR (    gp.pol_flag = '5'
                              AND NVL (gp.spld_acct_ent_date, gp.spld_date) >
                                                                      p_date_to
                             )
                         )
                     --end Deo [08.10.2016]
                     AND gi.ri_cd = NVL (p_ri_cd, gi.ri_cd)
                     AND gp.line_cd = NVL (p_line_cd, gp.line_cd)
                     AND (DECODE (
                             p_date_type,
                             '1', TRUNC (gp.issue_date),
                             '2', TRUNC (gp.eff_date),
                             '3', TRUNC (gp.acct_ent_date),
                             '4', LAST_DAY (
                                     TO_DATE (
                                           booking_mth
                                        || ','
                                        || TO_CHAR (booking_year),
                                        'FMMONTH,YYYY'))) BETWEEN p_date_from
                                                              AND p_date_to)
                     AND EXISTS
                            (SELECT 'X'
                               FROM TABLE (
                                       security_access.get_branch_line (
                                          'AC',
                                          p_module_id,
                                          p_user_id))
                              WHERE branch_cd = giisp.v ('ISS_CD_RI')))
       LOOP
          --Deo [08.10.2016]: added to consider update of ri commission (SR-22308)
          IF p_date_type = '3'
          THEN
             FOR j IN (SELECT   ROUND (a.old_ri_comm_amt * b.currency_rt,
                                       2
                                      ) old_ri_comm_amt,
                                ROUND (a.old_ri_comm_vat * b.currency_rt,
                                       2
                                      ) old_ri_comm_vat
                           FROM giac_ri_comm_hist a, gipi_invoice b
                          WHERE a.policy_id = b.policy_id
                            AND b.iss_cd = giisp.v ('ISS_CD_RI')
                            AND b.prem_seq_no = i.prem_seq_no
                            AND a.acct_ent_date <= p_date_to
                            AND TRUNC (a.post_date) > p_date_to
                       ORDER BY a.tran_id)
             LOOP
                i.ri_commission := j.old_ri_comm_amt;
                i.vat := j.old_ri_comm_vat;
                i.net_premium :=
                           i.gross_premium + i.evat - i.ri_commission - i.vat;
                EXIT;
             END LOOP;
          END IF;
          --end Deo [08.10.2016]
          
          v_not_exist := FALSE ;
          v_rec.ri_cd := i.ri_cd;
          v_rec.ri_name := i.ri_name;
          v_rec.line_cd := i.line_cd;
          v_rec.line_name := i.line_name;
          v_rec.pol_flag := i.pol_flag;
          v_rec.policy_no := i.policy_no;
          v_rec.issue_date := i.issue_date;
          v_rec.incept_date := i.eff_dt;
          v_rec.eff_date := i.eff_dt;
          v_rec.invoice_no := i.invoice_no;
          v_rec.policy_id := i.ri_policy_no2;
          v_rec.binder_id := i.ri_binder_no;
          v_rec.assured := i.assd_name;

          v_rec.prem := i.gross_premium;
          v_rec.ri_prem_vat := i.evat;
          v_rec.comm := i.ri_commission;
          v_rec.ri_comm_vat := i.vat;
          v_rec.net_prem := i.net_premium;
          v_rec.prem_seq_no := i.prem_seq_no;       
     
       
          -- get  tsi amount per bill
          v_tsi_amt := 0;

          FOR tx
             IN (SELECT NVL (SUM (NVL (A.TSI_AMT, 0) * NVL (B.CURRENCY_RT, 1)),
                             0)
                           sum_insured
                   FROM GIPI_INVPERIL A, GIPI_INVOICE B, GIIS_PERIL C
                  WHERE     A.ISS_CD = i.iss_cd
                        AND A.PREM_SEQ_NO = i.prem_seq_no
                        AND A.ISS_CD = B.ISS_CD
                        AND A.PREM_SEQ_NO = B.PREM_SEQ_NO
                        AND A.PERIL_CD = C.PERIL_CD
                        AND C.LINE_CD = i.line_cd
                        AND C.PERIL_TYPE = 'B')
          LOOP
             v_tsi_amt := tx.sum_insured;
          END LOOP;

          v_rec.amt_insured := v_tsi_amt;

          -- set variables that will be used in summing up amts equivalent to the original value
          v_rec.for_tot_prem := i.gross_premium;
          v_rec.for_tot_amt_insured := v_tsi_amt;
          v_rec.for_tot_net_prem := i.net_premium;
          v_rec.for_tot_comm := i.ri_commission;
          v_rec.for_tot_ri_comm_vat := i.vat;
          v_rec.for_tot_ri_prem_vat := i.evat;
          
          v_rec.tran_id := NULL;
          v_rec.tran_class := NULL; 
          v_rec.ref_date := NULL;
          v_rec.ref_no := NULL;
          v_rec.coll_amt := 0; 

       -- get total collection amt           
          v_collection_amt := 0;
          v_balance_due := i.net_premium ;
         
          FOR c2 IN (SELECT sum(nvl(a.collection_amt,0)) coll_amt
                          FROM giac_inwfacul_prem_collns a,
                               giac_acctrans d
                         WHERE d.tran_flag <> 'D'
                           AND a.gacc_tran_id = d.tran_id
                           AND NOT EXISTS (
                                  SELECT x.gacc_tran_id
                                    FROM giac_reversals x, giac_acctrans y
                                   WHERE x.reversing_tran_id = y.tran_id
                                     AND y.tran_flag <> 'D'
                                     AND x.gacc_tran_id = d.tran_id)
                           AND a.b140_iss_cd = i.iss_cd 
                           AND a.b140_prem_seq_no = i.prem_seq_no )
          LOOP          
                v_collection_amt := c2.coll_amt;
                v_balance_due := NVL (i.net_premium, 0) - NVL (v_collection_amt, 0);  
                EXIT;
          END LOOP;          
          
          v_balance_due := NVL (i.net_premium, 0) - NVL (v_collection_amt, 0); 
          v_rec.balance := v_balance_due ; 
          v_rec.for_tot_balance := v_balance_due;

          -- get collection amount
         v_cntPayt := 0; 
          v_rec.reCurPayt := 'N'; 
          FOR c2 IN (SELECT d.tran_date ref_date,
                               a.gacc_tran_id g_tran_id,
                               a.collection_amt coll_amt, d.tran_class t_class
                          FROM giac_inwfacul_prem_collns a,
                               giac_acctrans d
                         WHERE d.tran_flag <> 'D'
                           AND a.gacc_tran_id = d.tran_id
                           AND NOT EXISTS (
                                  SELECT x.gacc_tran_id
                                    FROM giac_reversals x, giac_acctrans y
                                   WHERE x.reversing_tran_id = y.tran_id
                                     AND y.tran_flag <> 'D'
                                     AND x.gacc_tran_id = d.tran_id)
                           AND a.b140_iss_cd = i.iss_cd 
                           AND a.b140_prem_seq_no = i.prem_seq_no
                           ORDER BY a.gacc_tran_id )
          LOOP
              v_rec.ref_date := c2.ref_date;
              v_rec.ref_no := get_ref_no(c2.g_tran_id);
              v_rec.coll_amt := NVL(c2.coll_amt,0); 
              v_rec.tran_id := c2.g_tran_id;
              v_rec.tran_class := c2.t_class; 
              
              IF v_cntPayt > 0 THEN 
                  v_rec.reCurPayt := 'Y'; 
                  v_rec.for_tot_prem := 0 ;
                  v_rec.for_tot_ri_comm_vat := 0 ;
                  v_rec.for_tot_comm := 0 ;
                  v_rec.for_tot_ri_prem_vat := 0 ;
                  v_rec.for_tot_net_prem := 0 ;
                  v_rec.for_tot_amt_insured := 0 ;
                  v_rec.for_tot_balance := 0  ;    
               END IF; 
              
              
              PIPE ROW (v_rec);    
              v_cntPayt := v_cntPayt + 1; 
                                                         
          END LOOP;                                               

          -- if there are no payments for the bill, output the record as is 
          IF v_cntPayt = 0 THEN
          
               v_rec.ref_date := NULL ;
              v_rec.ref_no := NULL ;
              v_rec.coll_amt := 0 ;  
              PIPE ROW (v_rec);    
          END IF; 
 
       END LOOP;

--       IF v_not_exist
--       THEN
--          PIPE ROW (v_rec);
--       END IF;
    END;

   FUNCTION get_binder_dtl (
      p_ri_cd       giri_binder.ri_cd%TYPE,
      p_line_cd     giri_binder.line_cd%TYPE,
      p_date_type   VARCHAR2,
      p_date_from   DATE,
      p_date_to     DATE,
      p_tran_id     giac_inwfacul_prem_collns.gacc_tran_id%TYPE,
      p_pol_id      gipi_polbasic.policy_id%TYPE,
      p_prem_seq_no giac_aging_ri_soa_details.prem_seq_no%TYPE
   )
      RETURN binder_dtl_tab PIPELINED
   IS
      v_not_exist   BOOLEAN := TRUE;
      v_rec         binder_dtl_type;
      v_tran_class  VARCHAR2(3);
   BEGIN
      
      FOR binder IN
         (SELECT NVL (gipc.collection_amt, 0) gipc_collection_amt,
                 gipc.gacc_tran_id gacc_tran_id,
                 gp.pol_flag
            FROM giac_aging_ri_soa_details garsd,
                 giis_line gl,
                 giis_reinsurer gr,
                 giri_inpolbas gi,
                 gipi_invoice giv,
                 gipi_polbasic gp,
                 giis_assured gia,
                 (SELECT gipc.gacc_tran_id, gipc.b140_iss_cd,
                         gipc.b140_prem_seq_no, gipc.a180_ri_cd,
                         gipc.collection_amt, gipc.inst_no
                    FROM giac_inwfacul_prem_collns gipc, giac_acctrans apr
                   WHERE gipc.gacc_tran_id = apr.tran_id
                     AND apr.tran_flag != 'D'
                     AND NOT EXISTS (
                            SELECT 'X'
                              FROM giac_reversals gr, giac_acctrans ga
                             WHERE gr.reversing_tran_id = ga.tran_id
                               AND gipc.gacc_tran_id = ga.tran_id
                               AND ga.tran_flag != 'D')) gipc
           WHERE garsd.a180_ri_cd = gr.ri_cd
             AND garsd.prem_seq_no = giv.prem_seq_no
             AND garsd.a150_line_cd = gl.line_cd
             AND garsd.a180_ri_cd = gi.ri_cd
             AND gi.policy_id = giv.policy_id
             AND gi.policy_id = gp.policy_id
             AND garsd.prem_seq_no = gipc.b140_prem_seq_no(+)
             AND garsd.a180_ri_cd = gipc.a180_ri_cd(+)
             AND garsd.inst_no = gipc.inst_no(+)
             AND gipc.b140_iss_cd(+) = 'RI'
             AND giv.iss_cd = 'RI'
             AND gia.assd_no = gp.assd_no
             AND garsd.a180_ri_cd = NVL (p_ri_cd, garsd.a180_ri_cd)
             AND garsd.a150_line_cd = NVL (p_line_cd, garsd.a150_line_cd)             
             AND gp.pol_flag <> '5'  -- robert GENQA 5269 -- changed from 5 to '5'
             AND gipc.gacc_tran_id = p_tran_id
             AND gp.policy_id = p_pol_id
             AND gipc.b140_prem_seq_no = p_prem_seq_no
             AND DECODE (p_date_type,
                         '1', TRUNC (gp.issue_date),
                         '2', TRUNC (gp.eff_date),
                         '3', TRUNC (gp.acct_ent_date),
                         '4', LAST_DAY (TO_DATE (   booking_mth
                                                 || ','
                                                 || TO_CHAR (booking_year),
                                                 'FMMONTH,YYYY'
                                                )
                                       )
                        ) BETWEEN p_date_from AND p_date_to
          UNION
          SELECT - (gipc.collection_amt) gipc_collection_amt,
                 gipc.gacc_tran_id gacc_tran_id,
                 gp.pol_flag
            FROM giac_aging_ri_soa_details garsd,
                 giis_line gl,
                 giis_reinsurer gr,
                 giri_inpolbas gi,
                 gipi_invoice giv,
                 gipi_polbasic gp,
                 giac_inwfacul_prem_collns gipc,
                 giac_order_of_payts gop,
                 giis_assured gia,
                 giac_acctrans ga
           WHERE garsd.a180_ri_cd = gr.ri_cd
             AND garsd.prem_seq_no = giv.prem_seq_no
             AND garsd.a150_line_cd = gl.line_cd
             AND garsd.a180_ri_cd = gi.ri_cd
             AND gi.policy_id = giv.policy_id
             AND gi.policy_id = gp.policy_id
             AND garsd.prem_seq_no = gipc.b140_prem_seq_no
             AND garsd.a180_ri_cd = gipc.a180_ri_cd
             AND garsd.inst_no = gipc.inst_no
             AND gipc.b140_iss_cd = 'RI'
             AND giv.iss_cd = 'RI'
             AND gia.assd_no = gp.assd_no
             AND garsd.a180_ri_cd = NVL (p_ri_cd, garsd.a180_ri_cd)
             AND garsd.a150_line_cd = NVL (p_line_cd, garsd.a150_line_cd)
             AND gipc.gacc_tran_id = gop.gacc_tran_id
             AND gop.or_flag = 'C'
             AND gipc.gacc_tran_id = ga.tran_id
             AND gipc.gacc_tran_id = p_tran_id
             AND gp.policy_id = p_pol_id
             AND gipc.b140_prem_seq_no = p_prem_seq_no
             AND ga.tran_flag != 'D'
             AND NOT EXISTS (
                    SELECT 'X'
                      FROM giac_reversals gr, giac_acctrans ga
                     WHERE gr.reversing_tran_id = ga.tran_id
                       AND gipc.gacc_tran_id = ga.tran_id
                       AND ga.tran_flag = 'D')
             AND gp.pol_flag <> '5'  -- robert GENQA 5269 -- changed from 5 to '5'
             AND DECODE (p_date_type,
                         '1', TRUNC (gp.issue_date),
                         '2', TRUNC (gp.eff_date),
                         '3', TRUNC (gp.acct_ent_date),
                         '4', LAST_DAY (TO_DATE (   booking_mth
                                                 || ','
                                                 || TO_CHAR (booking_year),
                                                 'FMMONTH,YYYY'
                                                )
                                       )
                        ) BETWEEN p_date_from AND p_date_to
   ORDER BY gipc_collection_amt DESC, gacc_tran_id)
      LOOP
         v_not_exist := FALSE;
         
         BEGIN
            SELECT tran_class
              INTO v_tran_class
              FROM giac_acctrans
             WHERE tran_id = binder.gacc_tran_id;

            IF v_tran_class = 'DV'
            THEN
               SELECT TO_CHAR(TO_DATE(dv_print_date), 'mm-dd-yyyy') ,--|| DECODE (dv_print_date, NULL, NULL,' /'),
                      dv_pref || '-' || LPAD (TO_CHAR (dv_no), 10, '0')
                 INTO v_rec.ref_date, v_rec.ref_no
                 FROM giac_disb_vouchers
                WHERE gacc_tran_id = binder.gacc_tran_id;
            END IF;

            IF v_tran_class = 'COL'
            THEN
               SELECT TO_CHAR(TO_DATE(or_date), 'mm-dd-yyyy') ,--|| DECODE (or_date, NULL, NULL, ' /'),
                      or_pref_suf || '-' || LPAD (TO_CHAR (or_no), 10, '0')
                 INTO v_rec.ref_date, v_rec.ref_no
                 FROM giac_order_of_payts
                WHERE gacc_tran_id = binder.gacc_tran_id;
            END IF;

            IF v_tran_class = 'JV'
            THEN
               SELECT TO_CHAR(TO_DATE(tran_date), 'mm-dd-yyyy') ,--|| DECODE (tran_date, NULL, NULL, ' /'),
                      DECODE (jv_pref_suff, NULL, NULL, jv_pref_suff)
                      || DECODE (jv_pref_suff, NULL, NULL, '-')
                      || LPAD (TO_CHAR (tran_class_no), 10, '0')
                 INTO v_rec.ref_date, v_rec.ref_no
                 FROM giac_acctrans
                WHERE tran_id = binder.gacc_tran_id;
            END IF;

         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.ref_date := NULL;
               v_rec.ref_no := NULL;             
         END;           
         
         
         IF binder.gipc_collection_amt = 0
         THEN
            v_rec.coll_amt := 0;
         ELSE
            v_rec.coll_amt := NVL(binder.gipc_collection_amt, 0);
         END IF;
                         
         v_rec.tran_class := v_tran_class;
         v_rec.pol_flag := binder.pol_flag;

         PIPE ROW (v_rec);
      END LOOP;
      
      IF v_not_exist
      THEN
         v_rec.coll_amt := 0;
         PIPE ROW (v_rec);
      END IF;
   END;
END;
/


