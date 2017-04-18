CREATE OR REPLACE PACKAGE BODY CPI.giacr259_pkg
AS
   /*
     **  Created by   : Michael John R. Malicad
     **  Date Created : 08.16.2013
     **  Reference By : GIACR259
     **  Description  : Commissions Not in Standard Rate
     */
   FUNCTION cf_date (p_date_param VARCHAR2, p_from DATE, p_to DATE)
      RETURN CHAR
   IS
      v_date   VARCHAR2 (100);
   BEGIN
      IF p_date_param = 'ISSUE_DATE'
      THEN
         v_date :=
               'Issue Date from'
            || ' '
            || TO_CHAR (p_from, 'fmMonth DD, YYYY')
            || ' '
            || 'to'
            || ' '
            || TO_CHAR (p_to, 'fmMonth DD, YYYY');
      ELSIF p_date_param = 'EFF_DATE'
      THEN
         v_date :=
               'Effectivity Date from'
            || ' '
            || TO_CHAR (p_from, 'fmMonth DD, YYYY')
            || ' '
            || 'to'
            || ' '
            || TO_CHAR (p_to, 'fmMonth DD, YYYY');
      ELSE
         v_date :=
               'Accounting Entry date from'
            || ' '
            || TO_CHAR (p_from, 'fmMonth DD, YYYY')
            || ' '
            || 'to'
            || ' '
            || TO_CHAR (p_to, 'fmMonth DD, YYYY');
      END IF;

      RETURN (v_date);
   END;

   FUNCTION cf_branch (
      p_branch_cd      VARCHAR2,
      p_branch_param   VARCHAR2,
      p_policy_id      NUMBER
   )
      RETURN CHAR
   IS
      v_branch   VARCHAR2 (50);
   BEGIN
      FOR a IN (SELECT (a.iss_cd || ' - ' || iss_name) branch
                  FROM giis_issource a, gipi_polbasic b
                 WHERE a.iss_cd = b.iss_cd
                   AND b.policy_id = p_policy_id
                   AND (   (    b.iss_cd = NVL (p_branch_cd, b.iss_cd)
                            AND p_branch_param = 'ISS_CD'
                           )
                        OR (    b.cred_branch =
                                              NVL (p_branch_cd, b.cred_branch)
                            AND p_branch_param = 'CRED_BRANCH'
                           )
                       ))
      LOOP
         v_branch := a.branch;
      END LOOP;

      RETURN (v_branch);
   END;

   FUNCTION cf_commission_rate (
      p_iss_cd            VARCHAR2,
      p_prem_seq_no       NUMBER,
      p_intermediary_cd   NUMBER
   )
      RETURN NUMBER
   IS
      v_commission_rt    NUMBER (16, 2);
      v_commission_rt2   NUMBER (16, 2);
      v_commission_rt3   NUMBER (16, 2);
   BEGIN
      FOR a1 IN (SELECT commission_rt
                   FROM gipi_comm_inv_peril
                  WHERE iss_cd = p_iss_cd
                    AND prem_seq_no = p_prem_seq_no
                    AND intrmdry_intm_no =
                                     NVL (p_intermediary_cd, intrmdry_intm_no))
      LOOP
         v_commission_rt := a1.commission_rt;
      END LOOP;
      
      BEGIN --added by steven 10.10.2014 begin...end
         SELECT commission_rt
           INTO v_commission_rt2
           FROM giac_parent_comm_invprl
          WHERE iss_cd = p_iss_cd
            AND prem_seq_no = p_prem_seq_no
            AND intm_no = NVL (p_intermediary_cd, intm_no);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_commission_rt2 := 0;
      END;
         v_commission_rt3 := (v_commission_rt - v_commission_rt2);
         RETURN (v_commission_rt3);
   END;

   FUNCTION cf_commission_amt (
      p_iss_cd            VARCHAR2,
      p_prem_seq_no       NUMBER,
      p_intermediary_cd   NUMBER
   )
      RETURN NUMBER
   IS
      v_commission_amt    NUMBER (16, 2);
      v_commission_amt2   NUMBER (16, 2);
      v_commission_amt3   NUMBER (16, 2);
   BEGIN
      FOR a1 IN (SELECT commission_amt
                   FROM gipi_comm_inv_peril
                  WHERE iss_cd = p_iss_cd
                    AND prem_seq_no = p_prem_seq_no
                    AND intrmdry_intm_no =
                                     NVL (p_intermediary_cd, intrmdry_intm_no))
      LOOP
         v_commission_amt := a1.commission_amt;
      END LOOP;

      SELECT commission_amt
        INTO v_commission_amt2
        FROM giac_parent_comm_invprl
       WHERE iss_cd = p_iss_cd
         AND prem_seq_no = p_prem_seq_no
         AND intm_no = NVL (p_intermediary_cd, intm_no);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_commission_amt2 := 0;
         v_commission_amt3 := (v_commission_amt - v_commission_amt2);
         RETURN (v_commission_amt3);
   END;

   FUNCTION get_giacr259_record (
      p_branch_param      VARCHAR2,
      p_date_param        VARCHAR2,
      p_line_cd           VARCHAR2,
      p_branch_cd         VARCHAR2,
      p_from              DATE,
      p_to                DATE,
      p_intm_cd           VARCHAR2,
      p_intermediary_cd   VARCHAR2,
      p_module_id         VARCHAR2,
      p_user_id           VARCHAR2
   )
      RETURN giacr259_record_tab PIPELINED
   IS
      v_rec   giacr259_record_type;
      mjm     BOOLEAN              := TRUE;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giacp.v ('COMPANY_ADDRESS');
      v_rec.cf_date := cf_date (p_date_param, p_from, p_to);

      FOR i IN (SELECT DISTINCT DECODE (p_branch_param,
                                        'ISS_CD', e.iss_cd,
                                        e.cred_branch
                                       ) branch,
                                DECODE (p_date_param,
                                        'EFF_DATE', e.eff_date,
                                        'ISSUE_DATE', e.issue_date,
                                        e.acct_ent_date
                                       ) pdate,
                                (b.line_cd || ' ' || '-' || ' ' || b.line_name
                                ) line,
                                (c.intm_type || ' ' || '-' || ' '
                                 || c.intm_desc
                                ) intm_type,
                                (   d.intm_no
                                 || '-'
                                 || d.ref_intm_cd
                                 || '-'
                                 || d.intm_name
                                ) intermediary,
                                (   e.line_cd
                                 || '-'
                                 || e.subline_cd
                                 || '-'
                                 || e.iss_cd
                                 || '-'
                                 || e.issue_yy
                                 || '-'
                                 || e.pol_seq_no
                                 || '-'
                                 || e.renew_no
                                ) policy_number,
                                (f.iss_cd || '-' || f.prem_seq_no
                                ) bill_number,
                                f.iss_cd, f.prem_seq_no, g.peril_name,
                                h.comm_rate, f.premium_amt, e.policy_id,
                                NVL (f.commission_amt, 0) comm_amt     --issa
                                                                  ,
                                NVL (i.commission_amt, 0) pcomm_amt    --issa
                                                                   ,
                                f.commission_rt                        --issa
                           FROM giis_intm_type c,
                                giis_intermediary d,
                                gipi_comm_inv_peril f,
                                giis_peril g,
                                giac_parent_comm_invprl i,
                                giis_intmdry_type_rt h,
                                giis_issource a,
                                giis_line b,
                                gipi_polbasic e
                          WHERE 1 = 1
                            AND e.pol_flag <> '5'
                            AND e.reg_policy_sw = 'Y'
                            AND c.intm_type = d.intm_type
                            AND f.peril_cd = g.peril_cd
                            AND i.intm_no = d.intm_no
                            AND c.intm_type = h.intm_type
                            AND f.intrmdry_intm_no = d.intm_no
                            AND e.iss_cd = f.iss_cd
                            AND f.iss_cd = h.iss_cd
                            AND g.line_cd = h.line_cd
                            AND e.subline_cd = h.subline_cd
                            AND f.peril_cd = h.peril_cd
                            AND e.policy_id = f.policy_id
                            AND e.line_cd = g.line_cd
                            AND e.line_cd = h.line_cd
                            AND e.iss_cd = h.iss_cd
                            AND e.iss_cd = a.iss_cd
                            AND e.line_cd = b.line_cd
                            AND h.comm_rate <> f.commission_rt          --issa
                            AND b.line_cd = NVL (p_line_cd, b.line_cd)
                            AND c.intm_type = NVL (p_intm_cd, c.intm_type)
                            AND d.intm_no = NVL (p_intermediary_cd, d.intm_no)
                            AND (   (    e.iss_cd =
                                                   NVL (p_branch_cd, e.iss_cd)
                                     AND p_branch_param = 'ISS_CD'
                                    )
                                 OR (    e.cred_branch =
                                              NVL (p_branch_cd, e.cred_branch)
                                     AND p_branch_param = 'CRED_BRANCH'
                                    )
                                )
                            AND (   (    (e.issue_date BETWEEN p_from AND p_to
                                         )
                                     AND p_date_param = 'ISSUE_DATE'
                                    )
                                 OR (    (e.eff_date BETWEEN p_from AND p_to
                                         )
                                     AND p_date_param = 'EFF_DATE'
                                    )
                                 OR     ((e.acct_ent_date BETWEEN p_from AND p_to
                                         )
                                        )
                                    AND p_date_param = 'ACC_ENTDATE'
                                )
                UNION                        --added query issa@cic 01.22.2007
                SELECT DISTINCT DECODE (p_branch_param,
                                        'ISS_CD', gp.iss_cd,
                                        gp.cred_branch
                                       ) branch,
                                DECODE (p_date_param,
                                        'EFF_DATE', gp.eff_date,
                                        'ISSUE_DATE', gp.issue_date,
                                        gp.acct_ent_date
                                       ) pdate,
                                (gl.line_cd || ' ' || '-' || ' '
                                 || gl.line_name
                                ) line,
                                (   git.intm_type
                                 || ' '
                                 || '-'
                                 || ' '
                                 || git.intm_desc
                                ) intm_type,
                                (   gi.intm_no
                                 || '-'
                                 || gi.ref_intm_cd
                                 || '-'
                                 || gi.intm_name
                                ) intermediary,
                                (   gp.line_cd
                                 || '-'
                                 || gp.subline_cd
                                 || '-'
                                 || gp.iss_cd
                                 || '-'
                                 || gp.issue_yy
                                 || '-'
                                 || gp.pol_seq_no
                                 || '-'
                                 || gp.renew_no
                                ) policy_number,
                                (gcip.iss_cd || '-' || gcip.prem_seq_no
                                ) bill_number,
                                gcip.iss_cd, gcip.prem_seq_no, gpe.peril_name,
                                gisr.rate comm_rate, gcip.premium_amt,
                                gp.policy_id,
                                NVL (gcip.commission_amt, 0) comm_amt,
                                NVL (gpci.commission_amt, 0) pcomm_amt,
                                gcip.commission_rt
                           FROM gipi_comm_inv_peril gcip,
                                gipi_polbasic gp,
                                giis_line gl,
                                giis_intm_type git,
                                giis_intermediary gi,
                                giis_peril gpe,
                                giis_intm_special_rate gisr,
                                giis_issource gis,
                                giac_parent_comm_invprl gpci
                          WHERE 1 = 1
                            AND gp.pol_flag <> '5'
                            AND gp.reg_policy_sw = 'Y'
                            AND git.intm_type = gi.intm_type
                            AND gcip.peril_cd = gpe.peril_cd
                            AND gcip.intrmdry_intm_no = gi.intm_no
                            AND gp.iss_cd = gcip.iss_cd
                            AND gp.policy_id = gcip.policy_id
                            AND gp.line_cd = gpe.line_cd
                            AND gp.iss_cd = gis.iss_cd
                            AND gp.line_cd = gl.line_cd
                            AND gp.policy_id = gcip.policy_id
                            AND gl.line_cd = gp.line_cd
                            AND git.intm_type = gi.intm_type
                            AND gi.intm_no = gcip.intrmdry_intm_no
                            AND gpe.line_cd = gp.line_cd
                            AND gi.intm_no = gisr.intm_no
                            AND gp.line_cd = gisr.line_cd
                            AND gp.iss_cd = gisr.iss_cd
                            AND gp.subline_cd = gisr.subline_cd
                            AND gpe.peril_cd = gisr.peril_cd
                            AND gisr.rate <> gcip.commission_rt
                            AND gl.line_cd = NVL (p_line_cd, gl.line_cd)
                            AND git.intm_type = NVL (p_intm_cd, git.intm_type)
                            AND gi.intm_no =
                                           NVL (p_intermediary_cd, gi.intm_no)
                            AND gpci.intm_no(+) = gisr.intm_no
                            AND (   (    gp.iss_cd =
                                                  NVL (p_branch_cd, gp.iss_cd)
                                     AND p_branch_param = 'ISS_CD'
                                    )
                                 OR (    gp.cred_branch =
                                             NVL (p_branch_cd, gp.cred_branch)
                                     AND p_branch_param = 'CRED_BRANCH'
                                    )
                                )
                            AND (   (    (gp.issue_date BETWEEN p_from AND p_to
                                         )
                                     AND p_date_param = 'ISSUE_DATE'
                                    )
                                 OR (    (gp.eff_date BETWEEN p_from AND p_to
                                         )
                                     AND p_date_param = 'EFF_DATE'
                                    )
                                 OR     ((gp.acct_ent_date BETWEEN p_from AND p_to
                                         )
                                        )
                                    AND p_date_param = 'ACC_ENTDATE'
                                )
                       ORDER BY iss_cd, prem_seq_no ASC)
      LOOP
         mjm := FALSE;
         v_rec.cf_branch :=
                         cf_branch (p_branch_cd, p_branch_param, i.policy_id);
         v_rec.branch := i.branch;
         v_rec.pdate := i.pdate;
         v_rec.line_name := i.line;
         v_rec.intm_type := i.intm_type;
         v_rec.intermediary_name := i.intermediary;
         v_rec.policy_number := i.policy_number;
         v_rec.bill_number := i.bill_number;
         v_rec.iss_cd := i.iss_cd;
         v_rec.prem_seq_no := i.prem_seq_no;
         v_rec.peril_name := i.peril_name;
         v_rec.comm_rate := i.comm_rate;
         v_rec.premium_amt := i.premium_amt;
         v_rec.commission_rate := i.commission_rt; --changed by steven 11.10.2014 
              --cf_commission_rate (i.iss_cd, i.prem_seq_no, p_intermediary_cd);
         v_rec.commission_amt := i.comm_amt - i.pcomm_amt; --changed by steven 11.10.2014 base on RDF
               --cf_commission_amt (i.iss_cd, i.prem_seq_no, p_intermediary_cd);
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_giacr259_record;
END;
/


