CREATE OR REPLACE PACKAGE BODY CPI.giis060_pkg
AS
   /*
   **  Created by      : Halley Pates
   **  Date Created    : 11.14.2012
   **  Reference By    : (GIIS060 - Distribution Share Maintenance)
   **  Description     : XOL List for Non Propotional Treaty
   */
   FUNCTION get_xol_list (p_line_cd giis_line.line_cd%TYPE)
      RETURN giis_xol_type_tab PIPELINED
   IS
      v_list   giis_xol_type;
   BEGIN
      FOR i IN (SELECT   xol_id, line_cd, xol_yy, xol_seq_no, xol_trty_name,
                         user_id, last_update, remarks
                    FROM giis_xol
                   WHERE line_cd = p_line_cd
                ORDER BY xol_seq_no)
      LOOP
         v_list.xol_id := i.xol_id;
         v_list.line_cd := i.line_cd;
         v_list.xol_yy := i.xol_yy;
         v_list.xol_seq_no := i.xol_seq_no;
         v_list.xol_trty_name := i.xol_trty_name;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_list.remarks := i.remarks;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_xol_list;

   /* Created by    :  Halley Pates
   ** Date Created  :  November 14, 2012
   ** Reference By  : (GIIS060 -  Distribution Share Maintenance)
   ** Description   : XOL List based on line_cd
   **/
   PROCEDURE chk_xol_exists (
      p_line_cd      IN       giis_line.line_cd%TYPE,
      p_xol_id       IN       giis_xol.xol_id%TYPE,
      p_xol_seq_no   IN       giis_xol.xol_seq_no%TYPE,
      p_exists       OUT      VARCHAR2
   )
   IS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_exists
           FROM giis_xol
          WHERE line_cd = p_line_cd
            AND xol_id = p_xol_id
            AND xol_seq_no = p_xol_seq_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exists := 'N';
      END;

      p_exists := v_exists;
   END chk_xol_exists;

   /* Created by    :  Halley Pates
   ** Date Created  :  November 16, 2012
   ** Reference By  : (GIIS060 - Distribution Share Maintenance)
   ** Description   : Checks if XOL exists
   **/
   PROCEDURE set_giis060_xol (
      p_line_cd         IN       giis_xol.line_cd%TYPE,
      p_xol_id          IN       giis_xol.xol_id%TYPE,
      p_xol_seq_no      IN OUT   giis_xol.xol_seq_no%TYPE,
      p_xol_trty_name   IN       giis_xol.xol_trty_name%TYPE,
      p_xol_yy          IN       giis_xol.xol_yy%TYPE,
      p_user_id         IN       giis_xol.user_id%TYPE,
      p_remarks         IN       giis_xol.remarks%TYPE
   )
   IS
      v_seq_no   giis_xol.xol_seq_no%TYPE := 1;
      v_xol_id   giis_xol.xol_id%TYPE;
   BEGIN
      BEGIN
         SELECT giis_xol_id_seq.NEXTVAL
           INTO v_xol_id
           FROM DUAL;
      END;

      BEGIN
         FOR a IN (SELECT MAX (xol_seq_no) seq_no
                     FROM giis_xol
                    WHERE line_cd = p_line_cd)
         LOOP
            v_seq_no := a.seq_no;
            EXIT;
         END LOOP;

  /*       IF v_seq_no IS NULL
         THEN
            p_xol_seq_no := 1;
         ELSE
            p_xol_seq_no := v_seq_no + 1;
         END IF;  */
      END;

      MERGE INTO giis_xol
         USING DUAL
         ON (    line_cd = p_line_cd
             AND xol_id = p_xol_id
             AND xol_seq_no = p_xol_seq_no)
         WHEN NOT MATCHED THEN
            INSERT (xol_id, line_cd, xol_yy, xol_seq_no, xol_trty_name,
                    user_id, last_update, remarks)
            VALUES (v_xol_id, p_line_cd, p_xol_yy,  decode(v_seq_no, NULL, 1, v_seq_no+1),
                    p_xol_trty_name, p_user_id, SYSDATE, p_remarks)
         WHEN MATCHED THEN
            UPDATE
               SET xol_trty_name = p_xol_trty_name, 
                   user_id = p_user_id,
                   last_update = SYSDATE,
                   remarks = p_remarks
            ;
   END set_giis060_xol;

   /* Created by     :  Halley Pates
    ** Date Created  :  November 16, 2012
    ** Reference By  : (GIIS060 - Distribution Share Maintenance)
    ** Description   :  XOL insert and update for GIIS060
    **/
   FUNCTION validate_add_xol (
      p_line_cd         IN   giis_line.line_cd%TYPE,
      p_xol_seq_no      IN   giis_xol.xol_seq_no%TYPE,
      p_xol_trty_name   IN   giis_xol.xol_trty_name%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exists   VARCHAR2 (2);
   BEGIN
      BEGIN
         SELECT DISTINCT 'X'
                    INTO v_exists
                    FROM giis_xol
                   WHERE line_cd = p_line_cd
                     AND xol_trty_name = p_xol_trty_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exists := 'N';
      END;

      IF v_exists = 'N'
      THEN
         IF UPPER (p_xol_trty_name) LIKE '%FACULTATIVE%'
         THEN
            v_exists := 'F';
         ELSIF UPPER (p_xol_trty_name) LIKE '%NET RETENTION%'
         THEN
            v_exists := 'NR';
         END IF;
      END IF;

      RETURN v_exists;
   END validate_add_xol;

   /* Created by     :  Halley Pates
    ** Date Created  :  November 16, 2012
    ** Reference By  : (GIIS060 - Distribution Share Maintenance)
    ** Description   :  Validates that addition of xol_trty_name is unique
    **/
   FUNCTION validate_update_xol (
      p_line_cd         IN   giis_line.line_cd%TYPE,
      p_xol_seq_no      IN   giis_xol.xol_seq_no%TYPE,
      p_xol_trty_name   IN   giis_xol.xol_trty_name%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exists   VARCHAR2 (2);
   BEGIN
      BEGIN
         SELECT DISTINCT 'Y'
                    INTO v_exists
                    FROM giis_xol
                   WHERE line_cd = p_line_cd
                     AND xol_seq_no = p_xol_seq_no
                     AND xol_trty_name = p_xol_trty_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exists := 'N';
      END;

      IF v_exists = 'N'
      THEN
         BEGIN
            SELECT DISTINCT 'X'
                       INTO v_exists
                       FROM giis_xol
                      WHERE line_cd = p_line_cd
                        AND xol_trty_name = p_xol_trty_name;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exists := 'N';
         END;
      END IF;

      IF v_exists IN ('N', 'X', 'Y')
      THEN
         IF UPPER (p_xol_trty_name) LIKE '%FACULTATIVE%'
         THEN
            v_exists := 'F';
         ELSIF UPPER (p_xol_trty_name) LIKE '%NET RETENTION%'
         THEN
            v_exists := 'NR';
         END IF;
      END IF;

      RETURN v_exists;
   END validate_update_xol;

   /* Created by     :  Halley Pates
    ** Date Created  :  November 16, 2012
    ** Reference By  : (GIIS060 - Distribution Share Maintenance)
    ** Description   :  Validates update of xol_trty_name
    **/
   FUNCTION validate_delete_xol (p_xol_id IN giis_xol.xol_id%TYPE)
      RETURN VARCHAR2
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT DISTINCT 'Y'
                    INTO v_exists
                    FROM giis_dist_share
                   WHERE xol_id = p_xol_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exists := 'N';
      END;

      RETURN v_exists;
   END validate_delete_xol;

   /* Created by     :  Halley Pates
   ** Date Created  :  November 16, 2012
   ** Reference By  : (GIIS060 - Distribution Share Maintenance)
   ** Description   : Validates that the deletion of the record is permitted
   **                 by checking for the existence of rows in giis_dist_share.
   **/
   PROCEDURE delete_xol (p_xol_id IN giis_xol.xol_id%TYPE)
   IS
   BEGIN
      DELETE FROM giis_xol
            WHERE xol_id = p_xol_id;
   END delete_xol;
/* Created by     :  Halley Pates
 ** Date Created  :  November 16, 2012
 ** Reference By  : (GIIS060 - Distribution Share Maintenance)
 ** Description   :  Delete row/s from table
 **/
END; 
/

