DROP PROCEDURE CPI.VALIDATE_AMT_COVERED;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_AMT_COVERED(
    p_line_cd           IN      GIPI_WPOLBAS.line_cd%TYPE,
    p_subline_cd        IN      GIPI_WPOLBAS.subline_cd%TYPE,
    p_iss_cd            IN      GIPI_WPOLBAS.iss_cd%TYPE,
    p_issue_yy          IN      GIPI_WPOLBAS.issue_yy%TYPE,
    p_pol_seq_no        IN      GIPI_WPOLBAS.pol_seq_no%TYPE,
    p_renew_no          IN      GIPI_WPOLBAS.renew_no%TYPE,
    p_eff_date          IN      VARCHAR2,
    p_grouped_item_no   IN      GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
    p_item_no           IN      GIPI_WGROUPED_ITEMS.item_no%TYPE,
    p_grouped_item_title IN     GIPI_WGROUPED_ITEMS.grouped_item_title%TYPE,
    p_rec_flag          IN      GIPI_WITEM.rec_flag%TYPE,
    p_amount_covered    IN OUT  GIPI_WGROUPED_ITEMS.amount_covered%TYPE,
    p_message           OUT     VARCHAR2
)
IS
    v_eff_date          GIPI_WPOLBAS.eff_date%TYPE := TO_DATE(p_eff_date, 'mm-dd-yyyy');
    v_sum               NUMBER := 0;
    
    CURSOR A IS
      SELECT policy_id,eff_date
        FROM gipi_polbasic
       WHERE line_cd                 =  p_line_cd
         AND iss_cd                  =  p_iss_cd
         AND      subline_cd              =  p_subline_cd
         AND      issue_yy                =  p_issue_yy
         AND      pol_seq_no              =  p_pol_seq_no
         AND      renew_no                =  p_renew_no
         AND      NVL(endt_expiry_date,expiry_date) >= v_eff_date
         AND      pol_flag !=  '5'
         AND endt_seq_no IN (SELECT MAX(endt_seq_no) endt_seq_no
                               FROM GIPI_GROUPED_ITEMS y,
                                    GIPI_POLBASIC x 
                              WHERE x.line_cd = p_line_cd
                                AND x.subline_cd = p_subline_cd
                                AND x.iss_cd = p_iss_cd
                                AND x.issue_yy = p_issue_yy
                                AND x.pol_seq_no = p_pol_seq_no
                                AND x.renew_no = p_renew_no
                                AND x.pol_flag IN ('1','2','3','X')
                                AND y.policy_id = x.policy_id
                                AND y.item_no = p_item_no
                                AND y.grouped_item_no = p_grouped_item_no
                                AND TO_DATE(p_eff_date, 'mm-dd-yyyy') BETWEEN TRUNC(NVL(from_date, eff_date))
                                AND NVL(to_date, NVL(endt_expiry_date, expiry_date)));
         
   CURSOR B(p_policy_id  GIPI_ITEM.policy_id%TYPE) IS
      SELECT      amount_coverage
        FROM      GIPI_GROUPED_ITEMS
       WHERE      policy_id   =  p_policy_id
         AND      grouped_item_no = p_grouped_item_no
         AND      item_no     =  p_item_no;
BEGIN
    p_message := 'SUCCESS';

    IF p_rec_flag = 'C' AND SIGN(p_amount_covered) = -1 THEN
        FOR A1 IN A LOOP
            FOR B1 IN B(A1.POLICY_ID) LOOP
                V_SUM := V_SUM + B1.AMOUNT_COVERAGE;
            END LOOP;
        END LOOP;
        
        IF V_SUM < ABS(p_amount_covered) THEN
            p_amount_covered := V_SUM * (-1);
            p_message := 'You have exceeded the total amount of grouped item ' || p_grouped_item_title || ' ( P '||to_char(v_sum,'fm99,999,999,999,990.90')||' )'; 
        END IF;
    END IF;
END;
/


