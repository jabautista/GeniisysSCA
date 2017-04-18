DROP PROCEDURE CPI.CHECK_EXPIRED_TREATY;

CREATE OR REPLACE PROCEDURE CPI.CHECK_EXPIRED_TREATY(
   p_policy_id                GIPI_POLBASIC.policy_id%TYPE,
   p_line_cd                  GIUW_WPERILDS_DTL.line_cd%TYPE,
   p_share_cd                 GIUW_WPERILDS_DTL.share_cd%TYPE,
   p_peril_cd                 GIUW_WPERILDS_DTL.peril_cd%TYPE,
   p_dist_seq_no              GIUW_WPERILDS_DTL.dist_seq_no%TYPE
)
AS
   v_peril_name               GIIS_PERIL.peril_name%TYPE;
   v_trty_name                GIIS_DIST_SHARE.trty_name%TYPE;
   v_share_type               GIIS_DIST_SHARE.share_type%TYPE;
   v_expired                  VARCHAR2(1) := 'Y';
BEGIN
   BEGIN
      SELECT trty_name, share_type
        INTO v_trty_name, v_share_type
        FROM GIIS_DIST_SHARE
       WHERE line_cd = p_line_cd
         AND share_cd = p_share_cd;
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;

   FOR i IN (SELECT a.trty_cd, a.trty_name, a.trty_yy, a.line_cd, a.share_cd,
                    a.share_type, a.eff_date, a.expiry_date
               FROM GIIS_DIST_SHARE a,
                    GIPI_POLBASIC b
              WHERE a.line_cd = p_line_cd
                AND a.share_cd = p_share_cd
                AND a.share_type = '2'
                AND b.policy_id = p_policy_id
                AND TRUNC(DECODE(NVL (prtfolio_sw, 'N'), 'N',b.incept_date, 'P',b.eff_date)) BETWEEN TRUNC(a.eff_date) AND TRUNC(a.expiry_date))
   LOOP
      v_expired := 'N';
   END LOOP;
   
   IF v_share_type <> '2' THEN
      v_expired := 'N';
   END IF;
   
   IF v_expired = 'Y' THEN
      BEGIN
         SELECT peril_name
           INTO v_peril_name
           FROM GIIS_PERIL
          WHERE line_cd = p_line_cd
            AND peril_cd = p_peril_cd;
      EXCEPTION
         WHEN OTHERS THEN
            v_peril_name := NULL;
      END;
   
      raise_application_error(-20001, 'Geniisys Exception#I#Treaty ' || v_trty_name || ' in group no. ' || p_dist_seq_no || ' under peril ' || v_peril_name
                                       || ' is already expired. Replace the treaty with another one.');
   END IF;
END;
/


