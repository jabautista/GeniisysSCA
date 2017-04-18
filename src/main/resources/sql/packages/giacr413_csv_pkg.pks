CREATE OR REPLACE PACKAGE cpi.giacr413_csv_pkg
AS
   TYPE csv_rec_type IS RECORD (
      rec   VARCHAR2 (32767)
   );

   TYPE csv_rec_tab IS TABLE OF csv_rec_type;

   FUNCTION get_giacr413a (
      p_branch_cd   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_tran_post   VARCHAR2,
      p_module_id   VARCHAR2,
      p_intm_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN csv_rec_tab PIPELINED;

   FUNCTION get_giacr413b (
      p_branch_cd   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_tran_post   VARCHAR2,
      p_module_id   VARCHAR2,
      p_intm_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN csv_rec_tab PIPELINED;

   FUNCTION get_giacr413c (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_tran_post   VARCHAR2,
      p_module_id   VARCHAR2,
      p_intm_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN csv_rec_tab PIPELINED;

   FUNCTION get_giacr413d (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_tran_post   VARCHAR2,
      p_module_id   VARCHAR2,
      p_intm_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN csv_rec_tab PIPELINED;

   FUNCTION get_giacr413e (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_tran_post   VARCHAR2,
      p_module_id   VARCHAR2,
      p_intm_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN csv_rec_tab PIPELINED;

   FUNCTION get_giacr413f (
      p_branch_cd   VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_tran_post   VARCHAR2,
      p_module_id   VARCHAR2,
      p_intm_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN csv_rec_tab PIPELINED;
END giacr413_csv_pkg;
/