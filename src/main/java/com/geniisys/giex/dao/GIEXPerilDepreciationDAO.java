package com.geniisys.giex.dao;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giex.entity.GIEXLine;

public interface GIEXPerilDepreciationDAO {
	List<GIEXLine> getLineList() throws SQLException, IOException;
	String savePerilDepreciation(Map<String, Object> allParams) throws SQLException;
	String validateAddPerilCd(Map<String, Object> params) throws SQLException;
}
