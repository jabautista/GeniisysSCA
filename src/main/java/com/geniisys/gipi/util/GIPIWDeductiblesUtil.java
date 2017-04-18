package com.geniisys.gipi.util;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.entity.GIPIWDeductible;

public class GIPIWDeductiblesUtil {

	public static List<GIPIWDeductible> prepareInsGipiWDeductiblesList(final HttpServletRequest request, final GIISUser USER, final int deductibleLevel){
		List<GIPIWDeductible> deductibleList = new ArrayList<GIPIWDeductible>();
		
		String[] itemNos 			= request.getParameterValues("insDedItemNo" + deductibleLevel);		
		String[] perilCds 		 	= request.getParameterValues("insDedPerilCd" + deductibleLevel);
		String[] deductibleCds 	 	= request.getParameterValues("insDedDeductibleCd" + deductibleLevel);
		String[] deductibleAmts  	= request.getParameterValues("insDedAmount" + deductibleLevel);
		String[] deductibleRts 	 	= request.getParameterValues("insDedRate" + deductibleLevel);
		String[] deductibleTexts 	= request.getParameterValues("insDedText" + deductibleLevel);
		String[] aggregateSws 	 	= request.getParameterValues("insDedAggregateSw" + deductibleLevel);
		String[] ceilingSws 	 	= request.getParameterValues("insDedCeilingSw" + deductibleLevel);
		String[] minimumAmounts		= request.getParameterValues("insDedMinimumAmount" + deductibleLevel);
		String[] maximumAmounts		= request.getParameterValues("insDedMaximumAmount" + deductibleLevel);
		String[] rangeSws			= request.getParameterValues("insDedRangeSw" + deductibleLevel);
		
		GIPIWDeductible deductible = null;
		for(int i=0, length=itemNos.length; i < length; i++){
			deductible = new GIPIWDeductible();
			deductible.setParId(Integer.parseInt(request.getParameter("globalParId")));
			deductible.setDedLineCd(request.getParameter("globalLineCd"));
			deductible.setDedSublineCd(request.getParameter("globalSublineCd"));
			deductible.setUserId(USER.getUserId());
			deductible.setItemNo(Integer.parseInt(itemNos[i]));
			deductible.setPerilCd(Integer.parseInt(perilCds[i]));
			deductible.setDedDeductibleCd(deductibleCds[i]);
			deductible.setDeductibleAmount(new BigDecimal(deductibleAmts[i].isEmpty() ? "0.00" : deductibleAmts[i].replaceAll(",", "")));
			deductible.setDeductibleRate(new BigDecimal(deductibleRts[i].isEmpty() ? "0.00" : deductibleRts[i]));
			deductible.setDeductibleText(deductibleTexts[i]);
			deductible.setAggregateSw(aggregateSws[i]);
			deductible.setCeilingSw(ceilingSws[i]);
			
			System.out.println("GIPIWDeductiblesUtil amounts(" + i + "): " + minimumAmounts[i] + " / " + maximumAmounts[i]);
			if(!(minimumAmounts[i].equals(""))) {
				deductible.setMinimumAmount(new BigDecimal(minimumAmounts[i].isEmpty()? "0.00" : minimumAmounts[i]));
			}
			
			System.out.println("GIPIWDeductiblesUtil dedItems(" + i + "): " + itemNos[i] + " - :dedCd->" + deductibleCds[i] + "-" + deductibleTexts[i]);
			
			deductible.setMaximumAmount(new BigDecimal(maximumAmounts[i].isEmpty()? "0.00" : maximumAmounts[i]));
			deductible.setRangeSw(rangeSws[i]);
			deductibleList.add(deductible);
			deductible = null;
			
			System.out.println("GIPIWDeductiblesUtil: " + new BigDecimal(minimumAmounts[i].isEmpty()? "0.00" : minimumAmounts[i])
								+ " - " + new BigDecimal(maximumAmounts[i].isEmpty()? "0.00" : maximumAmounts[i]));
		}
		
		return deductibleList;		
	}
	
	public static List<Map<String, Object>> prepareDelGipiWDeductiblesList(final HttpServletRequest request, final int deductibleLevel){
		List<Map<String, Object>> deductibleList = new ArrayList<Map<String, Object>>();		
		
		String[] itemNos			= request.getParameterValues("delDedItemNo" + deductibleLevel);			
		String[] deductibleCds 	 	= request.getParameterValues("delDedDeductibleCd" + deductibleLevel);
		
		for(int i=0, length=itemNos.length; i <length; i++){
			Map<String, Object> deductibleMap = new HashMap<String, Object>();
			deductibleMap.put("parId", Integer.parseInt(request.getParameter("globalParId")));
			deductibleMap.put("itemNo", Integer.parseInt(itemNos[i]));
			deductibleMap.put("dedDeductibleCd", deductibleCds[i]);
			deductibleList.add(deductibleMap);
			deductibleMap = null;
		}
		
		return deductibleList;
	}
}
