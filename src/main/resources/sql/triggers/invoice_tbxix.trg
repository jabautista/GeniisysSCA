DROP TRIGGER CPI.INVOICE_TBXIX;

CREATE OR REPLACE TRIGGER CPI.INVOICE_TBXIX
  BEFORE INSERT
  ON CPI.GIPI_INVOICE   FOR EACH ROW
DECLARE
  v_prem_seq   gipi_invoice.prem_seq_no%TYPE;
  v_pack       gipi_polbasic.pack_policy_id%TYPE;
  v_par_id     gipi_polbasic.par_id%TYPE;
BEGIN
  v_prem_seq := NULL;

  /* petermkaw 05072010
  ** added if condition to update the prem_seq_no in the table giis_prem_seq
  ** only if the record to be entered is not in a package policy. package
  ** policies does not take into account long term take-ups as of today.
  ** validation if the record is part of a package policy or not is done
  ** through the select into statement.
  */
  SELECT pack_policy_id, par_id
    INTO v_pack, v_par_id
    FROM gipi_polbasic
   WHERE policy_id = :NEW.policy_id;




  IF v_pack IS NULL
  /* petermkaw 05072010
  ** if the record is not part of a package policy, then the old trigger
  ** will be executed.
  */
  THEN
    FOR a IN (SELECT        prem_seq_no, ROWID
                       FROM giis_prem_seq
                      WHERE iss_cd = :NEW.iss_cd
              FOR UPDATE OF prem_seq_no)
    LOOP
      v_prem_seq := NVL (a.prem_seq_no, 0) + 1;

      BEGIN
        UPDATE giis_prem_seq
           SET prem_seq_no = v_prem_seq
         WHERE ROWID = a.ROWID;
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
          raise_application_error (-200001, 'Duplicate record in GIIS_PREM_SEQ found.');
      END;

      :NEW.prem_seq_no := v_prem_seq;
      EXIT;
    END LOOP;

    IF v_prem_seq IS NULL
    THEN
      BEGIN
        INSERT INTO giis_prem_seq
                    (iss_cd, prem_seq_no
                    )
             VALUES (:NEW.iss_cd, 1
                    );
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
          raise_application_error (-200001, 'Duplicate record in GIIS_PREM_SEQ found.');
      END;
    END IF;
  /* petermkaw 05072010
  ** else condition created to accomodate records under package policies
  */
  ELSE
    FOR y IN
      (SELECT   prem_seq_no
           FROM giis_pack_prem_seq_temp
          WHERE par_id = v_par_id AND item_grp = :NEW.item_grp AND iss_cd = :NEW.iss_cd
       ORDER BY /*ROW_ID*/ prem_seq_no DESC)   /* petermkaw 06222010 changed to prem_seq_no from ROW_ID */
    LOOP
      :NEW.prem_seq_no := y.prem_seq_no;
      EXIT;
    END LOOP;
  END IF;
  
    /********************
   Modifications 
     Edward Barroso 07242014
              Added generation of check digit
   *********************/
   :NEW.ref_inv_no := pkg_check_digit.generate(:NEW.iss_cd ,:NEW.prem_seq_no, :NEW.DUE_DATE) ;   
   /***************************************/
END;
/


