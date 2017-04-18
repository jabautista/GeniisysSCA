package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
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
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACChartOfAccts;
import com.geniisys.giac.entity.GIACUnidentifiedCollns;
import com.geniisys.giac.service.GIACAcctEntriesService;
import com.geniisys.giac.service.GIACChartOfAcctsService;
import com.geniisys.giac.service.GIACUnidentifiedCollnsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACUnidentifiedCollnsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private static Logger log = Logger.getLogger(GIACUnidentifiedCollnsController.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
			GIACChartOfAcctsService acctCdDtls = (GIACChartOfAcctsService) APPLICATION_CONTEXT.getBean("giacChartOfAcctsService");
			
			if ("showUnidentifiedCollection".equals(ACTION)){
				String[] param = {"GIAC_UNIDENTIFIED_COLLNS.TRANSACTION_TYPE"};
				List<LOV> tranTypeList = helper.getList(LOVHelper.CG_REF_CODE_LISTING, param);
				System.out.println("SIZE LIST: " + tranTypeList.size());
				StringFormatter.replaceQuotesInList(tranTypeList);
				request.setAttribute("tranTypeListJSON", new JSONArray(tranTypeList));
				int maxItemNo = 0;
				BigDecimal totalCollnAmt = new BigDecimal(0);
				
				Map<String, Object> params2 = new HashMap<String, Object>();
				params2.put("ACTION", "getUnidentifiedCollnsList");
				params2.put("gaccTranId", (request.getParameter("gaccTranId") == null || request.getParameter("gaccTranId").equals("") || request.getParameter("gaccTranId").equals("null")) ? 0 : Integer.parseInt(request.getParameter("gaccTranId")));
				params2.put("fundCd", request.getParameter("fundCd"));
				
				Map<String, Object> unspecifiedCollnsListTableGrid = TableGridUtil.getTableGrid(request, params2);
				StringFormatter.replaceQuotesInMap(unspecifiedCollnsListTableGrid);
				JSONObject json = new JSONObject(unspecifiedCollnsListTableGrid);
				System.out.println("unspecifiedCollns " + json.toString());
				
				JSONArray rows = json.getJSONArray("rows");
				for (int i = 0; i < rows.length(); i++) {
					maxItemNo = Integer.parseInt(rows.getJSONObject(i).getString("maxItemNo"));
					totalCollnAmt = new BigDecimal(rows.getJSONObject(i).getString("totalCollnAmt"));
				}
				request.setAttribute("maxItemNo", maxItemNo);
				request.setAttribute("totalCollnAmt", totalCollnAmt);
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("unspecifiedCollnsListJSON", json);
					PAGE = "/pages/accounting/officialReceipt/otherTrans/unidentifiedCollection.jsp";
				}	
			}
			else if ("openSearchItemModal".equals(ACTION)){
				PAGE = "/pages/accounting/officialReceipt/otherTrans/pop-ups/searchByItemNo.jsp";
			} else if ("getItemSearchResult".equals(ACTION)){
				
				GIACUnidentifiedCollnsService unIdentifiedCollnsService = (GIACUnidentifiedCollnsService) APPLICATION_CONTEXT.getBean("giacUnidentifiedCollnsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("tranYear", request.getParameter("tranYear").equals("") ? null : request.getParameter("tranYear"));
				params.put("tranMonth", request.getParameter("tranMonth").equals("") ? null : request.getParameter("tranMonth"));
				params.put("tranSeqNo", request.getParameter("tranSeqNo").equals("") ? null : request.getParameter("tranSeqNo"));
				
				Debug.print("PARAMS: " + params);
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				searchResult = unIdentifiedCollnsService.getOldItemList(params, pageNo);
				System.out.println("SIZE: " + searchResult.getNoOfPages() + " pageNo: " + searchResult.getPageIndex()+1);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				StringFormatter.replaceQuotesInList(searchResult);
				request.setAttribute("JSONSearchResults", new JSONArray(searchResult));
				PAGE = "/pages/accounting/officialReceipt/otherTrans/pop-ups/searchByItemNoAjaxResult.jsp";
			}else if ("openAccountCodeModal".equals(ACTION)){
				
				PAGE = "/pages/accounting/officialReceipt/otherTrans/pop-ups/searchAccountCode.jsp";
			}else if ("getAcctCdSearchResult".equals(ACTION)) {
				//GIACChartOfAcctsService acctCdDtls = (GIACChartOfAcctsService) APPLICATION_CONTEXT.getBean("giacChartOfAcctsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("glAcctCategory", request.getParameter("glAcctCategory"));
				params.put("glControlAcct", request.getParameter("glControlAcct"));
				params.put("glSubAcct1", request.getParameter("glSubAcct1"));
				params.put("glSubAcct2", request.getParameter("glSubAcct2"));
				params.put("glSubAcct3", request.getParameter("glSubAcct3"));
				params.put("glSubAcct4", request.getParameter("glSubAcct4"));
				params.put("glSubAcct5", request.getParameter("glSubAcct5"));
				params.put("glSubAcct6", request.getParameter("glSubAcct6"));
				params.put("glSubAcct7", request.getParameter("glSubAcct7"));
				
				Debug.print("PARAMS: " + params);
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				searchResult = acctCdDtls.getAccountCodeDtls(params, pageNo);
				System.out.println("SIZE: " + searchResult.getNoOfPages() + " pageNo: " + searchResult.getPageIndex()+1);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				StringFormatter.replaceQuotesInList(searchResult);
				request.setAttribute("JSONAcctCdSearchResults", new JSONArray(searchResult));
				
				PAGE = "/pages/accounting/officialReceipt/otherTrans/pop-ups/searchAccountCodeAjaxResult.jsp";
			}else if ("getSlListing".equals(ACTION)){
				String[] param = {request.getParameter("slTypeCd"), request.getParameter("fundCd")};
				List<LOV> slTypeList = helper.getList(LOVHelper.ACCT_ENTRIES_SL_LISTING2, param);
				StringFormatter.replaceQuotesInList(slTypeList);
				
				message = new JSONArray(slTypeList).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveUnidentifiedCollnsDtls".equals(ACTION)){
				GIACUnidentifiedCollnsService unIdentifiedCollnsService = (GIACUnidentifiedCollnsService) APPLICATION_CONTEXT.getBean("giacUnidentifiedCollnsService");
				JSONObject objParams = new JSONObject(request.getParameter("parameter"));
				Map<String, Object> params =  new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("user", USER.getUserId());
				params.put("moduleName", "GIACS014");
				params.put("orFlag", request.getParameter("orFlag"));
				params.put("tranSource", request.getParameter("tranSource"));
				params.put("insParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("addModifiedUnidentifiedCollns")), USER.getUserId(), GIACUnidentifiedCollns.class));
				params.put("delParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("deletedUnidentifiedCollns")), USER.getUserId(), GIACUnidentifiedCollns.class));
				
				Debug.print("SAVE PARAMS" + params);
				System.out.println("CC SaveParams: " + params.toString());
				unIdentifiedCollnsService.saveUnidentifiedCollnsDtls(params);
				
				message = "Saving successful.";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateAcctCode".equals(ACTION)){
				//GIACChartOfAcctsService acctCdDtls = (GIACChartOfAcctsService) APPLICATION_CONTEXT.getBean("giacChartOfAcctsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("glAcctCategory", request.getParameter("glAcctCategory"));
				params.put("glControlAcct", request.getParameter("glControlAcct"));
				params.put("glSubAcct1", request.getParameter("glSubAcct1"));
				params.put("glSubAcct2", request.getParameter("glSubAcct2"));
				params.put("glSubAcct3", request.getParameter("glSubAcct3"));
				params.put("glSubAcct4", request.getParameter("glSubAcct4"));
				params.put("glSubAcct5", request.getParameter("glSubAcct5"));
				params.put("glSubAcct6", request.getParameter("glSubAcct6"));
				params.put("glSubAcct7", request.getParameter("glSubAcct7"));
				
				Debug.print("Validate acct code params: " + params);
				
				List<GIACChartOfAccts> searchResult = acctCdDtls.getAccountCodes(params);
				StringFormatter.replaceQuotesInList(searchResult);
				System.out.println("Acct Codes Validation: " +  searchResult.toString());
				System.out.println("size: " + searchResult.size()); 
				//request.setAttribute("acctSize", searchResult.size());
				
				message = new JSONArray(searchResult).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateOldTranNo".equals(ACTION)){
				GIACUnidentifiedCollnsService unIdentifiedCollnsService = (GIACUnidentifiedCollnsService) APPLICATION_CONTEXT.getBean("giacUnidentifiedCollnsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccFundCd", request.getParameter("gaccFundCd"));
				params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("tranYear", request.getParameter("tranYear"));
				params.put("tranMonth", request.getParameter("tranMonth"));
				params.put("tranSeqNo", request.getParameter("tranSeqNo"));
				params.put("itemNo", request.getParameter("itemNo"));
				
				Debug.print("params: " + params);
				
				message = unIdentifiedCollnsService.validateOldTranNo(params);
				System.out.println("Val oldTran: " + message);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateOldItemNo".equals(ACTION)){
				GIACUnidentifiedCollnsService unIdentifiedCollnsService = (GIACUnidentifiedCollnsService) APPLICATION_CONTEXT.getBean("giacUnidentifiedCollnsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("itemNo", request.getParameter("itemNo"));
				
				Debug.print("params: " + params);
				
				message = unIdentifiedCollnsService.validateOldItemNo(params);
				System.out.println("Val oldItem: " + message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateItemNo".equals(ACTION)){
				GIACUnidentifiedCollnsService unIdentifiedCollnsService = (GIACUnidentifiedCollnsService) APPLICATION_CONTEXT.getBean("giacUnidentifiedCollnsService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("itemNo",request.getParameter("itemNo"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				
				System.out.println("Validate Item No Params: " + params.toString());
				
				message = unIdentifiedCollnsService.validateItemNo(params);
				System.out.println("Val Res: " + message);
				PAGE = "/pages/genericMessage.jsp";
				
				
				
			}else if ("getItemSearchResult2".equals(ACTION)){
				
				GIACUnidentifiedCollnsService unIdentifiedCollnsService = (GIACUnidentifiedCollnsService) APPLICATION_CONTEXT.getBean("giacUnidentifiedCollnsService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("keyword", request.getParameter("keyword").equals("") ? null : request.getParameter("keyword"));
				
				Debug.print("PARAMS: " + params);
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				searchResult = unIdentifiedCollnsService.searchOldItemList(params, pageNo);
				System.out.println("SIZE: " + searchResult.getNoOfPages() + " pageNo: " + searchResult.getPageIndex()+1);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				StringFormatter.replaceQuotesInList(searchResult);
				request.setAttribute("JSONSearchResults", new JSONArray(searchResult));
				PAGE = "/pages/accounting/officialReceipt/otherTrans/pop-ups/searchByItemNoAjaxResult.jsp";
			}else if ("getAcctCdSearchResult2".equals(ACTION)) {
				//GIACChartOfAcctsService acctCdDtls = (GIACChartOfAcctsService) APPLICATION_CONTEXT.getBean("giacChartOfAcctsService");
				String keyword = request.getParameter("keyword");
				System.out.println("keyword: " + keyword);
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				searchResult = acctCdDtls.getAccountCodeDtls2(keyword, pageNo);
				System.out.println("SIZE: " + searchResult.getNoOfPages() + " pageNo: " + searchResult.getPageIndex()+1);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				StringFormatter.replaceQuotesInList(searchResult);
				request.setAttribute("JSONAcctCdSearchResults", new JSONArray(searchResult));
				
				PAGE = "/pages/accounting/officialReceipt/otherTrans/pop-ups/searchAccountCodeAjaxResult.jsp";
			} else if("retrieveGlAcct".equals(ACTION)) {
				GIACAcctEntriesService acctEntriesService = APPLICATION_CONTEXT.getBean(GIACAcctEntriesService.class);
				String strParams = request.getParameter("glAcctObj");
				System.out.println("Retrieving chart of accounts - "+strParams);
				
				GIACChartOfAccts chartAccts = acctEntriesService.retrieveGLAccount(strParams);
				StringFormatter.replaceQuotesInObject(chartAccts);

				JSONObject acctEntriesObject = new JSONObject(chartAccts == null ? "" : chartAccts);
				request.setAttribute("object", acctEntriesObject == null ? "[]" : acctEntriesObject);
				System.out.println("object " + acctEntriesObject);
				PAGE = "/pages/genericObject.jsp";
			}else if("validateDelRec".equals(ACTION)){	//shan 10.30.2013
				GIACUnidentifiedCollnsService unIdentifiedCollnsService = (GIACUnidentifiedCollnsService) APPLICATION_CONTEXT.getBean("giacUnidentifiedCollnsService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				unIdentifiedCollnsService.validateDelRec(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch (NullPointerException e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

	
}
