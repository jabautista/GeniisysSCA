CREATE OR REPLACE PACKAGE BODY CPI.GICLR271_PKG
AS
/*
    **  Created by   :  Kenneth Mark Labrador
    **  Date Created : 06.04.2013
    **  Reference By : GICLR271_PKG - CLAIM LISTING PER USER
    */
   FUNCTION get_claims_per_user (
      p_in_hou_adj    gicl_claims.in_hou_adj%TYPE,
      p_as_of_date    DATE,
      p_as_of_ldate   DATE,
      p_from_date     DATE,
      p_from_ldate    DATE,
      p_to_date       DATE,
      p_to_ldate      DATE,
      p_as_of_edate   DATE,
      p_from_edate    DATE,
      p_to_edate      DATE,
      p_user_id       VARCHAR2
   )
      RETURN claims_per_user_tab PIPELINED
   IS
      v_detail   claims_per_user_type;
   BEGIN
      FOR i IN (SELECT   a.in_hou_adj, a.assured_name,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0999999'))
                                                                    claim_no,
                         a.dsp_loss_date, a.clm_file_date, b.clm_stat_desc,
                         NVL (a.loss_res_amt, 0) loss_res_amt,
                         NVL (a.exp_res_amt, 0) exp_res_amt,
                         NVL (a.loss_pd_amt, 0) loss_pd_amt,
                         NVL (a.exp_pd_amt, 0) exp_pd_amt, a.entry_date,
                         a.loss_dtls
                    FROM gicl_claims a, giis_clm_stat b
                   WHERE a.clm_stat_cd = b.clm_stat_cd
                     AND a.in_hou_adj = p_in_hou_adj
                      /*Modified by pjsantos 12/1/2016, GENQA 5880*/
                    -- AND check_user_per_line2 (a.line_cd, a.iss_cd, 'GICLS271', p_user_id) = 1  pjs test
                     AND EXISTS (SELECT 'X'
                                 FROM TABLE (security_access.get_branch_line ('CL', 'GICLS271', p_user_id))--pjs test
                                WHERE branch_cd = a.iss_cd AND line_cd = a.line_cd)
                     --pjsantos end
                     AND (   (       TRUNC (a.clm_file_date) >= p_from_date
                                 AND TRUNC (a.clm_file_date) <= p_to_date
                              OR TRUNC (a.clm_file_date) <= p_as_of_date
                             )
                          OR (       TRUNC (a.loss_date) >= p_from_ldate
                                 AND TRUNC (a.loss_date) <= p_to_ldate
                              OR TRUNC (a.loss_date) <= p_as_of_ldate
                             )
                          OR (       TRUNC (a.entry_date) >= p_from_edate
                                 AND TRUNC (a.entry_date) <= p_to_edate
                              OR TRUNC (a.entry_date) <= p_as_of_edate
                             )
                         )
                ORDER BY a.in_hou_adj,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '09')),
                         a.assured_name,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')))
      LOOP
         v_detail.in_hou_adj := i.in_hou_adj;
         v_detail.assured_name := i.assured_name;
         v_detail.policy_no := i.policy_no;
         v_detail.claim_no := i.claim_no;
         v_detail.dsp_loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-RRRR');
         v_detail.clm_file_date := TO_CHAR (i.clm_file_date, 'MM-DD-RRRR');
         v_detail.entry_date := TO_CHAR (i.entry_date, 'MM-DD-RRRR');
         v_detail.clm_stat_desc := i.clm_stat_desc;
         v_detail.loss_dtls := i.loss_dtls;
         v_detail.loss_res_amt := NVL(i.loss_res_amt, 0);
         v_detail.loss_pd_amt := NVL(i.loss_pd_amt, 0);
         v_detail.exp_res_amt := NVL(i.exp_res_amt, 0);
         v_detail.exp_pd_amt := NVL(i.exp_pd_amt, 0);
         v_detail.cf_company := giisp.v ('COMPANY_NAME');
         v_detail.cf_address := giisp.v ('COMPANY_ADDRESS');

         BEGIN
            IF p_as_of_date IS NOT NULL
            THEN
               v_detail.date_type :=
                     'Claim File Date As of '
                  || TO_CHAR (p_as_of_date, 'fmMonth DD, RRRR');
            ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL
            THEN
               v_detail.date_type :=
                     'Claim File Date From '
                  || TO_CHAR (p_from_date, 'fmMonth DD, RRRR')
                  || ' To '
                  || TO_CHAR (p_to_date, 'fmMonth DD, RRRR');
            ELSIF p_as_of_ldate IS NOT NULL
            THEN
               v_detail.date_type :=
                     'Loss Date As of '
                  || TO_CHAR (p_as_of_ldate, 'fmMonth DD, RRRR');
            ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL
            THEN
               v_detail.date_type :=
                     'Loss Date From '
                  || TO_CHAR (p_from_ldate, 'fmMonth DD, RRRR')
                  || ' To '
                  || TO_CHAR (p_to_ldate, 'fmMonth DD, RRRR');
            ELSIF p_as_of_edate IS NOT NULL
            THEN
               v_detail.date_type :=
                     'Entry Date As of '
                  || TO_CHAR (p_as_of_edate, 'fmMonth DD, RRRR');
            ELSIF p_from_edate IS NOT NULL AND p_to_edate IS NOT NULL
            THEN
               v_detail.date_type :=
                     'Entry Date From '
                  || TO_CHAR (p_from_edate, 'fmMonth DD, RRRR')
                  || ' To '
                  || TO_CHAR (p_to_edate, 'fmMonth DD, RRRR');
            END IF;
         END;

         PIPE ROW (v_detail);
      END LOOP;

      RETURN;
   END get_claims_per_user;
END GICLR271_PKG;
/


