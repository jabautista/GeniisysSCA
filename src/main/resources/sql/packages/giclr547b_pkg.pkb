CREATE OR REPLACE PACKAGE BODY CPI.giclr547b_pkg
AS
   FUNCTION get_giclr547b_comp_name
      RETURN VARCHAR2
   IS
      ws_company   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO ws_company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            ws_company := NULL;
      END;

      RETURN (ws_company);
   END get_giclr547b_comp_name;

   FUNCTION get_giclr547b_comp_add
      RETURN VARCHAR2
   IS
      ws_address   giis_parameters.param_value_v%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO ws_address
           FROM giis_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            ws_address := NULL;
      END;

      RETURN (ws_address);
   END get_giclr547b_comp_add;

   FUNCTION get_giclr547b_title (p_loss_exp VARCHAR2)
      RETURN CHAR
   IS
   BEGIN
      IF p_loss_exp = 'L'
      THEN
         RETURN ('REPORTED CLAIMS PER ENROLLEE - LOSSES');
      ELSIF p_loss_exp = 'E'
      THEN
         RETURN ('REPORTED CLAIMS PER ENROLLEE - EXPENSES');
      ELSE
         RETURN ('REPORTED CLAIMS PER ENROLLEE');
      END IF;
   END get_giclr547b_title;

   FUNCTION get_giclr547b_as_date (p_start_dt DATE, p_end_dt DATE)
      RETURN CHAR
   IS
      v_date   VARCHAR2 (50);
   BEGIN
      RETURN (   'From '
              || TO_CHAR (p_start_dt, 'fmMonth DD, YYYY')
              || ' to '
              || TO_CHAR (p_end_dt, 'fmMonth DD, YYYY')
             );
   END get_giclr547b_as_date;

   FUNCTION get_giclr547b_clm_func (p_loss_exp VARCHAR2)
      RETURN CHAR
   IS
   BEGIN
      IF p_loss_exp = 'L'
      THEN
         RETURN ('Loss Amount');
      ELSIF p_loss_exp = 'E'
      THEN
         RETURN ('Expense Amount');
      ELSE
         RETURN ('Claim Amount');
      END IF;
   END get_giclr547b_clm_func;

   FUNCTION get_giclr547b_loss_amt (
      p_loss_exp      VARCHAR2,
      p_claim_id      NUMBER,
      p_item_no       NUMBER,
      p_peril_cd      NUMBER,
      p_clm_stat_cd   VARCHAR2
   )
      RETURN NUMBER
   IS
      v_loss_amt     gicl_clm_res_hist.loss_reserve%TYPE;
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_loss_amt := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_loss_amt :=
              v_loss_amt
            + csv_reported_clms.get_loss_amount_per_item_peril (p_claim_id,
                                                                p_item_no,
                                                                p_peril_cd,
                                                                v_loss_exp,
                                                                p_clm_stat_cd
                                                               );
         v_loss_exp := 'E';
      END LOOP;

      RETURN (v_loss_amt);
   END get_giclr547b_loss_amt;

   FUNCTION get_giclr547b_retention (
      p_loss_exp      VARCHAR2,
      p_claim_id      NUMBER,
      p_item_no       NUMBER,
      p_peril_cd      NUMBER,
      p_clm_stat_cd   VARCHAR2
   )
      RETURN NUMBER
   IS
      v_net_ret      gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_net_ret := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_net_ret :=
              v_net_ret
            + csv_reported_clms.get_amount_per_item_peril (p_claim_id,
                                                           p_item_no,
                                                           p_peril_cd,
                                                           1,
                                                           v_loss_exp,
                                                           p_clm_stat_cd
                                                          );
         v_loss_exp := 'E';
      END LOOP;

      RETURN (v_net_ret);
   END get_giclr547b_retention;

   FUNCTION get_giclr547b_treaty (
      p_loss_exp      VARCHAR2,
      p_claim_id      NUMBER,
      p_item_no       NUMBER,
      p_peril_cd      NUMBER,
      p_clm_stat_cd   VARCHAR2
   )
      RETURN NUMBER
   IS
      v_trty         gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_trty := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_trty :=
              v_trty
            + csv_reported_clms.get_amount_per_item_peril
                                                  (p_claim_id,
                                                   p_item_no,
                                                   p_peril_cd,
                                                   giacp.v ('TRTY_SHARE_TYPE'),
                                                   v_loss_exp,
                                                   p_clm_stat_cd
                                                  );
         v_loss_exp := 'E';
      END LOOP;

      RETURN (v_trty);
   END get_giclr547b_treaty;

   FUNCTION get_giclr547b_facultative (
      p_loss_exp      VARCHAR2,
      p_claim_id      NUMBER,
      p_item_no       NUMBER,
      p_peril_cd      NUMBER,
      p_clm_stat_cd   VARCHAR2
   )
      RETURN NUMBER
   IS
      v_facul        gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_facul := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_facul :=
              v_facul
            + csv_reported_clms.get_amount_per_item_peril
                                                 (p_claim_id,
                                                  p_item_no,
                                                  p_peril_cd,
                                                  giacp.v ('FACUL_SHARE_TYPE'),
                                                  v_loss_exp,
                                                  p_clm_stat_cd
                                                 );
         v_loss_exp := 'E';
      END LOOP;

      RETURN (v_facul);
   END get_giclr547b_facultative;

   FUNCTION get_giclr547b_xol (
      p_loss_exp      VARCHAR2,
      p_claim_id      NUMBER,
      p_item_no       NUMBER,
      p_peril_cd      NUMBER,
      p_clm_stat_cd   VARCHAR2
   )
      RETURN NUMBER
   IS
      v_xol          gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_xol := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_xol :=
              v_xol
            + csv_reported_clms.get_amount_per_item_peril
                                              (p_claim_id,
                                               p_item_no,
                                               p_peril_cd,
                                               giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                               v_loss_exp,
                                               p_clm_stat_cd
                                              );
         v_loss_exp := 'E';
      END LOOP;

      RETURN (v_xol);
   END get_giclr547b_xol;

   FUNCTION get_giclr547b_records (
      p_clmstat_cd           VARCHAR2,
      p_clmstat_type         VARCHAR2,
      p_control_cd           VARCHAR2,
      p_control_type_cd      VARCHAR2,
      p_end_dt               VARCHAR2,
      p_grouped_item_title   VARCHAR2,
      p_loss_exp             VARCHAR2,
      p_start_dt             VARCHAR2,
      p_user_id              VARCHAR2
   )
      RETURN giclr547b_tab PIPELINED
   IS
      v_list        giclr547b_type;
      v_not_exist   BOOLEAN        := TRUE;
      v_start_dt    DATE           := TO_DATE (p_start_dt, 'MM/DD/YYYY');
      v_end_dt      DATE           := TO_DATE (p_end_dt, 'MM/DD/YYYY');
   BEGIN
      v_list.comp_name := get_giclr547b_comp_name;
      v_list.comp_add := get_giclr547b_comp_add;
      v_list.title := get_giclr547b_title (p_loss_exp);
      v_list.as_date := get_giclr547b_as_date (v_start_dt, v_end_dt);
      v_list.clm_func := get_giclr547b_clm_func (p_loss_exp);

      FOR i IN
         (SELECT   a.clm_stat_cd, b.clm_stat_desc, a.claim_id,
                   a.assured_name, a.intm_no, a.pol_iss_cd, a.pol_eff_date,
                   a.dsp_loss_date, a.clm_file_date, c.grouped_item_title,
                   c.control_cd, c.control_type_cd, c.item_no
              FROM gicl_claims a, giis_clm_stat b, gicl_accident_dtl c
             WHERE a.clm_stat_cd = b.clm_stat_cd
               AND a.claim_id = c.claim_id
               AND c.grouped_item_title IS NOT NULL
               AND NVL (c.grouped_item_title, '!@#') LIKE
                      NVL (p_grouped_item_title,
                           NVL (c.grouped_item_title, '!@#')
                          )
               AND NVL (c.control_cd, '!@#') LIKE
                                 NVL (p_control_cd, NVL (c.control_cd, '!@#'))
               AND NVL (c.control_type_cd, 1234) LIKE
                        NVL (p_control_type_cd, NVL (c.control_type_cd, 1234))
               AND TRUNC (a.clm_file_date) BETWEEN NVL (v_start_dt,
                                                        a.clm_file_date
                                                       )
                                               AND NVL (v_end_dt,
                                                        a.clm_file_date
                                                       )
               AND check_user_per_iss_cd2 (a.line_cd,
                                           a.iss_cd,
                                           'GICLS540',
                                           p_user_id
                                          ) = 1
          ORDER BY b.clm_stat_desc,
                   a.line_cd,
                   a.subline_cd,
                   a.iss_cd,
                   a.clm_yy,
                   a.clm_seq_no)
      LOOP
         v_not_exist := FALSE;
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.clm_stat_desc := i.clm_stat_desc;
         v_list.claim_id := i.claim_id;
         v_list.assured_name := i.assured_name;
         v_list.intm_no := i.intm_no;
         v_list.pol_iss_cd := i.pol_iss_cd;
         v_list.pol_eff_date := i.pol_eff_date;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.grouped_item_title := i.grouped_item_title;
         v_list.control_cd := i.control_cd;
         v_list.control_type_cd := i.control_type_cd;
         v_list.item_no := i.item_no;
         
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr547b_records;

   FUNCTION get_giclr547b_total (
      p_clmstat_cd           VARCHAR2,
      p_clmstat_type         VARCHAR2,
      p_control_cd           VARCHAR2,
      p_control_type_cd      VARCHAR2,
      p_end_dt               VARCHAR2,
      p_grouped_item_title   VARCHAR2,
      p_loss_exp             VARCHAR2,
      p_start_dt             VARCHAR2,
      p_user_id              VARCHAR2
   )
      RETURN giclr547b_tab PIPELINED
   IS
      v_list        giclr547b_type;
      v_not_exist   BOOLEAN        := TRUE;
      v_start_dt    DATE           := TO_DATE (p_start_dt, 'MM/DD/YYYY');
      v_end_dt      DATE           := TO_DATE (p_end_dt, 'MM/DD/YYYY');
   BEGIN
      FOR i IN
         (SELECT   a.clm_stat_cd, b.clm_stat_desc, a.claim_id,
                   a.assured_name, a.intm_no, a.pol_iss_cd, a.pol_eff_date,
                   a.dsp_loss_date, a.clm_file_date, c.grouped_item_title,
                   c.control_cd, c.control_type_cd, c.item_no
              FROM gicl_claims a, giis_clm_stat b, gicl_accident_dtl c
             WHERE a.clm_stat_cd = b.clm_stat_cd
               AND a.claim_id = c.claim_id
               AND c.grouped_item_title IS NOT NULL
               AND NVL (c.grouped_item_title, '!@#') LIKE
                      NVL (p_grouped_item_title,
                           NVL (c.grouped_item_title, '!@#')
                          )
               AND NVL (c.control_cd, '!@#') LIKE
                                 NVL (p_control_cd, NVL (c.control_cd, '!@#'))
               AND NVL (c.control_type_cd, 1234) LIKE
                        NVL (p_control_type_cd, NVL (c.control_type_cd, 1234))
               AND TRUNC (a.clm_file_date) BETWEEN NVL (v_start_dt,
                                                        a.clm_file_date
                                                       )
                                               AND NVL (v_end_dt,
                                                        a.clm_file_date
                                                       )
               AND check_user_per_iss_cd2 (a.line_cd,
                                           a.iss_cd,
                                           'GICLS540',
                                           p_user_id
                                          ) = 1
          ORDER BY b.clm_stat_desc,
                   a.line_cd,
                   a.subline_cd,
                   a.iss_cd,
                   a.clm_yy,
                   a.clm_seq_no)
      LOOP
         v_not_exist := FALSE;
         v_list.claim_id := i.claim_id;
         v_list.grouped_item_title := i.grouped_item_title;
         
         FOR k IN (SELECT DISTINCT b.claim_id, a.peril_cd
                              FROM giis_peril a, gicl_item_peril b
                             WHERE a.line_cd = b.line_cd
                               AND a.peril_cd = b.peril_cd
                               AND b.claim_id = i.claim_id)
         
         LOOP
            v_not_exist := FALSE;
            v_list.peril_cd := k.peril_cd;
            v_list.claim_id := k.claim_id;
            v_list.loss_amt :=
               get_giclr547b_loss_amt (p_loss_exp,
                                       i.claim_id,
                                       i.item_no,
                                       k.peril_cd,
                                       i.clm_stat_cd
                                      );
            v_list.RETENTION :=
               get_giclr547b_retention (p_loss_exp,
                                        i.claim_id,
                                        i.item_no,
                                        k.peril_cd,
                                        i.clm_stat_cd
                                       );
            v_list.treaty :=
               get_giclr547b_treaty (p_loss_exp,
                                     i.claim_id,
                                     i.item_no,
                                     k.peril_cd,
                                     i.clm_stat_cd
                                    );
            v_list.facultative :=
               get_giclr547b_facultative (p_loss_exp,
                                          i.claim_id,
                                          i.item_no,
                                          k.peril_cd,
                                          i.clm_stat_cd
                                         );
            v_list.xol :=
               get_giclr547b_xol (p_loss_exp,
                                  i.claim_id,
                                  i.item_no,
                                  k.peril_cd,
                                  i.clm_stat_cd
                                 );

            PIPE ROW (v_list);
         END LOOP;
         
         IF v_not_exist
         THEN
            v_list.retention       := 0;
            v_list.loss_amt        := 0;
            v_list.treaty          := 0;
            v_list.facultative     := 0;
            v_list.xol             := 0;            
            PIPE ROW (v_list);
         END IF; 
      END LOOP;     
   END get_giclr547b_total;

END;
/


