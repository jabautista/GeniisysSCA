package com.geniisys.common.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISIntermediary;
import com.geniisys.common.entity.GIISIntmType;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISIntermediaryService;
import com.geniisys.common.service.GIISIntmTypeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIISIntermediaryController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIISIntermediaryController.class);

	@SuppressWarnings("deprecation")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("doProcessing");
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISIntermediaryService giisIntermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
			PAGE = "/pages/genericMessage.jsp";
			
			if ("openSearchIntermediary".equals(ACTION)) {
				
				PAGE = "/pages/pop-ups/searchIntermediary.jsp";
			} else if ("getIntermediaryListing".equals(ACTION)) {
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				String keyword = request.getParameter("keyword");
				
				if (null==keyword) {
					keyword = "";
				}
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				
				if (null != request.getParameter("pageNo")) {
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				searchResult = intermediaryService.getIntermediaryList2(pageNo, keyword);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/pop-ups/searchIntermediaryAjaxResult.jsp";
			} else if ("openSearchBancaIntermediary".equals(ACTION)) {
				
				PAGE = "/pages/pop-ups/searchBancaIntermediary.jsp";
			} else if ("getBancaIntermediaryListing".equals(ACTION)) {
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				String keyword = request.getParameter("keyword");
				String bancTypeCd = request.getParameter("bancTypeCd");
				String intmType = request.getParameter("intmType");
				
				if (null==keyword) {
					keyword = "";
				}
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				
				if (null != request.getParameter("pageNo")) {
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				searchResult = intermediaryService.getBancaIntermediaryList(pageNo, keyword, bancTypeCd, intmType);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/pop-ups/searchBancaIntermediaryAjaxResult.jsp";
			} else if ("openSearchGipis085IntmListing".equals(ACTION)) {
				request.setAttribute("intmLOVName", request.getParameter("intmLOVName"));
				
				PAGE = "/pages/underwriting/pop-ups/wcommInvoiceIntermediary.jsp";
			} else if ("getGipis085IntermediaryListing".equals(ACTION)) {
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				String keyword = request.getParameter("keyword");
				String lovName = request.getParameter("lovName");
				String assdNo = request.getParameter("assdNo");
				String lineCd = request.getParameter("lineCd");
				String parId = request.getParameter("parId");
				
				if (null==keyword) {
					keyword = "";
				}
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				
				if (null != request.getParameter("pageNo")) {
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("keyword", keyword);
				params.put("lovName", lovName);
				params.put("assdNo", assdNo);
				params.put("lineCd", lineCd);
				params.put("parId", parId);
				
				searchResult = intermediaryService.getGipis085IntmLOVListing(pageNo, params);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				request.setAttribute("lovName", lovName);
				
				PAGE = "/pages/underwriting/pop-ups/searchWcommInvoiceIntmListingAjaxResult.jsp";
			} else if ("getDefaultTaxRate".equals(ACTION)) {
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				Integer intmNo = (request.getParameter("intmNo") == null) ? null : ((request.getParameter("intmNo").isEmpty()) ? null : Integer.parseInt(request.getParameter("intmNo")));
				BigDecimal wtaxRate = intermediaryService.getDefaultTaxRate(intmNo);
				
				message = (wtaxRate == null) ? "0" : wtaxRate.toString();
				
				PAGE = "/pages/genericMessage.jsp";
			} else if("showPremWarrLetter".equals(ACTION)){
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				intermediaryService.getPremWarrLetter(request, USER);
				PAGE = "/pages/claims/claimBasicInformation/subPages/premWarrLetter.jsp";
			}  else if ("getParentIntmNo".equals(ACTION)) {
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				message = intermediaryService.getParentIntmNo(request);
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("extractIntmProdColln".equals(ACTION)) {
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				message = intermediaryService.extractIntmProdColln(request, USER.getUserId());
			} else if ("extractWeb".equals(ACTION)) {
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				message = intermediaryService.extractWeb(request, USER.getUserId());
				
			// GIISS203 - Intermediary Listing Maintenance : shan 11.7.2013
			}else if("showGiiss203".equals(ACTION)){
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				GIISIntmTypeService intmTypeService = (GIISIntmTypeService) APPLICATION_CONTEXT.getBean("giisIntmTypeService");
				
				JSONObject json = intermediaryService.showGiiss203(request, USER.getUserId());
				List<GIISIntmType> intmTypeList = intmTypeService.getIntmTypeGiiss203();
				if(request.getParameter("refresh") == null) {
					request.setAttribute("intmTypeList", StringFormatter.escapeHTMLInList(intmTypeList));
					request.setAttribute("jsonIntermediaryList", json);
					PAGE = "/pages/underwriting/fileMaintenance/intermediary/intermediaryListing/intermediaryListing.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("valDeleteRec".equals(ACTION)){
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				
				message = intermediaryService.valDeleteRec(request);
				PAGE = "/pages/genericMessage.jsp";
			} /*else if ("valAddRec".equals(ACTION)){
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				
				intermediaryService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} */else if ("saveGiiss203".equals(ACTION)) {
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				
				intermediaryService.saveGiiss203(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				
			//GIISS076 - Intermediary Maintain : shan 11.11.2013
			}else if("showGiiss076".equals(ACTION)){
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				Integer intmNo = request.getParameter("intmNo") == "" ? null : Integer.parseInt(request.getParameter("intmNo"));
				GIISIntermediary giisIntm = intermediaryService.getGiiss076Record(intmNo);
				SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				String addEditSw = request.getParameter("addEditSw");
				
				if (addEditSw.equals("ADD")){
					request.setAttribute("recordStatus", "0");
				}else{
					request.setAttribute("recordStatus", null);
				}
				
				request.setAttribute("giisIntermediary", StringFormatter.escapeHTMLInObject(giisIntm));
				request.setAttribute("reqWtaxCode", intermediaryService.getRequireWtax());
				PAGE = "/pages/underwriting/fileMaintenance/intermediary/intermediaryMaintain/intermediaryMaintain.jsp";
				
			}else if("showGiiss076AddtlInfo".equals(ACTION)){
				PAGE = "/pages/underwriting/fileMaintenance/intermediary/intermediaryMaintain/popup/additionalInfo.jsp";
				
			}else if("showGiiss076MasterIntmDetails".equals(ACTION)){
				Integer masterIntmNo = request.getParameter("masterIntmNo") == "" ? null : Integer.parseInt(request.getParameter("masterIntmNo"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiiss0076MasterIntmDetails");	
				params.put("masterIntmNo", StringFormatter.escapeHTMLInObject(masterIntmNo));
				Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
				
				JSONObject json = new JSONObject(recList);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("masterIntmNo", masterIntmNo);
					request.setAttribute("jsonMasterIntm", json);
					PAGE = "/pages/underwriting/fileMaintenance/intermediary/intermediaryMaintain/popup/masterIntmDetails.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}
			else if("showGiiss076IntmHist".equals(ACTION)){
				Integer intmNo = request.getParameter("intmNo") == "" ? null : Integer.parseInt(request.getParameter("intmNo"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiiss0076IntmHist");	
				params.put("intmNo", intmNo);
				Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
				
				JSONObject json = new JSONObject(recList);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("intmNo", intmNo);
					request.setAttribute("intmName", StringFormatter.escapeHTML2(request.getParameter("intmName")));
					request.setAttribute("jsonIntmHist", json);
					PAGE = "/pages/underwriting/fileMaintenance/intermediary/intermediaryMaintain/popup/intmHist.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("copyIntermediaryGiiss076".equals(ACTION)){
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				message = intermediaryService.copyIntermediaryGiiss076(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkMobilePrefixGiiss076".equals(ACTION)){
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				message = intermediaryService.checkMobilePrefixGiiss076(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getParentTinGiiss076".equals(ACTION)){
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				Integer parentIntmNo = request.getParameter("parentIntmNo") == "" ? null : Integer.parseInt(request.getParameter("parentIntmNo"));
				message = intermediaryService.getParentTinGiiss076(parentIntmNo);
				PAGE = "/pages/genericMessage.jsp";
			}else if("valIntmNameGiiss076".equals(ACTION)){
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				message = (intermediaryService.valIntmNameGiiss076(request.getParameter("intmName")) == 0 ? "N" : "Y");
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGiacParamValueN".equals(ACTION)){
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				message = intermediaryService.getGiacParamValueN(request.getParameter("paramName"));
				PAGE = "/pages/genericMessage.jsp";
			}else if("valDeleteRecGiiss076".equals(ACTION)){
				Integer intmNo = request.getParameter("intmNo") == "" ? null : Integer.parseInt(request.getParameter("intmNo"));
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				intermediaryService.valDeleteRecGiiss076(intmNo);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveGiiss076".equals(ACTION)) {
				GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				
				message = intermediaryService.saveGiiss076(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("valCommRate".equals(ACTION)){
				message = giisIntermediaryService.valCommRate(request);
				PAGE = "/pages/genericMessage.jsp";
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
		} catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
