CREATE OR REPLACE PACKAGE BODY CPI.GICLR205ER_PKG
AS
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 04.08.2013
   **  Reference By : GILR205ER - Outstanding Bordereaux (Expenses)
   */
   FUNCTION cf_company_name
      RETURN VARCHAR2
   IS
      v_name   GIAC_PARAMETERS.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_name
        FROM GIAC_PARAMETERS
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_name);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (NULL);
   END cf_company_name;

   FUNCTION cf_company_address
      RETURN VARCHAR2
   IS
      v_add   GIIS_PARAMETERS.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_add
        FROM GIIS_PARAMETERS
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_add);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (NULL);
   END cf_company_address;

   FUNCTION cf_report_name
      RETURN VARCHAR2
   IS
      v_report_title   GIIS_REPORTS.report_title%TYPE;
   BEGIN
      BEGIN
         SELECT report_title
           INTO v_report_title
           FROM GIIS_REPORTS
          WHERE report_id = 'GICLR205E';
      END;

      RETURN v_report_title;
   END cf_report_name;

    FUNCTION cf_paramdate(
        p_os_date   VARCHAR2
    )
       RETURN VARCHAR2
    IS
       v_param   VARCHAR2 (100);
    BEGIN
       BEGIN
          SELECT DECODE (p_os_date,
                         1, 'Loss Date',
                         2, 'Claim File Date',
                         3, 'Booking Month'
                        )
            INTO v_param
            FROM DUAL;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_param := NULL;
       END;

       RETURN ('(Based on ' || v_param || ')');
    END cf_paramdate;

   FUNCTION cf_report_date (
      p_from_date     DATE,
      p_to_date       DATE,
      p_as_of_date    DATE,
      p_date_option   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_date   VARCHAR2 (100);
   BEGIN
      IF p_date_option = 1
      THEN
         BEGIN
            SELECT    'from '
                   || TO_CHAR (p_from_date, 'fmMonth DD, YYYY')
                   || ' to '
                   || TO_CHAR (p_to_date, 'fmMonth DD, YYYY')
              INTO v_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_date := NULL;
         END;
      ELSIF p_date_option = 2
      THEN
         BEGIN
            SELECT 'as of ' || TO_CHAR (p_as_of_date, 'fmMonth DD, YYYY')
              INTO v_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_date := NULL;
         END;
      END IF;

      RETURN (v_date);
   END cf_report_date;
   
   FUNCTION intm_desc (p_buss_source_type VARCHAR2)
      RETURN VARCHAR2
   IS
      v_source_type_desc   GIIS_INTM_TYPE.intm_desc%TYPE;
   BEGIN
      BEGIN
         SELECT intm_desc
           INTO v_source_type_desc
           FROM GIIS_INTM_TYPE
          WHERE intm_type = p_buss_source_type;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_source_type_desc := 'REINSURER ';
         WHEN OTHERS
         THEN
            v_source_type_desc := NULL;
      END;

      RETURN v_source_type_desc;
   END intm_desc;

   FUNCTION source_name (
      p_buss_source   GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_type      VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_source_name   GIIS_INTERMEDIARY.intm_name%TYPE;
   BEGIN
      IF p_iss_type = 'RI'
      THEN
         BEGIN
            SELECT ri_name
              INTO v_source_name
              FROM GIIS_REINSURER
             WHERE ri_cd = p_buss_source;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_source_name := NULL;
         END;
      ELSE
         BEGIN
            SELECT intm_name
              INTO v_source_name
              FROM GIIS_INTERMEDIARY
             WHERE intm_no = p_buss_source;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_source_name := NULL;
         END;
      END IF;

      RETURN v_source_name;
   END source_name;

   FUNCTION iss_name (
      p_iss_cd     GIIS_ISSOURCE.iss_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_iss_name   GIIS_ISSOURCE.iss_name%TYPE;
   BEGIN
      BEGIN
         SELECT iss_name
           INTO v_iss_name
           FROM GIIS_ISSOURCE
          WHERE iss_cd = p_iss_cd;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_iss_name := NULL;
      END;

      RETURN v_iss_name;
   END iss_name;

   FUNCTION line_name (
      p_line_cd     GIIS_LINE.line_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_line_name   GIIS_LINE.line_name%TYPE;
   BEGIN
      BEGIN
         SELECT line_name
           INTO v_line_name
           FROM GIIS_LINE
          WHERE line_cd = p_line_cd;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_line_name := NULL;
      END;

      RETURN v_line_name;
   END line_name;

   FUNCTION subline_name (
      p_subline_cd   GIIS_SUBLINE.subline_cd%TYPE,
      p_line_cd      GIIS_LINE.line_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_subline_name   GIIS_SUBLINE.subline_name%TYPE;
   BEGIN
      BEGIN
         SELECT subline_name
           INTO v_subline_name
           FROM GIIS_SUBLINE
          WHERE subline_cd = p_subline_cd AND line_cd = p_line_cd;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_subline_name := NULL;
      END;

      RETURN v_subline_name;
   END subline_name;

   FUNCTION cf_policy (
      p_claim_id    GICL_CLAIMS.claim_id%TYPE,
      p_policy_no   GICL_RES_BRDRX_EXTR.policy_no%TYPE
   )
      RETURN CHAR
   IS
      v_policy       VARCHAR2 (60);
      v_ref_pol_no   GIPI_POLBASIC.ref_pol_no%TYPE;
   BEGIN
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
            AND a.claim_id = p_claim_id
            AND ref_pol_no IS NOT NULL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_ref_pol_no := NULL;
      END;

      IF v_ref_pol_no IS NOT NULL
      THEN
         v_policy := p_policy_no || '/' || CHR (10) || v_ref_pol_no;
      ELSE
         v_policy := p_policy_no;
      END IF;

      RETURN (v_policy);
   END cf_policy;

   FUNCTION assd_name (
      p_assd_no     GICL_RES_BRDRX_EXTR.assd_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_assd_name   GIIS_ASSURED.assd_name%TYPE;
   BEGIN
      BEGIN
         SELECT assd_name
           INTO v_assd_name
           FROM GIIS_ASSURED
          WHERE assd_no = p_assd_no;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_assd_name := ' ';
      END;

      RETURN v_assd_name;
   END assd_name;

   FUNCTION peril_name (
      p_peril_cd   GIIS_PERIL.peril_cd%TYPE,
      p_line_cd    GIIS_LINE.line_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_peril_name   GIIS_PERIL.peril_name%TYPE;
   BEGIN
      BEGIN
         SELECT peril_name
           INTO v_peril_name
           FROM GIIS_PERIL
          WHERE peril_cd = p_peril_cd AND line_cd = p_line_cd;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_peril_name := NULL;
      END;

      RETURN v_peril_name;
   END peril_name;

    FUNCTION cf_intm_ri(
      p_session_id  GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id    GICL_CLAIMS.claim_id%TYPE,
      p_intm_break  VARCHAR2,
      p_item_no     GICL_RES_BRDRX_EXTR.item_no%TYPE,
      p_peril_cd    GIIS_PERIL.peril_cd%TYPE,
      p_intm_no     GICL_RES_BRDRX_EXTR.intm_no%TYPE
    )
       RETURN VARCHAR2
    IS
       v_pol_iss_cd   GICL_CLAIMS.pol_iss_cd%TYPE;
       v_intm_ri      VARCHAR2 (1000);
    BEGIN
       BEGIN
          SELECT pol_iss_cd
            INTO v_pol_iss_cd
            FROM GICL_CLAIMS
           WHERE claim_id = p_claim_id;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_pol_iss_cd := NULL;
       END;

       IF v_pol_iss_cd = GIACP.v ('RI_ISS_CD')
       THEN
          BEGIN
             FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                         FROM GICL_CLAIMS a, GIIS_REINSURER b
                        WHERE a.ri_cd = b.ri_cd AND a.claim_id = p_claim_id)
             LOOP
                v_intm_ri := TO_CHAR (r.ri_cd) || CHR (10) || r.ri_name;
             END LOOP;
          END;
       ELSE
          IF p_intm_break = 1
          THEN
             BEGIN
                FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                                 b.ref_intm_cd ref_intm_cd
                            FROM GICL_RES_BRDRX_EXTR a, GIIS_INTERMEDIARY b
                           WHERE a.intm_no = b.intm_no
                             AND a.session_id = p_session_id
                             AND a.claim_id = p_claim_id
                             AND a.item_no = p_item_no
                             AND a.peril_cd = p_peril_cd
                             AND a.intm_no = p_intm_no)
                LOOP
                   v_intm_ri :=
                         TO_CHAR (i.intm_no)
                      || '/'
                      || i.ref_intm_cd
                      || CHR (10)
                      || i.intm_name;
                END LOOP;
             END;
          ELSIF p_intm_break = 0
          THEN
             BEGIN
                FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                            FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                           WHERE a.intm_no = b.intm_no
                             AND a.claim_id = p_claim_id
                             AND a.item_no = p_item_no
                             AND a.peril_cd = p_peril_cd)
                LOOP
                   v_intm_ri :=
                         TO_CHAR (m.intm_no)
                      || '/'
                      || m.ref_intm_cd
                      || CHR (10)
                      || m.intm_name
                      || CHR (10)
                      || v_intm_ri;
                END LOOP;
             END;
          END IF;
       END IF;

       RETURN (v_intm_ri);
    END;

   FUNCTION treaty_name (
      p_grp_seq_no   GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_line_cd3     GIIS_LINE.line_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_trty_name   GIIS_DIST_SHARE.trty_name%TYPE;
   BEGIN
      BEGIN
         SELECT trty_name
           INTO v_trty_name
           FROM GIIS_DIST_SHARE
          WHERE share_cd = p_grp_seq_no AND line_cd = p_line_cd3;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_trty_name := NULL;
      END;

      RETURN v_trty_name;
   END treaty_name;

   FUNCTION facul_ri_name (
      p_facul_ri_cd   GICL_RES_BRDRX_RIDS_EXTR.prnt_ri_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_ri_name   GIIS_REINSURER.ri_name%TYPE;
   BEGIN
      BEGIN
         SELECT ri_sname
           INTO v_ri_name
           FROM GIIS_REINSURER
          WHERE ri_cd = p_facul_ri_cd; 
      EXCEPTION
         WHEN OTHERS
         THEN
            v_ri_name := NULL;
      END;

      RETURN v_ri_name;
   END facul_ri_name;

   FUNCTION treaty_name2 (
      p_grp_seq_no3   GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_line_cd4      GIIS_LINE.line_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_trty_name   GIIS_DIST_SHARE.trty_name%TYPE;
   BEGIN
      BEGIN
         SELECT trty_name
           INTO v_trty_name
           FROM GIIS_DIST_SHARE
          WHERE share_cd = p_grp_seq_no3 AND line_cd = p_line_cd4;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_trty_name := NULL;
      END;

      RETURN v_trty_name;
   END treaty_name2;

   FUNCTION ri_name (
      p_ri_cd GIIS_REINSURER.ri_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_ri_name   GIIS_REINSURER.ri_name%TYPE;
   BEGIN
      BEGIN
         SELECT ri_sname
           INTO v_ri_name
           FROM GIIS_REINSURER
          WHERE ri_cd = p_ri_cd;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_ri_name := NULL;
      END;

      RETURN v_ri_name;
   END ri_name;

   FUNCTION ri_shr (
      p_grp_seq_no3   GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_line_cd4      GIIS_LINE.line_cd%TYPE,
      p_ri_cd         GIIS_REINSURER.ri_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_shr_pct   GIIS_TRTY_PANEL.trty_shr_pct%TYPE;
   BEGIN
      FOR shr IN (SELECT trty_shr_pct
                    FROM GIIS_TRTY_PANEL
                   WHERE line_cd = p_line_cd4
                     AND trty_seq_no = p_grp_seq_no3
                     AND ri_cd = p_ri_cd)
      LOOP
         v_shr_pct := shr.trty_shr_pct;
      END LOOP;

      RETURN (v_shr_pct);
   END ri_shr;
   
   FUNCTION report_format_trigger(
        p_session_id    GICL_RES_BRDRX_EXTR.session_id%TYPE,
        p_claim_id      GICL_RES_BRDRX_EXTR.claim_id%TYPE
    )
        RETURN VARCHAR2 
    IS
        v_exist        VARCHAR2(10);
    BEGIN
       SELECT DISTINCT 'X'
                  INTO v_exist
                  FROM GICL_RES_BRDRX_EXTR a
                 WHERE a.session_id = p_session_id
                   AND a.claim_id = NVL (p_claim_id, a.claim_id)
                   AND (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0;

       IF v_exist IS NOT NULL
       THEN
          v_exist := 'TRUE';
       ELSE
          v_exist := 'FALSE';
       END IF;

       RETURN (v_exist);
    EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
       v_exist := NULL;
    END report_format_trigger;
    
    FUNCTION cf_outstaning_loss8(
        p_session_id            GICL_RES_BRDRX_EXTR.session_id%TYPE,
        p_claim_id              GICL_RES_BRDRX_EXTR.claim_id%TYPE,    
        p_outstanding_loss8     GICL_RES_BRDRX_EXTR.expense_reserve%TYPE,
        p_grp_seq_no8           GICL_RCVRY_BRDRX_DS_EXTR.grp_seq_no%TYPE
    )
       RETURN NUMBER
    IS
       v_os_loss8   GICL_RES_BRDRX_EXTR.expense_reserve%TYPE;
    BEGIN
       v_os_loss8 := p_outstanding_loss8;

       FOR j IN (SELECT SUM (shr_recovery_amt) rec_amt
                   FROM GICL_RCVRY_BRDRX_DS_EXTR a, GIIS_DIST_SHARE b
                  WHERE a.session_id = p_session_id
                    AND a.claim_id = NVL (p_claim_id, a.claim_id)
                    AND a.line_cd = b.line_cd
                    AND a.grp_seq_no = b.share_cd
                    AND a.grp_seq_no = p_grp_seq_no8
                    AND a.payee_type = 'E')
       LOOP
          IF NVL (j.rec_amt, 0) != 0
          THEN
             v_os_loss8 := v_os_loss8 - j.rec_amt;
          END IF;
       END LOOP;

       RETURN (v_os_loss8);
    END;

    FUNCTION cf_outstanding_loss_line(
        p_session_id            GICL_RES_BRDRX_EXTR.session_id%TYPE,
        p_claim_id              GICL_RES_BRDRX_EXTR.claim_id%TYPE,     
        p_outstanding_loss1     GICL_RES_BRDRX_EXTR.expense_reserve%TYPE,
        p_buss_source1          GICL_RES_BRDRX_EXTR.buss_source%TYPE,
        p_iss_cd1               GIIS_ISSOURCE.iss_cd%TYPE,              
        p_line_cd1              GIIS_LINE.line_cd%TYPE,
        p_grp_seq_no1           GICL_RCVRY_BRDRX_DS_EXTR.grp_seq_no%TYPE
    )
       RETURN NUMBER
    IS
       v_os_loss1   GICL_RES_BRDRX_EXTR.expense_reserve%TYPE;
    BEGIN
       v_os_loss1 := p_outstanding_loss1;

       FOR j IN (SELECT SUM (shr_recovery_amt) rec_amt
                   FROM GICL_RCVRY_BRDRX_DS_EXTR a, GIIS_DIST_SHARE b
                  WHERE a.session_id = p_session_id
                    AND a.line_cd = b.line_cd
                    AND a.grp_seq_no = b.share_cd
                    AND a.line_cd = p_line_cd1
                    AND a.claim_id = NVL (p_claim_id, a.claim_id)
                    AND a.grp_seq_no = p_grp_seq_no1
                    AND a.buss_source = p_buss_source1
                    AND a.iss_cd = p_iss_cd1
                    AND a.payee_type = 'E')
       LOOP
          IF NVL (j.rec_amt, 0) != 0
          THEN
             v_os_loss1 := v_os_loss1 - j.rec_amt;
          END IF;
       END LOOP;

       RETURN (v_os_loss1);
    END;

    FUNCTION cf_outstanding_loss_iss(
        p_session_id            GICL_RES_BRDRX_EXTR.session_id%TYPE,
        p_claim_id              GICL_RES_BRDRX_EXTR.claim_id%TYPE,     
        p_outstanding_loss6     GICL_RES_BRDRX_EXTR.expense_reserve%TYPE,
        p_buss_source6          GICL_RES_BRDRX_EXTR.buss_source%TYPE,
        p_iss_cd6               GIIS_ISSOURCE.iss_cd%TYPE,              
        p_grp_seq_no6           GICL_RCVRY_BRDRX_DS_EXTR.grp_seq_no%TYPE
    )
       RETURN NUMBER
    IS
       v_os_loss5   GICL_RES_BRDRX_EXTR.expense_reserve%TYPE;
    BEGIN
       v_os_loss5 := p_outstanding_loss6;

       FOR j IN (SELECT SUM (shr_recovery_amt) rec_amt
                   FROM GICL_RCVRY_BRDRX_DS_EXTR a, GIIS_DIST_SHARE b
                  WHERE a.session_id = p_session_id
                    AND a.line_cd = b.line_cd
                    AND a.claim_id = NVL (p_claim_id, a.claim_id)
                    AND a.grp_seq_no = b.share_cd
                    AND a.iss_cd = p_iss_cd6
                    AND a.grp_seq_no = p_grp_seq_no6
                    AND a.buss_source = p_buss_source6
                    AND a.payee_type = 'E')
       LOOP
          IF NVL (j.rec_amt, 0) != 0
          THEN
             v_os_loss5 := v_os_loss5 - j.rec_amt;
          END IF;
       END LOOP;

       RETURN (v_os_loss5);
    END;
    
    FUNCTION cf_outstanding_loss_buss(
        p_session_id            GICL_RES_BRDRX_EXTR.session_id%TYPE,
        p_claim_id              GICL_RES_BRDRX_EXTR.claim_id%TYPE,     
        p_outstanding_loss7     GICL_RES_BRDRX_EXTR.expense_reserve%TYPE,
        p_buss_source7          GICL_RES_BRDRX_EXTR.buss_source%TYPE,
        p_grp_seq_no7           GICL_RCVRY_BRDRX_DS_EXTR.grp_seq_no%TYPE    
    )
       RETURN NUMBER
    IS
       v_os_loss6   GICL_RES_BRDRX_EXTR.expense_reserve%TYPE;
    BEGIN
       v_os_loss6 := p_outstanding_loss7;

       FOR j IN (SELECT SUM (shr_recovery_amt) rec_amt
                   FROM GICL_RCVRY_BRDRX_DS_EXTR a, GIIS_DIST_SHARE b
                  WHERE a.session_id = p_session_id
                    AND a.claim_id = NVL (p_claim_id, a.claim_id)
                    AND a.line_cd = b.line_cd
                    AND a.grp_seq_no = b.share_cd
                    AND a.buss_source = p_buss_source7
                    AND a.grp_seq_no = p_grp_seq_no7
                    AND a.payee_type = 'E')
       LOOP
          IF NVL (j.rec_amt, 0) != 0
          THEN
             v_os_loss6 := v_os_loss6 - j.rec_amt;
          END IF;
       END LOOP;

       RETURN (v_os_loss6);
    END;

    FUNCTION cf_outstanding_loss_buss_type(
        p_session_id            GICL_RES_BRDRX_EXTR.session_id%TYPE,
        p_claim_id              GICL_RES_BRDRX_EXTR.claim_id%TYPE,     
        p_outstanding_loss9     GICL_RES_BRDRX_EXTR.expense_reserve%TYPE,
        p_iss_type              GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
        p_grp_seq_no9           GICL_RCVRY_BRDRX_DS_EXTR.grp_seq_no%TYPE       
    )
       RETURN NUMBER
    IS
       v_os_loss7   GICL_RES_BRDRX_EXTR.expense_reserve%TYPE;
    BEGIN
       v_os_loss7 := p_outstanding_loss9;

       FOR j IN (SELECT SUM (a.shr_recovery_amt) rec_amt
                   FROM GICL_RCVRY_BRDRX_DS_EXTR a,
                        GIIS_DIST_SHARE c,
                        GIIS_INTERMEDIARY d
                  WHERE a.session_id = p_session_id
                    AND a.claim_id = NVL (p_claim_id, a.claim_id)
                    AND c.line_cd = a.line_cd
                    AND c.share_cd = a.grp_seq_no
                    AND a.buss_source = d.intm_no(+)
                    AND DECODE (a.iss_cd, 'RI', 'RI', 'DI') = p_iss_type
                    AND a.grp_seq_no = p_grp_seq_no9
                    AND a.payee_type = 'E')
       LOOP
          IF NVL (j.rec_amt, 0) != 0
          THEN
             v_os_loss7 := v_os_loss7 - j.rec_amt;
          END IF;
       END LOOP;

       RETURN (v_os_loss7);
    END;

    FUNCTION os_loss(
        p_session_id            GICL_RES_BRDRX_EXTR.session_id%TYPE,
        p_claim_id              GICL_RES_BRDRX_EXTR.claim_id%TYPE,
        p_outstanding_loss      GICL_RES_BRDRX_EXTR.expense_reserve%TYPE,
        p_item_no               GICL_RCVRY_BRDRX_EXTR.item_no%TYPE,
        p_peril_cd              GICL_RCVRY_BRDRX_EXTR.peril_cd%TYPE           
    )
       RETURN NUMBER
    IS
       v_os_loss   GICL_RES_BRDRX_EXTR.expense_reserve%TYPE;
    BEGIN
       v_os_loss := p_outstanding_loss;

       FOR i IN (SELECT recovered_amt rec_amt
                   FROM GICL_RCVRY_BRDRX_EXTR
                  WHERE session_id = p_session_id
                    AND claim_id = NVL (p_claim_id, claim_id)
                    AND item_no = p_item_no
                    AND peril_cd = p_peril_cd
                    AND payee_type = 'E')
       LOOP
          IF i.rec_amt IS NOT NULL
          THEN
             v_os_loss := v_os_loss - i.rec_amt;
          END IF;
       END LOOP;

       RETURN (v_os_loss);
    END;

    FUNCTION cf_os_loss2(
        p_session_id            GICL_RES_BRDRX_EXTR.session_id%TYPE,
        p_brdrx_record_id1      GICL_RES_BRDRX_DS_EXTR.brdrx_record_id%TYPE,
        p_brdrx_ds_record_id1   GICL_RES_BRDRX_DS_EXTR.brdrx_ds_record_id%TYPE,
        p_outstanding_loss2     GICL_RES_BRDRX_EXTR.expense_reserve%TYPE              
    )
       RETURN NUMBER
    IS
       v_os_loss2   GICL_RES_BRDRX_EXTR.expense_reserve%TYPE;
    BEGIN
       v_os_loss2 := p_outstanding_loss2;

       FOR a IN (SELECT claim_id, item_no, peril_cd, grp_seq_no
                   FROM GICL_RES_BRDRX_DS_EXTR
                  WHERE session_id = p_session_id
                    AND (NVL (expense_reserve, 0) - NVL (expenses_paid, 0)) > 0
                    AND brdrx_record_id = p_brdrx_record_id1
                    AND brdrx_ds_record_id = p_brdrx_ds_record_id1)
       LOOP
          FOR b IN (SELECT y.shr_recovery_amt rec_amt
                      FROM gicl_rcvry_brdrx_extr x, gicl_rcvry_brdrx_ds_extr y
                     WHERE x.session_id = p_session_id
                       AND x.session_id = y.session_id
                       AND y.claim_id = x.claim_id
                       AND y.item_no = x.item_no
                       AND y.peril_cd = x.peril_cd
                       AND x.recovery_id = y.recovery_id
                       AND x.recovery_payt_id = y.recovery_payt_id
                       AND x.acct_tran_id = y.acct_tran_id
                       AND x.claim_id = a.claim_id
                       AND x.item_no = a.item_no
                       AND x.peril_cd = a.peril_cd
                       AND y.grp_seq_no = a.grp_seq_no
                       AND x.payee_type = 'E')
          LOOP
             IF NVL (b.rec_amt, 0) != 0
             THEN
                v_os_loss2 := v_os_loss2 - b.rec_amt;
             END IF;
          END LOOP;
       END LOOP;

       RETURN (v_os_loss2);
    END;

    FUNCTION cf_os_loss3(
        p_session_id            GICL_RES_BRDRX_EXTR.session_id%TYPE,    
        p_claim_id1             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
        p_outstanding_loss3     GICL_RES_BRDRX_EXTR.expense_reserve%TYPE,
        p_item_no1              GICL_RCVRY_BRDRX_DS_EXTR.item_no%TYPE,
        p_peril_cd1             GICL_RCVRY_BRDRX_DS_EXTR.peril_cd%TYPE,
        p_facul_ri_cd           GICL_RCVRY_BRDRX_RIDS_EXTR.ri_cd%TYPE
    )
       RETURN NUMBER
    IS
       v_os_loss3   GICL_RES_BRDRX_EXTR.expense_reserve%TYPE;
    BEGIN
       v_os_loss3 := p_outstanding_loss3;

       FOR j IN (SELECT b.shr_ri_recovery_amt rids_rec_amt
                   FROM GICL_RCVRY_BRDRX_DS_EXTR a, GICL_RCVRY_BRDRX_RIDS_EXTR b
                  WHERE a.session_id = p_session_id
                    AND a.claim_id = p_claim_id1
                    AND a.item_no = p_item_no1
                    AND a.peril_cd = p_peril_cd1
                    AND a.grp_seq_no = 999
                    AND a.claim_id = b.claim_id
                    AND a.item_no = b.item_no
                    AND a.peril_cd = b.peril_cd
                    AND a.grp_seq_no = b.grp_seq_no
                    AND b.ri_cd = p_facul_ri_cd
                    AND a.payee_type = 'E'
                    AND a.payee_type = b.payee_type)
       LOOP
          IF NVL (j.rids_rec_amt, 0) != 0
          THEN
             v_os_loss3 := v_os_loss3 - j.rids_rec_amt;
          END IF;
       END LOOP;

       RETURN (v_os_loss3);
    END;

    FUNCTION cf_os_loss4(
        p_session_id            GICL_RES_BRDRX_EXTR.session_id%TYPE,    
        p_claim_id2             GICL_RES_BRDRX_EXTR.claim_id%TYPE,
        p_outstanding_loss4     GICL_RES_BRDRX_EXTR.expense_reserve%TYPE,
        p_item_no2              GICL_RCVRY_BRDRX_DS_EXTR.item_no%TYPE,
        p_peril_cd2             GICL_RCVRY_BRDRX_DS_EXTR.peril_cd%TYPE,
        p_grp_seq_no2           GICL_RCVRY_BRDRX_DS_EXTR.grp_seq_no%TYPE,
        p_ri_cd1                GICL_RCVRY_BRDRX_RIDS_EXTR.ri_cd%TYPE       
    )
       RETURN NUMBER
    IS
       v_os_loss4   GICL_RES_BRDRX_EXTR.expense_reserve%TYPE;
    BEGIN
       v_os_loss4 := p_outstanding_loss4;

       FOR j IN (SELECT shr_ri_recovery_amt shr_rec_amt
                   FROM GICL_RCVRY_BRDRX_RIDS_EXTR
                  WHERE session_id = p_session_id
                    AND claim_id = p_claim_id2
                    AND item_no = p_item_no2
                    AND peril_cd = p_peril_cd2
                    AND grp_seq_no = p_grp_seq_no2
                    AND ri_cd = p_ri_cd1
                    AND payee_type = 'E')
       LOOP
          IF NVL (j.shr_rec_amt, 0) != 0
          THEN
             v_os_loss4 := v_os_loss4 - j.shr_rec_amt;
          END IF;
       END LOOP;

       RETURN (v_os_loss4);
    END;

   FUNCTION get_page_header(
      p_from_date     DATE,
      p_to_date       DATE,
      p_as_of_date    DATE,
      p_date_option   VARCHAR2,
      p_os_date       VARCHAR2
   )
      RETURN header_tab PIPELINED
   IS
      v_header     header_type;
   BEGIN
        v_header.company_name      := CF_COMPANY_NAME;
        v_header.company_address   := CF_COMPANY_ADDRESS;
        v_header.report_name       := CF_REPORT_NAME;
        v_header.report_param_date := CF_PARAMDATE(p_os_date);
        v_header.report_date       := CF_REPORT_DATE (p_from_date, p_to_date, p_as_of_date, p_date_option);
        PIPE ROW(v_header);
   END;
    
   FUNCTION get_report_header (
      p_session_id    GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id      GICL_RES_BRDRX_EXTR.claim_id%TYPE    
   )
      RETURN header_tab PIPELINED
   IS
      v_header   header_type;
      v_exists   VARCHAR2(10);
   BEGIN
      FOR i IN (SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI' ) iss_type,
                                DECODE (a.iss_cd,'RI', 'RI', b.intm_type) buss_source_type,
                                a.iss_cd, a.buss_source, a.line_cd,
                                a.subline_cd, a.loss_year
                           FROM GICL_RES_BRDRX_EXTR a, GIIS_INTERMEDIARY b
                          WHERE a.buss_source = b.intm_no(+)
                            AND a.session_id = p_session_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                       ORDER BY DECODE (a.iss_cd, 'RI', 'RI', b.intm_type),
                                a.buss_source,
                                a.iss_cd,
                                a.line_cd,
                                a.subline_cd,
                                a.loss_year)
      LOOP
        v_header.buss_source_type  := i.buss_source_type;
        v_header.buss_source_name  := INTM_DESC (i.buss_source_type);
        v_header.iss_type          := i.iss_cd;
        v_header.buss_source       := i.buss_source;
        v_header.source_name       := SOURCE_NAME (i.buss_source, i.iss_cd);
        v_header.iss_cd            := i.iss_cd;
        v_header.iss_name          := ISS_NAME (i.iss_cd);
        v_header.line_cd           := i.line_cd;
        v_header.line_name         := LINE_NAME (i.line_cd);
        v_header.subline_cd        := i.subline_cd;
        v_header.subline_name      := SUBLINE_NAME (i.subline_cd, i.line_cd);
        v_header.loss_year         := i.loss_year;
        v_header.report_format_trigger         := report_format_trigger(p_session_id, p_claim_id);
        PIPE ROW(v_header);
      END LOOP;
   END get_report_header;

   FUNCTION get_report_detail (
      p_session_id    GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id      GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_intm_break    VARCHAR2,
      p_buss_source   GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd        GIIS_ISSOURCE.iss_cd%TYPE,
      p_line_cd       GIIS_LINE.line_cd%TYPE,
      p_subline_cd    GIIS_SUBLINE.subline_cd%TYPE,
      p_loss_year     GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
      RETURN detail_tab PIPELINED
   IS
      v_detail   detail_type;
   BEGIN
      FOR i IN (SELECT   a.brdrx_record_id, a.buss_source, a.iss_cd,
                         a.line_cd, a.subline_cd, a.loss_year, a.claim_id,
                         a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                         a.expiry_date, a.loss_date, a.clm_file_date,
                         a.item_no, a.grouped_item_no, a.peril_cd,
                         a.loss_cat_cd, a.tsi_amt, a.intm_no,
                         ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) outstanding_loss
                    FROM GICL_RES_BRDRX_EXTR a
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                     AND a.buss_source = NVL (p_buss_source, a.buss_source)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                     AND a.loss_year = NVL (p_loss_year, a.loss_year)
                ORDER BY a.claim_id, a.assd_no, a.item_no, a.peril_cd)
      LOOP
         v_detail.brdrx_record_id   := i.brdrx_record_id;
         v_detail.buss_source       := i.buss_source;
         v_detail.iss_cd            := i.iss_cd;
         v_detail.line_cd           := i.line_cd;
         v_detail.subline_cd        := i.subline_cd;
         v_detail.loss_year         := i.loss_year;
         v_detail.claim_id          := i.claim_id;
         v_detail.assd_no           := i.assd_no;
         v_detail.claim_no          := i.claim_no;
         v_detail.policy_no         := CF_POLICY (i.claim_id, i.policy_no);
         v_detail.assd_name         := assd_name (i.assd_no);
         v_detail.incept_date       := i.incept_date;
         v_detail.expiry_date       := i.expiry_date;
         v_detail.loss_date         := i.loss_date;
         v_detail.item_no           := i.item_no;
         v_detail.item_title        := GET_GPA_ITEM_TITLE (i.claim_id, i.line_cd, i.item_no, NVL (i.grouped_item_no, 0));
         v_detail.tsi_amt           := i.tsi_amt;
         v_detail.peril_cd          := i.peril_cd;
         v_detail.peril_name        := PERIL_NAME (i.peril_cd, i.line_cd);
         v_detail.intm_ri           := CF_INTM_RI(p_session_id, i.claim_id, p_intm_break, i.item_no, i.peril_cd, i.intm_no);
         v_detail.outstanding_loss  := OS_LOSS(p_session_id, p_claim_id, i.outstanding_loss, i.item_no, i.peril_cd);
         PIPE ROW (v_detail);
      END LOOP;

      RETURN;
   END get_report_detail;

   FUNCTION get_treaty (
      p_session_id      GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id        GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_brdrx_record_id GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_buss_source     GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd          GIIS_ISSOURCE.iss_cd%TYPE,
      p_line_cd         GIIS_LINE.line_cd%TYPE,
      p_subline_cd      GIIS_SUBLINE.subline_cd%TYPE,
      p_loss_year       GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
      RETURN treaty_detail_tab PIPELINED
   IS
      v_treaty   treaty_detail_type;
   BEGIN
      FOR g IN (SELECT   a.brdrx_record_id, a.item_no, a.peril_cd,a.claim_id
                    FROM GICL_RES_BRDRX_EXTR a
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                     AND a.buss_source = p_buss_source
                     AND a.iss_cd = p_iss_cd
                     AND a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.loss_year = p_loss_year
                     AND a.brdrx_record_id = p_brdrx_record_id
                ORDER BY a.claim_no, a.item_no, a.peril_cd)
      LOOP
         FOR j IN (SELECT DISTINCT a.iss_cd, a.buss_source, a.line_cd,
                                   a.subline_cd, a.loss_year, a.grp_seq_no
                              FROM GICL_RES_BRDRX_DS_EXTR a
                             WHERE a.session_id = p_session_id
                               AND a.claim_id = NVL (p_claim_id, a.claim_id)
                               AND a.buss_source = p_buss_source
                              AND a.iss_cd = p_iss_cd
                              AND a.line_cd = p_line_cd
                              AND a.subline_cd = p_subline_cd
                              AND a.loss_year = p_loss_year
                              AND a.brdrx_record_id = p_brdrx_record_id)
         LOOP
            FOR l IN
               (SELECT DISTINCT a.brdrx_record_id, a.brdrx_ds_record_id,
                                a.grp_seq_no, a.shr_pct,
                                ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) outstanding_loss
                           FROM GICL_RES_BRDRX_DS_EXTR a
                          WHERE a.session_id = p_session_id
                            AND a.brdrx_record_id = g.brdrx_record_id
                            AND a.grp_seq_no = j.grp_seq_no
                            AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0)
            LOOP
               v_treaty.claim_id                := g.claim_id;
               v_treaty.brdrx_record_id2        := g.brdrx_record_id;
               v_treaty.peril_cd                := g.peril_cd;
               v_treaty.buss_source2            := j.buss_source;
               v_treaty.grp_seq_no2             := j.grp_seq_no;
               v_treaty.iss_cd2                 := j.iss_cd;
               v_treaty.line_cd2                := j.line_cd;
               v_treaty.subline_cd2             := j.subline_cd;
               v_treaty.loss_year2              := j.loss_year;
               v_treaty.treaty_name2            := treaty_name (j.grp_seq_no, j.line_cd);
               v_treaty.outstanding_loss2       := l.outstanding_loss;
               v_treaty.outstanding_loss_sum    := CF_OS_LOSS2(p_session_id, l.brdrx_record_id, l.brdrx_ds_record_id, l.outstanding_loss); 
               v_treaty.outstanding_loss2_sum   := CF_OS_LOSS2(p_session_id, l.brdrx_record_id, l.brdrx_ds_record_id, l.outstanding_loss); 
               v_treaty.outstanding_loss3       := NULL;
               v_treaty.facul_ri_cd2            := NULL;
               v_treaty.facul_ri_name2          := NULL;                
               PIPE ROW (v_treaty);
               
               FOR f IN (SELECT   a.brdrx_ds_record_id,
                                  DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd) facul_ri_cd,
                                  SUM (a.shr_ri_pct) facul_shr_ri_pct,claim_id, item_no, peril_cd,
                                  SUM ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) outstanding_loss3
                             FROM gicl_res_brdrx_rids_extr a
                            WHERE a.grp_seq_no = 999
                              AND a.session_id = p_session_id
                              AND a.brdrx_ds_record_id = l.brdrx_ds_record_id
                         GROUP BY a.brdrx_ds_record_id,claim_id, item_no, peril_cd,
                                  DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
               LOOP
                  v_treaty.facul_ri_cd2           := f.facul_ri_cd;
                  v_treaty.facul_ri_name2         := facul_ri_name (f.facul_ri_cd);
                  v_treaty.outstanding_loss3      := CF_OS_LOSS3(p_session_id, f.claim_id, f.outstanding_loss3, f.item_no, f.peril_cd, f.facul_ri_cd);
                  v_treaty.outstanding_loss_sum   := NULL;
                  v_treaty.outstanding_loss2      := NULL;
                  PIPE ROW (v_treaty);
               END LOOP;               
            END LOOP;
         END LOOP;

         FOR h IN (SELECT DISTINCT a.grp_seq_no, a.line_cd,
                                   a.brdrx_ds_record_id, brdrx_record_id
                              FROM GICL_RES_BRDRX_DS_EXTR a
                             WHERE a.session_id = p_session_id
                             --  AND a.claim_id = NVL (p_claim_id, a.claim_id)
                               AND a.buss_source = p_buss_source
                               AND a.iss_cd = p_iss_cd
                               AND a.line_cd = p_line_cd
                               AND a.subline_cd = p_subline_cd
                               AND a.loss_year = p_loss_year
                               AND a.grp_seq_no NOT IN (
                                      SELECT DISTINCT a.grp_seq_no
                                                 FROM GICL_RES_BRDRX_DS_EXTR a
                                                WHERE a.brdrx_record_id = g.brdrx_record_id
                                                  AND a.session_id = p_session_id
                                                --  AND a.claim_id = NVL (p_claim_id,a.claim_id)
                                                  AND a.buss_source = p_buss_source
                                                  AND a.iss_cd = p_iss_cd
                                                  AND a.line_cd = p_line_cd
                                                  AND a.subline_cd = p_subline_cd
                                                  AND a.loss_year = p_loss_year))
         LOOP
            v_treaty.treaty_name2           := treaty_name (h.grp_seq_no, h.line_cd);
            v_treaty.outstanding_loss2      := NULL;
            v_treaty.outstanding_loss_sum   := NULL;
            v_treaty.outstanding_loss2_sum  := NULL;
            v_treaty.grp_seq_no2            := h.grp_seq_no;
            v_treaty.outstanding_loss3      := NULL;
            v_treaty.facul_ri_cd2           := NULL;
            v_treaty.facul_ri_name2         := NULL;            
            PIPE ROW (v_treaty);
         END LOOP;
      END LOOP;

      RETURN;
   END get_treaty;

   FUNCTION get_treaty_facul (
      p_session_id    GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id      GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_brdrx_record_id GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_buss_source   GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd        GIIS_ISSOURCE.iss_cd%TYPE,
      p_line_cd       GIIS_LINE.line_cd%TYPE,
      p_subline_cd    GIIS_SUBLINE.subline_cd%TYPE,
      p_loss_year     GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
      RETURN treaty_facul_tab PIPELINED
   IS
      v_facul   treaty_facul_type;
   BEGIN
      FOR g IN (SELECT   a.brdrx_record_id
                    FROM GICL_RES_BRDRX_EXTR a
                   WHERE a.session_id = p_session_id
                     --AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                       AND a.claim_id  = NVL(DECODE(p_claim_id, -1, a.claim_id, p_claim_id), a.claim_id) 
                     AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                     AND a.buss_source = p_buss_source
                     AND a.iss_cd = p_iss_cd
                     AND a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.loss_year = p_loss_year
                ORDER BY a.claim_no, a.item_no, a.peril_cd)
      LOOP
         FOR j IN (SELECT DISTINCT a.iss_cd, a.buss_source, a.line_cd,
                                   a.subline_cd, a.loss_year, a.grp_seq_no
                              FROM GICL_RES_BRDRX_DS_EXTR a
                             WHERE a.session_id = p_session_id
                               --AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                               AND a.claim_id  = NVL(DECODE(p_claim_id, -1, a.claim_id, p_claim_id), a.claim_id) 
                               AND a.brdrx_record_id = NVL(DECODE(p_brdrx_record_id, -1, a.brdrx_record_id, p_brdrx_record_id),a.brdrx_record_id) 
                               AND a.buss_source = p_buss_source
                               AND a.iss_cd = p_iss_cd
                               AND a.line_cd = p_line_cd
                               AND a.subline_cd = p_subline_cd
                               AND a.loss_year = p_loss_year
                          ORDER BY a.grp_seq_no)
         LOOP
            FOR l IN (SELECT DISTINCT a.brdrx_ds_record_id, a.grp_seq_no,
                             SUM (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) outstanding_loss3
                                 FROM GICL_RES_BRDRX_DS_EXTR a
                                WHERE a.session_id = p_session_id
                                  AND a.brdrx_record_id = g.brdrx_record_id
                                  AND a.grp_seq_no = j.grp_seq_no
                                  AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                                GROUP BY a.brdrx_ds_record_id, a.grp_seq_no
                                ORDER BY a.grp_seq_no)
            LOOP
               v_facul.brdrx_record_id2  := g.brdrx_record_id;
               v_facul.grp_seq_no2       := j.grp_seq_no;
               v_facul.treaty_name2      := TREATY_NAME (j.grp_seq_no, j.line_cd);
               v_facul.facul_ri_cd2      := NULL;
               v_facul.facul_ri_name2    := NULL;
               v_facul.outstanding_loss3 := l.outstanding_loss3;
               PIPE ROW (v_facul);
               
               FOR f IN (SELECT   a.brdrx_ds_record_id,
                                  DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd) facul_ri_cd,
                                  SUM (a.shr_ri_pct) facul_shr_ri_pct,claim_id, item_no, peril_cd,
                                  SUM ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) outstanding_loss3
                             FROM gicl_res_brdrx_rids_extr a
                            WHERE a.grp_seq_no = 999
                              AND a.session_id = p_session_id
                              AND a.brdrx_ds_record_id = l.brdrx_ds_record_id
                         GROUP BY a.brdrx_ds_record_id,claim_id, item_no, peril_cd,
                                  DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
               LOOP
                  v_facul.facul_ri_cd2      := f.facul_ri_cd;
                  v_facul.facul_ri_name2    := facul_ri_name (f.facul_ri_cd);
                  v_facul.outstanding_loss3 := CF_OS_LOSS3(p_session_id, f.claim_id, f.outstanding_loss3, f.item_no, f.peril_cd, f.facul_ri_cd);
                  PIPE ROW (v_facul);
               END LOOP;
            END LOOP;
         END LOOP;

         FOR h IN (SELECT DISTINCT a.grp_seq_no, a.line_cd,
                                   a.brdrx_ds_record_id
                              FROM GICL_RES_BRDRX_DS_EXTR a
                             WHERE a.session_id = p_session_id
                               AND a.claim_id = NVL (p_claim_id, a.claim_id)
                               AND a.buss_source = p_buss_source
                               AND a.iss_cd = p_iss_cd
                               AND a.line_cd = p_line_cd
                               AND a.subline_cd = p_subline_cd
                               AND a.loss_year = p_loss_year
                               AND a.grp_seq_no NOT IN (
                                      SELECT DISTINCT a.grp_seq_no
                                                 FROM GICL_RES_BRDRX_DS_EXTR a
                                                WHERE a.brdrx_record_id = g.brdrx_record_id
                                                  AND a.session_id = p_session_id
                                                  AND a.claim_id = NVL (p_claim_id, a.claim_id)
                                                  AND a.buss_source = p_buss_source
                                                  AND a.iss_cd = p_iss_cd
                                                  AND a.line_cd = p_line_cd
                                                  AND a.subline_cd = p_subline_cd
                                                  AND a.loss_year = p_loss_year)
                          ORDER BY a.grp_seq_no)
         LOOP
            v_facul.treaty_name2        := TREATY_NAME (h.grp_seq_no, h.line_cd);
            v_facul.outstanding_loss3   := NULL;
            v_facul.grp_seq_no2         := h.grp_seq_no;
            v_facul.facul_ri_cd2        := NULL;
            v_facul.facul_ri_name2      := NULL;
            PIPE ROW (v_facul);
         END LOOP;
      END LOOP;

      RETURN;
   END get_treaty_facul;

   FUNCTION get_treaty_ri1 (
      p_session_id    GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id      GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source   GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd        GIIS_ISSOURCE.iss_cd%TYPE,
      p_line_cd       GIIS_LINE.line_cd%TYPE,
      p_subline_cd    GIIS_SUBLINE.subline_cd%TYPE,
      p_loss_year     GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
      RETURN treaty_ri_tab PIPELINED
   IS
      v_treaty_ri   treaty_ri_type;
   BEGIN
      FOR a IN (SELECT  DISTINCT a.iss_cd, a.buss_source,
                         a.line_cd, a.subline_cd, a.loss_year, a.grp_seq_no,
                         DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd) trty_ri_cd,
                         a.ri_cd, a.shr_ri_pct
                    FROM GICL_RES_BRDRX_RIDS_EXTR a
                   WHERE a.grp_seq_no <> 999
                     AND a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                     AND a.buss_source = p_buss_source
                     AND a.iss_cd = p_iss_cd
                     AND a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.loss_year = p_loss_year
                ORDER BY a.grp_seq_no,
                         DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
      LOOP
         v_treaty_ri.iss_cd                 := a.iss_cd;
         v_treaty_ri.buss_source            := a.buss_source;
         v_treaty_ri.line_cd                := a.line_cd;
         v_treaty_ri.subline_cd             := a.subline_cd;
         v_treaty_ri.loss_year              := a.loss_year;
         v_treaty_ri.grp_seq_no             := a.grp_seq_no;
         v_treaty_ri.trty_ri_cd             := a.trty_ri_cd;
         v_treaty_ri.ri_cd                  := a.ri_cd;
         v_treaty_ri.shr_ri_pct             := a.shr_ri_pct;
         v_treaty_ri.treaty_name2           := TREATY_NAME2 (a.grp_seq_no, a.line_cd);
         v_treaty_ri.ri_name                := RI_NAME (a.ri_cd);
         v_treaty_ri.ri_shr                 := RI_SHR (a.grp_seq_no, a.line_cd, a.ri_cd);
         PIPE ROW (v_treaty_ri);
      END LOOP;

      RETURN;
   END get_treaty_ri1;

   FUNCTION get_treaty_ri (
      p_session_id        GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id          GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source       GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd            GIIS_ISSOURCE.iss_cd%TYPE,
      p_line_cd           GIIS_LINE.line_cd%TYPE,
      p_subline_cd        GIIS_SUBLINE.subline_cd%TYPE,
      p_loss_year         GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_brdrx_record_id   GICL_RES_BRDRX_DS_EXTR.brdrx_record_id%TYPE
   )
      RETURN treaty_ri_tab PIPELINED
   IS
      v_treaty_ri   treaty_ri_type;
   BEGIN
      FOR b IN (SELECT DISTINCT a.brdrx_ds_record_id, brdrx_record_id,
                                a.iss_cd, a.buss_source, a.line_cd,
                                a.subline_cd, a.loss_year
                           FROM GICL_RES_BRDRX_DS_EXTR a
                          WHERE a.grp_seq_no <> 999
                            AND a.session_id = p_session_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND a.buss_source = p_buss_source
                            AND a.iss_cd = p_iss_cd
                            AND a.line_cd = p_line_cd
                            AND a.subline_cd = p_subline_cd
                            AND a.loss_year = p_loss_year
                            AND brdrx_record_id IN (
                                   SELECT a.brdrx_record_id
                                     FROM GICL_RES_BRDRX_EXTR a
                                    WHERE a.session_id = p_session_id
                                      AND a.claim_id = NVL (p_claim_id, a.claim_id)
                                      AND a.buss_source = p_buss_source
                                      AND a.iss_cd = p_iss_cd
                                      AND a.line_cd = p_line_cd
                                      AND a.subline_cd = p_subline_cd
                                      AND a.loss_year = p_loss_year))
      LOOP
         v_treaty_ri.brdrx_record_id := b.brdrx_record_id;

         FOR a IN (SELECT DISTINCT a.grp_seq_no, a.brdrx_rids_record_id,
                                   brdrx_ds_record_id, a.iss_cd,
                                   a.buss_source, a.line_cd, a.subline_cd,
                                   a.loss_year,
                                   DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd) trty_ri_cd,
                                   a.ri_cd, a.shr_ri_pct
                              FROM GICL_RES_BRDRX_RIDS_EXTR a
                             WHERE a.grp_seq_no <> 999
                               AND a.session_id = p_session_id
                               AND a.claim_id = NVL (p_claim_id, a.claim_id)
                               AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                               AND a.buss_source = NVL (p_buss_source, b.buss_source)
                               AND a.iss_cd = NVL (p_iss_cd, b.iss_cd)
                               AND a.line_cd = NVL (p_line_cd, b.line_cd)
                               AND a.subline_cd = NVL (p_subline_cd, b.subline_cd)
                               AND a.loss_year = NVL (p_loss_year, b.loss_year)
                               AND a.brdrx_ds_record_id = NVL (b.brdrx_ds_record_id, a.brdrx_ds_record_id)
                          ORDER BY a.grp_seq_no,
                                   DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
         LOOP
            v_treaty_ri.brdrx_ds_record_id      := a.brdrx_ds_record_id;
            v_treaty_ri.brdrx_rids_record_id    := a.brdrx_rids_record_id;
            v_treaty_ri.iss_cd                  := a.iss_cd;
            v_treaty_ri.buss_source             := a.buss_source;
            v_treaty_ri.line_cd                 := a.line_cd;
            v_treaty_ri.subline_cd              := a.subline_cd;
            v_treaty_ri.loss_year               := a.loss_year;
            v_treaty_ri.grp_seq_no              := a.grp_seq_no;
            v_treaty_ri.trty_ri_cd              := a.trty_ri_cd;
            v_treaty_ri.ri_cd                   := a.ri_cd;
            v_treaty_ri.shr_ri_pct              := a.shr_ri_pct;
            v_treaty_ri.treaty_name2            := TREATY_NAME2 (a.grp_seq_no, a.line_cd);
            v_treaty_ri.ri_name                 := RI_NAME (a.ri_cd);
            v_treaty_ri.ri_shr                  := RI_SHR (a.grp_seq_no, a.line_cd, a.ri_cd);
            PIPE ROW (v_treaty_ri);
         END LOOP;
      END LOOP;

      RETURN;
   END get_treaty_ri;

   FUNCTION get_treaty_ri_amt (
      p_session_id    GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id      GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source   GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd        GIIS_ISSOURCE.iss_cd%TYPE,
      p_line_cd       GIIS_LINE.line_cd%TYPE,
      p_subline_cd    GIIS_SUBLINE.subline_cd%TYPE,
      p_loss_year     GICL_RES_BRDRX_EXTR.loss_year%TYPE,
      p_ri_cd         GICL_RES_BRDRX_RIDS_EXTR.ri_cd%TYPE
   )
      RETURN treaty_ri_tab PIPELINED
   IS
      v_treaty_ri   treaty_ri_type;
   BEGIN
      FOR v IN (SELECT   a.brdrx_rids_record_id, grp_seq_no, line_cd, ri_cd
                    FROM GICL_RES_BRDRX_RIDS_EXTR a
                   WHERE a.grp_seq_no <> 999
                     AND a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                     AND a.buss_source = NVL (p_buss_source, a.buss_source)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.subline_cd = NVL (p_subline_cd, subline_cd)
                     AND a.loss_year = NVL (p_loss_year, a.loss_year)
                     AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                ORDER BY a.grp_seq_no,
                         DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
      LOOP
         FOR b IN (SELECT DISTINCT a.grp_seq_no
                              FROM GICL_RES_BRDRX_DS_EXTR a
                             WHERE a.grp_seq_no NOT IN (1, 999)
                               AND a.session_id = p_session_id
                               AND a.claim_id = NVL (p_claim_id, a.claim_id)
                               AND a.buss_source = NVL (p_buss_source, a.buss_source)
                               AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                               AND a.line_cd = NVL (p_line_cd, a.line_cd)
                               AND a.subline_cd = NVL (p_subline_cd, subline_cd)
                               AND a.loss_year = NVL (p_loss_year, a.loss_year)
                          ORDER BY a.grp_seq_no)
         LOOP
            v_treaty_ri.grp_seq_no2           := b.grp_seq_no;
            FOR c IN (SELECT a.brdrx_rids_record_id, a.grp_seq_no, a.claim_id, a.item_no, a.peril_cd, a.ri_cd,
                             ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) outstanding_loss
                        FROM GICL_RES_BRDRX_RIDS_EXTR a
                       WHERE a.grp_seq_no <> 999
                         AND a.session_id = p_session_id
                         AND a.brdrx_rids_record_id = v.brdrx_rids_record_id
                         AND a.grp_seq_no = b.grp_seq_no
                         AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0)
            LOOP
               v_treaty_ri.outstanding_loss4    := CF_OS_LOSS4(p_session_id, c.claim_id, c.outstanding_loss, c.item_no, c.peril_cd, c.grp_seq_no, c.ri_cd);
               v_treaty_ri.brdrx_rids_record_id := v.brdrx_rids_record_id;
               v_treaty_ri.treaty_name2         := TREATY_NAME2 (v.grp_seq_no, v.line_cd);
               v_treaty_ri.ri_name              := RI_NAME (v.ri_cd);
               v_treaty_ri.ri_cd                := v.ri_cd;
               v_treaty_ri.grp_seq_no           := v.grp_seq_no;
               PIPE ROW (v_treaty_ri);
            END LOOP;
         END LOOP;     
      END LOOP;

      FOR w in (SELECT  grp_seq_no
                    FROM GICL_RES_BRDRX_RIDS_EXTR a
                   WHERE a.grp_seq_no <> 999
                     AND a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                     AND a.buss_source = NVL (p_buss_source, a.buss_source)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.subline_cd = NVL (p_subline_cd, subline_cd)
                     AND a.loss_year = NVL (p_loss_year, a.loss_year)                
            MINUS                          
                SELECT  grp_seq_no
                    FROM GICL_RES_BRDRX_RIDS_EXTR a
                   WHERE a.grp_seq_no <> 999
                     AND a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                     AND a.buss_source = NVL (p_buss_source, a.buss_source)
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.subline_cd = NVL (p_subline_cd, subline_cd)
                     AND a.loss_year = NVL (p_loss_year, a.loss_year)
                     AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
      )
      LOOP
        v_treaty_ri.outstanding_loss4   := NULL;
        v_treaty_ri.grp_seq_no          := w.grp_seq_no;
        PIPE ROW (v_treaty_ri);
      END LOOP;
           
      RETURN;
   END get_treaty_ri_amt;

   FUNCTION get_total_per_line (
      p_session_id    GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id      GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source   GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd        GIIS_ISSOURCE.iss_cd%TYPE,
      p_line_cd       GIIS_LINE.line_cd%TYPE
   )
      RETURN total_tab PIPELINED
   IS
      v_total   total_type;
   BEGIN
        FOR f IN (SELECT DISTINCT (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) outstanding_loss, a.brdrx_record_id,
                         a.brdrx_ds_record_id,a.line_cd, a.subline_cd, a.iss_cd, a.buss_source
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE a.session_id = p_session_id
                     AND (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0
                     AND a.line_cd = p_line_cd
                     AND a.iss_cd = p_iss_cd
                     AND a.buss_source = p_buss_source
                     AND a.brdrx_record_id IN (SELECT a.brdrx_record_id
                                                 FROM GICL_RES_BRDRX_EXTR A
                                                WHERE a.session_id = p_session_id 
                                                  AND a.claim_id = NVL(p_claim_id,a.claim_id)
                                                  AND (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0))
        LOOP
            v_total.buss_source           := f.buss_source;
            v_total.iss_cd                := f.iss_cd;
            v_total.subline_cd            := f.subline_cd;
            v_total.line_cd               := f.line_cd;
            v_total.outstanding_loss      := CF_OS_LOSS2(p_session_id, f.brdrx_record_id, f.brdrx_ds_record_id, f.outstanding_loss);            
         PIPE ROW (v_total);
        END LOOP;  

       FOR i IN (SELECT   a.line_cd,
                          SUM ( (  NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) ) outstanding_loss,
                          b.trty_name, a.iss_cd, a.grp_seq_no, a.buss_source
                     FROM GICL_RES_BRDRX_DS_EXTR a, GIIS_DIST_SHARE b
                    WHERE (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0
                      AND a.session_id = p_session_id
                      AND a.claim_id = NVL (p_claim_id, a.claim_id)
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND a.buss_source = p_buss_source
                      AND a.iss_cd = p_iss_cd
                      AND a.line_cd = p_line_cd
                 GROUP BY a.line_cd, a.iss_cd, b.trty_name, a.grp_seq_no, a.buss_source
                 ORDER BY a.grp_seq_no)
       LOOP
          v_total.iss_cd                := i.iss_cd;
          v_total.outstanding_loss_trty := CF_OUTSTANDING_LOSS_LINE(p_session_id, p_claim_id, i.outstanding_loss, i.buss_source, i.iss_cd, i.line_cd,i.grp_seq_no);
          v_total.treaty_name           := i.trty_name;
          v_total.line_cd               := i.line_cd;
          v_total.buss_source           := i.buss_source;
          v_total.outstanding_loss      := NULL;           
          PIPE ROW (v_total);
       END LOOP;
       RETURN;
   END get_total_per_line;

   FUNCTION get_total_per_iss (
      p_session_id    GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id      GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source   GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd        GIIS_ISSOURCE.iss_cd%TYPE
   )
      RETURN total_tab PIPELINED
   IS
      v_total   total_type;
   BEGIN
        FOR d IN (SELECT a.brdrx_record_id, a.brdrx_ds_record_id, a.iss_cd, a.buss_source,
                         (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) outstanding_loss
                    FROM GICL_RES_BRDRX_DS_EXTR A
                   WHERE a.session_id = p_session_id
                     AND (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0
                     AND a.iss_cd = p_iss_cd
                     AND a.buss_source = p_buss_source
                     AND a.brdrx_record_id IN (SELECT a.brdrx_record_id
                                                 FROM GICL_RES_BRDRX_EXTR A
                                                WHERE a.session_id = p_session_id 
                                                  AND a.claim_id = NVL(p_claim_id,a.claim_id)
                                                  AND (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0))
        LOOP
             v_total.buss_source        := d.buss_source;
             v_total.iss_cd             := d.iss_cd;
             v_total.outstanding_loss   := CF_OS_LOSS2(p_session_id, d.brdrx_record_id, d.brdrx_ds_record_id, d.outstanding_loss); 
         PIPE ROW (v_total);            
        END LOOP;
        
       FOR i IN (SELECT   SUM ( (  NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) ) outstanding_loss,
                          b.trty_name, a.iss_cd, a.grp_seq_no, a.buss_source
                     FROM GICL_RES_BRDRX_DS_EXTR a, GIIS_DIST_SHARE b
                    WHERE ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                      AND a.session_id = p_session_id
                      AND a.claim_id = NVL (p_claim_id, a.claim_id)
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND a.buss_source = p_buss_source
                      AND a.iss_cd = p_iss_cd
                 GROUP BY b.trty_name, a.iss_cd, a.grp_seq_no, a.buss_source
                 ORDER BY a.grp_seq_no)
       LOOP
            v_total.buss_source             := i.buss_source;
            v_total.iss_cd                  := i.iss_cd;
            v_total.outstanding_loss_trty   := CF_OUTSTANDING_LOSS_ISS(p_session_id, p_claim_id, i.outstanding_loss, i.buss_source, i.iss_cd, i.grp_seq_no);
            v_total.treaty_name             := i.trty_name;
            v_total.outstanding_loss        := NULL; 
          PIPE ROW (v_total);
       END LOOP;
    RETURN;        
   END get_total_per_iss;

   FUNCTION get_total_per_buss_source (
      p_session_id    GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id      GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source   GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_buss_source_type    VARCHAR2
   )
      RETURN total_tab PIPELINED
   IS
      v_total   total_type;
   BEGIN
    IF p_buss_source_type IS NOT NULL 
    THEN
        FOR i IN (SELECT a.brdrx_record_id, a.brdrx_ds_record_id, line_cd, a.subline_cd, a.iss_cd, a.buss_source,
                         (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) outstanding_loss,
                         DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type
                    FROM GICL_RES_BRDRX_DS_EXTR A, GIIS_INTERMEDIARY b
                   WHERE a.session_id = p_session_id
                     AND (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0
                     AND a.buss_source = p_buss_source
                     AND DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) = p_buss_source_type
                     AND a.buss_source = b.intm_no(+)
                     AND a.brdrx_record_id IN (SELECT a.brdrx_record_id
                                                 FROM GICL_RES_BRDRX_EXTR a
                                                WHERE a.session_id = p_session_id 
                                                  AND a.claim_id = NVL(p_claim_id,a.claim_id)
                                                  AND (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0)
                ORDER BY a.buss_source)
        LOOP
             v_total.outstanding_loss   := CF_OS_LOSS2(p_session_id, i.brdrx_record_id, i.brdrx_ds_record_id, i.outstanding_loss); 
             v_total.buss_source        := i.buss_source;
             v_total.buss_source_type   := i.buss_source_type;
             PIPE ROW (v_total);            
        END LOOP;
    ELSIF p_buss_source_type IS NULL
    THEN
       FOR i IN (SELECT a.brdrx_record_id, a.brdrx_ds_record_id, line_cd, a.subline_cd, a.iss_cd, a.buss_source,
                        (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) outstanding_loss,
                        DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type
                   FROM GICL_RES_BRDRX_DS_EXTR A, GIIS_INTERMEDIARY b
                  WHERE a.session_id = p_session_id
                    AND (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0
                    AND a.buss_source = p_buss_source
                    AND a.buss_source = b.intm_no(+)
                    AND a.brdrx_record_id IN (SELECT a.brdrx_record_id
                                                FROM GICL_RES_BRDRX_EXTR a
                                               WHERE a.session_id = p_session_id 
                                                 AND a.claim_id = NVL(p_claim_id,a.claim_id)
                                                 AND (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0)
               ORDER BY a.buss_source)
        LOOP
             v_total.outstanding_loss   := CF_OS_LOSS2(p_session_id, i.brdrx_record_id, i.brdrx_ds_record_id, i.outstanding_loss); 
             v_total.buss_source        := i.buss_source;
             v_total.buss_source_type   := i.buss_source_type;
             PIPE ROW (v_total);            
        END LOOP;    
    END IF;

       FOR i IN (SELECT   a.buss_source,
                          SUM ( (  NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) ) outstanding_loss,
                          b.trty_name, a.grp_seq_no
                     FROM GICL_RES_BRDRX_DS_EXTR a, GIIS_DIST_SHARE b
                    WHERE ( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                      AND a.session_id = p_session_id
                      AND a.claim_id = NVL (p_claim_id, a.claim_id)
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                      AND a.buss_source = p_buss_source
                 GROUP BY a.buss_source, b.trty_name, a.grp_seq_no
                 ORDER BY a.grp_seq_no)
       LOOP
          v_total.outstanding_loss_trty  := CF_OUTSTANDING_LOSS_BUSS(p_session_id, p_claim_id, i.outstanding_loss, i.buss_source, i.grp_seq_no);
          v_total.buss_source            := i.buss_source;
          v_total.treaty_name            := i.trty_name;
          v_total.buss_source_type       := NULL;
          v_total.outstanding_loss       := NULL;
          PIPE ROW (v_total);
       END LOOP;    
    RETURN;        
   END get_total_per_buss_source;

   FUNCTION get_total_per_buss_source_type (
      p_session_id          GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id            GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source_type    VARCHAR2
   )
      RETURN total_tab PIPELINED
   IS
      v_total   total_type;
   BEGIN
        IF p_buss_source_type IS NOT NULL
        THEN
            FOR i IN (SELECT a.brdrx_record_id, a.brdrx_ds_record_id, a.grp_seq_no, a.shr_pct, 
                             a.line_cd, a.subline_cd, a.iss_cd, a.buss_source,
                             DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                             (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) outstanding_loss
                        FROM GICL_RES_BRDRX_DS_EXTR A, GIIS_INTERMEDIARY b
                       WHERE a.session_id = p_session_id
                         AND (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0
                         AND a.buss_source = b.intm_no(+)
                         AND DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) = NVL(p_buss_source_type,null)
                         AND a.brdrx_record_id IN (SELECT a.brdrx_record_id
                                                     FROM GICL_RES_BRDRX_EXTR A
                                                    WHERE a.session_id = p_session_id 
                                                      AND a.claim_id = NVL(p_claim_id,a.claim_id)
                                                      AND (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0)) 
          LOOP
             v_total.outstanding_loss   := CF_OS_LOSS2(p_session_id, i.brdrx_record_id, i.brdrx_ds_record_id, i.outstanding_loss); 
             v_total.buss_source_type   := i.buss_source_type;
             PIPE ROW (v_total);
          END LOOP;
        ELSIF p_buss_source_type IS NULL
        THEN
            FOR i IN (SELECT a.brdrx_record_id, a.brdrx_ds_record_id, a.grp_seq_no,
                             a.shr_pct, a.line_cd, a.subline_cd, a.iss_cd, a.buss_source,
                             DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                             (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) outstanding_loss
                        FROM GICL_RES_BRDRX_DS_EXTR A, GIIS_INTERMEDIARY b
                       WHERE a.session_id = p_session_id
                         AND (NVl(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0
                        AND a.buss_source = b.intm_no(+)
                        AND a.brdrx_record_id IN (SELECT a.brdrx_record_id
                                                    FROM GICL_RES_BRDRX_EXTR a
                                                   WHERE a.session_id = p_session_id 
                                                     AND a.claim_id = NVL(p_claim_id,a.claim_id)
                                                     AND (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0)) 
          LOOP
             v_total.outstanding_loss   := CF_OS_LOSS2(p_session_id, i.brdrx_record_id, i.brdrx_ds_record_id, i.outstanding_loss); 
             v_total.buss_source_type   := i.buss_source_type;
             PIPE ROW (v_total);
          END LOOP; 
        END IF;

       FOR i IN (SELECT   DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type, DECODE (a.iss_cd, 'RI', 'RI', d.intm_type) buss_source_type,
                          SUM (  NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) outstanding_loss, c.trty_name, a.grp_seq_no
                     FROM GICL_RES_BRDRX_DS_EXTR a,
                          GIIS_DIST_SHARE c,
                          GIIS_INTERMEDIARY d
                    WHERE (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0
                      AND a.session_id = p_session_id
                      AND a.claim_id = NVL (p_claim_id, a.claim_id)
                      AND c.line_cd = a.line_cd
                      AND c.share_cd = a.grp_seq_no
                      AND a.buss_source = d.intm_no(+)
                      AND DECODE (a.iss_cd, 'RI', 'RI', d.intm_type) = NVL(p_buss_source_type,NULL)
                 GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'), DECODE (a.iss_cd, 'RI', 'RI', d.intm_type), c.trty_name, a.grp_seq_no
                 ORDER BY a.grp_seq_no)
       LOOP
          v_total.outstanding_loss_trty := CF_OUTSTANDING_LOSS_BUSS_TYPE(p_session_id, p_claim_id, i.outstanding_loss, i.iss_type, i.grp_seq_no);
          v_total.buss_source_type      := i.buss_source_type;
          v_total.treaty_name           := i.trty_name;
          v_total.outstanding_loss      := NULL;
          PIPE ROW (v_total);
       END LOOP;
    RETURN;    
   END get_total_per_buss_source_type;

   FUNCTION get_report_grand_total (
      p_session_id   GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id     GICL_RES_BRDRX_EXTR.claim_id%TYPE
   )
      RETURN grand_total_tab PIPELINED
   IS
      v_grand   grand_total_type;
   BEGIN
      FOR i IN (SELECT   SUM ( NVL (b.expense_reserve, 0) - NVL (b.expenses_paid, 0) ) grand_treaty_loss,
                         c.trty_name, b.grp_seq_no
                    FROM GICL_RES_BRDRX_DS_EXTR b, GIIS_DIST_SHARE c
                   WHERE b.line_cd = c.line_cd
                     AND b.grp_seq_no = c.share_cd
                     AND ( NVL (b.expense_reserve, 0) - NVL (b.expenses_paid, 0) ) > 0
                     AND b.session_id = p_session_id
                GROUP BY c.trty_name, b.grp_seq_no
                ORDER BY b.grp_seq_no)
      LOOP
         v_grand.grand_treaty_loss  := CF_OUTSTANING_LOSS8(p_session_id,p_claim_id,i.grand_treaty_loss,i.grp_seq_no);
         v_grand.treaty_name        := i.trty_name;
         PIPE ROW (v_grand);
      END LOOP;
       
      FOR v IN (SELECT a.brdrx_record_id, a.brdrx_ds_record_id, a.line_cd, a.subline_cd, a.iss_cd, 
                       a.buss_source,(NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_LOSS
                  FROM GICL_RES_BRDRX_DS_EXTR A
                 WHERE a.session_id = p_session_id
                   AND (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0
                   AND a.brdrx_record_id IN (SELECT a.brdrx_record_id
                                               FROM GICL_RES_BRDRX_EXTR A
                                              WHERE a.session_id = p_session_id 
                                                AND a.claim_id = nvl(p_claim_id,a.claim_id)
                                                AND (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) > 0)) 
      LOOP
        v_grand.grand_os_loss      := CF_OS_LOSS2(p_session_id, v.brdrx_record_id, v.brdrx_ds_record_id, v.outstanding_loss); 
        v_grand.grand_treaty_loss  := NULL;
        v_grand.treaty_name        := NULL;                              
        PIPE ROW (v_grand);
      END LOOP;
        
   END get_report_grand_total;
   
   FUNCTION CF_INTM_RI2Formula(
        p_claim_id      gicl_intm_itmperil.CLAIM_ID%type,
        p_item_no       gicl_intm_itmperil.ITEM_NO%type,
        p_peril_cd      gicl_intm_itmperil.PERIL_CD%type
    ) RETURN VARCHAR2
    AS
        v_pol_iss_cd     gicl_claims.pol_iss_cd%type; 
        v_intm_ri        VARCHAR2(1000);
    BEGIN
        BEGIN
            SELECT pol_iss_cd
              INTO v_pol_iss_cd 
              FROM gicl_claims
             WHERE claim_id = p_claim_id;   
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_pol_iss_cd := NULL; 
        END;    
    
        IF v_pol_iss_cd = GIACP.V('RI_ISS_CD') THEN
            BEGIN 
                FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                            FROM gicl_claims a, giis_reinsurer b
                           WHERE a.ri_cd = b.ri_cd
                             AND a.claim_id = p_claim_id)
                LOOP
                    v_intm_ri := TO_CHAR(r.ri_cd)||CHR(10)||r.ri_name;
                END LOOP;
            END;
        ELSE            
            BEGIN 
                FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                            FROM gicl_intm_itmperil a, giis_intermediary b
                           WHERE a.intm_no = b.intm_no
                             AND a.claim_id = p_claim_id
                             AND a.item_no = p_item_no
                             AND a.peril_cd = p_peril_cd) 
                LOOP
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||CHR(10)||
                                 m.intm_name||CHR(10)||v_intm_ri;
                END LOOP;
            END; 
        END IF;
        
        RETURN(v_intm_ri);
    
    END CF_INTM_RI2Formula;
   
   /* Handle running multipage column 03.12.2014 - J. Diago */
   
   FUNCTION get_giclr205er_parent(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE
   )
     RETURN giclr205er_parent_tab PIPELINED
   IS
      v_row                giclr205er_parent_type;
      v_treaty_tab         treaty_tab;
      v_index              NUMBER := 0;
      v_id                 NUMBER := 0;
   BEGIN
      FOR bst IN (SELECT DISTINCT 
                         DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                         DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                         a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year
                    FROM gicl_res_brdrx_extr a, giis_intermediary b
                   WHERE a.buss_source = b.intm_no(+)
                     AND a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0
                   ORDER BY 1)
      LOOP
         v_id := 0;
         v_index := 0;
         v_treaty_tab := treaty_tab();
         
         FOR trty IN (SELECT DISTINCT 
                             a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year,
                             a.grp_seq_no, b.trty_name
                        FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                       WHERE a.line_cd = b.line_cd
                         AND a.grp_seq_no = b.share_cd
                         AND b.line_cd = bst.line_cd
                         AND a.session_id = p_session_id                        
                         AND a.buss_source = bst.buss_source
                         AND a.iss_cd = bst.iss_cd
                         AND a.line_cd = bst.line_cd
                         AND a.subline_cd = bst.subline_cd
                         AND a.loss_year = bst.loss_year
                       ORDER BY a.grp_seq_no)
         LOOP
            v_index := v_index + 1;
            v_treaty_tab.EXTEND;
            v_treaty_tab(v_index).grp_seq_no := trty.grp_seq_no;
            v_treaty_tab(v_index).trty_name := trty.trty_name;
         END LOOP;
         
         v_index := 1;
         
         LOOP
            v_id := v_id + 1;
            v_row := NULL;
            
            v_row.buss_source_type := bst.buss_source_type;
            
            BEGIN
              SELECT intm_desc
                INTO v_row.buss_source_type_name
                FROM giis_intm_type
               WHERE intm_type = bst.buss_source_type;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 v_row.buss_source_type_name := 'REINSURER ';    
              WHEN OTHERS THEN
                 v_row.buss_source_type_name := '';
            END;
            
            v_row.buss_source := bst.buss_source;
            IF bst.iss_type = 'RI' THEN
               BEGIN
                  SELECT ri_name
                    INTO v_row.buss_source_name
                    FROM giis_reinsurer
                   WHERE ri_cd  = bst.buss_source;
               EXCEPTION
                 WHEN OTHERS THEN
                    v_row.buss_source_name := '';
               END;
            ELSE
               BEGIN
                  SELECT intm_name
                    INTO v_row.buss_source_name
                    FROM giis_intermediary
                   WHERE intm_no  = bst.buss_source;
               EXCEPTION
                  WHEN OTHERS THEN
                     v_row.buss_source_name := '';
               END;
            END IF;
            
            v_row.iss_cd := bst.iss_cd;
            BEGIN
               SELECT iss_name
                 INTO v_row.iss_name
                  FROM giis_issource
               WHERE iss_cd  = bst.iss_cd;
            EXCEPTION
               WHEN OTHERS THEN
                  v_row.iss_name := '';
            END;
            
            v_row.subline_cd := bst.subline_cd;
            BEGIN
               SELECT subline_name
                 INTO v_row.subline_name
                 FROM giis_subline
                WHERE subline_cd = bst.subline_cd
                  AND line_cd    = bst.line_cd;
            EXCEPTION
               WHEN OTHERS THEN 
                  v_row.subline_name := '';
            END;
            
            v_row.line_cd := bst.line_cd;
            BEGIN
               SELECT line_name
                 INTO v_row.line_name
                 FROM giis_line
                WHERE line_cd = bst.line_cd;
            EXCEPTION
               WHEN OTHERS THEN 
                 v_row.line_name := '';
            END;
            
            v_row.loss_year := bst.loss_year;
            v_row.loss_year_dummy := TO_CHAR(v_row.loss_year || '_' || v_id);
           
            IF v_treaty_tab.EXISTS(v_index) THEN
               v_row.grp_seq_no1 := v_treaty_tab(v_index).grp_seq_no;
               v_row.treaty1 := v_treaty_tab(v_index).trty_name;
               v_index := v_index + 1;
            END IF;
            
            IF v_treaty_tab.EXISTS(v_index) THEN
               v_row.grp_seq_no2 := v_treaty_tab(v_index).grp_seq_no;
               v_row.treaty2 := v_treaty_tab(v_index).trty_name;
               v_index := v_index + 1;
            END IF;
            
            IF v_treaty_tab.EXISTS(v_index) THEN
               v_row.grp_seq_no3 := v_treaty_tab(v_index).grp_seq_no;
               v_row.treaty3 := v_treaty_tab(v_index).trty_name;
               v_index := v_index + 1;
            END IF;
            
            IF v_treaty_tab.EXISTS(v_index) THEN
               v_row.grp_seq_no4 := v_treaty_tab(v_index).grp_seq_no;
               v_row.treaty4 := v_treaty_tab(v_index).trty_name;
               v_index := v_index + 1;
            END IF;
           
            PIPE ROW(v_row);
           
            EXIT WHEN v_index > v_treaty_tab.COUNT;
         END LOOP;
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_giclr205er_claim(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE
   )
     RETURN giclr205er_claim_tab PIPELINED
   IS
      v_row                giclr205er_claim_type;
      v_line               giis_line.line_cd%TYPE;
   BEGIN
      FOR claim IN (SELECT DISTINCT a.claim_id, a.claim_no, a.policy_no, b.assd_name,
                           a.incept_date, a.expiry_date, a.loss_date, a.item_no,
                           a.line_cd
                      FROM gicl_res_brdrx_extr a, giis_assured b
                     WHERE a.assd_no = b.assd_no
                       AND a.session_id = p_session_id
                       AND a.claim_id = NVL (p_claim_id, a.claim_id)
                       AND (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0
                       AND a.buss_source = p_buss_source
                       AND a.line_cd = p_line_cd
                       AND a.subline_cd = p_subline_cd
                       AND a.iss_cd = p_iss_cd
                     ORDER BY a.claim_no)
      LOOP
         v_row.claim_id := claim.claim_id;
         v_row.claim_no := claim.claim_no;
         v_row.policy_no := claim.policy_no;
         v_row.assd_name := claim.assd_name;
         v_row.incept_date := claim.incept_date;
         v_row.expiry_date := claim.expiry_date;
         v_row.loss_date := claim.loss_date;
         v_row.item_no := claim.item_no;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_giclr205er_item_main(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE
   )
     RETURN giclr205er_item_main_tab PIPELINED
   IS
      v_row                giclr205er_item_main_type;
   BEGIN
      FOR item_name IN (SELECT DISTINCT a.claim_id, a.claim_no, a.policy_no, 
                               a.item_no, a.line_cd, a.grouped_item_no
                          FROM gicl_res_brdrx_extr a, giis_assured b
                         WHERE a.assd_no = b.assd_no
                           AND a.session_id = p_session_id
                           AND a.claim_id = NVL (p_claim_id, a.claim_id)
                           AND (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0
                           AND a.buss_source = p_buss_source
                           AND a.line_cd = p_line_cd
                           AND a.subline_cd = p_subline_cd
                           AND a.iss_cd = p_iss_cd
                         ORDER BY a.claim_no)
      LOOP
         v_row.claim_id := item_name.claim_id;
         v_row.claim_no := item_name.claim_no;
         v_row.policy_no := item_name.policy_no;
         v_row.item_no := item_name.item_no;
         v_row.item_title := CPI.get_gpa_item_title(item_name.claim_id, 
                                                   item_name.line_cd, 
                                                   item_name.item_no, 
                                                   item_name.grouped_item_no);
        
         PIPE ROW(v_row);
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_giclr205er_item(
      p_session_id         GICL_RES_BRDRX_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_item_no            GICL_RES_BRDRX_EXTR.item_no%TYPE
   )
     RETURN giclr205er_item_tab PIPELINED
   IS
      v_row                     giclr205er_item_type;
      v_outstanding_expense     GICL_RES_BRDRX_EXTR.losses_paid%TYPE;
      v_rec_amt                 GICL_RCVRY_BRDRX_EXTR.recovered_amt%TYPE;
   BEGIN
      FOR item IN (SELECT a.claim_id, a.claim_no, a.policy_no, a.item_no, a.tsi_amt,
                          a.loss_cat_cd, a.line_cd, a.peril_cd, a.clm_loss_id, a.brdrx_record_id,
                          (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) outstanding_expense
                     FROM gicl_res_brdrx_extr a
                    WHERE a.session_id = p_session_id
                      AND a.claim_id = NVL (p_claim_id, a.claim_id)
                      AND (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0
                      AND a.buss_source = p_buss_source
                      AND a.item_no = p_item_no                     
                    ORDER BY a.claim_no)
      LOOP
         v_row.claim_id := item.claim_id;
         v_row.claim_no := item.claim_no;
         v_row.policy_no := item.policy_no;
         v_row.item_no := item.item_no;
         v_row.tsi_amt := item.tsi_amt;
         --v_row.outstanding_expense := item.outstanding_expense;
         v_outstanding_expense := item.outstanding_expense;
         v_row.brdrx_record_id := item.brdrx_record_id;
         
         BEGIN
           SELECT peril_name
             INTO v_row.peril_name
             FROM giis_peril
            WHERE peril_cd  = item.peril_cd
              AND line_cd = item.line_cd;
         END;
         
         v_row.intm_name := GICLR205ER_PKG.CF_INTM_RI2Formula(item.claim_id, item.item_no, item.peril_cd);
         
         BEGIN
            FOR j IN (SELECT recovered_amt rec_amt
                        FROM gicl_rcvry_brdrx_extr
                       WHERE session_id = p_session_id
                         AND claim_id = item.claim_id
                         AND item_no = item.item_no
                         AND peril_cd = item.peril_cd
                         AND payee_type = 'L')
            LOOP
               v_rec_amt := j.rec_amt;
            END LOOP;
         END;
         
         IF NVL(v_rec_amt, 0) != 0 THEN
            v_row.outstanding_expense := v_outstanding_expense - v_rec_amt;
         ELSE
            v_row.outstanding_expense := v_outstanding_expense; 
         END IF;
         PIPE ROW(v_row);
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_giclr205er_treaty(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_loss_year_dummy    VARCHAR2,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE 
   )
     RETURN outstanding_e_tab_v PIPELINED
   IS
      TYPE ref_cursor      IS REF CURSOR;
      TYPE t_table         IS TABLE OF VARCHAR2(1000);
      v_table              t_table;
      cur                  ref_cursor;
      v_row                outstanding_e_type_v;
      v_index              NUMBER := 1;
      v_temp               VARCHAR2(1000);
      v_grp_seq_no         GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE;
      v_loop               VARCHAR2(2500);
      v_cur                VARCHAR2(1000);
      v_claim_id           NUMBER(12);
      v_cnt_grp_seq_no     NUMBER := 0;
   BEGIN
      v_table   := t_table();
      
      IF p_claim_id IS NULL THEN
         v_claim_id := -1;
      ELSE
         v_claim_id := p_claim_id;
      END IF;
      
      BEGIN       
        SELECT COUNT (DISTINCT a.grp_seq_no)
          INTO v_cnt_grp_seq_no
          FROM gicl_res_brdrx_ds_extr a
         WHERE a.session_id = p_session_id
           AND a.buss_source = p_buss_source
           AND a.iss_cd = p_iss_cd
           AND a.line_cd = p_line_cd
           AND a.subline_cd = p_subline_cd
           AND a.loss_year = p_loss_year;
      END;
      
      IF TO_NUMBER(SUBSTR(p_loss_year_dummy,6)) > 1
       THEN
        v_cnt_grp_seq_no := v_cnt_grp_seq_no - ((TO_NUMBER(SUBSTR(p_loss_year_dummy,6))*4)-4);
      END IF;
      
      FOR buss_source IN (SELECT buss_source, iss_cd, line_cd, subline_cd, loss_year, 
                                 grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                            FROM TABLE (giclr205er_pkg.get_giclr205er_parent(p_session_id, p_claim_id))
                           WHERE buss_source = p_buss_source
                             AND loss_year_dummy = p_loss_year_dummy
                             AND subline_cd = p_subline_cd)
      LOOP
         FOR treaty IN 1 .. 4
         LOOP
            IF treaty = 1 THEN
               v_grp_seq_no := buss_source.grp_seq_no1;
            ELSIF treaty = 2 THEN
               v_grp_seq_no := buss_source.grp_seq_no2;
            ELSIF treaty = 3 THEN
               v_grp_seq_no := buss_source.grp_seq_no3;
            ELSIF treaty = 4 THEN
               v_grp_seq_no := buss_source.grp_seq_no4;
            END IF;
            
            IF v_grp_seq_no IS NOT NULL THEN
               v_loop := 'SELECT outstanding_loss2
                         FROM TABLE (giclr205er_pkg.get_treaty ('||p_session_id||',
                                                                        '||v_claim_id||',
                                                                        '||p_brdrx_record_id||',
                                                                        '||buss_source.buss_source||',
                                                                        '''||buss_source.iss_cd||''',
                                                                        '''||buss_source.line_cd||''',
                                                                        '''||buss_source.subline_cd||''',
                                                                        '||buss_source.loss_year||'
                                                                      )
                                    )
                        WHERE grp_seq_no2 = '||v_grp_seq_no;
                        
                v_temp := NULL;
                
                OPEN cur FOR v_loop;
                LOOP
                   v_cur := NULL;
                   FETCH cur INTO v_cur;
                   
                   BEGIN
                      IF v_temp IS NOT NULL THEN
                         v_temp := v_temp || CHR(10);
                      END IF;
                
                      SELECT v_temp || DECODE(SUBSTR(TRIM(TO_CHAR(v_cur, '9,999,999,999,999,999.99')), 1, 1), '.',
                             '0' || TRIM(TO_CHAR(v_cur, '9,999,999,999,999,999.99')),
                             TRIM(TO_CHAR(v_cur, '9,999,999,999,999,999.99')))
                        INTO v_temp
                        FROM DUAL;
                   EXCEPTION
                      WHEN OTHERS THEN
                         v_temp := NULL;
                   END;
                   
                   EXIT WHEN cur%NOTFOUND;
                END LOOP;
                
                v_table.EXTEND;
                v_table(v_index) := NVL(v_temp,'0.00');
                v_index := v_index + 1;
                CLOSE cur;
            ELSE
               IF treaty <= v_cnt_grp_seq_no
                 THEN   
                    v_table.EXTEND;
                    v_table (v_index) := '0.00';
                    v_index := v_index + 1;
               ELSE
                    EXIT;
               END IF; 
            END IF;
            
            
         END LOOP;
      END LOOP;
      
      v_index := 1;
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_expense1 := v_table(v_index);
         v_index := v_index + 1;
      ELSIF v_cnt_grp_seq_no > 0 AND v_cnt_grp_seq_no >= v_index 
       THEN
          v_row.outstanding_expense1 := '0.00';
          v_index := v_index + 1;
      END IF;
      
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_expense2 := v_table(v_index);
         v_index := v_index + 1;
      ELSIF v_cnt_grp_seq_no > 0 AND v_cnt_grp_seq_no >= v_index 
       THEN
          v_row.outstanding_expense2 := '0.00';
          v_index := v_index + 1;
      END IF;
      
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_expense3 := v_table(v_index);
         v_index := v_index + 1;
      ELSIF v_cnt_grp_seq_no > 0 AND v_cnt_grp_seq_no >= v_index 
       THEN
          v_row.outstanding_expense3 := '0.00';
          v_index := v_index + 1;
      END IF;
      
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_expense4 := v_table(v_index);
         v_index := v_index + 1;
      ELSIF v_cnt_grp_seq_no > 0 AND v_cnt_grp_seq_no >= v_index 
       THEN
          v_row.outstanding_expense4 := '0.00';
          v_index := v_index + 1;
      END IF;
      
      PIPE ROW(v_row);
      
      RETURN;
   END;
   
   FUNCTION get_giclr205er_facul(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_loss_year_dummy    VARCHAR2,
      p_brdrx_record_id    GICL_RES_BRDRX_EXTR.brdrx_record_id%TYPE,
      p_grp_seq_no1        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no2        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no3        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE,
      p_grp_seq_no4        GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE
   )
     RETURN facul_tab PIPELINED
   IS
      v_row                facul_type;
   BEGIN
      FOR buss_source IN (SELECT buss_source, iss_cd, line_cd, subline_cd, loss_year, 
                                 grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                            FROM TABLE (giclr205er_pkg.get_giclr205er_parent(p_session_id, p_claim_id))
                           WHERE buss_source = p_buss_source
                             AND loss_year_dummy = p_loss_year_dummy)
      LOOP
         FOR facul IN (SELECT *
                         FROM TABLE(giclr205er_pkg.get_treaty_facul(p_session_id,p_claim_id,p_brdrx_record_id,buss_source.buss_source
                                    ,buss_source.iss_cd,buss_source.line_cd,buss_source.subline_cd,buss_source.loss_year))
                        WHERE grp_seq_no2 IN (p_grp_seq_no1, p_grp_seq_no2, p_grp_seq_no3, p_grp_seq_no4)
                          AND grp_seq_no2 = 999
                          AND facul_ri_name2 IS NOT NULL
                          AND brdrx_record_id2 = p_brdrx_record_id)
         LOOP
            v_row := NULL;
            IF p_grp_seq_no1 = 999 THEN
               v_row.ri_name1 := facul.facul_ri_name2;
               v_row.outstanding_expense1 := facul.outstanding_loss3;
            ELSIF p_grp_seq_no2 = 999 THEN
               v_row.ri_name2 := facul.facul_ri_name2;
               v_row.outstanding_expense2 := facul.outstanding_loss3;
            ELSIF p_grp_seq_no3 = 999 THEN
               v_row.ri_name3 := facul.facul_ri_name2;
               v_row.outstanding_expense3 := facul.outstanding_loss3;
            ELSIF p_grp_seq_no4 = 999 THEN
               v_row.ri_name4 := facul.facul_ri_name2;
               v_row.outstanding_expense4 := facul.outstanding_loss3;
            END IF;
            
            PIPE ROW(v_row);
         END LOOP;
      END LOOP;
   END;
   
   FUNCTION get_giclr205er_os_total(
     p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
     p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
     p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
     p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
     p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
     p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE
   )
     RETURN total_os_e_tab PIPELINED
   IS
      v_total              total_os_e_type;
   BEGIN
      FOR total IN (SELECT SUM ((NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0))) total_os_expense
                      FROM gicl_res_brdrx_extr a
                     WHERE a.session_id = p_session_id
                       AND a.claim_id = NVL (p_claim_id, a.claim_id)
                       AND NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) > 0
                       AND a.buss_source = p_buss_source
                       AND a.line_cd = p_line_cd
                       AND a.subline_cd = p_subline_cd
                       AND a.iss_cd = p_iss_cd
                     ORDER BY a.claim_no)
      LOOP
         v_total.total_os_expense := total.total_os_expense;
         PIPE ROW(v_total);
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_giclr205er_treaty_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_loss_year_dummy    VARCHAR2,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN outstanding_e_tab_v PIPELINED
   IS  
      TYPE ref_cursor      IS REF CURSOR;
      TYPE t_table         IS TABLE OF VARCHAR2(1000);
      v_table              t_table;
      cur                  ref_cursor;
      v_row                outstanding_e_type_v;
      v_index              NUMBER := 1;
      v_temp               VARCHAR2(1000);
      v_grp_seq_no         GICL_RES_BRDRX_DS_EXTR.grp_seq_no%TYPE;
      v_loop               VARCHAR2(2500);
      v_cur                VARCHAR2(1000);
      v_claim_id           NUMBER(12) := -1;
      v_brdrx_record_id    NUMBER(12) := -1;
      v_cnt_grp_seq_no     NUMBER := 0;
   BEGIN
      v_table   := t_table();
      
      BEGIN       
        SELECT COUNT (DISTINCT a.grp_seq_no)
          INTO v_cnt_grp_seq_no
          FROM gicl_res_brdrx_ds_extr a
         WHERE a.session_id = p_session_id
           AND a.buss_source = p_buss_source
           AND a.iss_cd = p_iss_cd
           AND a.line_cd = p_line_cd
           AND a.subline_cd = p_subline_cd
           AND a.loss_year = p_loss_year;
      END;
       
      IF TO_NUMBER(SUBSTR(p_loss_year_dummy,6)) > 1
       THEN
        v_cnt_grp_seq_no := v_cnt_grp_seq_no - ((TO_NUMBER(SUBSTR(p_loss_year_dummy,6))*4)-4);
      END IF;
      
      FOR buss_source IN (SELECT buss_source, iss_cd, line_cd, subline_cd, loss_year, 
                                 grp_seq_no1, grp_seq_no2, grp_seq_no3, grp_seq_no4
                            FROM TABLE (giclr205er_pkg.get_giclr205er_parent(p_session_id, p_claim_id))
                           WHERE buss_source = p_buss_source
                             AND loss_year_dummy = p_loss_year_dummy
                             AND iss_cd = p_iss_cd
                             AND line_cd = p_line_cd
                             AND subline_cd = p_subline_cd
                         )
      LOOP
         FOR treaty IN 1 .. 4
         LOOP
            IF treaty = 1 THEN
               v_grp_seq_no := buss_source.grp_seq_no1;
            ELSIF treaty = 2 THEN
               v_grp_seq_no := buss_source.grp_seq_no2;
            ELSIF treaty = 3 THEN
               v_grp_seq_no := buss_source.grp_seq_no3;
            ELSIF treaty = 4 THEN
               v_grp_seq_no := buss_source.grp_seq_no4;
            END IF;
            
            IF v_grp_seq_no IS NOT NULL THEN
               v_loop := 'SELECT SUM (outstanding_loss3)
                         FROM (SELECT outstanding_loss3
                                 FROM TABLE (giclr205er_pkg.get_treaty_facul('||p_session_id||',
                                                                             '||v_claim_id||',
                                                                             '||v_brdrx_record_id||',
                                                                             '''||p_buss_source||''',
                                                                             '''||buss_source.iss_cd||''',
                                                                             '''||buss_source.line_cd||''',
                                                                             '''||buss_source.subline_cd||''',
                                                                             '||buss_source.loss_year||'
                                                                            )
                                            )
                        WHERE grp_seq_no2 = '||v_grp_seq_no||'
                        GROUP BY brdrx_record_id2, outstanding_loss3)';            
            
                OPEN cur FOR v_loop;
                LOOP
                   FETCH cur INTO v_temp;
                   EXIT WHEN cur%NOTFOUND;
                END LOOP;
                
                v_table.EXTEND;
                v_table(v_index) := NVL(v_temp,'0.00');
                v_index := v_index + 1;
                CLOSE cur;
            ELSE
               IF treaty <= v_cnt_grp_seq_no
               THEN                 
                  v_table.EXTEND;
                  v_table (v_index) := '0.00';
                  v_index := v_index + 1;
               ELSE
                  EXIT;
               END IF;
            END IF;            
         END LOOP;
      END LOOP;
      
      v_index := 1;
     
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_expense1 := v_table(v_index);
         v_index := v_index + 1;
      ELSIF v_cnt_grp_seq_no > 0 AND v_cnt_grp_seq_no >= v_index 
       THEN
          v_row.outstanding_expense1 := '0.00';
          v_index := v_index + 1;
      END IF;
          
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_expense2 := v_table(v_index);
         v_index := v_index + 1;
      ELSIF v_cnt_grp_seq_no > 0 AND v_cnt_grp_seq_no >= v_index 
       THEN
          v_row.outstanding_expense2 := '0.00';
          v_index := v_index + 1;
      END IF;
          
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_expense3 := v_table(v_index);
         v_index := v_index + 1;
      ELSIF v_cnt_grp_seq_no > 0 AND v_cnt_grp_seq_no >= v_index 
       THEN
          v_row.outstanding_expense3 := '0.00';
          v_index := v_index + 1;
      END IF;
          
      IF v_table.EXISTS(v_index) THEN
         v_row.outstanding_expense4 := v_table(v_index);
         v_index := v_index + 1;
      ELSIF v_cnt_grp_seq_no > 0 AND v_cnt_grp_seq_no >= v_index 
       THEN
          v_row.outstanding_expense4 := '0.00';
          v_index := v_index + 1;
      END IF;
      
      PIPE ROW(v_row);
      
      RETURN;
   END;
   
   FUNCTION get_treaty_ri2(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_subline_cd         GICL_RES_BRDRX_EXTR.subline_cd%TYPE,
      p_loss_year          GICL_RES_BRDRX_EXTR.loss_year%TYPE
   )
     RETURN treaty_ri_tab2 PIPELINED
   AS
      rep                  treaty_ri_type2;
   BEGIN
      FOR j IN (SELECT DISTINCT a.ri_cd, a.line_cd, a.grp_seq_no,
                       DECODE(a.prnt_ri_cd, null, a.ri_cd, a.prnt_ri_cd) trty_ri_cd
                  FROM GICL_RES_BRDRX_RIDS_EXTR a,
                       GIIS_TRTY_PANEL b,
                       GICL_RES_BRDRX_EXTR c,
                       GICL_RES_BRDRX_DS_EXTR d
                 WHERE 1 = 1
                   AND a.grp_seq_no <> 999
                   AND a.session_id = p_session_id
                   AND a.session_id = c.session_id
                   AND a.session_id = d.session_id
                   AND c.brdrx_record_id = d.brdrx_record_id
                   AND a.brdrx_ds_record_id = d.brdrx_ds_record_id
                   AND a.claim_id = nvl(p_claim_id, a.claim_id)
                   AND a.line_cd = b.line_cd
                   AND a.grp_seq_no = b.trty_seq_no
                   AND a.ri_cd = b.ri_cd
                   AND (( NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) ) > 0
                    OR   (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0)
                   AND c.buss_source = p_buss_source 
                   AND c.loss_year = p_loss_year
                   AND c.iss_cd = p_iss_cd
                   AND c.line_cd = p_line_cd
                   AND c.subline_cd = p_subline_cd
                 ORDER BY a.grp_seq_no, a.ri_cd, DECODE(a.prnt_ri_cd, null, a.ri_cd, a.prnt_ri_cd))
      LOOP
         rep.line_cd := j.line_cd;
         rep.grp_seq_no := j.grp_seq_no;
         rep.ri_cd := j.ri_cd;
         rep.trty_ri_cd := j.trty_ri_cd;         
         rep.outstanding_expense := 0.00;
                  
         BEGIN
            SELECT trty_name
              INTO rep.treaty_name
              FROM giis_dist_share
             WHERE share_cd = j.grp_seq_no AND line_cd = j.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rep.treaty_name := NULL;
         END;
         
         BEGIN
            SELECT ri_sname
              INTO rep.ri_name
              FROM giis_reinsurer
             WHERE ri_cd = j.ri_cd;
         EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
               rep.ri_name := NULL;
         END;
         
         BEGIN
            FOR shr IN (SELECT trty_shr_pct
                          FROM giis_trty_panel
                         WHERE line_cd = j.line_cd
                           AND trty_seq_no = j.grp_seq_no
                           AND ri_cd = j.ri_cd)
            LOOP
               rep.trty_shr_pct := shr.trty_shr_pct;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rep.trty_shr_pct := NULL;
         END;
         
         FOR a IN (SELECT (NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0)) outstanding_expense
                     FROM GICL_RES_BRDRX_RIDS_EXTR a
                    WHERE a.grp_seq_no <> 999
                      AND a.session_id = p_session_id
                      AND NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) > 0
                      AND a.grp_seq_no = j.grp_seq_no
                      AND a.ri_cd = j.ri_cd
                      AND a.brdrx_rids_record_id IN(SELECT a.brdrx_rids_record_id
                                                      FROM GICL_RES_BRDRX_RIDS_EXTR a,
                                                           GIIS_TRTY_PANEL b,
                                                           GICL_RES_BRDRX_EXTR c,
                                                           GICL_RES_BRDRX_DS_EXTR d
                                                     WHERE a.grp_seq_no <> 999
                                                       AND a.session_id = p_session_id
                                                       AND a.session_id = c.session_id
                                                       AND a.session_id = d.session_id
                                                       AND c.brdrx_record_id = d.brdrx_record_id
                                                       AND a.brdrx_ds_record_id = d.brdrx_ds_record_id
                                                       AND a.claim_id = nvl(p_claim_id, a.claim_id)
                                                       AND a.line_cd = b.line_cd
                                                       AND a.grp_seq_no = b.trty_seq_no
                                                       AND a.ri_cd = b.ri_cd
                                                       AND NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) > 0
                                                       AND c.buss_source = p_buss_source 
                                                       AND c.loss_year = p_loss_year
                                                       AND c.iss_cd = p_iss_cd
                                                       AND c.line_cd = p_line_cd
                                                       AND c.subline_cd = p_subline_cd)
                    ORDER BY a.grp_seq_no, a.brdrx_rids_record_id)
         LOOP
            rep.outstanding_expense := rep.outstanding_expense + a.outstanding_expense;           
         END LOOP;
         PIPE ROW(rep);
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_per_group_total(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_buss_source_type   VARCHAR2,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE
   ) 
     RETURN per_group_total_tab PIPELINED
   IS
      v_row                per_group_total_type;
    BEGIN
       FOR pgt IN (SELECT SUM ((  NVL (a.expense_reserve, 0)
                                - NVL (a.expenses_paid, 0))) outstanding_expense
                     FROM gicl_res_brdrx_extr a, giis_intermediary b
                    WHERE a.buss_source = b.intm_no(+)
                      AND a.session_id = p_session_id
                      AND a.claim_id = NVL (p_claim_id, a.claim_id)
                      AND NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) > 0
                      AND a.line_cd = NVL (p_line_cd, a.line_cd)
                      AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                      AND DECODE (a.iss_cd, 'RI', 'RI', NVL(b.intm_type,'0')) = NVL(p_buss_source_type,DECODE (a.iss_cd, 'RI', 'RI', NVL(b.intm_type,'0')))
                      AND a.buss_source = NVL (p_buss_source, a.buss_source))
       LOOP
          v_row.outstanding_expense := pgt.outstanding_expense;
          PIPE ROW (v_row);
       END LOOP;

       RETURN;
    END;
   
   FUNCTION get_per_group_treaty(
      p_session_id         GICL_RES_BRDRX_DS_EXTR.session_id%TYPE,
      p_claim_id           GICL_RES_BRDRX_EXTR.claim_id%TYPE,
      p_line_cd            GICL_RES_BRDRX_EXTR.line_cd%TYPE,
      p_iss_cd             GICL_RES_BRDRX_EXTR.iss_cd%TYPE,
      p_buss_source_type   VARCHAR2,
      p_buss_source        GICL_RES_BRDRX_EXTR.buss_source%TYPE,
      p_group_sw           VARCHAR2
   )
     RETURN per_group_treaty_tab PIPELINED
   IS
      v_row                per_group_treaty_type;
   BEGIN
      IF p_group_sw = 'BT' THEN
         FOR i IN (SELECT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                          DECODE (a.iss_cd, 'RI', 'RI', d.intm_type) buss_source_type,
                          SUM (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) outstanding_expense,
                          c.trty_name
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share c, giis_intermediary d
                    WHERE NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) > 0
                      AND a.session_id = p_session_id
                      AND a.claim_id = NVL(p_claim_id, a.claim_id)
                      AND DECODE (a.iss_cd, 'RI', 'RI', d.intm_type) = NVL(p_buss_source_type, DECODE (a.iss_cd, 'RI', 'RI', d.intm_type))
                      AND a.line_cd = NVL(p_line_cd, a.line_cd)
                      AND a.iss_cd = NVL(p_iss_cd, a.iss_cd)
                      AND a.buss_source = NVL(p_buss_source, a.buss_source)
                      AND c.line_cd = a.line_cd
                      AND c.share_cd = a.grp_seq_no
                      AND a.buss_source = d.intm_no(+)
                    GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'),
                   DECODE (a.iss_cd, 'RI', 'RI', d.intm_type), c.trty_name, a.grp_seq_no
                    ORDER BY a.grp_seq_no)
         LOOP
            v_row.trty_name := i.trty_name;
            v_row.outstanding_expense := i.outstanding_expense;
            
            PIPE ROW(v_row);
         END LOOP;
      ELSIF p_group_sw = 'GT' THEN
         FOR i IN (SELECT SUM ((NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0))) outstanding_expense,
                          b.trty_name, a.grp_seq_no
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                    WHERE NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0) > 0
                      AND a.session_id = p_session_id
                      AND a.claim_id = NVL (p_claim_id, a.claim_id)
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                    GROUP BY b.trty_name, a.grp_seq_no
                    ORDER BY a.grp_seq_no)
         LOOP
            v_row.trty_name := i.trty_name;
            v_row.outstanding_expense := i.outstanding_expense;
            
            PIPE ROW(v_row);
         END LOOP;
      ELSE
         FOR i IN (SELECT SUM((NVL(a.expense_reserve, 0) - NVL(a.expenses_paid, 0))) outstanding_expense,
                          a.line_cd, b.trty_name, a.iss_cd, a.grp_seq_no, a.buss_source
                     FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                    WHERE NVL(a.expense_reserve, 0) - NVL(a.expenses_paid, 0) > 0
                      AND a.session_id = p_session_id
                      AND a.claim_id = NVL (p_claim_id, a.claim_id)
                      AND a.line_cd = DECODE(p_group_sw,
                                             'L', NVL(p_line_cd, a.line_cd),
                                             a.line_cd 
                                            )
                      AND a.iss_cd = DECODE(p_group_sw,
                                             'L', NVL(p_iss_cd, a.iss_cd),
                                             'I', NVL(p_iss_cd, a.iss_cd),
                                             a.iss_cd 
                                           )
                      AND a.buss_source = DECODE(p_group_sw,
                                                 'L',  NVL(p_buss_source, a.buss_source),
                                                 'I',  NVL(p_buss_source, a.buss_source),
                                                 'BS', NVL(p_buss_source, a.buss_source),
                                                 a.buss_source 
                                                )
                      AND a.line_cd = b.line_cd
                      AND a.grp_seq_no = b.share_cd
                    GROUP BY a.line_cd, a.iss_cd, b.trty_name, a.grp_seq_no, a.buss_source
                    ORDER BY a.grp_seq_no)
         LOOP
            v_row.trty_name := i.trty_name;
            v_row.outstanding_expense := i.outstanding_expense;
            
            PIPE ROW(v_row);
         END LOOP;
      END IF;
      
      RETURN;
   END;
END GICLR205ER_PKG;
/


