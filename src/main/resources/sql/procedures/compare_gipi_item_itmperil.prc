DROP PROCEDURE CPI.COMPARE_GIPI_ITEM_ITMPERIL;

CREATE OR REPLACE PROCEDURE CPI.COMPARE_GIPI_ITEM_ITMPERIL 
(p_policy_id         IN       GIPI_POLBASIC.policy_id%TYPE,
 p_pack_pol_flag     IN       GIPI_POLBASIC.pack_pol_flag%TYPE,
 p_line_cd           IN       GIPI_POLBASIC.line_cd%TYPE,
 p_message           OUT      VARCHAR2)
                                      
/**
**  Created by:     Veronica V. Raymundo
**  Date Created:   July 11, 2011
**  Referenced by:  GIUWS010 - Set-up Groups Distribution for Final (Item)
**  Description:    Compares the tsi, premium and annualized amounts 
**                  from the gipi_item tables against the corresponding 
**                  amounts from the gipi_itmperil table
**/
 
 IS
 
    v_tsi_amt               NUMBER(16,2);
    v_prem_amt              NUMBER(12,2);
    v_ann_tsi_amt           NUMBER(16,2);
    v2_tsi_amt              NUMBER(16,2);
    v2_prem_amt             NUMBER(12,2);
    v2_ann_tsi_amt          NUMBER(16,2);
    v3_tsi_amt              NUMBER(16,2);
    v3_prem_amt             NUMBER(12,2);
    v3_ann_tsi_amt          NUMBER(16,2); 
    v4_tsi_amt              NUMBER(16,2);
    v4_prem_amt             NUMBER(12,2);
    v4_ann_tsi_amt          NUMBER(16,2);
    v_exist                 VARCHAR2(1) := 'N';
    v_message               VARCHAR(500) := 'SUCCESS';
    
BEGIN
   
  IF NVL(p_pack_pol_flag, 'N') = 'N' THEN

     BEGIN
       SELECT SUM(tsi_amt),
              SUM(prem_amt),
              SUM(ann_tsi_amt)
         INTO v_tsi_amt,
              v_prem_amt,
              v_ann_tsi_amt
         FROM GIPI_ITEM
        WHERE policy_id = p_policy_id;

       SELECT SUM(prem_amt)
         INTO v2_prem_amt
         FROM GIPI_ITMPERIL
        WHERE policy_id = p_policy_id;

       SELECT SUM(a.tsi_amt),
              SUM(a.ann_tsi_amt)
         INTO v2_tsi_amt,
              v2_ann_tsi_amt
         FROM GIPI_ITMPERIL a
        WHERE EXISTS
             (SELECT 1
                FROM GIIS_PERIL b
               WHERE b.peril_type = 'B'
                 AND b.peril_cd   = a.peril_cd
                 AND b.line_cd    = p_line_cd)
          AND a.policy_id = p_policy_id;

       IF v_tsi_amt <> v2_tsi_amt THEN
          v_message := 'The total sum insured in gipi_item and gipi_itmperil does not tally.'||
                       ' Please call your database administrator.';
       ELSIF v_prem_amt <> v2_prem_amt THEN
          v_message :='The premium amounts in gipi_item and gipi_itmperil does not tally.'||
                      ' Please call your database administrator.';
       END IF;

     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_message := 'There are no records retrieved from gipi_item '||
                      'and gipi_itmperil for policy_id '||TO_CHAR(p_policy_id)||
                      '. Please call your database administrator.';
       WHEN OTHERS THEN
         v_message := 'Other exceptions';
     END;
  ELSE
     BEGIN
       v_exist := 'N';
       FOR c1 IN (  SELECT SUM(tsi_amt)     tsi_amt     ,
                           SUM(prem_amt)    prem_amt    ,
                           SUM(ann_tsi_amt) ann_tsi_amt ,
                           pack_line_cd
                      FROM GIPI_ITEM
                     WHERE policy_id = p_policy_id
                  GROUP BY pack_line_cd)
       LOOP
         v_tsi_amt     := c1.tsi_amt;
         v_prem_amt    := c1.prem_amt; 
         v_ann_tsi_amt := c1.ann_tsi_amt;
         FOR c2 IN (SELECT  SUM(a.tsi_amt)     tsi_amt,
                            SUM(a.ann_tsi_amt) ann_tsi_amt
                      FROM  GIPI_ITMPERIL a, GIPI_ITEM b
                     WHERE  EXISTS
                           (SELECT 1
                              FROM GIIS_PERIL c
                             WHERE c.peril_type = 'B'
                               AND c.peril_cd   = a.peril_cd
                               AND c.line_cd    = c1.pack_line_cd)
                       AND  a.item_no      = b.item_no
                       AND  a.policy_id    = b.policy_id
                       AND  b.pack_line_cd = c1.pack_line_cd 
                       AND  a.policy_id    = p_policy_id)
         LOOP
           v_exist := 'Y';
           v2_tsi_amt     := c2.tsi_amt;
           v2_ann_tsi_amt := c2.ann_tsi_amt;
           EXIT;
         END LOOP;
         IF v_exist = 'N' THEN
            EXIT;
         END IF;
         v3_tsi_amt     := NVL(v3_tsi_amt, 0)     + NVL(v_tsi_amt, 0);
         v3_prem_amt    := NVL(v3_prem_amt, 0)    + NVL(v_prem_amt, 0);
         v3_ann_tsi_amt := NVL(v3_ann_tsi_amt, 0) + v_ann_tsi_amt;
         v4_tsi_amt     := NVL(v4_tsi_amt, 0)     + v2_tsi_amt;
         v4_ann_tsi_amt := NVL(v4_ann_tsi_amt, 0) + v2_ann_tsi_amt;
       END LOOP;
       IF v_exist = 'N' THEN
          RAISE NO_DATA_FOUND;
       END IF;
       v_exist := 'N';
       FOR c1 IN (SELECT SUM(prem_amt) prem_amt
                    FROM GIPI_ITMPERIL
                   WHERE policy_id = p_policy_id)
       LOOP
         v_exist := 'Y';
         v4_prem_amt := c1.prem_amt;
         EXIT;
       END LOOP;
       IF v_exist = 'N' THEN
          RAISE NO_DATA_FOUND;
       END IF;
       IF v3_tsi_amt <> v4_tsi_amt THEN
          v_message := 'The total sum insured in gipi_item and gipi_itmperil does not tally.'||
                       ' Please call your database administrator.';
       ELSIF v3_prem_amt <> v4_prem_amt THEN
          v_message := 'The premium amounts in gipi_item and gipi_itmperil does not tally.'||
                       ' Please call your database administrator.';
       END IF;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_message := 'There are no records retrieved from gipi_item '||
                      'and gipi_itmperil for policy_id '||TO_CHAR(p_policy_id)||
                      '. Please call your database administrator.';
       WHEN OTHERS THEN
         v_message := 'Other exceptions';
     END;
  END IF;
    p_message := v_message;
END;
/


