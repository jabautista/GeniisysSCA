package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPIWGroupedItemsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIPIWGroupedItemsController", urlPatterns={"/GIPIWGroupedItemsController"})
public class GIPIWGroupedItemsController extends BaseController{
	
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWGroupedItemsService gipiWGroupedItemsService = (GIPIWGroupedItemsService) APPLICATION_CONTEXT.getBean("gipiWGroupedItemsService");
			
			if("getGIPIWGroupedItemsTableGrid".equals(ACTION)){
				Map<String, Object> tgParams = new HashMap<String, Object>();
				Integer parId = Integer.parseInt(request.getParameter("parId") != null ? request.getParameter("parId") : null);
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo") != null ? request.getParameter("itemNo") : null);
				
				tgParams.put("ACTION", ACTION);
				tgParams.put("parId", parId);
				tgParams.put("itemNo", itemNo);
				//tgParams.put("pageSize", 5);				
								
				Map<String, Object> tgGroupedItems = TableGridUtil.getTableGrid(request, tgParams);
				request.setAttribute("tgGroupedItems", new JSONObject(tgGroupedItems));
				
				PAGE = "/pages/underwriting/parTableGrid/casualty/subPages/groupedItems/groupedItemsTableGridListing.jsp";
			}else if("refreshGroupedItemsTable".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();				
				
				params.put("ACTION", "getGIPIWGroupedItemsTableGrid");		
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));				
				//params.put("pageSize", 5);
				
				params = TableGridUtil.getTableGrid(request, params);
				
				// apollo cruz 04.20.2015 - to get gipiWGroupedItems even on refresh
				params.put("gipiWGroupedItems", new JSONArray(gipiWGroupedItemsService.getGipiWGroupedItems2(Integer.parseInt(request.getParameter("parId")), Integer.parseInt(request.getParameter("itemNo")))));
				
				message = (new JSONObject(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("renumberGroupedItems".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				
				gipiWGroupedItemsService.renumberGroupedItems(params);
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";					
			}else if("getGroupedItemsListing".equals(ACTION)){
				Integer parId = Integer.parseInt(request.getParameter("parId"));
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("parId", parId);
				params.put("itemNo", itemNo);
				params.put("pageSize", 6);
				
				Map<String, Object> groupedItemsTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(groupedItemsTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					HashMap<String, Object> vars = gipiWGroupedItemsService.setGroupedItemsVars(params);
					request.setAttribute("vars", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(vars)));
					request.setAttribute("groupedItemsTGJson", json);
					PAGE = "/pages/underwriting/endt/jsonAccident/overlay/endtACGroupedItemsOverlay.jsp";
				}
			}else if("validateGroupedItemNo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params = gipiWGroupedItemsService.validateGroupedItemNo(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateGroupedItemTitle".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("groupedItemTitle", request.getParameter("groupedItemTitle"));
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params = gipiWGroupedItemsService.validateGroupedItemTitle(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validatePrincipalCd".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("principalCd", Integer.parseInt(request.getParameter("principalCd")));
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params = gipiWGroupedItemsService.validatePrincipalCd(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateGrpFromDate".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("fromDate", request.getParameter("fromDate"));
				params.put("toDate", request.getParameter("toDate"));
				params = gipiWGroupedItemsService.validateGrpFromDate(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateGrpToDate".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("fromDate", request.getParameter("fromDate"));
				params.put("toDate", request.getParameter("toDate"));
				params = gipiWGroupedItemsService.validateGrpToDate(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("getGroupedItem".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();				
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("amountCovered", request.getParameter("amountCovered"));
				params.put("groupCd", request.getParameter("groupCd"));
				HashMap<String, Object> wGroupedItem = gipiWGroupedItemsService.getGroupedItem(params);
				//request.setAttribute("object", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(wGroupedItem)));
				request.setAttribute("object", new JSONObject((HashMap<String, Object>)wGroupedItem));
				PAGE = "/pages/genericObject.jsp";
			}else if("getDeleteSwVars".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();				
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
				params.put("fromDate", request.getParameter("fromDate"));
				params = gipiWGroupedItemsService.getDeleteSwVars(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateRetrieveGrpItems".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("effDate", request.getParameter("effDate"));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				message = gipiWGroupedItemsService.validateRetrieveGrpItems(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateAmtCovered".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("effDate", request.getParameter("effDate"));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
				params.put("amountCovered", request.getParameter("amountCovered"));
				params.put("recFlag", request.getParameter("recFlag"));
				params.put("groupedItemTitle", request.getParameter("groupedItemTitle"));
				params = gipiWGroupedItemsService.validateAmtCovered(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("preNegateDelete".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
				message = gipiWGroupedItemsService.preNegateDelete(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkBackEndt".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("effDate", request.getParameter("effDate"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("groupedItemNo", request.getParameter("groupedItemNo"));
				message = gipiWGroupedItemsService.checkBackEndt(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("negateDelete".equals(ACTION)){
				gipiWGroupedItemsService.negateDelete(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGroupedItems".equals(ACTION)){
				gipiWGroupedItemsService.saveGroupedItems(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showRetrieveGrpItemsOverlay".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getRetrievedGroupedItemsListing");
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("effDate", request.getParameter("effDate"));
				
				Map<String, Object> retrievedGrpTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(retrievedGrpTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("retrievedGrpTGJson", json);
					PAGE = "/pages/underwriting/endt/jsonAccident/overlay/retrieveGrpItemsOverlay.jsp";
				}
			}else if("insertRetrievedGrpItems".equals(ACTION)){
				gipiWGroupedItemsService.insertRetrievedGrpItems(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showCopyBenefitsOverlay".equals(ACTION)){
				Integer groupedItemNo = Integer.parseInt(request.getParameter("groupedItemNo"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getCopyBenefitsListing");
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("groupedItemNo", groupedItemNo);
				
				Map<String, Object> copyBenTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(copyBenTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("packBenCd", request.getParameter("packBenCd"));
					request.setAttribute("copyBenTGJson", json);
					PAGE = "/pages/underwriting/endt/jsonAccident/overlay/copyBenefitsOverlay.jsp";
				}
			}else if("copyBenefits".equals(ACTION)){
				gipiWGroupedItemsService.copyBenefits(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkGroupedItems".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", request.getParameter("parId"));
				params.put("itemNo", request.getParameter("itemNo"));
				message = gipiWGroupedItemsService.checkGroupedItems(params).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateNoOfPersons".equals(ACTION)){
				message = gipiWGroupedItemsService.validateNoOfPersons(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getCAGroupedItems".equals(ACTION)) { //Deo [01.26.2017]: SR-23702
				message = new JSONObject(gipiWGroupedItemsService.getCAGroupedItems(request)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}		
	}
}