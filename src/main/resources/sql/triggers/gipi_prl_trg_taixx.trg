DROP TRIGGER CPI.GIPI_PRL_TRG_TAIXX;

CREATE OR REPLACE TRIGGER CPI.GIPI_PRL_TRG_TAIXX
AFTER INSERT ON CPI.GIPI_COMM_INV_PERIL REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
--
-- Inserts into or updates giac_parent_comm_invoice
-- and giac_parent_comm_invprl to compute overriding commission
-- for a given parent intermediary.
--
-- TABLES AFFECTED      TRANSACTION TYPE COLUMNS
--
-- giac_parent_comm_invprl  insert  all
--
-- giac_parent_comm_invoice update/insert premium_amt
--           commission_amt
--           wholding_tax
--
  v_comm_rt           GIIS_INTM_TYPE_COMRT.comm_rate%TYPE:=0;
  v_commission        GIAC_PARENT_COMM_INVOICE.COMMISSION_AMT%TYPE;
  v_intm              GIIS_INTM_SPECIAL_RATE.intm_no%TYPE;
  v_chld_intm_no      GIAC_PARENT_COMM_INVPRL.chld_intm_no%TYPE;
  v_tax_rt            GIIS_INTERMEDIARY.wtax_rate%TYPE;
  v_tax               GIAC_PARENT_COMM_INVOICE.WHOLDING_TAX%TYPE;
  v_prev_intm         GIIS_INTERMEDIARY.INTM_NO%TYPE;
  v_corp_tag          GIIS_INTERMEDIARY.CORP_TAG%TYPE;
  v_co_type           GIIS_INTERMEDIARY.CO_INTM_TYPE%TYPE;
  v_typ               GIIS_INTERMEDIARY.CO_INTM_TYPE%TYPE;
  v_pin               GIIS_INTERMEDIARY.intm_no%TYPE;
  v_tag               GIIS_INTERMEDIARY.corp_tag%TYPE;
  v_switch            NUMBER(1);

  CURSOR kim_trg IS
         SELECT a.intm_no,a.iss_cd,b.line_cd,b.subline_cd,a.peril_cd,a.override_tag
           FROM giis_intm_special_rate a,
                gipi_polbasic b,
                gipi_invoice c
          WHERE b.policy_id    = c.policy_id
            AND c.iss_cd       = :NEW.iss_cd
            AND c.prem_seq_no  = :NEW.prem_seq_no
            AND a.intm_no      = :NEW.intrmdry_intm_no
            AND a.iss_cd       = :NEW.iss_cd
            AND a.peril_cd     = :NEW.peril_cd
            AND a.line_cd      = b.line_cd -- added by jeannette 0906
            AND a.subline_cd   = b.subline_cd -- added by rj 01/26/2000
            AND a.override_tag = 'Y';
