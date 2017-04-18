DROP PROCEDURE CPI.GICLS032_GET_INTM_TYPE;

CREATE OR REPLACE PROCEDURE CPI.gicls032_get_intm_type (
  p_claim_id           gicl_claims.claim_id%TYPE,
  p_ri_iss_cd          giac_parameters.param_value_v%TYPE,
  p_acct_intm_cd OUT NUMBER)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - get_intm_type
   */
   
   v_share_percentage    gipi_comm_invoice.share_percentage%TYPE;
   v_intm_no             gipi_comm_invoice.intrmdry_intm_no%TYPE;
   v_parent_intm_no      giis_intermediary.parent_intm_no%TYPE;
   v_intm_type           giis_intm_type.intm_type%TYPE;
   v_acct_intm_cd        giis_intm_type.acct_intm_cd%TYPE;
   v_lic_tag             giis_intermediary.lic_tag%TYPE;
   var_lic_tag           giis_intermediary.lic_tag%TYPE            := 'N';
   var_intm_type         giis_intm_type.intm_type%TYPE;
   var_intm_no           gipi_comm_invoice.intrmdry_intm_no%TYPE;
   var_parent_intm_no    giis_intermediary.parent_intm_no%TYPE;
   gici_parent_intm_no   gipi_comm_invoice.parent_intm_no%TYPE;
   v_dummy               VARCHAR2 (1);
   v_policy_id           VARCHAR2 (2000)                           := NULL;
   v_pol_iss_cd          gicl_claims.pol_iss_cd%TYPE;
   v_module_name         VARCHAR2(100);
BEGIN 
  SELECT pol_iss_cd
    INTO v_pol_iss_cd
    FROM gicl_claims
   WHERE claim_id = p_claim_id;
   
  IF v_pol_iss_cd = p_ri_iss_cd THEN
     v_module_name := 'GIACS018';
  ELSE
     v_module_name := 'GIACS017';
  END IF;        

   BEGIN
      SELECT DISTINCT 'x'
                 INTO v_dummy
                 FROM giac_module_entries a
                WHERE intm_type_level IS NOT NULL
                  AND EXISTS (SELECT b.module_id
                                FROM giac_modules b
                               WHERE b.module_id = a.module_id AND b.module_name LIKE v_module_name);

      IF v_dummy IS NOT NULL
      THEN
         FOR rec IN (SELECT DISTINCT b.policy_id
                                FROM gicl_claims a, gipi_polbasic b
                               WHERE a.line_cd = b.line_cd
                                 AND a.subline_cd = b.subline_cd
                                 AND a.issue_yy = b.issue_yy
                                 AND a.pol_seq_no = b.pol_seq_no
                                 AND a.renew_no = b.renew_no
                                 AND a.claim_id = p_claim_id)
         LOOP
            IF v_policy_id IS NULL
            THEN
               v_policy_id := ',' || TO_CHAR (rec.policy_id) || ',';
            ELSIF v_policy_id IS NOT NULL
            THEN
               v_policy_id := v_policy_id || ',' || TO_CHAR (rec.policy_id) || ',';
            END IF;
         END LOOP;

         BEGIN
            FOR rec2 IN (SELECT DISTINCT parent_intm_no parent_intm_no
                                    FROM gipi_comm_invoice
                                   WHERE INSTR (v_policy_id, (',' || TO_CHAR (policy_id) || ','), 1) <> 0)
            LOOP
               IF v_parent_intm_no IS NULL
               THEN
                  v_parent_intm_no := rec2.parent_intm_no;
               ELSIF v_parent_intm_no IS NOT NULL
               THEN
                  IF v_parent_intm_no > rec2.parent_intm_no
                  THEN
                     v_parent_intm_no := rec2.parent_intm_no;
                  END IF;
               END IF;

               gici_parent_intm_no := 1;
            END LOOP;

            IF gici_parent_intm_no IS NOT NULL
            THEN
               BEGIN
                  SELECT a.intm_type, b.acct_intm_cd
                    INTO v_intm_type, v_acct_intm_cd
                    FROM giis_intermediary a, giis_intm_type b
                   WHERE a.intm_type = b.intm_type AND a.intm_no = v_parent_intm_no;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     raise_application_error(-20001, 'Geniisys Exception#I#Intermediary No. ' || TO_CHAR (gici_parent_intm_no) || ' does not exist in master file.');
               END;
            ELSIF gici_parent_intm_no IS NULL
            THEN

               BEGIN
                  SELECT MAX (share_percentage)
                    INTO v_share_percentage
                    FROM gipi_comm_invoice
                   WHERE policy_id IN (v_policy_id);

                  IF v_share_percentage IS NOT NULL
                  THEN
                     BEGIN
                        SELECT MIN (intrmdry_intm_no)
                          INTO v_intm_no
                          FROM gipi_comm_invoice
                         WHERE share_percentage = v_share_percentage AND policy_id IN (v_policy_id);
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           NULL;
                     END;
                  ELSE
                     NULL;
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     NULL;
               END;

               BEGIN
                  SELECT parent_intm_no, intm_type, NVL (lic_tag, 'N')
                    INTO v_parent_intm_no, v_intm_type, v_lic_tag
                    FROM giis_intermediary
                   WHERE intm_no = v_intm_no;

                  IF v_lic_tag = 'Y'
                  THEN
                     v_parent_intm_no := v_intm_no;
                  ELSIF v_lic_tag = 'N'
                  THEN
                     IF v_parent_intm_no IS NULL
                     THEN
                        v_parent_intm_no := v_intm_no;
                     ELSE                                                      -- check for the nearest licensed parent intm no --
                        var_lic_tag := v_lic_tag;

                        WHILE var_lic_tag = 'N' AND v_parent_intm_no IS NOT NULL
                        LOOP
                           BEGIN
                              SELECT intm_no, parent_intm_no, intm_type, lic_tag
                                INTO var_intm_no, var_parent_intm_no, var_intm_type, var_lic_tag
                                FROM giis_intermediary
                               WHERE intm_no = v_parent_intm_no;

                              v_parent_intm_no := var_parent_intm_no;
                              v_intm_type := var_intm_type;
                              v_lic_tag := var_lic_tag;

                              IF var_parent_intm_no IS NULL
                              THEN
                                 v_parent_intm_no := var_intm_no;
                                 EXIT;
                              ELSE
                                 var_lic_tag := 'N';
                              END IF;
                           EXCEPTION
                              WHEN NO_DATA_FOUND
                              THEN
                                 NULL;
                                 v_parent_intm_no := var_intm_no;
                                 EXIT;
                           END;
                        END LOOP;
                     END IF;                                                                    --if v_parent_intm_no is null then
                  END IF;                                                                               --if v_lic_tag  = 'Y' then

                  BEGIN
                     SELECT acct_intm_cd
                       INTO v_acct_intm_cd
                       FROM giis_intm_type
                      WHERE intm_type = v_intm_type;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        NULL;
                  END;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     NULL;
               END;
            END IF;                                                                          --if gici_parent_intm_no is null then
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   p_acct_intm_cd := v_acct_intm_cd;
END;
/


