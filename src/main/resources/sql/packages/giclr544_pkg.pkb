CREATE OR REPLACE PACKAGE BODY CPI.giclr544_pkg
AS
   FUNCTION get_giclr544_comp_name
      RETURN VARCHAR2
   IS
      --ws_company    varchar2(100);
      ws_company   giis_parameters.param_value_v%TYPE;
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
   END get_giclr544_comp_name;

   FUNCTION get_giclr544_comp_add
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
   END get_giclr544_comp_add;

   FUNCTION get_giclr544_title (p_loss_exp VARCHAR2)
      RETURN CHAR
   IS
   BEGIN
      IF p_loss_exp = 'L'
      THEN
         RETURN ('REPORTED CLAIMS PER BRANCH - LOSSES');
      ELSIF p_loss_exp = 'E'
      THEN
         RETURN ('REPORTED CLAIMS PER BRANCH - EXPENSES');
      ELSE
         RETURN ('REPORTED CLAIMS PER BRANCH');
      END IF;
   END get_giclr544_title;

   FUNCTION get_giclr544_as_date (p_start_dt DATE, p_end_dt DATE)
      RETURN VARCHAR2
   IS
      v_date   VARCHAR2 (50);
   BEGIN
      RETURN (   'from '
              || TO_CHAR (p_start_dt, 'fmMonth DD, YYYY')
              || ' to '
              || TO_CHAR (p_end_dt, 'fmMonth DD, YYYY')
             );
   END get_giclr544_as_date;

   FUNCTION get_giclr544_line_name (p_line_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_line_name   giis_line.line_name%TYPE;
   BEGIN
      BEGIN
         SELECT line_name
           INTO v_line_name
           FROM giis_line
          WHERE line_cd = p_line_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_line_name := ' ';
      END;

      RETURN (v_line_name);
   END get_giclr544_line_name;

   FUNCTION get_giclr544_intm (p_claim_id NUMBER)
      RETURN VARCHAR2
   IS
      v_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE;
      v_intm_name     giis_intermediary.intm_name%TYPE;
      v_intm_no       gicl_intm_itmperil.intm_no%TYPE;
      v_ref_intm_cd   giis_intermediary.ref_intm_cd%TYPE;
      v_ri_cd         gicl_claims.ri_cd%TYPE;
      v_ri_name       giis_reinsurer.ri_name%TYPE;
      v_intm          VARCHAR2 (300)                       := NULL;
      var_intm        VARCHAR2 (300)                       := NULL;
   BEGIN
      FOR i IN (SELECT a.pol_iss_cd
                  FROM gicl_claims a
                 WHERE a.claim_id = p_claim_id)
      LOOP
         v_pol_iss_cd := i.pol_iss_cd;
      END LOOP;

      IF v_pol_iss_cd = 'RI'
      THEN
         FOR k IN (SELECT DISTINCT g.ri_name, a.ri_cd
                              FROM gicl_claims a, giis_reinsurer g
                             WHERE a.claim_id = p_claim_id AND a.ri_cd = g.ri_cd(+))
         LOOP
            v_intm := TO_CHAR (k.ri_cd) || '/' || k.ri_name;

            IF var_intm IS NULL
            THEN
               var_intm := v_intm;
            ELSE
               var_intm := v_intm || CHR (10) || var_intm;
            END IF;
         END LOOP;
      ELSE
         FOR j IN (SELECT DISTINCT a.intm_no, b.intm_name, b.ref_intm_cd
                              FROM gicl_intm_itmperil a, giis_intermediary b
                             WHERE a.intm_no = b.intm_no
                               AND a.claim_id = p_claim_id)
         LOOP
            v_intm :=
               TO_CHAR (j.intm_no) || '/' || j.ref_intm_cd || '/'
               || j.intm_name;

            IF var_intm IS NULL
            THEN
               var_intm := v_intm;
            ELSE
               var_intm := v_intm || CHR (10) || var_intm;
            END IF;
         END LOOP;
      END IF;

      RETURN (var_intm);
   END get_giclr544_intm;

   FUNCTION get_giclr544_clm_stat (p_clm_stat_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_clm_stat   giis_clm_stat.clm_stat_desc%TYPE;
   BEGIN
      FOR i IN (SELECT clm_stat_desc
                  FROM giis_clm_stat
                 WHERE clm_stat_cd = p_clm_stat_cd)
      LOOP
         v_clm_stat := i.clm_stat_desc;
         EXIT;
      END LOOP;

      RETURN (v_clm_stat);
   END get_giclr544_clm_stat;

   FUNCTION get_giclr544_clm_func (p_loss_exp VARCHAR2)
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
   END get_giclr544_clm_func;

   FUNCTION get_giclr544_records (
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_end_dt      VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line        VARCHAR2,
      p_line_cd     VARCHAR2,
      p_loss_exp    VARCHAR2,
      p_start_dt    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giclr544_tab PIPELINED
   IS
      v_list        giclr544_type;
      v_not_exist   BOOLEAN       := TRUE;
      v_start_dt    DATE          := TO_DATE (p_start_dt, 'MM/DD/YYYY');
      v_end_dt      DATE          := TO_DATE (p_end_dt, 'MM/DD/YYYY');
   BEGIN
      v_list.comp_name := get_giclr544_comp_name;
      v_list.comp_add := get_giclr544_comp_add;
      v_list.title := get_giclr544_title (p_loss_exp);
      v_list.as_date := get_giclr544_as_date (v_start_dt, v_end_dt);
      v_list.clm_func := get_giclr544_clm_func (p_loss_exp);

      FOR i IN (SELECT   a.line_cd, a.iss_cd,
                         (   a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.iss_cd
                          || '-'
                          || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                          || '-'
                          || LPAD (TO_CHAR (a.clm_seq_no), 7, '0')
                         ) "CLAIM_NO",
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '00')) "POLICY_NO",
                         a.dsp_loss_date, a.clm_file_date, a.pol_eff_date,
                         a.subline_cd, a.pol_iss_cd, a.issue_yy,
                         a.pol_seq_no, a.renew_no, a.assured_name,
                         a.claim_id, a.clm_stat_cd, a.old_stat_cd,
                         close_date
                    FROM gicl_claims a
                   WHERE TRUNC (a.clm_file_date) BETWEEN NVL (v_start_dt,
                                                              a.clm_file_date
                                                             )
                                                     AND NVL (v_end_dt,
                                                              a.clm_file_date
                                                             )
                     AND a.iss_cd IN NVL (DECODE (p_branch_cd,
                                                  'D', a.iss_cd,
                                                  giacp.v ('RI_ISS_CD'), giacp.v
                                                                  ('RI_ISS_CD'),
                                                  p_branch_cd
                                                 ),
                                          a.iss_cd
                                         )
                     AND a.iss_cd NOT IN DECODE (p_branch_cd, 'D', 'RI', '*')
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND check_user_per_iss_cd2 (a.line_cd,
                                                 NVL (p_iss_cd, NULL),
                                                 'GICLS540',
                                                 p_user_id
                                                ) = 1
                     AND check_user_per_iss_cd2 (NVL (p_line_cd, NULL),
                                                 a.iss_cd,
                                                 'GICLS540',
                                                 p_user_id
                                                ) = 1
                     AND check_user_per_iss_cd2 (a.line_cd,
                                                 a.iss_cd,
                                                 'GICLS540',
                                                 p_user_id
                                                ) = 1
                ORDER BY    a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                         || '-'
                         || LPAD (TO_CHAR (a.clm_seq_no), 7, '0'))
      LOOP
         v_not_exist := FALSE;
         v_list.line_cd := i.line_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.pol_eff_date := i.pol_eff_date;
         v_list.subline_cd := i.subline_cd;
         v_list.pol_iss_cd := i.pol_iss_cd;
         v_list.issue_yy := i.issue_yy;
         v_list.pol_seq_no := i.pol_seq_no;
         v_list.renew_no := i.renew_no;
         v_list.assured_name := i.assured_name;
         v_list.claim_id := i.claim_id;
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.old_stat_cd := i.old_stat_cd;
         v_list.close_date := i.close_date;
         v_list.line_name := get_giclr544_line_name (i.line_cd);
         v_list.intm := get_giclr544_intm (i.claim_id);
         v_list.clm_stat := get_giclr544_clm_stat (i.clm_stat_cd);

         SELECT iss_name
           INTO v_list.branch_name
           FROM giis_issource
          WHERE iss_cd = i.iss_cd;

         PIPE ROW (v_list);

      END LOOP;
      
      IF v_not_exist
      THEN
        v_list.flag := 'T';
        PIPE ROW (v_list);
      END IF;      
   END get_giclr544_records;
--added by MarkS 11.23.2016 SR5844 OPTIMIZATION 
-------------------------------------------------   
   FUNCTION get_giclr544_records2 ( --MODIFIED by MarkS for optimization 11-23.2016 SR5844
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_end_dt      VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line        VARCHAR2,
      p_line_cd     VARCHAR2,
      p_loss_exp    VARCHAR2,
      p_start_dt    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giclr544_tab2 PIPELINED
   IS
      v_list        giclr544_type2;
      v_not_exist   BOOLEAN             := TRUE;
      v_start_dt    DATE                := TO_DATE (p_start_dt, 'MM/DD/YYYY');
      v_end_dt      DATE                := TO_DATE (p_end_dt, 'MM/DD/YYYY');
      v_exist2      VARCHAR2(1);
      v_loss_exp    VARCHAR2(1);
      ctr           NUMBER              := 0;
      v_intm        VARCHAR2(300);
      v_TRTY        VARCHAR2(100)       := giacp.v ('TRTY_SHARE_TYPE');
      v_FACUL       VARCHAR2(100)       := giacp.v ('FACUL_SHARE_TYPE');
      v_XOL         VARCHAR2(100)       := giacp.v ('XOL_TRTY_SHARE_TYPE');
      v_ri_cd       VARCHAR2(100)       := giacp.v ('RI_ISS_CD');
   BEGIN
   
     BEGIN
         SELECT param_value_v
           INTO v_list.comp_add
         FROM giis_parameters
         WHERE param_name = 'COMPANY_ADDRESS';
     EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.comp_add := NULL;
     END;
      
     BEGIN
         SELECT param_value_v
           INTO  v_list.comp_name
         FROM giis_parameters
         WHERE param_name = 'COMPANY_NAME';
     EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.comp_name := NULL;
     END;
   
     
     IF p_loss_exp = 'L'
     THEN
         v_list.title := 'REPORTED CLAIMS PER BRANCH - LOSSES';
         v_list.clm_func := 'Loss Amount';
     ELSIF p_loss_exp = 'E'
     THEN
         v_list.title := 'REPORTED CLAIMS PER BRANCH - EXPENSES';
         v_list.clm_func := 'Expense Amount';
     ELSE
         v_list.title := 'REPORTED CLAIMS PER BRANCH';
         v_list.clm_func := 'Claim Amount';
     END IF;       
     
     v_list.as_date :='from '
                      || TO_CHAR ((TO_DATE (p_start_dt,'mm-dd-yyyy')), 'fmMonth DD, YYYY')
                      || ' to '
                      || TO_CHAR ((TO_DATE (p_end_dt,'mm-dd-yyyy')), 'fmMonth DD, YYYY');  
              
      FOR rec IN (SELECT   a.line_cd, a.iss_cd,c.iss_name,b.line_name,
                         (   a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.iss_cd
                          || '-'
                          || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                          || '-'
                          || LPAD (TO_CHAR (a.clm_seq_no), 7, '0')
                         ) "CLAIM_NO",
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '00')) "POLICY_NO",
                         a.dsp_loss_date, a.clm_file_date, a.pol_eff_date,
                         a.subline_cd, a.pol_iss_cd, a.issue_yy,
                         a.pol_seq_no, a.renew_no, a.assured_name,
                         a.claim_id, a.clm_stat_cd, a.old_stat_cd,
                         close_date,clm_stat_desc
                    FROM gicl_claims a,
                         giis_line b,
                         giis_issource c,
                         giis_clm_stat d
                   WHERE TRUNC (a.clm_file_date) BETWEEN NVL (v_start_dt,
                                                              a.clm_file_date
                                                             )
                                                     AND NVL (v_end_dt,
                                                              a.clm_file_date
                                                             )
                     AND a.iss_cd IN NVL (DECODE (p_branch_cd,
                                                  'D', a.iss_cd,
                                                  v_ri_cd, v_ri_cd,
                                                  p_branch_cd
                                                 ),
                                          a.iss_cd
                                         )
                     AND a.iss_cd NOT IN DECODE (p_branch_cd, 'D', 'RI', '*')
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.iss_cd = c.iss_cd
                     AND a.clm_stat_cd = d.clm_stat_cd
                     AND a.iss_cd = c.iss_cd
                     AND a.line_cd = b.line_cd
                     AND EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL','GICLS540',p_user_id))
                         WHERE LINE_CD= a.line_cd and BRANCH_CD = a.iss_cd) --added by MarkS 11.18.2016 SR5844 optimization
                ORDER BY    a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                         || '-'
                         || LPAD (TO_CHAR (a.clm_seq_no), 7, '0'),c.iss_name,a.line_cd
                         )
      LOOP
         v_exist2 := NULL;
         v_not_exist := FALSE;
         FOR rec2 IN (SELECT DISTINCT c.peril_cd, c.peril_sname peril_sname, b.claim_id, c.line_cd
                       FROM gicl_item_peril b, giis_peril c 
                      WHERE b.peril_cd = c.peril_cd
                        AND c.line_cd = rec.line_cd
                        AND b.claim_id = rec.claim_id)
        LOOP
          v_exist2   := 'Y';
          SELECT decode(p_loss_exp,'E','E','L'),decode(p_loss_exp,'LE',2,1)
            INTO v_loss_exp, ctr
            FROM dual;
            
            
          FOR i IN 1..ctr
          LOOP
            --added by Edison 02.29.2012
            v_list.line_cd        := rec.line_cd; 
            v_list.iss_cd         := rec.iss_cd;
            v_list.branch         := rec.iss_name;
            v_list.branch_name    := rec.iss_name; 
            v_list.line_name      := rec.line_name;
            v_list.claim_no       := rec.claim_no;
            v_list.policy_no      := rec.policy_no;
            v_list.assured_name   := rec.assured_name;
            v_list.intm           := get_giclr544_intm (rec.claim_id);
            v_list.pol_eff_date   := rec.pol_eff_date;
            v_list.dsp_loss_date  := rec.dsp_loss_date;
            v_list.clm_file_date  := rec.clm_file_date;
            v_list.status         := rec.clm_stat_desc;
            v_list.peril_sname    := rec2.peril_sname;
            v_list.payee_type     := v_loss_exp;
            v_list.loss_amt       := get_loss_amt(rec.claim_id, rec2.peril_cd,v_loss_exp,rec.clm_stat_cd);
            v_list.net_ret        := nvl(AMOUNT_PER_SHARE_TYPE(rec.claim_id,rec2.peril_cd,1,v_loss_exp,rec.clm_stat_cd),0);
            v_list.trty           := nvl(AMOUNT_PER_SHARE_TYPE(rec.claim_id,rec2.peril_cd,v_TRTY,v_loss_exp,rec.clm_stat_cd),0);
            v_list.xol            := nvl(AMOUNT_PER_SHARE_TYPE(rec.claim_id,rec2.peril_cd,v_XOL,v_loss_exp,rec.clm_stat_cd),0);
            v_list.facul          := nvl(AMOUNT_PER_SHARE_TYPE(rec.claim_id,rec2.peril_cd,v_FACUL,v_loss_exp,rec.clm_stat_cd),0);
            v_list.exp_loss_amt       := get_loss_amt(rec.claim_id, rec2.peril_cd,'E',rec.clm_stat_cd);
            v_list.exp_net_ret        := nvl(AMOUNT_PER_SHARE_TYPE(rec.claim_id,rec2.peril_cd,1,'E',rec.clm_stat_cd),0);
            v_list.exp_trty           := nvl(AMOUNT_PER_SHARE_TYPE(rec.claim_id,rec2.peril_cd,v_TRTY,'E',rec.clm_stat_cd),0);
            v_list.exp_xol            := nvl(AMOUNT_PER_SHARE_TYPE(rec.claim_id,rec2.peril_cd,v_XOL,'E',rec.clm_stat_cd),0);
            v_list.exp_facul          := nvl(AMOUNT_PER_SHARE_TYPE(rec.claim_id,rec2.peril_cd,v_FACUL,'E',rec.clm_stat_cd),0);
            v_list.subline_cd := rec.subline_cd;
            v_list.pol_iss_cd := rec.pol_iss_cd;
            v_list.issue_yy := rec.issue_yy;
            v_list.pol_seq_no := rec.pol_seq_no;
            v_list.renew_no := rec.renew_no;
            v_list.claim_id := rec.claim_id;
            v_list.clm_stat_cd := rec.clm_stat_cd;
            v_list.old_stat_cd := rec.old_stat_cd;
            v_list.close_date := rec.close_date;
            v_list.clm_stat := rec.clm_stat_desc;
            PIPE ROW(v_list);
          
          v_loss_exp := 'E';
          END LOOP;
        END LOOP;
        
        IF NVL(v_exist2, 'N') = 'N' THEN
          v_list.iss_cd         := rec.iss_cd;
          v_list.branch         := rec.iss_name;
          v_list.line_name      := rec.line_name;
          v_list.branch_name    := rec.iss_name; 
          v_list.line_cd        := rec.line_cd; 
          v_list.claim_no       := rec.claim_no;
          v_list.policy_no      := rec.policy_no;
          v_list.assured_name   := rec.assured_name;
          v_list.intm           := get_giclr544_intm (rec.claim_id);
          v_list.pol_eff_date   := rec.pol_eff_date;
          v_list.dsp_loss_date  := rec.dsp_loss_date;
          v_list.clm_file_date  := rec.clm_file_date;
          v_list.status         := rec.clm_stat_desc;
          v_list.peril_sname    := null;
          v_list.loss_amt       := 0;
          v_list.net_ret        := 0;
          v_list.trty           := 0;
          v_list.xol            := 0;
          v_list.facul          := 0;
          v_list.exp_loss_amt   := 0;
          v_list.exp_net_ret    := 0;
          v_list.exp_trty       := 0;
          v_list.exp_xol        := 0;
          v_list.exp_facul      := 0;
          v_list.payee_type     := null;
          v_list.clm_stat       := rec.clm_stat_desc; 
          v_list.subline_cd := rec.subline_cd;
          v_list.pol_iss_cd := rec.pol_iss_cd;
          v_list.issue_yy := rec.issue_yy;
          v_list.pol_seq_no := rec.pol_seq_no;
          v_list.renew_no := rec.renew_no;
          v_list.claim_id := rec.claim_id;
          v_list.clm_stat_cd := rec.clm_stat_cd;
          v_list.old_stat_cd := rec.old_stat_cd;
          v_list.close_date := rec.close_date;
          v_list.clm_stat := rec.clm_stat_desc;
          PIPE ROW(v_list);
          --end 02.29.2012
        END IF;

      END LOOP;
      
      IF v_not_exist
      THEN
        v_list.flag := 'T';
        PIPE ROW (v_list);
      END IF;      
   END get_giclr544_records2;
