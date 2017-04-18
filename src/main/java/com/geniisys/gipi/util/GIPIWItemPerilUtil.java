package com.geniisys.gipi.util;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.geniisys.gipi.entity.GIPIWItemPeril;

public class GIPIWItemPerilUtil {
	
	private static Logger log = Logger.getLogger(GIPIWItemPerilUtil.class);

	public static List<GIPIWItemPeril> prepareInsItemPerilList(final HttpServletRequest request){
		List<GIPIWItemPeril> itemPerilList = new ArrayList<GIPIWItemPeril>();
		
		String[] itemNos 		= request.getParameterValues("perilItemNos");
		String[] lineCds 		= request.getParameterValues("perilLineCds");
		String[] perilCds 		= request.getParameterValues("perilPerilCds");
		String[] premRts 		= request.getParameterValues("perilPremRts");
		String[] tsiAmts 		= request.getParameterValues("perilTsiAmts");
		String[] premAmts 		= request.getParameterValues("perilPremAmts");
		String[] compRems 		= request.getParameterValues("perilCompRems");		
		String[] tarfCds 		= request.getParameterValues("perilTarfCds");
		String[] annTsiAmts 	= request.getParameterValues("perilAnnTsiAmts");
		String[] annPremAmts 	= request.getParameterValues("perilAnnPremAmts");
		String[] prtFlags 		= request.getParameterValues("perilPrtFlags");
		String[] riCommRates 	= request.getParameterValues("perilRiCommRates");
		String[] riCommAmts 	= request.getParameterValues("perilRiCommAmts");
		String[] surchargeSws 	= request.getParameterValues("perilSurchargeSws");
		String[] baseAmts 		= request.getParameterValues("perilBaseAmts");
		String[] aggregateSws 	= request.getParameterValues("perilAggregateSws");
		String[] discountSws 	= request.getParameterValues("perilDiscountSws");
		String[] bascPerlCds 	= request.getParameterValues("perilBascPerlCds");
		String[] noOfDayss	 	= request.getParameterValues("perilNoOfDayss");
		
		GIPIWItemPeril peril = null;
		
		for(int i=0, length=itemNos.length; i<length; i++){
			BigDecimal premRt =  "0.000000000".equals(premRts[i]) ? new BigDecimal("0") : new BigDecimal(premRts[i]);//(new BigDecimal(premRts[i])).intValue() == 0 ? null :  new BigDecimal(premRts[i]);
			/***added to handle zero value for premium rate being converted to exponential when carried to ibatis********/
			/***BRYAN 10/14/2010***/
			
			peril = new GIPIWItemPeril();
			peril.setParId(Integer.parseInt(request.getParameter("globalParId")));
			peril.setItemNo(Integer.parseInt(itemNos[i]));
			peril.setLineCd(lineCds[i]);
			peril.setPerilCd(Integer.parseInt(perilCds[i]));
			peril.setPremRt(premRt);//(new BigDecimal(premRts[i].replaceAll(",", ""))));
			peril.setTsiAmt(new BigDecimal(tsiAmts[i].isEmpty() ? "0.00" : tsiAmts[i].replaceAll(",", "")));
			peril.setPremAmt(new BigDecimal(premAmts[i].isEmpty() ? "0.00" : premAmts[i].replaceAll(",", "")));
			peril.setCompRem(compRems[i]);
			peril.setTarfCd(tarfCds[i]);
			peril.setAnnTsiAmt(new BigDecimal(annTsiAmts[i].isEmpty() ? "0.00" : annTsiAmts[i].replaceAll(",", "")));
			peril.setAnnPremAmt(new BigDecimal(annPremAmts[i].isEmpty() ? "0.00" : annPremAmts[i].replaceAll(",", "")));
			peril.setPrtFlag(prtFlags[i]);
			peril.setRiCommRate(new BigDecimal(riCommRates[i].isEmpty() ? "0.00" : riCommRates[i].replaceAll(",", "")));
			peril.setRiCommAmt(new BigDecimal(riCommAmts[i].isEmpty() ? "0.00" : riCommAmts[i].replaceAll(",", "")));
			peril.setSurchargeSw(surchargeSws[i]);
			peril.setBaseAmt(new BigDecimal(baseAmts[i].isEmpty() ? "0.00" : baseAmts[i].replaceAll(",", "")));
			peril.setAggregateSw(aggregateSws[i]);
			peril.setDiscountSw(discountSws[i]);
			peril.setBascPerlCd(bascPerlCds[i] == "" ? null : Integer.parseInt(bascPerlCds[i]));
			peril.setNoOfDays(noOfDayss[i] == "" ? null : Integer.parseInt(noOfDayss[i]));
			itemPerilList.add(peril);
			peril = null;			
		}
		
		return itemPerilList;		
	}
	
	public static List<Map<String, Object>> prepareDelGipiWDeductiblesList(final HttpServletRequest request){
		List<Map<String, Object>> itemPerilList = new ArrayList<Map<String, Object>>();
		
		String[] itemNos	= request.getParameterValues("delPerilItemNos");
		String[] perilCds	= request.getParameterValues("delPerilCds");
		String[] lineCds	= request.getParameterValues("delPerilLineCds");
		
		System.out.println("itemNos.length: "+itemNos.length);
		System.out.println("perilCds.length: "+perilCds.length);
		System.out.println("lineCds.length: "+lineCds.length);
		
		for(int i=0, length=itemNos.length; i<length; i++){
			Map<String, Object> perilMap = new HashMap<String, Object>();
			log.info("parId: "+request.getParameter("globalParId"));
			log.info("itemNo: "+itemNos[i]);
			log.info("perilCd: "+perilCds[i]);
			log.info("lineCd: "+lineCds[i]);
			perilMap.put("parId", Integer.parseInt(request.getParameter("globalParId")));
			perilMap.put("itemNo", Integer.parseInt(itemNos[i] == "" ? "0" : itemNos[i]));
			perilMap.put("perilCd", Integer.parseInt(perilCds[i] == "" ? "0" : perilCds[i]));
			perilMap.put("lineCd", lineCds[i]);
			itemPerilList.add(perilMap);
			perilMap = null;			
		}
		
		return itemPerilList;
	}
	
	public static Map<String, Object> loadPerilVariablesToMap(final HttpServletRequest request, final Map<String, Object> param){
		Map<String, Object> newMap = param;
		
		String[] masterItemNos			= request.getParameterValues("masterItemNos");
		String[] masterTsiAmts			= request.getParameterValues("masterTsiAmts");
		String[] masterPremAmts			= request.getParameterValues("masterPremAmts");
		String[] masterAnnTsiAmts		= request.getParameterValues("masterAnnTsiAmts");
		String[] masterAnnPremAmts		= request.getParameterValues("masterAnnPremAmts");
		String[] discDeleteds 			= request.getParameterValues("discDeleted");
		String[] wcSws 					= request.getParameterValues("perilWcSws");
		
		newMap.put("masterItemNos", masterItemNos);
		newMap.put("masterTsiAmts", masterTsiAmts);
		newMap.put("masterPremAmts", masterPremAmts);
		newMap.put("masterAnnTsiAmts", masterAnnTsiAmts);
		newMap.put("masterAnnPremAmts", masterAnnPremAmts);
		newMap.put("discDeleteds", discDeleteds);
		newMap.put("wcSws", wcSws);
				
		return newMap;
	}
}
