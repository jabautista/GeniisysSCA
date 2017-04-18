CREATE OR REPLACE PACKAGE CPI.Baecheck AS
/*
  Created By: Michaell
  Created On: 11-22-2002
  Remarks   : These functions are used to check the data before running the batch
     accounting entry generation. Used mainly in GIACB000, it also logs the data that
     are erroneous and the corresponding changes that the procedure will do, if applicable.

  (Most recent modifications should precede the old modifications
  Modified By:
  Modified On:
  Remarks    :

  Modified by lina on 10-21-2008
  Function check negated distribution.  To list down all distributions that are negated but the
  replacement distribution is undistibuted

  Function list of endorsements with the main policy and booking date of main policy
*/
   FUNCTION check_binder_flag(p_date VARCHAR2)
      RETURN NUMBER;
   FUNCTION check_comm_prem(p_date VARCHAR2)
      RETURN NUMBER;
   FUNCTION check_parent_intm
      RETURN NUMBER;
   FUNCTION check_trty_100
      RETURN NUMBER;
   FUNCTION check_trty_exists(p_date DATE)
      RETURN NUMBER;
   FUNCTION check_trty_type(p_date DATE)
      RETURN NUMBER;
   FUNCTION check_undist_pol(p_date VARCHAR2)
      RETURN NUMBER;
   FUNCTION check_inv_tax(p_date VARCHAR2)
      RETURN NUMBER;
   FUNCTION check_prem_invprl(p_date VARCHAR2)
      RETURN NUMBER;
   FUNCTION check_notendttax(p_date VARCHAR2)
      RETURN NUMBER;
   FUNCTION check_dist_data(p_date VARCHAR2)
      RETURN NUMBER;
   FUNCTION check_invcomm_exs(p_date VARCHAR2)
      RETURN NUMBER;
   FUNCTION check_negated_dist(p_date DATE)
      RETURN NUMBER;
  /* FUNCTION list_of_endorsements(p_date DATE)
      RETURN NUMBER;     */
    -- SR-4619 : shan 07.06.2015
    FUNCTION check_null_booking_mth
        RETURN NUMBER;
    -- end 07.06.2015
END;
/