-------------------------------------------------   
--END by MarkS 11.23.2016 SR5844 OPTIMIZATION  
   FUNCTION get_giclr544_peril_records (
      p_claim_id      NUMBER,
      p_line_cd       VARCHAR2,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   VARCHAR2
   )
      RETURN giclr544_peril_tab PIPELINED
   IS
      v_list        giclr544_peril_type;
      v_loss_exp    VARCHAR2 (2);
      v_not_exist   BOOLEAN             := TRUE;
   BEGIN
      FOR i IN (SELECT DISTINCT c.peril_cd, c.peril_sname peril_sname,
                                b.claim_id, c.line_cd
                           FROM gicl_item_peril b, giis_peril c
                          WHERE b.peril_cd = c.peril_cd
                            AND c.line_cd = NVL (p_line_cd, c.line_cd)
                            AND b.claim_id = p_claim_id)
      LOOP
         v_not_exist := FALSE;
         v_list.peril_cd := i.peril_cd;
         v_list.peril_sname := i.peril_sname;
         v_list.claim_id := i.claim_id;
         v_list.line_cd := i.line_cd;
         v_list.exp_amt :=
            NVL (gicls540_pkg.get_loss_amt (i.claim_id,
                                            i.peril_cd,
                                            'E',
                                            p_clm_stat_cd
                                           ),
                 0.00
                );
         v_list.exp_retention :=
            NVL (gicls540_pkg.amount_per_share_type (i.claim_id,
                                                     i.peril_cd,
                                                     1,
                                                     'E',
                                                     p_clm_stat_cd
                                                    ),
                 0.00
                );

         SELECT DECODE (p_loss_exp, 'E', 'E', 'L')
           INTO v_loss_exp
           FROM DUAL;

         v_list.RETENTION :=
            NVL (gicls540_pkg.amount_per_share_type (i.claim_id,
                                                     i.peril_cd,
                                                     1,
                                                     v_loss_exp,
                                                     p_clm_stat_cd
                                                    ),
                 0.00
                );
         v_list.loss_amt :=
            NVL (gicls540_pkg.get_loss_amt (i.claim_id,
                                            i.peril_cd,
                                            v_loss_exp,
                                            p_clm_stat_cd
                                           ),
                 0
                );
         v_list.exp_treaty :=
            NVL
               (gicls540_pkg.amount_per_share_type
                                                  (i.claim_id,
                                                   i.peril_cd,
                                                   giacp.v ('TRTY_SHARE_TYPE'),
                                                   'E',
                                                   p_clm_stat_cd
                                                  ),
                0.00
               );
         v_list.treaty :=
            NVL
               (gicls540_pkg.amount_per_share_type
                                                  (i.claim_id,
                                                   i.peril_cd,
                                                   giacp.v ('TRTY_SHARE_TYPE'),
                                                   v_loss_exp,
                                                   p_clm_stat_cd
                                                  ),
                0.00
               );
         v_list.exp_facultative :=
            NVL
               (gicls540_pkg.amount_per_share_type
                                                 (i.claim_id,
                                                  i.peril_cd,
                                                  giacp.v ('FACUL_SHARE_TYPE'),
                                                  'E',
                                                  p_clm_stat_cd
                                                 ),
                0.00
               );
         v_list.facultative :=
            NVL
               (gicls540_pkg.amount_per_share_type
                                                 (i.claim_id,
                                                  i.peril_cd,
                                                  giacp.v ('FACUL_SHARE_TYPE'),
                                                  v_loss_exp,
                                                  p_clm_stat_cd
                                                 ),
                0.00
               );
         v_list.exp_sol :=
            NVL
               (gicls540_pkg.amount_per_share_type
                                              (i.claim_id,
                                               i.peril_cd,
                                               giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                               'E',
                                               p_clm_stat_cd
                                              ),
                0.00
               );
         v_list.xol :=
            NVL
               (gicls540_pkg.amount_per_share_type
                                              (i.claim_id,
                                               i.peril_cd,
                                               giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                               v_loss_exp,
                                               p_clm_stat_cd
                                              ),
                0.00
               );
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.exp_amt := 0.00;
         v_list.exp_retention := 0.00;
         v_list.RETENTION := 0.00;
         v_list.loss_amt := 0.00;
         v_list.exp_treaty := 0.00;
         v_list.treaty := 0.00;
         v_list.exp_facultative := 0.00;
         v_list.facultative := 0.00;
         v_list.exp_sol := 0.00;
         v_list.xol := 0.00;
         PIPE ROW (v_list);
      END IF;
   END get_giclr544_peril_records;

   FUNCTION get_giclr544_line_tot (
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_end_dt      VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line        VARCHAR2,
      p_line_cd     VARCHAR2,
      p_loss_exp    VARCHAR2,
      p_start_dt    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giclr544_line_tot_tab PIPELINED
   IS
      v_list        giclr544_line_tot_type;
      v_loss_exp    VARCHAR2 (2);
      v_start_dt    DATE                := TO_DATE (p_start_dt, 'MM/DD/YYYY');
      v_end_dt      DATE                  := TO_DATE (p_end_dt, 'MM/DD/YYYY');
      v_not_exist   BOOLEAN                := TRUE;
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.iss_cd,
                         (   a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.iss_cd
                          || '-'
                          || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                          || '-'
                          || LPAD (TO_CHAR (a.clm_seq_no), 7, '0')
                         ) "CLAIM_NO",
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '00')) "POLICY_NO",
                         a.dsp_loss_date, a.clm_file_date, a.pol_eff_date,
                         a.subline_cd, a.pol_iss_cd, a.issue_yy,
                         a.pol_seq_no, a.renew_no, a.assured_name,
                         a.claim_id, a.clm_stat_cd, a.old_stat_cd,
                         close_date
                    FROM gicl_claims a
                   WHERE TRUNC (a.clm_file_date) BETWEEN NVL (v_start_dt,
                                                              a.clm_file_date
                                                             )
                                                     AND NVL (v_end_dt,
                                                              a.clm_file_date
                                                             )
                     AND a.iss_cd IN NVL (DECODE (p_branch_cd,
                                                  'D', a.iss_cd,
                                                  giacp.v ('RI_ISS_CD'), giacp.v
                                                                  ('RI_ISS_CD'),
                                                  p_branch_cd
                                                 ),
                                          a.iss_cd
                                         )
                     AND a.iss_cd NOT IN DECODE (p_branch_cd, 'D', 'RI', '*')
                     AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND check_user_per_iss_cd2 (a.line_cd,
                                                 NVL (p_iss_cd, NULL),
                                                 'GICLS540',
                                                 p_user_id
                                                ) = 1
                     AND check_user_per_iss_cd2 (NVL (p_line_cd, NULL),
                                                 a.iss_cd,
                                                 'GICLS540',
                                                 p_user_id
                                                ) = 1
                     AND check_user_per_iss_cd2 (a.line_cd,
                                                 a.iss_cd,
                                                 'GICLS540',
                                                 p_user_id
                                                ) = 1
                ORDER BY    a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                         || '-'
                         || LPAD (TO_CHAR (a.clm_seq_no), 7, '0'))
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.claim_id := i.claim_id;

         FOR k IN (SELECT DISTINCT c.peril_cd, c.peril_sname peril_sname,
                                   b.claim_id, c.line_cd
                              FROM gicl_item_peril b, giis_peril c
                             WHERE b.peril_cd = c.peril_cd
                               AND c.line_cd = NVL (i.line_cd, c.line_cd)
                               AND b.claim_id = i.claim_id)
         LOOP
            v_not_exist := FALSE;
            v_list.peril_cd := k.peril_cd;
            v_list.peril_sname := k.peril_sname;
            v_list.claim_id2 := k.claim_id;
            v_list.line_cd2 := k.line_cd;
            v_list.exp_amt :=
               NVL (gicls540_pkg.get_loss_amt (i.claim_id,
                                               k.peril_cd,
                                               'E',
                                               i.clm_stat_cd
                                              ),
                    0
                   );
            v_list.exp_retention :=
               NVL (gicls540_pkg.amount_per_share_type (i.claim_id,
                                                        k.peril_cd,
                                                        1,
                                                        'E',
                                                        i.clm_stat_cd
                                                       ),
                    0
                   );

            SELECT DECODE (p_loss_exp, 'E', 'E', 'L')
              INTO v_loss_exp
              FROM DUAL;

            v_list.RETENTION :=
               NVL (gicls540_pkg.amount_per_share_type (i.claim_id,
                                                        k.peril_cd,
                                                        1,
                                                        v_loss_exp,
                                                        i.clm_stat_cd
                                                       ),
                    0
                   );
            v_list.loss_amt :=
               NVL (gicls540_pkg.get_loss_amt (i.claim_id,
                                               k.peril_cd,
                                               v_loss_exp,
                                               i.clm_stat_cd
                                              ),
                    0
                   );
            v_list.exp_treaty :=
               NVL
                  (gicls540_pkg.amount_per_share_type
                                                  (i.claim_id,
                                                   k.peril_cd,
                                                   giacp.v ('TRTY_SHARE_TYPE'),
                                                   'E',
                                                   i.clm_stat_cd
                                                  ),
                   0
                  );
            v_list.treaty :=
               NVL
                  (gicls540_pkg.amount_per_share_type
                                                  (i.claim_id,
                                                   k.peril_cd,
                                                   giacp.v ('TRTY_SHARE_TYPE'),
                                                   v_loss_exp,
                                                   i.clm_stat_cd
                                                  ),
                   0
                  );
            v_list.exp_facultative :=
               NVL
                  (gicls540_pkg.amount_per_share_type
                                                 (i.claim_id,
                                                  k.peril_cd,
                                                  giacp.v ('FACUL_SHARE_TYPE'),
                                                  'E',
                                                  i.clm_stat_cd
                                                 ),
                   0
                  );
            v_list.facultative :=
               NVL
                  (gicls540_pkg.amount_per_share_type
                                                 (i.claim_id,
                                                  k.peril_cd,
                                                  giacp.v ('FACUL_SHARE_TYPE'),
                                                  v_loss_exp,
                                                  i.clm_stat_cd
                                                 ),
                   0
                  );
            v_list.exp_sol :=
               NVL
                  (gicls540_pkg.amount_per_share_type
                                              (i.claim_id,
                                               k.peril_cd,
                                               giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                               'E',
                                               i.clm_stat_cd
                                              ),
                   0
                  );
            v_list.xol :=
               NVL
                  (gicls540_pkg.amount_per_share_type
                                              (i.claim_id,
                                               k.peril_cd,
                                               giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                               v_loss_exp,
                                               i.clm_stat_cd
                                              ),
                   0
                  );
            PIPE ROW (v_list);
         END LOOP;
      END LOOP;

      IF v_not_exist
      THEN
         v_list.exp_amt := 0.00;
         v_list.exp_retention := 0.00;
         v_list.RETENTION := 0.00;
         v_list.loss_amt := 0.00;
         v_list.exp_treaty := 0.00;
         v_list.treaty := 0.00;
         v_list.exp_facultative := 0.00;
         v_list.facultative := 0.00;
         v_list.exp_sol := 0.00;
         v_list.xol := 0.00;
         PIPE ROW (v_list);
      END IF;
   END get_giclr544_line_tot;
   
