DROP VIEW CPI.GIAC_COMM_INCOME_EXT_V;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_comm_income_ext_v (policy_id,
                                                         assd_no,
                                                         incept_date,
                                                         acct_ent_date,
                                                         peril_cd,
                                                         total_prem_amt,
                                                         line_cd,
                                                         iss_cd,
                                                         treaty_prem,
                                                         treaty_comm,
                                                         trty_acct_type,
                                                         nr_prem_amt,
                                                         facul_prem,
                                                         facul_comm,
                                                         user_id,
                                                         last_update,
                                                         cred_branch
                                                        )
AS
   SELECT policy_id, assd_no, incept_date, acct_ent_date, peril_cd,
          total_prem_amt, line_cd, iss_cd, treaty1_prem treaty_prem,
          treaty1_comm treaty_comm, trty1_acct_type trty_acct_type,
          nr_prem_amt, facul_prem, facul_comm, user_id, last_update,
          cred_branch
     FROM giac_comm_income_ext
    WHERE trty1_acct_type IS NOT NULL
   UNION
   SELECT policy_id, assd_no, incept_date, acct_ent_date, peril_cd,
          total_prem_amt, line_cd, iss_cd, treaty2_prem treaty_prem,
          treaty2_comm treaty_comm, trty2_acct_type trty_acct_type,
          nr_prem_amt, facul_prem, facul_comm, user_id, last_update,
          cred_branch
     FROM giac_comm_income_ext
    WHERE trty2_acct_type IS NOT NULL
   UNION
   SELECT policy_id, assd_no, incept_date, acct_ent_date, peril_cd,
          total_prem_amt, line_cd, iss_cd, treaty3_prem treaty_prem,
          treaty3_comm treaty_comm, trty3_acct_type trty_acct_type,
          nr_prem_amt, facul_prem, facul_comm, user_id, last_update,
          cred_branch
     FROM giac_comm_income_ext
    WHERE trty3_acct_type IS NOT NULL
   UNION
   SELECT policy_id, assd_no, incept_date, acct_ent_date, peril_cd,
          total_prem_amt, line_cd, iss_cd, treaty4_prem treaty_prem,
          treaty4_comm treaty_comm, trty4_acct_type trty_acct_type,
          nr_prem_amt, facul_prem, facul_comm, user_id, last_update,
          cred_branch
     FROM giac_comm_income_ext
    WHERE trty4_acct_type IS NOT NULL
   UNION
   SELECT policy_id, assd_no, incept_date, acct_ent_date, peril_cd,
          total_prem_amt, line_cd, iss_cd, treaty5_prem treaty_prem,
          treaty5_comm treaty_comm, trty5_acct_type trty_acct_type,
          nr_prem_amt, facul_prem, facul_comm, user_id, last_update,
          cred_branch
     FROM giac_comm_income_ext
    WHERE trty5_acct_type IS NOT NULL
   UNION
   SELECT policy_id, assd_no, incept_date, acct_ent_date, peril_cd,
          total_prem_amt, line_cd, iss_cd, treaty6_prem treaty_prem,
          treaty6_comm treaty_comm, trty6_acct_type trty_acct_type,
          nr_prem_amt, facul_prem, facul_comm, user_id, last_update,
          cred_branch
     FROM giac_comm_income_ext
    WHERE trty6_acct_type IS NOT NULL
   UNION
   SELECT policy_id, assd_no, incept_date, acct_ent_date, peril_cd,
          total_prem_amt, line_cd, iss_cd, treaty7_prem treaty_prem,
          treaty7_comm treaty_comm, trty7_acct_type trty_acct_type,
          nr_prem_amt, facul_prem, facul_comm, user_id, last_update,
          cred_branch
     FROM giac_comm_income_ext
    WHERE trty7_acct_type IS NOT NULL
   UNION
   SELECT policy_id, assd_no, incept_date, acct_ent_date, peril_cd,
          total_prem_amt, line_cd, iss_cd, treaty8_prem treaty_prem,
          treaty8_comm treaty_comm, trty8_acct_type trty_acct_type,
          nr_prem_amt, facul_prem, facul_comm, user_id, last_update,
          cred_branch
     FROM giac_comm_income_ext
    WHERE trty8_acct_type IS NOT NULL
   UNION
   SELECT policy_id, assd_no, incept_date, acct_ent_date, peril_cd,
          total_prem_amt, line_cd, iss_cd, NULL "treaty_prem",
          NULL "treaty_comm", NULL "trty_acct_type", nr_prem_amt, facul_prem,
          facul_comm, user_id, last_update, cred_branch
     FROM giac_comm_income_ext
    WHERE trty1_acct_type IS NULL
      AND trty2_acct_type IS NULL
      AND trty3_acct_type IS NULL
      AND trty4_acct_type IS NULL
      AND trty5_acct_type IS NULL
      AND trty6_acct_type IS NULL
      AND trty7_acct_type IS NULL
      AND trty8_acct_type IS NULL;


