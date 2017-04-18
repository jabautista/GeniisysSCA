package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.dao.GIACCommPaytsDAO;
import com.geniisys.giac.entity.GIACCommPayts;
import com.geniisys.giac.service.GIACCommPaytsService;

public class GIACCommPaytsServiceImpl implements GIACCommPaytsService{

	/** The GIACCommPayts Dao. */
	private GIACCommPaytsDAO giacCommPaytsDAO;

	public void setGiacCommPaytsDAO(GIACCommPaytsDAO giacCommPaytsDAO) {
		this.giacCommPaytsDAO = giacCommPaytsDAO;
	}

	public GIACCommPaytsDAO getGiacCommPaytsDAO() {
		return giacCommPaytsDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#getGIACCommPayts(int)
	 */
	@Override
	public List<GIACCommPayts> getGIACCommPayts(int gaccTranId)
			throws SQLException {
		return this.getGiacCommPaytsDAO().getGIACCommPayts(gaccTranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#getGiacs020BasicVarValues(java.lang.Integer, java.lang.String)
	 */
	@Override
	public Map<String, Object> getGiacs020BasicVarValues(Integer gaccTranId, String userId) throws SQLException {
		return this.getGiacCommPaytsDAO().getGiacs020BasicVarValues(gaccTranId, userId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#getGIPICommInvoice(java.util.Map)
	 */
	@Override
	public Map<String, Object> getGIPICommInvoice(Map<String, Object> params)
			throws SQLException {
		return this.getGiacCommPaytsDAO().getGIPICommInvoice(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#getBillNoList(java.lang.Integer, java.lang.Integer, java.lang.String, java.lang.Integer, java.lang.String)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getBillNoList(Integer pageNo, Integer tranType,
			String issCd, Integer gaccTranId, String keyword)
			throws SQLException {
		List<Map<String, Object>> billNoList = this.getGiacCommPaytsDAO().getBillNoList(tranType, issCd, gaccTranId, keyword);
		PaginatedList paginatedList = new PaginatedList(billNoList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#chkModifiedComm(java.lang.String, java.lang.String)
	 */
	@Override
	public String chkModifiedComm(String premSeqNo, String issCd)
			throws SQLException {
		return this.getGiacCommPaytsDAO().chkModifiedComm(premSeqNo, issCd);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#validateGIACS020IntmNo(java.util.Map)
	 */
	@Override
	public Map<String, Object> validateGIACS020IntmNo(Map<String, Object> params)
			throws SQLException {
		return this.getGiacCommPaytsDAO().validateGIACS020IntmNo(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#commPaytsIntmNoPostText(java.util.Map)
	 */
	@Override
	public Map<String, Object> commPaytsIntmNoPostText(
			Map<String, Object> params) throws SQLException {
		return this.getGiacCommPaytsDAO().commPaytsIntmNoPostText(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#commPaytsParam2MgmtComp(java.util.Map)
	 */
	@Override
	public Map<String, Object> commPaytsParam2MgmtComp(
			Map<String, Object> params) throws SQLException {
		return this.getGiacCommPaytsDAO().commPaytsParam2MgmtComp(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#getCommPaytsDefPremPct(java.util.Map)
	 */
	@Override
	public Map<String, Object> getCommPaytsDefPremPct(Map<String, Object> params)
			throws SQLException {
		return this.getGiacCommPaytsDAO().getCommPaytsDefPremPct(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#commPaytsCompSummary(java.util.Map)
	 */
	@Override
	public Map<String, Object> commPaytsCompSummary(Map<String, Object> params)
			throws SQLException {
		return this.getGiacCommPaytsDAO().commPaytsCompSummary(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#preInsertGiacs020CommPayts(java.util.Map)
	 */
	@Override
	public Map<String, Object> preInsertGiacs020CommPayts(
			Map<String, Object> params) throws SQLException {
		return this.getGiacCommPaytsDAO().preInsertGiacs020CommPayts(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#deleteGIACCommPayts(java.util.List)
	 */
	@Override
	public void deleteGIACCommPayts(List<GIACCommPayts> giacCommPayts)
			throws SQLException {
		this.getGiacCommPaytsDAO().deleteGIACCommPayts(giacCommPayts);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#saveGIACCommPayts(java.util.List, java.util.List, java.util.Map)
	 */
	@Override
	public Map<String, Object> saveGIACCommPayts(List<GIACCommPayts> giacCommPayts,
			List<GIACCommPayts> delGiacCommPayts, Map<String, Object> params) throws SQLException {
		return this.getGiacCommPaytsDAO().saveGIACCommPayts(giacCommPayts, delGiacCommPayts, params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#setGIACCommPayts(java.util.List)
	 */
	@Override
	public void setGIACCommPayts(List<GIACCommPayts> giacCommPayts)
			throws SQLException {
		this.getGiacCommPaytsDAO().setGIACCommPayts(giacCommPayts);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#executeGiacs020PostFormsCommit(java.util.Map)
	 */
	@Override
	public Map<String, Object> executeGiacs020PostFormsCommit(
			Map<String, Object> params) throws SQLException {
		return this.getGiacCommPaytsDAO().executeGiacs020PostFormsCommit(params);
	}

	
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getGcopInv(Integer pageNo, Map<String, Object> params)
			throws SQLException {
		List<Map<String, Object>> gcopInvList = this.getGiacCommPaytsDAO().getGcopInv(params);
		PaginatedList paginatedList = new PaginatedList(gcopInvList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#checkGcopInvChkTag(java.util.Map)
	 */
	@Override
	public Map<String, Object> checkGcopInvChkTag(Map<String, Object> params)
			throws SQLException {
		return this.getGiacCommPaytsDAO().checkGcopInvChkTag(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCommPaytsService#executeGIACS020DeleteRecord(java.util.Map)
	 */
	@Override
	public String executeGIACS020DeleteRecord(Map<String, Object> params)
			throws SQLException {
		return this.getGiacCommPaytsDAO().executeGIACS020DeleteRecord(params);
	}

	@Override
	public List<Map<String, Object>> getGcopInvList(Map<String, Object> params)
			throws SQLException {
		return this.getGiacCommPaytsDAO().getGcopInv(params);
	}

	@Override
	public String checkRelCommWUnprintedOr(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("refNo", null);
		params.put("message", null);
		return this.getGiacCommPaytsDAO().checkRelCommWUnprintedOr(params);
	}
	
	public List<Map<String, Object>> getGcopInvDetails(Map<String, Object> params) throws SQLException{
		return this.getGiacCommPaytsDAO().getGcopInv(params);
	}
	
	public Map<String, Object> getParam2FullPremPayt(Map<String, Object> params) throws SQLException{
		return this.getGiacCommPaytsDAO().getParam2FullPremPayt(params);
	}
	
	public String validateGIACS020BillNo(HttpServletRequest request) throws SQLException{	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranType", request.getParameter("tranType"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		
		return this.giacCommPaytsDAO.validateGIACS020BillNo(params);
	}
	
	@Override
	public String checkingIfPaidOrUnpaid(HttpServletRequest request, String userId) //SR20909 :: john 11.9.2015
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		//this.giacCommPaytsDAO.checkingIfPaidOrUnpaid(params); //Commented out and replaced by code below - Jerome Bautista 03.04.2016 SR 21279
		return this.giacCommPaytsDAO.checkingIfPaidOrUnpaid(params); 
		
	}

	@Override
	public void checkCommPaytStatus(HttpServletRequest request)
			throws SQLException {
		this.getGiacCommPaytsDAO().checkCommPaytStatus(Integer.parseInt(request.getParameter("gaccTranId")));
	}
}
