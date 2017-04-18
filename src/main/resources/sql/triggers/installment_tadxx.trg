DROP TRIGGER CPI.INSTALLMENT_TADXX;

CREATE OR REPLACE TRIGGER CPI.INSTALLMENT_TADXX
AFTER DELETE ON CPI.GIPI_INSTALLMENT FOR EACH ROW
BEGIN
  IF DELETING THEN
     IF :OLD.iss_cd <> Giacp.v('RI_ISS_CD') THEN
        -- Added by Marvin 03.06.12
        DELETE
           FROM giac_aging_fc_soa_details
          WHERE iss_cd = :OLD.iss_cd
            AND prem_seq_no = :OLD.prem_seq_no
            AND inst_no = :OLD.inst_no;
            
        DELETE GIAC_AGING_SOA_DETAILS
         WHERE iss_cd      = :OLD.iss_cd
           AND prem_seq_no = :OLD.prem_seq_no
           AND inst_no     = :OLD.inst_no;
           
        /* Added by    : Edison
        ** Date added  : 12.11.12
        ** Description : To delete first the record in giac_aging_fc_soa_details
        **               to avoid getting user defined ORA-20021 (duplicate record).*/
        /* Moved by    : Marvin
        ** Date added  : 03.06.12
        ** Description : To avoid ORA-02292 Constraint violation - child records found.*/
        /*
         DELETE
           FROM giac_aging_fc_soa_details
          WHERE iss_cd = :OLD.iss_cd
            AND prem_seq_no = :OLD.prem_seq_no
            AND inst_no = :OLD.inst_no;
        --end 12.11.12
        */
     ELSIF :OLD.iss_cd = Giacp.v('RI_ISS_CD') THEN
        DELETE GIAC_AGING_RI_SOA_DETAILS
         WHERE prem_seq_no = :OLD.prem_seq_no
           AND inst_no     = :OLD.inst_no;
     END IF;
  END IF;
END;
/


