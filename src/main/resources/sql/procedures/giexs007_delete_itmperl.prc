DROP PROCEDURE CPI.GIEXS007_DELETE_ITMPERL;

CREATE OR REPLACE PROCEDURE CPI.GIEXS007_delete_itmperl(
                           p_policy_id    IN    NUMBER,  
                           p_item_no      IN    NUMBER, 
                           p_line_cd      IN    VARCHAR2,
                           p_peril_cd     IN    NUMBER,
                           p_peril_type   IN    VARCHAR2,
                           p_basc_perl_cd IN    NUMBER,
                           p_msg          OUT   VARCHAR2) IS
     cnt            NUMBER;
     cnt2           NUMBER;
     cnt_basic      NUMBER  := 0;
     p_peril        NUMBER;
     p_line         VARCHAR2(20);
     max_peril      gipi_witmperl.peril_cd%TYPE;
     max_tsi        NUMBER;
     p_tsi          NUMBER;
     p_perl_type    VARCHAR2(5);
     p_basic        NUMBER;
     p_item         NUMBER;
     p_exist        VARCHAR2(1) := 'N';
     p_cnt          NUMBER;
     p_allied       VARCHAR2(1) := 'N';
     peril_line     VARCHAR2(2);
     peril_peril    NUMBER;
     p_allied_peril NUMBER;
    
BEGIN
   SELECT COUNT(*)
    INTO cnt
      FROM giex_itmperil a, giis_peril b
     WHERE a.line_cd = b.line_cd
       AND a.peril_cd = b.peril_cd
       AND a.policy_id = p_policy_id
       AND a.item_no = p_item_no;
  
   FOR itmperl IN (SELECT a.line_cd line_cd, a.peril_cd peril_cd, a.tsi_amt tsi_amt,
                   a.prem_amt prem_amt, b.peril_type peril_type,
                   b.basc_perl_cd basc_perl_cd, a.policy_id policy_id, a.item_no item_no,
                   a.ann_tsi_amt ann_tsi, a.ann_prem_amt ann_prem
              FROM giex_itmperil a, giis_peril b
             WHERE a.line_cd = b.line_cd
               AND a.peril_cd = b.peril_cd
               AND a.policy_id = p_policy_id
               AND a.item_no = p_item_no)
   LOOP 
       IF p_peril_type = 'B' THEN
          FOR a IN REVERSE 1..cnt LOOP
              p_peril      :=  itmperl.peril_cd;
              p_tsi        :=  itmperl.ann_tsi;
              p_line       :=  itmperl.line_cd;
              p_perl_type  :=  itmperl.peril_type;
              p_basic      :=  itmperl.basc_perl_cd;
              p_item       :=  itmperl.item_no;
              IF ((p_peril=p_peril_cd) AND (p_line=p_line_cd) AND (p_item=p_item_no)) THEN
                 p_exist     := 'Y';
                 p_cnt       := a;
                 peril_peril := p_peril;
                 peril_line  := p_line; 
              END IF;
              IF p_perl_type = 'A' and p_basic is null  AND nvl(p_tsi,0) > 0 THEN
                 p_allied_peril  :=  p_peril;
              END IF;
              IF p_perl_type = 'A' and nvl(p_tsi,0) > 0 
                   AND  NVL(max_tsi,0) < p_tsi THEN
                         max_tsi   :=  p_tsi;
                         max_peril :=  p_peril;
              END IF;
              
              IF ((p_perl_type='A') AND (p_basic=p_peril_cd)) and nvl(p_tsi, 0) > 0 THEN
                 FOR A IN (SELECT peril_name
                             FROM giis_peril
                            WHERE line_cd  =  p_line
                              AND peril_cd =  p_peril) LOOP
                     p_msg:='The peril '''||A.peril_name||''' must be deleted first.';
                     p_allied    :=  'Y';
                     EXIT;
                 END LOOP;
              END IF;
          END LOOP;
          IF p_allied_peril is not null THEN
             FOR a IN REVERSE 1..cnt LOOP
                  p_peril      :=  itmperl.peril_cd;
                  p_tsi        :=  itmperl.ann_tsi;
                  p_line       :=  itmperl.line_cd;
                  p_perl_type  :=  itmperl.peril_type;
                  p_basic      :=  itmperl.basc_perl_cd;
                  p_item       :=  itmperl.item_no;
                 IF P_PERL_TYPE = 'B' AND P_PERIL != P_PERIL_CD AND
                    NVL(P_TSI,0) >= NVL(MAX_TSI,0) THEN
                    cnt_basic := cnt_basic  + 1;
                 END IF;
             END LOOP;
             IF cnt_basic = 0 then
                  FOR A IN (SELECT peril_name
                              FROM giis_peril
                             WHERE line_cd  =  p_line_CD
                               AND peril_cd =  max_peril) LOOP
                       p_msg:='The peril '''||A.peril_name||''' must be deleted first.';
                      p_allied    :=  'Y';
                      EXIT;
                  END LOOP;
             END IF;
          END IF;
       END IF;
   END LOOP;         
END;
/


