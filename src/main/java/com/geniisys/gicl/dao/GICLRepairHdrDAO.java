/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.dao
	File Name: GICLRepairHdrDAO.java
	Author:f Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 27, 2012
	Description: 
*/


package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.entity.GICLRepairHdr;

public interface GICLRepairHdrDAO {
	GICLRepairHdr getRepairDtl(Integer evalId)throws SQLException;
	String getTinsmithAmount(Map<String, Object>params)throws SQLException;
	String getPaintingsAmount(String lossExpCd)throws SQLException;
	String validateBeforeSave(Map<String, Object>params) throws SQLException;
	void saveRepairDet(Map<String, Object>params)throws SQLException;
	Map<String, Object>validateBeforeSaveOther(Map<String, Object> params)throws SQLException;
	void saveOtherLabor(Map<String, Object>params)throws SQLException;
}