BEGIN
  v_chld_intm_no:=:NEW.intrmdry_intm_no;
  
  FOR gip_trg IN kim_trg LOOP
    IF gip_trg.override_tag IS NOT NULL THEN
      FOR i IN (SELECT a.co_intm_type typ,
                       b.intm_no no,
                       b.intm_name name,
                       b.parent_intm_no pin,
                       a.intm_name parent,
                       b.corp_tag
                  FROM giis_intermediary a,
                       giis_intermediary b
                 WHERE a.intm_no = b.parent_intm_no
                   AND b.intm_no = :NEW.intrmdry_intm_no)
                   --AND b.iss_cd  = :NEW.iss_cd) -- grace 07.18.2005
                                                          -- should allow computation of overriding
                                                          -- commission for policies with different
                                                  -- issue source
      LOOP
        v_intm     := i.pin;
        v_corp_tag := i.corp_tag;
        v_co_type  := i.typ;
        
        WHILE v_intm IS NOT NULL LOOP
          v_switch := 0;
          -- Source of tax_rt from giis_intermediary instead from giac_parameters
          -- ModIFied for covenant and pfic by rj 01/27/2000
          FOR tx IN (SELECT wtax_rate
                       FROM giis_intermediary
                      WHERE intm_no = v_intm)
          LOOP
            v_tax_rt := tx.wtax_rate;
            EXIT;
          END LOOP;
          
          FOR a IN (SELECT a.intm_no,
                           a.iss_cd,
                           a.line_cd,
                           a.peril_cd,
                           a.comm_rate
                      FROM giis_spl_override_rt a,
                           giis_intermediary b
                     WHERE a.intm_no    = b.intm_no
                       AND b.intm_no    = v_intm
                       AND a.peril_cd LIKE :NEW.peril_cd
                       AND a.line_cd    = gip_trg.line_cd
                       AND a.subline_cd = gip_trg.subline_cd --j
                       AND a.iss_cd     = :NEW.iss_cd)
          LOOP
            v_comm_rt:= a.comm_rate;
            v_switch := 1;
            -- Source of tax_rt from giis_intermediary instead from giac_parameters
            -- ModIFied for covenant and pfic by rj 01/27/2000
            FOR tx IN (SELECT wtax_rate
                         FROM giis_intermediary
                        WHERE intm_no = v_intm)
            LOOP
              v_tax_rt := tx.wtax_rate;
              EXIT;
            END LOOP;
            
            -- START added by Jayson 10.19.2011 --
            IF :NEW.commission_rt = 0 THEN
              v_commission := 0;
              v_comm_rt    := 0;
            ELSE
            -- END added by Jayson 10.19.2011 --
              v_commission := ROUND((NVL(:NEW.premium_amt,0)*NVL(v_comm_rt,0))/100,2);
            END IF; -- added by Jayson 10.19.2011
            
            v_tax       :=ROUND((v_commission*v_tax_rt)/100,2);
            
            BEGIN
              INSERT INTO GIAC_PARENT_COMM_INVPRL
                (intm_no,                   chld_intm_no,
                iss_cd,                     prem_seq_no,
                peril_cd,                   premium_amt,
                commission_rt,              commission_amt,
                wholding_tax,               user_id,
                last_update)
              VALUES
                (v_intm,                    v_chld_intm_no,
                :NEW.iss_cd,                :NEW.prem_seq_no,
                :NEW.peril_cd,              :NEW.premium_amt,
                v_comm_rt,                  v_commission,
                v_tax,                      NVL (giis_users_pkg.app_user, USER),
                SYSDATE);
            EXCEPTION
              WHEN DUP_VAL_ON_INDEX THEN
                RAISE_APPLICATION_ERROR(-20019,'duplicate value on insert'||:NEW.ISS_CD||'-'||TO_CHAR(:NEW.PREM_SEQ_NO));
            END;
            
            BEGIN
              UPDATE GIAC_PARENT_COMM_INVOICE
                 SET premium_amt    = NVL(premium_amt,0) + NVL(:NEW.premium_amt,0),
                     commission_amt = NVL(commission_amt,0) + NVL(v_commission,0),
                     wholding_tax   = NVL(wholding_tax,0) + NVL(v_tax,0)
               WHERE intm_no      = v_intm
                 AND chld_intm_no = v_chld_intm_no
                 AND iss_cd       = :NEW.iss_cd
                 AND prem_seq_no  = :NEW.prem_seq_no;
                 
              IF SQL%NOTFOUND THEN
                INSERT INTO GIAC_PARENT_COMM_INVOICE
                  (intm_no,          chld_intm_no,
                   iss_cd,           prem_seq_no,
                   premium_amt,      commission_amt,
                   wholding_tax,     user_id,
                   last_update)
                VALUES
                  (v_intm,           v_chld_intm_no,
                   :NEW.iss_cd,      :NEW.prem_seq_no,
                   :NEW.premium_amt, v_commission,
                   v_tax,            NVL (giis_users_pkg.app_user, USER),
                   SYSDATE);
              END IF;  --sql
               
              v_commission:=0;
              v_tax:=0;
            END;
          END LOOP;    --a
          
          IF v_switch != 1 THEN
            FOR b IN (SELECT co_intm_type,iss_cd,line_cd,peril_cd,comm_rate
                        FROM giis_intm_type_comrt
                       WHERE co_intm_type = v_co_type
                         AND iss_cd     = :NEW.iss_cd
                         AND line_cd    = gip_trg.line_cd
                         AND subline_cd = gip_trg.subline_cd --J0316
                         AND peril_cd   = :NEW.peril_cd  )
            LOOP
              v_comm_rt    := b.comm_rate;
              
              -- START added by Jayson 10.19.2011 --
              IF :NEW.commission_rt = 0 THEN
                v_commission := 0;
                v_comm_rt    := 0;
              ELSE
              -- END added by Jayson 10.19.2011 --
                v_commission := ROUND((NVL(:NEW.premium_amt,0)*NVL(v_comm_rt,0))/100,2);
              END IF; -- added by Jayson 10.19.2011
                
              v_tax        := ROUND((v_commission*v_tax_rt)/100,2);
              
              BEGIN
                INSERT INTO GIAC_PARENT_COMM_INVPRL
                  (intm_no,                   chld_intm_no,
                  iss_cd,                     prem_seq_no,
                  peril_cd,                   premium_amt,
                  commission_rt,              commission_amt,
                  wholding_tax,               user_id,
                  last_update)
                VALUES
                  (v_intm,                    v_chld_intm_no,
                  :NEW.iss_cd,                :NEW.prem_seq_no,
                  :NEW.peril_cd,              :NEW.premium_amt,
                  v_comm_rt,                  v_commission,
                  v_tax,                      NVL (giis_users_pkg.app_user, USER),
                  SYSDATE);
              EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                  RAISE_APPLICATION_ERROR(-20019,'duplicate value on insert'||:NEW.ISS_CD||'-'||TO_CHAR(:NEW.PREM_SEQ_NO));
              END;
              
              BEGIN
                UPDATE GIAC_PARENT_COMM_INVOICE
                   SET premium_amt    = NVL(premium_amt,0) + NVL(:NEW.premium_amt,0),
                       commission_amt = NVL(commission_amt,0) + NVL(v_commission,0),
                       wholding_tax   = NVL(wholding_tax,0) + NVL(v_tax,0)
                 WHERE intm_no      = v_intm
                   AND chld_intm_no = v_chld_intm_no
                   AND iss_cd       = :NEW.iss_cd
                   AND prem_seq_no  = :NEW.prem_seq_no;
                 
                IF SQL%NOTFOUND THEN
                  INSERT INTO GIAC_PARENT_COMM_INVOICE
                    (intm_no,          chld_intm_no,
                     iss_cd,           prem_seq_no,
                     premium_amt,      commission_amt,
                     wholding_tax,     user_id,
                     last_update)
                  VALUES
                    (v_intm,           v_chld_intm_no,
                     :NEW.iss_cd,      :NEW.prem_seq_no,
                     :NEW.premium_amt, v_commission,
                     v_tax,            NVL (giis_users_pkg.app_user, USER),
                     SYSDATE);
                END IF;  --sql
                 
                v_commission:=0;
                v_tax:=0;
              END;
             END LOOP;   --b
          END IF;
         
          BEGIN
            SELECT a.co_intm_type,b.parent_intm_no,a.corp_tag
              INTO v_typ, v_pin, v_tag
              FROM giis_intermediary a,
                   giis_intermediary b
             WHERE a.intm_no =b.parent_intm_no
               AND b.intm_no = v_intm
               AND b.iss_cd  = :NEW.iss_cd;
            
            v_intm     := v_pin;
            v_corp_tag := v_tag;
            v_co_type  := v_typ;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
               v_intm := NULL;
          END;
        END LOOP;  --while
        
        v_prev_intm:=v_intm;
          
        IF v_comm_rt <> 0 THEN
          v_comm_rt := 0;
        ELSE
          v_comm_rt := NULL;
        END IF;
      END LOOP;    --i
    END IF;   --giptrg
  END LOOP;   --grp
END;
/


