package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISISSource;
import com.geniisys.common.entity.GIISLine;
import com.geniisys.common.entity.GIISUser;

public interface GIISUserDAO {

	void saveGiiss040(Map<String, Object> params) throws Exception;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(String recId) throws SQLException;
	void saveGiiss040Tran(Map<String, Object> params) throws Exception;
	void saveGiiss040UserModules(Map<String, Object> params) throws SQLException;
	void checkAllUserModule(Map<String, Object> params) throws SQLException;
	void uncheckAllUserModule(Map<String, Object> params) throws SQLException;
	List<GIISISSource> includeAllIssCodes() throws SQLException;
	List<GIISLine> includeAllLineCodes() throws SQLException;
	Map<String, Object> whenNewFormInstance() throws SQLException;
	void valDeleteRecTran1(Map<String, Object> params) throws SQLException;
	void valDeleteRecTran1Line(Map<String, Object> params) throws SQLException;
	GIISUser getUserDetails(String userId) throws SQLException;
}
