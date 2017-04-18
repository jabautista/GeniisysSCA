CREATE OR REPLACE PACKAGE BODY CPI.Uw_Prod_Excel IS
/* created by rose 06172010: for prduction reports to be converted in excel
   created the procedure for gipir924*/
  
/* updated by elzid 06232010; created the procedure for gipir923, gipir924J, gipir923J, gipir929A, gipir929B, gipir923B, gipir924B, gipir924E
*/
PROCEDURE excel_gipir924_mx(p_scope            NUMBER,
                            p_line_cd          VARCHAR2,
                            p_subline_cd       VARCHAR2,
                            p_iss_cd           VARCHAR2,
                            p_iss_param        VARCHAR2,
                            p_file_name        VARCHAR2)
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_iss_name          VARCHAR2(50);
    v_subline           VARCHAR2(50);
    v_param_v           VARCHAR2(1);
    v_total             NUMBER(38,2);
    v_to_date           DATE;
    v_fund_cd           GIAC_NEW_COMM_INV.fund_cd%TYPE;
    v_branch_cd         GIAC_NEW_COMM_INV.branch_cd%TYPE;
    v_commission       NUMBER(20,2);
    v_commission_amt   NUMBER(20,2);
    v_comm_amt         NUMBER(20,2);
    v_tax              VARCHAR2(50);
  BEGIN
  v_file := UTL_FILE.FOPEN('EXCEL_REPORTS', p_file_name, 'W');  
     FOR x IN  (SELECT  DISTINCT iss_cd 
                 FROM  GIPI_UWREPORTS_EXT 
                  WHERE iss_cd = NVL (p_iss_cd, iss_cd)
                  AND user_id = USER
                  ORDER BY iss_cd)
      LOOP
        FOR i IN (SELECT iss_name
                  FROM  GIIS_ISSOURCE
                 WHERE iss_cd = x.iss_cd)
        LOOP
        v_iss_name := x.iss_cd||' - '||i.iss_name;
        END LOOP;
    
    v_commission       := 0;
    v_commission_amt   := 0;
    v_comm_amt         := 0;
    v_total            := 0;
     
    END LOOP;
      
      UTL_FILE.PUT_LINE(v_file,'Crediting Branch: '||v_iss_name);
      UTL_FILE.PUT_LINE(v_file,' ');
      UTL_FILE.PUT_LINE(v_file, 'LINE'||CHR(9)||'SUBLINE '||CHR(9)||'POLICY_COUNT'||CHR(9)|| 'TOTAL SUM INSURED'||CHR(9)||
                                 'TOTAL PREMIUM'||CHR(9)||'DOC. STAMPS'||CHR(9)||'FIRE SERVICE TAX'||CHR(9)||'EVAT'||CHR(9)||'LGT'||CHR(9)||'PREMIUM TAX'||CHR(9)||
                                 'SERVICE CHARGES'||CHR(9)||'NOTARIAL FEE'||CHR(9)||'OTHER CHARGES'||CHR(9)||'TOTAL AMOUNT DUE'||CHR(9)||'COMMISSION');
      
  
  FOR rec IN(SELECT line_cd,
                    subline_cd,
                    DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd,
                    SUM(DECODE(DECODE(P_SCOPE,4,NULL,spld_date),NULL,NVL(a.total_tsi,0),0)) total_si,
                    SUM(DECODE(DECODE(P_SCOPE,4,NULL,spld_date),NULL,NVL(a.total_prem,0),0)) total_prem,
                    SUM(NVL(DECODE(spld_date,NULL,a.evatprem),0)) evatprem,
                    SUM(NVL(DECODE(spld_date,NULL,a.fst),0)) fst,
                    SUM(NVL(DECODE(spld_date,NULL,a.lgt),0)) lgt,
                    SUM(NVL(DECODE(spld_date,NULL,a.doc_stamps),0)) doc_stamps,
                    SUM(NVL(DECODE(spld_date,NULL,a.other_taxes),0)) other_taxes,
                    SUM(NVL(DECODE(spld_date,NULL,a.tax10),0)) EVAT,
                    SUM(NVL(DECODE(spld_date,NULL,a.tax12),0)) prem_tax,
                    SUM(NVL(DECODE(spld_date,NULL,a.tax13),0)) service_tax,
                    SUM(NVL(DECODE(spld_date,NULL,a.tax14),0)) notarial_fee,
                    SUM(NVL(DECODE(spld_date,NULL,a.other_charges),0)) other_charges,
                    SUM(NVL(DECODE(spld_date,NULL,a.total_prem),0))+SUM(NVL(DECODE(spld_date,NULL,a.evatprem),0))+SUM(NVL(DECODE(spld_date,NULL,a.fst),0))+SUM(NVL(DECODE(spld_date,NULL,a.lgt),0))+SUM(NVL(DECODE(spld_date,NULL,a.doc_stamps),0))+SUM(NVL(DECODE(spld_date,NULL,a.other_taxes),0))+SUM(NVL(DECODE(spld_date,NULL,a.other_charges),0)) total,
                    SUM(DECODE(DECODE(P_SCOPE,4,NULL,spld_date),NULL,1,0)) pol_count,
                    SUM(NVL(DECODE(spld_date,NULL,a.evatprem),0))+SUM(NVL(DECODE(spld_date,NULL,a.fst),0))+SUM(NVL(DECODE(spld_date,NULL,a.lgt),0))+SUM(NVL(DECODE(spld_date,NULL,a.doc_stamps),0))+SUM(NVL(DECODE(spld_date,NULL,a.other_taxes),0))+SUM(NVL(DECODE(spld_date,NULL,a.other_charges),0)) total_taxes,
                    SUM(DECODE(DECODE(P_SCOPE,4,NULL,spld_date),NULL,NVL(a.comm_amt,0),0)) commission
               FROM GIPI_UWREPORTS_EXT a
              WHERE a.user_id = USER
              AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) =NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
              AND line_cd =NVL( p_line_cd, line_cd)
              AND subline_cd =NVL( p_subline_cd, subline_cd)
              AND ((p_scope=5 AND endt_seq_no=endt_seq_no)
              OR  (p_scope=1 AND endt_seq_no=0 AND pol_flag <> '5' )
              OR  (p_scope=2 AND endt_seq_no>0 AND pol_flag <> '5' )
              OR  (p_scope=4 AND POL_FLAG = '5'))
              GROUP BY line_cd,subline_cd,DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) )
 LOOP
    v_commission := 0;
    --get ISS_NAME
  /* BEGIN
      SELECT iss_name
         INTO v_iss_name
         FROM giis_issource
        WHERE iss_cd = rec.ISS_CD;
      v_iss_name := REC.iss_cd||' - '||v_iss_name;
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN NULL;
    END;*/

    --get SUBLINE_NAME
    FOR c IN(SELECT subline_name
               FROM GIIS_SUBLINE
              WHERE line_cd = rec.LINE_CD
                AND subline_cd = rec.SUBLINE_CD)
    LOOP
     v_subline := c.subline_name;
    END LOOP;

    --get TOTAL
    FOR A IN ( SELECT param_value_v
                 FROM GIAC_PARAMETERS
                WHERE param_name = 'SHOW_TOTAL_TAXES')
    LOOP
     v_param_v := a.param_value_v;
    END LOOP;

    IF v_param_v = 'Y' THEN
      v_total := rec.total_taxes;
    ELSE
      v_total := rec.total;
    END IF;

    --get COMMISSION
    BEGIN
      SELECT DISTINCT TO_DATE
        INTO v_to_date
        FROM GIPI_UWREPORTS_EXT
       WHERE user_id = USER;

      v_fund_cd   := Giacp.v('FUND_CD');
      v_branch_cd := Giacp.v('BRANCH_CD');

      FOR rc IN (SELECT b.intrmdry_intm_no, b.iss_cd, b.prem_seq_no, c.ri_comm_amt, c.currency_rt, b.commission_amt, a.spld_date
                   FROM GIPI_COMM_INVOICE  b,
                        GIPI_INVOICE c,
                        GIPI_UWREPORTS_EXT a
                  WHERE a.policy_id   = b.policy_id
                    AND b.prem_seq_no = c.prem_seq_no
                    AND b.iss_cd      = c.iss_cd
                    AND a.policy_id   = c.policy_id
                    AND a.user_id     = USER
                    AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) = rec.ISS_CD
                    AND a.line_cd    = rec.LINE_CD
                    AND a.subline_cd = rec.SUBLINE_CD
                    AND ((p_scope=5 AND a.endt_seq_no=a.endt_seq_no)
                     OR  (p_scope=1 AND a.endt_seq_no=0 AND a.pol_flag <> '5' )
                     OR  (p_scope=2 AND a.endt_seq_no>0 AND a.pol_flag <> '5' )
                     OR  (p_scope=4 AND a.pol_flag = '5')) )
      LOOP
        IF (rc.ri_comm_amt * rc.currency_rt) = 0 THEN
           v_commission_amt := rc.commission_amt;

           FOR c1 IN (SELECT acct_ent_date, commission_amt, comm_rec_id, intm_no
                        FROM GIAC_NEW_COMM_INV
                     WHERE iss_cd = rc.iss_cd
                         AND prem_seq_no = rc.prem_seq_no
                      --   AND fund_cd              = v_fund_cd
                        -- AND branch_cd            = v_branch_cd
                         AND tran_flag          = 'P'
                         AND NVL(delete_sw,'N') = 'N'
                    ORDER BY comm_rec_id DESC)
           LOOP
             IF c1.acct_ent_date > v_to_date THEN
                FOR c2 IN (SELECT commission_amt
                             FROM GIAC_PREV_COMM_INV
                          WHERE /*fund_cd = v_fund_cd
                            AND branch_cd = v_branch_cd
                            AND */comm_rec_id = c1.comm_rec_id
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

        v_commission := NVL(v_commission,0) + v_comm_amt;--commission

        IF p_scope = 4 THEN
           v_commission := v_commission;
        ELSIF rc.spld_date IS NULL THEN
           v_commission := v_commission;
        ELSE
           v_commission := 0;
        END IF;
      END LOOP;
      
    END;
    UTL_FILE.PUT_LINE(v_file, rec.line_cd||CHR(9)||v_subline||CHR(9)||rec.pol_count||
                                  CHR(9)||rec.total_si||CHR(9)||rec.total_prem||CHR(9)||rec.doc_stamps||CHR(9)||
                                  rec.fst||CHR(9)||rec.EVAT||CHR(9)||rec.lgt||CHR(9)||rec.prem_tax||CHR(9)||REC.SERVICE_TAX||CHR(9)||rec.notarial_fee||CHR(9)
                                  ||rec.other_taxes||CHR(9)||v_total||CHR(9)||rec.commission);
 
  END LOOP;
  UTL_FILE.FCLOSE(v_file);
END excel_gipir924_mx;


PROCEDURE excel_gipir923_mx(p_scope           NUMBER,
                            p_line_cd         VARCHAR2,
                            p_subline_cd      VARCHAR2,
                            p_iss_cd          VARCHAR2,
                            p_iss_param       VARCHAR2,
							p_file_name       VARCHAR2)
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_iss_name          VARCHAR2(100);
    v_line              VARCHAR2(50);
    v_subline           VARCHAR2(30);
    v_policy_no         VARCHAR2(100);
    v_endt_no           VARCHAR2(30);
    v_ref_pol_no        VARCHAR2(35):= NULL;
    v_assured           VARCHAR2(500);
    v_param_value_v     GIIS_PARAMETERS.param_value_v%TYPE;
    v_testing           VARCHAR2(50);

    --commission
    v_to_date           DATE;
    v_fund_cd           GIAC_NEW_COMM_INV.fund_cd%TYPE;
    v_branch_cd         GIAC_NEW_COMM_INV.branch_cd%TYPE;
    v_commission        NUMBER(20,2);
    v_commission_amt    NUMBER(20,2);
    v_comm_amt          NUMBER(20,2);

    v_param_v           VARCHAR2(1);
    v_total             NUMBER(38,2);
  BEGIN
  v_file := UTL_FILE.FOPEN('EXCEL_REPORTS', p_file_name, 'W');
  
  UTL_FILE.PUT_LINE(v_file, 'ISS NAME'||CHR(9)||
                            'LINE'||CHR(9)||
	  						'SUBLINE'||CHR(9)||
							'STAT'||CHR(9)||
							'POLICY NO'||CHR(9)||
							'ASSURED'||CHR(9)||
							'INVOICE'||CHR(9)||
							'INCEPT DATE'||CHR(9)||
							'EXPIRY DATE'||CHR(9)||
							'TOTAL SI'||CHR(9)||
							'TOTAL PREMIUM'||CHR(9)||
							'EVAT'||CHR(9)||
							'LGT'||CHR(9)||
							'DOC STAMPS'||CHR(9)||
							'FIRE SERVICE TAX'||CHR(9)||
							'OTHER CHARGES'||CHR(9)||
							'TOTAL'||CHR(9)||
							'COMMISSION');
  
  FOR rec IN(  SELECT DECODE(a.SPLD_DATE,NULL,DECODE(a.dist_flag,3, 'D', 'U'),'S') DIST_FLAG,
                      a.line_cd,
                      a.subline_cd,
                      DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd_head,
                      a.iss_cd,
                      a.issue_yy,
                      a.pol_seq_no,
                      a.renew_no,
                      a.endt_iss_cd,
                      a.endt_yy,
                      a.endt_seq_no,
                      a.issue_date,
                      a.incept_date,
                      a.expiry_date,
                      DECODE(a.spld_date,NULL,a.total_tsi, 0) TOTAL_TSI,
                      DECODE(a.spld_date,NULL,a.total_prem, 0) TOTAL_PREM,
                      DECODE(a.spld_date,NULL,a.evatprem, 0) EVATPREM,
                      DECODE(a.spld_date,NULL,a.lgt, 0) LGT,
                      DECODE(a.spld_date,NULL,a.doc_stamps, 0) DOC_STAMP,
                      DECODE(a.spld_date,NULL,a.fst, 0) FST,
                      DECODE(a.spld_date,NULL,a.other_taxes, 0) OTHER_TAXES,
                      DECODE(a.spld_date,NULL,(a.total_prem + a.evatprem + a.lgt + a.doc_stamps + a.fst + a.other_taxes), 0) TOTAL_CHARGES,
                      DECODE(spld_date,NULL,( a.evatprem + a.lgt + a.doc_stamps + a.fst + a.other_taxes), 0) TOTAL_TAXES,
                      a.param_date,
                      a.from_date,
                      a.TO_DATE,
                      a.SCOPE,
                      a.user_id,
                      a.policy_id,
                      a.assd_no,
                      DECODE(a.SPLD_DATE,NULL,NULL,' S   P  O  I  L  E  D       /       '||TO_CHAR(a.SPLD_DATE,'MM-DD-YYYY')) SPLD_DATE,
                      DECODE(a.SPLD_DATE,NULL,1,0) POL_COUNT,
                      DECODE(a.spld_date,NULL,NVL(b.commission_amt2,0),0) commission_amt,
                      DECODE(a.spld_date,NULL,NVL(b.wholding_tax2,0),0) wholding_tax,
                      DECODE(a.spld_date,NULL,NVL(b.net_comm2,0),0) net_comm,
                      b.ref_inv_no2
                 FROM  (SELECT SUM(DECODE(c.ri_comm_amt * c.currency_rt,0,NVL(b.commission_amt * c.currency_rt,0),c.ri_comm_amt * c.currency_rt)) commission_amt2,
                               SUM(NVL(b.wholding_tax,0)) wholding_tax2,
                               SUM(NVL(b.commission_amt,0)-NVL(b.wholding_tax,0)) net_comm2,
                               c.policy_id policy_id2,c.ref_inv_no ref_inv_no2
                          FROM GIPI_COMM_INVOICE  b,
                               GIPI_INVOICE c
                         WHERE b.iss_cd = c.iss_cd
                           AND b.prem_seq_no = c.prem_seq_no
                      GROUP BY c.policy_id,c.ref_inv_no) b,
                      GIPI_UWREPORTS_EXT a
                WHERE a.policy_id=b.policy_id2(+)
                  AND a.user_id    = USER
                  AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                  AND a.line_cd =NVL( p_line_cd, a.line_cd)
                  AND a.subline_cd =NVL( p_subline_cd, a.subline_cd)
                  AND ((p_scope=5 AND a.endt_seq_no=a.endt_seq_no )
                  OR  (p_scope=1 AND a.endt_seq_no=0 AND a.pol_flag <> '5' )
                  OR  (p_scope=2 AND a.endt_seq_no>0 AND a.pol_flag <> '5' )
                  OR  (p_scope=3 AND a.pol_flag='4' ))
            ORDER BY a.line_cd, a.subline_cd, a.iss_cd,a.issue_yy, a.pol_seq_no,
                     a.renew_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no)
 LOOP
    v_commission := 0;
    --get ISS_NAME
   BEGIN
      SELECT iss_name
         INTO v_iss_name
         FROM GIIS_ISSOURCE
        WHERE iss_cd = rec.ISS_CD;
      v_iss_name := REC.iss_cd||' - '||v_iss_name;
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN NULL;
    END;

    --get LINE_NAME
    FOR b IN(SELECT line_name
               FROM GIIS_LINE
              WHERE line_cd = rec.LINE_CD)
    LOOP
     v_line := b.line_name;
    END LOOP;

    --get SUBLINE_NAME
    FOR c IN(SELECT subline_name
               FROM GIIS_SUBLINE
              WHERE line_cd = rec.LINE_CD
                AND subline_cd = rec.SUBLINE_CD)
    LOOP
     v_subline := c.subline_name;
    END LOOP;

    --get POLICY_NO
    BEGIN
      V_POLICY_NO := rec.LINE_CD||'-'||rec.SUBLINE_CD||'-'||LTRIM(rec.ISS_CD)||'-'||LTRIM(TO_CHAR(rec.ISSUE_YY,'09'))||'-'||LTRIM(TO_CHAR(rec.POL_SEQ_NO))||'-'||LTRIM(TO_CHAR(rec.RENEW_NO,'09'));

      IF rec.ENDT_SEQ_NO <> 0 THEN
       V_ENDT_NO := rec.ENDT_ISS_CD||'-'||LTRIM(TO_CHAR(rec.ENDT_YY,'09'))||'-'||LTRIM(TO_CHAR(rec.ENDT_SEQ_NO));
      END IF;

      BEGIN
        SELECT ref_pol_no
          INTO v_ref_pol_no
          FROM GIPI_POLBASIC
         WHERE policy_id = rec.policy_id;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              v_ref_pol_no := NULL;
      END;

      IF v_ref_pol_no IS NOT NULL THEN
        v_ref_pol_no := '/'||v_ref_pol_no;
      END IF;
    END;

    --get ASSURED
    FOR c IN (SELECT assd_name
                FROM GIIS_ASSURED
               WHERE assd_no = rec.assd_no)
    LOOP
      v_assured := c.assd_name;
    END LOOP;

    --get INVOICE
    BEGIN
       SELECT param_value_v
         INTO v_param_value_v
         FROM GIIS_PARAMETERS
        WHERE param_name = 'PRINT_REF_INV';
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
           v_param_value_v := NULL;
    END;

   IF v_param_value_v = 'N' THEN
       v_testing := rec.issue_date;
   ELSE
     v_testing := rec.ref_inv_no2;
   END IF;

    --get TOTAL
    FOR A IN ( SELECT param_value_v
                 FROM GIAC_PARAMETERS
                WHERE param_name = 'SHOW_TOTAL_TAXES')
    LOOP
     v_param_v := a.param_value_v;
    END LOOP;

    IF v_param_v = 'Y' THEN
      v_total := rec.total_taxes;
    ELSE
      v_total := rec.total_charges;
    END IF;

    --get COMMISSION
    BEGIN

      SELECT DISTINCT TO_DATE
        INTO v_to_date
        FROM GIPI_UWREPORTS_EXT
       WHERE user_id = USER;

      v_fund_cd   := Giacp.v('FUND_CD');
      v_branch_cd := Giacp.v('BRANCH_CD');

      FOR rc IN (SELECT b.intrmdry_intm_no, b.iss_cd, b.prem_seq_no, c.ri_comm_amt, c.currency_rt, b.commission_amt
                   FROM GIPI_COMM_INVOICE  b,
                        GIPI_INVOICE c,
                        GIPI_UWREPORTS_EXT a
                  WHERE a.policy_id  = c.policy_id
                    AND b.iss_cd  = c.iss_cd
                    AND b.prem_seq_no  = c.prem_seq_no
                    AND a.user_id    = USER
                    AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd)     = rec.iss_cd_head
                    AND a.line_cd    = rec.line_cd
                    AND a.subline_cd = rec.subline_cd
                    AND a.policy_id = rec.policy_id
                    AND ((p_scope=5 AND a.endt_seq_no= a.endt_seq_no )
                     OR  (p_scope=1 AND a.endt_seq_no=0 AND a.pol_flag <> '5' )
                     OR  (p_scope=2 AND a.endt_seq_no>0 AND a.pol_flag <> '5' )
                     OR  (p_scope=3 AND a.pol_flag='4' )) )
      LOOP
        IF (rc.ri_comm_amt * rc.currency_rt) = 0 THEN
           v_commission_amt := rc.commission_amt;
           FOR c1 IN (SELECT acct_ent_date, commission_amt, comm_rec_id, intm_no
                        FROM GIAC_NEW_COMM_INV
                     WHERE iss_cd = rc.iss_cd
                         AND prem_seq_no = rc.prem_seq_no
                         AND fund_cd            = v_fund_cd
                         AND branch_cd          = v_branch_cd
                         AND tran_flag          = 'P'
                         AND NVL(delete_sw,'N') = 'N'
                    ORDER BY comm_rec_id DESC)
           LOOP
             IF c1.acct_ent_date > v_to_date THEN
               FOR c2 IN (SELECT commission_amt
                            FROM GIAC_PREV_COMM_INV
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
        IF rec.spld_date IS NOT NULL THEN
           v_commission := 0;
        END IF;
      END LOOP;
    END;

UTL_FILE.PUT_LINE(v_file, v_iss_name||CHR(9)||
						  v_line||CHR(9)||
						  v_subline||CHR(9)||
						  rec.dist_flag||CHR(9)||
						  v_policy_no||' '||v_endt_no||v_ref_pol_no||CHR(9)||
						  v_assured||CHR(9)||
						  v_testing||CHR(9)||
						  rec.incept_date||CHR(9)||
						  rec.expiry_date||CHR(9)||
						  rec.total_tsi||CHR(9)||
						  rec.total_prem||CHR(9)||
						  rec.evatprem||CHR(9)||
						  rec.lgt||CHR(9)||
						  rec.doc_stamp||CHR(9)||
						  rec.fst||CHR(9)||
						  rec.other_taxes||CHR(9)||
						  v_total||CHR(9)||
						  v_commission);


  END LOOP;
 UTL_FILE.FCLOSE(v_file);
END excel_gipir923_mx;
 
 
 PROCEDURE excel_gipir924J_mx(p_scope           NUMBER,
             	              p_line_cd         VARCHAR2,
                              p_subline_cd      VARCHAR2,
                              p_iss_cd          VARCHAR2,
                              p_iss_param       VARCHAR2,
							  p_file_name       VARCHAR2)
  IS
    v_file 		        UTL_FILE.FILE_TYPE;
    v_iss_name          VARCHAR2(50);
    v_subline           VARCHAR2(30);
    v_param_v           VARCHAR2(1);
    v_total             NUMBER(38,2);
	
  BEGIN
  v_file := UTL_FILE.FOPEN('EXCEL_REPORTS', p_file_name, 'W');

  UTL_FILE.PUT_LINE(v_file, 'ISS NAME'||CHR(9)||
                            'LINE'||CHR(9)||
	  						'SUBLINE'||CHR(9)||
							'POL COUNT'||CHR(9)||
							'TOT SUM INSURED'||CHR(9)||
                            'TOT PREMIUM'||CHR(9)||
							'EVAT'||CHR(9)||
							'LGT'||CHR(9)||
							'DOC STAMPS'||CHR(9)||
							'FIRE SERVICE TAX'||CHR(9)||
							'OTHER CHARGES'||CHR(9)||
                            'TOTAL');
  
  FOR rec IN(  SELECT line_cd,
                      subline_cd,
                      DECODE(p_iss_param,1,gp.cred_branch,gp.iss_cd) iss_cd,
                      SUM(NVL(total_tsi,0)) total_si,
                      SUM(NVL(total_prem,0)) total_prem,
                      SUM(NVL(evatprem,0)) evatprem,
                      SUM(NVL(fst,0)) fst,
                      SUM(NVL(lgt,0)) lgt,
                      SUM(NVL(doc_stamps,0)) doc_stamps,
                      SUM(NVL(other_taxes,0)) other_taxes,
                      SUM(NVL(other_charges,0)) other_charges,
                      SUM(NVL(total_prem,0))+SUM(NVL(evatprem,0))+SUM(NVL(fst,0))+SUM(NVL(lgt,0))+SUM(NVL(doc_stamps,0))+SUM(NVL(other_taxes,0))+SUM(NVL(other_charges,0)) total,
                      COUNT(policy_id) pol_count,
                      SUM(NVL(evatprem,0))+SUM(NVL(fst,0))+SUM(NVL(lgt,0))+SUM(NVL(doc_stamps,0))+SUM(NVL(other_taxes,0))+SUM(NVL(other_charges,0)) total_taxes
                 FROM GIPI_UWREPORTS_EXT gp
                WHERE user_id = USER
                  AND DECODE(p_iss_param,1,gp.cred_branch,gp.iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,1,gp.cred_branch,gp.iss_cd))
                  AND line_cd =NVL( p_line_cd, line_cd)
                  AND subline_cd =NVL( p_subline_cd, subline_cd)
                  AND p_scope=3 AND pol_flag='4'
             GROUP BY iss_cd,line_cd,subline_cd,DECODE(p_iss_param,1,gp.cred_branch,gp.iss_cd))
 LOOP

    --get ISS_NAME
   BEGIN
      SELECT iss_name
         INTO v_iss_name
         FROM GIIS_ISSOURCE
        WHERE iss_cd = rec.ISS_CD;
      v_iss_name := REC.iss_cd||' - '||v_iss_name;
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN NULL;
    END;

    --get SUBLINE_NAME
    FOR c IN(SELECT subline_name
               FROM GIIS_SUBLINE
              WHERE line_cd = rec.LINE_CD
                AND subline_cd = rec.SUBLINE_CD)
    LOOP
     v_subline := c.subline_name;
    END LOOP;

    --get TOTAL
    FOR A IN ( SELECT param_value_v
                 FROM GIAC_PARAMETERS
                WHERE param_name = 'SHOW_TOTAL_TAXES')
    LOOP
     v_param_v := a.param_value_v;
    END LOOP;

    IF v_param_v = 'Y' THEN
      v_total := rec.total_taxes;
    ELSE
      v_total := rec.total;
    END IF;
	
  UTL_FILE.PUT_LINE(v_file, v_iss_name||CHR(9)||
                            rec.line_cd||CHR(9)||
							v_subline||CHR(9)||
							rec.pol_count||CHR(9)||
							rec.total_si||CHR(9)||
							rec.total_prem||CHR(9)||
							rec.evatprem||CHR(9)||
							rec.lgt||CHR(9)||
							rec.doc_stamps||CHR(9)||
							rec.fst||CHR(9)||
							rec.other_taxes||CHR(9)||
							v_total );


  END LOOP;
 UTL_FILE.FCLOSE(v_file);
