/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISParameter;
import com.geniisys.common.entity.GIISPeril;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISPerilService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIItemPeril;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;
import com.geniisys.gipi.service.GIPIItemPerilService;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWItmperlGroupedService;
import com.geniisys.gipi.service.GIPIWPolBasicService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWItemPerilController.
 */
public class GIPIWItemPerilController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWItemPerilController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
			log.info("ACTION: "+ACTION);
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWItemPerilService gipiWItemPerilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
			GIPIWItmperlGroupedService gipiWItmperlGroupedService = (GIPIWItmperlGroupedService) APPLICATION_CONTEXT.getBean("gipiWItmperlGroupedService");
			//GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
			//GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
			//GIPIWPolBasicService gipiWPolBasicService = (GIPIWPolBasicService) APPLICATION_CONTEXT.getBean("gipiWPolBasicService");
			//LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
			
			int parId = Integer.parseInt((request.getParameter("globalParId") == null) ? "0" : request.getParameter("globalParId"));
			GIPIPARList gipiPAR = null;
			if (parId != 0)	{
				GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				gipiPAR = gipiParService.getGIPIPARDetails(parId);//, packParId);
				gipiPAR.setParId(parId);
				request.setAttribute("parDetails", gipiPAR);
				System.out.println("discExists: "+gipiPAR.getDiscExists());
			}
			if ("showPerilInfoPage".equals(ACTION)){
				log.info("Creating peril information form...");
				GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
				GIISParameterFacadeService serv = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				//GIPIWPolBasicService gipiWPolBasicService = (GIPIWPolBasicService) APPLICATION_CONTEXT.getBean("gipiWPolBasicService");
				//LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				System.out.println("showPerilInfoPage parId: "+parId);
				Map<String, Object> parInfo = (Map<String, Object>) GIPIPARUtil.getPARInfo(request);
				GIPIPARUtil.setPARInfo(request, parInfo);
				
				//for item information block
				List<GIPIWItem> parItemInfo = (List<GIPIWItem>) gipiWItemService.getGIPIWItem(parId);
				request.setAttribute("parItemInfo", parItemInfo);
				
				int wItemCount = gipiWItemService.getWItemCount(parId);
				System.out.println("Item count: "+wItemCount);
				request.setAttribute("wItemParCount", wItemCount);
				String issCdRi = serv.getParamValueV2("ISS_CD_RI");
				System.out.println("issCdRi: "+issCdRi);
				request.setAttribute("issCdRi", issCdRi);
				System.out.println("issCd: "+gipiPAR.getIssCd());
				request.setAttribute("paramName", serv.getParamByIssCd(gipiPAR.getIssCd()));
				System.out.println("paramName: "+serv.getParamByIssCd(gipiPAR.getIssCd()));
				PAGE ="/pages/underwriting/perilInformationMain.jsp";
			} else if ("getItemPerilDetails".equals(ACTION)){
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				String isExist = gipiWItmperlGroupedService.isExist(parId, itemNo);
				log.info("isExist: "+isExist);
				message = isExist;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("loadItemPerilTable".equals(ACTION)){
				log.info("Loading item peril table...");
				//GIPIWItemPerilService gipiWItemPerilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
				GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");				
				GIISParameterFacadeService serv = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");//belle
				
				//parId = 51676;
				log.info("loadItemPerilTable parId: "+parId);
				List<GIPIWItem> items = gipiWItemService.getGIPIWItem(parId);
				List<Integer> itemNos = new ArrayList<Integer>();
				for (GIPIWItem item: items){
					itemNos.add(item.getItemNo());
				}
				
				GIISParameter markUpTag =  serv.getParamValueV("MARINE_TSI_AMT"); 
				request.setAttribute("markUpTag", markUpTag.getParamValueV());
				
				request.setAttribute("wItemPeril", gipiWItemPerilService.getGIPIWItemPerils(parId));
				request.setAttribute("itemNos", itemNos);		
				
				/********************FOR JSON IMPLEMENTATION**********************/
				LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				
				JSONObject jsonGIPIPARList = new JSONObject(gipiPAR);
				StringFormatter.replaceQuotesInObject(jsonGIPIPARList);
				request.setAttribute("jsonGIPIPARList", jsonGIPIPARList);
				
				
				
				//List<GIPIParItemMC> itemListing = (List<GIPIParItemMC>) StringFormatter.replaceQuotesInList(items);
				StringFormatter.replaceQuotesInList(items);
				request.setAttribute("jsonItemList", new JSONArray (items));
				
				List<GIPIWItemPeril> perilListing = gipiWItemPerilService.getGIPIWItemPerils(parId);
				StringFormatter.replaceQuotesInList(perilListing);				
				request.setAttribute("jsonItemPerilList", new JSONArray(perilListing));
				
				String lineCd = gipiPAR.getLineCd();
				String[] arg1 = {lineCd};
				List<LOV> perilClauseListing = lovHelper.getList(LOVHelper.PERIL_CLAUSES_LISTING, arg1); 
				StringFormatter.replaceQuotesInList(perilClauseListing);
				request.setAttribute("jsonPerilClauseList", new JSONArray(perilClauseListing));
				
				GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService = (GIPIWPolicyWarrantyAndClauseFacadeService) APPLICATION_CONTEXT.getBean("gipiWPolicyWarrantyAndClauseFacadeService");
				List<GIPIWPolicyWarrantyAndClause> wPolWCListing = gipiWPolWCService.getAllWPolicyWCs(lineCd, parId);
				StringFormatter.replaceQuotesInList(wPolWCListing);
				request.setAttribute("jsonWPolWCList", new JSONArray(wPolWCListing));
				
				PAGE="/pages/underwriting/subPages/parPerilInformationListingTable.jsp";
				
			} else if ("saveWItemPeril".equals(ACTION)){
				log.info("Saving changes in item peril information page...");								
				
				//GIPIWItemPerilService gipiWItemPerilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
				GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
				if(request.getParameterValues("delPerilItemNos") != null){
					String[] delPerilItemNos = request.getParameterValues("delPerilItemNos");
					String[] delPerilCds = request.getParameterValues("delPerilCds");
					String[] delPerilLineCds = request.getParameterValues("delPerilLineCds");
					
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("delPerilItemNos", delPerilItemNos);
					params.put("delPerilCds", delPerilCds);
					params.put("delPerilLineCds", delPerilLineCds);
					params.put("delParId", parId);
					gipiWItemPerilService.deleteWItemPeril(params);
				}				
				
				String[] itemNumbers = request.getParameterValues("masterItemNos");
				
				Map<String, Object> params = new HashMap<String, Object>();
				String[] discDeleteds = request.getParameterValues("discDeleted");
				
				for (String a: discDeleteds){
					System.out.println("a: "+a);
				}
				
				String deldiscSw = request.getParameter("deldiscSw");
				params.put("parId", parId);
				params.put("deldiscSw", deldiscSw);
				params.put("itemNos", itemNumbers);
				params.put("discDeleteds", discDeleteds);
				
				if(itemNumbers != null){
					String[] tsiAmts = request.getParameterValues("masterTsiAmts");
					String[] premAmts = request.getParameterValues("masterPremAmts");
					String[] annTsiAmts = request.getParameterValues("masterAnnTsiAmts");
					String[] annPremAmts = request.getParameterValues("masterAnnPremAmts");
					
					//Map<String, Object> itemPerils = new HashMap<String, Object>();
					
					for(int index=0, length=itemNumbers.length; index < length; index++){
						gipiWItemService.updateItemValues(
							new BigDecimal(tsiAmts[index]), new BigDecimal(premAmts[index]),
							new BigDecimal(annTsiAmts[index]), new BigDecimal(annPremAmts[index]),
							parId, Integer.parseInt(itemNumbers[index]));
						gipiWItemPerilService.updateWItem(parId, Integer.parseInt(itemNumbers[index]));						
					}
					
					if(request.getParameterValues("perilItemNos") != null){
						String[] perilItemNos = request.getParameterValues("perilItemNos");
						String[] perilLineCds = request.getParameterValues("perilLineCds");
						String[] perilPerilCds = request.getParameterValues("perilPerilCds");
						String[] perilPremRts = request.getParameterValues("perilPremRts");
						String[] perilTsiAmts = request.getParameterValues("perilTsiAmts");
						String[] perilPremAmts = request.getParameterValues("perilPremAmts");
						String[] perilCompRems = request.getParameterValues("perilCompRems");
						String[] perilWcSws = request.getParameterValues("perilWcSws");
						String[] perilTarfCds = request.getParameterValues("perilTarfCds");
						String[] perilAnnTsiAmts = request.getParameterValues("perilAnnTsiAmts");
						String[] perilAnnPremAmts = request.getParameterValues("perilAnnPremAmts");
						String[] perilPrtFlags = request.getParameterValues("perilPrtFlags");
						String[] perilRiCommRates = request.getParameterValues("perilRiCommRates");
						String[] perilRiCommAmts = request.getParameterValues("perilRiCommAmts");
						String[] perilSurchargeSws = request.getParameterValues("perilSurchargeSws");
						String[] perilBaseAmts = request.getParameterValues("perilBaseAmts");
						String[] perilAggregateSws = request.getParameterValues("perilAggregateSws");
						String[] perilDiscountSws = request.getParameterValues("perilDiscountSws");
						String[] perilBascPerlCds = request.getParameterValues("perilBascPerlCds");
						String[] perilNoOfDayss = request.getParameterValues("perilNoOfDayss");
						
						if (perilRiCommAmts != null){
							System.out.println("perilRiCommAmts length: "+perilRiCommAmts.length);
							for (int x=0; x<perilRiCommAmts.length; x++){
								System.out.println("riCommAmts val controller: "+perilRiCommAmts[x]);
							}
						}
						
						//for(int index=0, length=perilItemNos.length; index<length; index++){
							//Map<String, Object> perilMap = new HashMap<String, Object>();
							params.put("itemNos2", perilItemNos);
							params.put("lineCds", perilLineCds);
							params.put("perilCds", perilPerilCds);
							params.put("perilRates", perilPremRts);
							params.put("tsiAmounts", perilTsiAmts);
							params.put("premAmts", perilPremAmts);
							params.put("compRems", perilCompRems);
							params.put("wcSws", perilWcSws);
							params.put("tarfCds", perilTarfCds);
							params.put("annPremAmts", perilAnnPremAmts);
							params.put("prtFlags", perilPrtFlags);
							params.put("riCommRates", perilRiCommRates);
							params.put("riCommAmts", perilRiCommAmts);
							params.put("surchargeSws", perilSurchargeSws);
							params.put("baseAmts", perilBaseAmts);
							params.put("aggregateSws", perilAggregateSws);
							params.put("annTsiAmts", perilAnnTsiAmts);
							params.put("discountSws", perilDiscountSws);
							params.put("bascPerlCds", perilBascPerlCds);
							params.put("noOfDayss", perilNoOfDayss);
							//itemPerils.put(itemNumbers[index], perilMap);
						//}						
					}
					
					//params.put("itemPerils", itemPerils);
					gipiWItemPerilService.saveWItemPeril(params);
					
					gipiParService.insertParHist(parId, USER.getUserId(), "", "5");
					gipiWItemService.updateWPolbas(parId);
					int packParId = Integer.parseInt((request.getParameter("globalPackParId") == null) ? "0" : request.getParameter("globalPackParId"));
					System.out.println("packParId: "+packParId);
					if (packParId != 0){
						GIPIWPolBasicService gipiWPolBasicService = (GIPIWPolBasicService) APPLICATION_CONTEXT.getBean("gipiWPolBasicService");
						gipiWPolBasicService.updatePackWPolbas(packParId);
					}
					gipiParService.deleteBill(parId);
					String lineCd = request.getParameter("globalLineCd");
					String issCd = request.getParameter("globalIssCd");
					String packPolFlag = request.getParameter("globalPackPolFlag");
					System.out.println("lineCd: "+lineCd);
					System.out.println("issCd: "+issCd);
					System.out.println("packPolFlag: "+packPolFlag);
					if (packParId != 0){
						gipiWItemPerilService.createWInvoiceForPAR(parId, lineCd, issCd);
					}
					else {
						if ("Y".equals(packPolFlag)){
							gipiWItemPerilService.createWInvoiceForPAR(parId, lineCd, issCd);
						} else {
							gipiWItemPerilService.createWInvoiceForPAR(parId, lineCd, issCd);
						}
					}
					gipiWItemService.getTsi(parId);
					if (packParId != 0){
						gipiParService.setParStatusToWithPeril(parId, packParId);
					} else {
						gipiParService.setParStatusToWithPeril(parId);
					}
				}
				/*
				Map<String, Object> params = new HashMap<String, Object>();
				String[] itemNos = request.getParameterValues("itemNumber");				
				
				String[] discDeleteds = request.getParameterValues("discDeleted");
				String deldiscSw = request.getParameter("deldiscSw");
				params.put("parId", parId);
				params.put("deldiscSw", deldiscSw);
				params.put("itemNos", itemNos);
				params.put("discDeleteds", discDeleteds);
				Map<String, Object> itemPerils = new HashMap<String, Object>();
				if (itemNos != null)	{
					for (int i=0; i<itemNos.length; i++)	{
						//System.out.println("CONTROLLER - i="+i);
						//to update values in gipi_witem
						BigDecimal tsiAmt = new BigDecimal(request.getParameter("masterTsiAmt"+itemNos[i]));
						BigDecimal premAmt = new BigDecimal(request.getParameter("masterPremAmt"+itemNos[i]));
						BigDecimal annTsiAmt = new BigDecimal(request.getParameter("masterAnnTsiAmt"+itemNos[i]));
						BigDecimal annPremAmt = new BigDecimal(request.getParameter("masterAnnPremAmt"+itemNos[i]));
						Integer itemNo = Integer.parseInt(itemNos[i]);
						System.out.println("CONTROLLER - itemNo: "+itemNo);
						System.out.println("CONTROLLER - tsiAmt: "+tsiAmt);
						System.out.println("CONTROLLER - premAmt: "+premAmt);
						System.out.println("CONTROLLER - annTsiAmt: "+annTsiAmt);
						System.out.println("CONTROLLER - annPremAmt: "+annPremAmt);
						gipiWItemService.updateItemValues(tsiAmt, premAmt, annTsiAmt, annPremAmt, parId, itemNo);
						gipiWItemPerilService.updateWItem(parId, itemNo);
						
						//saving GIPIWItemPeril changes
						Map<String, Object> perilMap = new HashMap<String, Object>();
						perilMap.put("itemNos2", request.getParameterValues("itemNo"+itemNos[i]));
						perilMap.put("lineCds", request.getParameterValues("lineCd"+itemNos[i]));
						perilMap.put("perilCds", request.getParameterValues("perilCd"+itemNos[i]));
						perilMap.put("perilRates", request.getParameterValues("premRt"+itemNos[i]));
						perilMap.put("tsiAmounts", request.getParameterValues("tsiAmt"+itemNos[i]));
						perilMap.put("premAmts", request.getParameterValues("premAmt"+itemNos[i]));
						perilMap.put("compRems", request.getParameterValues("compRem"+itemNos[i]));
						perilMap.put("wcSws", request.getParameterValues("wcSw"+itemNos[i]));
						System.out.println("CONTROLLER - wcSw: "+request.getParameterValues("wcSw"+itemNos[i]));
						//System.out.println("CONTROLLER - itemNo"+itemNos[i]+":"+request.getParameterValues("itemNo"+itemNos[i]));
						//System.out.println("CONTROLLER - lineCd"+itemNos[i]+":"+request.getParameterValues("lineCd"+itemNos[i]));
						//System.out.println("CONTROLLER - perilCd"+itemNos[i]+":"+request.getParameterValues("perilCd"+itemNos[i]));
						//System.out.println("CONTROLLER - premRt"+itemNos[i]+":"+request.getParameterValues("premRt"+itemNos[i]));
						//System.out.println("CONTROLLER - tsiAmt"+itemNos[i]+":"+request.getParameterValues("tsiAmt"+itemNos[i]));
						itemPerils.put(itemNos[i], perilMap);
					}
				}
				params.put("itemPerils", itemPerils);
				gipiWItemPerilService.saveWItemPeril(params);
				gipiParService.insertParHist(parId, USER.getUserId(), "", "5");
				gipiWItemService.updateWPolbas(parId);
				int packParId = Integer.parseInt((request.getParameter("globalPackParId") == null) ? "0" : request.getParameter("globalPackParId"));
				System.out.println("packParId: "+packParId);
				if (packParId != 0){
					gipiWPolBasicService.updatePackWPolbas(packParId);
				}
				gipiParService.deleteBill(parId);
				String lineCd = request.getParameter("globalLineCd");
				String issCd = request.getParameter("globalIssCd");
				String packPolFlag = request.getParameter("globalPackPolFlag");
				System.out.println("lineCd: "+lineCd);
				System.out.println("issCd: "+issCd);
				System.out.println("packPolFlag: "+packPolFlag);
				gipiWItemPerilService.createWInvoiceForPAR(parId, lineCd, issCd);
				gipiWItemService.getTsi(parId);
				if (packParId != 0){
					gipiParService.setParStatusToWithPeril(parId, packParId);
				} else {
					gipiParService.setParStatusToWithPeril(parId);
				}
				*/
				message = "SAVING SUCCESSFUL.";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveCopiedPeril".equals(ACTION)){ //added by steven 10/23/2012
				gipiWItemPerilService.saveCopiedPeril(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkItemPerilDeductibles".equals(ACTION)){
				log.info("Copying peril items...");
				
				//GIPIWItemPerilService gipiWItemPerilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
				String lineCd = request.getParameter("lineCd");
				String nbtSublineCd = request.getParameter("nbtSublineCd");
				String wDedPerilItemNoExists = gipiWItemPerilService.checkDeductibleItemNo(parId, lineCd, nbtSublineCd);
				System.out.println("Is item no existing? "+wDedPerilItemNoExists);
				message = wDedPerilItemNoExists;
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deleteDiscounts".equals(ACTION)){
				log.info("Deleting discounts...");
				
				//GIPIWItemPerilService gipiWItemPerilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
				System.out.println("parId: "+parId);
				System.out.println("itemNo: "+itemNo);
				Map<String, Object> result = new HashMap<String, Object>();
				result.put("parId", parId);
				result.put("itemNo", itemNo);
				result = gipiWItemPerilService.deleteDeductibles(parId, itemNo);
				//BigDecimal premAmt = new BigDecimal(result.get("premAmt").toString());
				//BigDecimal annPremAmt = new BigDecimal(result.get("annPremAmt").toString());
				String premAmt = result.get("premAmt").toString();
				String annPremAmt = result.get("annPremAmt").toString();
				System.out.println("premAmt: "+premAmt);
				System.out.println("annPremAmt: "+annPremAmt);
				message = itemNo+","+premAmt+","+annPremAmt;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkIfWItemPerilExists".equals(ACTION)){
				log.info("Checking if peril exists...");
				
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				String isExist = gipiWItemPerilService.isExist(parId, itemNo);
				System.out.println("CONTROLLER - isExist: "+isExist);
				message = isExist;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkIfWItemPerilExists2".equals(ACTION)){
				log.info("Checking if peril exists...");
				
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				log.info("Par ID - " + parId);
				log.info("Item No - " + itemNo);
				String isExist = gipiWItemPerilService.isExist2(parId, itemNo);
				message = isExist;
				PAGE = "/pages/genericMessage.jsp";

			} else if ("checkIfParItemHasPeril".equals(ACTION)){
				log.info("Checking if peril exists...");
				
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				log.info("Par ID - " + parId);
				log.info("Item No - " + itemNo);
				String isExist = gipiWItemPerilService.checkIfParItemHasPeril(parId, itemNo);
				message = isExist;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getPerilDetails".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
				Integer perilCd = Integer.parseInt(request.getParameter("perilCd"));
				BigDecimal premAmt = new BigDecimal(request.getParameter("premiumAmt")== ""? "0":request.getParameter("premiumAmt"));
				String compRem = request.getParameter("compRem");
				params.put("parId", parId);
				params.put("itemNo", itemNo);
				params.put("perilCd", perilCd);
				params.put("premAmt", premAmt);
				params.put("compRem", compRem);
				GIPIWItemPeril itmperl = gipiWItemPerilService.getPerilDetails(params);
				message = itmperl.getPremRt()+","+itmperl.getTsiAmt()+","+itmperl.getPremAmt()+","
					+itmperl.getAnnTsiAmt()+","+itmperl.getAnnPremAmt()+","+itmperl.getRiCommRate()+","
					+itmperl.getRiCommAmt();
				System.out.println("message: "+message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("E".equals(request.getParameter("globalParType"))) {  /*** added by andrew 05.11.10 ***/					
				String lineCd 		= (request.getParameter("globalLineCd") == null ? "" : request.getParameter("globalLineCd"));
				String sublineCd 	= (request.getParameter("globalSublineCd") == null ? "" : request.getParameter("globalSublineCd"));
				int itemNo 			= Integer.parseInt((request.getParameter("itemNo") == null || request.getParameter("itemNo") == "" ? "0" : request.getParameter("itemNo")));
				int perilCd			= Integer.parseInt((request.getParameter("perilCd") == null || request.getParameter("perilCd") == "" ? "0" : request.getParameter("perilCd")));
				
				if ("showEndtPerilInfo".equals(ACTION)){							
					GIPIItemPerilService gipiItemPerilService = (GIPIItemPerilService) APPLICATION_CONTEXT.getBean("gipiItemPerilService");
					GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
					String[] perilArgs = {lineCd, sublineCd}; 
					LOVHelper perilLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
					List<LOV> perilsList = perilLovHelper.getList(LOVHelper.ENDT_PERIL_LISTING, perilArgs);
					
					String[] perilTariffArgs = {lineCd}; 
					List<LOV> perilTariffList = perilLovHelper.getList(LOVHelper.PERIL_TARIFF_LISTING, perilTariffArgs);				
					
					List<GIPIWItemPeril> endtItemPerils = (List<GIPIWItemPeril>) StringFormatter.escapeHTMLInListOfMap(gipiWItemPerilService.getEndtItemPeril(parId));
					List<GIPIItemPeril> polItemPerils	= (List<GIPIItemPeril>) StringFormatter.escapeHTMLInList(gipiItemPerilService.getGIPIItemPerils(parId));
					List<GIPIPolbasic> endtPolicy 		= gipiPolbasicService.getEndtPolicy(parId);
					
					request.setAttribute("endtPolicy", endtPolicy);
					request.setAttribute("endtItemPerils", endtItemPerils);
					request.setAttribute("itemPerils", polItemPerils);									
					request.setAttribute("perilsList", perilsList);
					request.setAttribute("perilTariffs", perilTariffList);
					
					request.setAttribute("objEndtItemPerils", new JSONArray(endtItemPerils));
					request.setAttribute("objPolItemPerils", new JSONArray(polItemPerils));
					
					PAGE = "/pages/underwriting/endt/common/subPages/endtPerilInformation.jsp";	
				} else if ("saveEndtPerils".equals(ACTION)){ /*** added by andrew 05.12.10 ***/				
					// peril/s to be inserted.
					String[] insItemNos				= request.getParameterValues("insItemNo");
					String[] insPerilCds 			= request.getParameterValues("insPerilCd");
					String[] insPremiumRates 		= request.getParameterValues("insPremiumRate");
					String[] insTsiAmounts 			= request.getParameterValues("insTsiAmount");
					String[] insAnnTsiAmounts 		= request.getParameterValues("insAnnTsiAmount");
					String[] insPremiumAmounts		= request.getParameterValues("insPremiumAmount");
					String[] insAnnPremiumAmounts	= request.getParameterValues("insAnnPremiumAmount");
					String[] insRemarks				= request.getParameterValues("insRemarks");
					String[] insWcSw				= request.getParameterValues("insWcSw");
					
					Map<String, Object> insParams = new HashMap<String, Object>();
					insParams.put("parId", parId);
					insParams.put("lineCd", lineCd);
					insParams.put("itemNos", insItemNos);
					insParams.put("perilCds", insPerilCds);
					insParams.put("premiumRates", insPremiumRates);
					insParams.put("tsiAmounts", insTsiAmounts);
					insParams.put("annTsiAmounts", insAnnTsiAmounts);
					insParams.put("premiumAmounts", insPremiumAmounts);
					insParams.put("annPremiumAmounts", insAnnPremiumAmounts);
					insParams.put("remarks", insRemarks);
					insParams.put("wcSws", insWcSw);
					
					// peril/s to be deleted.
					String[] delItemNos  = request.getParameterValues("delItemNo");
					String[] delPerilCds = request.getParameterValues("delPerilCd");
					
					Map<String, Object> delParams = new HashMap<String, Object>();
					delParams.put("parId", parId);
					delParams.put("lineCd", lineCd);
					delParams.put("itemNos", delItemNos);
					delParams.put("perilCds", delPerilCds);
					
					// other parameters				
					String delDiscounts 			= request.getParameter("delDiscounts");
					String delPercentTsiDeductibles = request.getParameter("delPercentTsiDeductibles");
					String updateEndtTax 			= request.getParameter("updateEndtTax");
					String packPolFlag   			= request.getParameter("globalPackPolFlag");
					Integer packParId     			= Integer.parseInt((request.getParameter("globalPackParId") == null || request.getParameter("globalPackParId") == "" ? "0" : request.getParameter("globalPackParId")));
					String packLineCd				= request.getParameter("packLineCd");
					String issCd 	    			= request.getParameter("globalIssCd");
					String parTsiAmount 			= request.getParameter("parTsiAmount");
					String parAnnTsiAmount 			= request.getParameter("parAnnTsiAmount");
					String parPremiumAmount			= request.getParameter("parPremiumAmount");
					String parAnnPremiumAmount		= request.getParameter("parAnnPremiumAmount");
	
					Map<String, Object> otherParams = new HashMap<String, Object>();
					otherParams.put("delDiscounts", delDiscounts);
					otherParams.put("delPercentTsiDeductibles", delPercentTsiDeductibles);
					otherParams.put("updateEndtTax", updateEndtTax);
					otherParams.put("packPolFlag", packPolFlag);
					otherParams.put("packParId", packParId);
					otherParams.put("packLineCd", packLineCd);
					otherParams.put("issCd", issCd);
					otherParams.put("parTsiAmount", parTsiAmount);
					otherParams.put("parAnnTsiAmount", parAnnTsiAmount);
					otherParams.put("parPremiumAmount", parPremiumAmount);
					otherParams.put("parAnnPremiumAmount", parAnnPremiumAmount);
					otherParams.put("userId", USER.getUserId());
					
					// deductibles
					String[] perilDedItemNos 		 = request.getParameterValues("dedItemNo3");
					String[] perilDedPerilCds 		 = request.getParameterValues("dedPerilCd3");
					String[] perilDedDeductibleCds 	 = request.getParameterValues("dedDeductibleCd3");
					String[] perilDedDeductibleAmts  = request.getParameterValues("dedAmount3");
					String[] perilDedDeductibleRts 	 = request.getParameterValues("dedRate3");
					String[] perilDedDeductibleTexts = request.getParameterValues("dedText3");
					String[] perilDedAggregateSws 	 = request.getParameterValues("dedAggregateSw3");
					String[] perilDedCeilingSws 	 = request.getParameterValues("dedCeilingSw3");
										
					Map<String, Object> perilDedParams = new HashMap<String, Object>();
					perilDedParams.put("itemNos", perilDedItemNos);
					perilDedParams.put("perilCds", perilDedPerilCds);
					perilDedParams.put("deductibleCds",perilDedDeductibleCds);
					perilDedParams.put("deductibleAmounts", perilDedDeductibleAmts);
					perilDedParams.put("deductibleRates", perilDedDeductibleRts);
					perilDedParams.put("deductibleTexts", perilDedDeductibleTexts);
					perilDedParams.put("aggregateSws", perilDedAggregateSws);
					perilDedParams.put("ceilingSws", perilDedCeilingSws);
					perilDedParams.put("parId", parId);
					perilDedParams.put("dedLineCd", lineCd);
					perilDedParams.put("dedSublineCd", sublineCd);
					perilDedParams.put("userId", USER.getUserId());									
					
					// all parameters.
					Map<String, Object> allEndtPerilParams = new HashMap<String, Object>();
					allEndtPerilParams.put("insParams", insParams);
					allEndtPerilParams.put("delParams", delParams);
					allEndtPerilParams.put("otherParams", otherParams);
					allEndtPerilParams.put("perilDedParams", perilDedParams);
					
					gipiWItemPerilService.saveEndtItemPeril(allEndtPerilParams);
					
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";				
				} else if("checkEndtPeril".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parId);
					params.put("lineCd", lineCd);
					params.put("sublineCd", sublineCd);
					params.put("itemNo", itemNo);
					params.put("perilCd", perilCd);			 							
					
					message = gipiWItemPerilService.checkEndtPeril(params);				
					PAGE = "/pages/genericMessage.jsp";
				} else if ("getEndtTariff".equals(ACTION)){
					BigDecimal tsiAmount			= new BigDecimal((request.getParameter("tsiAmount") == null) ? "0" : request.getParameter("tsiAmount"));				
					BigDecimal premiumAmount		= new BigDecimal((request.getParameter("premiumAmount") == null) ? "0" : request.getParameter("premiumAmount"));

					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parId);
					params.put("itemNo", itemNo);
					params.put("perilCd", perilCd);	
					params.put("tsiAmount", tsiAmount);
					params.put("premiumAmount", premiumAmount);
					
					message = "SUCCESS--" + gipiWItemPerilService.getEndtTariff(params).toString();
					PAGE = "/pages/genericMessage.jsp";
				} else if("showEndtPerilInfoTG".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", "getEndtGIPIWItemPerilTableGrid");
					params.put("parId", request.getParameter("globalParId"));
					params.put("itemNo", request.getParameter("itemNo"));
					Map<String, Object> endtPeril = TableGridUtil.getTableGrid(request, params);					
					
					if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
						JSONObject json = new JSONObject(endtPeril);
						message = json.toString();
						PAGE = "/pages/genericMessage.jsp";
					} else {
						request.setAttribute("jsonEndtPeril", new JSONObject(endtPeril));
						PAGE = "/pages/underwriting/endt/common/subPages/endtPerilInformationTG.jsp";
					}	
				}
			} else if ("deleteItemPeril".equals(ACTION)) {
				int itemNo = request.getParameter("itemNo") == null ? 0 : Integer.parseInt(request.getParameter("itemNo"));
				
				gipiWItemPerilService.deleteWItemPeril2(parId, itemNo);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getVarLineCodes".equals(ACTION)){
				GIISParameterFacadeService paramService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				message = paramService.getParamValueV2("FIRE") + "," + paramService.getParamValueV2("MOTOR CAR");
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getPostTextTsiAmtDetails".equals(ACTION)){
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
				Integer perilCd = Integer.parseInt(request.getParameter("perilCd"));
				System.out.println("request.getParameter('premRt'): "+(request.getParameter("premRt")));
				String premRt = request.getParameter("premRt");
				//BigDecimal premRt =  (request.getParameter("premRt")).equals("null") ? null :  new BigDecimal(request.getParameter("premRt") == "" ? "0" : request.getParameter("premRt"));
				//System.out.println("byteValueExact"+premRt.toPlainString());
				//BigDecimal premRt = new BigDecimal(request.getParameter("premRt") == ""? "0": request.getParameter("premRt"));
				BigDecimal tsiAmt = new BigDecimal(request.getParameter("tsiAmt")== ""? "0": request.getParameter("tsiAmt"));
				BigDecimal premAmt = new BigDecimal(request.getParameter("premAmt")== ""? "0": request.getParameter("premAmt"));
				BigDecimal annTsiAmt = new BigDecimal(request.getParameter("annTsiAmt")== ""? "0": request.getParameter("annTsiAmt"));
				BigDecimal annPremAmt = new BigDecimal(request.getParameter("annPremAmt")== ""? "0": request.getParameter("annPremAmt"));
				BigDecimal itemTsiAmt = new BigDecimal(request.getParameter("itemTsiAmt")== ""? "0": request.getParameter("itemTsiAmt"));
				BigDecimal itemPremAmt = new BigDecimal(request.getParameter("itemPremAmt")== ""? "0": request.getParameter("itemPremAmt"));
				BigDecimal itemAnnTsiAmt = new BigDecimal(request.getParameter("itemAnnTsiAmt")== ""? "0": request.getParameter("itemAnnTsiAmt"));   
				BigDecimal itemAnnPremAmt = new BigDecimal(request.getParameter("itemAnnPremAmt")== ""? "0": request.getParameter("itemAnnPremAmt"));
				Map<String, Object> params = new HashMap<String, Object>();
				log.info("CONTROLLER - parId: "+parId);
				params.put("parId", parId);
				params.put("itemNo", itemNo);
				params.put("perilCd", perilCd);
				params.put("premRt", premRt);
				params.put("tsiAmt", tsiAmt);
				params.put("premAmt", premAmt);
				params.put("annTsiAmt", annTsiAmt);
				params.put("annPremAmt", annPremAmt);
				params.put("itemTsiAmt", itemTsiAmt);
				params.put("itemPremAmt", itemPremAmt);
				params.put("itemAnnTsiAmt", itemAnnTsiAmt);
				params.put("itemAnnPremAmt", itemAnnPremAmt);
				GIPIWItemPeril a = gipiWItemPerilService.getPostTextTsiAmtDetails(params);
				
				message = a.getPerilPremAmt() + "," +
							a.getPerilAnnPremAmt()+ "," +
							a.getPerilAnnTsiAmt()+ "," +
							a.getItemPremAmt()+ "," +
							a.getItemAnnPremAmt()+ "," +
							a.getItemTsiAmt()+ "," +
							a.getItemAnnTsiAmt()+ "," +
							a.getPerilTsiAmt();
				System.out.println("mga nakuha: "+message);
				//message = a.getPerilPremAmt()+"";
				PAGE = "/pages/genericMessage.jsp";
			} else if("getNegateItemPerils".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				
				JSONArray negatedItemPerils = new JSONArray(gipiWItemPerilService.getNegateItemPerils(params));
				request.setAttribute("object", negatedItemPerils);
				PAGE = "/pages/genericObject.jsp";
			} else if("getNegateDeleteItem".equals(ACTION)){
				request.setAttribute("object", new JSONObject(gipiWItemPerilService.getNegateDeleteItem(request)));
				PAGE = "/pages/genericObject.jsp";
			} else if("getMaintainedPerilListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("packParId", request.getParameter("globalPackParId"));
				params.put("packLineCd", request.getParameter("packLineCd"));
				params.put("packSublineCd", request.getParameter("packSublineCd"));
				request.setAttribute("object", new JSONObject(gipiWItemPerilService.getMaintainedPerilListing(params)));
				PAGE = "/pages/genericObject.jsp";
			} else if("getGIPIWItemPerilTableGrid".equals(ACTION)){
				GIISPerilService giisPerilService = (GIISPerilService) APPLICATION_CONTEXT.getBean("giisPerilService");
				LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				Map<String, Object> tgParams = new HashMap<String, Object>();				
				Integer paramParId = Integer.parseInt(request.getParameter("parId"));
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
				String[] arg = {request.getParameter("lineCd")};				
				
				tgParams.put("ACTION", "getGIPIWItemPerilTableGrid");
				tgParams.put("parId", paramParId);
				tgParams.put("itemNo", itemNo);
				//tgParams.put("pageSize", 5);
				
				Map<String, Object> tgItemPerils = TableGridUtil.getTableGrid(request, tgParams);
				//tgItemPerils.put("allRecords", gipiWItemPerilService.getGIPIWItemPerils(paramParId)/*gipiWItemPerilService.getGIPIWItemPerilsByItem(paramParId, itemNo)*/);
				tgItemPerils.put("perilClauses", (List<LOV>) StringFormatter.escapeHTMLInList(lovHelper.getList(LOVHelper.PERIL_CLAUSES_LISTING, arg)));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("nbtSublineCd", request.getParameter("sublineCd"));
				params.put("packLineCd", request.getParameter("packLineCd"));
				params.put("packSublineCd", request.getParameter("packSublineCd"));
				params.put("parId", paramParId);	//added by Gzelle 09092014
				
				tgItemPerils.put("defaultPerils", (List<GIISPeril>) StringFormatter.escapeHTMLInList(giisPerilService.getDefaultPerils(params)));				
				tgItemPerils.put("defaultTag", gipiWItemPerilService.getItemPerilDefaultTag(params));
				tgItemPerils.put("packPlanPerils", (List<GIISPeril>) StringFormatter.escapeHTMLInList(giisPerilService.getPackPlanPerils(params)));	//added by Gzelle 09092014
				
				request.setAttribute("tgItemPerils", new JSONObject(tgItemPerils));	//added by Gzelle 09092014
				
				GIPIWPolicyWarrantyAndClauseFacadeService gipiWPolWCService = (GIPIWPolicyWarrantyAndClauseFacadeService) APPLICATION_CONTEXT.getBean("gipiWPolicyWarrantyAndClauseFacadeService");
				List<GIPIWPolicyWarrantyAndClause> wPolWCListing = gipiWPolWCService.getAllWPolicyWCs(request.getParameter("lineCd"), Integer.parseInt(request.getParameter("parId")));				
				//request.setAttribute("jsonWPolWCList", new JSONArray((List<GIPIWPolicyWarrantyAndClause>) StringFormatter.escapeHTMLInList(wPolWCListing))); // bonok :: 11.22.2012
				request.setAttribute("jsonWPolWCList", new JSONArray((List<GIPIWPolicyWarrantyAndClause>) StringFormatter.escapeHTMLInList3(wPolWCListing)));
				
				PAGE = "/pages/underwriting/common/itemperils/itemperilTableGridListing.jsp";
			} else if("refreshItemPerilsTable".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				Map<String, Object> tgParams = new HashMap<String, Object>();
				//Integer paramParId = Integer.parseInt(request.getParameter("parId"));
				//Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
				String[] arg = {request.getParameter("lineCd")};
				
				tgParams.put("ACTION", "getGIPIWItemPerilTableGrid");		
				tgParams.put("parId", Integer.parseInt(request.getParameter("parId")));
				tgParams.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				//tgParams.put("pageSize", 5);
				
				Map<String, Object> tgItemPerils = TableGridUtil.getTableGrid(request, tgParams);
				
				//tgItemPerils.put("allRecords", gipiWItemPerilService.getGIPIWItemPerilsByItem(paramParId, itemNo));
				tgItemPerils.put("perilClauses", (List<LOV>) StringFormatter.escapeHTMLInList(lovHelper.getList(LOVHelper.PERIL_CLAUSES_LISTING, arg)));
				
				message = (new JSONObject(tgParams)).toString();				
				//PAGE = "/pages/genericJSONParseMessage.jsp";
				PAGE = "/pages/genericMessage.jsp";
				
				//request.setAttribute("object", new JSONObject(tgParams));
				//PAGE = "/pages/genericObject.jsp";
			} else if("computeTsi".equals(ACTION)){
				JSONObject result = gipiWItemPerilService.computeTsi(request);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("showCopyPerilItems".equals(ACTION)){
				PAGE = "/pages/underwriting/common/itemperils/pop-ups/copyPerilSelectItem.jsp";
			} else if("checkPerilOnAllItems".equals(ACTION)) {
				message = gipiWItemPerilService.checkPerilOnAllItems(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validatePremiumAmount".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("lineCd", request.getParameter("lineCd"));
				request.setAttribute("object", new JSONObject(gipiWItemPerilService.validatePremiumAmount(params)));
				PAGE = "/pages/genericObject.jsp";
			} else if ("retrievePerils".equals(ACTION)){
				JSONObject result = gipiWItemPerilService.retrievePerils(request, USER);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("validatePeril".equals(ACTION)){
				JSONObject result = gipiWItemPerilService.validatePeril(request);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("computePremium".equals(ACTION)){
				JSONObject result = gipiWItemPerilService.computePremium(request);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("computePremiumRate".equals(ACTION)){
				JSONObject result = gipiWItemPerilService.computePremiumRate(request);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateBackAllied".equals(ACTION)){
				gipiWItemPerilService.validateBackAllied(request);
			} else if ("updatePlanDetails".equals(ACTION)) {	//added by Gzelle 09252014
				gipiWItemPerilService.updatePlanDetails(request, USER);
			} else if ("deleteWitemPerilTariff".equals(ACTION)) {	//added by Gzelle 12022014
				gipiWItemPerilService.deleteWitemPerilTariff(request, USER);
			} else if ("updateWithTariffSw".equals(ACTION)) {	//added by Gzelle 12032014
				gipiWItemPerilService.updateWithTariffSw(request, USER);				
			}
			
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
