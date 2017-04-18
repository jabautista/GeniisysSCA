SET SERVEROUTPUT ON

DECLARE
   v_exists   NUMBER (1) := 0;
BEGIN
   FOR i IN (SELECT DISTINCT 1 rec
                        FROM all_tables
                       WHERE owner = 'CPI'
                         AND table_name = 'GIIS_TARIFF_GROUP')
   LOOP
      v_exists := i.rec;
   END LOOP;

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line ('Table giis_tariff_group already exists.');
   ELSE
      EXECUTE IMMEDIATE (   'CREATE TABLE CPI.GIIS_TARIFF_GROUP '
                         || '( '
                         || 'tariff_cd             VARCHAR2(1 BYTE), '
                         || 'tariff_grp_desc       VARCHAR2(100 BYTE), '
                         || 'user_id             VARCHAR2(8 BYTE), '
                         || 'last_update             DATE '
                         || ') '
                         || 'TABLESPACE maintenance_data '
                         || 'PCTUSED    0 '
                         || 'PCTFREE    10 '
                         || 'INITRANS   1 '
                         || 'MAXTRANS   255 '
                         || 'STORAGE    ( '
                         || 'INITIAL          64 k '
                         || 'MINEXTENTS       1 '
                         || 'MAXEXTENTS       UNLIMITED '
                         || 'PCTINCREASE      0 '
                         || 'BUFFER_POOL      DEFAULT '
                         || ') '
                         || 'LOGGING '
                         || 'NOCOMPRESS '
                         || 'NOCACHE '
                         || 'NOPARALLEL '
                         || 'MONITORING'
                        );

      EXECUTE IMMEDIATE (   'CREATE UNIQUE INDEX cpi.giis_tariff_group_pk ON cpi.giis_tariff_group '
                         || '(tariff_cd) '
                         || 'LOGGING '
                         || 'TABLESPACE INDEXES '
                         || 'PCTFREE    10 '
                         || 'INITRANS   2 '
                         || 'MAXTRANS   255 '
                         || 'STORAGE    ( '
                         || 'INITIAL          64 k '
                         || 'MINEXTENTS       1 '
                         || 'MAXEXTENTS       UNLIMITED '
                         || 'PCTINCREASE      0 '
                         || 'BUFFER_POOL      DEFAULT '
                         || ') '
                         || 'NOPARALLEL '
                        );

      EXECUTE IMMEDIATE (   'CREATE UNIQUE INDEX cpi.tariff_grp_uk ON cpi.giis_tariff_group '
                         || '(tariff_grp_desc) '
                         || 'LOGGING '
                         || 'TABLESPACE INDEXES '
                         || 'PCTFREE    10 '
                         || 'INITRANS   2 '
                         || 'MAXTRANS   255 '
                         || 'STORAGE    ( '
                         || 'INITIAL          64 k '
                         || 'MINEXTENTS       1 '
                         || 'MAXEXTENTS       UNLIMITED '
                         || 'PCTINCREASE      0 '
                         || 'BUFFER_POOL      DEFAULT '
                         || ') '
                         || 'NOPARALLEL '
                        );

      EXECUTE IMMEDIATE (   'ALTER TABLE cpi.giis_tariff_group ADD ( '
                         || 'CONSTRAINT giis_tariff_group_pk '
                         || 'PRIMARY KEY '
                         || '(tariff_cd) '
                         || 'USING INDEX '
                         || 'TABLESPACE INDEXES '
                         || 'PCTFREE    10 '
                         || 'INITRANS   2 '
                         || 'MAXTRANS   255 '
                         || 'STORAGE    ( '
                         || 'INITIAL          64 k '
                         || 'MINEXTENTS       1 '
                         || 'MAXEXTENTS       UNLIMITED '
                         || 'PCTINCREASE      0 '
                         || '), '
                         || 'CONSTRAINT tariff_grp_uk '
                         || 'UNIQUE '
                         || '(tariff_grp_desc) '
                         || 'USING INDEX '
                         || 'TABLESPACE INDEXES '
                         || 'PCTFREE    10 '
                         || 'INITRANS   2 '
                         || 'MAXTRANS   255 '
                         || 'STORAGE    ( '
                         || 'INITIAL          64 k '
                         || 'MINEXTENTS       1 '
                         || 'MAXEXTENTS       UNLIMITED '
                         || 'PCTINCREASE      0 '
                         || ')) '
                        );

      EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM giis_tariff_group FOR cpi.giis_tariff_group');

      DBMS_OUTPUT.put_line ('Created giis_tariff_group.');
   END IF;
END;