END excel_gipir924J_mx;


PROCEDURE excel_gipir923J_mx(p_scope           NUMBER,
                             p_line_cd         VARCHAR2,
                             p_subline_cd      VARCHAR2,
                             p_iss_cd          VARCHAR2,
                             p_iss_param       VARCHAR2,
						     p_file_name       VARCHAR2)
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_iss_name          VARCHAR2(100);
    v_line              VARCHAR2(50);
    v_subline           VARCHAR2(30);
    v_policy_no         VARCHAR2(100);
    v_endt_no           VARCHAR2(30);
    v_ref_pol_no        VARCHAR2(35):= NULL;
    v_assured           VARCHAR2(500);
    v_param_value_v     GIIS_PARAMETERS.param_value_v%TYPE;
    v_testing           VARCHAR2(50);

    v_param_v           VARCHAR2(1);
    v_total             NUMBER(38,2);
  BEGIN
  v_file := UTL_FILE.FOPEN('EXCEL_REPORTS', p_file_name, 'W');

  UTL_FILE.PUT_LINE(v_file, 'ISS NAME'||CHR(9)||
                            'LINE'||CHR(9)||
	  						'SUBLINE'||CHR(9)||
							'STAT'||CHR(9)||
							'POLICY NO'||CHR(9)||
                            'ASSURED'||CHR(9)||
							'ISSUE DATE'||CHR(9)||
							'INCEPT DATE'||CHR(9)||
							'EXPIRY DATE'||CHR(9)||
							'TOTAL SI'||CHR(9)||
							'TOT PREMIUM'||CHR(9)||
                            'EVAT'||CHR(9)||
							'LGT'||CHR(9)||
							'DOC STAMPS'||CHR(9)||
							'FIRE SERVICE TAX'||CHR(9)||
							'OTHER CHARGES'||CHR(9)||
							'TOTAL');
  
  FOR rec IN(  SELECT DECODE(spld_date,NULL,DECODE(dist_flag,3, 'D', 'U'),'S') "DIST_FLAG",
                      line_cd, subline_cd, iss_cd,DECODE(p_iss_param,1,gp.cred_branch,gp.iss_cd) iss_cd_header,
                      issue_yy, pol_seq_no, renew_no,
                      endt_iss_cd, endt_yy, endt_seq_no,
                      issue_date, incept_date, expiry_date,
                    DECODE(spld_date,NULL,total_tsi, 0) total_tsi,
                      DECODE(spld_date,NULL,total_prem, 0) total_prem,
                    DECODE(spld_date,NULL,evatprem, 0) evatprem,
                      DECODE(spld_date,NULL,lgt, 0) lgt,
                    DECODE(spld_date,NULL,doc_stamps, 0) doc_stamp,
                    DECODE(spld_date,NULL,fst, 0) fst,
                    DECODE(spld_date,NULL,other_taxes, 0) other_taxes,
                      DECODE(spld_date,NULL,(total_prem + evatprem + lgt + doc_stamps + fst + other_taxes), 0) TOTAL_CHARGES,
                      DECODE(spld_date,NULL,( evatprem + lgt + doc_stamps + fst + other_taxes), 0) total_taxes,
                      param_date, from_date, TO_DATE, SCOPE,
                      user_id, policy_id,assd_no, DECODE(spld_date,NULL,NULL,' S   P  O  I  L  E  D       /       '||TO_CHAR(spld_date,'MM-DD-YYYY')) spld_date,
                      DECODE(spld_date,NULL,1,0) pol_count
                 FROM GIPI_UWREPORTS_EXT gp
                WHERE user_id = USER
                  AND DECODE(p_iss_param,1,gp.cred_branch,gp.iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,1,gp.cred_branch,gp.iss_cd))
                  AND line_cd =NVL( p_line_cd, line_cd)
                  AND subline_cd =NVL( p_subline_cd, subline_cd)
                  AND p_scope=3 AND pol_flag='4'
             ORDER BY line_cd, subline_cd, iss_cd,
                      issue_yy, pol_seq_no, renew_no,
                      endt_iss_cd, endt_yy, endt_seq_no)
 LOOP
    --get ISS_NAME
   BEGIN
      SELECT iss_name
         INTO v_iss_name
         FROM GIIS_ISSOURCE
        WHERE iss_cd = rec.ISS_CD;
      v_iss_name := REC.iss_cd||' - '||v_iss_name;
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN NULL;
    END;

    --get LINE_NAME
    FOR b IN(SELECT line_name
               FROM GIIS_LINE
              WHERE line_cd = rec.LINE_CD)
    LOOP
     v_line := b.line_name;
    END LOOP;

    --get SUBLINE_NAME
    FOR c IN(SELECT subline_name
               FROM GIIS_SUBLINE
              WHERE line_cd = rec.LINE_CD
                AND subline_cd = rec.SUBLINE_CD)
    LOOP
     v_subline := c.subline_name;
    END LOOP;

    --get POLICY_NO
    BEGIN
      V_POLICY_NO := rec.LINE_CD||'-'||rec.SUBLINE_CD||'-'||LTRIM(rec.ISS_CD)||'-'||LTRIM(TO_CHAR(rec.ISSUE_YY,'09'))||'-'||LTRIM(TO_CHAR(rec.POL_SEQ_NO))||'-'||LTRIM(TO_CHAR(rec.RENEW_NO,'09'));

      IF rec.ENDT_SEQ_NO <> 0 THEN
       V_ENDT_NO := rec.ENDT_ISS_CD||'-'||LTRIM(TO_CHAR(rec.ENDT_YY,'09'))||'-'||LTRIM(TO_CHAR(rec.ENDT_SEQ_NO));
      END IF;

      BEGIN
        SELECT ref_pol_no
          INTO v_ref_pol_no
          FROM GIPI_POLBASIC
         WHERE policy_id = rec.policy_id;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              v_ref_pol_no := NULL;
      END;

      IF v_ref_pol_no IS NOT NULL THEN
        v_ref_pol_no := '/'||v_ref_pol_no;
      END IF;
    END;

    --get ASSURED
    FOR c IN (SELECT SUBSTR(assd_name,1,50) assd_name
                FROM GIIS_ASSURED
               WHERE assd_no = rec.assd_no)
    LOOP
      v_assured := c.assd_name;
    END LOOP;

    --get TOTAL
    SELECT Giacp.v ('SHOW_TOTAL_TAXES')
      INTO v_param_v
      FROM DUAL;

    IF v_param_v = 'Y' THEN
      v_total := rec.total_taxes;
    ELSE
      v_total := rec.total_charges;
    END IF;

  UTL_FILE.PUT_LINE(v_file, v_iss_name||CHR(9)||
                            v_line||CHR(9)||
							v_subline||CHR(9)||
							rec.dist_flag||CHR(9)||
							v_policy_no||' '||v_endt_no||v_ref_pol_no||CHR(9)||
							v_assured||CHR(9)||
							rec.issue_date||CHR(9)||
							rec.incept_date||CHR(9)||
							rec.expiry_date||CHR(9)||
							rec.total_tsi||CHR(9)||
							rec.total_prem||CHR(9)||
							rec.evatprem||CHR(9)||
							rec.lgt||CHR(9)||
							rec.doc_stamp||CHR(9)||
							rec.fst||CHR(9)||
							rec.other_taxes||CHR(9)||
							v_total );
  
  END LOOP;

 UTL_FILE.FCLOSE(v_file);
