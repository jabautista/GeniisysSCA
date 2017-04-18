
package com.geniisys.giex.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giex.dao.GIEXExpiryDAO;
import com.geniisys.giex.entity.GIEXExpiry;
import com.geniisys.giex.service.GIEXExpiryService;

public class GIEXExpiryServiceImpl implements GIEXExpiryService{
	
	private GIEXExpiryDAO giexExpiryDAO;
	
	/**
	 * @param giexExpiryDAO the giexExpiryDAO to set
	 */
	public void setGiexExpiryDAO(GIEXExpiryDAO giexExpiryDAO) {
		this.giexExpiryDAO = giexExpiryDAO;
	}

	/**
	 * @return the giexExpiryDAO
	 */
	public GIEXExpiryDAO getGiexExpiryDAO() {
		return giexExpiryDAO;
	}
	
	@Override
	public Map<String, Object> getLastExtractionHistory(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiryDAO().getLastExtractionHistory(params);
	}
	
	@Override
	public Map<String, Object> extractExpiringPolicies(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiryDAO().extractExpiringPolicies(params);
	}
	
	@Override
	public Map<String, Object> extractExpiringPoliciesFinal(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiryDAO().extractExpiringPoliciesFinal(params);
	}

	@Override
	public Map<String, Object> updateBalanceClaimFlag(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiryDAO().updateBalanceClaimFlag(params);
	}

	@Override
	public Map<String, Object> arValidationGIEXS004(Map<String, Object> params)
			throws SQLException {
		System.out.println("PARAMS AR VALIDATION:::::::   " + params);
		return this.getGiexExpiryDAO().arValidationGIEXS004(params);
	}

	@Override
	public Map<String, Object> updateF000Field(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiryDAO().updateF000Field(params);
	}

	@Override
	public GIEXExpiry getGIEXS007B240Info(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiryDAO().getGIEXS007B240Info(params);
	}

	@Override
	public String checkRecordUser(Map<String, Object> params)
			throws SQLException {
		return this.giexExpiryDAO.checkRecordUser(params);
	}

	@Override
	public List<String> getRenewalNoticePolicyId(Map<String, Object> params)
			throws SQLException {
		return this.giexExpiryDAO.getRenewalNoticePolicyId(params);
	}

	@Override
	public String checkPolicyIdGiexs006(Integer policyId)
			throws SQLException {
		return this.giexExpiryDAO.checkPolicyIdGiexs006(policyId);
	}

	@Override
	public void generateRenewalNo(Map<String, Object> params) throws Exception {		
		this.giexExpiryDAO.generateRenewalNo(params);
	}

	@Override
	public void generatePackRenewalNo(Map<String, Object> params)
			throws Exception {
		this.giexExpiryDAO.generatePackRenewalNo(params);
	}

	@Override
	public Integer checkGenRnNo(Map<String, Object> params) throws SQLException {
		return this.giexExpiryDAO.checkGenRnNo(params);
	}

	@Override
	public String checkRecordUserNr(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiryDAO().checkRecordUserNr(params);
	}

	@Override
	public String getGiispLineCdGiexs006(String param) throws SQLException {
		return this.getGiexExpiryDAO().getGiispLineCdGiexs006(param);
	}

	@Override
	public String changeIncludePackValue(String lineCd) throws SQLException {
		return this.getGiexExpiryDAO().changeIncludePackValue(lineCd);
	}

	@Override
	public void updatePrintTag(Map<String, Object> params) throws SQLException {
		this.giexExpiryDAO.updatePrintTag(params);
		
	}
}
