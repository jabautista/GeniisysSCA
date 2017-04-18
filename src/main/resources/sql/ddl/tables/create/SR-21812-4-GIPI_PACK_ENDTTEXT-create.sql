SET SERVEROUTPUT ON;

DECLARE
    v_tab_exists NUMBER(1) := 0;
BEGIN
    SELECT 1
      INTO v_tab_exists
      FROM all_tables
     WHERE table_name = 'GIPI_PACK_ENDTTEXT'
       AND owner = 'CPI';
    
    DBMS_OUTPUT.PUT_LINE('GIPI_PACK_ENDTTEXT table already exists in CPI schema');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        EXECUTE IMMEDIATE('
            CREATE TABLE CPI.GIPI_PACK_ENDTTEXT(
                pack_policy_id      NUMBER(12) NOT NULL,
                endt_tax            VARCHAR2(1),
                endt_text01         VARCHAR2(2000),
                endt_text02         VARCHAR2(2000),
                endt_text03         VARCHAR2(2000),
                endt_text04         VARCHAR2(2000),
                endt_text05         VARCHAR2(2000),
                endt_text06         VARCHAR2(2000),
                endt_text07         VARCHAR2(2000),
                endt_text08         VARCHAR2(2000),
                endt_text09         VARCHAR2(2000),
                endt_text10         VARCHAR2(2000),
                endt_text11         VARCHAR2(2000),
                endt_text12         VARCHAR2(2000),
                endt_text13         VARCHAR2(2000),
                endt_text14         VARCHAR2(2000),
                endt_text15         VARCHAR2(2000),
                endt_text16         VARCHAR2(2000),
                endt_text17         VARCHAR2(2000),
                endt_cd             VARCHAR2(4),
                user_id             VARCHAR2(8),
                last_update         DATE
            )
            TABLESPACE  MAIN_DATA
            PCTUSED     0
            PCTFREE     10
            INITRANS    1
            MAXTRANS    255
            STORAGE     (
                         INITIAL        128K
                         NEXT           128K
                         MINEXTENTS     1
                         MAXEXTENTS     UNLIMITED
                         PCTINCREASE    0
                         BUFFER_POOL    DEFAULT
                        )
            LOGGING
            NOCOMPRESS
            NOCACHE
            NOPARALLEL
            MONITORING
        ');
        
        EXECUTE IMMEDIATE('CREATE OR REPLACE PUBLIC SYNONYM GIPI_PACK_ENDTTEXT FOR CPI.GIPI_PACK_ENDTTEXT');
        
    DBMS_OUTPUT.PUT_LINE('GIPI_PACK_ENDTTEXT table is successfully created');
END;
