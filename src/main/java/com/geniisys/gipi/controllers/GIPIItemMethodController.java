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
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPIItemService;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIParItemFacadeService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;



/**
 * The Class GIPIItemMethodController.
 */
public class GIPIItemMethodController extends BaseController{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIItemMethodController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			
			//GIPIParItemMCService gipiParItemMCService = (GIPIParItemMCService) APPLICATION_CONTEXT.getBean("gipiParItemMCService"); // +env
			//LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
			
			GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");//+env);
			GIPIParItemFacadeService itemService = (GIPIParItemFacadeService) APPLICATION_CONTEXT.getBean("gipiParItemFacadeService"); // + env
			GIPIItemService gipiItemService	= (GIPIItemService) APPLICATION_CONTEXT.getBean("gipiItemService");
			
			
			if("confirmCopyItem".equals(ACTION)){
				log.info("Confirm Copy Item ...");
				int parId 			= Integer.parseInt(request.getParameter("parId"));
				String lineCd 		= request.getParameter("lineCd");
				String sublineCd 	= request.getParameter("sublineCd");				
				
				message = itemService.confirmCopyItem(parId, lineCd, sublineCd);
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Confirm Item: " + message);
			} else if("confirmCopyEndtParItem".equals(ACTION)){
				log.info("Confirm Copy Item ...");
				int parId 			= Integer.parseInt(request.getParameter("parId"));
				String lineCd 		= request.getParameter("lineCd");
				String sublineCd 	= request.getParameter("sublineCd");				
				
				message = itemService.confirmCopyEndtParItem(parId, lineCd, sublineCd);
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("parId: " + parId);
				System.out.println("lineCd: " + lineCd);
				System.out.println("sublineCd: " + sublineCd);
				System.out.println("Confirm Item: " + message);
			} else if("validateItemForNegation".equals(ACTION)){
				log.info("Validating item for negation...");
				int parId = Integer.parseInt(request.getParameter("parId"));
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				
				message = itemService.validateNegateItem(parId, itemNo);
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
				System.out.println("Message: " + message);
			} else if("copyItemInfo".equals(ACTION)){			
				log.info("Copying Item Info ...");
				int parId = Integer.parseInt(request.getParameter("parId"));
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				int newItemNo = Integer.parseInt(request.getParameter("newItemNo"));
				
				log.info("Par Id : " + parId);
				log.info("Item No : " + itemNo);
				log.info("New Item No : " + newItemNo);
				
				itemService.copyItem(parId, itemNo, newItemNo);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Copy Item: " + message);
			} else if("copyAdditionalInfo".equals(ACTION)){
				log.info("Copying Additional Info ... ");
				int parId = Integer.parseInt(request.getParameter("parId"));
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				int newItemNo = Integer.parseInt(request.getParameter("newItemNo"));
				String lineCd 		= request.getParameter("globalLineCd");
				String sublineCd 	= request.getParameter("sublineCd");
				
				if ("MC".equals(lineCd)) {
					itemService.copyAdditionalInfoMC(parId, itemNo, newItemNo, lineCd, sublineCd);
				}
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Copy Additional Info: " + message);
			} else if("copyAdditionalInfoEndt".equals(ACTION)){
				//copy addition info, for endt par
				log.info("Copying Additional Info ... ");
				int parId = Integer.parseInt(request.getParameter("parId"));
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				int newItemNo = Integer.parseInt(request.getParameter("newItemNo"));
				String lineCd 		= request.getParameter("lineCd");
				String sublineCd 	= request.getParameter("sublineCd");
				
				if ("MC".equals(lineCd)) {
					itemService.copyAdditionalInfoMCEndt(parId, itemNo, newItemNo, lineCd, sublineCd);
				} else if ("FI".equals(lineCd)) {
					itemService.copyAdditionalInfoFIEndt(parId, itemNo, newItemNo, lineCd, sublineCd);
				}
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Copy Additional Info: " + message);
			} else if("deleteItemDeductible".equals(ACTION)){
				log.info("Deleting item deductible ... ");
				int parId = Integer.parseInt(request.getParameter("parId"));
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));				
				String lineCd 		= request.getParameter("lineCd");
				String sublineCd 	= request.getParameter("sublineCd");
				
				itemService.deleteItemDeductible(parId, itemNo, lineCd, sublineCd);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Delete Item Deductible: " + message);				
			} else if("confirmCopyItemPeril".equals(ACTION)){
				log.info("Confirm Copy Item/Peril ...");
				int parId 			= Integer.parseInt(request.getParameter("parId"));
				String lineCd 		= request.getParameter("lineCd");
				String sublineCd 	= request.getParameter("sublineCd");				
				
				message = itemService.confirmCopyItemPerilInfo(parId, lineCd, sublineCd);
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Confirm Item Peril: " + message);
			} else if("deletePolDeductibles".equals(ACTION)){
				log.info("Deleting Deductibles ...");
				int parId 			= Integer.parseInt(request.getParameter("parId"));
				String lineCd 		= request.getParameter("lineCd");
				String sublineCd 	= request.getParameter("sublineCd");				
				
				itemService.deletePolDeductibles(parId, lineCd, sublineCd);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Delete Pol Deductibles: " + message);
			} else if("copyItemPeril".equals(ACTION)){
				log.info("Copying Item Peril ...");
				int parId = Integer.parseInt(request.getParameter("parId"));
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				int newItemNo = Integer.parseInt(request.getParameter("newItemNo"));
				
				log.info("Par Id : " + parId);
				log.info("Item No : " + itemNo);
				log.info("New Item No : " + newItemNo);
				
				itemService.copyItemPeril(parId, itemNo, newItemNo);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Copy Item Peril: " + message);
			} else if("confirmRenumber".equals(ACTION)){
				log.info("Confirm Renumber ...");
				int parId = Integer.parseInt(request.getParameter("parId"));				
				message = itemService.confirmRenumber(parId);
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Confirm Renumber: " + message);
			} else if("renumber".equals(ACTION)){
				log.info("Renumbering ...");
				int parId = Integer.parseInt(request.getParameter("parId"));
				itemService.renumber(parId);				
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				System.out.println("Renumber: " + message);
			} else if("confirmAssignDeductibles".equals(ACTION)){
				log.info("Confirm Assign Deductibles ...");
				int parId = Integer.parseInt(request.getParameter("parId"));
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));				
				
				message = itemService.confirmAssignDeductibles(parId, itemNo);				
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Confirm Assign Deductibles: " + message);
			} else if("assignDeductibles".equals(ACTION)){
				log.info("Assigning Deductibles ...");
				int parId = Integer.parseInt(request.getParameter("parId"));
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				itemService.assignDeductibles(parId, itemNo);				
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				System.out.println("Assign Deductibles: " + message);
			} else if("updateItem".equals(ACTION)){
				//
			} else if("deleteItem".equals(ACTION)){
				//
			} else if("saveItem".equals(ACTION)){
				//String[] lineCds			= request.getParameterValues("itemLineCds");
				//String[] sublineCds		= request.getParameterValues("itemSublineCds");
				
				String[] itemNos		= request.getParameterValues("itemItemNos");				
				String[] delItemNos		= request.getParameterValues("delItemNos");				
				String parType			= request.getParameter("globalParType") == null ? "P" : request.getParameter("globalParType");
				
				log.info("Par Type : " + parType);
				
				if(delItemNos != null){
					String[] delParIds		= request.getParameterValues("delParIds");
					
					Map<String, Object> itemParam = new HashMap<String, Object>();
					itemParam.put("parIds", delParIds);
					itemParam.put("itemNos", delItemNos);
					
					if ("P".equals(parType)) {
						itemService.deleteGIPIParItem(itemParam);
					} else {
						itemService.deleteGIPIEndtParItem(itemParam);
					}
				}
				
				if(itemNos != null){
					String[] parIds				= request.getParameterValues("itemParIds");
					String[] itemTitles			= request.getParameterValues("itemItemTitles");
					String[] itemGrps			= request.getParameterValues("itemItemGrps");
					String[] itemDescs			= request.getParameterValues("itemItemDescs");
					String[] itemDesc2s			= request.getParameterValues("itemItemDesc2s");
					String[] tsiAmts			= request.getParameterValues("itemTsiAmts");
					String[] premAmts			= request.getParameterValues("itemPremAmts");
					String[] annPremAmts		= request.getParameterValues("itemAnnPremAmts");
					String[] annTsiAmts			= request.getParameterValues("itemAnnTsiAmts");
					String[] recFlags			= request.getParameterValues("itemRecFlags");
					String[] currencyCds		= request.getParameterValues("itemCurrencyCds");
					String[] currencyRts		= request.getParameterValues("itemCurrencyRts");
					String[] groupCds			= request.getParameterValues("itemGroupCds");
					String[] fromDates			= request.getParameterValues("itemFromDates");
					String[] toDates			= request.getParameterValues("itemToDates");
					String[] packLineCds		= request.getParameterValues("itemPackLineCds");
					String[] packSublineCds		= request.getParameterValues("itemPackSublineCds");
					String[] discountSws		= request.getParameterValues("itemDiscountSws");
					String[] coverageCds		= request.getParameterValues("itemCoverageCds");
					String[] otherInfos			= request.getParameterValues("itemOtherInfos");
					String[] surchargeSws		= request.getParameterValues("itemSurchargeSws"); 
					String[] regionCds			= request.getParameterValues("itemRegionCds");
					String[] changedTags		= request.getParameterValues("itemChangedTags");
					String[] prorateFlags		= request.getParameterValues("itemProrateFlags");
					String[] compSws			= request.getParameterValues("itemCompSws");
					String[] shortRtPercents	= request.getParameterValues("itemShortRtPercents");
					String[] packBenCds			= request.getParameterValues("itemPackBenCds");
					String[] paytTermss			= request.getParameterValues("itemPaytTermss");
					String[] riskNos			= request.getParameterValues("itemRiskNos");
					String[] riskItemNos		= request.getParameterValues("itemRiskItemNos");
					
					Map<String, Object> itemParam = new HashMap<String, Object>();					
					itemParam.put("lineCds", request.getParameter("lineCd")/*lineCds*/);
					itemParam.put("sublineCds", request.getParameter("sublineCd")/*sublineCds*/);
					itemParam.put("parIds", parIds);
					itemParam.put("itemNos", itemNos);
					itemParam.put("itemTitles", itemTitles);
					itemParam.put("itemGrps", itemGrps);
					itemParam.put("itemDescs", itemDescs);
					itemParam.put("itemDesc2s", itemDesc2s);
					itemParam.put("tsiAmts", tsiAmts);
					itemParam.put("premAmts", premAmts);
					itemParam.put("annPremAmts", annPremAmts);
					itemParam.put("annTsiAmts", annTsiAmts);
					itemParam.put("recFlags", recFlags);
					itemParam.put("currencyCds", currencyCds);
					itemParam.put("currencyRts", currencyRts);
					itemParam.put("groupCds", groupCds);
					itemParam.put("fromDates", fromDates);
					itemParam.put("toDates", toDates);
					itemParam.put("packLineCds", packLineCds);
					itemParam.put("packSublineCds", packSublineCds);
					itemParam.put("discountSws", discountSws);
					itemParam.put("coverageCds", coverageCds);
					itemParam.put("otherInfos", otherInfos);
					itemParam.put("surchargeSws", surchargeSws);
					itemParam.put("regionCds", regionCds);
					itemParam.put("changedTags", changedTags);
					itemParam.put("prorateFlags", prorateFlags);
					itemParam.put("compSws", compSws);
					itemParam.put("shortRtPercents", shortRtPercents);
					itemParam.put("packBenCds", packBenCds);
					itemParam.put("paytTermss", paytTermss);
					itemParam.put("riskNos", riskNos);
					itemParam.put("riskItemNos", riskItemNos);
					itemService.saveGIPIParItem(itemParam);
				}				
				request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiParService.getGIPIPARDetails(Integer.parseInt(request.getParameter("globalParId"))));
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkIfDiscountExist".equals(ACTION)){
				log.info("Checking if Discount Exists ...");
				int parId = Integer.parseInt(request.getParameter("parId"));
				
				message = itemService.checkIfDiscountExists(parId);				
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Discount Exist: " + message);
			} else if("getMaxWItemNo".equals(ACTION)){
				log.info("Getting Max WItem No ...");
				int parId = Integer.parseInt(request.getParameter("parId"));
				Integer maxItemNo = itemService.getMaxWItemNo(parId);
				
				message = maxItemNo.toString();
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Max Par Item No: " + message);
			} else if("getMaxEndtParItemNo".equals(ACTION)){
				log.info("Getting Max Endt Par Item No ...");
				int parId = Integer.parseInt(request.getParameter("parId"));
				Integer maxItemNo = itemService.getMaxEndtParItemNo(parId);
				
				message = maxItemNo.toString();
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Max Par Item No: " + message);
			} else if("getMaxRiskItemNo".equals(ACTION)){
				log.info("Getting Max Risk Item No ...");
				int parId = Integer.parseInt(request.getParameter("parId"));
				int riskNo = Integer.parseInt(request.getParameter("riskNo"));
				
				Integer maxRiskItemNo = itemService.getMaxRiskItemNo(parId, riskNo);
				
				message = maxRiskItemNo.toString();
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Max Par Item No: " + message);
			} else if("checkGIPIWItem".equals(ACTION)){
				log.info("Checking GIPIWItem ...");
				int checkBoth = Integer.parseInt(request.getParameter("checkBoth"));
				int parId = Integer.parseInt(request.getParameter("parId"));
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				
				message = itemService.checkGIPIWItem(checkBoth, parId, itemNo);
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Check GIPI WItem: " + message);
			} else if("insertParhist".equals(ACTION)){
				log.info("Inserting Parhist ...");
				int parId = Integer.parseInt(request.getParameter("globalParId"));
				System.out.println("User Id: " + USER.getUserId());
				itemService.insertParhist(parId, USER.getUserId());
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
				System.out.println("Insert Parhist: " + message);				
			} else if("deleteDiscount".equals(ACTION)){
				log.info("Deleting Discount ...");
				itemService.deleteDiscount(Integer.parseInt(request.getParameter("globalParId")));
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);				
			} else if("updateGIPIWPackLineSubline".equals(ACTION)){
				log.info("Updating GIPI_WPACK_LINE_SUBLINE ...");
				int globalParId = Integer.parseInt(request.getParameter("globalParId"));
				String packLineCd = request.getParameter("packLineCd");
				String packSublineCd = request.getParameter("packSublineCd");
				itemService.updateGIPIWPackLineSubline(globalParId, packLineCd, packSublineCd);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
			} else if("deleteCoInsurer".equals(ACTION)){
				log.info("Deleting co insurer record ... ");
				int globalParId = Integer.parseInt(request.getParameter("globalParId"));
				itemService.deleteCoInsurer(globalParId);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
			} else if("deleteBill".equals(ACTION)){
				log.info("Deleting bill record ... ");
				int globalParId = Integer.parseInt(request.getParameter("globalParId"));
				itemService.deleteBill(globalParId);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
			} else if("changeItemGroup".equals(ACTION)){				
				log.info("Changing Item Group ... ");
				int globalParId = Integer.parseInt(request.getParameter("globalParId"));
				String packPolFlag = request.getParameter("globalPackPolFlag");				
				itemService.changeItemGroup(globalParId, packPolFlag);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
			} else if("addParStatusNo".equals(ACTION)){
				log.info("Updating PAR Status No. ... ");
				Map<String, Object> result = new HashMap<String, Object>();
				int globalParId = Integer.parseInt(request.getParameter("globalParId"));
				String lineCd = request.getParameter("globalLineCd");
				int parStatus = Integer.parseInt(request.getParameter("globalParStatus"));
				String invoiceSw = request.getParameter("invoiceSw");
				String issCd = request.getParameter("globalIssCd");
				
				result = itemService.addParStatusNo(globalParId, lineCd, parStatus, invoiceSw, issCd);				
				message = result.get("result").toString().equals("SUCCESS") ? "SUCCESS" : result.get("result").toString();
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);				
			} else if("updateGipiWPolbasNoOfItem".equals(ACTION)){
				log.info("Update No. of Items ... ");
				int globalParId = Integer.parseInt(request.getParameter("globalParId"));
				itemService.updateGipiWPolbasNoOfItem(globalParId);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
			} else if("checkAdditionalInfo".equals(ACTION)){
				log.info("Checking additional info ... ");
				int globalParId = Integer.parseInt(request.getParameter("globalParId"));
				String lineCd = request.getParameter("globalLineCd");
				if("MC".equals(lineCd)){
					message = itemService.checkAdditionalInfoMC(globalParId);
				} else if("FI".equals(lineCd)){
					message = itemService.checkAdditionalInfoFI(globalParId);
				}				
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);
			} else if("checkBackEndtBeforeDelete".equals(ACTION)) {
				log.info("Checking item if back endt...");
				int parId = Integer.parseInt(request.getParameter("parId"));
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				
				System.out.println("parID: " + parId + " itemNo: " + itemNo);
				
				message = itemService.checkBackEndtBeforeDelete(parId, itemNo);
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
				System.out.println("Message: " + message);
			} else if("extractExpiry".equals(ACTION)) {
				DateFormat df = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss a");
				log.info("Extracting latest expiry...");
				int parId = Integer.parseInt(request.getParameter("parId"));
				Date expiry = itemService.extractExpiry(parId);
				
				message = expiry == null ? " " : df.format(expiry);
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
				System.out.println("Expiry date: " + message);
			} else if("deleteDiscount2".equals(ACTION)){
				log.info("Deleting Discount ...");
				itemService.deleteDiscount2(Integer.parseInt(request.getParameter("globalParId")));
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				request.setAttribute("message", message);				
			}else if("negateItem".equals(ACTION)) {
				Map<String, Object> params;
				int parId = Integer.parseInt(request.getParameter("parId"));
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				log.info("Negating item. Please wait...");
				params = itemService.negateItem(parId, itemNo);
				
				request.setAttribute("premAmt", params.get("premAmt"));
				request.setAttribute("tsiAmt", params.get("tsiAmt"));
				request.setAttribute("annPremAmt", params.get("annPremAmt"));
				request.setAttribute("annTsiAmt", params.get("annTsiAmt"));
				
				message = "SUCCESS";
				PAGE = "/pages/underwriting/subPages/ajaxUpdateFields.jsp";
			}else if ("createEndtParDistribution1".equals(ACTION)) {
				int parId = Integer.parseInt(request.getParameter("parId"));
				int distNo = Integer.parseInt(request.getParameter("distNo"));
				
				log.info("Par id : " + parId);
				log.info("Dist no : " + distNo);
				
				message = itemService.createEndtParDistribution1(parId, distNo);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("createEndtParDistribution2".equals(ACTION)) {
				int parId = Integer.parseInt(request.getParameter("parId"));
				int distNo = Integer.parseInt(request.getParameter("distNo"));
				String recExistsAlert = request.getParameter("alert1") == null ? "N" : request.getParameter("alert1");
				String distributionAlert = request.getParameter("alert2") == null ? "N" : request.getParameter("alert1");
				
				log.info("Par id : " + parId);
				log.info("Dist no : " + distNo);
				log.info("Rec Exists dialog confirmation : " + recExistsAlert);
				log.info("Distribution dialog confirmation : " + distributionAlert);
				
				message = itemService.createEndtParDistribution2(parId, distNo, recExistsAlert, distributionAlert);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("createEndtInvoiceItem".equals(ACTION)) {
				int parId = Integer.parseInt(request.getParameter("parId"));
				
				message = itemService.createEndtInvoiceItem(parId);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("createEndtParDistributionItem1".equals(ACTION)) {
				int parId = Integer.parseInt(request.getParameter("parId"));
				int distNo = Integer.parseInt(request.getParameter("distNo"));
				
				log.info("Par id : " + parId);
				log.info("Dist no : " + distNo);
				
				message = itemService.createEndtDistributionItem1(parId, distNo);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("createEndtParDistributionItem2".equals(ACTION)) {
				int parId = Integer.parseInt(request.getParameter("parId"));
				int distNo = Integer.parseInt(request.getParameter("distNo"));
				String recExistsAlert = request.getParameter("alert1") == null ? "N" : request.getParameter("alert1");
				String distributionAlert = request.getParameter("alert2") == null ? "N" : request.getParameter("alert1");
				
				log.info("Par id : " + parId);
				log.info("Dist no : " + distNo);
				log.info("Rec Exists dialog confirmation : " + recExistsAlert);
				log.info("Distribution dialog confirmation : " + distributionAlert);
				
				message = itemService.createEndtDistributionItem2(parId, distNo, recExistsAlert, distributionAlert);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("addEndtParStatusNo".equals(ACTION)) {
				int parId = Integer.parseInt(request.getParameter("parId"));
				String lineCd = request.getParameter("lineCd");
				String issCd = request.getParameter("issCd");
				String endtTaxSw = request.getParameter("endtTaxSw");
				String coInsSw = request.getParameter("coInsSw");
				String negateItem = request.getParameter("negateItem");
				String prorateFlag = request.getParameter("prorateFlag");
				String compSw = request.getParameter("compSw");
				String endtExpiryDate = request.getParameter("endtExpiryDate");
				String effDate = request.getParameter("effDate");
				String expiryDate = request.getParameter("expiryDate");
				BigDecimal shortRtPercent = request.getParameter("shortRtPercent") == null ? null : request.getParameter("shortRtPercent").trim().length() == 0 ? null : new BigDecimal(request.getParameter("shortRtPercent"));
				
				message = itemService.addEndtParStatusNo(parId, lineCd, issCd, endtTaxSw, coInsSw, negateItem, prorateFlag, compSw, endtExpiryDate, effDate, shortRtPercent, expiryDate);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("setPackageMenu".equals(ACTION)) {
				int parId = Integer.parseInt(request.getParameter("parId"));
				int packParId = Integer.parseInt(request.getParameter("packParId") == null ? "0" : request.getParameter("packParId"));
				
				itemService.setPackageMenu(parId, packParId);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("updateEndtGipiWpackLineSubline".equals(ACTION)) {
				int parId = Integer.parseInt(request.getParameter("parId"));
				String packLineCd = request.getParameter("packLineCd");
				String packSublineCd = request.getParameter("packSublineCd");
				
				itemService.updateEndtGipiWpackLineSubline(parId, packLineCd, packSublineCd);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("endtParValidateItemInfo".equals(ACTION)) {
				int parId = Integer.parseInt(request.getParameter("parId"));
				int funcPart = Integer.parseInt(request.getParameter("funcPart") == null ? "0" : request.getParameter("funcPart"));
				String alertConfirm = request.getParameter("alertConfirm");
				
				message = itemService.endtParValidateOtherInfo(parId, funcPart, alertConfirm);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showItemInfo".equals(ACTION)){
				
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyItemInfo.jsp";
				
			}else if ("getRelatedItemInfo".equals(ACTION)){
				
				String callingPage = request.getParameter("pageCalling");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getRelatedItemInfo");
				params.put("pageCalling",request.getParameter("pageCalling"));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiItemService.getRelatedItemInfo(params);
				JSONObject itemObject = new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params));
				/*if("policyBillGroup".equals(callingPage)){
					log.info("Retrieving Items for Bill Group");
					request.setAttribute("gipiRelatedItemBillTableGrid",itemObject );
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/relatedItemForBillGroupTable.jsp";			       
				}else */
				if("policyItemInfo".equals(callingPage)){
					log.info("Retrieving Items for Item Information");
					request.setAttribute("gipiRelatedItemInfoTableGrid",itemObject );
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/relatedItemInfoTable.jsp";
				}else if("policyInfoBasic".equals(callingPage)){
					log.info("Retrieving Items for Policy Basic Information");
					request.setAttribute("gipiRelatedItemInfoTableGrid",itemObject );
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyLeadOverlay.jsp";
				}else if("policyBillGroup".equals(callingPage)){
					log.info("Retrieving Items for Bill Group");
					request.setAttribute("gipiRelatedItemBillTableGrid",itemObject );
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/relatedItemForBillGroupTable.jsp";						
				}
			}else if ("refreshRelatedItemInfo".equals(ACTION)){
				Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				HashMap<String, Object> params = new HashMap<String, Object>();
				//added by Gzelle 06.27.2013
				if (request.getParameter("pageCalling").equals("policyItemInfo")) {
					params.put("ACTION", "getRelatedItemInfo");
					params.put("pageSize", request.getParameter("pageSize") != null ? Integer.parseInt(request.getParameter("pageSize")) : ApplicationWideParameters.PAGE_SIZE); //Added by pol cruz 01.09.2015
				}else if (request.getParameter("pageCalling").equals("policyBillGroup")) {
					params.put("ACTION", "getBillPremiumMainList");
				}
				params.put("policyId", policyId);
				params.put("pageCalling",request.getParameter("pageCalling"));
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params = gipiItemService.getRelatedItemInfo(params);
				//added by Gzelle 06.14.2013
				Map<String, Object> itemList =TableGridUtil.getTableGrid(request, params); 
				JSONObject json = new JSONObject(itemList);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					message = StringFormatter.replaceTildes(json.toString());
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("showAnnualizedAmounts".equals(ACTION)){
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/itemAnnualizedAmounts.jsp";
			}else if("showOtherInfo".equals(ACTION)){
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/itemInfoOverlay/itemOtherInfo.jsp";
			}else if("getNonMCItemTitle".equals(ACTION)){
				message = gipiItemService.getNonMCItemTitle(request, USER);
			}
			
			
		} catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);			
			this.doDispatch(request, response, PAGE);
		}
		
	}
}
