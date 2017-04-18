package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACDocSequenceUserDAO {

	void saveGiacs316(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void valMinSeqNo(Map<String, Object> params) throws SQLException;
	void valMaxSeqNo(Map<String, Object> params) throws SQLException;
	void valActiveTag(Map<String, Object> params) throws SQLException;
}
