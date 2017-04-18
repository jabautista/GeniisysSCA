DROP PROCEDURE CPI.CHECK_EXISTING_CLAIM;

CREATE OR REPLACE PROCEDURE CPI.check_existing_claim(p_line_cd         IN   gicl_claims.line_cd%TYPE,
                                                     p_subline_cd      IN   gicl_claims.subline_cd%TYPE,
                                                     p_iss_cd          IN   gicl_claims.iss_cd%TYPE,
                                                     p_issue_yy        IN   gicl_claims.issue_yy%TYPE,
                                                     p_pol_seq_no      IN   gicl_claims.pol_seq_no%TYPE,
                                                     p_renew_no        IN   gicl_claims.renew_no%TYPE,
                                                     p_eff_date        IN   gipi_polbasic_pol_dist_v.eff_date%TYPE,
                                                     p_dsp_endt_seq_no IN   gipi_polbasic_pol_dist_v.endt_seq_no%TYPE,
                                                     p_msg             OUT  VARCHAR2)
IS
  /*
  **  Created by   : Robert John Virrey
  **  Date Created : August 4, 2011
  **  Reference By : (GIUTS002 - Distribution Negation)
  **  Description  : Check if there are 
  **                 existing claim(s) for the policy  and if the loss date
  **                 of the claim is later or equal to policy/endt effectivity date
  */
  
   -- modified by J. Diago 09.15.2014 - Added conditions for new parameter RESTRICT_NEG_OF_BNDR_WCLAIM
   v_restrict_param   VARCHAR2(1);
BEGIN
   SELECT NVL(param_value_v,'Y')
     INTO v_restrict_param
     FROM giis_parameters
    WHERE param_name = 'RESTRICT_NEG_OF_BNDR_WCLAIM';

   FOR A1 IN (
           SELECT   claim_id
             FROM   gicl_claims
            WHERE   line_cd     = p_line_cd
              AND   subline_cd  = p_subline_cd
              AND   pol_iss_cd  = p_iss_cd
              AND   issue_yy    = p_issue_yy
              AND   pol_seq_no  = p_pol_seq_no
              AND   renew_no    = p_renew_no
              AND   clm_stat_cd NOT IN ('CC','DN','WD') --removed CD by J. Diago 09.16.2014
              AND   loss_date  >= p_eff_date)          
     LOOP
           /*IF NVL(p_dsp_endt_seq_no,0) = 0 THEN
              p_msg := 'This policy has an existing claim(s), please inform the Claims Department before negating this distribution. Do you want to continue?';
           ELSE
              p_msg := 'The policy for this endt. has an existing claim(s), please inform the Claims Department before negating this distribution. Do you want to continue?';
           END IF;*/
       IF v_restrict_param = 'N' THEN
          p_msg := 'Allow';
       ELSIF v_restrict_param = 'O' THEN
          p_msg := 'Override';
       ELSE
          p_msg := 'Restrict';
       END IF;
       
       IF NVL(p_dsp_endt_seq_no,0) = 0 THEN
          p_msg := p_msg||'-W/O Endorsement';
       ELSE
          p_msg := p_msg||'-W Endorsement';
       END IF;
       
       EXIT;  
     END LOOP;

END;
/


