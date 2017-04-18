CREATE OR REPLACE PACKAGE BODY CPI.CSV_BRDRX_DIST AS
  
  PROCEDURE CSV_GICLR205E(p_session_id          VARCHAR2,
                          p_claim_id            VARCHAR2,
                          p_intm_break          NUMBER,
                          p_file_name           VARCHAR2) 
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_columns           VARCHAR2(32767);
    v_headers           VARCHAR2(32767);
    v_totals            VARCHAR2(32767);
    v_loss              NUMBER := 0;
    v_outstanding       NUMBER := 0;
    v_month_grp         VARCHAR2(100);
    v_source_type_desc  GIIS_INTM_TYPE.INTM_DESC%TYPE;
    v_source_name       GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name         GIIS_LINE.LINE_NAME%TYPE;
    v_subline_name      GIIS_SUBLINE.SUBLINE_NAME%TYPE;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(1000);
  
    CURSOR c1 IS SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                                 DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
                                 A.ISS_CD,
                                 A.BUSS_SOURCE,
                                 A.LINE_CD,
                                 A.SUBLINE_CD,
                                 A.LOSS_YEAR,
                                 A.BRDRX_RECORD_ID,
                                 A.CLAIM_ID,
                                 A.ASSD_NO,
                                 A.CLAIM_NO,
                                 A.POLICY_NO,
                                 A.INCEPT_DATE,
                                 A.EXPIRY_DATE,
                                 A.LOSS_DATE,
                                 A.CLM_FILE_DATE,
                                 A.ITEM_NO,
                                 A.grouped_item_no,
                                 A.PERIL_CD,
                                 A.LOSS_CAT_CD,
                                 A.TSI_AMT,
                                 A.INTM_NO,
                                 (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_LOSS           
                            FROM GICL_RES_BRDRX_EXTR A,
                                 GIIS_INTERMEDIARY B
                           WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                             AND A.SESSION_ID = P_SESSION_ID 
                             AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                             AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0;
  BEGIN
    v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
    
    FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR205E')
    LOOP
      utl_file.put_line(v_file,'"'||i.report_title||'"');
      EXIT;
    END LOOP;
    
    
    FOR i IN (SELECT DISTINCT from_date, to_date,
                     DECODE(ol_date_opt, 1, 'Loss Date', 2, 'Claim File Date', 3, 'Booking Month') opt
                FROM gicl_res_brdrx_extr
               WHERE session_id = p_session_id)
    LOOP
      utl_file.put_line(v_file, '"Based on '||i.opt||'"');
      
      IF i.from_date IS NOT NULL THEN
         utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                                  ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      ELSE
         utl_file.put_line(v_file,'"As of '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      END IF;
      utl_file.put_line(v_file, ' ');
      EXIT;
    END LOOP; 
    
    v_headers := 'BUSINESS SOURCE,SOURCE NAME,ISSUE SOURCE,LINE,SUBLINE,'||
                 'LOSS YEAR,CLAIM NUMBER,POLICY NUMBER,ASSURED,INCEPT DATE,EXPIRY DATE,'||
                 'DATE OF LOSS,ITEM,TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY,OUTSTANDING';
    
 FOR j IN (SELECT DISTINCT A.SHARE_CD, A.TRTY_NAME 
                         FROM GIIS_DIST_SHARE A, GICL_RES_BRDRX_DS_EXTR B 
                        WHERE A.SHARE_CD IN (1, 999) 
                          AND A.SHARE_CD = B.GRP_SEQ_NO
                          AND B.SESSION_ID = p_session_id
                          AND (NVL(b.EXPENSE_RESERVE,0) - NVL(B.EXPENSES_PAID,0)) > 0
                        ORDER BY SHARE_CD) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;

    FOR j IN (SELECT DISTINCT A.LINE_CD, A.SHARE_CD, A.TRTY_NAME 
                         FROM GIIS_DIST_SHARE A, GICL_RES_BRDRX_DS_EXTR B 
                        WHERE A.SHARE_CD NOT IN (1, 999) 
                          AND A.SHARE_CD = B.GRP_SEQ_NO
                          AND A.LINE_CD = B.LINE_CD
                          AND B.SESSION_ID = p_session_id
                          AND (NVL(B.EXPENSE_RESERVE,0) - NVL(B.EXPENSES_PAID,0)) > 0
                     ORDER BY LINE_CD, SHARE_CD) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;
 
    utl_file.put_line(v_file,v_headers);     
  
    FOR rec IN c1 
    LOOP 
      BEGIN
        SELECT INTM_DESC
          INTO V_SOURCE_TYPE_DESC
          FROM GIIS_INTM_TYPE
         WHERE INTM_TYPE = rec.BUSS_SOURCE_TYPE;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
               V_SOURCE_TYPE_DESC := 'REINSURER ';
          WHEN OTHERS THEN
               V_SOURCE_TYPE_DESC := NULL;
      END;

      IF rec.ISS_TYPE = 'RI' THEN
        BEGIN
          SELECT RI_NAME
            INTO V_SOURCE_NAME
            FROM GIIS_REINSURER
           WHERE RI_CD  = rec.BUSS_SOURCE;
        EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
        END;
      ELSE
        BEGIN
          SELECT INTM_NAME
            INTO V_SOURCE_NAME
            FROM GIIS_INTERMEDIARY
           WHERE INTM_NO  = rec.BUSS_SOURCE;
        EXCEPTION
            WHEN OTHERS THEN
                 V_SOURCE_NAME  := NULL;
        END;
      END IF;
    
      BEGIN
        SELECT ISS_NAME
          INTO V_ISS_NAME
          FROM GIIS_ISSOURCE
         WHERE ISS_CD  = rec.ISS_CD;
      EXCEPTION
          WHEN OTHERS THEN
               V_ISS_NAME  := NULL;
      END;
    
      BEGIN
        SELECT LINE_NAME
          INTO V_LINE_NAME
          FROM GIIS_LINE
         WHERE LINE_CD = rec.LINE_CD;
      EXCEPTION
          WHEN OTHERS THEN
               V_LINE_NAME  := NULL;
      END;
    
      BEGIN
        SELECT SUBLINE_NAME
          INTO V_SUBLINE_NAME
          FROM GIIS_SUBLINE
         WHERE SUBLINE_CD = rec.SUBLINE_CD
           AND LINE_CD    = rec.LINE_CD;
      EXCEPTION
          WHEN OTHERS THEN
               V_SUBLINE_NAME  := NULL;
      END;
    
      BEGIN
        SELECT B.REF_POL_NO
          INTO v_ref_pol_no
          FROM GICL_CLAIMS a, GIPI_POLBASIC b
         WHERE A.LINE_CD = B.LINE_CD
           AND A.SUBLINE_CD = B.SUBLINE_CD
           AND A.POL_ISS_CD = B.ISS_CD
           AND A.ISSUE_YY = B.ISSUE_YY
           AND A.POL_SEQ_NO = B.POL_SEQ_NO
           AND A.RENEW_NO = B.RENEW_NO
           AND B.ENDT_SEQ_NO = 0
           AND A.CLAIM_ID = rec.CLAIM_ID
           AND REF_POL_NO IS NOT NULL;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
               v_ref_pol_no := NULL;
      END;
    
      IF v_ref_pol_no IS NOT NULL THEN
         v_policy := rec.policy_no||'/'||v_ref_pol_no;
      ELSE
         v_policy := rec.policy_no;
      END IF;
    
      BEGIN
        SELECT ASSD_NAME
          INTO V_ASSD_NAME
          FROM GIIS_ASSURED
         WHERE ASSD_NO = rec.ASSD_NO;
      EXCEPTION
          WHEN OTHERS THEN
               V_ASSD_NAME := NULL;
      END;

      v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));
    
      BEGIN
        SELECT PERIL_NAME
          INTO V_PERIL_NAME
          FROM GIIS_PERIL
         WHERE PERIL_CD    = rec.PERIL_CD
           AND LINE_CD     = rec.LINE_CD;
      EXCEPTION
          WHEN OTHERS THEN
               V_PERIL_NAME  := NULL;
      END;
    
      BEGIN
        SELECT POL_ISS_CD
          INTO V_POL_ISS_CD
          FROM GICL_CLAIMS
         WHERE CLAIM_ID = rec.CLAIM_ID;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
               v_pol_iss_cd := NULL;
      END;

      IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
        BEGIN
          FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                      FROM GICL_CLAIMS a, GIIS_REINSURER b
                     WHERE a.ri_cd = b.ri_cd
                       AND a.claim_id = rec.claim_id)
          LOOP
            v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
          END LOOP;
        END;
      ELSE
        IF p_intm_break = 1 THEN
          BEGIN
            FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                             b.ref_intm_cd ref_intm_cd
                        FROM GICL_RES_BRDRX_EXTR a, GIIS_INTERMEDIARY b
                       WHERE a.intm_no = b.intm_no
                         AND a.session_id = p_session_id
                         AND a.claim_id = rec.claim_id
                         AND a.item_no = rec.item_no
                         AND a.peril_cd = rec.peril_cd
                         AND a.intm_no = rec.intm_no)
            LOOP
              v_intm_ri := TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||i.intm_name;
            END LOOP;
          END;
        ELSIF p_intm_break = 0 THEN
          BEGIN
            FOR m IN (SELECT a.intm_no, b.intm_name intm_name, b.ref_intm_cd
                        FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                       WHERE a.intm_no = b.intm_no
                         AND a.claim_id = rec.claim_id
                         AND a.item_no = rec.item_no
                         AND a.peril_cd = rec.peril_cd)
            LOOP
              v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
            END LOOP;
          END;
        END IF;
      END IF;
   
      v_columns := '"'||v_source_type_desc||'","'||v_source_name||'","'||v_iss_name||'","'||v_line_name||'","'||v_subline_name||
                   '",'||rec.loss_year||',"'||rec.claim_no||'","'||v_policy||'","'||v_assd_name||'",'||rec.incept_date||
       ','||rec.expiry_date||','||rec.loss_date||',"'||v_item_title||'",'||rec.tsi_amt||',"'||v_peril_name||
       '","'||v_intm_ri||'",'||rec.outstanding_loss;

      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                            AND (NVL(B.EXPENSE_RESERVE,0) - NVL(B.EXPENSES_PAID,0)) > 0
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT (NVL(c.expense_reserve, 0) - NVL(c.expenses_paid, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND (NVL(C.EXPENSE_RESERVE,0) - NVL(C.EXPENSES_PAID,0)) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
  v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;
    
      FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND (NVL(B.EXPENSE_RESERVE,0) - NVL(B.EXPENSES_PAID,0)) > 0
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT c.claim_id, (NVL(c.expense_reserve, 0) - NVL(c.EXPENSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
                     AND c.session_id = p_session_id
                     AND (NVL(c.EXPENSE_RESERVE,0) - NVL(c.EXPENSES_PAID,0)) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
        v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;  
     utl_file.put_line(v_file,v_columns);
   v_outstanding := v_outstanding + rec.outstanding_loss;  
    END LOOP;
  
    v_totals := ',,,,,,,,,,,,,,,TOTAL,'||v_outstanding;
    FOR j IN (SELECT DISTINCT a.share_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND b.session_id = p_session_id
                          AND (NVL(B.EXPENSE_RESERVE,0) - NVL(B.EXPENSES_PAID,0)) > 0
                     ORDER BY share_cd) 
    LOOP
      FOR k IN (SELECT SUM((NVL(c.expense_reserve, 0) - NVL(c.EXPENSES_PAID, 0))) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND (NVL(C.EXPENSE_RESERVE,0) - NVL(C.EXPENSES_PAID,0)) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
  
    FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd NOT IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND a.line_cd = b.line_cd
                          AND b.session_id = p_session_id
                          AND (NVL(B.EXPENSE_RESERVE,0) - NVL(B.EXPENSES_PAID,0)) > 0
                     ORDER BY line_cd, share_cd) 
    LOOP
      FOR k IN (SELECT SUM((NVL(c.expense_reserve, 0) - NVL(c.expenses_paid, 0))) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND c.line_cd = j.line_cd
                   AND (NVL(C.EXPENSE_RESERVE,0) - NVL(C.EXPENSES_PAID,0)) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
    utl_file.put_line(v_file,v_totals);
    utl_file.fclose(v_file); 
  END;
  
  ----------------------------------------------------------------------------------------------------
  
  PROCEDURE CSV_GICLR205L(p_session_id          VARCHAR2,
                      p_claim_id            VARCHAR2,
                      p_intm_break      NUMBER,
                      p_file_name   VARCHAR2)
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_columns           VARCHAR2(32767);
    v_headers           VARCHAR2(32767);
    v_totals            VARCHAR2(32767);
    v_loss              NUMBER := 0;
    v_outstanding       NUMBER := 0;
    v_month_grp         VARCHAR2(100);
    v_source_type_desc  GIIS_INTM_TYPE.INTM_DESC%TYPE;
    v_source_name       GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name         GIIS_LINE.LINE_NAME%TYPE;
    v_subline_name      GIIS_SUBLINE.SUBLINE_NAME%TYPE;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(1000);
  
    CURSOR c1 IS SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                                 DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
                                 A.ISS_CD,
                                 A.BUSS_SOURCE,
                                 A.LINE_CD,
                                 A.SUBLINE_CD,
                                 A.LOSS_YEAR,
                                 A.BRDRX_RECORD_ID,
                                 A.CLAIM_ID,
                                 A.ASSD_NO,
                                 A.CLAIM_NO,
                                 A.POLICY_NO,
                                 A.INCEPT_DATE,
                                 A.EXPIRY_DATE,
                                 A.LOSS_DATE,
                                 A.CLM_FILE_DATE,
                                 A.ITEM_NO,
                                 A.grouped_item_no,
                                 A.PERIL_CD,
                                 A.LOSS_CAT_CD,
                                 A.TSI_AMT,
                                 A.INTM_NO,
                                 (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) OUTSTANDING_LOSS           
                            FROM GICL_RES_BRDRX_EXTR A,
                                 GIIS_INTERMEDIARY B
                           WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                             AND A.SESSION_ID = P_SESSION_ID 
                             AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                             AND (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) > 0;
  BEGIN
    v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
    
    FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR205L')
    LOOP
      utl_file.put_line(v_file,'"'||i.report_title||'"');
      EXIT;
    END LOOP;
    
    
    FOR i IN (SELECT DISTINCT from_date, to_date,
                     DECODE(ol_date_opt, 1, 'Loss Date', 2, 'Claim File Date', 3, 'Booking Month') opt
                FROM gicl_res_brdrx_extr
               WHERE session_id = p_session_id)
    LOOP
      utl_file.put_line(v_file, '"Based on '||i.opt||'"');
      
      IF i.from_date IS NOT NULL THEN
         utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                                  ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      ELSE
         utl_file.put_line(v_file,'"As of '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      END IF;
      utl_file.put_line(v_file, ' ');
      EXIT;
    END LOOP;
    
    v_headers := 'BUSINESS SOURCE,SOURCE NAME,ISSUE SOURCE,LINE,SUBLINE,'||
                 'LOSS YEAR,CLAIM NUMBER,POLICY NUMBER,ASSURED,INCEPT DATE,EXPIRY DATE,'||
                 'DATE OF LOSS,ITEM,TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY,OUTSTANDING';

    FOR j IN (SELECT DISTINCT a.share_cd, a.trty_name 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND b.session_id = p_session_id
                          AND (NVL(B.LOSS_RESERVE,0) - NVL(B.LOSSES_PAID,0)) > 0
                     ORDER BY share_cd) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;
  
    FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd, a.trty_name 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd NOT IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND a.line_cd = b.line_cd
                          AND b.session_id = p_session_id
                          AND (NVL(B.LOSS_RESERVE,0) - NVL(B.LOSSES_PAID,0)) > 0
                     ORDER BY line_cd, share_cd) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;
    utl_file.put_line(v_file,v_headers);     

    FOR rec IN c1 
    LOOP 
      BEGIN
        SELECT INTM_DESC
          INTO V_SOURCE_TYPE_DESC
          FROM GIIS_INTM_TYPE
         WHERE INTM_TYPE = rec.BUSS_SOURCE_TYPE;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
               V_SOURCE_TYPE_DESC := 'REINSURER ';
          WHEN OTHERS THEN
               V_SOURCE_TYPE_DESC := NULL;
      END;
    
      IF rec.ISS_TYPE = 'RI' THEN
        BEGIN
          SELECT RI_NAME
            INTO V_SOURCE_NAME
            FROM GIIS_REINSURER
           WHERE RI_CD  = rec.BUSS_SOURCE;
        EXCEPTION
            WHEN OTHERS THEN
                 V_SOURCE_NAME  := NULL;
        END;
      ELSE
        BEGIN
          SELECT INTM_NAME
            INTO V_SOURCE_NAME
            FROM GIIS_INTERMEDIARY
           WHERE INTM_NO  = rec.BUSS_SOURCE;
        EXCEPTION
            WHEN OTHERS THEN
                 V_SOURCE_NAME  := NULL;
        END;
      END IF;
    
      BEGIN
        SELECT ISS_NAME
          INTO V_ISS_NAME
          FROM GIIS_ISSOURCE
         WHERE ISS_CD  = rec.ISS_CD;
      EXCEPTION
          WHEN OTHERS THEN
               V_ISS_NAME  := NULL;
      END;
    
      BEGIN
        SELECT LINE_NAME
          INTO V_LINE_NAME
          FROM GIIS_LINE
         WHERE LINE_CD     = rec.LINE_CD;
      EXCEPTION
          WHEN OTHERS THEN
               V_LINE_NAME  := NULL;
      END;
    
      BEGIN
        SELECT SUBLINE_NAME
          INTO V_SUBLINE_NAME
          FROM GIIS_SUBLINE
         WHERE SUBLINE_CD = rec.SUBLINE_CD
           AND LINE_CD    = rec.LINE_CD;
      EXCEPTION
          WHEN OTHERS THEN
               V_SUBLINE_NAME  := NULL;
      END;
    
      BEGIN
        SELECT b.ref_pol_no
          INTO v_ref_pol_no
          FROM GICL_CLAIMS a, GIPI_POLBASIC b
         WHERE a.line_cd = b.line_cd
           AND a.subline_cd = b.subline_cd
           AND a.pol_iss_cd = b.iss_cd
           AND a.issue_yy = b.issue_yy
           AND a.pol_seq_no = b.pol_seq_no
           AND a.renew_no = b.renew_no
           AND b.endt_seq_no = 0
           AND a.claim_id = rec.claim_id
           AND ref_pol_no IS NOT NULL;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
               v_ref_pol_no := NULL;
      END;
    
      IF v_ref_pol_no IS NOT NULL THEN
        v_policy := rec.policy_no||'/'||v_ref_pol_no;
      ELSE
        v_policy := rec.policy_no;
      END IF;
    
      BEGIN
        SELECT ASSD_NAME
          INTO V_ASSD_NAME
          FROM GIIS_ASSURED
         WHERE ASSD_NO = rec.ASSD_NO;
      EXCEPTION
          WHEN OTHERS THEN
               V_ASSD_NAME := NULL;
      END;
    
   v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));
    
   BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
      EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
      END;
    
      BEGIN
        SELECT pol_iss_cd
          INTO v_pol_iss_cd
          FROM GICL_CLAIMS
         WHERE claim_id = rec.claim_id;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
               v_pol_iss_cd := NULL;
      END;

      IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
        BEGIN
          FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                      FROM GICL_CLAIMS a, GIIS_REINSURER b
                     WHERE a.ri_cd = b.ri_cd
                       AND a.claim_id = rec.claim_id)
          LOOP
            v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
          END LOOP;
        END;
      ELSE
        IF p_intm_break = 1 THEN
          BEGIN
            FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                             b.ref_intm_cd ref_intm_cd
                        FROM GICL_RES_BRDRX_EXTR a, GIIS_INTERMEDIARY b
                       WHERE a.intm_no = b.intm_no
                         AND a.session_id = p_session_id
                         AND a.claim_id = rec.claim_id
                         AND a.item_no = rec.item_no
                         AND a.peril_cd = rec.peril_cd
                         AND a.intm_no = rec.intm_no)
            LOOP
              v_intm_ri := TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||i.intm_name;
            END LOOP;
          END;
        ELSIF p_intm_break = 0 THEN
          BEGIN
            FOR m IN (SELECT a.intm_no, b.intm_name intm_name, b.ref_intm_cd
                        FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                       WHERE a.intm_no = b.intm_no
                         AND a.claim_id = rec.claim_id
                         AND a.item_no = rec.item_no
                         AND a.peril_cd = rec.peril_cd)
            LOOP
              v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
            END LOOP;
          END;
        END IF;
      END IF;

      v_columns := '"'||v_source_type_desc||'","'||v_source_name||'","'||v_iss_name||'","'||v_line_name||'","'||v_subline_name||
                   '",'||rec.loss_year||',"'||rec.claim_no||'","'||v_policy||'","'||v_assd_name||'",'||rec.incept_date||
                   ','||rec.expiry_date||','||rec.loss_date||',"'||v_item_title||'",'||rec.tsi_amt||',"'||v_peril_name||
       '","'||v_intm_ri||'",'||rec.outstanding_loss;
       
      FOR j IN (SELECT DISTINCT a.share_cd 
                FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
         WHERE a.share_cd IN (1, 999) 
           AND a.share_cd = b.grp_seq_no
           AND b.session_id = p_session_id
           AND (NVL(B.LOSS_RESERVE,0) - NVL(B.LOSSES_PAID,0)) > 0
         ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT (NVL(c.loss_reserve, 0) - NVL(c.LOSSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND (NVL(C.LOSS_RESERVE,0) - NVL(C.LOSSES_PAID,0)) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
        v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;
   
      FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND (NVL(B.LOSS_RESERVE,0) - NVL(B.LOSSES_PAID,0)) > 0
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT c.claim_id, (NVL(c.loss_reserve, 0) - NVL(c.LOSSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
                     AND c.session_id = p_session_id
                     AND (NVL(c.LOSS_RESERVE,0) - NVL(c.LOSSES_PAID,0)) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
        v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;  
      utl_file.put_line(v_file,v_columns);
      v_outstanding := v_outstanding + rec.outstanding_loss;  
    END LOOP;
    v_totals := ',,,,,,,,,,,,,,,TOTAL,'||v_outstanding;
  
    FOR j IN (SELECT DISTINCT a.share_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND b.session_id = p_session_id
                          AND (NVL(B.LOSS_RESERVE,0) - NVL(B.LOSSES_PAID,0)) > 0
                     ORDER BY share_cd) 
    LOOP
      FOR k IN (SELECT SUM((NVL(c.loss_reserve, 0) - NVL(c.LOSSES_PAID, 0))) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND (NVL(C.LOSS_RESERVE,0) - NVL(C.LOSSES_PAID,0)) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
  
    FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd NOT IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND a.line_cd = b.line_cd
                          AND b.session_id = p_session_id
                          AND (NVL(B.LOSS_RESERVE,0) - NVL(B.LOSSES_PAID,0)) > 0
                     ORDER BY line_cd, share_cd) 
    LOOP
      FOR k IN (SELECT SUM((NVL(c.loss_reserve, 0) - NVL(c.LOSSES_PAID, 0))) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND c.line_cd = j.line_cd
                   AND (NVL(C.LOSS_RESERVE,0) - NVL(C.LOSSES_PAID,0)) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
    utl_file.put_line(v_file,v_totals);
    utl_file.fclose(v_file); 
  END;

  ----------------------------------------------------------------------------------------------------

  PROCEDURE CSV_GICLR205LE(p_session_id          VARCHAR2,
                           p_claim_id            VARCHAR2,
                           p_intm_break          NUMBER,
                           p_file_name           VARCHAR2)
  IS
    v_file                UTL_FILE.FILE_TYPE;
    v_columns             VARCHAR2(32767);
    v_headers             VARCHAR2(32767);
    v_totals              VARCHAR2(32767);
    v_loss                NUMBER := 0;
    v_outstanding         NUMBER := 0;
    v_outstanding2        NUMBER := 0;
    v_month_grp           VARCHAR2(100);
    v_source_type_desc    GIIS_INTM_TYPE.INTM_DESC%TYPE;
    v_source_name         GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name            GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name           GIIS_LINE.LINE_NAME%TYPE;
    v_subline_name        GIIS_SUBLINE.SUBLINE_NAME%TYPE;
    v_policy              VARCHAR2(60);
    v_ref_pol_no          GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name           GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title          VARCHAR2(200);
    v_peril_name          GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd          GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri             VARCHAR2(1000);
    
    CURSOR c1 IS SELECT ISS_TYPE, 
                        BUSS_SOURCE_TYPE,
                        ISS_CD,           
                        BUSS_SOURCE,
                        LINE_CD,
                        SUBLINE_CD,
                        LOSS_YEAR,
                        CLAIM_ID,
                        ASSD_NO,
                        CLAIM_NO,
                        POLICY_NO,
                        INCEPT_DATE,
                        EXPIRY_DATE,
                        LOSS_DATE,
                        CLM_FILE_DATE,
                        ITEM_NO,
                        grouped_item_no,
                        PERIL_CD,
                        LOSS_CAT_CD,
                        TSI_AMT,
                        INTM_NO,
                        SUM(OUTSTANDING_LOSS) OUTSTANDING_LOSS,
                        SUM(OUTSTANDING_EXPENSE) OUTSTANDING_EXPENSE
                   FROM (SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                                DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
                                A.ISS_CD,
                                A.BUSS_SOURCE,
                                A.LINE_CD,
                                A.SUBLINE_CD,
                                A.LOSS_YEAR,
                                A.BRDRX_RECORD_ID,
                                A.CLAIM_ID,
                                A.ASSD_NO,
                                A.CLAIM_NO,
                                A.POLICY_NO,
                                A.INCEPT_DATE,
                                A.EXPIRY_DATE,
                                A.LOSS_DATE,
                                A.CLM_FILE_DATE,
                                A.ITEM_NO,
                                A.grouped_item_no,
                                A.PERIL_CD,
                                A.LOSS_CAT_CD,
                                A.TSI_AMT,
                                A.INTM_NO,
                                (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) OUTSTANDING_LOSS,
                                (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_EXPENSE           
                           FROM GICL_RES_BRDRX_EXTR A,
                                GIIS_INTERMEDIARY B
                          WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                            AND A.SESSION_ID = P_SESSION_ID 
                            AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                            AND (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) > 0
                         UNION
                         SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                                DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
                                A.ISS_CD,
                                A.BUSS_SOURCE,
                                A.LINE_CD,
                                A.SUBLINE_CD,
                                A.LOSS_YEAR,
                                A.BRDRX_RECORD_ID,
                                A.CLAIM_ID,
                                A.ASSD_NO,
                                A.CLAIM_NO,
                                A.POLICY_NO,
                                A.INCEPT_DATE,
                                A.EXPIRY_DATE,
                                A.LOSS_DATE,
                                A.CLM_FILE_DATE,
                                A.ITEM_NO,
                                A.grouped_item_no,
                                A.PERIL_CD,
                                A.LOSS_CAT_CD,
                                A.TSI_AMT,
                                A.INTM_NO,
                                (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) OUTSTANDING_LOSS,
                                (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_EXPENSE           
                           FROM GICL_RES_BRDRX_EXTR A,
                                GIIS_INTERMEDIARY B
                          WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                            AND A.SESSION_ID = P_SESSION_ID 
                            AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                            AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0)
                       GROUP BY ISS_TYPE, BUSS_SOURCE_TYPE,ISS_CD, BUSS_SOURCE,
                                LINE_CD, SUBLINE_CD, LOSS_YEAR, CLAIM_ID, ASSD_NO,
                                CLAIM_NO, POLICY_NO, INCEPT_DATE, EXPIRY_DATE,
                                LOSS_DATE, CLM_FILE_DATE, ITEM_NO, grouped_item_no,
                                PERIL_CD, LOSS_CAT_CD, TSI_AMT, INTM_NO;
  BEGIN
     v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
      
     FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR205LE')
    LOOP
      utl_file.put_line(v_file,'"'||i.report_title||'"');
      EXIT;
    END LOOP;
    
    
    FOR i IN (SELECT DISTINCT from_date, to_date,
                     DECODE(ol_date_opt, 1, 'Loss Date', 2, 'Claim File Date', 3, 'Booking Month') opt
                FROM gicl_res_brdrx_extr
               WHERE session_id = p_session_id)
    LOOP
      utl_file.put_line(v_file, '"Based on '||i.opt||'"');
      
      IF i.from_date IS NOT NULL THEN
         utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                                  ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      ELSE
         utl_file.put_line(v_file,'"As of '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      END IF;
      utl_file.put_line(v_file, ' ');
      EXIT;
    END LOOP;
    
      v_headers := 'BUSINESS SOURCE,SOURCE NAME,ISSUE SOURCE,LINE,SUBLINE,'||
                   'LOSS YEAR,CLAIM NUMBER,POLICY NUMBER,ASSURED,INCEPT DATE,EXPIRY DATE,'||
                   'DATE OF LOSS,ITEM,TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY,OUTSTANDING';

      FOR j IN (SELECT DISTINCT a.share_cd, a.trty_name 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                       ORDER BY share_cd) 
      LOOP
        v_headers := v_headers||',"'||j.trty_name||'"';
      END LOOP;

      FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd, a.trty_name 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                       ORDER BY line_cd, share_cd) 
      LOOP
        v_headers := v_headers||',"'||j.trty_name||'"';
      END LOOP;
      utl_file.put_line(v_file,v_headers);     
  
      FOR rec IN c1 
      LOOP 
        BEGIN
          SELECT INTM_DESC
            INTO V_SOURCE_TYPE_DESC
            FROM GIIS_INTM_TYPE
           WHERE INTM_TYPE = rec.BUSS_SOURCE_TYPE;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 V_SOURCE_TYPE_DESC := 'REINSURER ';
            WHEN OTHERS THEN
                 V_SOURCE_TYPE_DESC := NULL;
        END;
    
        IF rec.ISS_TYPE = 'RI' THEN
          BEGIN
            SELECT RI_NAME
              INTO V_SOURCE_NAME
              FROM GIIS_REINSURER
             WHERE RI_CD  = rec.BUSS_SOURCE;
          EXCEPTION
              WHEN OTHERS THEN
                   V_SOURCE_NAME  := NULL;
          END;
        ELSE
          BEGIN
            SELECT INTM_NAME
              INTO V_SOURCE_NAME
              FROM GIIS_INTERMEDIARY
             WHERE INTM_NO  = rec.BUSS_SOURCE;
          EXCEPTION
              WHEN OTHERS THEN
                   V_SOURCE_NAME  := NULL;
          END;
        END IF;
    
        BEGIN
          SELECT ISS_NAME
            INTO V_ISS_NAME
            FROM GIIS_ISSOURCE
           WHERE ISS_CD  = rec.ISS_CD;
        EXCEPTION
            WHEN OTHERS THEN
                 V_ISS_NAME  := NULL;
        END;
    
        BEGIN
          SELECT LINE_NAME
            INTO V_LINE_NAME
            FROM GIIS_LINE
           WHERE LINE_CD     = rec.LINE_CD;
        EXCEPTION
            WHEN OTHERS THEN
                 V_LINE_NAME  := NULL;
        END;
    
        BEGIN
          SELECT SUBLINE_NAME
            INTO V_SUBLINE_NAME
            FROM GIIS_SUBLINE
           WHERE SUBLINE_CD = rec.SUBLINE_CD
             AND LINE_CD    = rec.LINE_CD;
        EXCEPTION
            WHEN OTHERS THEN
                 V_SUBLINE_NAME  := NULL;
        END;
    
        BEGIN
          SELECT b.ref_pol_no
            INTO v_ref_pol_no
            FROM GICL_CLAIMS a, GIPI_POLBASIC b
           WHERE a.line_cd = b.line_cd
             AND a.subline_cd = b.subline_cd
             AND a.pol_iss_cd = b.iss_cd
             AND a.issue_yy = b.issue_yy
             AND a.pol_seq_no = b.pol_seq_no
             AND a.renew_no = b.renew_no
             AND b.endt_seq_no = 0
             AND a.claim_id = rec.claim_id
             AND ref_pol_no IS NOT NULL;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 v_ref_pol_no := NULL;
        END;
    
        IF v_ref_pol_no IS NOT NULL THEN
          v_policy := rec.policy_no||'/'||v_ref_pol_no;
        ELSE
          v_policy := rec.policy_no;
        END IF;

        BEGIN
          SELECT ASSD_NAME
            INTO V_ASSD_NAME
            FROM GIIS_ASSURED
           WHERE ASSD_NO = rec.ASSD_NO;
        EXCEPTION
            WHEN OTHERS THEN
                 V_ASSD_NAME := NULL;
        END;
        
        v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

        BEGIN
          SELECT PERIL_NAME
            INTO V_PERIL_NAME
            FROM GIIS_PERIL
           WHERE PERIL_CD    = rec.PERIL_CD
             AND LINE_CD     = rec.LINE_CD;
        EXCEPTION
            WHEN OTHERS THEN
                 V_PERIL_NAME  := NULL;
        END;

        BEGIN
          SELECT pol_iss_cd
            INTO v_pol_iss_cd
            FROM GICL_CLAIMS
           WHERE claim_id = rec.claim_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 v_pol_iss_cd := NULL;
        END;

        IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
          BEGIN
            FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                        FROM GICL_CLAIMS a, GIIS_REINSURER b
                       WHERE a.ri_cd = b.ri_cd
                         AND a.claim_id = rec.claim_id)
            LOOP
              v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
            END LOOP;
          END;
        ELSE
          IF p_intm_break = 1 THEN
            BEGIN
              FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                               b.ref_intm_cd ref_intm_cd
                          FROM GICL_RES_BRDRX_EXTR a, GIIS_INTERMEDIARY b
                         WHERE a.intm_no = b.intm_no
                           AND a.session_id = p_session_id
                           AND a.claim_id = rec.claim_id
                           AND a.item_no = rec.item_no
                           AND a.peril_cd = rec.peril_cd
                           AND a.intm_no = rec.intm_no)
              LOOP
                v_intm_ri := TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||i.intm_name;
              END LOOP;
            END;
          ELSIF p_intm_break = 0 THEN
            BEGIN
              FOR m IN (SELECT a.intm_no, b.intm_name intm_name, b.ref_intm_cd
                          FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                         WHERE a.intm_no = b.intm_no
                           AND a.claim_id = rec.claim_id
                           AND a.item_no = rec.item_no
                           AND a.peril_cd = rec.peril_cd)
              LOOP
                v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
              END LOOP;
            END;
          END IF;
        END IF;
   
        v_columns := '"'||v_source_type_desc||'","'||v_source_name||'","'||v_iss_name||'","'||v_line_name||
                     '","'||v_subline_name||'",'||rec.loss_year||',"'||rec.claim_no||'","'||v_policy||
                     '","'||v_assd_name||'",'||rec.incept_date||','||rec.expiry_date||','||rec.loss_date||
                     ',"'||v_item_title||'",'||rec.tsi_amt||',"'||v_peril_name||'","'||v_intm_ri||
                     '",'||rec.outstanding_loss;
      
        FOR j IN (SELECT DISTINCT a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND b.session_id = p_session_id
                         ORDER BY share_cd) 
        LOOP
          FOR k IN (SELECT (NVL(c.loss_reserve, 0) - NVL(c.LOSSES_PAID, 0)) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.session_id = p_session_id
                       AND c.grp_seq_no = j.share_cd)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;
   
        FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd NOT IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND a.line_cd = b.line_cd
                              AND b.session_id = p_session_id
                         ORDER BY line_cd, share_cd) 
        LOOP
          FOR k IN (SELECT c.claim_id, (NVL(c.loss_reserve, 0) - NVL(c.LOSSES_PAID, 0)) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.grp_seq_no = j.share_cd
                       AND c.line_cd = j.line_cd
                       AND c.session_id = p_session_id)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;  
        utl_file.put_line(v_file,v_columns);
        v_columns := ',,,,,,,,,,,,,,,,'||rec.outstanding_expense;
 
        FOR j IN (SELECT DISTINCT a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND b.session_id = p_session_id
                         ORDER BY share_cd) 
        LOOP
          FOR k IN (SELECT (NVL(c.expense_reserve, 0) - NVL(c.expenses_paid, 0)) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.session_id = p_session_id
                       AND c.grp_seq_no = j.share_cd)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;
   
        FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd NOT IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND a.line_cd = b.line_cd
                              AND b.session_id = p_session_id
                         ORDER BY line_cd, share_cd) 
        LOOP
          FOR k IN (SELECT c.claim_id, (NVL(c.expense_reserve, 0) - NVL(c.expenses_PAID, 0)) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.grp_seq_no = j.share_cd
                       AND c.line_cd = j.line_cd
                       AND c.session_id = p_session_id)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;
        utl_file.put_line(v_file,v_columns);
        v_outstanding := v_outstanding + rec.outstanding_loss;  
        v_outstanding2 := v_outstanding2 + rec.outstanding_expense; 
      END LOOP;
      v_totals := ',,,,,,,,,,,,,,,TOTAL,'||v_outstanding;
  
      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT SUM((NVL(c.loss_reserve, 0) - NVL(c.LOSSES_PAID, 0))) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
					 AND (NVL(c.loss_reserve, 0) - NVL(c.LOSSES_PAID, 0)) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
  
      FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT SUM((NVL(c.loss_reserve, 0) - NVL(c.LOSSES_PAID, 0))) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
					 AND (NVL(c.loss_reserve, 0) - NVL(c.LOSSES_PAID, 0)) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
      utl_file.put_line(v_file,v_totals);
      v_totals := ',,,,,,,,,,,,,,,TOTAL,'||v_outstanding2;
  
      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT SUM((NVL(c.EXPENSE_reserve, 0) - NVL(c.EXPENSES_PAID, 0))) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
					 AND (NVL(c.expense_reserve, 0) - NVL(c.expenses_paid, 0)) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
  
      FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT SUM((NVL(c.EXPENSE_RESERVE, 0) - NVL(c.EXPENSES_PAID, 0))) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
					 AND (NVL(c.loss_reserve, 0) - NVL(c.LOSSES_PAID, 0)) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
      utl_file.put_line(v_file,v_totals);
      utl_file.fclose(v_file); 
  END;
  
  ----------------------------------------------------------------------------------------------------
  
  PROCEDURE CSV_GICLR206E(p_session_id   VARCHAR2,
               			  p_claim_id     VARCHAR2,
               			  p_intm_break   NUMBER,
      					  p_paid_date    VARCHAR2,
      					  p_from_date    VARCHAR2,
      					  p_to_date      VARCHAR2,
						  p_file_name	 VARCHAR2) 
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_columns           VARCHAR2(32767);
    v_headers           VARCHAR2(32767);
    v_totals            VARCHAR2(32767);
    v_loss              NUMBER := 0;
    v_outstanding       NUMBER := 0;
    v_month_grp         VARCHAR2(100);
    v_source_type_desc  GIIS_INTM_TYPE.INTM_DESC%TYPE;
    v_source_name       GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name         GIIS_LINE.LINE_NAME%TYPE;
    v_subline_name      GIIS_SUBLINE.SUBLINE_NAME%TYPE;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(1000);
	var_dv_no        	VARCHAR2(2000):=' ';
 	v_dv_no          	VARCHAR2(500):=' ';
  
    CURSOR c1 IS SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
     				A.ISS_CD,
     				A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
     				A.BRDRX_RECORD_ID,
               		A.CLAIM_ID,
               		A.ASSD_NO,
               		A.CLAIM_NO,
               		A.POLICY_NO,
               		A.INCEPT_DATE,
               		A.EXPIRY_DATE,
               		A.LOSS_DATE,
               		A.CLM_FILE_DATE, 
               		A.ITEM_NO,
               		A.GROUPED_ITEM_NO, 
               		A.PERIL_CD,
               		A.LOSS_CAT_CD,
               		A.TSI_AMT,
               		A.INTM_NO,
               		A.CLM_LOSS_ID,
               		NVL(A.EXPENSES_PAID,0) LOSSES_PAID
         	   FROM GICL_RES_BRDRX_EXTR A,
               		GIIS_INTERMEDIARY B
        	  WHERE A.BUSS_SOURCE = B.INTM_NO(+)
       		  	AND A.SESSION_ID = P_SESSION_ID 
         		AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
        		AND NVL(A.EXPENSES_PAID,0) <> 0;
  BEGIN
    v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
    
    FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR206E')
    LOOP
      utl_file.put_line(v_file,'"'||i.report_title||'"');
      EXIT;
    END LOOP;
    
    
    FOR i IN (SELECT DISTINCT from_date, to_date,
                     DECODE(pd_date_opt, 1, 'Transaction Date', 2, 'Posting Date') opt
                FROM gicl_res_brdrx_extr
               WHERE session_id = p_session_id)
    LOOP
      utl_file.put_line(v_file, '"Based on '||i.opt||'"');
      utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                               ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      utl_file.put_line(v_file, ' ');
      EXIT;
    END LOOP;
    
    v_headers := 'BUSINESS SOURCE,SOURCE NAME,ISSUE SOURCE,LINE,SUBLINE,'||
                 'LOSS YEAR,CLAIM NUMBER,POLICY NUMBER,ASSURED,INCEPT DATE,EXPIRY DATE,'||
                 'DATE OF LOSS,ITEM,TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY,VOUCHER NUMBER, EXPENSES PAID';
    
 FOR j IN (SELECT DISTINCT A.SHARE_CD, A.TRTY_NAME 
                         FROM GIIS_DIST_SHARE A, GICL_RES_BRDRX_DS_EXTR B 
                        WHERE A.SHARE_CD IN (1, 999) 
                          AND A.SHARE_CD = B.GRP_SEQ_NO
                          AND B.SESSION_ID = p_session_id
                          AND NVL(B.EXPENSES_PAID,0) > 0
                        ORDER BY SHARE_CD) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;

    FOR j IN (SELECT DISTINCT A.LINE_CD, A.SHARE_CD, A.TRTY_NAME 
                         FROM GIIS_DIST_SHARE A, GICL_RES_BRDRX_DS_EXTR B 
                        WHERE A.SHARE_CD NOT IN (1, 999) 
                          AND A.SHARE_CD = B.GRP_SEQ_NO
                          AND A.LINE_CD = B.LINE_CD
                          AND B.SESSION_ID = p_session_id
                          AND NVL(B.EXPENSES_PAID,0) > 0
                     ORDER BY LINE_CD, SHARE_CD) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;
 
    utl_file.put_line(v_file,v_headers);     
  
    FOR rec IN c1 
    LOOP 
    BEGIN
       SELECT INTM_DESC
         INTO V_SOURCE_TYPE_DESC
         FROM GIIS_INTM_TYPE
        WHERE INTM_TYPE = rec.BUSS_SOURCE_TYPE;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
              V_SOURCE_TYPE_DESC := 'REINSURER ';
         WHEN OTHERS THEN
              V_SOURCE_TYPE_DESC := NULL;
    END;

    IF rec.ISS_TYPE = 'RI' THEN
      BEGIN
         SELECT RI_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_REINSURER
          WHERE RI_CD  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    ELSE
      BEGIN
         SELECT INTM_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_INTERMEDIARY
          WHERE INTM_NO  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    END IF;

    BEGIN
       SELECT ISS_NAME
         INTO V_ISS_NAME
         FROM GIIS_ISSOURCE
        WHERE ISS_CD  = rec.ISS_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_ISS_NAME  := NULL;
    END;

    BEGIN
       SELECT LINE_NAME
         INTO V_LINE_NAME
         FROM GIIS_LINE
        WHERE LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_LINE_NAME  := NULL;
    END;

    BEGIN
       SELECT SUBLINE_NAME
         INTO V_SUBLINE_NAME
         FROM GIIS_SUBLINE
        WHERE SUBLINE_CD = rec.SUBLINE_CD
          AND LINE_CD    = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_SUBLINE_NAME  := NULL;
    END;

    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
         END LOOP;
       END;
    ELSE
      IF p_intm_break = 1 THEN
         BEGIN
           FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                            b.ref_intm_cd ref_intm_cd
                       FROM GICL_RES_BRDRX_EXTR a, GIIS_INTERMEDIARY b
                      WHERE a.intm_no = b.intm_no
                        AND a.session_id = p_session_id
                        AND a.claim_id = rec.claim_id
                        AND a.item_no = rec.item_no
                        AND a.peril_cd = rec.peril_cd
                        AND a.intm_no = rec.intm_no)
           LOOP
             v_intm_ri := TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;
           END LOOP;
         END;
      ELSIF p_intm_break = 0 THEN
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
           END LOOP;
         END;
      END IF;
    END IF;
     
    IF SIGN(rec.losses_paid) < 1 THEN   
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))||
                                  ' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b, 
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id 
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.expenses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;   
         END IF;
       END LOOP;
    ELSE 
    FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                              LTRIM(TO_CHAR(b.dv_no,'0999999999')) 
                              ||' /'||e.check_no dv_no
                FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                     giac_direct_claim_payts c, giac_acctrans d,
                     giac_chk_disbursement e
               WHERE a.tran_id    = d.tran_id    
                 AND b.gacc_tran_id = c.gacc_tran_id
                 AND b.gacc_tran_id = d.tran_id
                 AND b.gacc_tran_id = e.gacc_tran_id
                 AND e.item_no   = rec.item_no
                 AND a.claim_id    = rec.claim_id 
                 AND a.clm_loss_id  = rec.clm_loss_id
                 AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                     BETWEEN p_from_date AND p_to_date
               GROUP BY b.dv_pref, b.dv_no, e.check_no
              HAVING SUM(NVL(a.expenses_paid,0)) > 0)    
    LOOP
      v_dv_no := v2.dv_no;
      IF var_dv_no IS NULL THEN
         var_dv_no := v_dv_no;
      ELSE
         var_dv_no := v_dv_no;   
      END IF;
    END LOOP;      
    END IF;
   
      v_columns := '"'||v_source_type_desc||'","'||v_source_name||'","'||v_iss_name||'","'||v_line_name||'","'||v_subline_name||
                   '",'||rec.loss_year||',"'||rec.claim_no||'","'||v_policy||'","'||v_assd_name||'",'||rec.incept_date||
       ','||rec.expiry_date||','||rec.loss_date||',"'||v_item_title||'",'||rec.tsi_amt||',"'||v_peril_name||
       '","'||v_intm_ri||'",'||var_dv_no||','||rec.losses_paid;

      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                            AND NVL(B.EXPENSES_PAID,0) > 0
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT NVL(c.expenses_paid, 0) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND NVL(C.EXPENSES_PAID,0) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
  		v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;
    
      FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND NVL(B.EXPENSES_PAID,0) > 0
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT NVL(c.EXPENSES_PAID, 0) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
                     AND c.session_id = p_session_id
                     AND NVL(c.EXPENSES_PAID,0) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
        v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;  
     utl_file.put_line(v_file,v_columns);
   v_outstanding := v_outstanding + rec.losses_paid;  
    END LOOP;
  
    v_totals := ',,,,,,,,,,,,,,,,TOTAL,'||v_outstanding;
    FOR j IN (SELECT DISTINCT a.share_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND b.session_id = p_session_id
                          AND NVL(B.EXPENSES_PAID,0) > 0
                     ORDER BY share_cd) 
    LOOP
      FOR k IN (SELECT SUM(NVL(c.EXPENSES_PAID, 0)) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND NVL(C.EXPENSES_PAID,0) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
  
    FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd NOT IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND a.line_cd = b.line_cd
                          AND b.session_id = p_session_id
                          AND NVL(B.EXPENSES_PAID,0) > 0
                     ORDER BY line_cd, share_cd) 
    LOOP
      FOR k IN (SELECT SUM(NVL(c.expenses_paid, 0)) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND c.line_cd = j.line_cd
                   AND NVL(C.EXPENSES_PAID,0) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
    utl_file.put_line(v_file,v_totals);
    utl_file.fclose(v_file); 
  END;

    ----------------------------------------------------------------------------------------------------
  
  PROCEDURE CSV_GICLR206L(p_session_id   VARCHAR2,
               			  p_claim_id     VARCHAR2,
               			  p_intm_break   NUMBER,
      					  p_paid_date    VARCHAR2,
      					  p_from_date    VARCHAR2,
      					  p_to_date      VARCHAR2,
						  p_file_name	 VARCHAR2) 
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_columns           VARCHAR2(32767);
    v_headers           VARCHAR2(32767);
    v_totals            VARCHAR2(32767);
    v_loss              NUMBER := 0;
    v_outstanding       NUMBER := 0;
    v_month_grp         VARCHAR2(100);
    v_source_type_desc  GIIS_INTM_TYPE.INTM_DESC%TYPE;
    v_source_name       GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name         GIIS_LINE.LINE_NAME%TYPE;
    v_subline_name      GIIS_SUBLINE.SUBLINE_NAME%TYPE;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(1000);
	var_dv_no        	VARCHAR2(2000):=' ';
 	v_dv_no          	VARCHAR2(500):=' ';
  
    CURSOR c1 IS SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
     				A.ISS_CD,
     				A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
     				A.BRDRX_RECORD_ID,
               		A.CLAIM_ID,
               		A.ASSD_NO,
               		A.CLAIM_NO,
               		A.POLICY_NO,
               		A.INCEPT_DATE,
               		A.EXPIRY_DATE,
               		A.LOSS_DATE,
               		A.CLM_FILE_DATE, 
               		A.ITEM_NO,
               		A.GROUPED_ITEM_NO, 
               		A.PERIL_CD,
               		A.LOSS_CAT_CD,
               		A.TSI_AMT,
               		A.INTM_NO,
               		A.CLM_LOSS_ID,
               		NVL(A.LOSSES_PAID,0) LOSSES_PAID
         	   FROM GICL_RES_BRDRX_EXTR A,
               		GIIS_INTERMEDIARY B
        	  WHERE A.BUSS_SOURCE = B.INTM_NO(+)
       		  	AND A.SESSION_ID = P_SESSION_ID 
         		AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
        		AND NVL(A.LOSSES_PAID,0) <> 0;
  BEGIN
    v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
    
    FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR206L')
    LOOP
      utl_file.put_line(v_file,'"'||i.report_title||'"');
      EXIT;
    END LOOP;
    
    
    FOR i IN (SELECT DISTINCT from_date, to_date,
                     DECODE(pd_date_opt, 1, 'Transaction Date', 2, 'Posting Date') opt
                FROM gicl_res_brdrx_extr
               WHERE session_id = p_session_id)
    LOOP
      utl_file.put_line(v_file, '"Based on '||i.opt||'"');
      utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                               ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      utl_file.put_line(v_file, ' ');
      EXIT;
    END LOOP;
    
    v_headers := 'BUSINESS SOURCE,SOURCE NAME,ISSUE SOURCE,LINE,SUBLINE,'||
                 'LOSS YEAR,CLAIM NUMBER,POLICY NUMBER,ASSURED,INCEPT DATE,EXPIRY DATE,'||
                 'DATE OF LOSS,ITEM,TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY,VOUCHER NUMBER, LOSSES PAID';
    
 FOR j IN (SELECT DISTINCT A.SHARE_CD, A.TRTY_NAME 
                         FROM GIIS_DIST_SHARE A, GICL_RES_BRDRX_DS_EXTR B 
                        WHERE A.SHARE_CD IN (1, 999) 
                          AND A.SHARE_CD = B.GRP_SEQ_NO
                          AND B.SESSION_ID = p_session_id
                          AND NVL(B.LOSSES_PAID,0) > 0
                        ORDER BY SHARE_CD) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;

    FOR j IN (SELECT DISTINCT A.LINE_CD, A.SHARE_CD, A.TRTY_NAME 
                         FROM GIIS_DIST_SHARE A, GICL_RES_BRDRX_DS_EXTR B 
                        WHERE A.SHARE_CD NOT IN (1, 999) 
                          AND A.SHARE_CD = B.GRP_SEQ_NO
                          AND A.LINE_CD = B.LINE_CD
                          AND B.SESSION_ID = p_session_id
                          AND NVL(B.LOSSES_PAID,0) > 0
                     ORDER BY LINE_CD, SHARE_CD) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;
 
    utl_file.put_line(v_file,v_headers);     
  
    FOR rec IN c1 
    LOOP 
    BEGIN
       SELECT INTM_DESC
         INTO V_SOURCE_TYPE_DESC
         FROM GIIS_INTM_TYPE
        WHERE INTM_TYPE = rec.BUSS_SOURCE_TYPE;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
              V_SOURCE_TYPE_DESC := 'REINSURER ';
         WHEN OTHERS THEN
              V_SOURCE_TYPE_DESC := NULL;
    END;

    IF rec.ISS_TYPE = 'RI' THEN
      BEGIN
         SELECT RI_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_REINSURER
          WHERE RI_CD  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    ELSE
      BEGIN
         SELECT INTM_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_INTERMEDIARY
          WHERE INTM_NO  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    END IF;

    BEGIN
       SELECT ISS_NAME
         INTO V_ISS_NAME
         FROM GIIS_ISSOURCE
        WHERE ISS_CD  = rec.ISS_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_ISS_NAME  := NULL;
    END;

    BEGIN
       SELECT LINE_NAME
         INTO V_LINE_NAME
         FROM GIIS_LINE
        WHERE LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_LINE_NAME  := NULL;
    END;

    BEGIN
       SELECT SUBLINE_NAME
         INTO V_SUBLINE_NAME
         FROM GIIS_SUBLINE
        WHERE SUBLINE_CD = rec.SUBLINE_CD
          AND LINE_CD    = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_SUBLINE_NAME  := NULL;
    END;

    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
         END LOOP;
       END;
    ELSE
      IF p_intm_break = 1 THEN
         BEGIN
           FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                            b.ref_intm_cd ref_intm_cd
                       FROM GICL_RES_BRDRX_EXTR a, GIIS_INTERMEDIARY b
                      WHERE a.intm_no = b.intm_no
                        AND a.session_id = p_session_id
                        AND a.claim_id = rec.claim_id
                        AND a.item_no = rec.item_no
                        AND a.peril_cd = rec.peril_cd
                        AND a.intm_no = rec.intm_no)
           LOOP
             v_intm_ri := TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;
           END LOOP;
         END;
      ELSIF p_intm_break = 0 THEN
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
           END LOOP;
         END;
      END IF;
    END IF;
     
    IF SIGN(rec.losses_paid) < 1 THEN   
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))||
                                  ' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b, 
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id 
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.losses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;   
         END IF;
       END LOOP;
    ELSE 
    FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                              LTRIM(TO_CHAR(b.dv_no,'0999999999')) 
                              ||' /'||e.check_no dv_no
                FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                     giac_direct_claim_payts c, giac_acctrans d,
                     giac_chk_disbursement e
               WHERE a.tran_id    = d.tran_id    
                 AND b.gacc_tran_id = c.gacc_tran_id
                 AND b.gacc_tran_id = d.tran_id
                 AND b.gacc_tran_id = e.gacc_tran_id
                 AND e.item_no   = rec.item_no
                 AND a.claim_id    = rec.claim_id 
                 AND a.clm_loss_id  = rec.clm_loss_id
                 AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                     BETWEEN p_from_date AND p_to_date
               GROUP BY b.dv_pref, b.dv_no, e.check_no
              HAVING SUM(NVL(a.losses_paid,0)) > 0)    
    LOOP
      v_dv_no := v2.dv_no;
      IF var_dv_no IS NULL THEN
         var_dv_no := v_dv_no;
      ELSE
         var_dv_no := v_dv_no;   
      END IF;
    END LOOP;      
    END IF;
   
      v_columns := '"'||v_source_type_desc||'","'||v_source_name||'","'||v_iss_name||'","'||v_line_name||'","'||v_subline_name||
                   '",'||rec.loss_year||',"'||rec.claim_no||'","'||v_policy||'","'||v_assd_name||'",'||rec.incept_date||
       ','||rec.expiry_date||','||rec.loss_date||',"'||v_item_title||'",'||rec.tsi_amt||',"'||v_peril_name||
       '","'||v_intm_ri||'",'||var_dv_no||','||rec.losses_paid;

      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                            AND NVL(B.LOSSES_PAID,0) > 0
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT NVL(c.LOSSES_paid, 0) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND NVL(C.LOSSES_PAID,0) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
  		v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;
    
      FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND NVL(B.LOSSES_PAID,0) > 0
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT NVL(c.LOSSES_PAID, 0) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
                     AND c.session_id = p_session_id
                     AND NVL(c.LOSSES_PAID,0) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
        v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;  
     utl_file.put_line(v_file,v_columns);
   v_outstanding := v_outstanding + rec.losses_paid;  
    END LOOP;
  
    v_totals := ',,,,,,,,,,,,,,,,TOTAL,'||v_outstanding;
    FOR j IN (SELECT DISTINCT a.share_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND b.session_id = p_session_id
                          AND NVL(B.LOSSES_PAID,0) > 0
                     ORDER BY share_cd) 
    LOOP
      FOR k IN (SELECT SUM(NVL(c.LOSSES_PAID, 0)) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND NVL(C.LOSSES_PAID,0) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
  
    FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd NOT IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND a.line_cd = b.line_cd
                          AND b.session_id = p_session_id
                          AND NVL(B.LOSSES_PAID,0) > 0
                     ORDER BY line_cd, share_cd) 
    LOOP
      FOR k IN (SELECT SUM(NVL(c.LOSSES_paid, 0)) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND c.line_cd = j.line_cd
                   AND NVL(C.LOSSES_PAID,0) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
    utl_file.put_line(v_file,v_totals);
    utl_file.fclose(v_file); 
  END;
  
  ----------------------------------------------------------------------------------------------------

  PROCEDURE CSV_GICLR206LE(p_session_id   VARCHAR2,
               			   p_claim_id     VARCHAR2,
               			   p_intm_break   NUMBER,
      					   p_paid_date    VARCHAR2,
      					   p_from_date    VARCHAR2,
      					   p_to_date      VARCHAR2,
						   p_file_name	 VARCHAR2)
  IS
    v_file                UTL_FILE.FILE_TYPE;
    v_columns             VARCHAR2(32767);
    v_headers             VARCHAR2(32767);
    v_totals              VARCHAR2(32767);
    v_loss                NUMBER := 0;
    v_outstanding         NUMBER := 0;
    v_outstanding2        NUMBER := 0;
    v_month_grp         VARCHAR2(100);
    v_source_type_desc  GIIS_INTM_TYPE.INTM_DESC%TYPE;
    v_source_name       GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name         GIIS_LINE.LINE_NAME%TYPE;
    v_subline_name      GIIS_SUBLINE.SUBLINE_NAME%TYPE;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(1000);
	var_dv_no        	VARCHAR2(2000):=' ';
 	v_dv_no          	VARCHAR2(500):=' ';
    
    CURSOR c1 IS SELECT ISS_TYPE, 
                        BUSS_SOURCE_TYPE,
                        ISS_CD,           
                        BUSS_SOURCE,
                        LINE_CD,
                        SUBLINE_CD,
                        LOSS_YEAR,
                        CLAIM_ID,
                        ASSD_NO,
                        CLAIM_NO,
                        POLICY_NO,
                        INCEPT_DATE,
                        EXPIRY_DATE,
                        LOSS_DATE,
                        CLM_FILE_DATE,
                        ITEM_NO,
                        grouped_item_no,
                        PERIL_CD,
                        LOSS_CAT_CD,
                        TSI_AMT,
                        INTM_NO,
						CLM_LOSS_ID,
                        SUM(LOSSES_PAID) LOSSES_PAID,
                        SUM(EXPENSES_PAID) EXPENSES_PAID
                   FROM (SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                                DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
                                A.ISS_CD,
                                A.BUSS_SOURCE,
                                A.LINE_CD,
                                A.SUBLINE_CD,
                                A.LOSS_YEAR,
                                A.BRDRX_RECORD_ID,
                                A.CLAIM_ID,
                                A.ASSD_NO,
                                A.CLAIM_NO,
                                A.POLICY_NO,
                                A.INCEPT_DATE,
                                A.EXPIRY_DATE,
                                A.LOSS_DATE,
                                A.CLM_FILE_DATE,
                                A.ITEM_NO,
                                A.grouped_item_no,
                                A.PERIL_CD,
                                A.LOSS_CAT_CD,
                                A.TSI_AMT,
                                A.INTM_NO,
								A.CLM_LOSS_ID,
                                NVL(A.LOSSES_PAID,0) LOSSES_PAID,
                                NVL(A.EXPENSES_PAID,0) EXPENSES_PAID           
                           FROM GICL_RES_BRDRX_EXTR A,
                                GIIS_INTERMEDIARY B
                          WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                            AND A.SESSION_ID = P_SESSION_ID 
                            AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                            AND NVL(A.LOSSES_PAID,0) > 0
                         UNION
                         SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                                DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
                                A.ISS_CD,
                                A.BUSS_SOURCE,
                                A.LINE_CD,
                                A.SUBLINE_CD,
                                A.LOSS_YEAR,
                                A.BRDRX_RECORD_ID,
                                A.CLAIM_ID,
                                A.ASSD_NO,
                                A.CLAIM_NO,
                                A.POLICY_NO,
                                A.INCEPT_DATE,
                                A.EXPIRY_DATE,
                                A.LOSS_DATE,
                                A.CLM_FILE_DATE,
                                A.ITEM_NO,
                                A.grouped_item_no,
                                A.PERIL_CD,
                                A.LOSS_CAT_CD,
                                A.TSI_AMT,
                                A.INTM_NO,
								A.CLM_LOSS_ID,
                                NVL(A.LOSSES_PAID,0) LOSSES_PAID,
                                NVL(A.EXPENSES_PAID,0) EXPENSES_PAID           
                           FROM GICL_RES_BRDRX_EXTR A,
                                GIIS_INTERMEDIARY B
                          WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                            AND A.SESSION_ID = P_SESSION_ID 
                            AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                            AND NVL(A.EXPENSES_PAID,0) > 0)
                       GROUP BY ISS_TYPE, BUSS_SOURCE_TYPE,ISS_CD, BUSS_SOURCE,
                                LINE_CD, SUBLINE_CD, LOSS_YEAR, CLAIM_ID, ASSD_NO,
                                CLAIM_NO, POLICY_NO, INCEPT_DATE, EXPIRY_DATE,
                                LOSS_DATE, CLM_FILE_DATE, ITEM_NO, grouped_item_no,
                                PERIL_CD, LOSS_CAT_CD, TSI_AMT, INTM_NO, CLM_LOSS_ID;
   BEGIN
      v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
      
      FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR206LE')
    LOOP
      utl_file.put_line(v_file,'"'||i.report_title||'"');
      EXIT;
    END LOOP;
    
    
    FOR i IN (SELECT DISTINCT from_date, to_date,
                     DECODE(pd_date_opt, 1, 'Transaction Date', 2, 'Posting Date') opt
                FROM gicl_res_brdrx_extr
               WHERE session_id = p_session_id)
    LOOP
      utl_file.put_line(v_file, '"Based on '||i.opt||'"');
      utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                               ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      utl_file.put_line(v_file, ' ');
      EXIT;
    END LOOP;
    
      v_headers := 'BUSINESS SOURCE,SOURCE NAME,ISSUE SOURCE,LINE,SUBLINE,'||
                   'LOSS YEAR,CLAIM NUMBER,POLICY NUMBER,ASSURED,INCEPT DATE,EXPIRY DATE,'||
                   'DATE OF LOSS,ITEM,TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY,VOUCHER NUMBER, LOSSES PAID';

      FOR j IN (SELECT DISTINCT a.share_cd, a.trty_name 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                       ORDER BY share_cd) 
      LOOP
        v_headers := v_headers||',"'||j.trty_name||'"';
      END LOOP;

      FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd, a.trty_name 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                       ORDER BY line_cd, share_cd) 
      LOOP
        v_headers := v_headers||',"'||j.trty_name||'"';
      END LOOP;
      utl_file.put_line(v_file,v_headers);     
  
      FOR rec IN c1 
      LOOP 
        BEGIN
       SELECT INTM_DESC
         INTO V_SOURCE_TYPE_DESC
         FROM GIIS_INTM_TYPE
        WHERE INTM_TYPE = rec.BUSS_SOURCE_TYPE;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
              V_SOURCE_TYPE_DESC := 'REINSURER ';
         WHEN OTHERS THEN
              V_SOURCE_TYPE_DESC := NULL;
    END;
    IF rec.ISS_TYPE = 'RI' THEN
      BEGIN
         SELECT RI_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_REINSURER
          WHERE RI_CD  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    ELSE
      BEGIN
         SELECT INTM_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_INTERMEDIARY
          WHERE INTM_NO  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    END IF;
    BEGIN
       SELECT ISS_NAME
         INTO V_ISS_NAME
         FROM GIIS_ISSOURCE
        WHERE ISS_CD  = rec.ISS_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_ISS_NAME  := NULL;
    END;
    BEGIN
       SELECT LINE_NAME
         INTO V_LINE_NAME
         FROM GIIS_LINE
        WHERE LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_LINE_NAME  := NULL;
    END;
    BEGIN
       SELECT SUBLINE_NAME
         INTO V_SUBLINE_NAME
         FROM GIIS_SUBLINE
        WHERE SUBLINE_CD = rec.SUBLINE_CD
          AND LINE_CD    = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_SUBLINE_NAME  := NULL;
    END;
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;
    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;
    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
         END LOOP;
       END;
    ELSE
      IF p_intm_break = 1 THEN
         BEGIN
           FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                            b.ref_intm_cd ref_intm_cd
                       FROM GICL_RES_BRDRX_EXTR a, GIIS_INTERMEDIARY b
                      WHERE a.intm_no = b.intm_no
                        AND a.session_id = p_session_id
                        AND a.claim_id = rec.claim_id
                        AND a.item_no = rec.item_no
                        AND a.peril_cd = rec.peril_cd
                        AND a.intm_no = rec.intm_no)
           LOOP
             v_intm_ri := TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;
           END LOOP;
         END;
      ELSIF p_intm_break = 0 THEN
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
           END LOOP;
         END;
      END IF;
    END IF; 
    IF SIGN(rec.losses_paid) < 1 THEN   
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))||
                                  ' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b, 
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id 
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.expenses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;   
         END IF;
       END LOOP;
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999')) 
                                  ||' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b, 
                         giac_acctrans c, giac_reversals d, 
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id 
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.losses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;   
         END IF;
       END LOOP;
    ELSE 
       FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                              LTRIM(TO_CHAR(b.dv_no,'0999999999')) 
                              ||' /'||e.check_no dv_no
                FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                     giac_direct_claim_payts c, giac_acctrans d,
                     giac_chk_disbursement e
               WHERE a.tran_id    = d.tran_id    
                 AND b.gacc_tran_id = c.gacc_tran_id
                 AND b.gacc_tran_id = d.tran_id
                 AND b.gacc_tran_id = e.gacc_tran_id
                 AND e.item_no   = rec.item_no
                 AND a.claim_id    = rec.claim_id 
                 AND a.clm_loss_id  = rec.clm_loss_id
                 AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                     BETWEEN p_from_date AND p_to_date
               GROUP BY b.dv_pref, b.dv_no, e.check_no
              HAVING SUM(NVL(a.expenses_paid,0)) > 0)    
        LOOP
          v_dv_no := v2.dv_no;
          IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
          ELSE
            var_dv_no := v_dv_no;   
          END IF;
        END LOOP; 
        FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                               LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                               ||' /'||e.check_no dv_no
                 FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                      giac_direct_claim_payts c, giac_acctrans d,
                      giac_chk_disbursement e
                WHERE a.tran_id = d.tran_id    
                  AND b.gacc_tran_id = c.gacc_tran_id
                  AND b.gacc_tran_id = d.tran_id
                  AND b.gacc_tran_id = e.gacc_tran_id
                  AND a.claim_id    = rec.claim_id 
                  AND a.clm_loss_id  = rec.clm_loss_id
                  AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                      BETWEEN p_from_date AND p_to_date
                GROUP BY b.dv_pref, b.dv_no, e.check_no
               HAVING SUM(NVL(a.losses_paid,0)) > 0)    
        LOOP
          v_dv_no := v2.dv_no;
          IF var_dv_no IS NULL THEN
             var_dv_no := v_dv_no;
          ELSE
             var_dv_no := v_dv_no;   
          END IF;
        END LOOP;     
    END IF;
        v_columns := '"'||v_source_type_desc||'","'||v_source_name||'","'||v_iss_name||'","'||v_line_name||
                     '","'||v_subline_name||'",'||rec.loss_year||',"'||rec.claim_no||'","'||v_policy||
                     '","'||v_assd_name||'",'||rec.incept_date||','||rec.expiry_date||','||rec.loss_date||
                     ',"'||v_item_title||'",'||rec.tsi_amt||',"'||v_peril_name||'","'||v_intm_ri||'",'||var_dv_no||
                     ','||rec.losses_paid;
      
        FOR j IN (SELECT DISTINCT a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND b.session_id = p_session_id
                         ORDER BY share_cd) 
        LOOP
          FOR k IN (SELECT NVL(c.LOSSES_PAID, 0) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.session_id = p_session_id
                       AND c.grp_seq_no = j.share_cd)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;
   
        FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd NOT IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND a.line_cd = b.line_cd
                              AND b.session_id = p_session_id
                         ORDER BY line_cd, share_cd) 
        LOOP
          FOR k IN (SELECT NVL(c.LOSSES_PAID, 0) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.grp_seq_no = j.share_cd
                       AND c.line_cd = j.line_cd
                       AND c.session_id = p_session_id)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;  
        utl_file.put_line(v_file,v_columns);
        v_columns := ',,,,,,,,,,,,,,,,,'||rec.expenses_paid;
 
        FOR j IN (SELECT DISTINCT a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND b.session_id = p_session_id
                         ORDER BY share_cd) 
        LOOP
          FOR k IN (SELECT NVL(c.expenses_paid, 0) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.session_id = p_session_id
                       AND c.grp_seq_no = j.share_cd)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;
   
        FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd NOT IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND a.line_cd = b.line_cd
                              AND b.session_id = p_session_id
                         ORDER BY line_cd, share_cd) 
        LOOP
          FOR k IN (SELECT NVL(c.expenses_PAID, 0) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.grp_seq_no = j.share_cd
                       AND c.line_cd = j.line_cd
                       AND c.session_id = p_session_id)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;
        utl_file.put_line(v_file,v_columns);
        v_outstanding := v_outstanding + rec.losses_paid;  
        v_outstanding2 := v_outstanding2 + rec.expenses_paid; 
      END LOOP;
      v_totals := ',,,,,,,,,,,,,,,,TOTAL,'||v_outstanding;
  
      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT SUM(NVL(c.LOSSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
					 AND NVL(C.LOSSES_PAID, 0) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
  
      FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT SUM(NVL(c.LOSSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
					 AND NVL(C.LOSSES_PAID, 0) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
      utl_file.put_line(v_file,v_totals);
      v_totals := ',,,,,,,,,,,,,,,,TOTAL,'||v_outstanding2;
  
      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT SUM(NVL(c.EXPENSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
					 AND NVL(C.EXPENSES_PAID, 0) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
  
      FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT SUM(NVL(c.EXPENSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
					 AND NVL(C.EXPENSES_PAID, 0) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
      utl_file.put_line(v_file,v_totals);
      utl_file.fclose(v_file); 
  END;
  
  ----------------------------------------------------------------------------------------------------
    
  PROCEDURE CSV_GICLR222L(p_session_id   VARCHAR2,
               			  p_claim_id     VARCHAR2,
      					  p_paid_date    VARCHAR2,
      					  p_from_date    VARCHAR2,
      					  p_to_date      VARCHAR2,
						  p_file_name	 VARCHAR2) 
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_columns           VARCHAR2(32767);
    v_headers           VARCHAR2(32767);
    v_totals            VARCHAR2(32767);
    v_loss              NUMBER := 0;
    v_outstanding       NUMBER := 0;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(1000);
	var_dv_no        	VARCHAR2(2000):=' ';
 	v_dv_no          	VARCHAR2(500):=' ';
  
    CURSOR c1 IS SELECT DISTINCT A.BRDRX_RECORD_ID,
               		A.CLAIM_ID,
                    A.LINE_CD,
               		A.ASSD_NO,
               		A.CLAIM_NO,
               		A.POLICY_NO,
               		A.INCEPT_DATE,
               		A.EXPIRY_DATE,
               		A.LOSS_DATE,
               		A.CLM_FILE_DATE, 
               		A.ITEM_NO,
               		A.GROUPED_ITEM_NO, 
               		A.PERIL_CD,
               		A.LOSS_CAT_CD,
               		A.TSI_AMT,
               		A.INTM_NO,
               		A.CLM_LOSS_ID,
               		NVL(A.LOSSES_PAID,0) LOSSES_PAID
         	   FROM GICL_RES_BRDRX_EXTR A
        	  WHERE A.SESSION_ID = P_SESSION_ID 
         		AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
        		AND NVL(A.LOSSES_PAID,0) <> 0;
  BEGIN
    v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
    
    FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR222L')
    LOOP
      utl_file.put_line(v_file,'"'||i.report_title||'"');
      EXIT;
    END LOOP;
    
    
    FOR i IN (SELECT DISTINCT from_date, to_date,
                     DECODE(pd_date_opt, 1, 'Transaction Date', 2, 'Posting Date') opt
                FROM gicl_res_brdrx_extr
               WHERE session_id = p_session_id)
    LOOP
      utl_file.put_line(v_file, '"Based on '||i.opt||'"');
      utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                               ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      utl_file.put_line(v_file, ' ');
      EXIT;
    END LOOP;
    
    v_headers := 'POLICY NUMBER,ASSURED,INCEPT DATE,EXPIRY DATE,'||
                 'CLAIM NUMBER,DATE OF LOSS,ITEM,TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY,VOUCHER NUMBER, LOSSES PAID';
    
 FOR j IN (SELECT DISTINCT A.SHARE_CD, A.TRTY_NAME 
                         FROM GIIS_DIST_SHARE A, GICL_RES_BRDRX_DS_EXTR B 
                        WHERE A.SHARE_CD IN (1, 999) 
                          AND A.SHARE_CD = B.GRP_SEQ_NO
                          AND B.SESSION_ID = p_session_id
                          AND NVL(B.LOSSES_PAID,0) > 0
                        ORDER BY SHARE_CD) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;

    FOR j IN (SELECT DISTINCT A.LINE_CD, A.SHARE_CD, A.TRTY_NAME 
                         FROM GIIS_DIST_SHARE A, GICL_RES_BRDRX_DS_EXTR B 
                        WHERE A.SHARE_CD NOT IN (1, 999) 
                          AND A.SHARE_CD = B.GRP_SEQ_NO
                          AND A.LINE_CD = B.LINE_CD
                          AND B.SESSION_ID = p_session_id
                          AND NVL(B.LOSSES_PAID,0) > 0
                     ORDER BY LINE_CD, SHARE_CD) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;
 
    utl_file.put_line(v_file,v_headers);     
  
    FOR rec IN c1 
    LOOP 
    
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
         END LOOP;
       END;
    ELSE
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
           END LOOP;
         END;
    END IF;
     
    IF SIGN(rec.losses_paid) < 1 THEN   
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))||
                                  ' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b, 
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id 
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.losses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;   
         END IF;
       END LOOP;
    ELSE 
    FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                              LTRIM(TO_CHAR(b.dv_no,'0999999999')) 
                              ||' /'||e.check_no dv_no
                FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                     giac_direct_claim_payts c, giac_acctrans d,
                     giac_chk_disbursement e
               WHERE a.tran_id    = d.tran_id    
                 AND b.gacc_tran_id = c.gacc_tran_id
                 AND b.gacc_tran_id = d.tran_id
                 AND b.gacc_tran_id = e.gacc_tran_id
                 AND e.item_no   = rec.item_no
                 AND a.claim_id    = rec.claim_id 
                 AND a.clm_loss_id  = rec.clm_loss_id
                 AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                     BETWEEN p_from_date AND p_to_date
               GROUP BY b.dv_pref, b.dv_no, e.check_no
              HAVING SUM(NVL(a.losses_paid,0)) > 0)    
    LOOP
      v_dv_no := v2.dv_no;
      IF var_dv_no IS NULL THEN
         var_dv_no := v_dv_no;
      ELSE
         var_dv_no := v_dv_no;   
      END IF;
    END LOOP;      
    END IF;
   
      v_columns := '"'||v_policy||'","'||v_assd_name||'",'||rec.incept_date||
       ','||rec.expiry_date||',"'||rec.claim_no||'",'||rec.loss_date||',"'||v_item_title||'",'||rec.tsi_amt||',"'||v_peril_name||
       '","'||v_intm_ri||'",'||var_dv_no||','||rec.losses_paid;

      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                            AND NVL(B.LOSSES_PAID,0) > 0
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT NVL(c.LOSSES_paid, 0) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND NVL(C.LOSSES_PAID,0) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
  		v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;
    
      FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND NVL(B.LOSSES_PAID,0) > 0
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT NVL(c.LOSSES_PAID, 0) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
                     AND c.session_id = p_session_id
                     AND NVL(c.LOSSES_PAID,0) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
        v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;  
     utl_file.put_line(v_file,v_columns);
   v_outstanding := v_outstanding + rec.losses_paid;  
    END LOOP;
  
    v_totals := ',,,,,,,,,,TOTAL,'||v_outstanding;
    FOR j IN (SELECT DISTINCT a.share_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND b.session_id = p_session_id
                          AND NVL(B.LOSSES_PAID,0) > 0
                     ORDER BY share_cd) 
    LOOP
      FOR k IN (SELECT SUM(NVL(c.LOSSES_PAID, 0)) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND NVL(C.LOSSES_PAID,0) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
  
    FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd NOT IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND a.line_cd = b.line_cd
                          AND b.session_id = p_session_id
                          AND NVL(B.LOSSES_PAID,0) > 0
                     ORDER BY line_cd, share_cd) 
    LOOP
      FOR k IN (SELECT SUM(NVL(c.LOSSES_paid, 0)) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND c.line_cd = j.line_cd
                   AND NVL(C.LOSSES_PAID,0) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
    utl_file.put_line(v_file,v_totals);
    utl_file.fclose(v_file); 
  END;
  
  ----------------------------------------------------------------------------------------------------

  PROCEDURE CSV_GICLR222E(p_session_id   VARCHAR2,
               			  p_claim_id     VARCHAR2,
      					  p_paid_date    VARCHAR2,
      					  p_from_date    VARCHAR2,
      					  p_to_date      VARCHAR2,
						  p_file_name	 VARCHAR2) 
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_columns           VARCHAR2(32767);
    v_headers           VARCHAR2(32767);
    v_totals            VARCHAR2(32767);
    v_loss              NUMBER := 0;
    v_outstanding       NUMBER := 0;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(1000);
	var_dv_no        	VARCHAR2(2000):=' ';
 	v_dv_no          	VARCHAR2(500):=' ';
  
    CURSOR c1 IS SELECT DISTINCT A.BRDRX_RECORD_ID,
               		A.CLAIM_ID,
                    A.LINE_CD,
               		A.ASSD_NO,
               		A.CLAIM_NO,
               		A.POLICY_NO,
               		A.INCEPT_DATE,
               		A.EXPIRY_DATE,
               		A.LOSS_DATE,
               		A.CLM_FILE_DATE, 
               		A.ITEM_NO,
               		A.GROUPED_ITEM_NO, 
               		A.PERIL_CD,
               		A.LOSS_CAT_CD,
               		A.TSI_AMT,
               		A.INTM_NO,
               		A.CLM_LOSS_ID,
               		NVL(A.EXPENSES_PAID,0) LOSSES_PAID
         	   FROM GICL_RES_BRDRX_EXTR A
        	  WHERE A.SESSION_ID = P_SESSION_ID 
         		AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
        		AND NVL(A.EXPENSES_PAID,0) <> 0;
  BEGIN
    v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
    
    FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR222E')
    LOOP
      utl_file.put_line(v_file,'"'||i.report_title||'"');
      EXIT;
    END LOOP;
    
    
    FOR i IN (SELECT DISTINCT from_date, to_date,
                     DECODE(pd_date_opt, 1, 'Transaction Date', 2, 'Posting Date') opt
                FROM gicl_res_brdrx_extr
               WHERE session_id = p_session_id)
    LOOP
      utl_file.put_line(v_file, '"Based on '||i.opt||'"');
      utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                               ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      utl_file.put_line(v_file, ' ');
      EXIT;
    END LOOP;
    
    v_headers := 'POLICY NUMBER,ASSURED,INCEPT DATE,EXPIRY DATE,'||
                 'CLAIM NUMBER,DATE OF LOSS,ITEM,TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY,VOUCHER NUMBER, LOSSES PAID';
    
 FOR j IN (SELECT DISTINCT A.SHARE_CD, A.TRTY_NAME 
                         FROM GIIS_DIST_SHARE A, GICL_RES_BRDRX_DS_EXTR B 
                        WHERE A.SHARE_CD IN (1, 999) 
                          AND A.SHARE_CD = B.GRP_SEQ_NO
                          AND B.SESSION_ID = p_session_id
                          AND NVL(B.EXPENSES_PAID,0) > 0
                        ORDER BY SHARE_CD) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;

    FOR j IN (SELECT DISTINCT A.LINE_CD, A.SHARE_CD, A.TRTY_NAME 
                         FROM GIIS_DIST_SHARE A, GICL_RES_BRDRX_DS_EXTR B 
                        WHERE A.SHARE_CD NOT IN (1, 999) 
                          AND A.SHARE_CD = B.GRP_SEQ_NO
                          AND A.LINE_CD = B.LINE_CD
                          AND B.SESSION_ID = p_session_id
                          AND NVL(B.EXPENSES_PAID,0) > 0
                     ORDER BY LINE_CD, SHARE_CD) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;
 
    utl_file.put_line(v_file,v_headers);     
  
    FOR rec IN c1 
    LOOP 
    
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
         END LOOP;
       END;
    ELSE
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
           END LOOP;
         END;
    END IF;
     
    IF SIGN(rec.losses_paid) < 1 THEN   
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))||
                                  ' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b, 
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id 
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.expenses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;   
         END IF;
       END LOOP;
    ELSE 
    FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                              LTRIM(TO_CHAR(b.dv_no,'0999999999')) 
                              ||' /'||e.check_no dv_no
                FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                     giac_direct_claim_payts c, giac_acctrans d,
                     giac_chk_disbursement e
               WHERE a.tran_id    = d.tran_id    
                 AND b.gacc_tran_id = c.gacc_tran_id
                 AND b.gacc_tran_id = d.tran_id
                 AND b.gacc_tran_id = e.gacc_tran_id
                 AND e.item_no   = rec.item_no
                 AND a.claim_id    = rec.claim_id 
                 AND a.clm_loss_id  = rec.clm_loss_id
                 AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                     BETWEEN p_from_date AND p_to_date
               GROUP BY b.dv_pref, b.dv_no, e.check_no
              HAVING SUM(NVL(a.expenses_paid,0)) > 0)    
    LOOP
      v_dv_no := v2.dv_no;
      IF var_dv_no IS NULL THEN
         var_dv_no := v_dv_no;
      ELSE
         var_dv_no := v_dv_no;   
      END IF;
    END LOOP;      
    END IF;
   
      v_columns := '"'||v_policy||'","'||v_assd_name||'",'||rec.incept_date||
       ','||rec.expiry_date||',"'||rec.claim_no||'",'||rec.loss_date||',"'||v_item_title||'",'||rec.tsi_amt||',"'||v_peril_name||
       '","'||v_intm_ri||'",'||var_dv_no||','||rec.losses_paid;

      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                            AND NVL(B.EXPENSES_PAID,0) > 0
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT NVL(c.EXPENSES_paid, 0) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND NVL(C.EXPENSES_PAID,0) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
  		v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;
    
      FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND NVL(B.EXPENSES_PAID,0) > 0
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT NVL(c.EXPENSES_PAID, 0) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
                     AND c.session_id = p_session_id
                     AND NVL(c.EXPENSES_PAID,0) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
        v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;  
     utl_file.put_line(v_file,v_columns);
   v_outstanding := v_outstanding + rec.losses_paid;  
    END LOOP;
  
    v_totals := ',,,,,,,,,,TOTAL,'||v_outstanding;
    FOR j IN (SELECT DISTINCT a.share_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND b.session_id = p_session_id
                          AND NVL(B.EXPENSES_PAID,0) > 0
                     ORDER BY share_cd) 
    LOOP
      FOR k IN (SELECT SUM(NVL(c.EXPENSES_PAID, 0)) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND NVL(C.EXPENSES_PAID,0) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
  
    FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd NOT IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND a.line_cd = b.line_cd
                          AND b.session_id = p_session_id
                          AND NVL(B.EXPENSES_PAID,0) > 0
                     ORDER BY line_cd, share_cd) 
    LOOP
      FOR k IN (SELECT SUM(NVL(c.EXPENSES_paid, 0)) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND c.line_cd = j.line_cd
                   AND NVL(C.EXPENSES_PAID,0) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
    utl_file.put_line(v_file,v_totals);
    utl_file.fclose(v_file); 
  END;
  
  ----------------------------------------------------------------------------------------------------
  PROCEDURE CSV_GICLR222LE(p_session_id   VARCHAR2,
               			   p_claim_id     VARCHAR2,
      					   p_paid_date    VARCHAR2,
      					   p_from_date    VARCHAR2,
      					   p_to_date      VARCHAR2,
						   p_file_name	 VARCHAR2)
  IS
    v_file                UTL_FILE.FILE_TYPE;
    v_columns             VARCHAR2(32767);
    v_headers             VARCHAR2(32767);
    v_totals              VARCHAR2(32767);
    v_loss                NUMBER := 0;
    v_outstanding         NUMBER := 0;
    v_outstanding2        NUMBER := 0;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(1000);
	var_dv_no        	VARCHAR2(2000):=' ';
 	v_dv_no          	VARCHAR2(500):=' ';
    
    CURSOR c1 IS SELECT LINE_CD,
                        CLAIM_ID,
                        ASSD_NO,
                        CLAIM_NO,
                        POLICY_NO,
                        INCEPT_DATE,
                        EXPIRY_DATE,
                        LOSS_DATE,
                        CLM_FILE_DATE,
                        ITEM_NO,
                        grouped_item_no,
                        PERIL_CD,
                        LOSS_CAT_CD,
                        TSI_AMT,
                        INTM_NO,
						CLM_LOSS_ID,
                        SUM(LOSSES_PAID) LOSSES_PAID,
                        SUM(EXPENSES_PAID) EXPENSES_PAID
                   FROM (SELECT DISTINCT A.LINE_CD,
                                A.BRDRX_RECORD_ID,
                                A.CLAIM_ID,
                                A.ASSD_NO,
                                A.CLAIM_NO,
                                A.POLICY_NO,
                                A.INCEPT_DATE,
                                A.EXPIRY_DATE,
                                A.LOSS_DATE,
                                A.CLM_FILE_DATE,
                                A.ITEM_NO,
                                A.grouped_item_no,
                                A.PERIL_CD,
                                A.LOSS_CAT_CD,
                                A.TSI_AMT,
                                A.INTM_NO,
								A.CLM_LOSS_ID,
                                NVL(A.LOSSES_PAID,0) LOSSES_PAID,
                                NVL(A.EXPENSES_PAID,0) EXPENSES_PAID           
                           FROM GICL_RES_BRDRX_EXTR A,
                                GIIS_INTERMEDIARY B
                          WHERE A.SESSION_ID = P_SESSION_ID 
                            AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                            AND NVL(A.LOSSES_PAID,0) > 0
                         UNION
                         SELECT DISTINCT A.LINE_CD,
                                A.BRDRX_RECORD_ID,
                                A.CLAIM_ID,
                                A.ASSD_NO,
                                A.CLAIM_NO,
                                A.POLICY_NO,
                                A.INCEPT_DATE,
                                A.EXPIRY_DATE,
                                A.LOSS_DATE,
                                A.CLM_FILE_DATE,
                                A.ITEM_NO,
                                A.grouped_item_no,
                                A.PERIL_CD,
                                A.LOSS_CAT_CD,
                                A.TSI_AMT,
                                A.INTM_NO,
								A.CLM_LOSS_ID,
                                NVL(A.LOSSES_PAID,0) LOSSES_PAID,
                                NVL(A.EXPENSES_PAID,0) EXPENSES_PAID           
                           FROM GICL_RES_BRDRX_EXTR A,
                                GIIS_INTERMEDIARY B
                          WHERE A.SESSION_ID = P_SESSION_ID 
                            AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                            AND NVL(A.EXPENSES_PAID,0) > 0)
                       GROUP BY LINE_CD,  CLAIM_ID, ASSD_NO,
                                CLAIM_NO, POLICY_NO, INCEPT_DATE, EXPIRY_DATE,
                                LOSS_DATE, CLM_FILE_DATE, ITEM_NO, grouped_item_no,
                                PERIL_CD, LOSS_CAT_CD, TSI_AMT, INTM_NO, CLM_LOSS_ID;
   BEGIN
      v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
      
      FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR222LE')
    LOOP
      utl_file.put_line(v_file,'"'||i.report_title||'"');
      EXIT;
    END LOOP;
    
    
    FOR i IN (SELECT DISTINCT from_date, to_date,
                     DECODE(pd_date_opt, 1, 'Transaction Date', 2, 'Posting Date') opt
                FROM gicl_res_brdrx_extr
               WHERE session_id = p_session_id)
    LOOP
      utl_file.put_line(v_file, '"Based on '||i.opt||'"');
      utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                               ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      utl_file.put_line(v_file, ' ');
      EXIT;
    END LOOP;
    
      v_headers := 'POLICY NUMBER,ASSURED,INCEPT DATE,EXPIRY DATE,'||
                   'CLAIM NUMBER,DATE OF LOSS,ITEM,TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY,VOUCHER NUMBER, LOSSES PAID';

      FOR j IN (SELECT DISTINCT a.share_cd, a.trty_name 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                       ORDER BY share_cd) 
      LOOP
        v_headers := v_headers||',"'||j.trty_name||'"';
      END LOOP;

      FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd, a.trty_name 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                       ORDER BY line_cd, share_cd) 
      LOOP
        v_headers := v_headers||',"'||j.trty_name||'"';
      END LOOP;
      utl_file.put_line(v_file,v_headers);     
  
      FOR rec IN c1 
      LOOP 
        
    
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;
    
    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;
    
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;
    
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));
    
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;
    
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;
    
    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
         END LOOP;
       END;
    ELSE
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
           END LOOP;
         END;
    END IF; 
    
    IF SIGN(rec.losses_paid) < 1 THEN   
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))||
                                  ' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b, 
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id 
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.expenses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;   
         END IF;
       END LOOP;
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999')) 
                                  ||' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b, 
                         giac_acctrans c, giac_reversals d, 
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id 
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.losses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;   
         END IF;
       END LOOP;
    ELSE 
       FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                              LTRIM(TO_CHAR(b.dv_no,'0999999999')) 
                              ||' /'||e.check_no dv_no
                FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                     giac_direct_claim_payts c, giac_acctrans d,
                     giac_chk_disbursement e
               WHERE a.tran_id    = d.tran_id    
                 AND b.gacc_tran_id = c.gacc_tran_id
                 AND b.gacc_tran_id = d.tran_id
                 AND b.gacc_tran_id = e.gacc_tran_id
                 AND e.item_no   = rec.item_no
                 AND a.claim_id    = rec.claim_id 
                 AND a.clm_loss_id  = rec.clm_loss_id
                 AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                     BETWEEN p_from_date AND p_to_date
               GROUP BY b.dv_pref, b.dv_no, e.check_no
              HAVING SUM(NVL(a.expenses_paid,0)) > 0)    
        LOOP
          v_dv_no := v2.dv_no;
          IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
          ELSE
            var_dv_no := v_dv_no;   
          END IF;
        END LOOP; 
        FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                               LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                               ||' /'||e.check_no dv_no
                 FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                      giac_direct_claim_payts c, giac_acctrans d,
                      giac_chk_disbursement e
                WHERE a.tran_id = d.tran_id    
                  AND b.gacc_tran_id = c.gacc_tran_id
                  AND b.gacc_tran_id = d.tran_id
                  AND b.gacc_tran_id = e.gacc_tran_id
                  AND a.claim_id    = rec.claim_id 
                  AND a.clm_loss_id  = rec.clm_loss_id
                  AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                      BETWEEN p_from_date AND p_to_date
                GROUP BY b.dv_pref, b.dv_no, e.check_no
               HAVING SUM(NVL(a.losses_paid,0)) > 0)    
        LOOP
          v_dv_no := v2.dv_no;
          IF var_dv_no IS NULL THEN
             var_dv_no := v_dv_no;
          ELSE
             var_dv_no := v_dv_no;   
          END IF;
        END LOOP;     
    END IF;
        v_columns := '"'||v_policy||'","'||v_assd_name||'",'||rec.incept_date||','||rec.expiry_date||
                     ',"'||rec.claim_no||'",'||rec.loss_date||
                     ',"'||v_item_title||'",'||rec.tsi_amt||',"'||v_peril_name||'","'||v_intm_ri||'",'||var_dv_no||
                     ','||rec.losses_paid;
      
        FOR j IN (SELECT DISTINCT a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND b.session_id = p_session_id
                         ORDER BY share_cd) 
        LOOP
          FOR k IN (SELECT NVL(c.LOSSES_PAID, 0) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.session_id = p_session_id
                       AND c.grp_seq_no = j.share_cd)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;
   
        FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd NOT IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND a.line_cd = b.line_cd
                              AND b.session_id = p_session_id
                         ORDER BY line_cd, share_cd) 
        LOOP
          FOR k IN (SELECT NVL(c.LOSSES_PAID, 0) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.grp_seq_no = j.share_cd
                       AND c.line_cd = j.line_cd
                       AND c.session_id = p_session_id)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;  
        utl_file.put_line(v_file,v_columns);
        v_columns := ',,,,,,,,,,,'||rec.expenses_paid;
 
        FOR j IN (SELECT DISTINCT a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND b.session_id = p_session_id
                         ORDER BY share_cd) 
        LOOP
          FOR k IN (SELECT NVL(c.expenses_paid, 0) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.session_id = p_session_id
                       AND c.grp_seq_no = j.share_cd)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;
   
        FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd NOT IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND a.line_cd = b.line_cd
                              AND b.session_id = p_session_id
                         ORDER BY line_cd, share_cd) 
        LOOP
          FOR k IN (SELECT NVL(c.expenses_PAID, 0) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.grp_seq_no = j.share_cd
                       AND c.line_cd = j.line_cd
                       AND c.session_id = p_session_id)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;
        utl_file.put_line(v_file,v_columns);
        v_outstanding := v_outstanding + rec.losses_paid;  
        v_outstanding2 := v_outstanding2 + rec.expenses_paid; 
      END LOOP;
      v_totals := ',,,,,,,,,,TOTAL,'||v_outstanding;
  
      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT SUM(NVL(c.LOSSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
					 AND NVL(C.LOSSES_PAID, 0) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
  
      FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT SUM(NVL(c.LOSSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
					 AND NVL(C.LOSSES_PAID, 0) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
      utl_file.put_line(v_file,v_totals);
      v_totals := ',,,,,,,,,,TOTAL,'||v_outstanding2;
  
      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT SUM(NVL(c.EXPENSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
					 AND NVL(C.EXPENSES_PAID, 0) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
  
      FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT SUM(NVL(c.EXPENSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
					 AND NVL(C.EXPENSES_PAID, 0) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
      utl_file.put_line(v_file,v_totals);
      utl_file.fclose(v_file); 
  END;
  
  ----------------------------------------------------------------------------------------------------
    
  PROCEDURE CSV_GICLR221L(p_session_id   VARCHAR2,
               			  p_claim_id     VARCHAR2,
      					  p_paid_date    VARCHAR2,
      					  p_from_date    VARCHAR2,
      					  p_to_date      VARCHAR2,
						  p_file_name	 VARCHAR2) 
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_columns           VARCHAR2(32767);
    v_headers           VARCHAR2(32767);
    v_totals            VARCHAR2(32767);
    v_loss              NUMBER := 0;
    v_outstanding       NUMBER := 0;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(1000);
	var_dv_no        	VARCHAR2(2000):=' ';
 	v_dv_no          	VARCHAR2(500):=' ';
  
    CURSOR c1 IS SELECT DISTINCT A.BRDRX_RECORD_ID,
               		A.CLAIM_ID,
                    A.LINE_CD,
               		A.ASSD_NO,
               		A.CLAIM_NO,
               		A.POLICY_NO,
               		A.INCEPT_DATE,
               		A.EXPIRY_DATE,
               		A.LOSS_DATE,
               		A.CLM_FILE_DATE, 
               		A.ITEM_NO,
               		A.GROUPED_ITEM_NO, 
               		A.PERIL_CD,
               		A.LOSS_CAT_CD,
               		A.TSI_AMT,
               		A.INTM_NO,
               		A.CLM_LOSS_ID,
                    A.ENROLLEE,
               		NVL(A.LOSSES_PAID,0) LOSSES_PAID
         	   FROM GICL_RES_BRDRX_EXTR A
        	  WHERE A.SESSION_ID = P_SESSION_ID 
         		AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
        		AND NVL(A.LOSSES_PAID,0) <> 0;
  BEGIN
    v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
    
    FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR221L')
    LOOP
      utl_file.put_line(v_file,'"'||i.report_title||'"');
      EXIT;
    END LOOP;
    
    FOR i IN (SELECT DISTINCT from_date, to_date,
                     DECODE(pd_date_opt, 1, 'Transaction Date', 2, 'Posting Date') opt
                FROM gicl_res_brdrx_extr
               WHERE session_id = p_session_id)
    LOOP
      utl_file.put_line(v_file, '"Based on '||i.opt||'"');
      utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                               ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      utl_file.put_line(v_file, ' ');
      EXIT;
    END LOOP;
    
    v_headers := 'ENROLLEE,CLAIM NUMBER,POLICY NUMBER,ASSURED,INCEPT DATE,EXPIRY DATE,'||
                 'DATE OF LOSS,ITEM,TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY,VOUCHER NUMBER, LOSSES PAID';
    
 FOR j IN (SELECT DISTINCT A.SHARE_CD, A.TRTY_NAME 
                         FROM GIIS_DIST_SHARE A, GICL_RES_BRDRX_DS_EXTR B 
                        WHERE A.SHARE_CD IN (1, 999) 
                          AND A.SHARE_CD = B.GRP_SEQ_NO
                          AND B.SESSION_ID = p_session_id
                          AND NVL(B.LOSSES_PAID,0) > 0
                        ORDER BY SHARE_CD) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;

    FOR j IN (SELECT DISTINCT A.LINE_CD, A.SHARE_CD, A.TRTY_NAME 
                         FROM GIIS_DIST_SHARE A, GICL_RES_BRDRX_DS_EXTR B 
                        WHERE A.SHARE_CD NOT IN (1, 999) 
                          AND A.SHARE_CD = B.GRP_SEQ_NO
                          AND A.LINE_CD = B.LINE_CD
                          AND B.SESSION_ID = p_session_id
                          AND NVL(B.LOSSES_PAID,0) > 0
                     ORDER BY LINE_CD, SHARE_CD) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;
 
    utl_file.put_line(v_file,v_headers);     
  
    FOR rec IN c1 
    LOOP 
    
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
         END LOOP;
       END;
    ELSE
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
           END LOOP;
         END;
    END IF;
     
    IF SIGN(rec.losses_paid) < 1 THEN   
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))||
                                  ' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b, 
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id 
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.losses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;   
         END IF;
       END LOOP;
    ELSE 
    FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                              LTRIM(TO_CHAR(b.dv_no,'0999999999')) 
                              ||' /'||e.check_no dv_no
                FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                     giac_direct_claim_payts c, giac_acctrans d,
                     giac_chk_disbursement e
               WHERE a.tran_id    = d.tran_id    
                 AND b.gacc_tran_id = c.gacc_tran_id
                 AND b.gacc_tran_id = d.tran_id
                 AND b.gacc_tran_id = e.gacc_tran_id
                 AND e.item_no   = rec.item_no
                 AND a.claim_id    = rec.claim_id 
                 AND a.clm_loss_id  = rec.clm_loss_id
                 AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                     BETWEEN p_from_date AND p_to_date
               GROUP BY b.dv_pref, b.dv_no, e.check_no
              HAVING SUM(NVL(a.losses_paid,0)) > 0)    
    LOOP
      v_dv_no := v2.dv_no;
      IF var_dv_no IS NULL THEN
         var_dv_no := v_dv_no;
      ELSE
         var_dv_no := v_dv_no;   
      END IF;
    END LOOP;      
    END IF;
   
      v_columns := '"'||rec.enrollee||'","'||rec.claim_no||'","'||v_policy||'","'||v_assd_name||'",'||rec.incept_date||
       ','||rec.expiry_date||','||rec.loss_date||',"'||v_item_title||'",'||rec.tsi_amt||',"'||v_peril_name||
       '","'||v_intm_ri||'",'||var_dv_no||','||rec.losses_paid;

      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                            AND NVL(B.LOSSES_PAID,0) > 0
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT NVL(c.LOSSES_paid, 0) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND NVL(C.LOSSES_PAID,0) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
  		v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;
    
      FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND NVL(B.LOSSES_PAID,0) > 0
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT NVL(c.LOSSES_PAID, 0) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
                     AND c.session_id = p_session_id
                     AND NVL(c.LOSSES_PAID,0) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
        v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;  
     utl_file.put_line(v_file,v_columns);
   v_outstanding := v_outstanding + rec.losses_paid;  
    END LOOP;
  
    v_totals := ',,,,,,,,,,,TOTAL,'||v_outstanding;
    FOR j IN (SELECT DISTINCT a.share_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND b.session_id = p_session_id
                          AND NVL(B.LOSSES_PAID,0) > 0
                     ORDER BY share_cd) 
    LOOP
      FOR k IN (SELECT SUM(NVL(c.LOSSES_PAID, 0)) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND NVL(C.LOSSES_PAID,0) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
  
    FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd NOT IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND a.line_cd = b.line_cd
                          AND b.session_id = p_session_id
                          AND NVL(B.LOSSES_PAID,0) > 0
                     ORDER BY line_cd, share_cd) 
    LOOP
      FOR k IN (SELECT SUM(NVL(c.LOSSES_paid, 0)) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND c.line_cd = j.line_cd
                   AND NVL(C.LOSSES_PAID,0) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
    utl_file.put_line(v_file,v_totals);
    utl_file.fclose(v_file); 
  END;
  
  ----------------------------------------------------------------------------------------------------

  PROCEDURE CSV_GICLR221E(p_session_id   VARCHAR2,
               			  p_claim_id     VARCHAR2,
      					  p_paid_date    VARCHAR2,
      					  p_from_date    VARCHAR2,
      					  p_to_date      VARCHAR2,
						  p_file_name	 VARCHAR2) 
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_columns           VARCHAR2(32767);
    v_headers           VARCHAR2(32767);
    v_totals            VARCHAR2(32767);
    v_loss              NUMBER := 0;
    v_outstanding       NUMBER := 0;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(1000);
	var_dv_no        	VARCHAR2(2000):=' ';
 	v_dv_no          	VARCHAR2(500):=' ';
  
    CURSOR c1 IS SELECT DISTINCT A.BRDRX_RECORD_ID,
               		A.CLAIM_ID,
                    A.LINE_CD,
               		A.ASSD_NO,
               		A.CLAIM_NO,
               		A.POLICY_NO,
               		A.INCEPT_DATE,
               		A.EXPIRY_DATE,
               		A.LOSS_DATE,
               		A.CLM_FILE_DATE, 
               		A.ITEM_NO,
               		A.GROUPED_ITEM_NO, 
               		A.PERIL_CD,
               		A.LOSS_CAT_CD,
               		A.TSI_AMT,
               		A.INTM_NO,
               		A.CLM_LOSS_ID,
                    A.ENROLLEE,
               		NVL(A.EXPENSES_PAID,0) LOSSES_PAID
         	   FROM GICL_RES_BRDRX_EXTR A
        	  WHERE A.SESSION_ID = P_SESSION_ID 
         		AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
        		AND NVL(A.EXPENSES_PAID,0) <> 0;
  BEGIN
    v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
    
    FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR221E')
    LOOP
      utl_file.put_line(v_file,'"'||i.report_title||'"');
      EXIT;
    END LOOP;
    
    FOR i IN (SELECT DISTINCT from_date, to_date,
                     DECODE(pd_date_opt, 1, 'Transaction Date', 2, 'Posting Date') opt
                FROM gicl_res_brdrx_extr
               WHERE session_id = p_session_id)
    LOOP
      utl_file.put_line(v_file, '"Based on '||i.opt||'"');
      utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                               ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      utl_file.put_line(v_file, ' ');
      EXIT;
    END LOOP;
    
    v_headers := 'ENROLLEE,CLAIM NUMBER,POLICY NUMBER,ASSURED,INCEPT DATE,EXPIRY DATE,'||
                 'DATE OF LOSS,ITEM,TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY,VOUCHER NUMBER, LOSSES PAID';
    
 FOR j IN (SELECT DISTINCT A.SHARE_CD, A.TRTY_NAME 
                         FROM GIIS_DIST_SHARE A, GICL_RES_BRDRX_DS_EXTR B 
                        WHERE A.SHARE_CD IN (1, 999) 
                          AND A.SHARE_CD = B.GRP_SEQ_NO
                          AND B.SESSION_ID = p_session_id
                          AND NVL(B.EXPENSES_PAID,0) > 0
                        ORDER BY SHARE_CD) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;

    FOR j IN (SELECT DISTINCT A.LINE_CD, A.SHARE_CD, A.TRTY_NAME 
                         FROM GIIS_DIST_SHARE A, GICL_RES_BRDRX_DS_EXTR B 
                        WHERE A.SHARE_CD NOT IN (1, 999) 
                          AND A.SHARE_CD = B.GRP_SEQ_NO
                          AND A.LINE_CD = B.LINE_CD
                          AND B.SESSION_ID = p_session_id
                          AND NVL(B.EXPENSES_PAID,0) > 0
                     ORDER BY LINE_CD, SHARE_CD) 
    LOOP
      v_headers := v_headers||',"'||j.trty_name||'"';
    END LOOP;
 
    utl_file.put_line(v_file,v_headers);     
  
    FOR rec IN c1 
    LOOP 
    
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
         END LOOP;
       END;
    ELSE
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
           END LOOP;
         END;
    END IF;
     
    IF SIGN(rec.losses_paid) < 1 THEN   
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))||
                                  ' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b, 
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id 
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.expenses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;   
         END IF;
       END LOOP;
    ELSE 
    FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                              LTRIM(TO_CHAR(b.dv_no,'0999999999')) 
                              ||' /'||e.check_no dv_no
                FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                     giac_direct_claim_payts c, giac_acctrans d,
                     giac_chk_disbursement e
               WHERE a.tran_id    = d.tran_id    
                 AND b.gacc_tran_id = c.gacc_tran_id
                 AND b.gacc_tran_id = d.tran_id
                 AND b.gacc_tran_id = e.gacc_tran_id
                 AND e.item_no   = rec.item_no
                 AND a.claim_id    = rec.claim_id 
                 AND a.clm_loss_id  = rec.clm_loss_id
                 AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                     BETWEEN p_from_date AND p_to_date
               GROUP BY b.dv_pref, b.dv_no, e.check_no
              HAVING SUM(NVL(a.expenses_paid,0)) > 0)    
    LOOP
      v_dv_no := v2.dv_no;
      IF var_dv_no IS NULL THEN
         var_dv_no := v_dv_no;
      ELSE
         var_dv_no := v_dv_no;   
      END IF;
    END LOOP;      
    END IF;
   
      v_columns := '"'||rec.enrollee||'","'||rec.claim_no||'","'||v_policy||'","'||v_assd_name||'",'||rec.incept_date||
       ','||rec.expiry_date||','||rec.loss_date||',"'||v_item_title||'",'||rec.tsi_amt||',"'||v_peril_name||
       '","'||v_intm_ri||'",'||var_dv_no||','||rec.losses_paid;

      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                            AND NVL(B.EXPENSES_PAID,0) > 0
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT NVL(c.EXPENSES_paid, 0) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND NVL(C.EXPENSES_PAID,0) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
  		v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;
    
      FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND NVL(B.EXPENSES_PAID,0) > 0
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT NVL(c.EXPENSES_PAID, 0) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.claim_id = rec.claim_id
                     AND c.ITEM_NO = rec.item_no
                     AND c.PERIL_CD = rec.peril_cd
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
                     AND c.session_id = p_session_id
                     AND NVL(c.EXPENSES_PAID,0) > 0)
        LOOP
          v_loss := v_loss + k.os;
        END LOOP;    
        v_columns := v_columns||','||v_loss;
        v_loss := 0;
      END LOOP;  
     utl_file.put_line(v_file,v_columns);
   v_outstanding := v_outstanding + rec.losses_paid;  
    END LOOP;
  
    v_totals := ',,,,,,,,,,,TOTAL,'||v_outstanding;
    FOR j IN (SELECT DISTINCT a.share_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND b.session_id = p_session_id
                          AND NVL(B.EXPENSES_PAID,0) > 0
                     ORDER BY share_cd) 
    LOOP
      FOR k IN (SELECT SUM(NVL(c.EXPENSES_PAID, 0)) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND NVL(C.EXPENSES_PAID,0) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
  
    FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                         FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                        WHERE a.share_cd NOT IN (1, 999) 
                          AND a.share_cd = b.grp_seq_no
                          AND a.line_cd = b.line_cd
                          AND b.session_id = p_session_id
                          AND NVL(B.EXPENSES_PAID,0) > 0
                     ORDER BY line_cd, share_cd) 
    LOOP
      FOR k IN (SELECT SUM(NVL(c.EXPENSES_paid, 0)) os
                  FROM gicl_res_brdrx_ds_extr c
                 WHERE c.session_id = p_session_id
                   AND c.grp_seq_no = j.share_cd
                   AND c.line_cd = j.line_cd
                   AND NVL(C.EXPENSES_PAID,0) > 0)
      LOOP
        v_totals := v_totals||','||k.os;
      END LOOP;    
    END LOOP;
    utl_file.put_line(v_file,v_totals);
    utl_file.fclose(v_file); 
  END;
  
  ----------------------------------------------------------------------------------------------------
  PROCEDURE CSV_GICLR221LE(p_session_id   VARCHAR2,
               			   p_claim_id     VARCHAR2,
      					   p_paid_date    VARCHAR2,
      					   p_from_date    VARCHAR2,
      					   p_to_date      VARCHAR2,
						   p_file_name	 VARCHAR2)
  IS
    v_file                UTL_FILE.FILE_TYPE;
    v_columns             VARCHAR2(32767);
    v_headers             VARCHAR2(32767);
    v_totals              VARCHAR2(32767);
    v_loss                NUMBER := 0;
    v_outstanding         NUMBER := 0;
    v_outstanding2        NUMBER := 0;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(1000);
	var_dv_no        	VARCHAR2(2000):=' ';
 	v_dv_no          	VARCHAR2(500):=' ';
    
    CURSOR c1 IS SELECT LINE_CD,
                        CLAIM_ID,
                        ASSD_NO,
                        CLAIM_NO,
                        POLICY_NO,
                        INCEPT_DATE,
                        EXPIRY_DATE,
                        LOSS_DATE,
                        CLM_FILE_DATE,
                        ITEM_NO,
                        grouped_item_no,
                        PERIL_CD,
                        LOSS_CAT_CD,
                        TSI_AMT,
                        INTM_NO,
						CLM_LOSS_ID,
                        ENROLLEE,
                        SUM(LOSSES_PAID) LOSSES_PAID,
                        SUM(EXPENSES_PAID) EXPENSES_PAID
                   FROM (SELECT DISTINCT A.LINE_CD,
                                A.BRDRX_RECORD_ID,
                                A.CLAIM_ID,
                                A.ASSD_NO,
                                A.CLAIM_NO,
                                A.POLICY_NO,
                                A.INCEPT_DATE,
                                A.EXPIRY_DATE,
                                A.LOSS_DATE,
                                A.CLM_FILE_DATE,
                                A.ITEM_NO,
                                A.grouped_item_no,
                                A.PERIL_CD,
                                A.LOSS_CAT_CD,
                                A.TSI_AMT,
                                A.INTM_NO,
								A.CLM_LOSS_ID,
                                A.ENROLLEE,
                                NVL(A.LOSSES_PAID,0) LOSSES_PAID,
                                NVL(A.EXPENSES_PAID,0) EXPENSES_PAID           
                           FROM GICL_RES_BRDRX_EXTR A,
                                GIIS_INTERMEDIARY B
                          WHERE A.SESSION_ID = P_SESSION_ID 
                            AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                            AND NVL(A.LOSSES_PAID,0) > 0
                         UNION
                         SELECT DISTINCT A.LINE_CD,
                                A.BRDRX_RECORD_ID,
                                A.CLAIM_ID,
                                A.ASSD_NO,
                                A.CLAIM_NO,
                                A.POLICY_NO,
                                A.INCEPT_DATE,
                                A.EXPIRY_DATE,
                                A.LOSS_DATE,
                                A.CLM_FILE_DATE,
                                A.ITEM_NO,
                                A.grouped_item_no,
                                A.PERIL_CD,
                                A.LOSS_CAT_CD,
                                A.TSI_AMT,
                                A.INTM_NO,
								A.CLM_LOSS_ID,
                                A.ENROLLEE,
                                NVL(A.LOSSES_PAID,0) LOSSES_PAID,
                                NVL(A.EXPENSES_PAID,0) EXPENSES_PAID           
                           FROM GICL_RES_BRDRX_EXTR A,
                                GIIS_INTERMEDIARY B
                          WHERE A.SESSION_ID = P_SESSION_ID 
                            AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                            AND NVL(A.EXPENSES_PAID,0) > 0)
                       GROUP BY LINE_CD,  CLAIM_ID, ASSD_NO,
                                CLAIM_NO, POLICY_NO, INCEPT_DATE, EXPIRY_DATE,
                                LOSS_DATE, CLM_FILE_DATE, ITEM_NO, grouped_item_no,
                                PERIL_CD, LOSS_CAT_CD, TSI_AMT, INTM_NO, CLM_LOSS_ID, ENROLLEE;
   BEGIN
      v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
      
      FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR221LE')
    LOOP
      utl_file.put_line(v_file,'"'||i.report_title||'"');
      EXIT;
    END LOOP;
    
    FOR i IN (SELECT DISTINCT from_date, to_date,
                     DECODE(pd_date_opt, 1, 'Transaction Date', 2, 'Posting Date') opt
                FROM gicl_res_brdrx_extr
               WHERE session_id = p_session_id)
    LOOP
      utl_file.put_line(v_file, '"Based on '||i.opt||'"');
      utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                               ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
      utl_file.put_line(v_file, ' ');
      EXIT;
    END LOOP;
    
      v_headers := 'ENROLLEE,CLAIM NUMBER,POLICY NUMBER,ASSURED,INCEPT DATE,EXPIRY DATE,'||
                   'DATE OF LOSS,ITEM,TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY,VOUCHER NUMBER, LOSSES PAID';

      FOR j IN (SELECT DISTINCT a.share_cd, a.trty_name 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                       ORDER BY share_cd) 
      LOOP
        v_headers := v_headers||',"'||j.trty_name||'"';
      END LOOP;

      FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd, a.trty_name 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                       ORDER BY line_cd, share_cd) 
      LOOP
        v_headers := v_headers||',"'||j.trty_name||'"';
      END LOOP;
      utl_file.put_line(v_file,v_headers);     
  
      FOR rec IN c1 
      LOOP 
        
    
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;
    
    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;
    
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;
    
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));
    
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;
    
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;
    
    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
         END LOOP;
       END;
    ELSE
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
           END LOOP;
         END;
    END IF; 
    
    IF SIGN(rec.losses_paid) < 1 THEN   
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))||
                                  ' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b, 
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id 
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.expenses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;   
         END IF;
       END LOOP;
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999')) 
                                  ||' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b, 
                         giac_acctrans c, giac_reversals d, 
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id 
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.losses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;   
         END IF;
       END LOOP;
    ELSE 
       FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                              LTRIM(TO_CHAR(b.dv_no,'0999999999')) 
                              ||' /'||e.check_no dv_no
                FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                     giac_direct_claim_payts c, giac_acctrans d,
                     giac_chk_disbursement e
               WHERE a.tran_id    = d.tran_id    
                 AND b.gacc_tran_id = c.gacc_tran_id
                 AND b.gacc_tran_id = d.tran_id
                 AND b.gacc_tran_id = e.gacc_tran_id
                 AND e.item_no   = rec.item_no
                 AND a.claim_id    = rec.claim_id 
                 AND a.clm_loss_id  = rec.clm_loss_id
                 AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                     BETWEEN p_from_date AND p_to_date
               GROUP BY b.dv_pref, b.dv_no, e.check_no
              HAVING SUM(NVL(a.expenses_paid,0)) > 0)    
        LOOP
          v_dv_no := v2.dv_no;
          IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
          ELSE
            var_dv_no := v_dv_no;   
          END IF;
        END LOOP; 
        FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                               LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                               ||' /'||e.check_no dv_no
                 FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                      giac_direct_claim_payts c, giac_acctrans d,
                      giac_chk_disbursement e
                WHERE a.tran_id = d.tran_id    
                  AND b.gacc_tran_id = c.gacc_tran_id
                  AND b.gacc_tran_id = d.tran_id
                  AND b.gacc_tran_id = e.gacc_tran_id
                  AND a.claim_id    = rec.claim_id 
                  AND a.clm_loss_id  = rec.clm_loss_id
                  AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                      BETWEEN p_from_date AND p_to_date
                GROUP BY b.dv_pref, b.dv_no, e.check_no
               HAVING SUM(NVL(a.losses_paid,0)) > 0)    
        LOOP
          v_dv_no := v2.dv_no;
          IF var_dv_no IS NULL THEN
             var_dv_no := v_dv_no;
          ELSE
             var_dv_no := v_dv_no;   
          END IF;
        END LOOP;     
    END IF;
        v_columns := '"'||rec.enrollee||'","'||rec.claim_no||'","'||v_policy||'","'||v_assd_name||'",'||rec.incept_date||','||rec.expiry_date||
                     ','||rec.loss_date||
                     ',"'||v_item_title||'",'||rec.tsi_amt||',"'||v_peril_name||'","'||v_intm_ri||'",'||var_dv_no||
                     ','||rec.losses_paid;
      
        FOR j IN (SELECT DISTINCT a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND b.session_id = p_session_id
                         ORDER BY share_cd) 
        LOOP
          FOR k IN (SELECT NVL(c.LOSSES_PAID, 0) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.session_id = p_session_id
                       AND c.grp_seq_no = j.share_cd)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;
   
        FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd NOT IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND a.line_cd = b.line_cd
                              AND b.session_id = p_session_id
                         ORDER BY line_cd, share_cd) 
        LOOP
          FOR k IN (SELECT NVL(c.LOSSES_PAID, 0) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.grp_seq_no = j.share_cd
                       AND c.line_cd = j.line_cd
                       AND c.session_id = p_session_id)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;  
        utl_file.put_line(v_file,v_columns);
        v_columns := ',,,,,,,,,,,,'||rec.expenses_paid;
 
        FOR j IN (SELECT DISTINCT a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND b.session_id = p_session_id
                         ORDER BY share_cd) 
        LOOP
          FOR k IN (SELECT NVL(c.expenses_paid, 0) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.session_id = p_session_id
                       AND c.grp_seq_no = j.share_cd)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;
   
        FOR j IN (SELECT DISTINCT a.line_cd, a.share_cd 
                             FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                            WHERE a.share_cd NOT IN (1, 999) 
                              AND a.share_cd = b.grp_seq_no
                              AND a.line_cd = b.line_cd
                              AND b.session_id = p_session_id
                         ORDER BY line_cd, share_cd) 
        LOOP
          FOR k IN (SELECT NVL(c.expenses_PAID, 0) os
                      FROM gicl_res_brdrx_ds_extr c
                     WHERE c.claim_id = rec.claim_id
                       AND c.ITEM_NO = rec.item_no
                       AND c.PERIL_CD = rec.peril_cd
                       AND c.grp_seq_no = j.share_cd
                       AND c.line_cd = j.line_cd
                       AND c.session_id = p_session_id)
          LOOP
            v_loss := v_loss + k.os;
          END LOOP;    
          v_columns := v_columns||','||v_loss;
          v_loss := 0;
        END LOOP;
        utl_file.put_line(v_file,v_columns);
        v_outstanding := v_outstanding + rec.losses_paid;  
        v_outstanding2 := v_outstanding2 + rec.expenses_paid; 
      END LOOP;
      v_totals := ',,,,,,,,,,,TOTAL,'||v_outstanding;
  
      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT SUM(NVL(c.LOSSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
					 AND NVL(C.LOSSES_PAID, 0) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
  
      FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT SUM(NVL(c.LOSSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
					 AND NVL(C.LOSSES_PAID, 0) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
      utl_file.put_line(v_file,v_totals);
      v_totals := ',,,,,,,,,,,TOTAL,'||v_outstanding2;
  
      FOR j IN (SELECT DISTINCT a.share_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND b.session_id = p_session_id
                       ORDER BY share_cd) 
      LOOP
        FOR k IN (SELECT SUM(NVL(c.EXPENSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
					 AND NVL(C.EXPENSES_PAID, 0) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
  
      FOR j IN (SELECT DISTINCT a.share_cd, a.line_cd 
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b 
                          WHERE a.share_cd NOT IN (1, 999) 
                            AND a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                       ORDER BY line_cd, share_cd) 
      LOOP
        FOR k IN (SELECT SUM(NVL(c.EXPENSES_PAID, 0)) os
                    FROM gicl_res_brdrx_ds_extr c
                   WHERE c.session_id = p_session_id
                     AND c.grp_seq_no = j.share_cd
                     AND c.line_cd = j.line_cd
					 AND NVL(C.EXPENSES_PAID, 0) > 0)
        LOOP
          v_totals := v_totals||','||k.os;
        END LOOP;    
      END LOOP;
      utl_file.put_line(v_file,v_totals);
      utl_file.fclose(v_file); 
  END;
  
  ----------------------------------------------------------------------------------------------------
  PROCEDURE CSV_GICLR208A(p_session_id   VARCHAR2,
                          p_claim_id     VARCHAR2,
                          p_intm_break   NUMBER,
                          p_iss_break    NUMBER,
                          p_file_name    VARCHAR2)
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_columns           VARCHAR2(32767);
    v_headers           VARCHAR2(32767);
    v_totals            VARCHAR2(32767);
    v_intm_name         GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name         GIIS_LINE.LINE_NAME%TYPE;
    v_eff_date          GICL_CLAIMS.POL_EFF_DATE%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_loss_cat_des      GIIS_LOSS_CTGRY.LOSS_CAT_DES%TYPE;
    v_net_ret           NUMBER(16,2);
    v_facultative       NUMBER(16,2);
    v_treaty            NUMBER(16,2);
    v_xol_treaty        NUMBER(16,2);
    v_total_net_ret     NUMBER(16,2);
    v_total_treaty      NUMBER(16,2);
    v_total_xol_treaty  NUMBER(16,2);
    v_total_facultative NUMBER(16,2);
    v_total_os_loss     NUMBER(16,2);
    
    BEGIN
      v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
      
      FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR208A')
      LOOP
        utl_file.put_line(v_file,'"'||i.report_title||'"');
        EXIT;
      END LOOP;
    
      FOR i IN (SELECT DISTINCT from_date, to_date,
                       DECODE(ol_date_opt, 1, 'Loss Date', 2, 'Claim File Date', 3, 'Booking Month') opt
                  FROM gicl_res_brdrx_extr
                 WHERE session_id = p_session_id)
      LOOP
        utl_file.put_line(v_file, '"Based on '||i.opt||'"');
      
        IF i.from_date IS NOT NULL THEN
           utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                                    ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
        ELSE
           utl_file.put_line(v_file,'"As of '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
        END IF;
        utl_file.put_line(v_file, ' ');
        EXIT;
      END LOOP;
    
      IF p_intm_break = 1 THEN
        v_headers := 'INTERMEDIARY,';
      END IF;
      IF p_iss_break = 1 THEN
        v_headers := v_headers||'BRANCH,';
      END IF; 
      v_headers := v_headers||'LINE, CLAIM NUMBER, POLICY NUMBER, CLAIM FILE DATE,'||
                   'EFFECTIVITY DATE, LOSS DATE, ASSURED, NATURE OF LOSS, OUTSTANDING LOSS, NET RETENTION, FACULTATIVE, PROPORTIONAL TREATY, NON-PROPORTIONAL TREATY';
      utl_file.put_line(v_file,v_headers); 
      
      FOR rec IN (SELECT  A.BUSS_SOURCE,
                          A.ISS_CD,
                          A.LINE_CD,
                          A.SUBLINE_CD,
                          A.CLAIM_ID,
                          A.ASSD_NO,
                          A.CLAIM_NO,
                          A.POLICY_NO,
                          A.CLM_FILE_DATE, 
                          A.LOSS_DATE,
                          A.LOSS_CAT_CD,
                          A.INTM_NO,
                          SUM(NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) OUTSTANDING_LOSS
                     FROM GICL_RES_BRDRX_EXTR A
                    WHERE A.SESSION_ID = P_SESSION_ID 
                      AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                      AND (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) > 0 
                 GROUP BY A.BUSS_SOURCE,
                          A.ISS_CD,
                          A.LINE_CD,
                          A.SUBLINE_CD,
                          A.CLAIM_ID,
                          A.ASSD_NO,
                          A.CLAIM_NO,
                          A.POLICY_NO,
                          A.CLM_FILE_DATE, 
                          A.LOSS_DATE,
                          A.LOSS_CAT_CD,
                          A.INTM_NO
                 ORDER BY DECODE(P_INTM_BREAK, 1, INTM_NO, 1),
                          DECODE(P_ISS_BREAK, 1, ISS_CD, 1),
                          LINE_CD)
      LOOP
        v_columns := null;
        v_net_ret := 0;
        v_facultative := 0;
        v_treaty := 0;
        v_xol_treaty := 0;
        
        FOR i IN (SELECT intm_name
                    FROM giis_intermediary
                   WHERE intm_no = rec.intm_no)
        LOOP
          v_intm_name := i.intm_name;
        END LOOP;  
        
        FOR b IN (SELECT iss_name
                    FROM giis_issource
                   WHERE iss_cd = rec.iss_cd)
        LOOP
          v_iss_name := b.iss_name;
        END LOOP; 
        
        FOR l IN (SELECT line_name
                    FROM giis_line
                   WHERE line_cd = rec.line_cd)
        LOOP
          v_line_name := l.line_name;
        END LOOP;
        
        FOR f IN (SELECT pol_eff_date
                    FROM gicl_claims
                   WHERE claim_id = rec.claim_id)
        LOOP
          v_eff_date := f.pol_eff_date;
        END LOOP;
        
        FOR a IN (SELECT assd_name
                    FROM giis_assured
                   WHERE assd_no = rec.assd_no)
        LOOP
          v_assd_name := a.assd_name;
        END LOOP;   
        
        FOR c IN (SELECT loss_cat_des
                    FROM giis_loss_ctgry
                   WHERE line_cd = rec.line_cd
                     AND loss_cat_cd = rec.loss_cat_cd)
        LOOP
          v_loss_cat_des := c.loss_cat_des;
        END LOOP;
        
        FOR I IN (SELECT (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 1)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) > 0) 
        LOOP
          v_net_ret :=  i.outstanding_loss + v_net_ret;
        END LOOP;
        
        FOR I IN (SELECT (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 3)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) > 0) 
        LOOP
          v_facultative :=  i.outstanding_loss + v_facultative;
        END LOOP;
        
        FOR I IN (SELECT (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 2)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) > 0) 
        LOOP
          v_treaty :=  i.outstanding_loss + v_treaty;
        END LOOP;
        
        FOR I IN (SELECT (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 4)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) > 0) 
        LOOP
          v_xol_treaty :=  i.outstanding_loss + v_xol_treaty;
        END LOOP;
        
        IF p_intm_break = 1 THEN
           v_columns := '"'||v_intm_name||'",';
        END IF;
        
        IF p_iss_break = 1 THEN
           v_columns := v_columns||'"'||v_iss_name||'",';
        END IF;
        
        v_columns := v_columns||
                     '"'||v_line_name||'","'||rec.claim_no||'","'||rec.policy_no||
                     '",'||rec.clm_file_date||','||v_eff_date||','||rec.loss_date||
                     ',"'||v_assd_name||'","'||v_loss_cat_des||'",'||nvl(rec.outstanding_loss, 0)||
                     ','||v_net_ret||','||v_facultative||','||v_treaty||','||v_xol_treaty;
        utl_file.put_line(v_file,v_columns);
        v_total_os_loss := nvl(v_total_os_loss, 0) + nvl(rec.outstanding_loss, 0);
        v_total_net_ret := nvl(v_total_net_ret, 0) + v_net_ret;
        v_total_facultative := nvl(v_total_facultative, 0) + v_facultative;
        v_total_treaty := nvl(v_total_treaty, 0) + v_treaty;
        v_total_xol_treaty := nvl(v_total_xol_treaty, 0) + v_xol_treaty;        
      END LOOP;
      
      IF p_intm_break = 1 THEN
         v_totals := ',';
      END IF;
      
      IF p_iss_break = 1 THEN
         v_totals := v_totals||',';
      END IF;
      
      v_totals := v_totals||
                  ',,,,,,,TOTALS,'||
                  v_total_os_loss||','||
                  v_total_net_ret||','||
                  v_total_facultative||','||
                  v_total_treaty||','||
                  v_total_xol_treaty;
      utl_file.put_line(v_file,v_totals);   
      utl_file.fclose(v_file);             
    END;
 
  ----------------------------------------------------------------------------------------------------- 
  PROCEDURE CSV_GICLR208B(p_session_id   VARCHAR2,
                          p_claim_id     VARCHAR2,
                          p_intm_break   NUMBER,
                          p_iss_break    NUMBER,
                          p_file_name    VARCHAR2)
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_columns           VARCHAR2(32767);
    v_headers           VARCHAR2(32767);
    v_totals            VARCHAR2(32767);
    v_intm_name         GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name         GIIS_LINE.LINE_NAME%TYPE;
    v_eff_date          GICL_CLAIMS.POL_EFF_DATE%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_loss_cat_des      GIIS_LOSS_CTGRY.LOSS_CAT_DES%TYPE;
    v_net_ret           NUMBER(16,2);
    v_facultative       NUMBER(16,2);
    v_treaty            NUMBER(16,2);
    v_xol_treaty        NUMBER(16,2);
    v_total_net_ret     NUMBER(16,2);
    v_total_treaty      NUMBER(16,2);
    v_total_xol_treaty  NUMBER(16,2);
    v_total_facultative NUMBER(16,2);
    v_total_os_loss     NUMBER(16,2);
    
    BEGIN
      v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
      
      FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR208B')
      LOOP
        utl_file.put_line(v_file,'"'||i.report_title||'"');
        EXIT;
      END LOOP;
    
      FOR i IN (SELECT DISTINCT from_date, to_date,
                       DECODE(ol_date_opt, 1, 'Loss Date', 2, 'Claim File Date', 3, 'Booking Month') opt
                  FROM gicl_res_brdrx_extr
                 WHERE session_id = p_session_id)
      LOOP
        utl_file.put_line(v_file, '"Based on '||i.opt||'"');
      
        IF i.from_date IS NOT NULL THEN
           utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                                    ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
        ELSE
           utl_file.put_line(v_file,'"As of '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
        END IF;
        utl_file.put_line(v_file, ' ');
        EXIT;
      END LOOP;
      
      IF p_intm_break = 1 THEN
        v_headers := 'INTERMEDIARY,';
      END IF;
      IF p_iss_break = 1 THEN
        v_headers := v_headers||'BRANCH,';
      END IF; 
      v_headers := v_headers||'LINE, CLAIM NUMBER, POLICY NUMBER, CLAIM FILE DATE,'||
                   'EFFECTIVITY DATE, LOSS DATE, ASSURED, NATURE OF LOSS, OUTSTANDING EXPENSE, NET RETENTION, FACULTATIVE, PROPORTIONAL TREATY, NON-PROPORTIONAL TREATY';
      utl_file.put_line(v_file,v_headers); 
      
      FOR rec IN (SELECT  A.BUSS_SOURCE,
                          A.ISS_CD,
                          A.LINE_CD,
                          A.SUBLINE_CD,
                          A.CLAIM_ID,
                          A.ASSD_NO,
                          A.CLAIM_NO,
                          A.POLICY_NO,
                          A.CLM_FILE_DATE, 
                          A.LOSS_DATE,
                          A.LOSS_CAT_CD,
                          A.INTM_NO,
                          SUM(NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_LOSS
                     FROM GICL_RES_BRDRX_EXTR A
                    WHERE A.SESSION_ID = P_SESSION_ID 
                      AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                      AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0 
                 GROUP BY A.BUSS_SOURCE,
                          A.ISS_CD,
                          A.LINE_CD,
                          A.SUBLINE_CD,
                          A.CLAIM_ID,
                          A.ASSD_NO,
                          A.CLAIM_NO,
                          A.POLICY_NO,
                          A.CLM_FILE_DATE, 
                          A.LOSS_DATE,
                          A.LOSS_CAT_CD,
                          A.INTM_NO
                 ORDER BY DECODE(P_INTM_BREAK, 1, INTM_NO, 1),
                          DECODE(P_ISS_BREAK, 1, ISS_CD, 1),
                          LINE_CD)
      LOOP
        v_columns := null;
        v_net_ret := 0;
        v_facultative := 0;
        v_treaty := 0;
        v_xol_treaty := 0;
        
        FOR i IN (SELECT intm_name
                    FROM giis_intermediary
                   WHERE intm_no = rec.intm_no)
        LOOP
          v_intm_name := i.intm_name;
        END LOOP;  
        
        FOR b IN (SELECT iss_name
                    FROM giis_issource
                   WHERE iss_cd = rec.iss_cd)
        LOOP
          v_iss_name := b.iss_name;
        END LOOP; 
        
        FOR l IN (SELECT line_name
                    FROM giis_line
                   WHERE line_cd = rec.line_cd)
        LOOP
          v_line_name := l.line_name;
        END LOOP;
        
        FOR f IN (SELECT pol_eff_date
                    FROM gicl_claims
                   WHERE claim_id = rec.claim_id)
        LOOP
          v_eff_date := f.pol_eff_date;
        END LOOP;
        
        FOR a IN (SELECT assd_name
                    FROM giis_assured
                   WHERE assd_no = rec.assd_no)
        LOOP
          v_assd_name := a.assd_name;
        END LOOP;   
        
        FOR c IN (SELECT loss_cat_des
                    FROM giis_loss_ctgry
                   WHERE line_cd = rec.line_cd
                     AND loss_cat_cd = rec.loss_cat_cd)
        LOOP
          v_loss_cat_des := c.loss_cat_des;
        END LOOP;
        
        FOR I IN (SELECT (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 1)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0) 
        LOOP
          v_net_ret :=  i.outstanding_loss + v_net_ret;
        END LOOP;
        
        FOR I IN (SELECT (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 3)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0) 
        LOOP
          v_facultative :=  i.outstanding_loss + v_facultative;
        END LOOP;
        
        FOR I IN (SELECT (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 2)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0) 
        LOOP
          v_treaty :=  i.outstanding_loss + v_treaty;
        END LOOP;
        
        FOR I IN (SELECT (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 4)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0) 
        LOOP
          v_xol_treaty :=  i.outstanding_loss + v_xol_treaty;
        END LOOP;
        
        IF p_intm_break = 1 THEN
           v_columns := '"'||v_intm_name||'",';
        END IF;
        
        IF p_iss_break = 1 THEN
           v_columns := v_columns||'"'||v_iss_name||'",';
        END IF;
        
        v_columns := v_columns||
                     '"'||v_line_name||'","'||rec.claim_no||'","'||rec.policy_no||
                     '",'||rec.clm_file_date||','||v_eff_date||','||rec.loss_date||
                     ',"'||v_assd_name||'","'||v_loss_cat_des||'",'||nvl(rec.outstanding_loss, 0)||
                     ','||v_net_ret||','||v_facultative||','||v_treaty||','||v_xol_treaty;
        utl_file.put_line(v_file,v_columns);
        v_total_os_loss := nvl(v_total_os_loss, 0) + nvl(rec.outstanding_loss, 0);
        v_total_net_ret := nvl(v_total_net_ret, 0) + v_net_ret;
        v_total_facultative := nvl(v_total_facultative, 0) + v_facultative;
        v_total_treaty := nvl(v_total_treaty, 0) + v_treaty;
        v_total_xol_treaty := nvl(v_total_xol_treaty, 0) + v_xol_treaty;        
      END LOOP;
      
      IF p_intm_break = 1 THEN
         v_totals := ',';
      END IF;
      
      IF p_iss_break = 1 THEN
         v_totals := v_totals||',';
      END IF;
      
      v_totals := v_totals||
                  ',,,,,,,TOTALS,'||
                  v_total_os_loss||','||
                  v_total_net_ret||','||
                  v_total_facultative||','||
                  v_total_treaty||','||
                  v_total_xol_treaty;
      utl_file.put_line(v_file,v_totals);   
      utl_file.fclose(v_file);             
    END;
 
  -----------------------------------------------------------------------------------------------------
  PROCEDURE CSV_GICLR209A(p_session_id   VARCHAR2,
                          p_claim_id     VARCHAR2,
                          p_intm_break   NUMBER,
                          p_iss_break    NUMBER,
                          p_file_name    VARCHAR2)
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_columns           VARCHAR2(32767);
    v_headers           VARCHAR2(32767);
    v_totals            VARCHAR2(32767);
    v_intm_name         GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name         GIIS_LINE.LINE_NAME%TYPE;
    v_eff_date          GICL_CLAIMS.POL_EFF_DATE%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_loss_cat_des      GIIS_LOSS_CTGRY.LOSS_CAT_DES%TYPE;
    v_net_ret           NUMBER(16,2);
    v_facultative       NUMBER(16,2);
    v_treaty            NUMBER(16,2);
    v_xol_treaty        NUMBER(16,2);
    v_total_net_ret     NUMBER(16,2);
    v_total_treaty      NUMBER(16,2);
    v_total_xol_treaty  NUMBER(16,2);
    v_total_facultative NUMBER(16,2);
    v_total_os_loss     NUMBER(16,2);
    v_tran_date         VARCHAR2(500);
    v_check_no          VARCHAR2(1000);
    v_clm_stat          VARCHAR2(50);
    
    BEGIN
      v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
      
      FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR209A')
      LOOP
        utl_file.put_line(v_file,'"'||i.report_title||'"');
        EXIT;
      END LOOP;
    
      FOR i IN (SELECT DISTINCT from_date, to_date,
                       DECODE(pd_date_opt, 1, 'Transaction Date', 2, 'Posting Date') opt
                  FROM gicl_res_brdrx_extr
                 WHERE session_id = p_session_id)
      LOOP
        utl_file.put_line(v_file, '"Based on '||i.opt||'"');
        utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                                 ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
        utl_file.put_line(v_file, ' ');
        EXIT;
      END LOOP;
    
      IF p_intm_break = 1 THEN
        v_headers := 'INTERMEDIARY,';
      END IF;
      IF p_iss_break = 1 THEN
        v_headers := v_headers||'BRANCH,';
      END IF; 
      v_headers := v_headers||'LINE, CLAIM NUMBER, POLICY NUMBER, CLAIM FILE DATE,'||
                   'EFFECTIVITY DATE, LOSS DATE, ASSURED, NATURE OF LOSS, PAID LOSS, NET RETENTION, FACULTATIVE, PROPORTIONAL TREATY, NON-PROPORTIONAL TREATY,'||
                   'DATE PAID,CHECK NUMBER, CLAIM STATUS';
      utl_file.put_line(v_file,v_headers); 
      
      FOR rec IN (SELECT  A.BRDRX_RECORD_ID,
                          A.BUSS_SOURCE,
                          A.ISS_CD,
                          A.LINE_CD,
                          A.SUBLINE_CD,
                          A.CLAIM_ID,
                          A.ASSD_NO,
                          A.CLAIM_NO,
                          A.POLICY_NO,
                          A.CLM_FILE_DATE, 
                          A.LOSS_DATE,
                          A.LOSS_CAT_CD,
                          A.INTM_NO,
                          A.CLM_LOSS_ID,
                          A.PD_DATE_OPT,
                          A.FROM_DATE,
                          A.TO_DATE,
                          NVL(A.LOSSES_PAID,0) OUTSTANDING_LOSS
                     FROM GICL_RES_BRDRX_EXTR A
                    WHERE A.SESSION_ID = P_SESSION_ID 
                      AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                      AND NVL(A.LOSSES_PAID,0) > 0 
                 ORDER BY DECODE(P_INTM_BREAK, 1, INTM_NO, 1),
                          DECODE(P_ISS_BREAK, 1, ISS_CD, 1),
                          LINE_CD)
      LOOP
        v_columns := null;
        v_tran_date := null;
        v_check_no := null;
        v_clm_stat := null;
        v_net_ret := 0;
        v_facultative := 0;
        v_treaty := 0;
        v_xol_treaty := 0;
        
        FOR i IN (SELECT intm_name
                    FROM giis_intermediary
                   WHERE intm_no = rec.intm_no)
        LOOP
          v_intm_name := i.intm_name;
        END LOOP;  
        
        FOR b IN (SELECT iss_name
                    FROM giis_issource
                   WHERE iss_cd = rec.iss_cd)
        LOOP
          v_iss_name := b.iss_name;
        END LOOP; 
        
        FOR l IN (SELECT line_name
                    FROM giis_line
                   WHERE line_cd = rec.line_cd)
        LOOP
          v_line_name := l.line_name;
        END LOOP;
        
        FOR f IN (SELECT pol_eff_date
                    FROM gicl_claims
                   WHERE claim_id = rec.claim_id)
        LOOP
          v_eff_date := f.pol_eff_date;
        END LOOP;
        
        FOR a IN (SELECT assd_name
                    FROM giis_assured
                   WHERE assd_no = rec.assd_no)
        LOOP
          v_assd_name := a.assd_name;
        END LOOP;   
        
        FOR c IN (SELECT loss_cat_des
                    FROM giis_loss_ctgry
                   WHERE line_cd = rec.line_cd
                     AND loss_cat_cd = rec.loss_cat_cd)
        LOOP
          v_loss_cat_des := c.loss_cat_des;
        END LOOP;
        
        FOR I IN (SELECT NVL(A.LOSSES_PAID,0) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 1)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND NVL(A.LOSSES_PAID,0) > 0) 
        LOOP
          v_net_ret :=  i.outstanding_loss + v_net_ret;
        END LOOP;
        
        FOR I IN (SELECT NVL(A.LOSSES_PAID,0) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 3)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND NVL(A.LOSSES_PAID,0) > 0) 
        LOOP
          v_facultative :=  i.outstanding_loss + v_facultative;
        END LOOP;
        
        FOR I IN (SELECT NVL(A.LOSSES_PAID,0) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 2)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND NVL(A.LOSSES_PAID,0) > 0) 
        LOOP
          v_treaty :=  i.outstanding_loss + v_treaty;
        END LOOP;
        
        FOR I IN (SELECT NVL(A.LOSSES_PAID,0) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 4)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND NVL(A.LOSSES_PAID,0) > 0) 
        LOOP
          v_xol_treaty :=  i.outstanding_loss + v_xol_treaty;
        END LOOP;
        
        IF sign(nvl(rec.outstanding_loss, 0)) < 1 THEN  
           FOR d1 IN (SELECT TO_CHAR(a.date_paid,'MM-DD-RRRR') tran_date, 
                             TO_CHAR(a.cancel_date,'MM-DD-RRRR') cancel_date
                        FROM gicl_clm_res_hist a, 
                             giac_acctrans b, 
                             giac_reversals c 
                       WHERE a.tran_id = c.gacc_tran_id
                         AND b.tran_id = c.reversing_tran_id 
                         AND a.claim_id = rec.claim_id
                         AND a.clm_loss_id = rec.clm_loss_id
                    GROUP BY a.date_paid, a.cancel_date 
                      HAVING SUM(a.losses_paid) > 0)
           LOOP
             IF v_tran_date IS NULL THEN
                v_tran_date := d1.tran_date;
             ELSE
                v_tran_date := d1.tran_date||'/'||v_tran_date;   
             END IF;
           END LOOP;
        ELSE 
           FOR d2 IN (SELECT TO_CHAR(a.date_paid,'MM-DD-RRRR') tran_date
                        FROM gicl_clm_res_hist a, giac_acctrans b 
                       WHERE a.claim_id = rec.claim_id
                         AND a.clm_loss_id = rec.clm_loss_id
                         AND a.tran_id = b.tran_id
                         AND DECODE(rec.pd_date_opt,1,TRUNC(a.date_paid),2,TRUNC(b.posting_date))
                             BETWEEN rec.from_date AND rec.to_date
                    GROUP BY a.date_paid
                      HAVING SUM(a.losses_paid) > 0)   
           LOOP
             IF v_tran_date IS NULL THEN
                v_tran_date := d2.tran_date;
             ELSE
                v_tran_date := d2.tran_date||'/'||v_tran_date;   
              END IF;
           END LOOP;       
        END IF;
        
        IF sign(nvl(rec.outstanding_loss, 0)) < 1 THEN  
           FOR c1 IN (SELECT DISTINCT b.check_pref_suf||'-'||
                                      LTRIM(TO_CHAR(b.check_no,'0999999999')) check_no,
                                      TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                                 FROM gicl_clm_res_hist a, giac_chk_disbursement b, 
                                      giac_acctrans c, giac_reversals d 
                                WHERE a.tran_id = b.gacc_tran_id
                                  AND a.tran_id = d.gacc_tran_id
                                  AND c.tran_id = d.reversing_tran_id 
                                  AND a.claim_id = rec.claim_id
                                  AND a.clm_loss_id = rec.clm_loss_id
                             GROUP BY b.check_pref_suf, b.check_no, a.cancel_date
                               HAVING SUM(a.losses_paid) > 0)
           LOOP
             IF v_check_no IS NULL THEN
                v_check_no := c1.check_no||'/'||'cancelled '||c1.cancel_date;
             ELSE
                v_check_no := c1.check_no||'/'||'cancelled '||c1.cancel_date||'/'||v_check_no;   
             END IF;
           END LOOP;
        ELSE 
           FOR c2 IN (SELECT DISTINCT b.check_pref_suf||'-'||
                                      LTRIM(TO_CHAR(b.check_no,'0999999999')) check_no
                                 FROM gicl_clm_res_hist a, giac_chk_disbursement b, giac_disb_vouchers c,
                                      giac_direct_claim_payts d, giac_acctrans e
                                WHERE a.tran_id = e.tran_id    
                                  AND b.gacc_tran_id = c.gacc_tran_id
                                  AND b.gacc_tran_id = d.gacc_tran_id(+)  
                                  AND b.gacc_tran_id = e.tran_id
                                  AND a.claim_id = rec.claim_id
                                  AND a.clm_loss_id = rec.clm_loss_id 
                                  AND DECODE(rec.pd_date_opt,1,TRUNC(a.date_paid),2,TRUNC(e.posting_date)) 
                                      BETWEEN rec.from_date AND rec.to_date
                             GROUP BY b.check_pref_suf, b.check_no
                               HAVING SUM(a.losses_paid) > 0)    
           LOOP
             IF v_check_no IS NULL THEN
                v_check_no := c2.check_no;
             ELSE
                v_check_no := c2.check_no||'/'||v_check_no;   
             END IF;
           END LOOP;      
        END IF;
        
        FOR f IN (SELECT a.item_stat_cd
                    FROM gicl_clm_loss_exp a, gicl_item_peril b, gicl_clm_res_hist c
                   WHERE a.claim_id = b.claim_id
                     AND a.item_no = b.item_no
                     AND a.peril_cd = b.peril_cd
                     AND a.claim_id = c.claim_id
                     AND a.clm_loss_id = c.clm_loss_id 
                     AND a.payee_type = 'L' 
                     AND a.claim_id = rec.claim_id
                     AND a.clm_loss_id = rec.clm_loss_id
                     AND b.loss_cat_cd IN (SELECT loss_cat_cd 
                                             FROM gicl_res_brdrx_extr
                                            WHERE session_id = p_session_id
                                              AND claim_id = rec.claim_id
                                              AND brdrx_record_id = rec.brdrx_record_id
                                              AND peril_cd = a.peril_cd))
        LOOP
          IF v_clm_stat IS NULL THEN
             v_clm_stat := f.item_stat_cd;
          ELSE
             v_clm_stat := f.item_stat_cd||'/'||v_clm_stat;
          END IF;
        END LOOP;
        
        IF p_intm_break = 1 THEN
           v_columns := '"'||v_intm_name||'",';
        END IF;
        
        IF p_iss_break = 1 THEN
           v_columns := v_columns||'"'||v_iss_name||'",';
        END IF;
        
        v_columns := v_columns||
                     '"'||v_line_name||'","'||rec.claim_no||'","'||rec.policy_no||
                     '",'||rec.clm_file_date||','||v_eff_date||','||rec.loss_date||
                     ',"'||v_assd_name||'","'||v_loss_cat_des||'",'||nvl(rec.outstanding_loss, 0)||
                     ','||v_net_ret||','||v_facultative||','||v_treaty||','||v_xol_treaty||
                     ',"'||v_tran_date||'","'||v_check_no||'","'||v_clm_stat||'"';
        utl_file.put_line(v_file,v_columns);
        v_total_os_loss := nvl(v_total_os_loss, 0) + nvl(rec.outstanding_loss, 0);
        v_total_net_ret := nvl(v_total_net_ret, 0) + v_net_ret;
        v_total_facultative := nvl(v_total_facultative, 0) + v_facultative;
        v_total_treaty := nvl(v_total_treaty, 0) + v_treaty;
        v_total_xol_treaty := nvl(v_total_xol_treaty, 0) + v_xol_treaty;        
      END LOOP;
      
      IF p_intm_break = 1 THEN
         v_totals := ',';
      END IF;
      
      IF p_iss_break = 1 THEN
         v_totals := v_totals||',';
      END IF;
      
      v_totals := v_totals||
                  ',,,,,,,TOTALS,'||
                  v_total_os_loss||','||
                  v_total_net_ret||','||
                  v_total_facultative||','||
                  v_total_treaty||','||
                  v_total_xol_treaty;
      utl_file.put_line(v_file,v_totals);   
      utl_file.fclose(v_file);             
    END;
 
  ----------------------------------------------------------------------------------------------------- 
  PROCEDURE CSV_GICLR209B(p_session_id   VARCHAR2,
                          p_claim_id     VARCHAR2,
                          p_intm_break   NUMBER,
                          p_iss_break    NUMBER,
                          p_file_name    VARCHAR2)
  IS
    v_file              UTL_FILE.FILE_TYPE;
    v_columns           VARCHAR2(32767);
    v_headers           VARCHAR2(32767);
    v_totals            VARCHAR2(32767);
    v_intm_name         GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name         GIIS_LINE.LINE_NAME%TYPE;
    v_eff_date          GICL_CLAIMS.POL_EFF_DATE%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_loss_cat_des      GIIS_LOSS_CTGRY.LOSS_CAT_DES%TYPE;
    v_net_ret           NUMBER(16,2);
    v_facultative       NUMBER(16,2);
    v_treaty            NUMBER(16,2);
    v_xol_treaty        NUMBER(16,2);
    v_total_net_ret     NUMBER(16,2);
    v_total_treaty      NUMBER(16,2);
    v_total_xol_treaty  NUMBER(16,2);
    v_total_facultative NUMBER(16,2);
    v_total_os_loss     NUMBER(16,2);
    v_tran_date         VARCHAR2(500);
    v_check_no          VARCHAR2(1000);
    v_clm_stat          VARCHAR2(50);
    
    BEGIN
      v_file := utl_file.fopen('EXCEL_REPORTS', p_file_name, 'W');
      
      FOR i IN (SELECT report_title
                FROM giis_reports
               WHERE report_id = 'GICLR209B')
      LOOP
        utl_file.put_line(v_file,'"'||i.report_title||'"');
        EXIT;
      END LOOP;
    
      FOR i IN (SELECT DISTINCT from_date, to_date,
                       DECODE(pd_date_opt, 1, 'Transaction Date', 2, 'Posting Date') opt
                  FROM gicl_res_brdrx_extr
                 WHERE session_id = p_session_id)
      LOOP
        utl_file.put_line(v_file, '"Based on '||i.opt||'"');
        utl_file.put_line(v_file,'"From '||to_char(i.from_date,'fmMonth DD, YYYY')
                                 ||' to '||to_char(i.to_date,'fmMonth DD, YYYY')||'"');
        utl_file.put_line(v_file, ' ');
        EXIT;
      END LOOP;
      
      IF p_intm_break = 1 THEN
        v_headers := 'INTERMEDIARY,';
      END IF;
      IF p_iss_break = 1 THEN
        v_headers := v_headers||'BRANCH,';
      END IF; 
      v_headers := v_headers||'LINE, CLAIM NUMBER, POLICY NUMBER, CLAIM FILE DATE,'||
                   'EFFECTIVITY DATE, LOSS DATE, ASSURED, NATURE OF LOSS, PAID EXPENSE, NET RETENTION, FACULTATIVE, PROPORTIONAL TREATY, NON-PROPORTIONAL TREATY,'||
                   'DATE PAID,CHECK NUMBER, CLAIM STATUS';
      utl_file.put_line(v_file,v_headers); 
      
      FOR rec IN (SELECT  A.BRDRX_RECORD_ID,
                          A.BUSS_SOURCE,
                          A.ISS_CD,
                          A.LINE_CD,
                          A.SUBLINE_CD,
                          A.CLAIM_ID,
                          A.ASSD_NO,
                          A.CLAIM_NO,
                          A.POLICY_NO,
                          A.CLM_FILE_DATE, 
                          A.LOSS_DATE,
                          A.LOSS_CAT_CD,
                          A.INTM_NO,
                          A.CLM_LOSS_ID,
                          A.PD_DATE_OPT,
                          A.FROM_DATE,
                          A.TO_DATE,
                          NVL(A.EXPENSES_PAID,0) OUTSTANDING_LOSS
                     FROM GICL_RES_BRDRX_EXTR A
                    WHERE A.SESSION_ID = P_SESSION_ID 
                      AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID) 
                      AND NVL(A.EXPENSES_PAID,0) > 0 
                 ORDER BY DECODE(P_INTM_BREAK, 1, INTM_NO, 1),
                          DECODE(P_ISS_BREAK, 1, ISS_CD, 1),
                          LINE_CD)
      LOOP
        v_columns := null;
        v_tran_date := null;
        v_check_no := null;
        v_clm_stat := null;
        v_net_ret := 0;
        v_facultative := 0;
        v_treaty := 0;
        v_xol_treaty := 0;
        
        FOR i IN (SELECT intm_name
                    FROM giis_intermediary
                   WHERE intm_no = rec.intm_no)
        LOOP
          v_intm_name := i.intm_name;
        END LOOP;  
        
        FOR b IN (SELECT iss_name
                    FROM giis_issource
                   WHERE iss_cd = rec.iss_cd)
        LOOP
          v_iss_name := b.iss_name;
        END LOOP; 
        
        FOR l IN (SELECT line_name
                    FROM giis_line
                   WHERE line_cd = rec.line_cd)
        LOOP
          v_line_name := l.line_name;
        END LOOP;
        
        FOR f IN (SELECT pol_eff_date
                    FROM gicl_claims
                   WHERE claim_id = rec.claim_id)
        LOOP
          v_eff_date := f.pol_eff_date;
        END LOOP;
        
        FOR a IN (SELECT assd_name
                    FROM giis_assured
                   WHERE assd_no = rec.assd_no)
        LOOP
          v_assd_name := a.assd_name;
        END LOOP;   
        
        FOR c IN (SELECT loss_cat_des
                    FROM giis_loss_ctgry
                   WHERE line_cd = rec.line_cd
                     AND loss_cat_cd = rec.loss_cat_cd)
        LOOP
          v_loss_cat_des := c.loss_cat_des;
        END LOOP;
        
        FOR I IN (SELECT NVL(A.EXPENSES_PAID,0) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 1)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND NVL(A.EXPENSES_PAID,0) > 0) 
        LOOP
          v_net_ret :=  i.outstanding_loss + v_net_ret;
        END LOOP;
        
        FOR I IN (SELECT NVL(A.EXPENSES_PAID,0) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 3)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND NVL(A.EXPENSES_PAID,0) > 0) 
        LOOP
          v_facultative :=  i.outstanding_loss + v_facultative;
        END LOOP;
        
        FOR I IN (SELECT NVL(A.EXPENSES_PAID,0) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 2)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND NVL(A.EXPENSES_PAID,0) > 0) 
        LOOP
          v_treaty :=  i.outstanding_loss + v_treaty;
        END LOOP;
        
        FOR I IN (SELECT NVL(A.EXPENSES_PAID,0) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE A.SESSION_ID = P_SESSION_ID
                     AND a.loss_cat_cd = rec.loss_cat_cd 
                     AND a.grp_seq_no in (SELECT a.share_cd
                                            FROM giis_dist_share a
                                           WHERE a.line_cd = rec.line_cd
                                             AND a.share_type = 4)
                     AND A.CLAIM_ID = NVL(rec.CLAIM_ID,A.CLAIM_ID)
                     AND NVL(A.EXPENSES_PAID,0) > 0) 
        LOOP
          v_xol_treaty :=  i.outstanding_loss + v_xol_treaty;
        END LOOP;
        
        IF sign(nvl(rec.outstanding_loss, 0)) < 1 THEN  
           FOR d1 IN (SELECT TO_CHAR(a.date_paid,'MM-DD-RRRR') tran_date, 
                             TO_CHAR(a.cancel_date,'MM-DD-RRRR') cancel_date
                        FROM gicl_clm_res_hist a, 
                             giac_acctrans b, 
                             giac_reversals c 
                       WHERE a.tran_id = c.gacc_tran_id
                         AND b.tran_id = c.reversing_tran_id 
                         AND a.claim_id = rec.claim_id
                         AND a.clm_loss_id = rec.clm_loss_id
                    GROUP BY a.date_paid, a.cancel_date 
                      HAVING SUM(a.expenses_paid) > 0)
           LOOP
             IF v_tran_date IS NULL THEN
                v_tran_date := d1.tran_date;
             ELSE
                v_tran_date := d1.tran_date||'/'||v_tran_date;   
             END IF;
           END LOOP;
        ELSE 
           FOR d2 IN (SELECT TO_CHAR(a.date_paid,'MM-DD-RRRR') tran_date
                        FROM gicl_clm_res_hist a, giac_acctrans b 
                       WHERE a.claim_id = rec.claim_id
                         AND a.clm_loss_id = rec.clm_loss_id
                         AND a.tran_id = b.tran_id
                         AND DECODE(rec.pd_date_opt,1,TRUNC(a.date_paid),2,TRUNC(b.posting_date))
                             BETWEEN rec.from_date AND rec.to_date
                    GROUP BY a.date_paid
                      HAVING SUM(a.expenses_paid) > 0)   
           LOOP
             IF v_tran_date IS NULL THEN
                v_tran_date := d2.tran_date;
             ELSE
                v_tran_date := d2.tran_date||'/'||v_tran_date;   
              END IF;
           END LOOP;       
        END IF;
        
        IF sign(nvl(rec.outstanding_loss, 0)) < 1 THEN  
           FOR c1 IN (SELECT DISTINCT b.check_pref_suf||'-'||
                                      LTRIM(TO_CHAR(b.check_no,'0999999999')) check_no,
                                      TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                                 FROM gicl_clm_res_hist a, giac_chk_disbursement b, 
                                      giac_acctrans c, giac_reversals d 
                                WHERE a.tran_id = b.gacc_tran_id
                                  AND a.tran_id = d.gacc_tran_id
                                  AND c.tran_id = d.reversing_tran_id 
                                  AND a.claim_id = rec.claim_id
                                  AND a.clm_loss_id = rec.clm_loss_id
                             GROUP BY b.check_pref_suf, b.check_no, a.cancel_date
                               HAVING SUM(a.expenses_paid) > 0)
           LOOP
             IF v_check_no IS NULL THEN
                v_check_no := c1.check_no||'/'||'cancelled '||c1.cancel_date;
             ELSE
                v_check_no := c1.check_no||'/'||'cancelled '||c1.cancel_date||'/'||v_check_no;   
             END IF;
           END LOOP;
        ELSE 
           FOR c2 IN (SELECT DISTINCT b.check_pref_suf||'-'||
                                      LTRIM(TO_CHAR(b.check_no,'0999999999')) check_no
                                 FROM gicl_clm_res_hist a, giac_chk_disbursement b, giac_disb_vouchers c,
                                      giac_direct_claim_payts d, giac_acctrans e
                                WHERE a.tran_id = e.tran_id    
                                  AND b.gacc_tran_id = c.gacc_tran_id
                                  AND b.gacc_tran_id = d.gacc_tran_id(+)  
                                  AND b.gacc_tran_id = e.tran_id
                                  AND a.claim_id = rec.claim_id
                                  AND a.clm_loss_id = rec.clm_loss_id 
                                  AND DECODE(rec.pd_date_opt,1,TRUNC(a.date_paid),2,TRUNC(e.posting_date)) 
                                      BETWEEN rec.from_date AND rec.to_date
                             GROUP BY b.check_pref_suf, b.check_no
                               HAVING SUM(a.expenses_paid) > 0)    
           LOOP
             IF v_check_no IS NULL THEN
                v_check_no := c2.check_no;
             ELSE
                v_check_no := c2.check_no||'/'||v_check_no;   
             END IF;
           END LOOP;      
        END IF;
        
        FOR f IN (SELECT a.item_stat_cd
                    FROM gicl_clm_loss_exp a, gicl_item_peril b, gicl_clm_res_hist c
                   WHERE a.claim_id = b.claim_id
                     AND a.item_no = b.item_no
                     AND a.peril_cd = b.peril_cd
                     AND a.claim_id = c.claim_id
                     AND a.clm_loss_id = c.clm_loss_id 
                     AND a.payee_type = 'E' 
                     AND a.claim_id = rec.claim_id
                     AND a.clm_loss_id = rec.clm_loss_id
                     AND b.loss_cat_cd IN (SELECT loss_cat_cd 
                                             FROM gicl_res_brdrx_extr
                                            WHERE session_id = p_session_id
                                              AND claim_id = rec.claim_id
                                              AND brdrx_record_id = rec.brdrx_record_id
                                              AND peril_cd = a.peril_cd))
        LOOP
          IF v_clm_stat IS NULL THEN
             v_clm_stat := f.item_stat_cd;
          ELSE
             v_clm_stat := f.item_stat_cd||'/'||v_clm_stat;
          END IF;
        END LOOP;
        
        IF p_intm_break = 1 THEN
           v_columns := '"'||v_intm_name||'",';
        END IF;
        
        IF p_iss_break = 1 THEN
           v_columns := v_columns||'"'||v_iss_name||'",';
        END IF;
        
        v_columns := v_columns||
                     '"'||v_line_name||'","'||rec.claim_no||'","'||rec.policy_no||
                     '",'||rec.clm_file_date||','||v_eff_date||','||rec.loss_date||
                     ',"'||v_assd_name||'","'||v_loss_cat_des||'",'||nvl(rec.outstanding_loss, 0)||
                     ','||v_net_ret||','||v_facultative||','||v_treaty||','||v_xol_treaty||
                     ',"'||v_tran_date||'","'||v_check_no||'","'||v_clm_stat||'"';
        utl_file.put_line(v_file,v_columns);
        v_total_os_loss := nvl(v_total_os_loss, 0) + nvl(rec.outstanding_loss, 0);
        v_total_net_ret := nvl(v_total_net_ret, 0) + v_net_ret;
        v_total_facultative := nvl(v_total_facultative, 0) + v_facultative;
        v_total_treaty := nvl(v_total_treaty, 0) + v_treaty;
        v_total_xol_treaty := nvl(v_total_xol_treaty, 0) + v_xol_treaty;        
      END LOOP;
      
      IF p_intm_break = 1 THEN
         v_totals := ',';
      END IF;
      
      IF p_iss_break = 1 THEN
         v_totals := v_totals||',';
      END IF;
      
      v_totals := v_totals||
                  ',,,,,,,TOTALS,'||
                  v_total_os_loss||','||
                  v_total_net_ret||','||
                  v_total_facultative||','||
                  v_total_treaty||','||
                  v_total_xol_treaty;
      utl_file.put_line(v_file,v_totals);   
      utl_file.fclose(v_file);             
    
    END;
 
  -----------------------------------------------------------------------------------------------------           
END;
/


