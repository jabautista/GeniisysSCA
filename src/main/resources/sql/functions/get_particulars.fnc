DROP FUNCTION CPI.GET_PARTICULARS;

CREATE OR REPLACE FUNCTION CPI.get_particulars(
   p_tran_id            NUMBER,
   p_iss_cd             GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE,
   p_prem_seq_no        GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE
)
  RETURN VARCHAR2
IS
 v_particulars VARCHAR2(500) := '';
 v_pack_pol_flag				gipi_polbasic.pack_pol_flag%TYPE;
 v_package_particulars	   giac_parameters.param_value_v%TYPE := NVL(giacp.v('PACKAGE_PREM_COLLN_PARTICULARS'), 'XX');
 v_or_particulars          giac_parameters.param_value_v%TYPE := GIACP.V('OR_PARTICULARS_TEXT');
 v_pack_pol_id					gipi_polbasic.pack_policy_id%TYPE;
 v_pack_pol_no					VARCHAR2(500);
 v_pack_name				   VARCHAR2(500) := NULL;
BEGIN
/* marco - comment out; replaced with codes below
  FOR i IN (SELECT get_policy_no(policy_id) policy_no, iss_cd, prem_seq_no, policy_id 
              FROM gipi_invoice
                WHERE (iss_cd, prem_seq_no) in (
                           SELECT b140_iss_cd, b140_prem_seq_no
                             FROM giac_direct_prem_collns
                            WHERE gacc_tran_id = p_tran_id))
  LOOP
        
        IF NVL(giacp.v('PREM_COLLN_PARTICULARS'),'PN') = 'PB' THEN
          --mark jm 07.11.2011 commented condition for the length of particulars
          --IF LENGTH(v_particulars) + LENGTH(i.policy_no || '/' || i.iss_cd || '/' || TO_CHAR(i.prem_seq_no,'99999999') || ', ') <= 502 THEN          
            v_particulars := v_particulars ||i.policy_no || '/' || i.iss_cd || '-' || TO_CHAR(i.prem_seq_no,'fm099999999999') || ', ';
          --END IF;
        
        ELSE
         -- mark jm 07.11.2011 commented condition for the length of particulars
         --IF LENGTH (v_particulars || i.policy_no||', ') <= 501 THEN          
            v_particulars := v_particulars ||i.policy_no ||', ';
         --END IF;
        END IF;

  END LOOP;
  
  IF GIACP.V('OR_PARTICULARS_TEXT') IS NOT NULL THEN
    RETURN GIACP.V('OR_PARTICULARS_TEXT')||' '||v_particulars;
  ELSE 
    RETURN v_particulars;
  END IF; */

   BEGIN
      SELECT DISTINCT a.pack_pol_flag
        INTO v_pack_pol_flag
        FROM gipi_polbasic a, gipi_invoice b
       WHERE a.policy_id = b.policy_id
         AND b.iss_cd = p_iss_cd
         AND b.prem_seq_no = p_prem_seq_no;
   EXCEPTION
      WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
         v_pack_pol_flag := NULL;
   END;
   
   IF v_package_particulars <> 'XX' AND v_pack_pol_flag = 'Y' THEN
      BEGIN
         SELECT a.line_cd
             || '-'
             || a.subline_cd
             || '-'
             || a.iss_cd
             || '-'
             || LTRIM (TO_CHAR (a.issue_yy, '09'))
             || '-'
             || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
             || '-'
             || LTRIM (TO_CHAR (a.renew_no, '09'))
             || DECODE (
                   NVL (a.endt_seq_no, 0),
                   0, '',
                      ' / '
                   || a.endt_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.endt_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.endt_seq_no, '9999999'))
                ) pack_pol_no, a.pack_policy_id
           INTO v_pack_pol_no, v_pack_pol_id
           FROM gipi_pack_polbasic a, gipi_polbasic b, gipi_invoice c
          WHERE a.pack_policy_id = b.pack_policy_id
            AND b.policy_id = c.policy_id
            AND c.iss_cd = p_iss_cd
            AND c.prem_seq_no = p_prem_seq_no;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
            v_pack_pol_no := NULL;
            v_pack_pol_id := NULL;
      END;
      
      IF NVL(v_particulars, 'XX') NOT LIKE '%'||v_pack_pol_no||'%' THEN
         IF v_package_particulars = 'PK' THEN
            v_particulars := v_particulars||v_pack_pol_no||', ';
         ELSE
            v_pack_name := v_pack_pol_no||'(';
					
            FOR pack IN (	SELECT    a.line_cd
                                  || '-'
                                  || a.subline_cd
                                  || '-'
                                  || a.iss_cd
                                  || '-'
                                  || LTRIM (TO_CHAR (a.issue_yy, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                                  || '-'
                                  || LTRIM (TO_CHAR (a.renew_no, '09'))
                                  || DECODE (
                                        NVL (a.endt_seq_no, 0),
                                        0, '',
                                           ' / '
                                        || a.endt_iss_cd
                                        || '-'
                                        || LTRIM (TO_CHAR (a.endt_yy, '09'))
                                        || '-'
                                        || LTRIM (TO_CHAR (a.endt_seq_no, '0999999'))
                                     ) policy_no, b.iss_cd||'-'||TO_CHAR(b.prem_seq_no, 'FM099999999999') bill_no 
                                   FROM gipi_polbasic a, gipi_invoice b
                                  WHERE a.policy_id = b.policy_id
                                    AND EXISTS (SELECT 'X'
                                                  FROM giac_direct_prem_collns x
                                                 WHERE x.b140_iss_cd = b.iss_cd
                                                   AND x.b140_prem_seq_no = b.prem_seq_no)
                                    AND a.pack_policy_id = v_pack_pol_id)
            LOOP
               IF v_package_particulars = 'KS' THEN
                  v_pack_name := v_pack_name||pack.policy_no||', ';
               ELSIF v_package_particulars = 'KN' THEN
                  v_pack_name := v_pack_name||pack.policy_no||'/'||pack.bill_no||', ';
               ELSIF v_package_particulars = 'KB' THEN
                  v_pack_name := v_pack_name||pack.bill_no||', ';
               END IF;
            END LOOP;
            
            v_pack_name := rtrim(ltrim(substr(v_pack_name, 1, length(rtrim(v_pack_name))-1)))||')';
            v_particulars := v_particulars||v_pack_name||', ';
         END IF;
      END IF;
   END IF;
   
   FOR i IN (SELECT get_policy_no(policy_id) policy_no, iss_cd, prem_seq_no, policy_id 
               FROM gipi_invoice
              WHERE (iss_cd, prem_seq_no) in (SELECT b140_iss_cd, b140_prem_seq_no
                                                FROM giac_direct_prem_collns
                                               WHERE gacc_tran_id = p_tran_id))
   LOOP
      IF NVL(giacp.v('PREM_COLLN_PARTICULARS'),'PN') = 'PB' AND (v_pack_pol_flag = 'N' OR (v_pack_pol_flag = 'Y' AND v_package_particulars = 'XX')) THEN          
         v_particulars := v_particulars ||i.policy_no || '/' || i.iss_cd || '-' || TO_CHAR(i.prem_seq_no,'fm099999999999') || ', ';
      ELSIF NVL(giacp.v('PREM_COLLN_PARTICULARS'),'PN') = 'PN' AND (v_pack_pol_flag = 'N' OR (v_pack_pol_flag = 'Y' AND v_package_particulars = 'XX')) THEN
         v_particulars := v_particulars ||i.policy_no ||', ';
      END IF;
   END LOOP; 
     
   IF v_or_particulars IS NOT NULL THEN
      RETURN v_or_particulars||' '||v_particulars;
   ELSE 
      RETURN v_particulars;
   END IF;
END;
/


