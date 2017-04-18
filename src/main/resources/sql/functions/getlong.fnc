DROP FUNCTION CPI.GETLONG;

CREATE OR REPLACE FUNCTION CPI.getlong (
   p_tname   IN   VARCHAR2,
   p_cname   IN   VARCHAR2,
   p_rowid   IN   ROWID,
   p_length  IN   NUMBER,
   p_startin IN   NUMBER
)
   RETURN VARCHAR2
AS
   l_cursor     INTEGER         DEFAULT DBMS_SQL.OPEN_CURSOR;
   l_n          NUMBER;
   l_long_val   VARCHAR2 (4000);
   l_long_len   NUMBER;
   l_buflen     NUMBER          := p_length;
   l_curpos     NUMBER          := p_startin;
BEGIN
   DBMS_SQL.PARSE (l_cursor,
                      'SELECT '
                   || p_cname
                   || ' FROM '
                   || p_tname
                   || ' WHERE ROWID = :X',
                   DBMS_SQL.native
                  );
   DBMS_SQL.BIND_VARIABLE (l_cursor, ':X', p_rowid);
   DBMS_SQL.DEFINE_COLUMN_LONG (l_cursor, 1);
   l_n := DBMS_SQL.EXECUTE (l_cursor);

   IF (DBMS_SQL.FETCH_ROWS (l_cursor) > 0)
   THEN
      DBMS_SQL.COLUMN_VALUE_LONG (l_cursor,
                                  1,
                                  l_buflen,
                                  l_curpos,
                                  l_long_val,
                                  l_long_len
                                 );
   END IF;

   DBMS_SQL.CLOSE_CURSOR (l_cursor);
   RETURN l_long_val;
END getlong;
/


