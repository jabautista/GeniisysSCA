CREATE OR REPLACE PACKAGE CPI.summarize_distribution
/*Modified    : Iris Bordey
**Date        : 02.27.2003
**MOdification:1. This package summarizes distribution of a policy
*/
AS
  --extract procedure determines whether there is validation on date when
  --summarizing distribution or just to summarize all dist. of the policy
  PROCEDURE EXTRACT(p_line_cd    VARCHAR2,
                    p_subline_cd VARCHAR2,
     p_iss_cd     VARCHAR2,
     p_issue_yy   NUMBER,
     p_pol_seq_no NUMBER,
     p_renew_no   NUMBER,
     p_date       DATE);

  --summarizes all distribution without validation on dates
  PROCEDURE summarize_all_distribution(p_line_cd VARCHAR2,
                                       p_subline_cd VARCHAR2,
                        p_iss_cd  VARCHAR2,
                        p_issue_yy NUMBER,
                        p_pol_seq_no NUMBER,
                        p_renew_no NUMBER);

  --summarizes distribution with validation on parameter DATE
  PROCEDURE summarize_eff_distribution(p_line_cd VARCHAR2,
                                       p_subline_cd VARCHAR2,
                               p_iss_cd  VARCHAR2,
                        p_issue_yy NUMBER,
                        p_pol_seq_no NUMBER,
                        p_renew_no NUMBER,
                        p_date    DATE);
  FUNCTION get_rate (p_numerator  NUMBER,
                     p_denominator NUMBER)
    RETURN NUMBER;
END summarize_distribution;
/


