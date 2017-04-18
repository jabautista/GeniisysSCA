DROP PROCEDURE CPI.VALIDATE_PAR;

CREATE OR REPLACE PROCEDURE CPI.validate_par (
   p_par_id       IN       gipi_parlist.par_id%TYPE,
   p_line_cd      IN       gipi_parlist.line_cd%TYPE,
   p_subline_cd   IN       gipi_wpolbas.subline_cd%TYPE,
   p_iss_cd       IN       gipi_wpolbas.iss_cd%TYPE,
   p_par_seq_no   IN       gipi_parlist.par_seq_no%TYPE,
   p_par_yy       IN       gipi_parlist.par_yy%TYPE,
   p_pack         IN       gipi_wpolbas.pack_pol_flag%TYPE,
   p_par_type     IN       gipi_parlist.par_type%TYPE,
   p_pol_stat     IN       gipi_wpolbas.pol_flag%TYPE,
   p_affecting    IN       VARCHAR2,
   p_msg_alert    OUT      VARCHAR2
)
IS
   v_msg_alert   VARCHAR2 (32000);
   v_dumm_var    VARCHAR2 (32000);
   v_open_flag   giis_subline.op_flag%TYPE;
BEGIN
   /*
   **  Created by   : Jerome Orio
   **  Date Created : March 24, 2010
   **  Reference By : (GIPIS055 - POST PAR)
   **  Description  : validate_par program unit
   */
   BEGIN
      SELECT op_flag
        INTO v_open_flag
        FROM giis_subline
       WHERE line_cd = p_line_cd AND subline_cd = p_subline_cd;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   IF v_msg_alert IS NULL
   THEN
      validate_in_parlist (p_line_cd, p_par_yy, p_par_seq_no, v_msg_alert);
   END IF;

   IF v_msg_alert IS NULL
   THEN
      validate_in_wpolbas (p_par_id, v_msg_alert);
   END IF;

   IF v_msg_alert IS NULL
   THEN
      validate_table_amts (p_par_id, v_msg_alert);            --BETH validate if amounts in polbasic, item and item peril tallies
   END IF;

--  msg_alert('par id '||:postpar.par_id||' par_type '||:postpar.par_type ||
  --          ' pol stat '||:postpar.pol_stat||' open flag '||variables.open_flag,'I',TRUE);
  --beth 04152001 if auto_dist = 'Y' validate distribution tables records
   FOR a IN (SELECT dist_no
               FROM giuw_pol_dist
              WHERE par_id = p_par_id AND auto_dist = 'Y')
   LOOP
      IF v_msg_alert IS NULL
      THEN
         validate_existing_final_dist (a.dist_no, v_msg_alert);
      END IF;
   END LOOP;

   IF p_par_type = 'E'
   THEN
        --validate_wendttext;
      /* NOTE HINDI KO NA ginamit ung validate_wendttext eto nalang ginawa ko... jerome orio
      ** di naman kasi need ito basta mavalidate lang
      */
      BEGIN
         SELECT par_id
           INTO v_dumm_var
           FROM gipi_wendttext
          WHERE par_id = p_par_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_msg_alert := 'PAR should have an endorsement text.';
      END;
   END IF;

   IF p_pack <> 'Y' -- andrew - 09.12.2012 - validation for renewal/replacement in gipi_wpolnrep will be done for par only
   THEN
      IF p_pol_stat = '2'
      THEN
         --validate_renewal;
         BEGIN
            SELECT par_id
              INTO v_dumm_var
              FROM gipi_wpolnrep
             WHERE par_id = p_par_id AND ren_rep_sw = '1';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_msg_alert := 'PAR should have at least one policy being renewed.';
            --:gauge.FILE := 'PAR should have at least one policy being renewed.';
            --error_rtn;
            WHEN TOO_MANY_ROWS
            THEN
               NULL;
         END;
      ELSIF p_pol_stat = '3'
      THEN
         --validate_replcment;
         BEGIN
            SELECT rec_flag
              INTO v_dumm_var
              FROM gipi_wpolnrep
             WHERE par_id = p_par_id AND ren_rep_sw = '2';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_msg_alert := 'PAR should have at least one policy being replaced.';
            --:gauge.FILE := ('PAR should have at least one policy being replaced.');
            --error_rtn;
            WHEN TOO_MANY_ROWS
            THEN
               NULL;
         END;
      END IF;
   END IF;

   IF p_par_type = 'P'
   THEN
      IF v_msg_alert IS NULL
      THEN
         validate_addl_items (p_par_id, p_pack, p_line_cd, p_subline_cd, p_affecting, p_iss_cd, v_msg_alert);
      END IF;
   END IF;

   IF NVL (v_open_flag, 'N') <> 'Y'
   THEN
      IF v_msg_alert IS NULL
      THEN
         validate_witem (p_par_id, p_line_cd, p_subline_cd, p_pack, p_par_type, v_msg_alert);
      END IF;
   END IF;

   IF v_msg_alert IS NULL
   THEN
      validate_witem_grouping (p_par_id, v_msg_alert);
   END IF;

   IF v_msg_alert IS NULL
   THEN
      validate_invoice_info (p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_par_type, v_msg_alert);
   END IF;

   IF v_msg_alert IS NULL
   THEN
      validate_prelimds (p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_par_type, v_msg_alert);
   END IF;

   p_msg_alert := NVL (v_msg_alert, p_msg_alert);
END;
/


