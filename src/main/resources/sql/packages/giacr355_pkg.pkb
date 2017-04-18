CREATE OR REPLACE PACKAGE BODY CPI.giacr355_pkg
AS
   /*
   **  Created by   : Steve
   **  Date Created : 02.07.2014
   **  Reference By : GIACR355
   **  Remarks      : i'm kinda losing hope,losing focus and giving up. but still i'm gonna finish this one.
   */
   FUNCTION get_main_report
      RETURN main_report_tab PIPELINED
   IS
      v_rep   main_report_type;
   BEGIN
      v_rep.cf_company := giacp.v ('COMPANY_NAME');
      v_rep.cf_address := giacp.v ('COMPANY_ADDRESS');

      FOR q1 IN (SELECT COUNT (*) count_
                   FROM TABLE (giacr355_pkg.get_q1_report))
      LOOP
         v_rep.count_q1 := q1.count_;
         EXIT;
      END LOOP;

      FOR q2 IN (SELECT COUNT (*) count_
                   FROM TABLE (giacr355_pkg.get_q2_report))
      LOOP
         v_rep.count_q2 := q2.count_;
         EXIT;
      END LOOP;

      FOR q3 IN (SELECT COUNT (*) count_
                   FROM TABLE (giacr355_pkg.get_q3_report))
      LOOP
         v_rep.count_q3 := q3.count_;
         EXIT;
      END LOOP;

      FOR q4 IN (SELECT COUNT (*) count_
                   FROM TABLE (giacr355_pkg.get_q4_report))
      LOOP
         v_rep.count_q4 := q4.count_;
         EXIT;
      END LOOP;

      FOR q5 IN (SELECT COUNT (*) count_
                   FROM TABLE (giacr355_pkg.get_q5_report))
      LOOP
         v_rep.count_q5 := q5.count_;
         EXIT;
      END LOOP;

      FOR q6 IN (SELECT COUNT (*) count_
                   FROM TABLE (giacr355_pkg.get_q6_report))
      LOOP
         v_rep.count_q6 := q6.count_;
         EXIT;
      END LOOP;

      FOR q1 IN (SELECT COUNT (*) count_
                   FROM TABLE (giacr355_pkg.get_q6_report))
      LOOP
         v_rep.count_q1 := q1.count_;
         EXIT;
      END LOOP;

      PIPE ROW (v_rep);
   END;

   FUNCTION get_q1_report
      RETURN q_report_tab PIPELINED
   IS
      v_rep   q_report_type;
   BEGIN
      FOR i IN (SELECT policy_id, policy_no
                  FROM giac_batch_check_undist)
      LOOP
         v_rep.policy_id := i.policy_id;
         v_rep.policy_no := i.policy_no;
         PIPE ROW (v_rep);
      END LOOP;
   END;

   FUNCTION get_q2_report
      RETURN q_report_tab PIPELINED
   IS
      v_rep   q_report_type;
   BEGIN
      FOR i IN (SELECT line_cd || '-' || trty_yy || '-' || trty_seq_no panel
                  FROM giac_batch_panel_100)
      LOOP
         v_rep.panel := i.panel;
         PIPE ROW (v_rep);
      END LOOP;
   END;

   FUNCTION get_q3_report
      RETURN q_report_tab PIPELINED
   IS
      v_rep   q_report_type;
   BEGIN
      FOR i IN (SELECT line_cd || '-' || share_cd trty
                  FROM giac_batch_check_trtytype)
      LOOP
         v_rep.trty := i.trty;
         PIPE ROW (v_rep);
      END LOOP;
   END;

   FUNCTION get_q4_report
      RETURN q_report_tab PIPELINED
   IS
      v_rep   q_report_type;
   BEGIN
      FOR i IN (SELECT policy_id, binder_id
                  FROM giac_batch_bad_binders)
      LOOP
         v_rep.policy_id := i.policy_id;
         v_rep.binder_id := i.binder_id;
         PIPE ROW (v_rep);
      END LOOP;
   END;

   FUNCTION get_q5_report
      RETURN q_report_tab PIPELINED
   IS
      v_rep   q_report_type;
   BEGIN
      FOR i IN (SELECT iss_cd || '-' || prem_seq_no bill_no
                  FROM giac_batch_prem_check)
      LOOP
         v_rep.bill_no := i.bill_no;
         PIPE ROW (v_rep);
      END LOOP;
   END;

   FUNCTION get_q6_report
      RETURN q_report_tab PIPELINED
   IS
      v_rep   q_report_type;
   BEGIN
      FOR i IN (SELECT policy_id
                  FROM giac_batch_check_parent)
      LOOP
         v_rep.policy_id := i.policy_id;
         PIPE ROW (v_rep);
      END LOOP;
   END;
   
    -- SR-4798 : shan 07.21.2015
    FUNCTION get_report_details
        RETURN report_tab PIPELINED
    AS
        v_rep       report_type;
        v_print     BOOLEAN := FALSE;
        v_trty_yy   GIIS_DIST_SHARE.TRTY_YY%TYPE;
    BEGIN
        v_rep.cf_company := giacp.v ('COMPANY_NAME');
        v_rep.cf_address := giacp.v ('COMPANY_ADDRESS');
        
        -- 1. Proportional treaties in GIIS_TRTY_PANEL do not have a total of 100%.
        FOR i IN (SELECT *
                    FROM GIAC_BATCH_PANEL_100)
        LOOP
            v_print         := TRUE;
            v_rep.subcode   := 1;
            v_rep.subtitle  := 'LIST OF RECORDS IN GIIS_TRTY_PANEL WHERE THE PANEL''S TOTAL IS NOT 100% :';
            v_rep.trty_no   := i.line_cd || '-' || LTRIM (TO_CHAR (i.trty_yy, '09')) || '-' || LTRIM (TO_CHAR (i.trty_seq_no, '099'));            
            v_rep.trty_name := NULL;
            
            BEGIN
                SELECT trty_name
                  INTO v_rep.trty_name
                  FROM giis_dist_share
                 WHERE line_cd = i.line_cd
                   AND trty_yy = i.trty_yy
                   AND share_cd = i.trty_seq_no;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    v_rep.trty_name := NULL;
            END;
            
            PIPE ROW(v_rep);
        END LOOP;
                
        v_rep.subcode       := NULL;
        v_rep.subtitle      := NULL;
        v_rep.trty_no       := NULL;            
        v_rep.trty_name     := NULL;
            
        -- 2. Treaties do not have treaty type in GIIS_DIST_SHARE.
        FOR i IN (SELECT *
                    FROM GIAC_BATCH_CHECK_TRTYTYPE)
        LOOP
            v_print         := TRUE;
            v_rep.subcode   := 2;
            v_rep.subtitle  := 'LIST OF RECORDS IN GIIS_DIST_SHARE THAT DO NOT HAVE TREATY TYPE :';
            v_rep.trty_name := NULL;
            
            BEGIN
                SELECT trty_name, trty_yy
                  INTO v_rep.trty_name, v_trty_yy
                  FROM giis_dist_share
                 WHERE line_cd = i.line_cd
                   AND share_cd = i.share_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    v_rep.trty_name := NULL;
                    v_trty_yy       := NULL;
            END;            
            
            v_rep.trty_no   := i.line_cd || '-' || LTRIM (TO_CHAR (v_trty_yy, '09')) || '-' || LTRIM (TO_CHAR (i.share_cd, '099'));            
            
            PIPE ROW(v_rep);
        END LOOP;
                
        v_rep.subcode       := NULL;
        v_rep.subtitle      := NULL;
        v_rep.trty_no       := NULL;            
        v_rep.trty_name     := NULL;
        
        -- 3. Policies that are not tax endorsements do not have records in GIPI_COMM_INVOICE.
        FOR i IN (SELECT *
                    FROM GIAC_BATCH_BAD_BINDERS)
        LOOP
            v_print         := TRUE;
            v_rep.subcode       := 3;
            v_rep.subtitle      := 'LIST OF BINDERS IN GIRI_BINDER THAT SHOULD HAVE A REPLACED FLAG :';
            v_rep.policy_id     := i.policy_id;
            v_rep.binder_id     := i.binder_id;   
            v_rep.old_rep_flag  := i.old_rep_flag;
            v_rep.new_rep_flag  := i.new_rep_flag;   
            v_rep.policy_no     := NULL;          
            v_rep.binder_no     := NULL;   
            
            BEGIN
                SELECT line_cd || '-' || subline_cd || '-' || iss_cd || '-' || LTRIM (TO_CHAR (issue_yy, '09'))
                        || '-' || LTRIM (TO_CHAR (pol_seq_no, '0999999')) || '-' || LTRIM (TO_CHAR (renew_no, '09'))
                  INTO v_rep.policy_no
                  FROM gipi_polbasic
                 WHERE policy_id = i.policy_id;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    v_rep.policy_no := NULL;
            END;
            
            BEGIN
                SELECT line_cd || '-' || LTRIM (TO_CHAR (binder_yy, '09')) || '-' || LTRIM (TO_CHAR (binder_seq_no, '09999'))
                  INTO v_rep.binder_no
                  FROM giri_binder
                 WHERE fnl_binder_id = i.binder_id;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    v_rep.binder_no := NULL;
            END;
            
            PIPE ROW(v_rep);
        END LOOP;
                
        v_rep.subcode       := NULL;
        v_rep.subtitle      := NULL;
        v_rep.policy_id     := NULL;
        v_rep.policy_no     := NULL;
        v_rep.binder_id     := NULL;            
        v_rep.binder_no     := NULL;
        v_rep.old_rep_flag  := NULL;
        v_rep.new_rep_flag  := NULL;
        
        -- 4. Treaties used do not exist in GIIS_TRTY_PERIL.
        FOR i IN (SELECT *
                    FROM GIAC_BATCH_CHCK_TRTYEXIST)
        LOOP
            v_print         := TRUE;
            v_rep.subcode       := 4;
            v_rep.subtitle      := 'LIST OF TREATIES USED THAT DO NOT EXIST IN GIIS_DIST_SHARE :';
            v_rep.trty_name     := i.trty_name;
            v_rep.peril_cd      := i.peril_cd;
            v_rep.peril_name    := i.peril_name;
            
            BEGIN
                SELECT trty_yy
                  INTO v_trty_yy
                  FROM giis_dist_share
                 WHERE line_cd = i.line_cd
                   AND share_cd = i.share_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    v_trty_yy       := NULL;
            END;            
            
            v_rep.trty_no   := i.line_cd || '-' || LTRIM (TO_CHAR (v_trty_yy, '09')) || '-' || LTRIM (TO_CHAR (i.share_cd, '099')); 
            
            PIPE ROW(v_rep);
        END LOOP;
                
        v_rep.subcode       := NULL;
        v_rep.subtitle      := NULL;
        v_rep.trty_no       := NULL;            
        v_rep.trty_name     := NULL;
        v_rep.peril_cd      := NULL;
        v_rep.peril_name    := NULL;
        
        -- 5. Policies that are not tax endorsements do not have records in GIPI_COMM_INVOICE.
        FOR i IN (SELECT *
                    FROM GIAC_BATCH_INVCOMM_CHECK)
        LOOP
            v_print         := TRUE;
            v_rep.subcode       := 5;
            v_rep.subtitle      := 'LIST OF POLICIES THAT ARE NOT TAX ENDORSEMENTS WHICH DO NOT HAVE RECORDS IN GIPI_COMM_INVOICE :';
            v_rep.policy_id     := i.policy_id;
            v_rep.bill_no       := i.iss_cd || '-' || LTRIM (TO_CHAR (i.prem_seq_no, '099999999999'));
            v_rep.par_id        := i.par_id;            
            v_rep.policy_no     := NULL;
            
            BEGIN
                SELECT line_cd || '-' || subline_cd || '-' || iss_cd || '-' || LTRIM (TO_CHAR (issue_yy, '09'))
                        || '-' || LTRIM (TO_CHAR (pol_seq_no, '0999999')) || '-' || LTRIM (TO_CHAR (renew_no, '09'))
                  INTO v_rep.policy_no
                  FROM gipi_polbasic
                 WHERE policy_id = i.policy_id;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    v_rep.policy_no := NULL;
            END;
            
            PIPE ROW(v_rep);
        END LOOP;
                
        v_rep.subcode       := NULL;
        v_rep.subtitle      := NULL;
        v_rep.policy_id     := NULL;
        v_rep.bill_no       := NULL;
        v_rep.par_id        := NULL;            
        v_rep.policy_no     := NULL;
        
        -- 6. Replacement distributions are not fully distributed.
        FOR i IN (SELECT *
                    FROM GIAC_BATCH_NEGATE_CHECK)
        LOOP
            v_print         := TRUE;
            v_rep.subcode       := 6;
            v_rep.subtitle      := 'LIST OF REPLACEMENT DISTRIBUTIONS THAT ARE NOT FULLY DISTRIBUTED :';
            v_rep.policy_id     := i.policy_id;
            v_rep.old_dist_no   := i.dist_no_old;
            v_rep.old_dist_flag := i.dist_flag_old;
            v_rep.new_dist_no   := i.dist_no_new;
            v_rep.new_dist_flag := i.dist_flag_new;   
            v_rep.negate_date   := TO_CHAR(i.negate_date, 'MM-DD-RRRR');
            v_rep.acct_neg_date := TO_CHAR(i.acct_neg_date, 'MM-DD-RRRR');         
            v_rep.policy_no     := NULL;
            
            BEGIN
                SELECT line_cd || '-' || subline_cd || '-' || iss_cd || '-' || LTRIM (TO_CHAR (issue_yy, '09'))
                        || '-' || LTRIM (TO_CHAR (pol_seq_no, '0999999')) || '-' || LTRIM (TO_CHAR (renew_no, '09'))
                  INTO v_rep.policy_no
                  FROM gipi_polbasic
                 WHERE policy_id = i.policy_id;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    v_rep.policy_no := NULL;
            END;
            
            PIPE ROW(v_rep);
        END LOOP;
                
        v_rep.subcode       := NULL;
        v_rep.subtitle      := NULL;
        v_rep.policy_id     := NULL;
        v_rep.old_dist_no   := NULL;
        v_rep.old_dist_flag := NULL;
        v_rep.new_dist_no   := NULL;
        v_rep.new_dist_flag := NULL;   
        v_rep.negate_date   := NULL;
        v_rep.acct_neg_date := NULL;          
        v_rep.policy_no     := NULL;
        
        -- 7. Policies with null booking month in GIPI_POLBASIC.
        FOR i IN (SELECT *
                    FROM GIAC_BATCH_NULL_BOOKINGMTH)
        LOOP
            v_print         := TRUE;
            v_rep.subcode       := 7;
            v_rep.subtitle      := 'LIST OF POLICIES WITH NULL BOOKING MONTH IN GIPI_POLBASIC :';
            v_rep.policy_id     := i.policy_id;       
            v_rep.policy_no     := NULL;
            
            BEGIN
                SELECT line_cd || '-' || subline_cd || '-' || iss_cd || '-' || LTRIM (TO_CHAR (issue_yy, '09'))
                        || '-' || LTRIM (TO_CHAR (pol_seq_no, '0999999')) || '-' || LTRIM (TO_CHAR (renew_no, '09'))
                  INTO v_rep.policy_no
                  FROM gipi_polbasic
                 WHERE policy_id = i.policy_id;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    v_rep.policy_no := NULL;
            END;
            
            PIPE ROW(v_rep);
        END LOOP;
        
        IF v_print = FALSE THEN
            PIPE ROW(v_rep);
        END IF;
    END get_report_details;
    -- end SR-4798 
END giacr355_pkg;
/


