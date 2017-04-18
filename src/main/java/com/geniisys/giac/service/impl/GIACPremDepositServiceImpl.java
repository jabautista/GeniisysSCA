package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.dao.GIACPremDepositDAO;
import com.geniisys.giac.entity.GIACAccTrans;
import com.geniisys.giac.entity.GIACPremDeposit;
import com.geniisys.giac.service.GIACPremDepositService;

public class GIACPremDepositServiceImpl implements GIACPremDepositService {

	/** The GIAC Prem Deposit DAO */
	private GIACPremDepositDAO giacPremDepositDAO;
	
	public GIACPremDepositDAO getGiacPremDepositDAO() {
		return giacPremDepositDAO;
	}

	public void setGiacPremDepositDAO(GIACPremDepositDAO giacPremDepositDAO) {
		this.giacPremDepositDAO = giacPremDepositDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#getGIACPremDeposit(int)
	 */
	@Override
	public List<GIACPremDeposit> getGIACPremDeposit(int tranId) throws SQLException {
		return this.getGiacPremDepositDAO().getGIACPremDeposit(tranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#getGIACAcctrans(int, java.lang.String, java.lang.String)
	 */
	@Override
	public GIACAccTrans getGIACAcctrans(int tranId, String gfunFundCd,
			String gibrBranchCd) throws SQLException {
		return this.getGiacPremDepositDAO().getGIACAcctrans(tranId, gfunFundCd, gibrBranchCd);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#getTotalCollections(int)
	 */
	@Override
	public BigDecimal getTotalCollections(int tranId) throws SQLException {
		return this.getGiacPremDepositDAO().getTotalCollections(tranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#getDefaultCurrency(java.lang.Integer)
	 */
	@Override
	public Map<String, Object> getDefaultCurrency(Integer currencyCd)
			throws SQLException {
		return this.getGiacPremDepositDAO().getDefaultCurrency(currencyCd);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#getOldItemNoList(java.lang.Integer, java.lang.String, java.lang.Integer, java.lang.String)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getOldItemNoList(Integer transactionType,
			String controlModule, Integer pageNo, String keyword, String userId) throws SQLException {
		List<Map<String, Object>> oldItemNoList = this.getGiacPremDepositDAO().getOldItemNoList(transactionType, controlModule, keyword, userId);
		PaginatedList paginatedList = new PaginatedList(oldItemNoList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#getGIACPremDepositModuleRecords(java.util.Map)
	 */
	@Override
	public Map<String, Object> getGIACPremDepositModuleRecords(
			Map<String, Object> params) throws SQLException {
		return this.getGiacPremDepositDAO().getGIACPremDepositModuleRecords(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#getOldItemNoListFor4(java.lang.Integer, java.lang.String)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getOldItemNoListFor4(Integer pageNo, String keyword) throws SQLException {
		List<Map<String, Object>> oldItemNoList = this.getGiacPremDepositDAO().getOldItemNoListFor4(keyword);
		PaginatedList paginatedList = new PaginatedList(oldItemNoList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#getGIACPremDeposit2(int, int)
	 */
	@Override
	public List<GIACPremDeposit> getGIACPremDeposit2()
			throws SQLException {
		return this.getGiacPremDepositDAO().getGIACPremDeposit2();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#getCollectionAmtSumFor2List()
	 */
	@Override
	public List<Map<String, Object>> getCollectionAmtSumFor2List() throws SQLException {
		return this.getGiacPremDepositDAO().getCollectionAmtSumFor2List();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#getCollectionAmtSumFor4List()
	 */
	@Override
	public List<Map<String, Object>> getCollectionAmtSumFor4List()
			throws SQLException {
		return this.getGiacPremDepositDAO().getCollectionAmtSumFor4List();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#getGIACAgingSOAPOlicy(java.util.Map)
	 */
	@Override
	public Map<String, Object> getGIACAgingSOAPolicy(Map<String, Object> params)
			throws SQLException {
		return this.getGiacPremDepositDAO().getGIACAgingSOAPolicy(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#validateRiCd(java.util.Map)
	 */
	@Override
	public Map<String, Object> validateRiCd(Map<String, Object> params)
			throws SQLException {
		return this.getGiacPremDepositDAO().validateRiCd(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#validateTranType1(java.util.Map)
	 */
	@Override
	public Map<String, Object> validateTranType1(Map<String, Object> params)
			throws SQLException {
		return this.getGiacPremDepositDAO().validateTranType1(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#getParSeqNo2(java.util.Map)
	 */
	@Override
	public Map<String, Object> getParSeqNo2(Map<String, Object> params)
			throws SQLException {
		return this.getGiacPremDepositDAO().getParSeqNo2(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#deleteGIACPremDeposit(java.util.List)
	 */
	@Override
	public void deleteGIACPremDeposit(List<Map<String, Object>> giacPremDeps)
			throws SQLException {
		this.getGiacPremDepositDAO().deleteGIACPremDeposit(giacPremDeps);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#saveGIACPremDeposit(java.util.List, java.util.List, java.lang.String, java.lang.String, int, java.lang.String, java.lang.String, java.lang.String, java.lang.String, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public String saveGIACPremDeposit(List<GIACPremDeposit> giacPremDeps, List<Map<String, Object>> delGiacPremDeps,
			  String gaccBranchCd, String gaccFundCd, int gaccTranId, String moduleName,
			  String genType, String tranSource, String orFlag, GIISUser USER) throws SQLException {
		return this.getGiacPremDepositDAO().saveGIACPremDeposit(giacPremDeps, delGiacPremDeps, gaccBranchCd, 
														gaccFundCd, gaccTranId, moduleName, genType, tranSource, orFlag, USER);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#setGIACPremDeposit(java.util.List)
	 */
	@Override
	public void setGIACPremDeposit(List<GIACPremDeposit> giacPremDeps)
			throws SQLException {
		this.getGiacPremDepositDAO().setGIACPremDeposit(giacPremDeps);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#executeCollectionDefaultAmount(java.util.Map)
	 */
	@Override
	public void executeCollectionDefaultAmount(Map<String, Object> params)
			throws SQLException {
		this.getGiacPremDepositDAO().executeCollectionDefaultAmount(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#getParSeqNo(java.util.Map)
	 */
	@Override
	public void getParSeqNo(Map<String, Object> params) throws SQLException {
		this.getGiacPremDepositDAO().getParSeqNo(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#validateTranType2(java.util.Map)
	 */
	@Override
	public void validateTranType2(Map<String, Object> params)
			throws SQLException {
		this.getGiacPremDepositDAO().validateTranType2(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#checkGipdGipdFKConstraint(java.util.Map)
	 */
	@Override
	public String checkGipdGipdFKConstraint(Map<String, Object> params)
			throws SQLException {
		return this.getGiacPremDepositDAO().checkGipdGipdFKConstraint(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPremDepositService#saveGIACPremDep(java.util.Map)
	 */
	public String saveGIACPremDep(Map<String, Object> params, String parameters, String userId) throws JSONException,
				SQLException {
	JSONObject objParameters = new JSONObject(parameters);
	Map<String, Object> allParams = new HashMap<String, Object>();
	allParams.put("userId", params.get("userId"));
	allParams.put("appUser", params.get("userId"));
	allParams.put("gaccTranId", params.get("gaccTranId"));
	allParams.put("gaccBranchCd", params.get("gaccBranchCd"));
	allParams.put("gaccFundCd", params.get("gaccFundCd"));
	allParams.put("genType", params.get("genType"));
	allParams.put("orFlag", params.get("orFlag"));
	allParams.put("tranSource", params.get("tranSource"));
	allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIACPremDeposit.class));
	allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIACPremDeposit.class));
	System.out.println(allParams);
	return this.giacPremDepositDAO.saveGIACPremDep(allParams);
	}

	@Override		/*added by kenneth for print premium deposit 06.25.2013*/
	public String extractPremDeposit(String userId) throws SQLException {
		return this.giacPremDepositDAO.extractPremDeposit(userId);
	}

	@Override		/*added by kenneth for print premium deposit 06.25.2013*/
	public String extractWidNoReversal(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException{
		String totalRow = "";
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", USER.getUserId());
		param.put("posting", request.getParameter("posting"));
		param.put("transaction", request.getParameter("transaction"));
		param.put("fromDate", df.parse(request.getParameter("fromDate")));
		param.put("toDate", df.parse(request.getParameter("toDate")));
		param.put("branchCd", request.getParameter("branchCd"));
		param.put("reversal", request.getParameter("reversal"));
		param.put("cutOff", df.parse(request.getParameter("cutOff")));
		param.put("assdNo", request.getParameter("assdNo"));
		param.put("depFlag", request.getParameter("depFlag"));
		param.put("rdoDep", request.getParameter("rdoDep"));
		totalRow = this.giacPremDepositDAO.extractWidNoReversal(param);
		System.out.println(totalRow);
		return totalRow;
	}

	@Override		/*added by kenneth for print premium deposit 06.25.2013*/
	public String extractWidReversal(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException {
		String totalRow = "";
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", USER.getUserId());
		param.put("posting", request.getParameter("posting"));
		param.put("transaction", request.getParameter("transaction"));
		param.put("fromDate", df.parse(request.getParameter("fromDate")));
		param.put("toDate", df.parse(request.getParameter("toDate")));
		param.put("branchCd", request.getParameter("branchCd"));
		param.put("reversal", request.getParameter("reversal"));
		param.put("cutOff", df.parse(request.getParameter("cutOff")));
		param.put("assdNo", request.getParameter("assdNo"));
		param.put("depFlag", request.getParameter("depFlag"));
		param.put("rdoDep", request.getParameter("rdoDep"));
		totalRow = this.giacPremDepositDAO.extractWidReversal(param);
		System.out.println(totalRow);
		return totalRow;
	}

	@Override		/*added by kenneth for print premium deposit 06.25.2013*/
	public Map<String, Object> getLastExtractParams(String userId)throws SQLException {
		return this.giacPremDepositDAO.getLastExtract(userId);
	}

}
