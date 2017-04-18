DROP PROCEDURE CPI.GIEXS007_VALIDATE_ITMPERL;

CREATE OR REPLACE PROCEDURE CPI.GIEXS007_validate_itmperl(
                           p_policy_id    IN    NUMBER,  
                           p_item_no      IN    NUMBER, 
                           p_line_cd      IN    VARCHAR2,
                           p_peril_cd     IN    NUMBER,
                           p_peril_type   IN    VARCHAR2,
                           p_basc_perl_cd IN    NUMBER,
                           p_tsi_amt      IN    NUMBER,
                           p_prem_amt     IN    NUMBER,
                           p_msg          OUT   VARCHAR2
                           ) IS
   cnt_itmperl    NUMBER:=0;
   max_tsi        NUMBER;
   dum_tsi        NUMBER;
   dum_prem       NUMBER;
   p_tsi          NUMBER;
   p_prem         NUMBER;
   p_type         VARCHAR2(1);
   p_peril        NUMBER;
   p_line         VARCHAR2(8);
   p_basc         NUMBER;
   p_exist        VARCHAR2(1):='N';
   rg_peril       VARCHAR2(30):=NULL;   
BEGIN 
   SELECT COUNT(*)
    INTO cnt_itmperl
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
       IF p_peril_type='A' THEN
         IF ((NVL(cnt_itmperl,0)=0) AND (p_basc_perl_cd IS NULL)) THEN
              p_msg:='A basic peril must be added before this peril';
          ELSIF ((NVL(cnt_itmperl,0)=0) AND (p_basc_perl_cd IS NOT NULL)) THEN
              FOR perl IN (SELECT    peril_name
                             FROM    giis_peril
                            WHERE    line_cd   =  p_line_cd
                              AND    peril_cd  =  p_basc_perl_cd) LOOP
                      p_msg:='Basic peril '||perl.peril_name||' must be added first '||
                                'before this peril.';     
              END LOOP;
          END IF;
          IF p_basc_perl_cd IS NULL THEN
            FOR a IN 1..cnt_itmperl LOOP
               p_tsi   :=  itmperl.tsi_amt;
               p_prem  :=  itmperl.prem_amt;
               p_type  :=  itmperl.peril_type;
               IF NVL(p_type,'B')='B' THEN
                 IF dum_tsi IS NULL THEN
                   dum_tsi := NVL(p_tsi,0);
                 END IF;
                 IF dum_prem IS NULL THEN
                   dum_prem := NVL(p_prem,0);
                 END IF;
                 IF NVL(p_tsi,0) > dum_tsi THEN
                   dum_tsi := NVL(p_tsi,0);
                 END IF;
                 IF NVL(p_prem,0) > dum_prem THEN
                   dum_prem:= NVL(p_prem,0);
                 END IF;
               END IF;
               p_exist := 'Y';
            END LOOP;
            IF p_tsi_amt > dum_tsi THEN   
               p_msg:= 'TSI amount of this peril should be less than '||
                         LTRIM(to_char(dum_tsi,'99,999,999,999,990.90'))||'.';
            END IF;
          ELSE
            FOR a IN 1..cnt_itmperl LOOP
               p_tsi   :=  itmperl.tsi_amt;
               p_prem  :=  itmperl.prem_amt;
               p_type  :=  itmperl.peril_type;
               p_peril :=  itmperl.peril_cd;
               p_line  :=  itmperl.line_cd;
               IF ((p_basc_perl_cd = p_peril) AND (p_line = p_line_cd)) THEN
                  IF p_tsi_amt > NVL(p_tsi,0) THEN
                    p_msg:= 'TSI amount must be less than '||
                               LTRIM(to_char(p_tsi,'99,999,999,999,990.90'))||'.';
                  END IF;
                  p_exist :=  'Y';
               END IF;
            END LOOP;
          END IF;
          IF p_exist != 'Y' THEN
             p_msg:= 'A basic peril should exists before any peril can be added';
          END IF;
       END IF;
   END LOOP;
END;
/


