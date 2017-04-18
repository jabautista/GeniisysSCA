/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.service.GIPIItemService;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWItemController.
 */
public class GIPIWItemController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	private static Logger log = Logger.getLogger(GIPIWItemController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
		GIACParameterFacadeService giacParameterFacadeService  = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
		//int parId = Integer.parseInt((request.getParameter("parNo") == null) ? "11306" : request.getParameter("parId"));
		int parId = Integer.parseInt((request.getParameter("parNo") == null) ? "11306" : request.getParameter("globalParId"));
		try {
			if ("getItemsForParId".equals(ACTION)){
				List<GIPIWItem> items = gipiWItemService.getGIPIWItem(parId);
				request.setAttribute("parItemInfo", items);
			} else if ("showCopyPerilItems".equals(ACTION)){
				//int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				//String itemNoList = request.getParameter("itemNoList");
				//String[] itemNos = itemNoList.split(",");
				//String[] itemNos = request.getParameterValues("itemNumber");
				//String[] itemNos = request.getParameterValues("masterItemNos");
				//for (String item: itemNos){
				//	System.out.println("itemNo: "+item);
				//}
				//System.out.println("selectedItemNo: "+itemNo);
				//request.setAttribute("selectedItemNo", itemNo);
				//request.setAttribute("itemNumber", itemNos);
				PAGE = "/pages/underwriting/subPages/copyPerilSelectItem.jsp";
			} else if ("getDistinctItemNos".equals(ACTION)) {
				parId = Integer.parseInt(request.getParameter("parId") == null ? "0" : request.getParameter("parId"));
				List<Integer> itemNos = gipiWItemService.getDistinctItemNos(parId);
				request.setAttribute("itemNos", itemNos);
				request.setAttribute("itemNosSize", itemNos == null ? 0 : itemNos.size());
				message = "SUCCESS";
				PAGE = "/pages/underwriting/subPages/ajaxUpdateFields.jsp";
			} else if("validateEndtAddItem".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				//Integer parId = Integer.parseInt(request.getParameter("parId") == null ? "0" : request.getParameter("parId"));
				Integer itemNo = Integer.parseInt((request.getParameter("itemNo")).trim());
				String lineCd = request.getParameter("lineCd");
				String sublineCd = request.getParameter("sublineCd");
				String issCd = request.getParameter("issCd");
				Integer issueYy = Integer.parseInt(request.getParameter("issueYy"));
				Integer polSeqNo = Integer.parseInt(request.getParameter("polSeqNo"));
				Integer renewNo = Integer.parseInt(request.getParameter("renewNo"));
				Date effDate = df.parse(request.getParameter("effDate"));				
				
				params.put("parId", parId);
				params.put("itemNo", itemNo);
				params.put("lineCd", lineCd);
				params.put("sublineCd", sublineCd);
				params.put("issCd", issCd);
				params.put("issueYy", issueYy);
				params.put("polSeqNo", polSeqNo);
				params.put("renewNo", renewNo);
				params.put("effDate", effDate);
				log.info(params.toString());
				String valMessage = gipiWItemService.validateEndtAddItem(params);
				message = valMessage;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getEndtAddItemList".equals(ACTION)){				
				//
				
				Map<String, Object> params = new HashMap<String, Object>();
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				//Integer parId = Integer.parseInt(request.getParameter("parId") == null ? "0" : request.getParameter("parId"));
				Integer itemNo = Integer.parseInt((request.getParameter("itemNo")).trim());
				String lineCd = request.getParameter("lineCd");
				String sublineCd = request.getParameter("sublineCd");
				String issCd = request.getParameter("issCd");
				Integer issueYy = Integer.parseInt(request.getParameter("issueYy"));
				Integer polSeqNo = Integer.parseInt(request.getParameter("polSeqNo"));
				Integer renewNo = Integer.parseInt(request.getParameter("renewNo"));
				Date effDate = df.parse(request.getParameter("effDate"));				
				
				params.put("parId", parId);
				params.put("itemNo", itemNo);
				params.put("lineCd", lineCd);
				params.put("sublineCd", sublineCd);
				params.put("issCd", issCd);
				params.put("issueYy", issueYy);
				params.put("polSeqNo", polSeqNo);
				params.put("renewNo", renewNo);
				params.put("effDate", effDate);
				//
				log.info(params.toString());
				//Map<String, Object> params = this.getAddEndtItemsParams(request);
				JSONArray addItems = new JSONArray(gipiWItemService.getEndtAddItemList(params));
				request.setAttribute("object", addItems);
				PAGE = "/pages/genericObject.jsp";
			} else if ("showEndtAddDeleteItem".equals(ACTION)) {
				String itemNos[] = request.getParameterValues("itemNos");
				request.setAttribute("itemNos", itemNos);
				request.setAttribute("choice", request.getParameter("choice"));
				PAGE = "/pages/underwriting/endt/common/subPages/endtItemInfoAddDeleteItem.jsp";
			} else if ("getPlanDetails".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", Integer.parseInt(request.getParameter("globalParId")));
				params.put("packParId", (request.getParameter("globalPackParId")).equals("0")? null : Integer.parseInt(request.getParameter("globalPackParId")));
				params.put("packLineCd", request.getParameter("packLineCd"));
				params.put("packSublineCd", request.getParameter("packSublineCd"));
				params = gipiWItemService.getPlanDetails(params);
				log.info("packPlanCd: "+params.get("packPlanCd"));
				log.info("packPlanSw: "+params.get("packPlanSw"));
				log.info("planSw: "+params.get("planSw"));
				log.info("vOra2010Sw: "+params.get("vOra2010Sw"));
				message = params.get("packPlanSw")+","+params.get("packPlanCd")+","+params.get("planSw")+","+params.get("vOra2010Sw");
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showPackItemsPerLine".equals(ACTION)){
				GIPIPARListService gipiParListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				System.out.println("packParId: "+request.getParameter("packParId"));
				System.out.println("packLineCd: "+request.getParameter("packLineCd"));
				Integer packParId = Integer.parseInt(request.getParameter("packParId") == null ? "0" : request.getParameter("packParId"));				
				String packLineCd = request.getParameter("packLineCd");
				request.setAttribute("assdNo", request.getParameter("globalAssdNo"));
				request.setAttribute("assdName", request.getParameter("globalAssdName"));
				request.setAttribute("parNo", request.getParameter("globalPackParNo"));
				request.setAttribute("packLineCd", packLineCd);
				request.setAttribute("isPack", "Y");
				@SuppressWarnings("unchecked")
				List<GIPIWItem> packParList  = (List<GIPIWItem>) StringFormatter.escapeHTMLInList(gipiParListService.getPackItemParList(packParId, packLineCd));
				request.setAttribute("packParList", new JSONArray(packParList));
				//request.setAttribute("packParList", new JSONArray(gipiParListService.getPackItemParList(packParId, packLineCd)));
				PAGE = "/pages/underwriting/packPar/packParItem/packParItemInformationMain.jsp";				
			} else if("showPackPolicyItems".equals(ACTION)){
				//GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);
				
				request.setAttribute("formMap", new JSONObject(gipiWItemService.gipis095NewFormInstance(params)));
				request.setAttribute("defualtCurrencyCd", giacParameterFacadeService.getParamValueN("CURRENCY_CD"));
				message = "SUCCESS";
				PAGE = "/pages/underwriting/packPar/packPolicyItems/packPolicyItemsMain.jsp";
			} else if("savePackagePolicyItems".equals(ACTION)){
				gipiWItemService.savePackagePolicyItems(request.getParameter("parameters"),USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";			
			}else if("showEndtPackPolicyItems".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("response", response);
				params.put("applicationContext", APPLICATION_CONTEXT);
				params.put("USER", USER);
				
				request.setAttribute("formMap", new JSONObject(gipiWItemService.gipis096NewFormInstance(params)));
				request.setAttribute("parType", "E");
				message = "SUCCESS";
				PAGE = "/pages/underwriting/packPar/packPolicyItems/endtPackPolicyItemsMain.jsp";
			}else if("saveEndtPackPolicyItems".equals(ACTION)){
				gipiWItemService.saveEndtPackagePolicyItems(request.getParameter("parameters"), USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getPackPolicyItemsList".equals(ACTION)){
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				String lineCd 	 = request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd");
				String issCd 	 = request.getParameter("issCd") == null ? "" : request.getParameter("issCd");
				String sublineCd = request.getParameter("sublineCd") == null ? "" : request.getParameter("sublineCd");
				Integer issueYy  = request.getParameter("issueYy").equals("") ? null : Integer.parseInt(request.getParameter("issueYy"));
				Integer polSeqNo = request.getParameter("polSeqNo").equals("") ? null : Integer.parseInt(request.getParameter("polSeqNo"));
				Integer renewNo  = request.getParameter("renewNo").equals("") ? null : Integer.parseInt(request.getParameter("renewNo"));
				Date effDate 	 = request.getParameter("effDate").equals("") ? null : df.parse(request.getParameter("effDate"));
				Date expiryDate  = request.getParameter("expiryDate").equals("") ? null : df.parse(request.getParameter("expiryDate"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("lineCd", lineCd);
				params.put("issCd", issCd);
				params.put("sublineCd", sublineCd);
				params.put("issueYy", issueYy);
				params.put("polSeqNo", polSeqNo);
				params.put("renewNo", renewNo);
				params.put("effDate", effDate);
				params.put("expiryDate", expiryDate);
				
				Map<String, Object> polItemsTableGrid = TableGridUtil.getTableGrid(request, params);				
				
				JSONObject json = new JSONObject(polItemsTableGrid);				
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("polItemsTableGrid", json);
					PAGE = "/pages/underwriting/packPar/packPolicyItems/overlay/policyItemsList.jsp";
				}
			}else if("validateItemNo".equals(ACTION)){
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				Integer packParId= request.getParameter("packParId").equals("") ? null : Integer.parseInt(request.getParameter("packParId"));
				Integer itemNo   = request.getParameter("itemNo").equals("") ? null : Integer.parseInt(request.getParameter("itemNo"));
				String lineCd 	 = request.getParameter("lineCd") == null ? "" : request.getParameter("lineCd");
				String issCd     = request.getParameter("issCd") == null ? "" : request.getParameter("issCd");
				String sublineCd = request.getParameter("sublineCd") == null ? "" : request.getParameter("sublineCd");
				Integer issueYy  = request.getParameter("issueYy").equals("") ? null : Integer.parseInt(request.getParameter("issueYy"));
				Integer polSeqNo = request.getParameter("polSeqNo").equals("") ? null : Integer.parseInt(request.getParameter("polSeqNo"));
				Integer renewNo  = request.getParameter("renewNo").equals("") ? null : Integer.parseInt(request.getParameter("renewNo"));
				Date effDate     = request.getParameter("effDate").equals("") ? null : df.parse(request.getParameter("effDate"));
				Date expiryDate  = request.getParameter("expiryDate").equals("") ? null : df.parse(request.getParameter("expiryDate"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("packParId", packParId);
				params.put("itemNo", itemNo);
				params.put("lineCd", lineCd);
				params.put("issCd", issCd);
				params.put("sublineCd", sublineCd);
				params.put("issueYy", issueYy);
				params.put("polSeqNo", polSeqNo);
				params.put("renewNo", renewNo);
				params.put("effDate", effDate);
				params.put("expiryDate", expiryDate);
				params.put("tsiAmt", null);
				params.put("premAmt", null);
				params.put("riskNo", null);
				params.put("riskItemNo", null);
				
				params = gipiWItemService.gipis096ValidateItemNo(params);
				
				JSONObject json = new JSONObject(StringFormatter.replaceQuotesInMap(params));
				message = json.toString();					
				PAGE = "/pages/genericMessage.jsp";				
			} else if("renumber".equals(ACTION)){				
				gipiWItemService.renumber(Integer.parseInt(request.getParameter("parId")),USER);	//modified by Gzelle 09302014
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("refreshItemTable".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();				
				
				params.put("ACTION", request.getParameter("lineAction"));				
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("pageSize", 5);
				
				params = TableGridUtil.getTableGrid(request, params);
				
				message = (new JSONObject(params)).toString();				
				//PAGE = "/pages/genericJSONParseMessage.jsp";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getEndtItemList".equals(ACTION)){
				GIPIItemService gipiItemService = (GIPIItemService) APPLICATION_CONTEXT.getBean("gipiItemService");
				request.setAttribute("object", gipiItemService.getEndtItemList(request));
				PAGE = "/pages/genericObject.jsp";
			}else if ("checkGetDefCurrRt".equals(ACTION)) {
				message = gipiWItemService.checkGetDefCurrRt();
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){//added by steven 02.04.2013
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
	
	@SuppressWarnings({ "unused", "finally" })
	private Map<String, Object> getAddEndtItemsParams(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		try {
			DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
			Integer parId = Integer.parseInt(request.getParameter("parId") == null ? "0" : request.getParameter("parId"));
			Integer itemNo = Integer.parseInt((request.getParameter("itemNo")).trim());
			String lineCd = request.getParameter("lineCd");
			String sublineCd = request.getParameter("sublineCd");
			String issCd = request.getParameter("issCd");
			Integer issueYy = Integer.parseInt(request.getParameter("issueYy"));
			Integer polSeqNo = Integer.parseInt(request.getParameter("polSeqNo"));
			Integer renewNo = Integer.parseInt(request.getParameter("renewNo"));
			Date effDate = df.parse(request.getParameter("effDate"));
			
			log.info("parId : "+parId);
			log.info("itemNo : "+itemNo);
			log.info("lineCd : "+lineCd);
			log.info("sublineCd : "+sublineCd);
			log.info("issCd : "+issCd);
			log.info("issueYy : "+issueYy);
			log.info("polSeqNo : "+polSeqNo);
			log.info("renewNo : "+renewNo);
			log.info("effDate : "+effDate);
			
			params.put("parId", parId);
			params.put("itemNo", itemNo);
			params.put("lineCd", lineCd);
			params.put("sublineCd", sublineCd);
			params.put("issCd", issCd);
			params.put("issueYy", issueYy);
			params.put("polSeqNo", polSeqNo);
			params.put("renewNo", renewNo);
			params.put("effDate", effDate);
		} finally {
			return params;
		}
	}

}
