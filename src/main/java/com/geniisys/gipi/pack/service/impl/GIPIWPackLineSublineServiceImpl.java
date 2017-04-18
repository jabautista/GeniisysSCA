/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gipi.pack.service.impl
	File Name: GIPIWPackLineSublineServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 11, 2011
	Description: 
*/


package com.geniisys.gipi.pack.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.pack.dao.GIPIWPackLineSublineDAO;
import com.geniisys.gipi.pack.entity.GIPIWPackLineSubline;
import com.geniisys.gipi.pack.service.GIPIWPackLineSublineService;

public class GIPIWPackLineSublineServiceImpl implements GIPIWPackLineSublineService {

	GIPIWPackLineSublineDAO gipiwPackLineSublineDAO;
	
	public List<GIPIWPackLineSubline> getGIPIWPackLineSublineList(String lineCd)
			throws SQLException {
		return getGipiwPackLineSublineDAO().getGIPIWPackLineSublineList(lineCd);
	}

	public List<GIPIWPackLineSubline> getGIPIWPackLineSublineListByPParId(
			int packParId ,String lineCd) throws SQLException {
		return getGipiwPackLineSublineDAO().getGIPIWPackLineSublineListByPParId(packParId, lineCd);
	}
	public GIPIWPackLineSublineDAO getGipiwPackLineSublineDAO() {
		return gipiwPackLineSublineDAO;
	}

	public void setGipiwPackLineSublineDAO(
			GIPIWPackLineSublineDAO gipiwPackLineSublineDAO) {
		this.gipiwPackLineSublineDAO = gipiwPackLineSublineDAO;
	}

	@Override
	public List<GIPIWPackLineSubline> getGIPIWpackLineSublineDspTag(
			Map<String, Object> params) throws SQLException {
		return null;
	}

	@Override
	public void saveGIPIWPackLineSubline(
			Map<String, Object> params) throws SQLException, JSONException {
		gipiwPackLineSublineDAO.saveGIPIWPackLineSubline(params);
	}

	@Override
	public Map<String, Object> checkIfExistGIPIWPackItemPeril(
			Map<String, Object> params) throws SQLException {
		return this.gipiwPackLineSublineDAO.checkIfExistGIPIWPackItemPeril(params);
	}

	@Override
	public List<GIPIWPackLineSubline> getGIPIWPackEndtLineSublineList(
			Map<String, Object> params) throws SQLException {
		return this.gipiwPackLineSublineDAO.getGIPIWPackEndtLineSublineList(params);
	}

	@Override
	public void delGIPIWPackLineSublineByPackParId(Integer packParId)
			throws SQLException {
		this.gipiwPackLineSublineDAO.delGIPIWPackLineSublineByPackParId(packParId);
	}

	@Override
	public void saveEndtGIPIWPackLineSubline(Map<String, Object> params)
			throws SQLException, JSONException {
		this.gipiwPackLineSublineDAO.saveEndtGIPIWPackLineSubline(params);
	}

	@Override
	public List<GIPIWPackLineSubline> getGIPIWPackLineSublineList2(
			Integer packParId, String lineCd) throws SQLException {
		return this.gipiwPackLineSublineDAO.getGIPIWPackLineSublineList2(packParId, lineCd);
	}
	
}
