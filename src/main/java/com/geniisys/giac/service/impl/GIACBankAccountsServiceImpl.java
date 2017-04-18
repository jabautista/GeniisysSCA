package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACBankAccountsDAO;
import com.geniisys.giac.entity.GIACBankAccounts;
import com.geniisys.giac.service.GIACBankAccountsService;

public class GIACBankAccountsServiceImpl implements GIACBankAccountsService {
	
	/** The DAO */
	private GIACBankAccountsDAO giacBankAccountsDAO;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIACBankAccountsServiceImpl.class);
	
	public GIACBankAccountsDAO getGiacBankAccountsDAO() {
		return giacBankAccountsDAO;
	}

	public void setGiacBankAccountsDAO(GIACBankAccountsDAO giacBankAccountsDAO) {
		this.giacBankAccountsDAO = giacBankAccountsDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACBankAccountsService#getBankAcctNoLOV(java.lang.Integer, java.lang.String)
	 */
	@Override
	public PaginatedList getBankAcctNoLOV(Integer pageNo, String keyword)
			throws SQLException {
		log.info("getBankAcctNoLOV");
		List<Map<String, Object>> bankAcctNoList = this.getGiacBankAccountsDAO().getBankAcctNoLOV(keyword);
		PaginatedList paginatedList = new PaginatedList(bankAcctNoList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.setNoOfPages(pageNo);
		return paginatedList;
	}

	@Override
	public JSONObject showGiacs312(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs312RecList");
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("bankCd") != null && request.getParameter("bankAcctCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("bankCd", request.getParameter("bankCd"));
			params.put("bankAcctCd", request.getParameter("bankAcctCd"));
			this.giacBankAccountsDAO.valDeleteRec(params);
		}
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("bankAcctCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("bankAcctCd", request.getParameter("bankAcctCd"));
			this.giacBankAccountsDAO.valAddRec(params);
		}
	}

	@Override
	public void saveGiacs312(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACBankAccounts.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACBankAccounts.class));
		params.put("appUser", userId);
		this.giacBankAccountsDAO.saveGiacs312(params);
	}

}
