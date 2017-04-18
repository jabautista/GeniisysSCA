CREATE OR REPLACE PACKAGE BODY CPI.giac_loss_ri_collns_pkg
AS
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-27-2010 
    **  Reference By : (GIACS009 - Ri Trans - Loss Recov from RI)  
    **  Description  :  CGFK$CHK_GCRR_GCRR_E150_FK program unit 
    */  
    PROCEDURE CGFK$CHK_GCRR_GCRR_E150_FK(
            p_a180_ri_cd          giac_loss_ri_collns.a180_ri_cd%TYPE,
            p_e150_line_cd        giac_loss_ri_collns.e150_line_cd%TYPE,
            p_e150_la_yy          giac_loss_ri_collns.e150_la_yy%TYPE,
            p_e150_fla_seq_no     giac_loss_ri_collns.e150_fla_seq_no%TYPE,
            p_msg_alert       OUT VARCHAR2
            ) IS
      CG$DUMMY VARCHAR2(1);      
    BEGIN
        DECLARE     
            CURSOR C IS
              SELECT DISTINCT '1'
                FROM GIIS_REINSURER A180, GICL_ADVS_FLA A
               WHERE A.RI_CD      = A180.RI_CD
                 AND A.LINE_CD    = NVL(p_e150_line_cd,A.LINE_CD)
                 AND A.LA_YY      = NVL(p_e150_la_yy,A.LA_YY)
                 AND A.FLA_SEQ_NO = NVL(p_e150_fla_seq_no,A.FLA_SEQ_NO)
                 AND A180.RI_CD   = NVL(p_a180_ri_cd,A180.RI_CD)
                 AND (A.cancel_tag <> 'Y' OR A.cancel_tag IS NULL); -- added by jerome 10-27-2010 
        BEGIN
            OPEN C;
            FETCH C
            INTO CG$DUMMY;
            IF C%NOTFOUND THEN
              RAISE NO_DATA_FOUND;
            END IF;
            CLOSE C;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              p_msg_alert := 'The RI code and Final Loss Advise No. does not exist.';
              RETURN;
            WHEN OTHERS THEN
              p_msg_alert := 'Error sql exception occured.';
              RETURN;
        END;     
    END;

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-27-2010 
    **  Reference By : (GIACS009 - Ri Trans - Loss Recov from RI)  
    **  Description  :  GET_DEFAULT_VALUE2 program unit 
    */  
    PROCEDURE GET_DEFAULT_VALUE(
        p_gacc_tran_id        IN  giac_loss_ri_collns.gacc_tran_id%TYPE,
        p_transaction_type    IN  giac_loss_ri_collns.transaction_type%TYPE,
        p_dsp_policy          IN  VARCHAR2,
        p_payee_type          IN  giac_loss_ri_collns.payee_type%TYPE,
        p_a180_ri_cd          IN  giac_loss_ri_collns.a180_ri_cd%TYPE,
        p_e150_line_cd        IN  giac_loss_ri_collns.e150_line_cd%TYPE,
        p_e150_la_yy          IN  giac_loss_ri_collns.e150_la_yy%TYPE,
        p_e150_fla_seq_no     IN  giac_loss_ri_collns.e150_fla_seq_no%TYPE,
        p_sve_collecion_amt   IN  giac_loss_ri_collns.collection_amt%TYPE,
        p_collecion_amt      OUT  giac_loss_ri_collns.collection_amt%TYPE,
        p_foreign_curr_amt   OUT  giac_loss_ri_collns.foreign_curr_amt%TYPE,
        p_currency_cd        OUT  giac_loss_ri_collns.currency_cd%TYPE,
        p_currency_desc      OUT  giis_currency.currency_desc%TYPE,
        p_convert_rate       OUT  giis_currency.currency_rt%TYPE, 
        p_msg_alert          OUT  VARCHAR2
        ) IS
      WS_LOSS_AMT    GIAC_LOSS_RI_COLLNS.COLLECTION_AMT%TYPE;
      WS_PAID_AMT    GIAC_LOSS_RI_COLLNS.COLLECTION_AMT%TYPE;
      WS_COLL_AMT    GIAC_LOSS_RI_COLLNS.COLLECTION_AMT%TYPE;
    BEGIN

    IF p_transaction_type = 1 THEN
      BEGIN
        /*FOR j IN (SELECT DECODE(e.payee_type,'L',e.loss_shr_amt,e.exp_shr_amt) amount
                   FROM gicl_advs_fla_type e,
                        gicl_claims b,
                        gicl_advs_fla d
                  WHERE 1=1
                    AND e.claim_id = d.claim_id
                    AND e.grp_seq_no = d.grp_seq_no
                    AND e.fla_id = d.fla_id
                    AND e.payee_type = p_payee_type
                    AND b.claim_id = d.claim_id
                    AND d.line_cd  = p_e150_line_cd
                    AND d.la_yy    = p_e150_la_yy
                    AND d.fla_seq_no = p_e150_fla_seq_no
                    AND d.ri_cd    = p_a180_ri_cd
                    AND (d.cancel_tag <> 'Y' OR d.cancel_tag IS NULL))*/
        --replaced by john 11.28.2014                    
        FOR j IN (SELECT  DECODE(e.payee_type,'L',e.loss_shr_amt,e.exp_shr_amt) * NVL(c.orig_curr_rate, c.convert_rate) amount, 
                              NVL(c.orig_curr_rate, c.convert_rate) currency_rate, NVL(c.orig_curr_cd, c.currency_cd) currency_cd
               FROM  gicl_advs_fla_type e,
                     gicl_claims b,
                     gicl_advice c,
                     gicl_advs_fla d
              WHERE 1=1
                AND e.claim_id = d.claim_id
                AND e.grp_seq_no = d.grp_seq_no
                AND e.fla_id = d.fla_id
                AND b.claim_id = d.claim_id
                AND c.claim_id = d.claim_id
                AND c.adv_fla_id = d.adv_fla_id
                AND e.payee_type = p_payee_type
                AND b.claim_id = d.claim_id
                AND d.line_cd  = p_e150_line_cd
                AND d.la_yy    = p_e150_la_yy
                AND d.fla_seq_no = p_e150_fla_seq_no
                AND d.ri_cd    = p_a180_ri_cd
                AND (d.cancel_tag <> 'Y' OR d.cancel_tag IS NULL))
        LOOP
          ws_loss_amt := j.amount;
          p_currency_cd := j.currency_cd; --John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI 
          p_convert_rate := j.currency_rate;
        END LOOP;
      END;
     
     /* Get collected amount from giac_loss_ri_collns. */
      FOR K IN (SELECT NVL(sum( nvl(A.collection_amt,0)),0) collection   
                  FROM GIAC_LOSS_RI_COLLNS A, GIAC_ACCTRANS B
                 WHERE A.GACC_TRAN_ID         = B.TRAN_ID               
                   AND A.E150_LINE_CD         = p_e150_line_cd
                   AND A.E150_LA_YY           = p_e150_la_yy
                   AND A.E150_FLA_SEQ_NO      = p_e150_fla_seq_no
                   AND A.A180_RI_CD           = p_a180_ri_cd
                   AND A.payee_type           = p_payee_type  --A.R.C. 01.25.2006
                   AND B.tran_flag  <> 'D'
                   AND NOT EXISTS (SELECT '1'
                                     FROM giac_acctrans C,
                                          giac_reversals D
                                    WHERE C.tran_id      = D.reversing_tran_id
                                      AND D.gacc_tran_id = B.tran_id
                                      AND C.tran_flag   <> 'D' )) 
      LOOP
        WS_PAID_AMT := K.COLLECTION;
      END LOOP;
      WS_COLL_AMT := NVL(WS_LOSS_AMT,0) - NVL(WS_PAID_AMT,0);
      IF WS_COLL_AMT = 0 AND p_dsp_policy IS NOT NULL THEN
        p_collecion_amt := p_sve_collecion_amt;
        p_msg_alert     := ' Full loss recovery has been made.';
      ELSIF WS_COLL_AMT < 0 THEN
        p_collecion_amt := p_sve_collecion_amt;
        p_msg_alert     := ' Invalid value for collection amount.';
      ELSIF WS_COLL_AMT > 0 THEN
        p_collecion_amt := WS_COLL_AMT;
      END IF;
    ELSIF p_transaction_type = 2 THEN
      BEGIN                 --removed by john 11.27.2014
          FOR i IN (SELECT (/*-1*/SUM(NVL(f.collection_amt,0))) collection, f.currency_cd  --roset, 12/4/09, changed the select so that refundable amt will be equal only to the collected amt
                      FROM gicl_advs_fla_type e,
                           gicl_claims b, 
                           gicl_advs_fla d, 
                           giac_loss_ri_collns f, 
                           giac_acctrans i
                     WHERE 1=1
                       AND f.gacc_tran_id = i.tran_id --added by roset, 12/8/09
                       AND f.gacc_tran_id = p_gacc_tran_id --added by roset, 12/8/09
                       AND e.claim_id = d.claim_id
                       AND e.grp_seq_no = d.grp_seq_no
                       AND e.fla_id = d.fla_id
                       AND e.payee_type = p_payee_type
                       AND e.payee_type = f.payee_type -- added by roset, 12/4/09
                       AND f.e150_line_cd    = d.line_cd
                       AND f.e150_la_yy      = d.la_yy
                       AND f.e150_fla_seq_no = d.fla_seq_no
                       AND f.gacc_tran_id    = i.tran_id
                       AND d.claim_id        = b.claim_id
                       AND b.claim_id = d.claim_id
                       AND d.line_cd         = p_e150_line_cd
                       AND d.la_yy           = p_e150_la_yy
                       AND d.fla_seq_no      = p_e150_fla_seq_no
                       AND d.ri_cd           = p_a180_ri_cd
                       AND i.tran_flag  <> 'D'
                       AND (d.cancel_tag <> 'Y' OR d.cancel_tag IS NULL)
                       AND NOT EXISTS (SELECT '1'
                                         FROM giac_acctrans j,
                                              giac_reversals k
                                        WHERE j.tran_id      = k.reversing_tran_id
                                          AND k.gacc_tran_id = f.gacc_tran_id
                                          AND j.tran_flag   <> 'D')
                       AND 0 < (SELECT SUM(NVL(g.collection_amt,0))
                                  FROM giac_loss_ri_collns g
                                 WHERE f.e150_line_cd    = g.e150_line_cd
                                   AND f.e150_la_yy      = g.e150_la_yy
                                   AND f.e150_fla_seq_no = g.e150_fla_seq_no )
                 GROUP BY SUBSTR(b.line_cd || '-' || b.subline_cd ||'-'|| b.iss_cd || '-' ||
                                 LTRIM(TO_CHAR(b.issue_yy,'09')) ||'-'|| 
                                 LTRIM(TO_CHAR(b.pol_seq_no,'0999999')) ||'-'||
                             LTRIM(TO_CHAR(b.renew_no,'09')), 1, 40),
                            b.assured_name,f.gacc_tran_id, f.currency_cd) 
          LOOP -- group by gacc_tran_id added by roset, 12/8/09
            p_collecion_amt := I.COLLECTION;
            p_currency_cd := i.currency_cd;
          END LOOP;
      END;
    END IF;

     /* Set default of currency code to 1 - Philippine Peso . */
    BEGIN
        --removed by john 11.28.2014
      /*SELECT GIAC_PARAMETERS_PKG.n('CURRENCY_CD') 
        INTO p_currency_cd
        FROM dual;*/
        
      SELECT CURRENCY_DESC, CURRENCY_RT
        INTO p_currency_desc, p_convert_rate
        FROM GIIS_CURRENCY
       WHERE MAIN_CURRENCY_CD = p_currency_cd;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
       p_msg_alert     := ' Currency code is not existing.';
      WHEN TOO_MANY_ROWS THEN
       p_msg_alert     := ' Too many rows found for currency code equal to 1.';
      WHEN OTHERS THEN
       p_msg_alert     := ' Error getting default value.';
    END;
