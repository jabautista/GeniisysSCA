CREATE OR REPLACE PACKAGE BODY CPI.GIISS165_PKG
AS

   /******************************************************************************
   NAME: GIISS165_PKG
   PURPOSE: Maintain Default Distribution (By Peril)

   REVISIONS:
   Ver        Date        Author    Description
   ---------  ----------  --------  ----------------------------------------------
   1.0        1/10/2014   Marco     Remembrance lang para sa last conversion ko :)
   ******************************************************************************/
   
   FUNCTION get_line_lov(
      p_iss_cd                   giis_issource.iss_cd%TYPE,
      p_user_id                  giis_users.user_id%TYPE,
      p_find_text                VARCHAR2
   )
     RETURN line_lov_tab PIPELINED
   IS
      v_row                      line_lov_type;
   BEGIN
      FOR i IN(SELECT line_cd, line_name
                 FROM giis_line
                WHERE check_user_per_line2(line_cd, p_iss_cd, 'GIISS165', p_user_id) = 1
                  AND (UPPER(line_cd) LIKE UPPER(NVL(p_find_text, '%'))
                   OR UPPER(line_name) LIKE UPPER(NVL(p_find_text, '%'))))
      LOOP
         v_row.line_cd := i.line_cd;
         v_row.line_name := i.line_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_subline_lov(
      p_line_cd                  giis_subline.line_cd%TYPE,
      p_find_text                VARCHAR2
   )
     RETURN subline_lov_tab PIPELINED
   IS
      v_row                      subline_lov_type;
   BEGIN
      FOR i IN(SELECT line_cd, subline_cd, subline_name
                 FROM giis_subline
                WHERE line_cd = p_line_cd
                  AND (UPPER(subline_cd) LIKE UPPER(NVL(p_find_text, '%'))
                   OR UPPER(subline_name) LIKE UPPER(NVL(p_find_text, '%'))))
      LOOP
         v_row.line_cd := i.line_cd;
         v_row.subline_cd := i.subline_cd;
         v_row.subline_name := i.subline_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_issource_lov(
      p_line_cd                  giis_line.line_cd%TYPE,
      p_user_id                  giis_users.user_id%TYPE,
      p_find_text                VARCHAR2
   )
     RETURN issource_lov_tab PIPELINED
   IS
      v_row                      issource_lov_type;
   BEGIN
      FOR i IN(SELECT iss_cd, iss_name
                 FROM giis_issource
                WHERE check_user_per_iss_cd2(p_line_cd, iss_cd, 'GIISS165', p_user_id) = 1
                  AND (UPPER(iss_cd) LIKE UPPER(NVL(p_find_text, '%'))
                   OR UPPER(iss_name) LIKE UPPER(NVL(p_find_text, '%'))))
      LOOP
         v_row.iss_cd := i.iss_cd;
         v_row.iss_name := i.iss_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_type_lov(
      p_rv_domain                VARCHAR2,
      p_find_text                VARCHAR2
   )
     RETURN dist_tab PIPELINED
   IS
      v_row                      dist_type;
   BEGIN
      FOR i IN(SELECT rv_low_value, rv_meaning
                 FROM cg_ref_codes
                WHERE rv_domain = p_rv_domain
                  AND (UPPER(rv_low_value) LIKE UPPER(NVL(p_find_text, '%'))
                   OR UPPER(rv_meaning) LIKE UPPER(NVL(p_find_text, '%')))
                ORDER BY rv_low_value)
      LOOP
         v_row.type := i.rv_low_value;
         v_row.meaning := i.rv_meaning;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_share_lov(
      p_line_cd                  giis_dist_share.line_cd%TYPE,
      p_find_text                VARCHAR2
   )
     RETURN share_tab PIPELINED
   IS
      v_row                      share_type;
   BEGIN
      FOR i IN(SELECT line_cd, share_cd, trty_name
                 FROM giis_dist_share
                WHERE line_cd = p_line_cd
                  AND share_type <> 4
                  AND (UPPER(trty_name) LIKE UPPER(NVL(p_find_text, '%'))
                   OR TO_CHAR(share_cd) LIKE NVL(p_find_text, TO_CHAR(share_cd)))
                ORDER BY share_cd)
      LOOP
         v_row.line_cd := i.line_cd;
         v_row.share_cd := i.share_cd;
         v_row.trty_name := i.trty_name;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_share_lov2(
      p_line_cd                  giis_dist_share.line_cd%TYPE,
      p_find_text                VARCHAR2
   )
     RETURN share_tab PIPELINED
   IS
      v_row                      share_type;
   BEGIN
      FOR i IN(SELECT line_cd, share_cd, trty_name
                 FROM giis_dist_share
                WHERE line_cd = p_line_cd
                  AND share_type <> 4
                  AND share_cd <> 999
                  AND (UPPER(trty_name) LIKE UPPER(NVL(p_find_text, '%'))
                   OR TO_CHAR(share_cd) LIKE NVL(p_find_text, TO_CHAR(share_cd)))
                ORDER BY share_cd)
      LOOP
         v_row.line_cd := i.line_cd;
         v_row.share_cd := i.share_cd;
         v_row.trty_name := i.trty_name;
         
         PIPE ROW(v_row);
      END LOOP;
   END;

   FUNCTION get_def_dist_listing(
      p_user_id                  giis_default_dist.user_id%TYPE,
      p_default_no               giis_default_dist.default_no%TYPE
   )
     RETURN def_dist_tab PIPELINED
   IS
      v_row                      def_dist_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM giis_default_dist
                WHERE check_user_per_line2(line_cd, NULL, 'GIISS165', p_user_id) = 1
                  AND check_user_per_iss_cd2(NULL, iss_cd, 'GIISS165', p_user_id) = 1
                  AND default_no = NVL(p_default_no, default_no)
                ORDER BY default_no)
                
      LOOP
         v_row.default_no := i.default_no;
         v_row.line_cd := i.line_cd;
         v_row.default_type := i.default_type;
         v_row.dist_type := i.dist_type;
         v_row.subline_cd := i.subline_cd;
         v_row.iss_cd := i.iss_cd;
         v_row.dflt_netret_pct := i.dflt_netret_pct;
         v_row.user_id := i.user_id;
         v_row.last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_row.remarks := i.remarks;
         
         v_row.default_type_desc := NULL;
         FOR a IN(SELECT rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_low_value = i.default_type
                     AND rv_domain = 'GIIS_DEFAULT_DIST.DEFAULT_TYPE')
         LOOP
            v_row.default_type_desc := a.rv_meaning;
            EXIT;
         END LOOP;
         
         v_row.dist_type_desc := NULL;
         FOR a IN(SELECT rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_low_value = i.dist_type
                     AND rv_domain = 'GIIS_DEFAULT_DIST.DIST_TYPE')
         LOOP
            v_row.dist_type_desc := a.rv_meaning;
            EXIT;
         END LOOP;
         
         v_row.line_name := NULL;
         FOR a IN(SELECT line_name
                    FROM giis_line
                   WHERE line_cd = i.line_cd)
         LOOP
            v_row.line_name := a.line_name;
            EXIT;
         END LOOP;
         
         v_row.subline_name := NULL;
         FOR a IN(SELECT subline_name
                    FROM giis_subline
                   WHERE line_cd = i.line_cd
                     AND subline_cd = i.subline_cd)
         LOOP
            v_row.subline_name := a.subline_name;
            EXIT;
         END LOOP;
         
         v_row.iss_name := NULL;
         FOR a IN(SELECT iss_name
                    FROM giis_issource
                   WHERE iss_cd = i.iss_cd)
         LOOP
            v_row.iss_name := a.iss_name;
            EXIT;
         END LOOP;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_def_dist_dtl_listing(
      p_default_no               giis_default_dist_dtl.default_no%TYPE,
      p_range_from               giis_default_dist_dtl.range_from%TYPE,
      p_range_to                 giis_default_dist_dtl.range_from%TYPE
   )
     RETURN def_dist_dtl_tab PIPELINED
   IS
      v_row                      def_dist_dtl_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM giis_default_dist_dtl
                WHERE default_no = p_default_no
                  AND range_from = NVL(p_range_from, range_from)
                  AND range_to = NVL(p_range_to, range_to))
      LOOP
         v_row.default_no := i.default_no;
         v_row.line_cd := i.line_cd;
         v_row.subline_cd := i.subline_cd;
         v_row.iss_cd := i.iss_cd;
         v_row.range_from := i.range_from;
         v_row.range_to := i.range_to;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_peril_listing(
      p_line_cd                  giis_peril.line_cd%TYPE,
      p_peril_name               giis_peril.peril_name%TYPE
   )
     RETURN peril_tab PIPELINED
   IS
      v_row                      peril_type;
   BEGIN
      FOR i IN(SELECT line_cd, peril_cd, peril_name
                 FROM giis_peril
                WHERE line_cd = p_line_cd
                  AND UPPER(peril_name) LIKE UPPER(NVL(p_peril_name, '%'))
                ORDER BY peril_name)
      LOOP
         v_row.line_cd := i.line_cd;
         v_row.peril_cd := i.peril_cd;
         v_row.peril_name := i.peril_name;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_def_dist_peril_listing(
      p_default_no               giis_default_dist_peril.default_no%TYPE,
      p_line_cd                  giis_default_dist_peril.line_cd%TYPE,
      p_peril_cd                 giis_default_dist_peril.peril_cd%TYPE,
      p_sequence                 giis_default_dist_peril.sequence%TYPE,
      p_share_pct                giis_default_dist_peril.share_pct%TYPE,
      p_share_amt1               giis_default_dist_peril.share_amt1%TYPE
   )
     RETURN def_dist_peril_tab PIPELINED
   IS
      v_row                      def_dist_peril_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM giis_default_dist_peril
                WHERE default_no = p_default_no
                  AND line_cd = p_line_cd
                  AND peril_cd = p_peril_cd
                  AND sequence = NVL(p_sequence, sequence)
                  AND NVL(share_pct, -1) = NVL(p_share_pct, NVL(share_pct, -1))
                  AND NVL(share_amt1, -1) = NVL(p_share_amt1, NVL(share_amt1, -1))
                ORDER BY sequence)
      LOOP
         v_row.default_no := i.default_no;
         v_row.line_cd := i.line_cd;
         v_row.peril_cd := i.peril_cd;
         v_row.share_cd := i.share_cd;
         v_row.sequence := i.sequence;
         v_row.share_pct := i.share_pct;
         v_row.share_amt1 := i.share_amt1;
         v_row.share_amt2 := i.share_amt2;
         v_row.user_id := i.user_id;
         v_row.last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_row.remarks := i.remarks;
         
         v_row.trty_name := NULL;
         FOR a IN(SELECT trty_name
                    FROM giis_dist_share
                   WHERE line_cd = i.line_cd
                     AND share_cd = i.share_cd)
         LOOP
            v_row.trty_name := a.trty_name;
            EXIT;
         END LOOP;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE val_del_rec(
      p_default_no               giis_default_dist.default_no%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT 1
                 FROM giis_default_dist_group
                WHERE default_no = p_default_no)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_DEFAULT_DIST while dependent record(s) in GIIS_DEFAULT_DIST_GROUP exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM giis_default_dist_peril
                WHERE default_no = p_default_no)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_DEFAULT_DIST while dependent record(s) in GIIS_DEFAULT_DIST_PERIL exists.');
      END LOOP;
   END;
   
   PROCEDURE delete_rec(
      p_default_no               giis_default_dist.default_no%TYPE
   )
   IS
   BEGIN
      DELETE
        FROM giis_default_dist_dtl
       WHERE default_no = p_default_no;
   
      DELETE
        FROM giis_default_dist
       WHERE default_no = p_default_no;
   END;
   
   PROCEDURE val_add_rec(
      p_default_no               giis_default_dist.default_no%TYPE,
      p_line_cd                  giis_default_dist.line_cd%TYPE,
      p_subline_cd               giis_default_dist.subline_cd%TYPE,
      p_iss_cd                   giis_default_dist.iss_cd%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT 1
                 FROM giis_default_dist
                WHERE line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                  AND iss_cd = p_iss_cd
                  AND default_no <> NVL(p_default_no, -1))
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Record already exists with the same line_cd, subline_cd and iss_cd.');
      END LOOP; 
   END;
   
   PROCEDURE add_rec(
      p_rec                      giis_default_dist%ROWTYPE
   )
   IS
   BEGIN
      MERGE INTO giis_default_dist
      USING DUAL
         ON (default_no = p_rec.default_no)
       WHEN NOT MATCHED THEN
            INSERT (default_no, line_cd, default_type, dist_type, subline_cd, iss_cd, user_id, last_update)
            VALUES (p_rec.default_no, p_rec.line_cd, p_rec.default_type, p_rec.dist_type, p_rec.subline_cd, p_rec.iss_cd, p_rec.user_id, SYSDATE)
       WHEN MATCHED THEN
            UPDATE SET default_type = p_rec.default_type,
                       dist_type = p_rec.dist_type,
                       iss_cd = p_rec.iss_cd,
                       user_id = p_rec.user_id,
                       last_update = SYSDATE;
   END;
   
   PROCEDURE get_dist_peril_variables(
      p_default_no         IN    giis_default_dist_peril.default_no%TYPE,
      p_line_cd            IN    giis_default_dist_peril.line_cd%TYPE,
      p_peril_cd           IN    giis_default_dist_peril.peril_cd%TYPE,
      p_max_sequence       OUT   giis_default_dist_peril.sequence%TYPE,
      p_total_share_pct    OUT   giis_default_dist_peril.share_pct%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT NVL(SUM(share_pct), 0) total_share_pct
                 FROM giis_default_dist_peril
                WHERE default_no = p_default_no
                  AND line_cd = p_line_cd
                  AND peril_cd = p_peril_cd)
      LOOP
         p_total_share_pct := i.total_share_pct;
      END LOOP;
      
      FOR i IN(SELECT NVL(MAX(sequence), 0) max_sequence
                 FROM giis_default_dist_peril
                WHERE default_no = p_default_no
                  AND line_cd = p_line_cd
                  AND peril_cd = p_peril_cd)
      LOOP
         p_max_sequence := i.max_sequence;
      END LOOP;
   END;
   
   PROCEDURE check_dist_records(
      p_default_no               giis_default_dist_peril.default_no%TYPE,
      p_line_cd                  giis_default_dist_peril.line_cd%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT 1
                 FROM giis_default_dist_peril
                WHERE default_no = p_default_no
                  AND line_cd = p_line_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#I#You cannot change the default type if there are already existing ' || 
                                          'detail default distribution records.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM giis_default_dist_group
                WHERE default_no = p_default_no
                  AND line_cd = p_line_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#I#You cannot change the default type if there are already existing detail default ' || 
                                          'distribution records in default distribution by group.');
      END LOOP;
   END;
   
   PROCEDURE add_peril(
      p_rec                      giis_default_dist_peril%ROWTYPE
   )
   IS
   BEGIN
      MERGE INTO giis_default_dist_peril
      USING DUAL
         ON (default_no = p_rec.default_no
        AND line_cd = p_rec.line_cd
        AND peril_cd = p_rec.peril_cd
        AND share_cd = p_rec.share_cd)
       WHEN NOT MATCHED THEN
            INSERT (default_no, line_cd, peril_cd, share_cd, sequence, share_pct, share_amt1, user_id, last_update, remarks)
            VALUES (p_rec.default_no, p_rec.line_cd, p_rec.peril_cd, p_rec.share_cd, p_rec.sequence,
                     p_rec.share_pct, p_rec.share_amt1, p_rec.user_id, SYSDATE, p_rec.remarks)
       WHEN MATCHED THEN
            UPDATE SET sequence = p_rec.sequence, 
                       share_pct = p_rec.share_pct,
                       share_amt1 = p_rec.share_amt1,
                       user_id = p_rec.user_id,
                       remarks = p_rec.remarks,
                       last_update = SYSDATE;
   END;
   
   PROCEDURE delete_peril(
      p_default_no               giis_default_dist_peril.default_no%TYPE,
      p_line_cd                  giis_default_dist_peril.line_cd%TYPE,
      p_peril_cd                 giis_default_dist_peril.peril_cd%TYPE,
      p_share_cd                 giis_default_dist_peril.share_cd%TYPE
   )
   IS
   BEGIN
      DELETE
        FROM giis_default_dist_peril
       WHERE default_no = p_default_no
         AND line_cd = p_line_cd
         AND peril_cd = p_peril_cd
         AND share_cd = p_share_cd;
   END;
   
END;
/


