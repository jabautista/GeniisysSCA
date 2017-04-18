CREATE OR REPLACE PACKAGE BODY CPI.GIPIS214_PKG
AS
/* Created by : John Dolon
 * Date Created: 09.19.2013
 * Reference By: GIPIS214 - Premium Payment Warranty Tracking Screen
 *
*/

   FUNCTION get_gipis214_table(
       p_search_by          VARCHAR2,
       p_from_date          VARCHAR2,
       p_to_date            VARCHAR2,
       p_as_of_date         VARCHAR2,
       p_user_id            VARCHAR2
   )
   RETURN gipis214_table_tab PIPELINED
   IS
        v_list gipis214_table_type;
   BEGIN
        FOR i IN (
                    SELECT * 
                      FROM PPW_TRACKING_V
                     WHERE check_user_per_iss_cd2(BINDER_LINE_CD, ISS_CD, 'GIPIS214',p_user_id) = 1
                       AND (DECODE(p_search_by, 1, TO_DATE(incept_dates),
                                                2, TO_DATE(acc_ent_date),
                                                3, TO_DATE(booking_date)) >= TO_DATE(p_from_date, 'MM-DD-YYYY')
                                   AND DECODE(p_search_by, 1, TO_DATE(incept_dates),
                                                           2, TO_DATE(acc_ent_date),
                                                           3, TO_DATE(booking_date)) <= TO_DATE(p_to_date, 'MM-DD-YYYY')
                                    OR DECODE(p_search_by, 1, TO_DATE(incept_dates),
                                                           2, TO_DATE(acc_ent_date),
                                                           3, TO_DATE(booking_date)) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY'))
                     ORDER BY binder_line_cd, binder_yy, binder_seq_no                                   
                       )
              LOOP
                 v_list.binder_line_cd    := i.binder_line_cd;
                 v_list.binder_yy         := i.binder_yy;
                 v_list.binder_seq_no     := i.binder_seq_no; 
                 v_list.ri_name           := i.ri_name;       
                 v_list.binder_date       := i.binder_date;   
                 v_list.prem_warr_days    := i.prem_warr_days;
                 v_list.ri_tsi_amt        := i.ri_tsi_amt;    
                 v_list.ri_prem_amt       := i.ri_prem_amt;
                 v_list.assd_name         := i.assd_name;     
                 v_list.policy_no         := i.policy_no;     
                 v_list.incept_dates      := i.incept_dates;  
                 v_list.acc_ent_date      := i.acc_ent_date;  
                 v_list.booking_date      := TO_CHAR(i.booking_date, 'fmMonth YYYY');
                 v_list.dsp_booking_date  := TO_CHAR(i.booking_date, 'fmMonth YYYY'); 

                PIPE ROW (v_list);
              END LOOP;
      RETURN;
   END;
END;
/