--    modified by gab 09.07.2016 SR 22496
--    IF NVL(p_convert_rate,0) = 0 THEN
    IF p_convert_rate = 0 THEN
       p_msg_alert     := 'Currency Rate is zero(0). Invalid value.';
    ELSIF p_convert_rate IS NULL THEN
       p_msg_alert     := 'Currency Rate is NULL. Invalid value.';
    END IF;

    /*Set default foreign currency amount*/
--    p_foreign_curr_amt := ROUND(NVL(p_collecion_amt,0)/ NVL(p_convert_rate,0),2);
    p_foreign_curr_amt := ROUND(NVL(p_collecion_amt,0)/ p_convert_rate,2); --removed nvl on p_convert_rate by gab SR 22946 09.07.2016
    /*Set the default value of the collection amount */ 
    p_collecion_amt     := p_collecion_amt;  /* DEFAULT VALUE */
    END;

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-22-2010 
    **  Reference By : (GIACS009 - Ri Trans - Loss Recov from RI)  
    **  Description  :  get loss advice listing 
    */  
    FUNCTION get_loss_advice_list(
            p_transaction_type    giac_loss_ri_collns.transaction_type%TYPE,  
            p_share_type          giac_loss_ri_collns.share_type%TYPE,
            p_a180_ri_cd          giac_loss_ri_collns.a180_ri_cd%TYPE,
            p_e150_line_cd        giac_loss_ri_collns.e150_line_cd%TYPE,
            p_e150_la_yy          giac_loss_ri_collns.e150_la_yy%TYPE,
            p_e150_fla_seq_no     giac_loss_ri_collns.e150_fla_seq_no%TYPE,
            p_user_id             giis_users.user_id%TYPE --added by robert 03.18.2013
            )
    RETURN loss_advice_list_tab PIPELINED IS
        v_list          loss_advice_list_type;
        v_msg_alert     VARCHAR2(32000) := '';
            CURSOR a IS
                SELECT d.ri_cd,
                       d.line_cd, 
                       d.la_yy, 
                       d.fla_seq_no, 
                       j.payee_type,
                       d.fla_date,
                       b.claim_id,  
                       b.line_cd clm_line_cd,
                       b.subline_cd clm_subline_cd,
                       b.iss_cd clm_iss_cd,
                       b.clm_yy clm_yy,
                       b.clm_seq_no clm_seq_no, 
                       b.line_cd pol_line_cd,
                       b.subline_cd pol_subline_cd,
                       b.iss_cd pol_iss_cd,
                       b.issue_yy pol_issue_yy,
                       b.pol_seq_no pol_seq_no, 
                       b.renew_no pol_renew_no,
                       (b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(b.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(b.renew_no,'09')) ) policy,
                       b.loss_date, 
                       b.assured_name,
                       (DECODE(j.payee_type,'L',j.loss_shr_amt,j.exp_shr_amt)-nvl(f.collection_amt,0)) collection --roset  -- added nvl for f.collection_amt by Jayson 07.14.2010
                  FROM gicl_advs_fla_type j, gicl_claims b, gicl_advs_fla d, (SELECT SUM(collection_amt) collection_amt, a.claim_id, a.payee_type, a.a180_ri_cd,
                                                                                     a.e150_line_cd, a.e150_fla_seq_no, a.e150_la_yy
                                                                                FROM giac_loss_ri_collns a, gicl_advs_fla d, giac_acctrans p --added giac_acctrans by robert 03.18.2013
                                                                               WHERE a.A180_ri_cd = NVL(p_a180_ri_cd,d.ri_cd)
                                                                                 AND a.E150_line_cd = NVL(p_e150_line_cd,d.line_cd)
                                                                                 AND a.E150_la_yy = NVL(p_e150_la_yy,d.la_yy)
                                                                                 AND a.E150_fla_seq_no = NVL(p_e150_fla_seq_no,d.fla_seq_no)
                                                                                 AND a.claim_id = d.claim_id
                                                                                 --added by robert 03.18.2013
                                                                                  AND a.gacc_tran_id = p.tran_id
                                                                                  AND p.tran_flag <> 'D'
                                                                                  AND NOT EXISTS (
                                                                                          SELECT '1'
                                                                                            FROM giac_acctrans j, giac_reversals k
                                                                                           WHERE j.tran_id = k.reversing_tran_id
                                                                                             AND k.gacc_tran_id = a.gacc_tran_id
                                                                                             AND j.tran_flag <> 'D')
                                                                                  --end
                                                                               GROUP BY a.claim_id, payee_type,
                                                                                        a.a180_ri_cd,a.e150_line_cd, a.e150_fla_seq_no, a.e150_la_yy -- added by Jayson 07.14.2010
                                                                              ) f --roset, 12/10/09, added to get the sum of paid amt
                 WHERE 1=1
                   AND d.claim_id = f.claim_id (+) --roset, 12/10/09 -- added (+) by Jayson 07.14.2010
                   AND d.line_cd = f.e150_line_cd (+) -- added by Jayson 07.14.2010
                   AND d.fla_seq_no = f.e150_fla_seq_no (+) -- added by Jayson 07.14.2010
                   AND d.la_yy = f.e150_la_yy (+) -- added by Jayson 07.14.2010
                   AND d.ri_cd = f.a180_ri_cd (+) -- added by Jayson 07.14.2010
                   --AND d.payee_type = f.payee_type (+)--roset, 12/10/09 -- removed by Jayson 07.14.2010
                   AND j.claim_id = d.claim_id
                   AND j.grp_seq_no = d.grp_seq_no
                   AND j.fla_id = d.fla_id         
                   AND d.claim_id = b.claim_id 
                   AND b.claim_id = d.claim_id 
                   AND d.share_type = p_share_type 
                   AND d.ri_cd = NVL(p_a180_ri_cd,d.ri_cd)
                   AND d.line_cd = NVL(p_e150_line_cd,d.line_cd)
                   AND d.la_yy = NVL(p_e150_la_yy,d.la_yy)
                   AND d.fla_seq_no = NVL(p_e150_fla_seq_no,d.fla_seq_no)
                   AND (d.cancel_tag <> 'Y' OR d.cancel_tag IS NULL) 
                   /*AND (d.line_cd,d.la_yy,d.fla_seq_no) NOT IN ( SELECT x.e150_line_cd,x.e150_la_yy,x.e150_fla_seq_no 
                                                                   FROM giac_loss_ri_collns x, giac_acctrans y, gicl_advs_fla_type n, (SELECT SUM(collection_amt) collection_amt, a.claim_id, payee_type,
																   																			  d.fla_id  --added by robert 03.18.2013
                                                                                                                                         FROM giac_loss_ri_collns a, gicl_advs_fla d,
                                                                                                                                              giac_acctrans w --added by robert 03.18.2013
                                                                                                                                        WHERE a.A180_ri_cd = NVL(p_a180_ri_cd,d.ri_cd)
                                                                                                                                          AND a.E150_line_cd = NVL(p_e150_line_cd,d.line_cd)
                                                                                                                                          AND a.E150_la_yy = NVL(p_e150_la_yy,d.la_yy)
                                                                                                                                          AND a.E150_fla_seq_no = NVL(p_e150_fla_seq_no,d.fla_seq_no)
                                                                                                                                          AND a.claim_id = d.claim_id
                                                                                                                                          --added by robert 03.18.2013
                                                                                                                                          AND a.gacc_tran_id = w.tran_id
                                                                                                                                          AND w.tran_flag <> 'D'
                                                                                                                                          AND NOT EXISTS (
                                                                                                                                                  SELECT '1'
                                                                                                                                                    FROM giac_acctrans j, giac_reversals k
                                                                                                                                                   WHERE j.tran_id = k.reversing_tran_id
                                                                                                                                                     AND k.gacc_tran_id = a.gacc_tran_id
                                                                                                                                                     AND j.tran_flag <> 'D')
                                                                                                                                         --end
                                                                                                                                        GROUP BY a.claim_id, d.fla_id, payee_type) f       --roset, 12/10/09  --added d.fla_id, robert
                                                                  WHERE x.gacc_tran_id = y.tran_id 
                                                                    AND x.claim_id = n.claim_id --roset, 12/3/09, added condition so that fla of partially paid share amt will still appear on the LOV
                                                                    AND f.collection_amt = n.loss_shr_amt --roset, 12/3/09
                                                                    AND f.claim_id = n.claim_id --roset, 12/10/09
                                                                    AND f.payee_type = n.payee_type --roset 10/12/09
                                                                    AND f.fla_id = n.fla_id --added by robert 03.18.2013
                                                                    AND f.fla_id = j.fla_id --added by robert 03.18.2013
                                                                    AND y.tran_flag <> 'D' 
                                                                    AND NOT EXISTS( SELECT '1' 
                                                                                      FROM giac_acctrans j, giac_reversals k 
                                                                                     WHERE j.tran_id = k.reversing_tran_id 
                                                                                       AND k.gacc_tran_id = x.gacc_tran_id 
                                                                                       AND j.tran_flag <> 'D' )) */  --commented out by steven 7.12.2012; it causes the query to dispaly some records that should not be display  --added again by robert 03.18.2013
                                                                    AND check_user_per_iss_cd_acctg2 (NULL, b.iss_cd, 'GIACS009', NVL(p_user_id,USER)) = 1 --added by robert 03.18.2013