--added by MarkS 11.23.2016 SR5844 OPTIMIZATION 
-------------------------------------------------
   FUNCTION AMOUNT_PER_SHARE_TYPE(p_claim_id     gicl_claims.claim_id%TYPE,
                                  p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
                                  p_share_type   gicl_loss_exp_ds.share_type%TYPE,
                                  p_loss_exp     VARCHAR2,
                                  p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE)
                         RETURN NUMBER
   IS
       v_amount       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
   BEGIN
      --considered item number for peril that exists in more than one item.
      FOR item IN (  SELECT DISTINCT b.item_no
                       FROM giis_peril a, gicl_item_peril b
                      WHERE a.line_cd = b.line_cd
                        AND a.peril_cd = b.peril_cd
                        AND b.claim_id = p_claim_id
                        AND b.peril_cd = p_peril_cd  ) 
      LOOP
         v_amount := v_amount + get_amount_per_item_peril(p_claim_id, item.item_no, p_peril_cd, p_share_type, p_loss_exp, p_clm_stat_cd);
      END LOOP;
      RETURN (v_amount);
   END;   
   FUNCTION get_loss_amt(p_claim_id     gicl_claims.claim_id%TYPE,
                         p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
                         p_loss_exp     VARCHAR2,
                         p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE)
                         RETURN NUMBER
   IS
     v_amount       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
   BEGIN
      --considered item number for peril that exists in more than one item by MAC 11/09/2012.
      FOR item IN (  SELECT DISTINCT b.item_no
                       FROM giis_peril a, gicl_item_peril b
                      WHERE a.line_cd = b.line_cd
                        AND a.peril_cd = b.peril_cd
                        AND b.claim_id = p_claim_id
                        AND b.peril_cd = p_peril_cd  ) 
      LOOP
          v_amount := v_amount + get_loss_amount_per_item_peril(p_claim_id, item.item_no, p_peril_cd, p_loss_exp, p_clm_stat_cd);
      END LOOP;
     RETURN (v_amount);
   END;
  FUNCTION get_amount_per_item_peril(p_claim_id     gicl_claims.claim_id%TYPE,
                                      p_item_no      gicl_loss_exp_ds.item_no%TYPE,
                                      p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
                                      p_share_type   gicl_loss_exp_ds.share_type%TYPE,
                                      p_loss_exp     VARCHAR2,
                                      p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE) RETURN NUMBER
   IS
       v_amount       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
       v_exist        VARCHAR2 (1);
   BEGIN
      IF p_clm_stat_cd = 'CC' OR p_clm_stat_cd = 'DN' OR p_clm_stat_cd = 'WD' THEN
          v_amount := 0;
      ELSE
         BEGIN
            SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                      WHERE a.tran_id IS NOT NULL
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.claim_id = p_claim_id
                        AND a.item_no = p_item_no --considered item number
                        AND a.peril_cd = p_peril_cd
                        --added additional condition to check what particular type has payment
                        AND DECODE (p_loss_exp, 'E', a.expenses_paid, a.losses_paid) <> 0
                        AND a.claim_id = b.claim_id
                        AND a.item_no = b.item_no       
                        AND a.peril_cd = b.peril_cd
                        AND a.grouped_item_no = b.grouped_item_no
                        AND a.clm_loss_id = b.clm_loss_id;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               v_exist := NULL;
         END;

         --get amount per type (Loss or Expense)
         IF v_exist IS NOT NULL THEN
            FOR p IN (SELECT SUM (c.convert_rate * NVL (shr_le_net_amt, 0)) paid
                        FROM gicl_clm_loss_exp a,
                             gicl_loss_exp_ds b,
                             gicl_advice c
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_loss_id = b.clm_loss_id
                         AND a.claim_id = c.claim_id
                         AND a.advice_id = c.advice_id
                         AND b.claim_id = p_claim_id
                         AND b.item_no = p_item_no --considered item number
                         AND b.peril_cd = p_peril_cd
                         AND a.tran_id IS NOT NULL
                         AND NVL (b.negate_tag, 'N') = 'N'
                         AND b.share_type = p_share_type
                         AND a.payee_type = DECODE (p_loss_exp, 'L', 'L', 'E') )
            LOOP
               v_amount := NVL(p.paid,0);
            END LOOP;
         ELSE
            FOR r IN (SELECT DECODE (p_loss_exp,
                                            'L', SUM (  b.convert_rate * NVL (a.shr_loss_res_amt, 0) ),
                                                 SUM (  b.convert_rate * NVL (a.shr_exp_res_amt, 0) )
                                    ) reserve
                        FROM gicl_reserve_ds a, gicl_clm_res_hist b
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_res_hist_id = b.clm_res_hist_id
                         AND b.dist_sw = 'Y'
                         AND a.claim_id = p_claim_id
                         AND b.item_no = p_item_no --considered item number
                         AND a.peril_cd = p_peril_cd
                         AND NVL (a.negate_tag, 'N') = 'N'
                         AND a.share_type = p_share_type)
            LOOP
               v_amount := NVL(r.reserve,0);
            END LOOP;
         END IF;
      END IF;
      RETURN (v_amount);
   END; 
   
   FUNCTION get_loss_amount_per_item_peril(p_claim_id     gicl_claims.claim_id%TYPE,
                                           p_item_no      gicl_loss_exp_ds.item_no%TYPE,
                                           p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
                                           p_loss_exp     VARCHAR2,
                                           p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE)
                                           RETURN NUMBER
   IS
        v_amount       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
        v_exist        VARCHAR2 (1);
   BEGIN
     IF p_clm_stat_cd = 'CC' OR p_clm_stat_cd = 'DN' OR p_clm_stat_cd = 'WD' THEN
        v_amount := 0;
     ELSE
        FOR i IN (SELECT DISTINCT 1
                        FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                       WHERE a.tran_id IS NOT NULL
                         AND NVL(a.cancel_tag,'N') = 'N' 
                         AND a.claim_id = p_claim_id
                         AND a.item_no = p_item_no --considered item number by MAC 11/09/2012.
                         AND a.peril_cd = p_peril_cd
                         AND DECODE(p_loss_exp,'E',expenses_paid,losses_paid) <> 0
                          --AND TRUNC(date_paid) BETWEEN p_start_dt AND p_end_dt) jen.20121025
                         AND a.claim_id = b.claim_id
                         AND a.item_no = b.item_no       
                         AND a.peril_cd = b.peril_cd
                         AND a.grouped_item_no = b.grouped_item_no
                         AND a.clm_loss_id = b.clm_loss_id)       
        LOOP
          v_exist := 'Y';
          EXIT;
        END LOOP;
        
        /*Modified by: Jen.20121029 
        ** Get the paid amt if claim has payment, else get the reserve amount.*/
        FOR p IN (SELECT SUM(DECODE (NVL (cancel_tag, 'N'),
                                     'N', DECODE (tran_id,
                                                  NULL, DECODE(p_loss_exp, 'E',NVL (convert_rate * expense_reserve, 0),
                                                               NVL (convert_rate * loss_reserve, 0)), 
                                                  DECODE(p_loss_exp, 'E',NVL (convert_rate * expenses_paid, 0),
                                                         NVL (convert_rate * losses_paid, 0))),
                                     DECODE(p_loss_exp, 'E',NVL (convert_rate * expense_reserve, 0),
                                            NVL (convert_rate * loss_reserve, 0)))) paid
                    FROM gicl_clm_res_hist
                   WHERE claim_id = p_claim_id 
                     AND item_no = p_item_no --considered item number by MAC 11/09/2012.
                     AND peril_cd = p_peril_cd 
                     AND NVL(dist_sw,'!') = DECODE (v_exist, NULL, 'Y',NVL(dist_sw,'!'))               
                     AND NVL(tran_id,-1) = DECODE (v_exist, 'Y', tran_id, -1))               
        LOOP
          v_amount :=  NVL(p.paid,0);
        END LOOP;
     END IF;
        RETURN (v_amount);
   END;
-------------------------------------------------   
--END by MarkS 11.23.2016 SR5844 OPTIMIZATION      
END;
/


