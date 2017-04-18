CREATE OR REPLACE PACKAGE CPI.GIPIS214_PKG
AS
/* Created by : John Dolon
 * Date Created: 09.19.2013
 * Reference By: GIPIS214 - Premium Payment Warranty Tracking Screen
 *
*/ 
   TYPE gipis214_table_type IS RECORD (
        binder_line_cd      VARCHAR2(2),
        binder_yy           NUMBER(2),
        binder_seq_no       NUMBER(5),
        ri_name             VARCHAR2(50),
        binder_date         DATE,
        prem_warr_days      NUMBER(3),
        ri_tsi_amt          NUMBER(16,2),
        ri_prem_amt         NUMBER(12,2),
        assd_name           VARCHAR2(500),
        policy_no           VARCHAR2(4000),
        incept_dates        DATE,
        acc_ent_date        DATE,
        booking_date        VARCHAR2(100),
        dsp_booking_date    VARCHAR2(100)
   );
      
   TYPE gipis214_table_tab IS TABLE OF gipis214_table_type;
   
   FUNCTION get_gipis214_table(
       p_search_by          VARCHAR2,
       p_from_date          VARCHAR2,
       p_to_date            VARCHAR2,
       p_as_of_date         VARCHAR2,
       p_user_id            VARCHAR2
   )
   RETURN gipis214_table_tab PIPELINED;
END;
/


