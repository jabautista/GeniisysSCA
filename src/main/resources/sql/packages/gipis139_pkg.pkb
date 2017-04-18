CREATE OR REPLACE PACKAGE BODY CPI.gipis139_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 09.12.2013
   **  Reference By : GIPIS139 - View Intermediary Commission
   **  Description  :
   */
   FUNCTION get_subline_lov (p_line_cd giis_line.line_cd%TYPE)
      RETURN subline_lov_tab PIPELINED
   IS
      v_rec   subline_lov_type;
   BEGIN
      FOR i IN (SELECT subline_cd, subline_name
                  FROM giis_subline
                 WHERE line_cd = p_line_cd)
      LOOP
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_line_lov (
      p_user_id     giis_users.user_id%TYPE,
      p_module_id   VARCHAR2
   )
      RETURN line_lov_tab PIPELINED
   IS
      v_rec   line_lov_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name
                  FROM giis_line
                 WHERE line_cd =
                          DECODE (check_user_per_line2 (line_cd,
                                                        NULL,
                                                        p_module_id,
                                                        p_user_id
                                                       ),
                                  1, line_cd,
                                  NULL
                                 ))
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_intermediary_lov
      RETURN intermediary_lov_tab PIPELINED
   IS
      v_rec   intermediary_lov_type;
   BEGIN
      FOR i IN (SELECT intm_no, intm_name
                  FROM giis_intermediary)
      LOOP
         v_rec.intm_no := i.intm_no;
         v_rec.intm_name := i.intm_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_intermediary_comm (
      p_intrmdry_intm_no   polbasic_comm_invoice_v.intrmdry_intm_no%TYPE,
      p_line_cd            polbasic_comm_invoice_v.line_cd%TYPE,
      p_subline_cd         polbasic_comm_invoice_v.subline_cd%TYPE,
      p_cred_branch        VARCHAR2,
      p_user_id            VARCHAR2,
      p_module_id          VARCHAR2
   )
      RETURN intermediary_comm_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      custom    cur_typ;
      v_rec     intermediary_comm_type;
      v_where   VARCHAR2 (10000)       := '';
      v_query   VARCHAR2 (10000)
         :=    'SELECT a.intrmdry_intm_no, a.prem_seq_no, a.share_percentage,
       a.commission_amt, a.line_cd, a.subline_cd, a.issue_yy, a.endt_yy,
       a.pol_seq_no, a.renew_no, a.eff_date, a.assd_no, a.endt_seq_no,
       a.endt_iss_cd
          FROM polbasic_comm_invoice_v a
         WHERE a.line_cd = '
            || ''''
            || p_line_cd
            || ''''
            || ' AND a.subline_cd = '
            || ''''
            || p_subline_cd
            || ''''
            || ' AND a.intrmdry_intm_no = '
            || ''''
            || p_intrmdry_intm_no
            || '''';
   BEGIN
      IF check_user_per_line2 (p_line_cd,
                               p_cred_branch,
                               p_module_id,
                               p_user_id
                              ) = 1
      THEN
         v_where :=
               ' AND prem_seq_no IN (SELECT distinct b.prem_seq_no
                 FROM gipi_polbasic a, gipi_comm_invoice b, polbasic_comm_invoice_v c 
                WHERE 1=1
                  AND b.prem_seq_no = c.prem_seq_no 
                  AND a.policy_id = b.policy_id 
                  AND a.iss_cd = b.iss_cd
                  AND a.cred_branch = '''
            || p_cred_branch
            || ''''
            || ')';
      ELSE
         v_where :=
               ' AND check_user_per_line2(line_cd,endt_iss_cd,'''
            || p_module_id
            || ''','''
            || p_user_id
            || ''')=1 AND prem_seq_no IN (SELECT distinct b.prem_seq_no
   	                  FROM gipi_polbasic a, gipi_comm_invoice b, polbasic_comm_invoice_v c 
                    WHERE 1=1
                      AND b.prem_seq_no = c.prem_seq_no 
                      AND a.policy_id = b.policy_id 
                      AND a.iss_cd = b.iss_cd
                      AND a.cred_branch = '''
            || p_cred_branch
            || ''''
            || ')';
      END IF;

      v_query := v_query || v_where;

--      raise_application_error (-20001,v_query);
      OPEN custom FOR v_query;

      LOOP
         FETCH custom
          INTO v_rec.intm_no, v_rec.prem_seq_no, v_rec.share_percentage,
               v_rec.commission_amt, v_rec.line_cd, v_rec.subline_cd,
               v_rec.issue_yy, v_rec.endt_yy, v_rec.pol_seq_no,
               v_rec.renew_no, v_rec.eff_date, v_rec.assd_no,
               v_rec.endt_seq_no, v_rec.endt_iss_cd;

         FOR a IN (SELECT policy_id, iss_cd
                     FROM gipi_polbasic
                    WHERE line_cd = v_rec.line_cd
                      AND subline_cd = v_rec.subline_cd
                      AND issue_yy = v_rec.issue_yy
                      AND pol_seq_no = v_rec.pol_seq_no
                      AND endt_iss_cd = v_rec.endt_iss_cd
                      AND endt_seq_no = v_rec.endt_seq_no
                      AND endt_yy = v_rec.endt_yy)
         LOOP
            v_rec.policy_id := a.policy_id;
            v_rec.iss_cd := a.iss_cd;
            EXIT;
         END LOOP;

         IF v_rec.endt_seq_no <> 0
         THEN
            v_rec.policy_no :=
                  v_rec.line_cd
               || '-'
               || RTRIM (v_rec.subline_cd)
               || '-'
               || RTRIM (v_rec.iss_cd)
               || '-'
               || TO_CHAR (v_rec.issue_yy, '09')
               || '-'
               || TO_CHAR (v_rec.pol_seq_no, '0999999')
               || '-'
               || TO_CHAR (v_rec.renew_no, '09')
               || '/'
               || TO_CHAR (v_rec.endt_yy, '09')
               || '-'
               || TO_CHAR (v_rec.endt_seq_no, '0999999');
         ELSE
            v_rec.policy_no :=
                  v_rec.line_cd
               || '-'
               || RTRIM (v_rec.subline_cd)
               || '-'
               || RTRIM (v_rec.iss_cd)
               || '-'
               || TO_CHAR (v_rec.issue_yy, '09')
               || '-'
               || TO_CHAR (v_rec.pol_seq_no, '0999999')
               || '-'
               || TO_CHAR (v_rec.renew_no, '09')
               || '/';
         END IF;

         v_rec.invoice_no :=
                 v_rec.iss_cd || '-' || TO_CHAR (v_rec.prem_seq_no, '0999999');

         BEGIN
            FOR b IN (SELECT assd_name
                        FROM giis_assured
                       WHERE assd_no = v_rec.assd_no)
            LOOP
               v_rec.assured_name := b.assd_name;
               EXIT;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            SELECT DISTINCT (cred_branch)
                       INTO v_rec.cred_branch
                       FROM gipi_polbasic a,
                            gipi_comm_invoice b
                            --polbasic_comm_invoice_v c			removed by Kevs SR-5050 3-22-2017
                      WHERE 1 = 1
                        AND b.prem_seq_no = v_rec.prem_seq_no
                        --AND c.intrmdry_intm_no = b.intrmdry_intm_no
                        AND a.policy_id = b.policy_id
                        AND a.iss_cd = b.iss_cd
                        AND a.iss_cd = v_rec.iss_cd
                        AND cred_branch IS NOT NULL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.cred_branch := NULL;
         END;

         EXIT WHEN custom%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE custom;
   END;

   FUNCTION get_peril_detail (
      p_intrmdry_intm_no   gipi_comm_inv_peril.intrmdry_intm_no%TYPE,
      p_iss_cd             gipi_comm_inv_peril.iss_cd%TYPE,
      p_prem_seq_no        gipi_comm_inv_peril.prem_seq_no%TYPE,
      p_policy_id          gipi_comm_inv_peril.policy_id%TYPE,
      p_line_cd            giis_line.line_cd%TYPE
   )
      RETURN peril_detail_tab PIPELINED
   IS
      v_rec   peril_detail_type;
   BEGIN
      FOR i IN (SELECT peril_cd, premium_amt, commission_amt, commission_rt
                  FROM gipi_comm_inv_peril
                 WHERE intrmdry_intm_no = p_intrmdry_intm_no
                   AND iss_cd = p_iss_cd
                   AND prem_seq_no = p_prem_seq_no
                   AND policy_id = p_policy_id)
      LOOP
         FOR a1 IN (SELECT a170.peril_name peril
                      FROM giis_peril a170
                     WHERE a170.line_cd = p_line_cd
                       AND a170.peril_cd = i.peril_cd)
         LOOP
            v_rec.peril_name := a1.peril;
            EXIT;
         END LOOP;

         v_rec.peril_cd := i.peril_cd;
         v_rec.premium_amt := i.premium_amt;
         v_rec.commission_amt := i.commission_amt;
         v_rec.commission_rt := i.commission_rt;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_comm_detail (
      p_intrmdry_intm_no   gipi_comm_inv_peril.intrmdry_intm_no%TYPE,
      p_iss_cd             gipi_comm_inv_peril.iss_cd%TYPE,
      p_prem_seq_no        gipi_comm_inv_peril.prem_seq_no%TYPE,
      p_policy_id          gipi_comm_inv_peril.policy_id%TYPE,
      p_line_cd            giis_line.line_cd%TYPE
   )
      RETURN comm_detail_tab PIPELINED
   IS
      v_rec   comm_detail_type;
   BEGIN
      FOR i IN (SELECT peril_cd
                  FROM gipi_comm_inv_peril
                 WHERE intrmdry_intm_no = p_intrmdry_intm_no
                   AND iss_cd = p_iss_cd
                   AND prem_seq_no = p_prem_seq_no
                   AND policy_id = p_policy_id)
      LOOP
         FOR a IN (SELECT a.commission_rt a1, a.commission_amt a2,
                          b.commission_rt b1, b.commission_amt b2,
                          c.peril_name, a.iss_cd, a.prem_seq_no,
                          a.chld_intm_no
                     FROM giac_parent_comm_invprl a,
                          gipi_comm_inv_peril b,
                          giis_peril c
                    WHERE a.iss_cd = b.iss_cd
                      AND a.prem_seq_no = b.prem_seq_no
                      AND a.chld_intm_no = b.intrmdry_intm_no
                      AND a.peril_cd = b.peril_cd
                      AND b.peril_cd = c.peril_cd
                      AND a.iss_cd = p_iss_cd
                      AND a.chld_intm_no = p_intrmdry_intm_no
                      AND a.prem_seq_no = p_prem_seq_no
                      AND c.peril_cd = i.peril_cd
                      AND c.line_cd = p_line_cd)
         LOOP
            v_rec.parent_comm_rt := NVL (a.a1, 0.00);
            v_rec.parent_comm_amt := NVL (a.a2, 0.00);
            v_rec.child_comm_rt := NVL (a.b1 - a.a1, 0.00);
            v_rec.child_comm_amt := NVL (a.b2 - a.a2, 0.00);
            v_rec.peril_name := a.peril_name;
            v_rec.peril_cd := i.peril_cd;
            PIPE ROW (v_rec);
         END LOOP;
      END LOOP;
   END;
END;
/


