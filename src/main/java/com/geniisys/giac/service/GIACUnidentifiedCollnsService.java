package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACUnidentifiedCollns;

public interface GIACUnidentifiedCollnsService{
	PaginatedList getOldItemList(Map<String, Object> params, Integer pageNo) throws SQLException;
	PaginatedList searchOldItemList(Map<String, Object> params, Integer pageNo) throws SQLException;
	public List<GIACUnidentifiedCollns> getUnidentifiedCollnsListing(Map<String, Object> params) throws SQLException;
	public boolean saveUnidentifiedCollnsDtls(Map<String, Object> params) throws Exception;
	public String validateItemNo(Map<String, Object> parameters) throws SQLException;
	public String validateOldTranNo(Map<String, Object> params) throws SQLException;
	public String validateOldItemNo(Map<String, Object> params) throws SQLException;
	public void validateDelRec(Map<String, Object> params) throws Exception;	// shan 10.30.2013
}
