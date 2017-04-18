package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACMemo;

public interface GIACMemoDAO {

	public GIACMemo getDefaultMemo() throws SQLException;
	//public void saveMemo(Map<String, Object> params) throws SQLException;
	public GIACMemo saveMemo(Map<String, Object> params) throws SQLException, Exception;
	//public Integer saveMemo(GIACMemo memo) throws SQLException;
	Integer getNextTranId() throws SQLException;
	List<GIACMemo> getMemoList(Map<String, Object> params) throws SQLException;
	public GIACMemo getMemoInfo(Map<String, Object> params) throws SQLException; 
	
	public String getClosedTag(Map<String, Object> params) throws SQLException;
	
	public String cancelMemo(Map<String, Object> params) throws SQLException, Exception;
	
	public void updateMemoStatus(Map<String, Object> params) throws SQLException, Exception;
	public String validateCurrSname(String currSname) throws SQLException;
}
