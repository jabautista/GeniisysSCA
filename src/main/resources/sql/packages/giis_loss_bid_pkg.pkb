CREATE OR REPLACE PACKAGE BODY CPI.giis_loss_bid_pkg
AS
   FUNCTION get_lost_bid_reason_list (p_line_cd giis_lost_bid.line_cd%TYPE)
      RETURN lost_bid_reason_list_tab PIPELINED
   IS
      v_reason   lost_bid_reason_list_type;
   BEGIN
      FOR i IN (SELECT   reason_cd, reason_desc
                    FROM giis_lost_bid
                   WHERE line_cd = p_line_cd
                     AND active_tag = 'A' --added by carlo SR 5915 01-25-2017
                ORDER BY UPPER (reason_desc))
      LOOP
         v_reason.reason_cd := i.reason_cd;
         v_reason.reason_desc := i.reason_desc;
         PIPE ROW (v_reason);
      END LOOP;

      RETURN;
   END get_lost_bid_reason_list;

   FUNCTION get_reason_desc (p_reason_cd NUMBER)
      RETURN VARCHAR2
   AS
      v_reason_desc   giis_lost_bid.reason_desc%TYPE;
   BEGIN
      FOR rec IN (SELECT   reason_desc
                      FROM giis_lost_bid
                     WHERE reason_cd = p_reason_cd
                  ORDER BY UPPER (reason_desc))
      LOOP
         v_reason_desc := rec.reason_desc;
         EXIT;
      END LOOP;

      RETURN (v_reason_desc);
   END get_reason_desc;

    /*
   **  Created by   :  D. Alcantara
   **  Date Created :  Sept. 23, 2010
   **  Reference By :  GIISS204 - Maintain Reasons
   **  Description  :  get all rows from GIIS_Lost_Bid
   */
   FUNCTION get_reasons_for_denial (p_user_id VARCHAR2)
      RETURN lost_bid_reason_list_tab PIPELINED
   IS
      v_reason   lost_bid_reason_list_type;
   BEGIN
      FOR i IN (SELECT a.reason_cd reason_cd, a.reason_desc reason_desc,
                       a.remarks remarks, a.line_cd line_cd, active_tag, --carlo 01-27-2017
                       a.user_id user_id, a.last_update last_update
                  FROM giis_lost_bid a
                 WHERE check_user_per_line2 (a.line_cd,
                                             NULL,
                                             'GIISS204',
                                             p_user_id
                                            ) = 1)
      LOOP
         v_reason.reason_cd := i.reason_cd;
         v_reason.reason_desc := i.reason_desc;
         v_reason.remarks := i.remarks;
         v_reason.line_cd := i.line_cd;
         v_reason.user_id := i.user_id;
         v_reason.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');

         FOR j IN (SELECT line_name
                     FROM giis_line
                    WHERE line_cd = i.line_cd)
         LOOP
            v_reason.line_name := j.line_name;
            EXIT;
         END LOOP;
         
         v_reason.active_tag := i.active_tag;

         PIPE ROW (v_reason);
      END LOOP;

      RETURN;
   END get_reasons_for_denial;

   /*
   **  Created by   :  D. Alcantara
   **  Date Created :  Sept. 23, 2010
   **  Reference By :  GIISS204 - Maintain Reasons
   **  Description  :  inserts/updates a reason / lost bid
   */
   PROCEDURE set_lost_bid (p_reason IN giis_lost_bid%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_lost_bid
         USING DUAL
         ON (reason_cd = p_reason.reason_cd)
         WHEN NOT MATCHED THEN
            INSERT (reason_cd, reason_desc, remarks, line_cd, last_update)
            VALUES (p_reason.reason_cd, p_reason.reason_desc,
                    p_reason.remarks, p_reason.line_cd, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET reason_desc = p_reason.reason_desc,
                   remarks = p_reason.remarks, line_cd = p_reason.line_cd,
                   last_update = SYSDATE
            ;
   END set_lost_bid;

   /*
   **  Created by   :  D. Alcantara
   **  Date Created :  Sept. 23, 2010
   **  Reference By :  GIISS204 - Maintain Reasons
   **  Description  :  deletes a reason/lost bid given the reason_cd
   */
   PROCEDURE del_lost_bid (p_reason_cd IN giis_lost_bid.reason_cd%TYPE)
   IS
   BEGIN
      DELETE FROM giis_lost_bid
            WHERE reason_cd = p_reason_cd;
   END del_lost_bid;

    /*
   **  Created by   :  I. Ellarina
   **  Date Created :  Oct. 24, 2013
   **  Reference By :  GIISS204 - Maintain Reasons
   **  Description  :  validates update reason/lost bid given the reason_cd
   */
   FUNCTION val_update_rec (p_reason_cd giis_lost_bid.reason_cd%TYPE)
      RETURN VARCHAR2
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_quote a
                 WHERE a.reason_cd = p_reason_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      RETURN v_exists;
   END;

   PROCEDURE set_rec (p_rec giis_lost_bid%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_lost_bid
         USING DUAL
         ON (reason_cd = p_rec.reason_cd AND line_cd = p_rec.line_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, reason_cd, reason_desc, remarks, user_id,
                    last_update, active_tag)--carlo 01-27-2017
            VALUES (p_rec.line_cd,
                    seq_nextval_on_demand ('LOST_BID_REASON_CD_S'),
                    p_rec.reason_desc, p_rec.remarks, p_rec.user_id, SYSDATE, p_rec.active_tag)
         WHEN MATCHED THEN
            UPDATE
               SET reason_desc = p_rec.reason_desc, remarks = p_rec.remarks,
                   user_id = p_rec.user_id, last_update = SYSDATE,
                   active_tag = p_rec.active_tag --carlo 01-27-2017
            ;
   END;

   PROCEDURE del_rec (
      p_line_cd     giis_lost_bid.line_cd%TYPE,
      p_reason_cd   giis_lost_bid.reason_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_lost_bid
            WHERE line_cd = p_line_cd AND reason_cd = p_reason_cd;
   END;

   PROCEDURE val_del_rec (p_reason_cd giis_lost_bid.reason_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_quote a
                 WHERE a.reason_cd = p_reason_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LOST_BID while dependent record(s) in GIPI_QUOTE exists.#'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (p_reason_cd giis_lost_bid.reason_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_lost_bid a
                 WHERE a.reason_cd = p_reason_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same reason_cd.'
            );
      END IF;
   END;
END giis_loss_bid_pkg;
/


