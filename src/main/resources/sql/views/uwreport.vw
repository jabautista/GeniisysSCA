DROP VIEW CPI.UWREPORT;

/* Formatted on 2015/05/15 10:42 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.uwreport (gp_evatprem,
                                           gp_fst,
                                           gp_lgt,
                                           gp_doc_stamps,
                                           gp_other_taxes,
                                           gp_other_charges,
                                           policy_id
                                          )
AS
   SELECT   SUM (inv.evat) gp_evatprem, SUM (inv.fst) gp_fst,
            SUM (inv.lgt) gp_lgt, SUM (inv.doc_stamps) gp_doc_stamps,
            SUM (inv.other_taxes) gp_other_taxes,
            SUM (inv.other_charges) gp_other_charges, inv.policy_id
       FROM (SELECT DECODE (git.tax_cd,
                            giacp.n ('FST'), NVL (git.tax_amt
                                                  * giv.currency_rt,
                                                  0
                                                 ) * 1,
                            0
                           ) fst,
                    DECODE (git.tax_cd,
                            giacp.n ('LGT'), NVL (git.tax_amt
                                                  * giv.currency_rt,
                                                  0
                                                 ) * 1,
                            0
                           ) lgt,
                    DECODE (git.tax_cd,
                            giacp.n ('DOC_STAMPS'), NVL (  git.tax_amt
                                                         * giv.currency_rt,
                                                         0
                                                        ) * 1,
                            0
                           ) doc_stamps,
                      DECODE (git.tax_cd,
                              giacp.n ('EVAT'), NVL (  git.tax_amt
                                                     * giv.currency_rt,
                                                     0
                                                    ) * 1,
                              0
                             )
                    + DECODE (git.tax_cd,
                              giacp.n ('5PREM_TAX'), NVL (  git.tax_amt
                                                          * giv.currency_rt,
                                                          0
                                                         ) * 1,
                              0
                             ) evat,
                    NVL (NVL (giv.other_charges, 0) * giv.currency_rt,
                         0
                        ) other_taxes,
                    DECODE (git.tax_cd,
                            giacp.n ('DOC_STAMPS'), 0,
                            giacp.n ('FST'), 0,
                            giacp.n ('LGT'), 0,
                            giacp.n ('EVAT'), 0,
                            giacp.n ('5PREM_TAX'), 0,
                            NVL (NVL (giv.other_charges, 0) * giv.currency_rt,
                                 0
                                )
                           ) other_charges,
                    giv.policy_id policy_id
               FROM gipi_inv_tax git, gipi_invoice giv
              WHERE giv.iss_cd = git.iss_cd
                AND giv.prem_seq_no = git.prem_seq_no
                AND git.tax_cd >= 0
                AND giv.item_grp = git.item_grp) inv
   GROUP BY inv.policy_id;