END excel_gipir923J_mx; 


PROCEDURE excel_gipir929A_mx(p_scope           NUMBER,
             		         p_line_cd         VARCHAR2,
                             p_subline_cd      VARCHAR2,
                             p_iss_cd          VARCHAR2,
                             p_iss_param       VARCHAR2,
                             p_intm_no         NUMBER,
                             p_assd_no         NUMBER,
                             p_ri_cd           VARCHAR2,
							 p_file_name       VARCHAR2)
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_iss_name          VARCHAR2(50);
    --policy_no
    v_policy_no         VARCHAR2(150);
    v_endt_no           VARCHAR2(100);
    v_ref_pol_no        VARCHAR2(100):= NULL;
  BEGIN

  v_file := UTL_FILE.FOPEN('EXCEL_REPORTS', p_file_name, 'W');

  UTL_FILE.PUT_LINE(v_file, 'ISS NAME'||CHR(9)||
                            'INTM NAME'||CHR(9)||
							'LINE'||CHR(9)||
							'SUBLINE'||CHR(9)||
							'POL COUNT'||CHR(9)||
							'TOTAL TSI'||CHR(9)||
							'TOTAL PREM'||CHR(9)||
							'EVAT PREM'||CHR(9)||
							'LGT'||CHR(9)||
							'DOC STAMPS'||CHR(9)||
							'FIRE SERVICE TAX'||CHR(9)||
							'OTHER CHARGES'||CHR(9)||
							'TOTAL'||CHR(9)||
							'COMMISSION'||CHR(9)||
							'RI COMM VAT');
							
  
  FOR rec IN(  SELECT a.ri_cd, a.ri_name, a.LINE_CD,  a.LINE_NAME, a.SUBLINE_CD, a.SUBLINE_NAME,
                      a.cred_branch ISS_CD, SUM(a.TOTAL_TSI) total_tsi,
                      SUM(a.TOTAL_PREM) total_prem, SUM(a.EVATPREM)evatprem, SUM(a.LGT) lgt,  SUM(a.DOC_STAMPS) doc_stamps,
                      SUM(a.FST) fst,  SUM(a.OTHER_TAXES) other_taxes, SUM(a.OTHER_CHARGES) other_charges,
                      a.PARAM_DATE, a.FROM_DATE, a.TO_DATE,
                      a.SCOPE, a.USER_ID,
                    SUM(a.TOTAL_PREM)+SUM(a.EVATPREM)+SUM(a.LGT)+SUM(a.DOC_STAMPS)+SUM(a.FST)+SUM(a.OTHER_TAXES)+SUM(a.OTHER_CHARGES) TOTAL,
                      COUNT(a.POLICY_ID) POL_COUNT,
                      SUM(B.commission) commission, SUM(c.ri_comm_vat) ri_comm_vat
                 FROM GIPI_UWREPORTS_INW_RI_EXT a,
                      (  SELECT x.policy_id,x.line_cd, x.subline_cd, SUM(y.ri_comm_amt) commission
                       FROM GIPI_UWREPORTS_INW_RI_EXT x, GIPI_ITMPERIL y
                      WHERE x.policy_id= y.policy_id
                       GROUP BY x.line_cd, x.subline_cd,x.policy_id) b, GIPI_INVOICE c
                WHERE a.policy_id=b.policy_id(+)
                  AND a.policy_id = c.policy_id
                  AND a.user_id = USER
                  AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                  AND NVL(a.cred_branch,'x') = NVL( p_iss_cd,NVL(a.cred_branch,'x'))
                  AND a.LINE_CD = NVL(P_LINE_CD, a.LINE_CD)
                  AND a.SUBLINE_CD = NVL(P_SUBLINE_CD, a.SUBLINE_CD)
                  AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                  OR   (p_scope=1 AND endt_seq_no=0)
                  OR   (p_scope=2 AND endt_seq_no>0))
             GROUP BY a.LINE_CD,  a.LINE_NAME, a.SUBLINE_CD, a.SUBLINE_NAME, a.cred_branch, PARAM_DATE, a.FROM_DATE, a.TO_DATE, SCOPE, a.USER_ID,a.ri_cd, a.ri_name
             ORDER BY a.cred_branch, a.ri_name, a.LINE_NAME,  a.SUBLINE_NAME)
 LOOP
    --get ISS_NAME
   BEGIN
      SELECT iss_name
         INTO v_iss_name
         FROM GIIS_ISSOURCE
        WHERE iss_cd = rec.ISS_CD;
      v_iss_name := REC.iss_cd||' - '||v_iss_name;
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN NULL;
    END;
	
	UTL_FILE.PUT_LINE(v_file, v_iss_name||CHR(9)||
	                          rec.ri_name||CHR(9)||
	                          rec.line_name||CHR(9)||
 							  rec.subline_name||CHR(9)||
							  rec.pol_count||CHR(9)||
							  rec.total_tsi||CHR(9)||
							  rec.total_prem||CHR(9)||
							  rec.evatprem||CHR(9)||
							  rec.lgt||CHR(9)||
							  rec.doc_stamps||CHR(9)||
							  rec.fst||CHR(9)||
							  rec.other_taxes||CHR(9)||
							  rec.total||CHR(9)||
							  rec.commission||CHR(9)||
							  rec.ri_comm_vat);

  END LOOP;
 UTL_FILE.FCLOSE(v_file);
