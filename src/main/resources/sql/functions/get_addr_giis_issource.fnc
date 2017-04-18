DROP FUNCTION CPI.GET_ADDR_GIIS_ISSOURCE;

CREATE OR REPLACE FUNCTION CPI.get_addr_giis_issource (
   p_iss_cd   giis_issource.iss_cd%TYPE
  )
  RETURN VARCHAR2
  IS
  v_address  VARCHAR2(2000);
  
  BEGIN
    SELECT decode(address1,null,
           decode(address2,null,
           decode(address3,null,null,address3),
                          address2||' '||decode(address3,null,null,address3)),
                          address1||' '||decode(address2,null,
           decode(address3,null,null,address3),
                          address2||' '||decode(address3,null,null,address3)))
      INTO v_address
      FROM giis_issource
     WHERE iss_cd = p_iss_cd;
  RETURN v_address;
  END;
/


