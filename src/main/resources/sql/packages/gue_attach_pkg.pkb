CREATE OR REPLACE PACKAGE BODY CPI.GUE_ATTACH_PKG AS

/*
** Created by    : Andrew Robes
** Created date  : August 23, 2010
** Referenced by : (WOFLO01 - Workflow)
** Description   : Procedure to insert workflow attachments
*/
    PROCEDURE set_gue_attach(p_attach GUE_ATTACH%ROWTYPE)
    IS
      v_item_no GUE_ATTACH.item_no%TYPE;
    BEGIN
      IF p_attach.item_no IS NULL THEN
        SELECT NVL(MAX(item_no),0)+1
          INTO v_item_no
          FROM GUE_ATTACH
         WHERE tran_id = p_attach.tran_id;
      END IF;

      MERGE INTO GUE_ATTACH
      USING DUAL ON (tran_id = p_attach.tran_id
                 AND item_no = p_attach.item_no)
      WHEN NOT MATCHED THEN
        INSERT (tran_id, item_no, file_name, remarks)
        VALUES (p_attach.tran_id, v_item_no, p_attach.file_name, p_attach.remarks)
      WHEN MATCHED THEN
        UPDATE SET remarks = p_attach.remarks;

    END set_gue_attach;

/*
** Created by    : Andrew Robes
** Created date  : 09.29.2011
** Referenced by : (WOFLO01 - Workflow)
** Description   : Function to retrieve attachment records
*/
    FUNCTION get_gue_attach_listing(p_tran_id GUE_ATTACH.tran_id%TYPE)
      RETURN gue_attach_tab PIPELINED
    IS
      v_attach gue_attach_type;
    BEGIN
      FOR i IN (
        SELECT tran_id, item_no, file_name, remarks
          FROM gue_attach
         WHERE tran_id = p_tran_id)
      LOOP
        v_attach.tran_id := i.tran_id;
        v_attach.item_no := i.item_no;
        v_attach.file_name := SUBSTR(i.file_name, INSTR( i.file_name, '/', -1) + 1, LENGTH(i.file_name));
        v_attach.file_path := i.file_name;
        v_attach.remarks := i.remarks;

        PIPE ROW(v_attach);
      END LOOP;
      RETURN;
    END get_gue_attach_listing;

   PROCEDURE del_gue_attach(
      p_tran_id GUE_ATTACH.tran_id%TYPE,
      p_item_no GUE_ATTACH.item_no%TYPE
    )
   IS
   BEGIN
     DELETE gue_attach
      WHERE tran_id = p_tran_id
        AND item_no = p_item_no;

   END del_gue_attach;

END GUE_ATTACH_PKG;
/


