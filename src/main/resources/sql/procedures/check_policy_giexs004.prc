DROP PROCEDURE CPI.CHECK_POLICY_GIEXS004;

CREATE OR REPLACE PROCEDURE CPI.check_policy_giexs004(
    p_dsp_policy_id     OUT gipi_polbasic.policy_id%TYPE,
    p_dsp_line_cd2      IN  gipi_polbasic.line_cd%TYPE,
    p_dsp_subline_cd2   IN  gipi_polbasic.subline_cd%TYPE,
    p_dsp_iss_cd2       IN  gipi_polbasic.iss_cd%TYPE,
    p_dsp_issue_yy2     IN  gipi_polbasic.issue_yy%TYPE,
    p_dsp_pol_seq_no2   IN  gipi_polbasic.pol_seq_no%TYPE,
    p_dsp_renew_no2     IN  gipi_polbasic.renew_no%TYPE,
    p_msg               OUT VARCHAR2,
    p_user              IN  giex_expiry.extract_user%TYPE,
    p_all_user          IN  VARCHAR2,
    p_allow_renewal_other_user IN VARCHAR2 -- Added by Jerome Bautista 03.14.2016 SR 21944
)
IS
  v_pol_flag    gipi_wpolbas.pol_flag%TYPE;
  v_expiry      gipi_wpolbas.expiry_date%TYPE;
  v_sw          VARCHAR2(1);
  v_user        giex_expiry.extract_user%TYPE;
  v_post        giex_expiry.post_flag%TYPE;
  v_checker     varchar2(3):='yes';
  v_all_user    VARCHAR2(1):= 'N'; --added by joanne 06.25.14, default all_user_sw is N
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 09-26-2011
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
  **  Description  : check_policy program unit; check if policy is valid according to the allowed conditions
  **                which are determined by the options that are checked
  */
  p_dsp_policy_id := null;
  BEGIN
      SELECT pol_flag, policy_id
        INTO v_pol_flag, p_dsp_policy_id
        FROM gipi_polbasic
       WHERE line_cd     = p_dsp_line_cd2
         AND subline_cd  = p_dsp_subline_cd2
         AND iss_cd      = p_dsp_iss_cd2
         AND issue_yy    = p_dsp_issue_yy2
         AND pol_seq_no  = p_dsp_pol_seq_no2
         AND renew_no    = p_dsp_renew_no2
         AND NVL(endt_seq_no, 0) = 0;
         v_checker := 'pol';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
    v_checker := 'non';
    END;
    IF v_checker = 'non' THEN
        BEGIN
          SELECT pol_flag, pack_policy_id policy_id
            INTO v_pol_flag, p_dsp_policy_id
            FROM gipi_pack_polbasic
           WHERE line_cd     = p_dsp_line_cd2
             AND subline_cd  = p_dsp_subline_cd2
             AND iss_cd      = p_dsp_iss_cd2
             AND issue_yy    = p_dsp_issue_yy2
             AND pol_seq_no  = p_dsp_pol_seq_no2
             AND renew_no    = p_dsp_renew_no2
             AND NVL(endt_seq_no, 0) = 0;
             v_checker := 'pck';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
        v_checker := 'non';
        END;
    END IF;
    IF v_checker = 'non' THEN
        p_dsp_policy_id := null;
        p_msg := 'Policy does not exist...';
        RETURN;
    END IF;

  IF v_pol_flag = '5' THEN
    p_dsp_policy_id := null;
    p_msg := 'This policy is already spoiled, policy that is already spoiled cannot be process in expiry module.';
    RETURN;
  ELSIF v_pol_flag = '4' THEN
    p_dsp_policy_id := null;
    p_msg := 'This policy is already cancelled, cancelled policy cannot be process in expiry module.';
    RETURN;
  END IF;
  v_sw := 'N';
  IF v_checker = 'pol' THEN
      FOR A IN (SELECT extract_user, post_flag
                  FROM giex_expiry
                 WHERE policy_id = p_dsp_policy_id)
      LOOP
        v_user    := a.extract_user;
        v_post    := a.post_flag;
        v_sw      := 'Y';
      END LOOP;
    ELSIF v_checker = 'pck' THEN
      FOR A IN (SELECT extract_user, post_flag
                  FROM giex_pack_expiry
                 WHERE pack_policy_id = p_dsp_policy_id)
      LOOP
        v_user    := a.extract_user;
        v_post    := a.post_flag;
        v_sw      := 'Y';
      END LOOP;
    END IF;
  IF v_sw = 'N' THEN
     p_dsp_policy_id := NULL;
     p_msg := 'Policy is not yet process for expiry.';
     RETURN;
  END IF;
  IF v_post = 'Y' THEN
     p_dsp_policy_id := NULL;
     p_msg:= 'Policy had already been process for expiration.';
     RETURN;
  END IF;
  --IF p_all_user = 'N' THEN joanne 06.25.14
  IF p_all_user = 'N' OR NVL(p_allow_renewal_other_user,'N') = 'N' THEN -- Modified by Jerome Bautista 03.14.2016 SR 21944
      IF v_user <>  p_user THEN
         p_dsp_policy_id := NULL;
         p_msg := 'This policy had been extracted by other user.';
         RETURN;
      END IF;
    END IF;
  /*p_claim_sw         := NULL;
  p_balance_sw       := NULL;
  p_fm_mon           := NULL;
  p_fm_year          := NULL;
  p_to_mon           := NULL;
  p_to_year          := NULL;
  p_fm_date          := NULL;
  p_to_date          := NULL;*/
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    p_dsp_policy_id := null;
    p_msg := 'Policy does not exist...';
END check_policy_giexs004;
/


