CREATE OR REPLACE PACKAGE BODY CPI.gicls170_pkg
AS
/*
**  Created by   : Ildefonso Ellarina
**  Date Created : 8.27.2013
**  Reference By    : (GICLS170 - Table Maintenance Claim Status Reasons)
**  Description  : Populate Claim Status Reasons List
*/
   FUNCTION show_clm_stat_reasons
      RETURN clm_stat_reasons_tab PIPELINED
   IS
      v_list   clm_stat_reasons_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_reasons)
      LOOP
         v_list.clm_stat_desc := NULL;
         v_list.reason_cd := i.reason_cd;
         v_list.reason_desc := i.reason_desc;
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-RRRR HH:MI:SS AM');

         FOR j IN (SELECT clm_stat_desc
                     FROM giis_clm_stat
                    WHERE clm_stat_cd = i.clm_stat_cd)
         LOOP
            v_list.clm_stat_desc := j.clm_stat_desc;
            EXIT;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END show_clm_stat_reasons;

   FUNCTION get_clm_stat_reasons_lov
      RETURN clm_stat_reasons_lov_tab PIPELINED
   IS
      v_list   clm_stat_reasons_lov_type;
   BEGIN
      FOR i IN (SELECT clm_stat_cd, clm_stat_desc, clm_stat_type
                  FROM giis_clm_stat)
      LOOP
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.clm_stat_desc := i.clm_stat_desc;
         v_list.clm_stat_type := i.clm_stat_type;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_clm_stat_reasons_lov;

   FUNCTION validate_reasons_input (
      p_txt_field      VARCHAR2,
      p_input_string   VARCHAR2,
      p_reason_cd      VARCHAR2,
      p_clm_stat_cd    VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_result        VARCHAR2 (500)                  := 'TRUE';
      v_reason        gicl_claims.reason_cd%TYPE      := NULL;
      v_code          gicl_reasons.reason_cd%TYPE;
      v_desc          gicl_reasons.reason_desc%TYPE;
      v_clm_stat_cd   gicl_reasons.clm_stat_cd%TYPE;
      v_remarks       gicl_reasons.remarks%TYPE;
   BEGIN
      IF p_txt_field = 'Code'
      THEN
         BEGIN
            BEGIN
               SELECT reason_cd
                 INTO v_reason
                 FROM gicl_claims
                WHERE reason_cd = p_reason_cd AND clm_stat_cd = p_clm_stat_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_reason := NULL;
               WHEN TOO_MANY_ROWS
               THEN
                  v_reason := '1';
            END;

            BEGIN
               SELECT reason_cd
                 INTO v_code
                 FROM gicl_reasons
                WHERE reason_cd = p_input_string;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_clm_stat_cd := NULL;
            END;

            IF v_reason IS NOT NULL
            THEN
               v_result :=
                  'Cannot update record. Reason is currently being used by a record in Claims.';
            ELSIF v_code IS NOT NULL
            THEN
               v_result :=
                  'Reason code already exists. Please enter another reason code.';
            END IF;
         END;
      ELSIF p_txt_field = 'Description'
      THEN
         BEGIN
            BEGIN
               SELECT reason_cd
                 INTO v_reason
                 FROM gicl_claims
                WHERE reason_cd = p_reason_cd AND clm_stat_cd = p_clm_stat_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_reason := NULL;
               WHEN TOO_MANY_ROWS
               THEN
                  v_reason := '1';
            END;

            IF v_reason IS NOT NULL
            THEN
               v_result :=
                  'Cannot update record. Reason is currently being used by a record in Claims.';
            END IF;
         END;
      ELSIF p_txt_field = 'Claim Status'
      THEN
         BEGIN
            BEGIN
               SELECT reason_cd
                 INTO v_reason
                 FROM gicl_claims
                WHERE reason_cd = p_reason_cd AND clm_stat_cd = p_clm_stat_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_reason := NULL;
               WHEN TOO_MANY_ROWS
               THEN
                  v_reason := '1';
            END;

            BEGIN
               SELECT clm_stat_cd
                 INTO v_clm_stat_cd
                 FROM gicl_reasons
                WHERE reason_cd = p_reason_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_clm_stat_cd := NULL;
            END;

            IF v_reason IS NOT NULL
            THEN
               v_result :=
                  'Cannot update record. Reason is currently being used by a record in Claims.';
            END IF;
         END;
      ELSIF p_txt_field = 'Remarks'
      THEN
         BEGIN
            BEGIN
               SELECT reason_cd
                 INTO v_reason
                 FROM gicl_claims
                WHERE reason_cd = p_reason_cd AND clm_stat_cd = p_clm_stat_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_reason := NULL;
               WHEN TOO_MANY_ROWS
               THEN
                  v_reason := '1';
            END;

            IF v_reason IS NOT NULL
            THEN
               v_result :=
                  'Cannot update record. Reason is currently being used by a record in Claims.';
            END IF;
         END;
      ELSIF p_txt_field = 'Update'
      THEN
         BEGIN
            BEGIN
               SELECT reason_cd
                 INTO v_reason
                 FROM gicl_claims
                WHERE reason_cd = p_reason_cd AND clm_stat_cd = p_clm_stat_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_reason := NULL;
               WHEN TOO_MANY_ROWS
               THEN
                  v_reason := '1';
            END;

            IF v_reason IS NOT NULL
            THEN
               v_result :=
                  'Cannot update record. Reason is currently being used by a record in Claims.';
            END IF;
         END;
      ELSIF p_txt_field = 'Delete'
      THEN
         BEGIN
            BEGIN
               SELECT reason_cd
                 INTO v_reason
                 FROM gicl_claims
                WHERE reason_cd = p_reason_cd AND clm_stat_cd = p_clm_stat_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_reason := NULL;
               WHEN TOO_MANY_ROWS
               THEN
                  v_reason := '1';
            END;

            IF v_reason IS NOT NULL
            THEN
               v_result :=
                  'Cannot delete record. Reason is currently being used by a record in Claims.';
            END IF;
         END;
      END IF;

      RETURN v_result;
   END validate_reasons_input;

       /*
   **  Created by       :Fons Ellarina
   **  Date Created    : 08.29.2013
   **  Reference By    : (GICLS170 - Table Maintenance - Claim Status Reasons)
   **  Description     : Insert or update record in gicl_reasons
   */
   PROCEDURE set_clm_stat_reasons (
      p_reason_cd     gicl_reasons.reason_cd%TYPE,
      p_reason_desc   gicl_reasons.reason_desc%TYPE,
      p_clm_stat_cd   gicl_reasons.clm_stat_cd%TYPE,
      p_remarks       gicl_reasons.remarks%TYPE
   )
   IS
   BEGIN
      MERGE INTO gicl_reasons
         USING DUAL
         ON (reason_cd = p_reason_cd)
         WHEN NOT MATCHED THEN
            INSERT (reason_cd, reason_desc, clm_stat_cd, remarks)
            VALUES (p_reason_cd, p_reason_desc, p_clm_stat_cd, p_remarks)
         WHEN MATCHED THEN
            UPDATE
               SET reason_desc = p_reason_desc, clm_stat_cd = p_clm_stat_cd,
                   remarks = p_remarks
            ;
   END set_clm_stat_reasons;

       /*
   **  Created by       :Fons Ellarina
   **  Date Created    : 08.29.2013
   **  Reference By    : (GICLS170 - Table Maintenance - Claim Status Reasons)
   **  Description     : Delete record in gicl_reasons
   */
   PROCEDURE delete_in_clm_stat_reasons (
      p_reason_cd   gicl_reasons.reason_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM gicl_reasons
            WHERE reason_cd = p_reason_cd;
   END delete_in_clm_stat_reasons;
END gicls170_pkg;
/


