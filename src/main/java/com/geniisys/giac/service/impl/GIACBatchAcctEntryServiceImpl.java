/**
 * 
 */
package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.dao.GIACBatchAcctEntryDAO;
import com.geniisys.giac.entity.GIACBatchAcctEntry;
import com.geniisys.giac.service.GIACBatchAcctEntryService;

/**
 * @author steven
 * @date 04.11.2013
 */
public class GIACBatchAcctEntryServiceImpl implements GIACBatchAcctEntryService{
	
	private GIACBatchAcctEntryDAO giacBatchAcctEntryDAO;
	
	/**
	 * @return the giacBatchAcctEntryDAO
	 */
	public GIACBatchAcctEntryDAO getGiacBatchAcctEntryDAO() {
		return giacBatchAcctEntryDAO;
	}


	/**
	 * @param giacBatchAcctEntryDAO the giacBatchAcctEntryDAO to set
	 */
	public void setGiacBatchAcctEntryDAO(GIACBatchAcctEntryDAO giacBatchAcctEntryDAO) {
		this.giacBatchAcctEntryDAO = giacBatchAcctEntryDAO;
	}

	@Override
	public void showBatchAccountingEntry(HttpServletRequest request, GIISUser USER) throws SQLException {
		request.setAttribute("enterAdvPayt", getGiacBatchAcctEntryDAO().getGIACParamValue("ENTER_ADVANCED_PAYT"));
		request.setAttribute("enterPrepaidComm", getGiacBatchAcctEntryDAO().getGIACParamValue("ENTER_PREPAID_COMM"));
		request.setAttribute("excludeSpecial", getGiacBatchAcctEntryDAO().getGIACParamValue("EXCLUDE_SPECIAL"));
	}

	@Override
	public List<Map<String, Object>> validateProdDate(HttpServletRequest request)
			throws SQLException {
		List<Map<String, Object>> result = (List<Map<String, Object>>) getGiacBatchAcctEntryDAO().validateProdDate(request.getParameter("prodDate"));
		return result;
	}


	@Override
	public List<GIACBatchAcctEntry> generateDataCheck(
			HttpServletRequest request, GIISUser USER) throws SQLException, Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("dateCheckParams", prepareDateCheckParams(request));
		return getGiacBatchAcctEntryDAO().generateDataCheck(params);
	}
	

	@Override
	public void validateWhenExit() throws SQLException, Exception {
		getGiacBatchAcctEntryDAO().validateWhenExit();
	}


	@Override
	public List<GIACBatchAcctEntry> genAccountingEntry(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		List<GIACBatchAcctEntry> result = new ArrayList<GIACBatchAcctEntry>();
		String giacbNum = request.getParameter("giacbNum");
		if (giacbNum.equals("1")) {
			result = getGiacBatchAcctEntryDAO().giacb001Proc(prepareGIACB000Params(request, USER));
		}else if (giacbNum.equals("4")) {
			result = getGiacBatchAcctEntryDAO().giacb004Proc(prepareGIACB000Params(request, USER));
		}else if (giacbNum.equals("2")) {
			result = getGiacBatchAcctEntryDAO().giacb002Proc(prepareGIACB000Params(request, USER));
		}else if (giacbNum.equals("3")) {
			result = getGiacBatchAcctEntryDAO().giacb003Proc(prepareGIACB000Params(request, USER));
		}else if (giacbNum.equals("6")) {
			result = getGiacBatchAcctEntryDAO().giacb005Proc(prepareGIACB000Params(request, USER));
		}else if (giacbNum.equals("7")) {
			result = getGiacBatchAcctEntryDAO().giacb006Proc(prepareGIACB000Params(request, USER));
		}else if (giacbNum.equals("8")) { //benjo 10.13.2016 SR-5512
			result = getGiacBatchAcctEntryDAO().giacb007Proc(prepareGIACB000Params(request, USER));
		}
		return result;
	}

	@Override
	public void prodSumRepAndPerilExt(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		getGiacBatchAcctEntryDAO().prodSumRepAndPerilExt(prepareDateCheckParams(request));
	}
	
	private List<GIACBatchAcctEntry> prepareDateCheckParams(HttpServletRequest request) throws ParseException {
		GIACBatchAcctEntry giacBatchAcctEntry = new GIACBatchAcctEntry();
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		List<GIACBatchAcctEntry> dateCheckParamList = new ArrayList<GIACBatchAcctEntry>();
		giacBatchAcctEntry.setProdDate(sdf.parse(request.getParameter("prodDate")));
		giacBatchAcctEntry.setReport(null);
		giacBatchAcctEntry.setLog(null);
		giacBatchAcctEntry.setErrorMsg(null);
		giacBatchAcctEntry.setCond(Boolean.parseBoolean(request.getParameter("cond")));
		dateCheckParamList.add(giacBatchAcctEntry);
		return dateCheckParamList;
	}
	
	private List<GIACBatchAcctEntry> prepareGIACB000Params(HttpServletRequest request,
			GIISUser USER) throws ParseException, SQLException {
		GIACBatchAcctEntry giacBatchAcctEntry = new GIACBatchAcctEntry();
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		List<GIACBatchAcctEntry> giacb000ParamsList = new ArrayList<GIACBatchAcctEntry>();
		giacBatchAcctEntry.setProdDate(sdf.parse(request.getParameter("prodDate")));
		giacBatchAcctEntry.setNewProdDate(null);
		giacBatchAcctEntry.setExcludeSpecial(getGiacBatchAcctEntryDAO().getGIACParamValue("EXCLUDE_SPECIAL"));
		giacBatchAcctEntry.setUserId(USER.getUserId());
		giacBatchAcctEntry.setMsg(null);
		giacBatchAcctEntry.setLog(null);
		giacBatchAcctEntry.setGenHome(null);
		giacBatchAcctEntry.setSqlPath(null);
		giacBatchAcctEntry.setVarParamValueN(null);
		giacBatchAcctEntry.setFundCd(null);
		giacBatchAcctEntry.setRiIssCd(null);
		giacBatchAcctEntry.setPremRecGrossTag(null);
		giacBatchAcctEntry.setProcess(null);
		giacb000ParamsList.add(giacBatchAcctEntry);
		return giacb000ParamsList;
	}
}
