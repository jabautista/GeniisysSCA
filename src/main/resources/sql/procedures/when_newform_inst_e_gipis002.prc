DROP PROCEDURE CPI.WHEN_NEWFORM_INST_E_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.When_Newform_Inst_E_Gipis002
   (b240_iss_cd IN VARCHAR2,
    var IN OUT VARCHAR2) IS    
BEGIN
  FOR sw IN (SELECT cred_br_tag
        FROM GIIS_ISSOURCE
       WHERE iss_cd = b240_iss_cd)
 LOOP
  var := sw.cred_br_tag;
  EXIT;
 END LOOP;
END;
/


