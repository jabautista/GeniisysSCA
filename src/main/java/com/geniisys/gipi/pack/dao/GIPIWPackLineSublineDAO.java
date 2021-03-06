/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gipi.pack.dao
	File Name: GIPIWPackLineSublineDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 11, 2011
	Description: 
*/


package com.geniisys.gipi.pack.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.pack.entity.GIPIWPackLineSubline;

public interface GIPIWPackLineSublineDAO {
	List<GIPIWPackLineSubline>getGIPIWPackLineSublineList(String lineCd)throws SQLException;
	List<GIPIWPackLineSubline>getGIPIWPackEndtLineSublineList(Map<String, Object> params)throws SQLException;
	List<GIPIWPackLineSubline>getGIPIWPackLineSublineListByPParId(int packParId,String lineCd) throws SQLException;
	List<GIPIWPackLineSubline>getGIPIWPackLineSublineList2(Integer packParId,String lineCd) throws SQLException;
	String getGIPIWpackLineSublineDspTag(Map<String, Object>params) throws SQLException;
	void saveGIPIWPackLineSubline(Map<String, Object>params)throws SQLException, JSONException;
	void saveEndtGIPIWPackLineSubline(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> checkIfExistGIPIWPackItemPeril(Map<String, Object>params) throws SQLException;
	void delGIPIWPackLineSublineByPackParId(Integer packParId) throws SQLException;
}
