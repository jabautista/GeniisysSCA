CREATE OR REPLACE PACKAGE BODY CPI.giclr218_pkg
AS
   /*
     **  Created by   : Michael John R. Malicad
     **  Date Created : 09.02.2013
     **  Reference By : GICLR218
     **  Description  : Loss Profile Report by Risk/Item
     */
   FUNCTION cf_title (p_extract NUMBER)
      RETURN CHAR
   IS
      v_addl   giis_reports.report_title%TYPE;
   BEGIN
      FOR rpt IN (SELECT report_title title
                    FROM giis_reports
                   WHERE report_id = 'GICLR218')
      LOOP
         v_addl := rpt.title;
      END LOOP;

      IF NVL (v_addl, '1') != '1'
      THEN
         IF p_extract = 1
         THEN
            v_addl :=
                   v_addl || CHR (10)
                   || '(BASED ON TOTAL SUM INSURED AMOUNT)';
         ELSE
            v_addl := v_addl || CHR (10) || '(BASED ON LOSS AMOUNT)';
         END IF;
      ELSE
         v_addl := ' ';
      END IF;

      RETURN (UPPER (v_addl));
   END;

   FUNCTION cf_heading1 (
      p_param_date       VARCHAR2,
      p_starting_date    DATE,
      p_ending_date      DATE,
      p_claim_date       VARCHAR2,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_extract          NUMBER
   )
      RETURN CHAR
   IS
      v_date   VARCHAR2 (100);
   BEGIN
      IF p_extract = 1
      THEN
         BEGIN
            SELECT    p_param_date
                   || ' from '
                   || TO_CHAR (p_starting_date, 'fmMonth DD, YYYY')
                   || ' to '
                   || TO_CHAR (p_ending_date, 'fmMonth DD, YYYY')
              INTO v_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_date := NULL;
         END;
      ELSE
         BEGIN
            SELECT    p_claim_date
                   || ' from '
                   || TO_CHAR (p_loss_date_from, 'fmMonth DD, YYYY')
                   || ' to '
                   || TO_CHAR (p_loss_date_to, 'fmMonth DD, YYYY')
              INTO v_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_date := NULL;
         END;
      END IF;

      RETURN (v_date);
   END;

   FUNCTION cf_heading2 (
      p_claim_date       VARCHAR2,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_extract          NUMBER
   )
      RETURN CHAR
   IS
      v_date   VARCHAR2 (100);
   BEGIN
      IF p_extract = 1
      THEN
         BEGIN
            SELECT    p_claim_date
                   || ' from '
                   || TO_CHAR (p_loss_date_from, 'fmMonth DD, YYYY')
                   || ' to '
                   || TO_CHAR (p_loss_date_to, 'fmMonth DD, YYYY')
              INTO v_date
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_date := NULL;
         END;
      ELSE
         v_date := NULL;
      END IF;

      RETURN (v_date);
   END;

   FUNCTION cf_line_name (p_line_cd VARCHAR2)
      RETURN CHAR
   IS
      v_line_name   giis_line.line_name%TYPE;
   BEGIN
      SELECT line_name
        INTO v_line_name
        FROM giis_line
       WHERE line_cd = p_line_cd;

      RETURN (v_line_name);
   END;

   FUNCTION get_giclr218_record (
      p_line_cd          VARCHAR2,
      p_starting_date    DATE,
      p_ending_date      DATE,
      p_user_id          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_param_date       VARCHAR2,
      p_claim_date       VARCHAR2,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_extract          NUMBER
   )
      RETURN giclr218_record_tab PIPELINED
   IS
      v_rec   giclr218_record_type;
      mjm     BOOLEAN              := TRUE;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.title := cf_title (p_extract);
      v_rec.heading1 :=
         cf_heading1 (p_param_date,
                      p_starting_date,
                      p_ending_date,
                      p_claim_date,
                      p_loss_date_from,
                      p_loss_date_to,
                      p_extract
                     );
      v_rec.heading2 :=
         cf_heading2 (p_claim_date,
                      p_loss_date_from,
                      p_loss_date_to,
                      p_extract
                     );

      FOR i IN (SELECT   c001.range_from, c001.range_to, c001.line_cd,
                         c001.block_id, c001.risk_cd,
                         SUM (NVL (c001.sum_insured, 0)) sum_insured,
                         SUM (NVL (c002.loss, 0)) loss, c003.cnt_clm,
                         c004.risk_desc
                    FROM giis_risks c004,
                         (SELECT   SUM (cnt_clm) cnt_clm, line_cd, subline_cd,
                                   block_id, risk_cd
                              FROM gicl_loss_profile_ext
                          GROUP BY line_cd, subline_cd, block_id, risk_cd) c003,
                         (SELECT   b.range_from, b.range_to, a.line_cd,
                                   a.subline_cd, a.pol_iss_cd, a.issue_yy,
                                   a.pol_seq_no, a.renew_no, a.block_id,
                                   a.risk_cd, SUM (a.tsi_amt) sum_insured
                              FROM gicl_loss_profile_ext2 a,
                                   gicl_loss_profile b
                             WHERE b.line_cd = NVL (p_line_cd, b.line_cd)
                               AND b.user_id = UPPER (p_user_id)
                               AND NVL (b.subline_cd, '***') =
                                                     NVL (p_subline_cd, '***')
                               AND a.tsi_amt BETWEEN b.range_from AND b.range_to
                          GROUP BY b.range_from,
                                   b.range_to,
                                   a.line_cd,
                                   a.subline_cd,
                                   a.pol_iss_cd,
                                   a.issue_yy,
                                   a.pol_seq_no,
                                   a.renew_no,
                                   a.block_id,
                                   a.risk_cd) c001,
                         (SELECT   SUM (a.loss_amt) loss, a.block_id,
                                   a.risk_cd, b.line_cd, b.subline_cd,
                                   b.pol_iss_cd, b.issue_yy, b.pol_seq_no,
                                   b.renew_no, c.range_from, c.range_to
                              FROM gicl_loss_profile_ext3 a,
                                   gicl_claims b,
                                   gicl_loss_profile c
                             WHERE a.claim_id = b.claim_id
                               AND c.line_cd = NVL (p_line_cd, b.line_cd)
                               AND c.user_id = UPPER (p_user_id)
                               AND NVL (c.subline_cd, '***') =
                                                     NVL (p_subline_cd, '***')
                               AND a.loss_amt BETWEEN c.range_from AND c.range_to
                          GROUP BY a.block_id,
                                   a.risk_cd,
                                   b.line_cd,
                                   b.subline_cd,
                                   b.pol_iss_cd,
                                   b.issue_yy,
                                   b.pol_seq_no,
                                   b.renew_no,
                                   c.range_from,
                                   c.range_to) c002
                   WHERE c001.range_from = c002.range_from(+)
                     AND c001.range_to = c002.range_to(+)
                     AND c001.line_cd = c002.line_cd(+)
                     AND c001.subline_cd = c002.subline_cd(+)
                     AND c001.block_id = c002.block_id(+)
                     AND c001.risk_cd = c002.risk_cd(+)
                     AND c003.line_cd = c001.line_cd
                     AND c003.subline_cd = c001.subline_cd
                     AND c003.block_id = c001.block_id
                     AND c003.risk_cd = c001.risk_cd
                     AND c004.block_id = c001.block_id
                     AND c004.risk_cd = c001.risk_cd
                GROUP BY c001.range_from,
                         c001.range_to,
                         c001.line_cd,
                         c001.subline_cd,
                         c001.block_id,
                         c001.risk_cd,
                         c003.cnt_clm,
                         c004.risk_desc)
      LOOP
         mjm := FALSE;
         v_rec.range_from := i.range_from;
         v_rec.range_to := i.range_to;
         v_rec.line_cd := i.line_cd;
         v_rec.block_id := i.block_id;
         v_rec.risk_cd := i.risk_cd;
         v_rec.sum_insured := i.sum_insured;
         v_rec.loss := i.loss;
         v_rec.cnt_clm := i.cnt_clm;
         v_rec.risk_desc := i.risk_desc;
         v_rec.cf_line := i.line_cd || ' - ' || cf_line_name (i.line_cd);
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_giclr218_record;
END;
/


