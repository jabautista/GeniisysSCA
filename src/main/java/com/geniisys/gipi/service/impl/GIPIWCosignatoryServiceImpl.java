package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIWCosignatoryDAO;
import com.geniisys.gipi.entity.GIPIWCosignatory;
import com.geniisys.gipi.service.GIPIWCosignatoryService;

public class GIPIWCosignatoryServiceImpl implements GIPIWCosignatoryService {
	
	private GIPIWCosignatoryDAO gipiWCosignatoryDAO;

	@Override
	public List<GIPIWCosignatory> getGIPIWCosignatory(Integer parId)
			throws SQLException {
		return this.getGipiWCosignatoryDAO().getGIPIWCosignatory(parId);
	}

	public void setGipiWCosignatoryDAO(GIPIWCosignatoryDAO gipiWCosignatoryDAO) {
		this.gipiWCosignatoryDAO = gipiWCosignatoryDAO;
	}

	public GIPIWCosignatoryDAO getGipiWCosignatoryDAO() {
		return gipiWCosignatoryDAO;
	}

	@Override
	public void deleteGIPIWCosignatory(Integer parId, Integer cosignId)
			throws SQLException {
		this.getGipiWCosignatoryDAO().deleteGIPIWCosignatory(parId, cosignId);
	}

	@Override
	public void insertGIPIWCosignatory(Map<String, Object> wCosignatory)
			throws SQLException {
		this.getGipiWCosignatoryDAO().insertGIPIWCosignatory(wCosignatory);
	}

	@Override
	public void saveGIPIWCosignatoryPageChanges(Map<String, Object> params)
			throws SQLException {
		this.getGipiWCosignatoryDAO().saveGIPIWCosignatoryPageChanges(params);
	}

}
