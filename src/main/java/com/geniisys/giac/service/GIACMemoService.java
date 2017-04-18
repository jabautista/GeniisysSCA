package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.entity.GIACMemo;

public interface GIACMemoService {
	
	public GIACMemo getDefaultMemo() throws SQLException;
	public GIACMemo saveMemo(HttpServletRequest request,GIISUser USER) throws SQLException, Exception;
	Integer getNextTranId() throws SQLException;
	//public List<GIACMemo> getMemoList(HttpServletRequest request) throws SQLException, JSONException;
	public GIACMemo getMemoInfo(Map<String, Object> params) throws SQLException;
	
	public String getClosedTag(Map<String, Object> params) throws SQLException;
	
	public String cancelMemo(Map<String, Object> params) throws SQLException, Exception;
	
	public void updateMemoStatus(Map<String, Object> params) throws SQLException, Exception;
	public String validateCurrSname(String currSname) throws SQLException;
}
