package com.geniisys.giex.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.giex.entity.GIEXLine;
import com.ibm.disthub2.impl.matching.selector.ParseException;

public interface GIEXPerilDepreciationService {
	List<GIEXLine> getLineList() throws SQLException, IOException;
	JSONObject  getPerilList(HttpServletRequest request) throws JSONException, SQLException, IOException;
	String savePerilDep(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException;
	String validateAddPerilCd(HttpServletRequest request) throws JSONException, SQLException, ParseException;
}