--				AND (d.line_cd,d.la_yy,d.fla_seq_no) NOT IN (SELECT x.e150_line_cd,x.e150_la_yy,x.e150_fla_seq_no /*added by steven 7.12.2012; copied from GIACS009 FMB Record Groups:LOV_FLA_NO_1*/
--						FROM giac_loss_ri_collns x, giac_acctrans y 
--						WHERE x.gacc_tran_id = y.tran_id AND y.tran_flag <> 'D' 
--						AND NOT EXISTS( SELECT '1' 
--											FROM giac_acctrans j, giac_reversals k 
--											WHERE j.tran_id = k.reversing_tran_id 
--											AND k.gacc_tran_id = x.gacc_tran_id 
--											AND j.tran_flag <> 'D' ))     --commented out by robert 03.18.2013                                                   
				    /* shan 07.23.2013, SR-13688: added payee_type to handle records with same FLA number but different payee types  */
                --AND (d.line_cd,d.la_yy,d.fla_seq_no, j.payee_type) NOT IN (SELECT x.e150_line_cd,x.e150_la_yy,x.e150_fla_seq_no, x.payee_type /*added by steven 7.12.2012; copied from GIACS009 FMB Record Groups:LOV_FLA_NO_1*/
						--FROM giac_loss_ri_collns x, giac_acctrans y 
						--WHERE x.gacc_tran_id = y.tran_id AND y.tran_flag <> 'D') --removed by john 11.27.2014
						/*AND NOT EXISTS( SELECT '1' 
											FROM giac_acctrans j, giac_reversals k 
											WHERE j.tran_id = k.reversing_tran_id 
											AND k.gacc_tran_id = x.gacc_tran_id 
											AND j.tran_flag <> 'D' ))       */                                           
                 ORDER BY d.line_cd, d.la_yy, d.fla_seq_no, j.payee_type;
             
            CURSOR b IS	
                    SELECT d.ri_cd,
                           d.line_cd, 
                           d.la_yy, 
                           d.fla_seq_no, 
                           j.payee_type,
                           d.fla_date,
                           b.claim_id,  
                           b.line_cd clm_line_cd,
                           b.subline_cd clm_subline_cd,
                           b.iss_cd clm_iss_cd,
                           b.clm_yy clm_yy,
                           b.clm_seq_no clm_seq_no, 
                           b.line_cd pol_line_cd,
                           b.subline_cd pol_subline_cd,
                           b.iss_cd pol_iss_cd,
                           b.issue_yy pol_issue_yy,
                           b.pol_seq_no pol_seq_no, 
                           b.renew_no pol_renew_no,
                           (b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.issue_yy,'09'))||'-'||LTRIM(TO_CHAR(b.pol_seq_no,'0999999'))||'-'||LTRIM(TO_CHAR(b.renew_no,'09')) ) policy,
                           b.loss_date, 
                           b.assured_name, 
                           --DECODE(j.payee_type,'L',j.loss_shr_amt,j.exp_shr_amt) collection , commented by roset 12/8/09
                           f.collection_amt collection, --added by roset, 12/8/09
                           f.gacc_tran_id --added by roset, 12/8/09
                      FROM gicl_advs_fla_type j, gicl_claims b, gicl_advs_fla d, giac_loss_ri_collns f, giac_acctrans i 
                     WHERE 1=1
                       AND f.payee_type = j.payee_type --roset, 12/8/09
                       AND j.claim_id = d.claim_id
                       AND j.grp_seq_no = d.grp_seq_no
                       AND j.fla_id = d.fla_id		 
                       AND f.e150_line_cd = d.line_cd 
                       AND f.e150_la_yy = d.la_yy 
                       AND f.e150_fla_seq_no = d.fla_seq_no 
                       AND f.gacc_tran_id = i.tran_id 
                       AND d.claim_id = b.claim_id 
                       AND b.claim_id = d.claim_id 
                       AND d.share_type = p_share_type 
                       AND d.ri_cd = NVL(p_a180_ri_cd,d.ri_cd) 
                       AND d.line_cd = NVL(p_e150_line_cd,d.line_cd)
                       AND d.la_yy = NVL(p_e150_la_yy,d.la_yy)
                       AND d.fla_seq_no = NVL(p_e150_fla_seq_no,d.fla_seq_no)			 
                       AND i.tran_flag <> 'D' 
                       AND (d.cancel_tag <> 'Y' OR d.cancel_tag IS NULL) 
                       AND f.transaction_type = '1' 
                       AND NOT EXISTS ( SELECT '1' 
                                          FROM giac_acctrans j, giac_reversals k 
                                         WHERE j.tran_id = k.reversing_tran_id 
                                           AND k.gacc_tran_id = f.gacc_tran_id 
                                           AND j.tran_flag <> 'D' ) 
                                           /*AND (d.line_cd,d.fla_seq_no,d.la_yy) NOT IN (SELECT e150_line_cd,e150_fla_seq_no,e150_la_yy 
                                                                                          FROM giac_loss_ri_collns 
                                                                                         WHERE transaction_type = '2')*/
                     ORDER BY d.line_cd, d.la_yy, d.fla_seq_no, j.payee_type;
    BEGIN
        /*CGFK$CHK_GCRR_GCRR_E150_FK(
            p_a180_ri_cd,
            p_e150_line_cd,
            p_e150_la_yy,
            p_e150_fla_seq_no,
            v_msg_alert
            );
        IF v_msg_alert IS NOT NULL THEN
            v_list.dsp_msg_alert := v_msg_alert;
            PIPE ROW(v_list);
            RETURN;
        END IF;*/ --comment out by john 11.17.2014 --to avoid LOV from displaying record with blank details
        
        IF p_transaction_type = 1 THEN
            FOR a_rec IN a
            LOOP	
              v_list.dsp_ri_cd              := a_rec.ri_cd;
              v_list.dsp_line_cd            := a_rec.line_cd;
              v_list.dsp_la_yy              := a_rec.la_yy;
              v_list.dsp_fla_seq_no         := a_rec.fla_seq_no; 
              v_list.dsp_payee_type         := a_rec.payee_type;
              v_list.dsp_fla_date           := a_rec.fla_date;
              v_list.nbt_claim_id           := a_rec.claim_id;
              v_list.dsp_clm_line_cd        := a_rec.clm_line_cd;
              v_list.dsp_clm_subline_cd     := a_rec.clm_subline_cd;
              v_list.dsp_clm_iss_cd         := a_rec.clm_iss_cd;
              v_list.dsp_clm_yy             := a_rec.clm_yy;
              v_list.dsp_clm_seq_no         := a_rec.clm_seq_no;
              v_list.nbt_claim              := a_rec.clm_line_cd||'-'||a_rec.clm_subline_cd||'-'||a_rec.clm_iss_cd||'-'||trim(to_char(a_rec.clm_yy,'09'))||'-'||trim(to_char(a_rec.clm_seq_no,'0999999'));
              v_list.dsp_pol_line_cd        := a_rec.pol_line_cd;
              v_list.dsp_pol_subline_cd     := a_rec.pol_subline_cd;
              v_list.dsp_pol_iss_cd         := a_rec.pol_iss_cd;
              v_list.dsp_pol_issue_yy       := a_rec.pol_issue_yy;
              v_list.dsp_pol_seq_no         := a_rec.pol_seq_no;
              v_list.dsp_pol_renew_no       := a_rec.pol_renew_no;
              v_list.nbt_policy             := trim(a_rec.policy);
              v_list.dsp_loss_date          := a_rec.loss_date;
              v_list.dsp_assd_name          := a_rec.assured_name;
              v_list.dsp_collection_amt     := a_rec.collection;
              GET_DEFAULT_VALUE(
                '',
                p_transaction_type,
                v_list.nbt_policy,
                v_list.dsp_payee_type,
                a_rec.ri_cd,
                a_rec.line_cd,
                a_rec.la_yy,
                a_rec.fla_seq_no,
                v_list.dsp_collection_amt,
                v_list.dsp_collection_amt,
                v_list.dsp_foreign_curr_amt,
                v_list.dsp_currency_cd,
                v_list.dsp_currency_desc,
                v_list.dsp_convert_rate,
                v_list.dsp_msg_alert
                );
              PIPE ROW(v_list);
            END LOOP;
        ELSIF p_transaction_type = 2 THEN
            FOR b_rec IN b
            LOOP
              v_list.dsp_ri_cd              := b_rec.ri_cd;
              v_list.dsp_line_cd            := b_rec.line_cd;
              v_list.dsp_la_yy              := b_rec.la_yy;
              v_list.dsp_fla_seq_no         := b_rec.fla_seq_no;
              v_list.dsp_payee_type         := b_rec.payee_type;  
              v_list.dsp_fla_date           := b_rec.fla_date;
              v_list.nbt_claim_id           := b_rec. claim_id;
              v_list.dsp_clm_line_cd        := b_rec.clm_line_cd;
              v_list.dsp_clm_subline_cd     := b_rec.clm_subline_cd;
              v_list.dsp_clm_iss_cd         := b_rec.clm_iss_cd;
              v_list.dsp_clm_yy             := b_rec.clm_yy;
              v_list.dsp_clm_seq_no         := b_rec.clm_seq_no;
              v_list.nbt_claim              := b_rec.clm_line_cd||'-'||b_rec.clm_subline_cd||'-'||b_rec.clm_iss_cd||'-'||trim(to_char(b_rec.clm_yy,'09'))||'-'||trim(to_char(b_rec.clm_seq_no,'0999999'));
              v_list.dsp_pol_line_cd        := b_rec.pol_line_cd;
              v_list.dsp_pol_subline_cd     := b_rec.pol_subline_cd;
              v_list.dsp_pol_iss_cd         := b_rec.pol_iss_cd;
              v_list.dsp_pol_issue_yy       := b_rec.pol_issue_yy;
              v_list.dsp_pol_seq_no         := b_rec.pol_seq_no;
              v_list.dsp_pol_renew_no       := b_rec.pol_renew_no;
              v_list.nbt_policy             := trim(b_rec.policy);
              v_list.dsp_loss_date          := b_rec.loss_date;
              v_list.dsp_assd_name          := b_rec.assured_name;
              v_list.dsp_collection_amt     := b_rec.collection; 
              v_list.nbt_gacc_tran_id       := b_rec.gacc_tran_id; --roset, 12/10/09
              GET_DEFAULT_VALUE(
                v_list.nbt_gacc_tran_id,
                p_transaction_type,
                v_list.nbt_policy,
                v_list.dsp_payee_type,
                b_rec.ri_cd,
                b_rec.line_cd,
                b_rec.la_yy,
                b_rec.fla_seq_no,
                v_list.dsp_collection_amt,
                v_list.dsp_collection_amt,
                v_list.dsp_foreign_curr_amt,
                v_list.dsp_currency_cd,
                v_list.dsp_currency_desc,
                v_list.dsp_convert_rate,
                v_list.dsp_msg_alert
                );
              PIPE ROW(v_list);
            END LOOP;
        END IF;
    RETURN;
    END;

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-22-2010 
    **  Reference By : (GIACS009 - Ri Trans - Loss Recov from RI)  
    **  Description  :  GET_ASSURED_POL_CLM program unit 
    */  
    PROCEDURE GET_ASSURED_POL_CLM(
            p_a180_ri_cd          IN  giac_loss_ri_collns.a180_ri_cd%TYPE,
            p_e150_line_cd        IN  giac_loss_ri_collns.e150_line_cd%TYPE,
            p_e150_la_yy          IN  giac_loss_ri_collns.e150_la_yy%TYPE,
            p_e150_fla_seq_no     IN  giac_loss_ri_collns.e150_fla_seq_no%TYPE,
            p_dsp_policy          OUT VARCHAR2,
            p_dsp_claim           OUT VARCHAR2,
            p_dsp_assd_name       OUT VARCHAR2
            ) IS
    BEGIN
      SELECT substr(b.line_cd || '-' ||
                 b.subline_cd||'-'||
                 b.iss_cd || '-' ||
                 ltrim(to_char(b.issue_yy,'09')) ||'-'||
                 ltrim(to_char(b.pol_seq_no,'0999999'))||'-'||
                 ltrim(to_char(b.renew_no,'09')),1,40) policy,
             substr(b.line_cd || '-' ||
                 b.subline_cd||'-'||
                 b.iss_cd || '-' ||
                 ltrim(to_char(b.clm_yy,'09')) ||'-'||
                 ltrim(to_char(b.clm_seq_no,'0999999')),1,40) claim,
             b.assured_name
        INTO p_dsp_policy, p_dsp_claim, p_dsp_assd_name
        FROM gicl_claims b,
             gicl_advs_fla d
       WHERE b.claim_id    = d.claim_id
         AND d.line_cd     = p_e150_line_cd
         AND d.la_yy       = p_e150_la_yy
         AND d.fla_seq_no  = p_e150_fla_seq_no
         AND d.ri_cd       = p_a180_ri_cd;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
      WHEN OTHERS THEN
        --CGTE$OTHER_EXCEPTIONS;
        NULL;
    END;

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-22-2010 
    **  Reference By : (GIACS009 - Ri Trans - Loss Recov from RI)  
    **  Description  :  get giac_loss_ri_collns records 
    */  
    FUNCTION get_giac_loss_ri_collns (p_gacc_tran_id    giac_loss_ri_collns.gacc_tran_id%TYPE)
    RETURN giac_loss_ri_collns_tab PIPELINED IS
        v_list  giac_loss_ri_collns_type;
    BEGIN
        FOR i IN (SELECT a.gacc_tran_id,      a.a180_ri_cd,         a.transaction_type,
                         a.e150_line_cd,      a.e150_la_yy,         a.e150_fla_seq_no,
                         a.collection_amt,    a.claim_id,           a.currency_cd,
                         a.convert_rate,      a.foreign_curr_amt,   a.or_print_tag,
                         a.particulars,       a.user_id,            a.last_update,
                         a.cpi_rec_no,        a.cpi_branch_cd,      a.share_type,
                         a.payee_type,        b.ri_name,            c.currency_desc,
                         d.rv_meaning share_type_desc, e.rv_meaning transaction_type_desc
                   FROM giac_loss_ri_collns a, 
                        giis_reinsurer b,
                        giis_currency c,
                        cg_ref_codes d,
                        cg_ref_codes e
                  WHERE a.gacc_tran_id = p_gacc_tran_id
                    AND a.a180_ri_cd = b.ri_cd(+)
                    AND a.currency_cd = c.main_currency_cd(+)
                    AND a.share_type = d.rv_low_value(+)
                    AND d.rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE' 
                    AND d.rv_low_value <> 1
                    AND a.transaction_type = e.rv_low_value(+)
                    AND e.rv_domain = 'GIAC_LOSS_RI_COLLNS.TRANSACTION_TYPE')
        LOOP
            v_list.gacc_tran_id             := i.gacc_tran_id;     
            v_list.a180_ri_cd               := i.a180_ri_cd;        
            v_list.transaction_type         := i.transaction_type;        
            v_list.e150_line_cd             := i.e150_line_cd;         
            v_list.e150_la_yy               := i.e150_la_yy;          
            v_list.e150_fla_seq_no          := i.e150_fla_seq_no;    
            v_list.collection_amt           := i.collection_amt;       
            v_list.claim_id                 := i.claim_id;            
            v_list.currency_cd              := i.currency_cd;    
            v_list.convert_rate             := i.convert_rate;     
            v_list.foreign_curr_amt         := i.foreign_curr_amt;  
            v_list.or_print_tag             := i.or_print_tag; 
            v_list.particulars              := i.particulars;      
            v_list.user_id                  := i.user_id;           
            v_list.last_update              := i.last_update; 
            v_list.cpi_rec_no               := i.cpi_rec_no;       
            v_list.cpi_branch_cd            := i.cpi_branch_cd;      
            v_list.share_type               := i.share_type; 
            v_list.payee_type               := i.payee_type; 
            v_list.ri_name                  := i.ri_name;
            v_list.currency_desc            := i.currency_desc;
            v_list.share_type_desc          := i.share_type_desc;     
            v_list.transaction_type_desc    := i.transaction_type_desc; 
            GET_ASSURED_POL_CLM(i.a180_ri_cd,       i.e150_line_cd,     
                    i.e150_la_yy,       i.e150_fla_seq_no,
                    v_list.dsp_policy,  v_list.dsp_claim,   
                    v_list.dsp_assd_name);     
        PIPE ROW(v_list);
        END LOOP;
    RETURN;    
    END;        

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-28-2010 
    **  Reference By : (GIACS009 - Ri Trans - Loss Recov from RI)  
    **  Description  :  deleting records in giac_loss_ri_collns 
    */    
    PROCEDURE del_giac_loss_ri_collns(
        p_gacc_tran_id          giac_loss_ri_collns.gacc_tran_id%TYPE,
        p_a180_ri_cd            giac_loss_ri_collns.a180_ri_cd%TYPE,
        p_e150_line_cd          giac_loss_ri_collns.e150_line_cd%TYPE,
        p_e150_la_yy            giac_loss_ri_collns.e150_la_yy%TYPE,
        p_e150_fla_seq_no       giac_loss_ri_collns.e150_fla_seq_no%TYPE,
        p_payee_type            giac_loss_ri_collns.PAYEE_TYPE%type     --added by shan 07.23.2013: SR-13688
        ) IS
    BEGIN
        DELETE giac_loss_ri_collns
         WHERE gacc_tran_id     = p_gacc_tran_id
           AND a180_ri_cd       = p_a180_ri_cd
           AND e150_line_cd     = p_e150_line_cd
           AND e150_la_yy       = p_e150_la_yy
           AND e150_fla_seq_no  = p_e150_fla_seq_no
           AND payee_type       = p_payee_type;     --added by shan 07.23.2013: SR-13688
    END;
   
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-28-2010 
    **  Reference By : (GIACS009 - Ri Trans - Loss Recov from RI)  
    **  Description  :  inserting records in giac_loss_ri_collns 
    */  
    PROCEDURE set_giac_loss_ri_collns(
        p_gacc_tran_id                giac_loss_ri_collns.gacc_tran_id%TYPE,    
        p_a180_ri_cd                  giac_loss_ri_collns.a180_ri_cd%TYPE,   
        p_transaction_type            giac_loss_ri_collns.transaction_type%TYPE,   
        p_e150_line_cd                giac_loss_ri_collns.e150_line_cd%TYPE,   
        p_e150_la_yy                  giac_loss_ri_collns.e150_la_yy%TYPE,   
        p_e150_fla_seq_no             giac_loss_ri_collns.e150_fla_seq_no%TYPE,   
        p_collection_amt              giac_loss_ri_collns.collection_amt%TYPE,   
        p_claim_id                    giac_loss_ri_collns.claim_id%TYPE,   
        p_currency_cd                 giac_loss_ri_collns.currency_cd%TYPE,   
        p_convert_rate                giac_loss_ri_collns.convert_rate%TYPE,   
        p_foreign_curr_amt            giac_loss_ri_collns.foreign_curr_amt%TYPE,   
        p_or_print_tag                giac_loss_ri_collns.or_print_tag%TYPE,   
        p_particulars                 giac_loss_ri_collns.particulars%TYPE,   
        p_user_id                     giac_loss_ri_collns.user_id%TYPE,   
        p_last_update                 giac_loss_ri_collns.last_update%TYPE,   
        p_cpi_rec_no                  giac_loss_ri_collns.cpi_rec_no%TYPE,   
        p_cpi_branch_cd               giac_loss_ri_collns.cpi_branch_cd%TYPE,   
        p_share_type                  giac_loss_ri_collns.share_type%TYPE,   
        p_payee_type                  giac_loss_ri_collns.payee_type%TYPE
        ) IS
    BEGIN
        MERGE INTO giac_loss_ri_collns
        USING dual
           ON (gacc_tran_id     = p_gacc_tran_id
          AND a180_ri_cd       = p_a180_ri_cd
          AND e150_line_cd     = p_e150_line_cd
          AND e150_la_yy       = p_e150_la_yy
          AND e150_fla_seq_no  = p_e150_fla_seq_no
          AND payee_type       = p_payee_type)      --added by shan 07.22.2013 for SR-13688
        WHEN NOT MATCHED THEN
            INSERT (gacc_tran_id,      a180_ri_cd,         transaction_type,
                    e150_line_cd,      e150_la_yy,         e150_fla_seq_no,
                    collection_amt,    claim_id,           currency_cd,
                    convert_rate,      foreign_curr_amt,   or_print_tag,
                    particulars,       user_id,            last_update,
                    cpi_rec_no,        cpi_branch_cd,      share_type,
                    payee_type)
            VALUES (p_gacc_tran_id,      p_a180_ri_cd,         p_transaction_type,
                    p_e150_line_cd,      p_e150_la_yy,         p_e150_fla_seq_no,
                    p_collection_amt,    p_claim_id,           p_currency_cd,
                    p_convert_rate,      p_foreign_curr_amt,   p_or_print_tag,
                    p_particulars,       p_user_id,            sysdate,
                    p_cpi_rec_no,        p_cpi_branch_cd,      p_share_type,
                    p_payee_type)
        WHEN MATCHED THEN
            UPDATE  
               SET transaction_type     = p_transaction_type,
                   collection_amt       = p_collection_amt,
                   claim_id             = p_claim_id, 
                   currency_cd          = p_currency_cd,
                   convert_rate         = p_convert_rate,
                   foreign_curr_amt     = p_foreign_curr_amt,
                   or_print_tag         = p_or_print_tag,
                   particulars          = p_particulars,
                   user_id              = p_user_id,
                   last_update          = sysdate,
                   cpi_rec_no           = p_cpi_rec_no,
                   cpi_branch_cd        = p_cpi_branch_cd,
                   share_type           = p_share_type;
                   --payee_type           = p_payee_type;  --commented out by shan 07.22.2013 for SR-13688
    END;    

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  11-02-2010 
    **  Reference By : (GIACS009 - Ri Trans - Loss Recov from RI)  
    **  Description  :  UPDATE_GIAC_OP_TEXT2 program unit 
    */  
    PROCEDURE UPDATE_GIAC_OP_TEXT (
            p_gacc_tran_id                giac_loss_ri_collns.gacc_tran_id%TYPE
            ) IS
    /* Update the GIAC_OP_TEXT table. */
      CURSOR C IS
        SELECT DISTINCT A.GACC_TRAN_ID, A.USER_ID, A.LAST_UPDATE, D.LINE_CD,
               A.COLLECTION_AMT ITEM_AMT,
               ('Policy No.: ' || D.LINE_CD ||'-'|| D.SUBLINE_CD ||'-'||
                 D.ISS_CD ||'-'|| LTRIM(TO_CHAR(D.ISSUE_YY,'09')) ||'-'||
                 LTRIM(TO_CHAR(D.POL_SEQ_NO,'09999999')) ||'-'||
                 LTRIM(TO_CHAR(D.RENEW_NO,'09')) 
                 ||' / FLA No.: ' || A.E150_LINE_CD ||'-'||
                 LTRIM(TO_CHAR(A.E150_LA_YY,'09')) ||'-'||
                 LTRIM(TO_CHAR(A.E150_FLA_SEQ_NO,'09999'))
                 ||' / Loss Date : '||TO_CHAR(D.LOSS_DATE,'DD-MON-YYYY')) ITEM_TEXT
                ,A.CURRENCY_CD
                ,A.FOREIGN_CURR_AMT
         FROM  GICL_CLAIMS D, GIAC_ACCTRANS B,
               GICL_ADVS_FLA E, GIAC_LOSS_RI_COLLNS A
         WHERE A.E150_LINE_CD    = E.LINE_CD
           AND A.E150_LA_YY      = E.LA_YY
           AND A.E150_FLA_SEQ_NO = E.FLA_SEQ_NO
           AND A.GACC_TRAN_ID    = B.TRAN_ID
           AND E.CLAIM_ID        = D.CLAIM_ID
           AND B.TRAN_FLAG      <> 'D'
           AND (e.cancel_tag <> 'Y' or e.cancel_tag is null)
           AND NOT EXISTS (SELECT '1'
                             FROM GIAC_ACCTRANS F, GIAC_REVERSALS G
                            WHERE F.TRAN_ID      = G.REVERSING_TRAN_ID
                              AND G.GACC_TRAN_ID = B.TRAN_ID
                              AND F.TRAN_FLAG   <> 'D' )
           AND A.GACC_TRAN_ID    = p_gacc_tran_id;
        WS_SEQ_NO      GIAC_OP_TEXT.ITEM_SEQ_NO%TYPE := 1;
        WS_GEN_TYPE    VARCHAR2(1) := 'C';
    BEGIN
       DELETE FROM GIAC_OP_TEXT
       WHERE GACC_TRAN_ID  = p_gacc_tran_id
         AND ITEM_GEN_TYPE = WS_GEN_TYPE;
      FOR C_REC IN C LOOP
        INSERT INTO GIAC_OP_TEXT
                    (GACC_TRAN_ID, ITEM_SEQ_NO, ITEM_GEN_TYPE, ITEM_TEXT,
                     ITEM_AMT, USER_ID, LAST_UPDATE, LINE, print_seq_no, CURRENCY_CD, FOREIGN_CURR_AMT)
             VALUES (C_REC.GACC_TRAN_ID, WS_SEQ_NO, WS_GEN_TYPE, C_REC.ITEM_TEXT,
                     C_REC.ITEM_AMT, C_REC.USER_ID, C_REC.LAST_UPDATE, C_REC.LINE_CD, WS_SEQ_NO,
                     C_REC.CURRENCY_CD, C_REC.FOREIGN_CURR_AMT);
        WS_SEQ_NO := WS_SEQ_NO + 1;
      END LOOP;
    END;

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  11-02-2010 
    **  Reference By : (GIACS009 - Ri Trans - Loss Recov from RI)  
    **  Description  :  get_sl_type_parameters program unit 
    */  
    FUNCTION get_sl_type_parameters(p_module_name     VARCHAR2)
    RETURN get_sl_type_parameters_tab PIPELINED IS
     v_Sl_TYPE1   GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
     v_sl_TYPE2   GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;  
     v_sl         get_sl_type_parameters_type;
    BEGIN
      begin 
        select param_value_v
          into v_sl.variables_assd_no 
          from giac_parameters
         where param_name ='ASSD_SL_TYPE';
      EXCEPTION
        WHEN no_data_found THEN
          v_sl.v_msg_Alert := 'No data found in GIAC PARAMETERS.';
      end;
       
      begin
       select param_value_v
         into v_sl.variables_ri_cd 
         from giac_parameters
        where param_name = 'RI_SL_TYPE';
      EXCEPTION
        WHEN no_data_found THEN
           v_sl.v_msg_Alert := 'No data found in GIAC PARAMETERS.';
      end;
      
      begin
        select param_value_v
          into v_sl.variables_line_cd 
          from giac_parameters
         where param_name ='LINE_SL_TYPE';
      EXCEPTION
        WHEN no_data_found THEN
           v_sl.v_msg_Alert := 'No data found in GIAC PARAMETERS.';
      end;

      BEGIN
      v_sl.variables_module_name := p_module_name;
        SELECT module_id,
               generation_type
          INTO v_sl.VARIABLES_module_id,
               v_sl.VARIABLES_gen_type
          FROM giac_modules
         WHERE module_name  = v_sl.variables_module_name;
      EXCEPTION
        WHEN no_data_found THEN
           v_sl.v_msg_Alert := 'No data found in GIAC MODULES.';
      END;
     
      BEGIN
      v_sl.variables_item_no := 1;
       SELECT sl_type_cd
         INTO v_sl_type1
         FROM giac_module_entries    
        WHERE module_id = v_sl.variables_module_id
          AND item_no= v_sl.variables_item_no;
      EXCEPTION
        WHEN no_data_found THEN
           v_sl.v_msg_Alert := 'No data found in GIAC MODULE ENTRIES.';
      END; 

      BEGIN 
        IF v_sl_type1 = v_sl.variables_assd_no THEN
          v_sl.variables_sl_type_cd1 := 'ASSD_SL_TYPE';
        ELSIF v_sl_type1 = v_sl.variables_ri_cd THEN
          v_sl.variables_sl_type_cd1 := 'RI_SL_TYPE' ; 
        ELSIF v_sl_type1 = v_sl.variables_line_cd THEN
          v_sl.variables_sl_type_cd1 := 'LINE_SL_TYPE';
        END IF;
      END;
    PIPE ROW(v_sl);  
    END;


    PROCEDURE AEG_Create_Acct_Entries
      (aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE,
       aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE,
       aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE,
       aeg_iss_cd             GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE,
       aeg_bill_no            GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE,
       aeg_line_cd            GIIS_LINE.line_cd%TYPE,
       aeg_type_cd            GIPI_POLBASIC.type_cd%TYPE,
       aeg_acct_amt           GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE,
       aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE,
       aeg_share_type         GICL_ADVS_FLA.share_type%TYPE,
       aeg_ri_cd              GICL_ADVS_FLA.ri_cd%TYPE,
       aeg_la_yy              GICL_ADVS_FLA.la_yy%TYPE,
       aeg_fla_seq_no         GICL_ADVS_FLA.fla_seq_no%TYPE,
       p_gacc_branch_cd       GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
       p_gacc_fund_cd         GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
       p_gacc_tran_id         GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
       p_user_id              GIIS_USERS.user_id%TYPE,
       p_msg_alert        OUT VARCHAR2) IS  

      ws_gl_acct_category              GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
      ws_gl_control_acct               GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
      ws_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
      ws_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
      ws_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
      ws_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
      ws_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
      ws_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
      ws_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;

      ws_pol_type_tag                  GIAC_MODULE_ENTRIES.pol_type_tag%TYPE;
      ws_intm_type_level               GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
      ws_old_new_acct_level            GIAC_MODULE_ENTRIES.old_new_acct_level%TYPE;
      ws_line_dep_level                GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
      ws_treaty_type_level             GIAC_MODULE_ENTRIES.ca_treaty_type_level%TYPE;
      ws_dr_cr_tag                     GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;

      ws_acct_intm_cd                  GIIS_INTM_TYPE.acct_intm_cd%TYPE;
      ws_line_cd                       GIIS_LINE.line_cd%TYPE;
      ws_acct_treaty_type              GICL_ADVS_FLA.acct_trty_type%TYPE;
      ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;

      ws_old_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
      ws_new_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
      pt_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
      pt_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
      pt_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
      pt_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
      pt_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
      ws_debit_amt                     GIAC_ACCT_ENTRIES.debit_amt%TYPE;
      ws_credit_amt                    GIAC_ACCT_ENTRIES.credit_amt%TYPE;  
      ws_gl_acct_id                    GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
	  
	  ws_sl_type_cd                    giac_acct_entries.sl_type_cd%TYPE; -- added by robert 10.17.2013
     
    BEGIN

      /**************************************************************************
      *                                                                         *
      * Populate the GL Account Code used in every transactions.                *
      *                                                                         *
      **************************************************************************/

          BEGIN
            SELECT gl_acct_category, gl_control_acct,
                   gl_sub_acct_1   , gl_sub_acct_2  ,
                   gl_sub_acct_3   , gl_sub_acct_4  ,
                   gl_sub_acct_5   , gl_sub_acct_6  ,
                   gl_sub_acct_7   , pol_type_tag   ,
                   intm_type_level , old_new_acct_level,
                   dr_cr_tag       , line_dependency_level, 
                   ca_treaty_type_level, sl_type_cd --added by robert 10.17.2013
              INTO ws_gl_acct_category, ws_gl_control_acct,
                   ws_gl_sub_acct_1   , ws_gl_sub_acct_2  ,
                   ws_gl_sub_acct_3   , ws_gl_sub_acct_4  ,
                   ws_gl_sub_acct_5   , ws_gl_sub_acct_6  ,
                   ws_gl_sub_acct_7   , ws_pol_type_tag   ,
                   ws_intm_type_level , ws_old_new_acct_level,
                   ws_dr_cr_tag       , ws_line_dep_level, 
                   ws_treaty_type_level, ws_sl_type_cd --added by robert 10.17.2013
              FROM giac_module_entries
             WHERE module_id = aeg_module_id
               AND item_no   = aeg_item_no
            FOR UPDATE of gl_sub_acct_1;
          EXCEPTION
            WHEN no_data_found THEN
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
            BEGIN
              SELECT DISTINCT(c.acct_intm_cd)
                INTO ws_acct_intm_cd
                FROM gipi_comm_invoice a,
                     giis_intermediary b,
                     giis_intm_type c
               WHERE a.intrmdry_intm_no = b.intm_no
                 AND b.intm_type        = c.intm_type
                 AND a.iss_cd           = aeg_iss_cd
                 AND a.prem_seq_no      = aeg_bill_no;
            EXCEPTION
              WHEN no_data_found THEN
                p_msg_alert := 'No data found in giis_intm_type.';
                RETURN;
            END;
            giac_acct_entries_pkg.AEG_Check_Level(ws_intm_type_level, ws_acct_intm_cd , ws_gl_sub_acct_1,
                            ws_gl_sub_acct_2  , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                            ws_gl_sub_acct_5  , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
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
              WHEN no_data_found THEN
                p_msg_alert := 'No data found in giis_line.';      
                RETURN;
            END;
          giac_acct_entries_pkg.AEG_Check_Level(ws_line_dep_level, ws_line_cd      , ws_gl_sub_acct_1,
                          ws_gl_sub_acct_2 , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                          ws_gl_sub_acct_5 , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
          END IF;

      /**************************************************************************
      *                                                                         *
      * Validate the TREATY_DEPENDENCY_LEVEL value which indicates the segment of *
      * the GL account code that holds the treaty type.                         *
      *                                                                         *
      **************************************************************************/

          IF ws_treaty_type_level != 0 THEN      
            BEGIN
              SELECT acct_trty_type
                INTO ws_acct_treaty_type
                FROM gicl_advs_fla
               WHERE share_type= aeg_share_type 
             AND ri_cd = aeg_ri_cd
                 AND line_cd = aeg_line_cd
             AND la_yy = aeg_la_yy 
                 AND fla_seq_no = aeg_fla_seq_no;
            EXCEPTION
              WHEN no_data_found THEN
                p_msg_alert := 'No data found in gicl_advs_fla.';      
                RETURN;
            END;
          giac_acct_entries_pkg.AEG_Check_Level(ws_treaty_type_level, ws_acct_treaty_type      , ws_gl_sub_acct_1,
                          ws_gl_sub_acct_2 , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                          ws_gl_sub_acct_5 , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
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
                giac_acct_entries_pkg.AEG_Check_Level(ws_old_new_acct_level, ws_old_acct_cd  , ws_gl_sub_acct_1,
                                ws_gl_sub_acct_2     , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                                ws_gl_sub_acct_5     , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
              ELSE
                giac_acct_entries_pkg.AEG_Check_Level(ws_old_new_acct_level, ws_new_acct_cd  , ws_gl_sub_acct_1,
                                ws_gl_sub_acct_2     , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                                ws_gl_sub_acct_5     , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
              END IF;
            EXCEPTION
              WHEN no_data_found THEN
                p_msg_alert := 'No data found in giac_parameters.';
                RETURN;
            END;
          END IF;

      /**************************************************************************
      *                                                                         *
      * Check the POL_TYPE_TAG which indicates if the policy type GL code       *
      * segments will be attached to this GL account.                           *
      *                                                                         *
      **************************************************************************/

          IF ws_pol_type_tag = 'Y' THEN
            BEGIN
              SELECT NVL(gl_sub_acct_1,0), NVL(gl_sub_acct_2,0),
                     NVL(gl_sub_acct_3,0), NVL(gl_sub_acct_4,0),
                     NVL(gl_sub_acct_5,0), NVL(gl_sub_acct_6,0),
                     NVL(gl_sub_acct_7,0)
                INTO pt_gl_sub_acct_1, pt_gl_sub_acct_2,
                     pt_gl_sub_acct_3, pt_gl_sub_acct_4,
                     pt_gl_sub_acct_5, pt_gl_sub_acct_6,
                     pt_gl_sub_acct_7
                FROM giac_policy_type_entries
               WHERE line_cd = aeg_line_cd
                 AND type_cd = aeg_type_cd;
              IF pt_gl_sub_acct_1 != 0 THEN
                ws_gl_sub_acct_1 := pt_gl_sub_acct_1;
              END IF;
              IF pt_gl_sub_acct_2 != 0 THEN
                ws_gl_sub_acct_2 := pt_gl_sub_acct_2;
              END IF;
              IF pt_gl_sub_acct_3 != 0 THEN
                ws_gl_sub_acct_3 := pt_gl_sub_acct_3;
              END IF;
              IF pt_gl_sub_acct_4 != 0 THEN
                ws_gl_sub_acct_4 := pt_gl_sub_acct_4;
              END IF;
              IF pt_gl_sub_acct_5 != 0 THEN
                ws_gl_sub_acct_5 := pt_gl_sub_acct_5;
              END IF;
              IF pt_gl_sub_acct_6 != 0 THEN
                ws_gl_sub_acct_6 := pt_gl_sub_acct_6;
              END IF;
              IF pt_gl_sub_acct_7 != 0 THEN
                ws_gl_sub_acct_7 := pt_gl_sub_acct_7;
              END IF;
            EXCEPTION
              WHEN no_data_found THEN
                p_msg_alert := 'No data found in giac_policy_type_entries.';
                RETURN;
            END;
          END IF;

      /**************************************************************************
      *                                                                         *
      * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
      *                                                                         *
      **************************************************************************/
     BEGIN	/*added by steven 7.11.2012 - to return the value of p_msg_alert*/ 
      SELECT DISTINCT (gl_acct_id)
                 INTO ws_gl_acct_id
                 FROM giac_chart_of_accts
                WHERE gl_acct_category = ws_gl_acct_category
                  AND gl_control_acct = ws_gl_control_acct
                  AND gl_sub_acct_1 = ws_gl_sub_acct_1
                  AND gl_sub_acct_2 = ws_gl_sub_acct_2
                  AND gl_sub_acct_3 = ws_gl_sub_acct_3
                  AND gl_sub_acct_4 = ws_gl_sub_acct_4
                  AND gl_sub_acct_5 = ws_gl_sub_acct_5
                  AND gl_sub_acct_6 = ws_gl_sub_acct_6
                  AND gl_sub_acct_7 = ws_gl_sub_acct_7;
				  
		   EXCEPTION
			  WHEN NO_DATA_FOUND
			  THEN
				 p_msg_alert :=
					   'GL account code '
					|| TO_CHAR (ws_gl_acct_category)
					|| '-'
					|| TO_CHAR (ws_gl_control_acct, '09')
					|| '-'
					|| TO_CHAR (ws_gl_sub_acct_1, '09')
					|| '-'
					|| TO_CHAR (ws_gl_sub_acct_2, '09')
					|| '-'
					|| TO_CHAR (ws_gl_sub_acct_3, '09')
					|| '-'
					|| TO_CHAR (ws_gl_sub_acct_4, '09')
					|| '-'
					|| TO_CHAR (ws_gl_sub_acct_5, '09')
					|| '-'
					|| TO_CHAR (ws_gl_sub_acct_6, '09')
					|| '-'
					|| TO_CHAR (ws_gl_sub_acct_7, '09')
					|| ' does not exist in Chart of Accounts (Giac_Acctrans).';
					RETURN;
 		END;
       /*giac_acct_entries_pkg.AEG_Check_Chart_Of_Accts(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                 ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                 ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                 ws_gl_acct_id      , p_msg_alert); */

      /****************************************************************************
      *                                                                           *
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      *                                                                           *
      ****************************************************************************/

        IF ws_dr_cr_tag = 'D' THEN
          IF aeg_acct_amt > 0 THEN
            ws_debit_amt  := ABS(aeg_acct_amt);
            ws_credit_amt := 0;
          ELSE
            ws_debit_amt  := 0;
            ws_credit_amt := ABS(aeg_acct_amt);
          END IF;
        ELSE
          IF aeg_acct_amt > 0 THEN
            ws_debit_amt  := 0;
            ws_credit_amt := ABS(aeg_acct_amt);
          ELSE
            ws_debit_amt  := ABS(aeg_acct_amt);
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

		giac_acct_entries_pkg.insert_update_acct_entries(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
								  ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
								  ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
								  aeg_sl_cd          , ws_sl_type_cd     , aeg_gen_type   , --added ws_sl_type_cd by robert 10.17.2013
								  ws_gl_acct_id      , ws_debit_amt      , ws_credit_amt   , 
								  p_gacc_branch_cd   , p_gacc_fund_cd    , p_gacc_tran_id  , 
								  p_user_id);
								  
    END;

    PROCEDURE AEG_Parameters(p_gacc_tran_id     GIAC_ACCTRANS.tran_id%TYPE,
                             p_sl_type_cd1      GIAC_PARAMETERS.param_name%TYPE,
                             p_gen_type         GIAC_MODULES.generation_type%TYPE,
                             p_module_id        GIAC_MODULES.module_id%TYPE,
                             p_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
                             p_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                             p_user_id          giis_users.user_id%TYPE,
                             p_msg_alert    OUT VARCHAR2) IS
      /*
      **  For COLLNS ON LOSSES RECOVERABLE FROM RI...
      */
      cursor CLRR_cur is 
        SELECT a.collection_amt, a.share_type, a.a180_ri_cd, 
               a.E150_line_cd, a.E150_la_yy, a.E150_fla_seq_no, a.payee_type,
           decode(p_sl_type_cd1, 'ASSD_SL_TYPE', c.assd_no,
                                       'RI_SL_TYPE',a.a180_ri_cd,
                                       'LINE_SL_TYPE',h.acct_line_cd)sl_cd
          FROM giac_loss_ri_collns a, giis_line h, gicl_claims c
         WHERE a.E150_LINE_CD = h.LINE_CD
          AND a.claim_id = c.claim_id
          AND a.gacc_tran_id = p_gacc_tran_id;

       SHARE_TYPE           GIAC_LOSS_RI_COLLNS.SHARE_TYPE%TYPE;
       v_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE := 1;
    BEGIN
      /*
      ** Call the deletion of accounting entry procedure.
      */
	  
	  giac_acct_entries_pkg.aeg_delete_acct_entries(p_gacc_tran_id, p_gen_type);
      
      FOR CLRR_rec in CLRR_cur LOOP
        /*
        ** Call the accounting entry generation procedure.
        */
         SHARE_TYPE := CLRR_rec.SHARE_TYPE;    
      IF NVL(giacp.v('SEPARATE_RI_RECOV'),'N') = 'Y' THEN
        IF clrr_rec.payee_type = 'L' THEN
              IF SHARE_TYPE = TO_CHAR(2) THEN
                  v_item_no := 1;
              ELSIF SHARE_TYPE = TO_CHAR(3) THEN
                  v_item_no := 2;
              ELSIF SHARE_TYPE = TO_CHAR(4) THEN --John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI 
                IF NVL(giacp.v('SEPARATE_XOL_ENTRIES'),'N') = 'Y' THEN
                    v_item_no := 5;
                ELSE
                    v_item_no := 1;
                END IF;
              END IF;
          ELSE
              IF SHARE_TYPE = TO_CHAR(2) THEN
                  v_item_no := 3;
              ELSIF SHARE_TYPE = TO_CHAR(3) THEN
                  v_item_no := 4;
              ELSIF SHARE_TYPE = TO_CHAR(4) THEN --John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI 
                IF NVL(giacp.v('SEPARATE_XOL_ENTRIES'),'N') = 'Y' THEN
                    v_item_no := 6;
                ELSE
                    v_item_no := 3;
                END IF;
              END IF;
          END IF;	  	
      ELSE	
          IF SHARE_TYPE = TO_CHAR(2) THEN
              v_item_no := 1;
          ELSIF SHARE_TYPE = TO_CHAR(3) THEN
              v_item_no := 2;
          ELSIF SHARE_TYPE = TO_CHAR(4) THEN --John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI 
             IF NVL(giacp.v('SEPARATE_XOL_ENTRIES'),'N') = 'Y' THEN              
                      v_item_no := 5; 
             ELSE 
                v_item_no := 1;
             END IF; 
          END IF;
      END IF; 
      GIAC_LOSS_RI_COLLNS_PKG.AEG_Create_Acct_Entries(CLRR_rec.sl_cd, p_module_id, v_item_no,
                              NULL, NULL, CLRR_rec.e150_LINE_CD, NULL, CLRR_rec.collection_amt,
                              p_gen_type, CLRR_rec.SHARE_TYPE, CLRR_rec.A180_RI_CD, 
                              CLRR_rec.E150_LA_YY, CLRR_rec.E150_FLA_SEQ_NO,
                              p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
                              p_user_id, p_msg_alert);
      END LOOP;
	EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	  	   p_msg_alert := 'No data!'; --John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI 
    END;

END; 
/