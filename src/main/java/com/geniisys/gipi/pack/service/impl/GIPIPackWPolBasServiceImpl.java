package com.geniisys.gipi.pack.service.impl;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.gipi.pack.dao.GIPIPackWPolBasDAO;
import com.geniisys.gipi.pack.entity.GIPIPackWPolBas;
import com.geniisys.gipi.pack.entity.GIPIWPackLineSubline;
import com.geniisys.gipi.pack.service.GIPIPackWPolBasService;
import com.seer.framework.util.StringFormatter;

public class GIPIPackWPolBasServiceImpl implements GIPIPackWPolBasService {
	
	private GIPIPackWPolBasDAO gipiPackWPolBasDAO;

	public void setGipiPackWPolBasDAO(GIPIPackWPolBasDAO gipiPackWPolBasDAO) {
		this.gipiPackWPolBasDAO = gipiPackWPolBasDAO;
	}

	public GIPIPackWPolBasDAO getGipiPackWPolBasDAO() {
		return gipiPackWPolBasDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public GIPIPackWPolBas getGIPIPackWPolBas(int packParId)
			throws SQLException {
		// apollo cruz 07.27.2015 - to handle special characters in gipiPackWPolBas.gipiwPackLineSubline SR#19757
		GIPIPackWPolBas gipiPackWPolBas = this.getGipiPackWPolBasDAO().getGIPIPackWPolBas(packParId);		
		gipiPackWPolBas.setGipiwPackLineSubline((List<GIPIWPackLineSubline>) StringFormatter.escapeHTMLInList4(gipiPackWPolBas.getGipiwPackLineSubline()));		
		return (GIPIPackWPolBas) StringFormatter.escapeHTMLInObject(gipiPackWPolBas);
		//return (GIPIPackWPolBas) StringFormatter.replaceQuotesInObject(this.getGipiPackWPolBasDAO().getGIPIPackWPolBas(packParId));
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackWPolBasService#executeGipis031ANewFormInstance(java.util.Map)
	 */
	@Override
	public void executeGipis031ANewFormInstance(Map<String, Object> params)
			throws SQLException {
		this.getGipiPackWPolBasDAO().executeGipis031ANewFormInstance(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackWPolBasService#executeGipis031AGetAcctOfCd(java.util.Map)
	 */
	@Override
	public void executeGipis031AGetAcctOfCd(Map<String, Object> params)
			throws SQLException {
		this.getGipiPackWPolBasDAO().executeGipis031AGetAcctOfCd(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackWPolBasService#checkPolicyNoForPackEndt(java.util.Map)
	 */	
	@Override
	public Map<String, Object> checkPolicyNoForPackEndt(
			Map<String, Object> params) throws SQLException {
		return this.getGipiPackWPolBasDAO().checkPolicyNoForPackEndt(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackWPolBasService#getEndtPackBasicInfoRecs(java.util.Map)
	 */
	@Override
	public void getEndtPackBasicInfoRecs(Map<String, Object> params)
			throws SQLException {
		this.getGipiPackWPolBasDAO().getEndtPackBasicInfoRecs(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackWPolBasService#searchForPolicy(java.util.Map)
	 */
	@Override
	public void searchForPolicy(Map<String, Object> params) throws SQLException {
		this.getGipiPackWPolBasDAO().searchForPolicy(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackWPolBasService#saveEndtBasicInfo(java.util.Map)
	 */
	@Override
	public Map<String, Object> saveEndtBasicInfo(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPackWPolBasDAO().saveEndtBasicInfo(params);
	}

	@Override
	public Map<String, String> newFormInst(String lineCd, String issCd) throws SQLException {
		return this.getGipiPackWPolBasDAO().newFormInst(lineCd, issCd);
	}

	@Override
	public Map<String, String> isPackWPolbasExist(Integer packParId)
			throws SQLException {
		return this.getGipiPackWPolBasDAO().isPackWPolbasExist(packParId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public GIPIPackWPolBas getGipiPackWPolbasDefaultValues(Integer packParId)
			throws SQLException {
		// apollo cruz 07.27.2015 - to handle special characters in gipiPackWPolBas.gipiwPackLineSubline SR#19757
		GIPIPackWPolBas gipiPackWPolBas = this.getGipiPackWPolBasDAO().getGipiPackWPolbasDefaultValues(packParId);		
		gipiPackWPolBas.setGipiwPackLineSubline((List<GIPIWPackLineSubline>) StringFormatter.escapeHTMLInList4(gipiPackWPolBas.getGipiwPackLineSubline()));		
		return (GIPIPackWPolBas) StringFormatter.escapeHTMLInObject(gipiPackWPolBas);
		//return (GIPIPackWPolBas) StringFormatter.replaceQuotesInObject(this.getGipiPackWPolBasDAO().getGipiPackWPolbasDefaultValues(packParId));
	}

	@Override
	public Map<String, Object> savePackPARBasicInfo(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPackWPolBasDAO().savePackPARBasicInfo(params);
	}

	@Override
	public Map<String, Object> checkPackParExistingTables(Integer packParId)
			throws SQLException {
		return this.getGipiPackWPolBasDAO().checkPackParExistingTables(packParId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackWPolBasService#checkPolicyForAffectingEndtToCancel(java.util.Map)
	 */
	@Override
	public String checkPolicyForAffectingEndtToCancel(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPackWPolBasDAO().checkPolicyForAffectingEndtToCancel(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackWPolBasService#checkIfExistingInGipiWitmperl(java.lang.Integer)
	 */
	@Override
	public String checkIfExistingInGipiWitmperl(Integer parId)
			throws SQLException {
		return this.getGipiPackWPolBasDAO().checkIfExistingInGipiWitmperl(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackWPolBasService#checkIfExistingInGipiWitem(java.lang.Integer)
	 */
	@Override
	public String checkIfExistingInGipiWitem(Integer parId) throws SQLException {
		return this.getGipiPackWPolBasDAO().checkIfExistingInGipiWitem(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackWPolBasService#getRecordsForPackEndtCancellation(java.util.Map)
	 */
	@Override
	public List<Map<String, Object>> getRecordsForPackEndtCancellation(
			Map<String, Object> params) throws SQLException {
		return this.getGipiPackWPolBasDAO().getRecordsForPackEndtCancellation(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackWPolBasService#checkPackEndtForItemAndPeril(java.util.Map)
	 */
	@Override
	public Map<String, Object> checkPackEndtForItemAndPeril(
			Map<String, Object> params) throws SQLException {
		return this.getGipiPackWPolBasDAO().checkPackEndtForItemAndPeril(params);

	}

	@Override
	public Map<String, Object> generateBankRefNoForPack(
			Map<String, Object> params) throws SQLException {
		return this.getGipiPackWPolBasDAO().generateBankRefNoForPack(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackWPolBasService#preGetAmountsForPackEndt(java.util.Map)
	 */
	@Override
	public String preGetAmountsForPackEndt(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPackWPolBasDAO().preGetAmountsForPackEndt(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackWPolBasService#createNegatedRecordsFlat(java.util.Map)
	 */
	@Override
	public Map<String, Object> createNegatedRecordsFlat(
			Map<String, Object> params) throws SQLException {
		return this.getGipiPackWPolBasDAO().createNegatedRecordsFlat(params);
	}

	@Override
	public String validatePackRefPolNo(Integer packParId, String refPolNo)
			throws SQLException {
		return this.getGipiPackWPolBasDAO().validatePackRefPolNo(packParId, refPolNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackWPolBasService#validatePackEndtEffDate(java.util.Map)
	 */
	@Override
	public Map<String, Object> validatePackEndtEffDate(
			Map<String, Object> params) throws SQLException {
		return this.getGipiPackWPolBasDAO().validatePackEndtEffDate(params);
	}

	@Override
	public Map<String, Object> processPackEndtCancellation(
			Map<String, Object> params) throws SQLException {
		return getGipiPackWPolBasDAO().processPackEndtCancellation(params);
	}	

	@SuppressWarnings("unchecked")
	public Map<String, Object> searchForEditedPackPolicy(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", Integer.parseInt(request.getParameter("packParId")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("effDate", request.getParameter("effDate"));
		params.put("acctOfCd", request.getParameter("acctOfCd"));
		params.put("bondSeqNo", request.getParameter("bondSeqNo") == "" ? null : Integer.parseInt(request.getParameter("bondSeqNo")));
		params = this.gipiPackWPolBasDAO.searchForEditedPackPolicy(params);
		List<GIPIPackWPolBas> pol = (List<GIPIPackWPolBas>) params.get("gipiPackWPolbas");
		SimpleDateFormat sdfWithTime = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		params.put("inceptDate", pol.get(0).getInceptDate() != null ? sdfWithTime.format(pol.get(0).getInceptDate()) :"");
		params.put("expiryDate", pol.get(0).getExpiryDate() != null ? sdfWithTime.format(pol.get(0).getExpiryDate()) :"");
		params.put("endtExpiryDate", pol.get(0).getEndtExpiryDate() != null ? sdfWithTime.format(pol.get(0).getEndtExpiryDate()) :"");
		return params;
	}
}
