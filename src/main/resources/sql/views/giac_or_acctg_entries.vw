DROP VIEW CPI.GIAC_OR_ACCTG_ENTRIES;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_or_acctg_entries (gacc_tran_id,
                                                        balance,
                                                        account_cd
                                                       )
AS
   SELECT   gacc_tran_id, SUM (credit_amt) - SUM (debit_amt) balance,
            DECODE
               (a.gl_sub_acct_1,
                0,  a.gl_acct_category
                 || '-'
                 || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                 || '-'
                 || '00'
                 || '-'
                 || '00'
                 || '-'
                 || '00'
                 || '-'
                 || '00'
                 || '-'
                 || '00'
                 || '-'
                 || '00'
                 || '-'
                 || '00',
                DECODE
                   (a.gl_sub_acct_2,
                    0,  a.gl_acct_category
                     || '-'
                     || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                     || '-'
                     || '00'
                     || '-'
                     || '00'
                     || '-'
                     || '00'
                     || '-'
                     || '00'
                     || '-'
                     || '00'
                     || '-'
                     || '00'
                     || '-'
                     || '00',
                    DECODE
                       (a.gl_sub_acct_3,
                        0,  a.gl_acct_category
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                         || '-'
                         || '00'
                         || '-'
                         || '00'
                         || '-'
                         || '00'
                         || '-'
                         || '00'
                         || '-'
                         || '00'
                         || '-'
                         || '00',
                        DECODE
                           (a.gl_sub_acct_4,
                            0,  a.gl_acct_category
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                             || '-'
                             || '00'
                             || '-'
                             || '00'
                             || '-'
                             || '00'
                             || '-'
                             || '00'
                             || '-'
                             || '00',
                            DECODE
                               (a.gl_sub_acct_5,
                                0,  a.gl_acct_category
                                 || '-'
                                 || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                                 || '-'
                                 || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                                 || '-'
                                 || LTRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                                 || '-'
                                 || LTRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                                 || '-'
                                 || '00'
                                 || '-'
                                 || '00'
                                 || '-'
                                 || '00'
                                 || '-'
                                 || '00',
                                DECODE
                                   (a.gl_sub_acct_6,
                                    0,  a.gl_acct_category
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_control_acct,
                                                        '00'
                                                       )
                                              )
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
                                     || '-'
                                     || '00'
                                     || '-'
                                     || '00'
                                     || '-'
                                     || '00',
                                    DECODE
                                        (a.gl_sub_acct_7,
                                         0,  a.gl_acct_category
                                          || '-'
                                          || LTRIM
                                                  (TO_CHAR (a.gl_control_acct,
                                                            '00'
                                                           )
                                                  )
                                          || '-'
                                          || LTRIM (TO_CHAR (a.gl_sub_acct_1,
                                                             '00'
                                                            )
                                                   )
                                          || '-'
                                          || LTRIM (TO_CHAR (a.gl_sub_acct_2,
                                                             '00'
                                                            )
                                                   )
                                          || '-'
                                          || LTRIM (TO_CHAR (a.gl_sub_acct_3,
                                                             '00'
                                                            )
                                                   )
                                          || '-'
                                          || LTRIM (TO_CHAR (a.gl_sub_acct_4,
                                                             '00'
                                                            )
                                                   )
                                          || '-'
                                          || LTRIM (TO_CHAR (a.gl_sub_acct_5,
                                                             '00'
                                                            )
                                                   )
                                          || '-'
                                          || '00'
                                          || '-'
                                          || '00',
                                            a.gl_acct_category
                                         || '-'
                                         || LTRIM (TO_CHAR (a.gl_control_acct,
                                                            '00'
                                                           )
                                                  )
                                         || '-'
                                         || LTRIM (TO_CHAR (a.gl_sub_acct_1,
                                                            '00'
                                                           )
                                                  )
                                         || '-'
                                         || LTRIM (TO_CHAR (a.gl_sub_acct_2,
                                                            '00'
                                                           )
                                                  )
                                         || '-'
                                         || LTRIM (TO_CHAR (a.gl_sub_acct_3,
                                                            '00'
                                                           )
                                                  )
                                         || '-'
                                         || LTRIM (TO_CHAR (a.gl_sub_acct_4,
                                                            '00'
                                                           )
                                                  )
                                         || '-'
                                         || LTRIM (TO_CHAR (a.gl_sub_acct_5,
                                                            '00'
                                                           )
                                                  )
                                         || '-'
                                         || LTRIM (TO_CHAR (a.gl_sub_acct_6,
                                                            '00'
                                                           )
                                                  )
                                         || '-'
                                         || '0'
                                        )
                                   )
                               )
                           )
                       )
                   )
               ) account_cd                                                --,
       FROM giac_acct_entries a, giac_chart_of_accts b
      WHERE a.gl_acct_id = b.gl_acct_id
        AND generation_type != (SELECT generation_type
                                  FROM giac_modules
                                 WHERE module_name = 'GIACS001')
   GROUP BY gacc_tran_id,
            DECODE
               (a.gl_sub_acct_1,
                0,  a.gl_acct_category
                 || '-'
                 || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                 || '-'
                 || '00'
                 || '-'
                 || '00'
                 || '-'
                 || '00'
                 || '-'
                 || '00'
                 || '-'
                 || '00'
                 || '-'
                 || '00'
                 || '-'
                 || '00',
                DECODE
                   (a.gl_sub_acct_2,
                    0,  a.gl_acct_category
                     || '-'
                     || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                     || '-'
                     || '00'
                     || '-'
                     || '00'
                     || '-'
                     || '00'
                     || '-'
                     || '00'
                     || '-'
                     || '00'
                     || '-'
                     || '00'
                     || '-'
                     || '00',
                    DECODE
                       (a.gl_sub_acct_3,
                        0,  a.gl_acct_category
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                         || '-'
                         || '00'
                         || '-'
                         || '00'
                         || '-'
                         || '00'
                         || '-'
                         || '00'
                         || '-'
                         || '00'
                         || '-'
                         || '00',
                        DECODE
                           (a.gl_sub_acct_4,
                            0,  a.gl_acct_category
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                             || '-'
                             || LTRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                             || '-'
                             || '00'
                             || '-'
                             || '00'
                             || '-'
                             || '00'
                             || '-'
                             || '00'
                             || '-'
                             || '00',
                            DECODE
                               (a.gl_sub_acct_5,
                                0,  a.gl_acct_category
                                 || '-'
                                 || LTRIM (TO_CHAR (a.gl_control_acct, '00'))
                                 || '-'
                                 || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                                 || '-'
                                 || LTRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                                 || '-'
                                 || LTRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                                 || '-'
                                 || '00'
                                 || '-'
                                 || '00'
                                 || '-'
                                 || '00'
                                 || '-'
                                 || '00',
                                DECODE
                                   (a.gl_sub_acct_6,
                                    0,  a.gl_acct_category
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_control_acct,
                                                        '00'
                                                       )
                                              )
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                                     || '-'
                                     || LTRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
                                     || '-'
                                     || '00'
                                     || '-'
                                     || '00'
                                     || '-'
                                     || '00',
                                    DECODE
                                        (a.gl_sub_acct_7,
                                         0,  a.gl_acct_category
                                          || '-'
                                          || LTRIM
                                                  (TO_CHAR (a.gl_control_acct,
                                                            '00'
                                                           )
                                                  )
                                          || '-'
                                          || LTRIM (TO_CHAR (a.gl_sub_acct_1,
                                                             '00'
                                                            )
                                                   )
                                          || '-'
                                          || LTRIM (TO_CHAR (a.gl_sub_acct_2,
                                                             '00'
                                                            )
                                                   )
                                          || '-'
                                          || LTRIM (TO_CHAR (a.gl_sub_acct_3,
                                                             '00'
                                                            )
                                                   )
                                          || '-'
                                          || LTRIM (TO_CHAR (a.gl_sub_acct_4,
                                                             '00'
                                                            )
                                                   )
                                          || '-'
                                          || LTRIM (TO_CHAR (a.gl_sub_acct_5,
                                                             '00'
                                                            )
                                                   )
                                          || '-'
                                          || '00'
                                          || '-'
                                          || '00',
                                            a.gl_acct_category
                                         || '-'
                                         || LTRIM (TO_CHAR (a.gl_control_acct,
                                                            '00'
                                                           )
                                                  )
                                         || '-'
                                         || LTRIM (TO_CHAR (a.gl_sub_acct_1,
                                                            '00'
                                                           )
                                                  )
                                         || '-'
                                         || LTRIM (TO_CHAR (a.gl_sub_acct_2,
                                                            '00'
                                                           )
                                                  )
                                         || '-'
                                         || LTRIM (TO_CHAR (a.gl_sub_acct_3,
                                                            '00'
                                                           )
                                                  )
                                         || '-'
                                         || LTRIM (TO_CHAR (a.gl_sub_acct_4,
                                                            '00'
                                                           )
                                                  )
                                         || '-'
                                         || LTRIM (TO_CHAR (a.gl_sub_acct_5,
                                                            '00'
                                                           )
                                                  )
                                         || '-'
                                         || LTRIM (TO_CHAR (a.gl_sub_acct_6,
                                                            '00'
                                                           )
                                                  )
                                         || '-'
                                         || '0'
                                        )
                                   )
                               )
                           )
                       )
                   )
               );


