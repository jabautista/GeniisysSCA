DROP VIEW CPI.GIAC_COMM_INCOME_EXT_SUMM_V;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_comm_income_ext_summ_v (line_cd,
                                                              iss_cd,
                                                              cred_branch,
                                                              user_id,
                                                              acct_ent_date,
                                                              total_prem_amt,
                                                              nr_prem_amt,
                                                              treaty_prem,
                                                              treaty_comm,
                                                              trty_acct_type,
                                                              facul_prem,
                                                              facul_comm
                                                             )
AS
   (SELECT a.line_cd, a.iss_cd, a.cred_branch, a.user_id, a.acct_ent_date,
           total_prem_amt, nr_prem_amt, treaty_prem, treaty_comm,
           trty_acct_type, facul_prem, facul_comm
      FROM (SELECT   line_cd, iss_cd, cred_branch, user_id, acct_ent_date,
                     SUM (total_prem_amt) total_prem_amt,
                     SUM (nr_prem_amt) nr_prem_amt,
                     SUM (facul_prem) facul_prem, SUM (facul_comm) facul_comm
                FROM giac_comm_income_ext
            GROUP BY line_cd, iss_cd, cred_branch, user_id, acct_ent_date) a,
           (SELECT   line_cd, iss_cd, user_id, cred_branch, acct_ent_date,
                     SUM (treaty1_prem) treaty_prem,
                     SUM (treaty1_comm) treaty_comm,
                     trty1_acct_type trty_acct_type
                FROM giac_comm_income_ext
               WHERE trty1_acct_type IS NOT NULL
            GROUP BY line_cd,
                     iss_cd,
                     cred_branch,
                     user_id,
                     acct_ent_date,
                     trty1_acct_type) b
     WHERE a.line_cd = b.line_cd
       AND a.iss_cd = b.iss_cd
       AND a.user_id = b.user_id
       AND a.acct_ent_date = b.acct_ent_date
       AND a.cred_branch = b.cred_branch)
   UNION
   (SELECT a.line_cd, a.iss_cd, a.cred_branch, a.user_id, a.acct_ent_date,
           total_prem_amt, nr_prem_amt, treaty_prem, treaty_comm,
           trty_acct_type, facul_prem, facul_comm
      FROM (SELECT   line_cd, iss_cd, cred_branch, user_id, acct_ent_date,
                     SUM (total_prem_amt) total_prem_amt,
                     SUM (nr_prem_amt) nr_prem_amt,
                     SUM (facul_prem) facul_prem, SUM (facul_comm) facul_comm
                FROM giac_comm_income_ext
            GROUP BY line_cd, iss_cd, cred_branch, user_id, acct_ent_date) a,
           (SELECT   line_cd, iss_cd, user_id, cred_branch, acct_ent_date,
                     SUM (treaty2_prem) treaty_prem,
                     SUM (treaty2_comm) treaty_comm,
                     trty2_acct_type trty_acct_type
                FROM giac_comm_income_ext
               WHERE trty2_acct_type IS NOT NULL
            GROUP BY line_cd,
                     iss_cd,
                     cred_branch,
                     user_id,
                     acct_ent_date,
                     trty2_acct_type) b
     WHERE a.line_cd = b.line_cd
       AND a.iss_cd = b.iss_cd
       AND a.user_id = b.user_id
       AND a.acct_ent_date = b.acct_ent_date
       AND a.cred_branch = b.cred_branch)
   UNION
   (SELECT a.line_cd, a.iss_cd, a.cred_branch, a.user_id, a.acct_ent_date,
           total_prem_amt, nr_prem_amt, treaty_prem, treaty_comm,
           trty_acct_type, facul_prem, facul_comm
      FROM (SELECT   line_cd, iss_cd, cred_branch, user_id, acct_ent_date,
                     SUM (total_prem_amt) total_prem_amt,
                     SUM (nr_prem_amt) nr_prem_amt,
                     SUM (facul_prem) facul_prem, SUM (facul_comm) facul_comm
                FROM giac_comm_income_ext
            GROUP BY line_cd, iss_cd, cred_branch, user_id, acct_ent_date) a,
           (SELECT   line_cd, iss_cd, user_id, cred_branch, acct_ent_date,
                     SUM (treaty3_prem) treaty_prem,
                     SUM (treaty3_comm) treaty_comm,
                     trty3_acct_type trty_acct_type
                FROM giac_comm_income_ext
               WHERE trty3_acct_type IS NOT NULL
            GROUP BY line_cd,
                     iss_cd,
                     cred_branch,
                     user_id,
                     acct_ent_date,
                     trty3_acct_type) b
     WHERE a.line_cd = b.line_cd
       AND a.iss_cd = b.iss_cd
       AND a.user_id = b.user_id
       AND a.acct_ent_date = b.acct_ent_date
       AND a.cred_branch = b.cred_branch)
   UNION
   (SELECT a.line_cd, a.iss_cd, a.cred_branch, a.user_id, a.acct_ent_date,
           total_prem_amt, nr_prem_amt, treaty_prem, treaty_comm,
           trty_acct_type, facul_prem, facul_comm
      FROM (SELECT   line_cd, iss_cd, cred_branch, user_id, acct_ent_date,
                     SUM (total_prem_amt) total_prem_amt,
                     SUM (nr_prem_amt) nr_prem_amt,
                     SUM (facul_prem) facul_prem, SUM (facul_comm) facul_comm
                FROM giac_comm_income_ext
            GROUP BY line_cd, iss_cd, cred_branch, user_id, acct_ent_date) a,
           (SELECT   line_cd, iss_cd, user_id, cred_branch, acct_ent_date,
                     SUM (treaty4_prem) treaty_prem,
                     SUM (treaty4_comm) treaty_comm,
                     trty4_acct_type trty_acct_type
                FROM giac_comm_income_ext
               WHERE trty4_acct_type IS NOT NULL
            GROUP BY line_cd,
                     iss_cd,
                     cred_branch,
                     user_id,
                     acct_ent_date,
                     trty4_acct_type) b
     WHERE a.line_cd = b.line_cd
       AND a.iss_cd = b.iss_cd
       AND a.user_id = b.user_id
       AND a.acct_ent_date = b.acct_ent_date
       AND a.cred_branch = b.cred_branch)
   UNION
   (SELECT a.line_cd, a.iss_cd, a.cred_branch, a.user_id, a.acct_ent_date,
           total_prem_amt, nr_prem_amt, treaty_prem, treaty_comm,
           trty_acct_type, facul_prem, facul_comm
      FROM (SELECT   line_cd, iss_cd, cred_branch, user_id, acct_ent_date,
                     SUM (total_prem_amt) total_prem_amt,
                     SUM (nr_prem_amt) nr_prem_amt,
                     SUM (facul_prem) facul_prem, SUM (facul_comm) facul_comm
                FROM giac_comm_income_ext
            GROUP BY line_cd, iss_cd, cred_branch, user_id, acct_ent_date) a,
           (SELECT   line_cd, iss_cd, user_id, cred_branch, acct_ent_date,
                     SUM (treaty5_prem) treaty_prem,
                     SUM (treaty5_comm) treaty_comm,
                     trty5_acct_type trty_acct_type
                FROM giac_comm_income_ext
               WHERE trty5_acct_type IS NOT NULL
            GROUP BY line_cd,
                     iss_cd,
                     cred_branch,
                     user_id,
                     acct_ent_date,
                     trty5_acct_type) b
     WHERE a.line_cd = b.line_cd
       AND a.iss_cd = b.iss_cd
       AND a.user_id = b.user_id
       AND a.acct_ent_date = b.acct_ent_date
       AND a.cred_branch = b.cred_branch)
   UNION
   (SELECT a.line_cd, a.iss_cd, a.cred_branch, a.user_id, a.acct_ent_date,
           total_prem_amt, nr_prem_amt, treaty_prem, treaty_comm,
           trty_acct_type, facul_prem, facul_comm
      FROM (SELECT   line_cd, iss_cd, cred_branch, user_id, acct_ent_date,
                     SUM (total_prem_amt) total_prem_amt,
                     SUM (nr_prem_amt) nr_prem_amt,
                     SUM (facul_prem) facul_prem, SUM (facul_comm) facul_comm
                FROM giac_comm_income_ext
            GROUP BY line_cd, iss_cd, cred_branch, user_id, acct_ent_date) a,
           (SELECT   line_cd, iss_cd, user_id, cred_branch, acct_ent_date,
                     SUM (treaty6_prem) treaty_prem,
                     SUM (treaty6_comm) treaty_comm,
                     trty6_acct_type trty_acct_type
                FROM giac_comm_income_ext
               WHERE trty6_acct_type IS NOT NULL
            GROUP BY line_cd,
                     iss_cd,
                     cred_branch,
                     user_id,
                     acct_ent_date,
                     trty6_acct_type) b
     WHERE a.line_cd = b.line_cd
       AND a.iss_cd = b.iss_cd
       AND a.user_id = b.user_id
       AND a.acct_ent_date = b.acct_ent_date
       AND a.cred_branch = b.cred_branch)
   UNION
   (SELECT a.line_cd, a.iss_cd, a.cred_branch, a.user_id, a.acct_ent_date,
           total_prem_amt, nr_prem_amt, treaty_prem, treaty_comm,
           trty_acct_type, facul_prem, facul_comm
      FROM (SELECT   line_cd, iss_cd, cred_branch, user_id, acct_ent_date,
                     SUM (total_prem_amt) total_prem_amt,
                     SUM (nr_prem_amt) nr_prem_amt,
                     SUM (facul_prem) facul_prem, SUM (facul_comm) facul_comm
                FROM giac_comm_income_ext
            GROUP BY line_cd, iss_cd, cred_branch, user_id, acct_ent_date) a,
           (SELECT   line_cd, iss_cd, user_id, cred_branch, acct_ent_date,
                     SUM (treaty7_prem) treaty_prem,
                     SUM (treaty7_comm) treaty_comm,
                     trty7_acct_type trty_acct_type
                FROM giac_comm_income_ext
               WHERE trty7_acct_type IS NOT NULL
            GROUP BY line_cd,
                     iss_cd,
                     cred_branch,
                     user_id,
                     acct_ent_date,
                     trty7_acct_type) b
     WHERE a.line_cd = b.line_cd
       AND a.iss_cd = b.iss_cd
       AND a.user_id = b.user_id
       AND a.acct_ent_date = b.acct_ent_date
       AND a.cred_branch = b.cred_branch)
   UNION
   (SELECT a.line_cd, a.iss_cd, a.cred_branch, a.user_id, a.acct_ent_date,
           total_prem_amt, nr_prem_amt, treaty_prem, treaty_comm,
           trty_acct_type, facul_prem, facul_comm
      FROM (SELECT   line_cd, iss_cd, cred_branch, user_id, acct_ent_date,
                     SUM (total_prem_amt) total_prem_amt,
                     SUM (nr_prem_amt) nr_prem_amt,
                     SUM (facul_prem) facul_prem, SUM (facul_comm) facul_comm
                FROM giac_comm_income_ext
            GROUP BY line_cd, iss_cd, cred_branch, user_id, acct_ent_date) a,
           (SELECT   line_cd, iss_cd, user_id, cred_branch, acct_ent_date,
                     SUM (treaty8_prem) treaty_prem,
                     SUM (treaty8_comm) treaty_comm,
                     trty8_acct_type trty_acct_type
                FROM giac_comm_income_ext
               WHERE trty8_acct_type IS NOT NULL
            GROUP BY line_cd,
                     iss_cd,
                     cred_branch,
                     user_id,
                     acct_ent_date,
                     trty8_acct_type) b
     WHERE a.line_cd = b.line_cd
       AND a.iss_cd = b.iss_cd
       AND a.user_id = b.user_id
       AND a.acct_ent_date = b.acct_ent_date
       AND a.cred_branch = b.cred_branch)
   UNION
   SELECT   line_cd, iss_cd, cred_branch, user_id, acct_ent_date,
            SUM (total_prem_amt) total_prem_amt, SUM (nr_prem_amt)
                                                                  nr_prem_amt,
            NULL "treaty_prem", NULL "treaty_comm", NULL "trty_acct_type",
            SUM (facul_prem) facul_prem, SUM (facul_comm) facul_comm
       FROM giac_comm_income_ext
   GROUP BY line_cd, iss_cd, cred_branch, user_id, acct_ent_date;