END excel_gipir929A_mx;


PROCEDURE excel_gipir929B_mx(p_scope           NUMBER,
                             p_line_cd         VARCHAR2,
                             p_subline_cd      VARCHAR2,
                             p_iss_cd          VARCHAR2,
                             p_iss_param       VARCHAR2,
                             p_intm_no         NUMBER,
                             p_assd_no         NUMBER,
                             p_ri_cd           VARCHAR2,
							 p_file_name       VARCHAR2)
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_iss_name          VARCHAR2(50);
    --policy_no
    v_policy_no         VARCHAR2(150);
    v_endt_no           VARCHAR2(100);
    v_ref_pol_no        VARCHAR2(100):= NULL;
  BEGIN
  v_file := UTL_FILE.FOPEN('EXCEL_REPORTS', p_file_name, 'W');
  
  UTL_FILE.PUT_LINE(v_file, 'ISS NAME'||CHR(9)||
                            'INTM NAME'||CHR(9)||
							'LINE'||CHR(9)||
							'SUBLINE'||CHR(9)||
							'POLICY NO'||CHR(9)||
							'INCEPT DATE'||CHR(9)||
							'TOTAL TSI'||CHR(9)||
							'TOTAL PREMIUM'||CHR(9)||
							'EVAT PREM'||CHR(9)||
							'LGT'||CHR(9)||
							'DOC STAMPS'||CHR(9)||
							'FIRE SERVICE TAX'||CHR(9)||
							'OTHER CHARGES'||CHR(9)||
							'TOTAL'||CHR(9)||
							'COMMISSION'||CHR(9)||
							'RI COMM VAT');
  
  FOR rec IN(  SELECT a.ri_name, a.ri_cd, a.line_cd, a.line_name, a.subline_cd, a.subline_name,
                      DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd,
                      a.issue_yy, a.pol_seq_no, a.renew_no, a.endt_iss_cd, a.endt_yy,
                      a.endt_seq_no, a.incept_date, a.expiry_date, a.total_tsi, a.total_prem, a.evatprem,
                      a.lgt, a.doc_stamps, a.fst, a.other_taxes,
                      a.other_charges, a.param_date, a.from_date, a.TO_DATE, a.SCOPE,
                      a.user_id, a.policy_id,
                      a.total_prem+ a.evatprem+a.lgt+ a.doc_stamps+ a.fst+ a.other_taxes total,
                      SUM( b.ri_comm_amt) commission,
                      c.ri_comm_vat ri_comm_vat
                 FROM GIPI_UWREPORTS_INW_RI_EXT a, GIPI_ITMPERIL b, GIPI_INVOICE c
                WHERE a.policy_id=b.policy_id(+)
                  AND a.policy_id = c.policy_id
                  AND a.user_id = USER
                  AND NVL(a.cred_branch,'x') = NVL( p_iss_cd, NVL(a.cred_branch,'x'))
                  AND a.line_cd =NVL( p_line_cd, a.line_cd)
                  AND subline_cd =NVL( p_subline_cd, subline_cd)
                  AND ri_cd = NVL(p_ri_cd, ri_cd)
                  AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                  OR  (p_scope=1 AND endt_seq_no=0)
                  OR  (p_scope=2 AND endt_seq_no>0))
             GROUP BY a.ri_name, a.ri_cd, a.line_cd, a.line_name, a.subline_cd, a.subline_name, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd),
                      a.issue_yy, a.pol_seq_no, a.renew_no, a.endt_iss_cd, a.endt_yy,
                      a.endt_seq_no, a.incept_date, a.expiry_date, a.total_tsi, a.total_prem, a.evatprem,
                      a.lgt, a.doc_stamps, a.fst, a.other_taxes,
                      a.other_charges, a.param_date, a.from_date, a.TO_DATE, a.SCOPE,
                      a.user_id, a.policy_id, a.total_prem+ a.evatprem+ a.lgt+ a.doc_stamps+ a.fst+ a.other_taxes, a.cred_branch, c.ri_comm_vat
             ORDER BY a.ri_cd,a.line_name, a.subline_name, a.cred_branch,issue_yy, pol_seq_no,renew_no, endt_seq_no)
 LOOP
    --get ISS_NAME
   BEGIN
      SELECT iss_name
         INTO v_iss_name
         FROM GIIS_ISSOURCE
        WHERE iss_cd = rec.ISS_CD;
      v_iss_name := REC.iss_cd||' - '||v_iss_name;
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN NULL;
    END;

    --get POLICY_NO
    BEGIN
      V_POLICY_NO := rec.LINE_CD||'-'||rec.SUBLINE_CD||'-'||rec.ISS_CD||'-'||
              LPAD(TO_CHAR(rec.ISSUE_YY),2,'0')||'-'||LPAD(TO_CHAR(rec.POL_SEQ_NO),7,'0')||'-'||LPAD(TO_CHAR(rec.RENEW_NO),2,'0');
      IF rec.ENDT_SEQ_NO <> 0 THEN
        V_ENDT_NO := rec.ENDT_ISS_CD||'-'||LPAD(TO_CHAR(rec.ENDT_YY),2,'0')||'-'||LPAD(TO_CHAR(rec.ENDT_SEQ_NO),7,'0');
      END IF;
      BEGIN
         SELECT ref_pol_no
           INTO v_ref_pol_no
           FROM GIPI_POLBASIC
          WHERE policy_id = rec.policy_id;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              NULL;
      END;
      IF v_ref_pol_no IS NOT NULL THEN
       v_ref_pol_no := '/'||v_ref_pol_no;
      END IF;
    END;

  UTL_FILE.PUT_LINE(v_file, v_iss_name||CHR(9)||
                            rec.ri_cd||' - '||rec.ri_name||CHR(9)||
                            rec.line_name||CHR(9)||
							rec.subline_name||CHR(9)||
                            v_policy_no||' '||v_endt_no||v_ref_pol_no||CHR(9)||
							rec.incept_date||CHR(9)||
							rec.total_tsi||CHR(9)||
							rec.total_prem||CHR(9)||
							rec.evatprem||CHR(9)||
							rec.lgt||CHR(9)||
							rec.doc_stamps||CHR(9)||
							rec.fst||CHR(9)||
							rec.other_taxes||CHR(9)||
							rec.total||CHR(9)||
							rec.commission||CHR(9)||
							rec.ri_comm_vat );
							
  END LOOP;
 UTL_FILE.FCLOSE(v_file);
