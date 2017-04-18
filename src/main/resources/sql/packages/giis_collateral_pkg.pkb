CREATE OR REPLACE PACKAGE BODY CPI.GIIS_COLLATERAL_PKG AS

  FUNCTION get_collateral_dtl (p_par_id GIPI_COLL_PAR.par_id%TYPE)
    RETURN  collateral_tab PIPELINED
    IS 
    v_coll    collateral_type;
  BEGIN 
  FOR i IN(SELECT GCB.coll_type,
                  GCB.collateral_desc,
                  GCP.collateral_val,
                  to_char(GCP.receive_date, 'MM-DD-YYYY') rev_date,
                  GCB.collateral_id
             FROM GIIS_COLL_BONDS GCB, 
                  GIPI_COLL_PAR GCP,
                  GIIS_COLL_DTL GCD
            WHERE GCP.par_id = p_par_id
              AND GCB.collateral_id = GCP.collateral_id
              AND GCB.collateral_id = GCD.collateral_id)
    LOOP 
        v_coll.coll_type        :=i.coll_type;
        v_coll.coll_desc        :=i.collateral_desc;
        v_coll.coll_value       :=i.collateral_val;
        v_coll.rev_date         :=i.rev_date;
        v_coll.coll_id          :=i.collateral_id;
        PIPE ROW (v_coll);
    END LOOP;
    
    
  END get_collateral_dtl;
  
  
  FUNCTION get_lov_coll_type
    RETURN lov_coll_tab PIPELINED
    IS
    lov_coll    lov_coll_type;
  BEGIN
  FOR i IN(SELECT coll_type,
                  coll_name
             FROM GIIS_COLLATERAL_TYPE)
    LOOP
        lov_coll.coll_type      :=i.coll_type;
        lov_coll.coll_name      :=i.coll_name;
        PIPE ROW (lov_coll);
    END LOOP;
  END get_lov_coll_type;  
    
  
  FUNCTION get_lov_coll_desc(p_coll_type giis_coll_bonds.coll_type%TYPE)
    RETURN lov_coll2_tab PIPELINED
    IS
    lov_coll2   lov_coll2_type;
    BEGIN
       FOR i IN (SELECT   a.collateral_id, a.collateral_desc, a.collateral_val,
                          b.rev_date, a.coll_type
                     FROM giis_coll_bonds a, giis_coll_dtl b
                    WHERE a.collateral_id = b.collateral_id
                      AND coll_type = p_coll_type
                 GROUP BY a.collateral_id,
                          a.collateral_desc,
                          a.collateral_val,
                          b.rev_date,
                          a.coll_type)
       LOOP
          lov_coll2.coll_type := i.coll_type;
          lov_coll2.coll_desc := i.collateral_desc;
          lov_coll2.coll_val := i.collateral_val;
          lov_coll2.rev_date := TO_CHAR (i.rev_date, 'MM-DD-YYYY');
          lov_coll2.coll_id := i.collateral_id;
          PIPE ROW (lov_coll2);
       END LOOP;
    END get_lov_coll_desc;
        
END;
/


