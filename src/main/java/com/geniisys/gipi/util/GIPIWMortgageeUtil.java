package com.geniisys.gipi.util;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIParMortgagee;

public class GIPIWMortgageeUtil {
	
	public static Map<String, Object> prepareMortgagees(final HttpServletRequest request, final GIISUser USER){
		Map<String, Object> insMortgMap = new HashMap<String, Object>();
		
		String[] insMortgItemNos	= request.getParameterValues("insMortgItemNos");
		String[] insMortgCds		= request.getParameterValues("insMortgAmounts");
		String[] insMortgAmts		= request.getParameterValues("insMortgCds");
		
		insMortgMap.put("parId", Integer.parseInt(request.getParameter("globalParId")));
		insMortgMap.put("issCd", request.getParameter("globalIssCd"));
		insMortgMap.put("userId", USER.getUserId());
		insMortgMap.put("insMortgItemNos", insMortgItemNos);
		insMortgMap.put("insMortgCds", insMortgCds);
		insMortgMap.put("insMortgAmts", insMortgAmts);
		
		return insMortgMap;
	}
	
	public static List<GIPIParMortgagee> prepareInsGipiWMortgageeList(final HttpServletRequest request, final GIISUser USER){
		List<GIPIParMortgagee> mortgageeList = new ArrayList<GIPIParMortgagee>();
		
		String[] insMortgItemNos	= request.getParameterValues("insMortgItemNos");
		String[] insMortgCds		= request.getParameterValues("insMortgCds");
		String[] insMortgAmts		= request.getParameterValues("insMortgAmounts");
		
		GIPIParMortgagee mortgagee = null;
		
		for(int i=0, length = insMortgItemNos.length; i < length; i++){
			mortgagee = new GIPIParMortgagee();
			mortgagee.setParId(Integer.parseInt(request.getParameter("globalParId")));
			mortgagee.setIssCd(request.getParameter("globalIssCd"));
			mortgagee.setUserId(USER.getUserId());
			mortgagee.setItemNo(Integer.parseInt(insMortgItemNos[i]));
			mortgagee.setMortgCd(insMortgCds[i]);
			mortgagee.setAmount(new BigDecimal(insMortgAmts[i].replaceAll(",", "")));
			mortgageeList.add(mortgagee);
			mortgagee = null;
		}
		
		return mortgageeList;
	}
	
	public static List<Map<String, Object>> prepareDelGipiWMortgageeList(final HttpServletRequest request){
		List<Map<String, Object>> mortgageeList = new ArrayList<Map<String, Object>>();
		
		String[] delMortgItemNos = request.getParameterValues("delMortgageeItemNos");
		String[] delMortgCds	= request.getParameterValues("delMortgCds");
		
		Map<String, Object> mortgagee = null;
		
		for(int i=0, length = delMortgItemNos.length; i < length; i++){
			mortgagee = new HashMap<String, Object>();
			mortgagee.put("parId", Integer.parseInt(request.getParameter("globalParId")));
			mortgagee.put("itemNo", Integer.parseInt(delMortgItemNos[i]));
			mortgagee.put("mortgCd", delMortgCds[i]);
			mortgageeList.add(mortgagee);
			mortgagee = null;
		}		
		
		return mortgageeList;
	}
}
