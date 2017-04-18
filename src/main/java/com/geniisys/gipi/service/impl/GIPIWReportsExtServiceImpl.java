package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIWReportsExtDAO;
import com.geniisys.gipi.entity.GIPIUWReportsParam;
import com.geniisys.gipi.service.GIPIWReportsExtService;

public class GIPIWReportsExtServiceImpl implements GIPIWReportsExtService{
	private GIPIWReportsExtDAO gipiWReportsExtDAO;

	public GIPIWReportsExtDAO getGipiWReportsExtDAO() {
		return gipiWReportsExtDAO;
	}

	public void setGipiWReportsExtDAO(GIPIWReportsExtDAO gipiWReportsExtDAO) {
		this.gipiWReportsExtDAO = gipiWReportsExtDAO;
	}

	@Override
	public String checkUwReportsEdst(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().checkUwReportsEdst(params);
	}

	@Override
	public String checkUwReports(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().checkUwReports(params);
	}

	@Override
	public String extractUWReports(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().extractUWReports(params);
	}

	@Override
	public GIPIUWReportsParam getLastExtractParams(Map<String, Object> params) throws SQLException {
		return this.getGipiWReportsExtDAO().getLastExtractParams(params);
	}

	@Override
	public Map<String, Object> validateCedant(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().validateCedant(params);
	}

	@Override
	public String checkUwReportsDist(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().checkUwReportsDist(params);
	}

	@Override
	public String extractUWReportsDist(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().extractUWReportsDist(params);
	}

	@Override
	public String checkUwReportsOutward(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().checkUwReportsOutward(params);
	}

	@Override
	public String extractUWReportsOutward(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().extractUWReportsOutward(params);
	}

	@Override
	public String checkUwReportsPerPeril(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().checkUwReportsPerPeril(params);
	}

	@Override
	public String extractUWReportsPerPeril(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().extractUWReportsPerPeril(params);
	}

	@Override
	public String checkUwReportsPerAssd(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().checkUwReportsPerAssd(params);
	}

	@Override
	public String extractUWReportsPerAssd(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().extractUWReportsPerAssd(params);
	}

	@Override
	public String checkUwReportsInward(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().checkUwReportsInward(params);
	}

	@Override
	public String extractUWReportsInward(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().extractUWReportsInward(params);
	}

	@Override
	public Integer getParamDate(String userId) throws SQLException {
		return this.getGipiWReportsExtDAO().getParamDate(userId);
	}

	@Override
	public String checkUwReportsPolicy(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().checkUwReportsPolicy(params);
	}

	@Override
	public String extractUWReportsPolicy(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().extractUWReportsPolicy(params);
	}

	@Override
	public String validatePrintPolEndt(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().validatePrintPolEndt(params);
	}

	@Override
	public String validatePrint(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().validatePrint(params);
	}

	@Override
	public Integer countNoShareCd(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().countNoShareCd(params);
	}

	@Override
	public String validatePrintAssd(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().validatePrintAssd(params);
	}

	@Override
	public String validatePrintOutwardInwardRI(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWReportsExtDAO().validatePrintOutwardInwardRI(params); 
	}

}