END excel_gipir929B_mx;


PROCEDURE excel_gipir923B_mx(p_scope          NUMBER,
             			     p_line_cd         VARCHAR2,
                             p_subline_cd      VARCHAR2,
                             p_iss_cd          VARCHAR2,
                             p_iss_param       VARCHAR2,
                             p_intm_no         NUMBER,
                             p_assd_no         NUMBER,
                             p_intm_type       VARCHAR2,
	   					     p_file_name       VARCHAR2)
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_iss_name          VARCHAR2(50);
    v_intm_type         VARCHAR2(20);
    v_param_value_v1    GIIS_PARAMETERS.param_value_v%TYPE;
    v_param_value_v2    GIIS_PARAMETERS.param_value_v%TYPE;
    --policy_no
    v_policy_no         VARCHAR2(150);
    v_endt_no           VARCHAR2(100);
    v_ref_pol_no        VARCHAR2(100):= NULL;
    --commission
    v_to_date           DATE;
    v_fund_cd           GIAC_NEW_COMM_INV.fund_cd%TYPE;
    v_branch_cd         GIAC_NEW_COMM_INV.branch_cd%TYPE;
   v_commission       NUMBER(20,2);
   v_commission_amt   NUMBER(20,2);
   v_comm_amt         NUMBER(20,2);
  BEGIN
  v_file := UTL_FILE.FOPEN('EXCEL_REPORTS', p_file_name, 'W');
  
  UTL_FILE.PUT_LINE(v_file, 'ISS NAME'||CHR(9)||
                            'INTM TYPE'||CHR(9)||
							'INTM NAME'||CHR(9)||
							'LINE'||CHR(9)||
							'SUBLINE'||CHR(9)||
							'POLICY NO'||CHR(9)||
							'ASSURED'||CHR(9)||
							'INVOICE'||CHR(9)||
							'POL DATE'||CHR(9)||
							'TOTAL TSI'||CHR(9)||
							'TOTAL PREM'||CHR(9)||
							'EVAT PREM'||CHR(9)||
							'LGT'||CHR(9)||
							'DOC STAMPS'||CHR(9)||
							'FIRE SERVICE TAX'||CHR(9)||
							'OTHER CHARGES'||CHR(9)||
							'TOTAL'||CHR(9)||
							'COMMISSION');
  
  FOR rec IN(  SELECT a.assd_no, SUBSTR(a.assd_name,1,50) assd_name, a.line_cd, a.line_name, a.subline_cd, a.subline_name,
                      DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd,
                      a.iss_cd iss_cd2, a.issue_yy, a.pol_seq_no, a.renew_no, a.endt_iss_cd, a.endt_yy,
                      a.endt_seq_no, a.incept_date, a.expiry_date, a.total_tsi, a.total_prem, a.evatprem,
                      a.lgt, a.doc_stamps, a.fst, a.other_taxes,
                      a.other_charges, a.param_date, a.from_date, a.TO_DATE, a.SCOPE,
                      a.user_id, a.policy_id, a.intm_name, a.intm_no,
                      a.total_prem+ a.evatprem+a.lgt+ a.doc_stamps+ a.fst+ a.other_taxes total,
                      B.COMMISSION commission, B.REF_INV_NO,a.intm_type
                 FROM GIPI_UWREPORTS_INTM_EXT a,
                      (  SELECT C.POLICY_ID,
                                SUM( DECODE(c.ri_comm_amt * c.currency_rt,0,NVL(b.commission_amt * c.currency_rt,0),c.ri_comm_amt * c.currency_rt)) commission,
                                c.iss_Cd||'-'||c.prem_seq_no||DECODE(NVL(REF_INV_NO, '1'), '1', ' ',' / '||REF_INV_NO) REF_INV_NO
                          FROM GIPI_COMM_INVOICE b,
                              GIPI_INVOICE c
                         WHERE B.POLICY_ID = C.POLICY_ID
                     GROUP BY C.POLICY_ID, c.iss_Cd||'-'||c.prem_seq_no||DECODE(NVL(REF_INV_NO, '1'), '1', ' ',' / '||REF_INV_NO)) B
                WHERE a.policy_id=b.policy_id(+)
                  AND a.user_id = USER
                  AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                  AND a.line_cd =NVL( p_line_cd, a.line_cd)
                  AND subline_cd =NVL( p_subline_cd, subline_cd)
                  AND assd_no = NVL(p_assd_no, assd_no)
                  AND intm_no = NVL(p_intm_no, intm_no)
                  AND intm_type = NVL(p_intm_type, intm_type)
                  AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                  OR  (p_scope=1 AND endt_seq_no=0)
                  OR  (p_scope=2 AND endt_seq_no>0))
             ORDER BY DECODE(p_iss_param,1,a.cred_branch,a.iss_cd), a.intm_type, a.intm_name, a.line_name, subline_name, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd),issue_yy, pol_seq_no,renew_no, endt_seq_no)
 LOOP
    v_commission := 0;
    --get ISS_NAME
   BEGIN
      SELECT iss_name
         INTO v_iss_name
         FROM GIIS_ISSOURCE
        WHERE iss_cd = rec.ISS_CD;
      v_iss_name := REC.iss_cd||' - '||v_iss_name;
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN NULL;
    END;

    --get INTM_TYPE
    BEGIN
      SELECT intm_desc
       INTO v_intm_type
       FROM GIIS_INTM_TYPE
       WHERE intm_type = rec.intm_type;
    END;

    --get POLICY_NO
    BEGIN
      V_POLICY_NO := rec.LINE_CD||'-'||rec.SUBLINE_CD||'-'||LTRIM(rec.ISS_CD2)||'-'||
              LTRIM(TO_CHAR(rec.ISSUE_YY,'09'))||'-'||LTRIM(TO_CHAR(rec.POL_SEQ_NO))||'-'||LTRIM(TO_CHAR(rec.RENEW_NO,'09'));
      IF rec.ENDT_SEQ_NO <> 0 THEN
       V_ENDT_NO := rec.ENDT_ISS_CD||'-'||LTRIM(TO_CHAR(rec.ENDT_YY,'09'))||'-'||LTRIM(TO_CHAR(rec.ENDT_SEQ_NO));
      END IF;
      BEGIN
       SELECT ref_pol_no
         INTO v_ref_pol_no
         FROM GIPI_POLBASIC
        WHERE policy_id = rec.policy_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
        NULL;
      END;
      IF v_ref_pol_no IS NOT NULL THEN
       v_ref_pol_no := '/'||v_ref_pol_no;
      END IF;
    END;

    --get INVOICE
    BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_param_value_v2
           FROM GIIS_PARAMETERS
          WHERE param_name = 'PRINT_REF_INV';
      EXCEPTION
           WHEN NO_DATA_FOUND THEN
             v_param_value_v2 := NULL;
     END;

     IF v_param_value_v2 = 'Y' THEN
       v_param_value_v2 := rec.ref_inv_no;
     ELSE
      v_param_value_v2 := rec.incept_date;
     END IF;
    END;

    --get POL_DATE
    BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_param_value_v1
           FROM GIIS_PARAMETERS
          WHERE param_name = 'PRINT_REF_INV';
      EXCEPTION
           WHEN NO_DATA_FOUND THEN
                v_param_value_v1 := NULL;
     END;

     IF v_param_value_v1 = 'Y' THEN
       v_param_value_v1 := rec.incept_date;
     ELSE
      v_param_value_v1 := rec.expiry_date;
     END IF;
    END;

    --get COMMISSION
    BEGIN

      SELECT DISTINCT TO_DATE
        INTO v_to_date
        FROM GIPI_UWREPORTS_INTM_EXT
       WHERE user_id = USER;
      v_fund_cd   := Giacp.v('FUND_CD');
      v_branch_cd := Giacp.v('BRANCH_CD');

      FOR rc IN (SELECT b.intrmdry_intm_no, b.iss_cd, b.prem_seq_no, c.ri_comm_amt, c.currency_rt, b.commission_amt
                   FROM GIPI_COMM_INVOICE  b,
                        GIPI_INVOICE c,
                        GIPI_UWREPORTS_INTM_EXT a
                  WHERE a.policy_id  = b.policy_id
                    AND a.policy_id  = c.policy_id
                    AND a.user_id    = USER
                    AND intm_no = rec.intm_no
                    AND intm_type = rec.intm_type
                    AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) = rec.iss_cd
                    AND a.line_cd = rec.line_cd
                    AND subline_cd = rec.subline_cd
                    AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                     OR  (p_scope=1 AND endt_seq_no=0)
                     OR  (p_scope=2 AND endt_seq_no>0)) )

       LOOP
          IF (rc.ri_comm_amt * rc.currency_rt) = 0 THEN
             v_commission_amt := rc.commission_amt;
              FOR c1 IN (  SELECT acct_ent_date, commission_amt, comm_rec_id, intm_no
                             FROM GIAC_NEW_COMM_INV
                         WHERE iss_cd = rc.iss_cd
                              AND prem_seq_no = rc.prem_seq_no
                              AND fund_cd              = v_fund_cd
                              AND branch_cd            = v_branch_cd
                              AND tran_flag          = 'P'
                              AND NVL(delete_sw,'N') = 'N'
                         ORDER BY comm_rec_id DESC)
              LOOP
                IF c1.acct_ent_date > v_to_date THEN
                  FOR c2 IN (SELECT commission_amt
                               FROM GIAC_PREV_COMM_INV
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
    END;

  UTL_FILE.PUT_LINE(v_file, v_iss_name||CHR(9)||
                            v_intm_type||CHR(9)||
							rec.intm_no||' - '||rec.intm_name||CHR(9)||
							rec.line_name||CHR(9)||
							rec.subline_name||CHR(9)||
							v_policy_no||' '||v_endt_no||v_ref_pol_no||CHR(9)||
							rec.assd_name||CHR(9)||
							v_param_value_v2||CHR(9)||
							v_param_value_v1||CHR(9)||
							rec.total_tsi||CHR(9)||
							rec.total_prem||CHR(9)||
							rec.evatprem||CHR(9)||
							rec.lgt||CHR(9)||
							rec.doc_stamps||CHR(9)||
							rec.fst||CHR(9)||
							rec.other_taxes||CHR(9)||
							rec.total||CHR(9)||
							v_commission);
							
  END LOOP;
 UTL_FILE.FCLOSE(v_file);
END excel_gipir923B_mx;


PROCEDURE excel_gipir924B_mx(p_scope           NUMBER,
                             p_line_cd         VARCHAR2,
                             p_subline_cd      VARCHAR2,
                             p_iss_cd          VARCHAR2,
                             p_iss_param       VARCHAR2,
                             p_intm_no         NUMBER,
                             p_assd_no         NUMBER,
                             p_intm_type       VARCHAR2,
							 p_file_name       VARCHAR2)
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_iss_name          VARCHAR2(50);
    v_intm_type         VARCHAR2(20);
    --commission
    v_to_date           DATE;
    v_fund_cd           GIAC_NEW_COMM_INV.fund_cd%TYPE;
    v_branch_cd         GIAC_NEW_COMM_INV.branch_cd%TYPE;
   v_commission       NUMBER(20,2);
   v_commission_amt   NUMBER(20,2);
   v_comm_amt         NUMBER(20,2);
  BEGIN
  v_file := UTL_FILE.FOPEN('EXCEL_REPORTS', p_file_name, 'W');
  
  UTL_FILE.PUT_LINE(v_file, 'ISS NAME'||CHR(9)||
                            'INTM TYPE'||CHR(9)||
							'INTM NAME'||CHR(9)||
							'LINE'||CHR(9)||
							'SUBLINE'||CHR(9)||
							'POL COUNT'||CHR(9)||
							'TOTAL TSI'||CHR(9)||
							'TOTAL PREM'||CHR(9)||
							'EVAT PREM'||CHR(9)||
							'LGT'||CHR(9)||
							'DOC STAMPS'||CHR(9)||
							'FIRE SERVICE TAX'||CHR(9)||
							'OTHER CHARGES'||CHR(9)||
							'TOTAL'||CHR(9)||
							'COMMISSION');
  
  FOR rec IN(  SELECT a.LINE_CD, a.LINE_NAME, a.SUBLINE_CD, a.SUBLINE_NAME,
                      DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) ISS_CD,
                      SUM(a.TOTAL_TSI) total_tsi ,
                      SUM(a.TOTAL_PREM) total_prem,
                      SUM(a.EVATPREM) evatprem,
                      SUM(a.LGT) lgt,
                      SUM(a.DOC_STAMPS) doc_stamps,
                      SUM(a.FST) fst,
                      SUM(a.OTHER_TAXES) other_taxes,
                      SUM(a.OTHER_CHARGES) other_charges,
                      a.PARAM_DATE, a.FROM_DATE, a.TO_DATE, a.SCOPE, a.USER_ID,
                      a.intm_no, a.INTM_NAME,a.INTM_TYPE,
                    SUM(a.TOTAL_PREM)+SUM(a.EVATPREM)+SUM(a.LGT)+SUM(a.DOC_STAMPS)+SUM(a.FST)+SUM(a.OTHER_TAXES)+SUM(a.OTHER_CHARGES) TOTAL,
                      COUNT(a.POLICY_ID) POL_COUNT,
                      SUM(B.COMMISSION ) commission
                 FROM GIPI_UWREPORTS_INTM_EXT a,
                      (  SELECT C.POLICY_ID,SUM( DECODE(c.ri_comm_amt * c.currency_rt,0,NVL(b.commission_amt * c.currency_rt,0),c.ri_comm_amt * c.currency_rt)) commission
                          FROM GIPI_COMM_INVOICE b,
                              GIPI_INVOICE c
                         WHERE B.POLICY_ID = C.POLICY_ID
                     GROUP BY C.POLICY_ID) B
                WHERE a.policy_id=b.policy_id(+)
                  AND a.user_id = USER
                  AND ASSD_NO = NVL(P_ASSD_NO,ASSD_NO)
                  AND INTM_NO = NVL(P_INTM_NO, INTM_NO)
                  AND INTM_TYPE = NVL(P_INTM_TYPE, INTM_TYPE)
                  AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                  AND a.LINE_CD = NVL(P_LINE_CD, a.LINE_CD)
                  AND SUBLINE_CD = NVL(P_SUBLINE_CD, SUBLINE_CD)
                  AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                  OR  (p_scope=1 AND endt_seq_no=0)
                  OR  (p_scope=2 AND endt_seq_no>0))
             GROUP BY LINE_CD,  LINE_NAME, SUBLINE_CD, SUBLINE_NAME, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd), PARAM_DATE, a.FROM_DATE, a.TO_DATE, SCOPE, a.USER_ID,intm_no, INTM_NAME,a.INTM_TYPE
             ORDER BY DECODE(p_iss_param,1,a.cred_branch,a.iss_cd),a.INTM_TYPE,a.INTM_NAME)
 LOOP
    v_commission := 0;
    --get ISS_NAME
   BEGIN
      SELECT iss_name
         INTO v_iss_name
         FROM GIIS_ISSOURCE
        WHERE iss_cd = rec.ISS_CD;
      v_iss_name := REC.iss_cd||' - '||v_iss_name;
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN NULL;
    END;

    --get INTM_TYPE
    BEGIN
      SELECT intm_desc
       INTO v_intm_type
       FROM GIIS_INTM_TYPE
       WHERE intm_type = rec.intm_type;
    END;

    --get COMMISSION
    BEGIN

      SELECT DISTINCT TO_DATE
        INTO v_to_date
        FROM GIPI_UWREPORTS_INTM_EXT
       WHERE user_id = USER;
      v_fund_cd   := Giacp.v('FUND_CD');
      v_branch_cd := Giacp.v('BRANCH_CD');

      FOR rc IN (SELECT b.intrmdry_intm_no, b.iss_cd, b.prem_seq_no, c.ri_comm_amt, c.currency_rt, b.commission_amt
                   FROM GIPI_COMM_INVOICE  b,
                        GIPI_INVOICE c,
                        GIPI_UWREPORTS_INTM_EXT a
                  WHERE a.policy_id  = b.policy_id
                    AND a.policy_id  = c.policy_id
                    AND a.user_id    = USER
                    AND intm_no = rec.intm_no
                    AND intm_type = rec.intm_type
                    AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) = rec.iss_cd
                    AND a.line_cd = rec.line_cd
                    AND subline_cd = rec.subline_cd
                    AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                     OR  (p_scope=1 AND endt_seq_no=0)
                     OR  (p_scope=2 AND endt_seq_no>0)) )

       LOOP
          IF (rc.ri_comm_amt * rc.currency_rt) = 0 THEN
             v_commission_amt := rc.commission_amt;
              FOR c1 IN (  SELECT acct_ent_date, commission_amt, comm_rec_id, intm_no
                             FROM GIAC_NEW_COMM_INV
                         WHERE iss_cd = rc.iss_cd
                              AND prem_seq_no = rc.prem_seq_no
                              AND fund_cd              = v_fund_cd
                              AND branch_cd            = v_branch_cd
                              AND tran_flag          = 'P'
                              AND NVL(delete_sw,'N') = 'N'
                         ORDER BY comm_rec_id DESC)
              LOOP
                IF c1.acct_ent_date > v_to_date THEN
                  FOR c2 IN (SELECT commission_amt
                               FROM GIAC_PREV_COMM_INV
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
    END;

  UTL_FILE.PUT_LINE(v_file, v_iss_name||CHR(9)||
						    v_intm_type||CHR(9)||
						    rec.intm_name||CHR(9)||
						    rec.line_name||CHR(9)||
						    rec.subline_name||CHR(9)||
						    rec.pol_count||CHR(9)||
						    rec.total_tsi||CHR(9)||
						    rec.total_prem||CHR(9)||
						    rec.evatprem||CHR(9)||
						    rec.lgt||CHR(9)||
						    rec.doc_stamps||CHR(9)||
						    rec.fst||CHR(9)||
    					    rec.other_taxes||CHR(9)||
						    rec.total||CHR(9)||
                            v_commission);

  END LOOP;
 UTL_FILE.FCLOSE(v_file);
END excel_gipir924B_mx;


PROCEDURE excel_gipir924E_mx(p_line_cd         VARCHAR2,
                             p_subline_cd      VARCHAR2,
                             p_iss_cd          VARCHAR2,
                             p_iss_param       VARCHAR2,
							 p_file_name	   VARCHAR2)
  IS
    v_file			    UTL_FILE.FILE_TYPE;
    v_iss_name          VARCHAR2(50);
    v_line              VARCHAR2(50);
    v_subline           VARCHAR2(50);
    v_pol_flag          CG_REF_CODES.rv_meaning%TYPE;
    v_assured           VARCHAR2(500);
    v_param_v           VARCHAR2(1);
    v_total             NUMBER(38,2);
    --policy_no
    v_policy_no         VARCHAR2(100);
    v_endt_no           VARCHAR2(30);
    v_ref_pol_no        VARCHAR2(35):= NULL;
    --commission
    v_to_date           DATE;
    v_fund_cd           GIAC_NEW_COMM_INV.fund_cd%TYPE;
    v_branch_cd         GIAC_NEW_COMM_INV.branch_cd%TYPE;
   v_commission       NUMBER(20,2);
   v_commission_amt   NUMBER(20,2);
   v_comm_amt         NUMBER(20,2);
  BEGIN
  v_file := UTL_FILE.FOPEN('EXCEL_REPORTS', p_file_name, 'W');
  
  UTL_FILE.PUT_LINE(v_file, 'ISS NAME'||CHR(9)||
							'LINE'||CHR(9)||
							'SUBLINE'||CHR(9)||
							'POL FLAG'||CHR(9)||
							'POLICY NO'||CHR(9)||
							'ASSURED'||CHR(9)||
							'ISSUE DATE'||CHR(9)||
							'INCEPT DATE'||CHR(9)||
							'EXPIRY DATE'||CHR(9)||
							'TOTAL SUM INSURED'||CHR(9)||
							'TOTAL PREMIUM'||CHR(9)||
							'EVAT'||CHR(9)||
							'LGT'||CHR(9)||
							'DOC STAMPS'||CHR(9)||
							'FIRE SERVICE TAX'||CHR(9)||
							'OTHER CHARGES'||CHR(9)||
							'TOTAL'||CHR(9)||
							'COMMISSION');
  
  FOR rec IN(  SELECT DECODE(SPLD_DATE,NULL,DECODE(a.dist_flag,3, 'D', 'U'),'S') DIST_FLAG,
                      a.line_cd, a.subline_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) iss_cd_header,a.iss_cd,
                      a.issue_yy, a.pol_seq_no, a.renew_no,
                      a.endt_iss_cd, a.endt_yy, a.endt_seq_no,
                      a.issue_date, a.incept_date, a.expiry_date,
                    DECODE(spld_date,NULL,a.total_tsi, 0) TOTAL_TSI,
                      DECODE(spld_date,NULL,a.total_prem, 0) TOTAL_PREM,
                    DECODE(spld_date,NULL,a.evatprem, 0) EVATPREM,
                      DECODE(spld_date,NULL,a.lgt, 0) LGT,
                    DECODE(spld_date,NULL,a.doc_stamps, 0) DOC_STAMP,
                    DECODE(spld_date,NULL,a.fst, 0) FST,
                    DECODE(spld_date,NULL,a.other_taxes, 0) OTHER_TAXES,
                      DECODE(spld_date,NULL,(a.total_prem + a.evatprem + a.lgt + a.doc_stamps + a.fst + a.other_taxes), 0) TOTAL_CHARGES,
                      DECODE(spld_date,NULL,( a.evatprem + a.lgt + a.doc_stamps + a.fst + a.other_taxes), 0) TOTAL_TAXES,
                      a.param_date, a.from_date, a.TO_DATE, SCOPE,
                      a.user_id, a.policy_id,a.assd_no, DECODE(SPLD_DATE,NULL,NULL,' S   P  O  I  L  E  D       /       '||TO_CHAR(SPLD_DATE,'MM-DD-YYYY')) SPLD_DATE,
                      DECODE(SPLD_DATE,NULL,1,0) POL_COUNT,
                      DECODE(spld_date,NULL,b.commission_amt,0) commission_amt,
                      DECODE(spld_date,NULL,b.wholding_tax,0) wholding_tax,
                      DECODE(spld_date,NULL,b.net_comm,0) net_comm,
                      a.pol_flag
                 FROM GIPI_UWREPORTS_EXT a,
                      (SELECT SUM(DECODE(c.ri_comm_amt * c.currency_rt,0,NVL(b.commission_amt * c.currency_rt,0),c.ri_comm_amt * c.currency_rt)) commission_amt,
                              SUM(NVL(b.wholding_tax,0)) wholding_tax,
                              SUM((NVL(b.commission_amt,0) - NVL(b.wholding_tax,0))) net_comm, c.policy_id policy_id
                         FROM GIPI_COMM_INVOICE  b,
                              GIPI_INVOICE c
                        WHERE c.policy_id=b.policy_id GROUP BY c.policy_id) b
                WHERE a.policy_id=b.policy_id(+)
                  AND a.user_id    = USER
                  AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,1,a.cred_branch,a.iss_cd))
                  AND line_cd =NVL( p_line_cd, line_cd)
                  AND subline_cd =NVL( p_subline_cd, subline_cd)
             ORDER BY a.line_cd, a.subline_cd, a.iss_cd,
                      a.issue_yy, a.pol_seq_no, a.renew_no,
                      a.endt_iss_cd, a.endt_yy, a.endt_seq_no)
 LOOP
    v_commission := 0;
    --get ISS_NAME
   BEGIN
      SELECT iss_name
         INTO v_iss_name
         FROM GIIS_ISSOURCE
        WHERE iss_cd = rec.ISS_CD;
      v_iss_name := REC.iss_cd||' - '||v_iss_name;
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN NULL;
    END;

    --get LINE_NAME
    FOR c IN (SELECT line_name
                FROM GIIS_LINE
               WHERE line_cd = rec.line_cd)
    LOOP
      v_line := c.line_name;
    END LOOP;

    --get SUBLINE_NAME
    FOR c IN(SELECT subline_name
               FROM GIIS_SUBLINE
              WHERE line_cd = rec.LINE_CD
                AND subline_cd = rec.SUBLINE_CD)
    LOOP
     v_subline := c.subline_name;
    END LOOP;

    --get POL_FLAG
    BEGIN
      FOR c1 IN (SELECT rv_meaning
                   FROM CG_REF_CODES
                  WHERE rv_domain = 'GIPI_POLBASIC.POL_FLAG'
                    AND rv_low_value = rec.pol_flag)
      LOOP
       v_pol_flag := c1.rv_meaning;
      END LOOP;
    END;

    --get POLICY_NO
    BEGIN
      V_POLICY_NO := rec.LINE_CD||'-'||rec.SUBLINE_CD||'-'||LTRIM(rec.ISS_CD)||'-'||
              LTRIM(TO_CHAR(rec.ISSUE_YY,'09'))||'-'||LTRIM(TO_CHAR(rec.POL_SEQ_NO))||'-'||LTRIM(TO_CHAR(rec.RENEW_NO,'09'));

      IF rec.ENDT_SEQ_NO <> 0 THEN
       V_ENDT_NO := rec.ENDT_ISS_CD||'-'||LTRIM(TO_CHAR(rec.ENDT_YY,'09'))||'-'||LTRIM(TO_CHAR(rec.ENDT_SEQ_NO));
      END IF;

      BEGIN
       SELECT ref_pol_no
         INTO v_ref_pol_no
         FROM GIPI_POLBASIC
        WHERE policy_id = rec.policy_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
        v_ref_pol_no := NULL;
      END;

      IF v_ref_pol_no IS NOT NULL THEN
       v_ref_pol_no := '/'||v_ref_pol_no;
      END IF;
    END;

    --get ASSURED
    FOR c IN (SELECT SUBSTR(assd_name,1,50) assd_name
                FROM GIIS_ASSURED
               WHERE assd_no = rec.assd_no)
    LOOP
      v_assured := c.assd_name;
    END LOOP;

    --get TOTAL
    SELECT Giacp.v ('SHOW_TOTAL_TAXES')
      INTO v_param_v
      FROM DUAL;

     IF v_param_v = 'Y' THEN
        IF rec.spld_date IS NULL THEN
           v_total := rec.total_taxes;
        ELSE
           v_total := rec.total_charges;
        END IF;
     ELSE
        v_total := rec.total_charges;
     END IF;

    --get COMMISSION
    BEGIN

      SELECT DISTINCT TO_DATE
        INTO v_to_date
        FROM GIPI_UWREPORTS_EXT
       WHERE user_id = USER;
      v_fund_cd := Giacp.v('FUND_CD');
      v_branch_cd := Giacp.v('BRANCH_CD');

      FOR rc IN (SELECT b.intrmdry_intm_no, b.iss_cd, b.prem_seq_no, c.ri_comm_amt, c.currency_rt, b.commission_amt, a.spld_date
                   FROM GIPI_COMM_INVOICE  b,
                        GIPI_INVOICE c,
                        GIPI_UWREPORTS_EXT a
                  WHERE a.policy_id  = b.policy_id
                    AND a.policy_id  = c.policy_id
                    AND a.user_id    = USER
                    AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd) = rec.iss_cd
                    AND a.line_cd    = rec.line_cd
                    AND a.subline_cd = rec.subline_cd
                    AND a.policy_id = rec.policy_id)

       LOOP
          IF (rc.ri_comm_amt * rc.currency_rt) = 0 THEN
             v_commission_amt := rc.commission_amt;
              FOR c1 IN (SELECT acct_ent_date, commission_amt, comm_rec_id, intm_no
                           FROM GIAC_NEW_COMM_INV
                       WHERE iss_cd = rc.iss_cd
                            AND prem_seq_no = rc.prem_seq_no
                            AND fund_cd              = v_fund_cd
                            AND branch_cd            = v_branch_cd
                            AND tran_flag          = 'P'
                            AND NVL(delete_sw,'N') = 'N'
                          ORDER BY comm_rec_id DESC)
              LOOP
                IF c1.acct_ent_date > v_to_date THEN
                  FOR c2 IN (SELECT commission_amt
                               FROM GIAC_PREV_COMM_INV
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
         IF rc.spld_date IS NOT NULL THEN
            v_commission := 0;
         END IF;
       END LOOP;
    END;

UTL_FILE.PUT_LINE(v_file, v_iss_name||CHR(9)||
						  v_line||CHR(9)||
						  v_subline||CHR(9)||
						  v_pol_flag||CHR(9)||
						  v_policy_no||' '||v_endt_no||v_ref_pol_no||CHR(9)||
						  v_assured||CHR(9)||
						  rec.issue_date||CHR(9)||
						  rec.incept_date||CHR(9)||
						  rec.expiry_date||CHR(9)||
						  rec.total_tsi||CHR(9)||
						  rec.total_prem||CHR(9)||
						  rec.evatprem||CHR(9)||
						  rec.lgt||CHR(9)||
						  rec.doc_stamp||CHR(9)||
						  rec.fst||CHR(9)||
						  rec.other_taxes||CHR(9)||
						  v_total||CHR(9)||
						  v_commission);


  END LOOP;
 UTL_FILE.FCLOSE(v_file);
END excel_gipir924E_mx;


END Uw_Prod_Excel;
/


