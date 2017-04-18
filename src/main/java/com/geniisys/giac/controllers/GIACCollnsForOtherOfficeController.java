package com.geniisys.giac.controllers;

import java.io.IOException;
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
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACOthFundOffCollns;
import com.geniisys.giac.service.GIACOthFundOffCollnsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACCollnsForOtherOfficeController extends BaseController {

	private static final long serialVersionUID = 1L;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIACCollnsForOtherOfficeController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
	
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
	
		log.info("Initializing " + this.getClass().getSimpleName());
		GIACOthFundOffCollnsService giacOthFundOffCollnsService = (GIACOthFundOffCollnsService) APPLICATION_CONTEXT.getBean("giacOthFundOffCollnsService");
		
		try{
			if("showCollnsForOtherOffices".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				Integer gaccTranId = Integer.parseInt(request.getParameter("gaccTranId"));
				List<GIACOthFundOffCollns> giacOthFundOffCollns = giacOthFundOffCollnsService.getGIACOthFundOffCollns(gaccTranId);
				StringFormatter.replaceQuotesInList(giacOthFundOffCollns);
				request.setAttribute("searchResult", new JSONArray(giacOthFundOffCollns));
				
				String [] argsTranType= {"GIAC_OTH_FUND_OFF_COLLNS.TRANSACTION_TYPE"};
				List<LOV> transactionType = lovHelper.getList(LOVHelper.TRANSACTION_TYPE_PARAM, argsTranType );
				request.setAttribute("transType", transactionType);
				
				String[] argsFundCd = {"GIACS012", USER.getUserId()};
				List<LOV> fundCd = lovHelper.getList(LOVHelper.GIBR_GFUN_FUND_LISTING, argsFundCd);
				request.setAttribute("fundList", fundCd);
				
				PAGE = "/pages/accounting/officialReceipt/otherTrans/collnsForOtherOff.jsp";
			}else if ("showCollnsForOtherOfficesTableGrid".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				Integer gaccTranId = (request.getParameter("gaccTranId").equals("") || request.getParameter("gaccTranId").equals("null") || request.getParameter("gaccTranId") == null) ? 0 : Integer.parseInt(request.getParameter("gaccTranId"));
				String [] argsTranType= {"GIAC_OTH_FUND_OFF_COLLNS.TRANSACTION_TYPE"};
				List<LOV> transactionType = lovHelper.getList(LOVHelper.TRANSACTION_TYPE_PARAM, argsTranType );
				String[] argsFundCd = {"GIACS012", USER.getUserId()};
				List<LOV> fundCd = lovHelper.getList(LOVHelper.GIBR_GFUN_FUND_LISTING, argsFundCd);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("gaccTranId", gaccTranId);
				
				List<Integer> itemNoList = new ArrayList<Integer>();
				itemNoList = giacOthFundOffCollnsService.getItemNoList(gaccTranId);
				Map<String, Object> collns = TableGridUtil.getTableGrid(request, params);
				StringFormatter.replaceQuotesInMap(collns);
				JSONObject collnsJSON = new JSONObject(collns);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("fundCdList", fundCd);
					request.setAttribute("transType", transactionType);
					request.setAttribute("collnsJSON", collnsJSON);
					request.setAttribute("itemNoList", itemNoList);
					PAGE = "/pages/accounting/officialReceipt/otherTrans/collnsForOtherOffTableGrid.jsp";
				}else{
					message = collnsJSON.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showTransactionNoListing".equals(ACTION)){
				PAGE = "/pages/accounting/officialReceipt/otherTrans/pop-ups/searchTransactionNo.jsp";
			}else if("getTransactionNoListing".equals(ACTION)){
				String keyword = request.getParameter("keyword")== null ? "" :(request.getParameter("keyword"));
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				
				if(null != request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"));
					}
				}
				
				searchResult = giacOthFundOffCollnsService.getTransactionNoListing(keyword, pageNo);
				System.out.println("Search Result "+searchResult);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", pageNo);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				PAGE = "/pages/accounting/officialReceipt/otherTrans/pop-ups/searchTransactionNoResults.jsp";
			
			}else if("saveGIACOthFundOffCollns".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("tranSource", request.getParameter("tranSource"));
				params.put("orFlag", request.getParameter("orFlag"));
				params.put("globalBranchCd", request.getParameter("globalBranchCd"));
				params.put("globalFundCd", request.getParameter("globalFundCd"));
				
				JSONArray setRows = new JSONArray(request.getParameter("setRows"));
				JSONArray delRows = new JSONArray(request.getParameter("delRows"));
				
				message = giacOthFundOffCollnsService.saveGIACOthFundOffCollns(setRows, delRows, params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getDefaultAmount".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("tranYear", Integer.parseInt(request.getParameter("tranYear")));
				params.put("tranMonth", Integer.parseInt(request.getParameter("tranMonth")));
				params.put("tranSeqNo", Integer.parseInt(request.getParameter("tranSeqNo")));
				params.put("gibrGfunFund", request.getParameter("gibrGfunFund"));
				params.put("gofcGibrBranch", request.getParameter("gofcGibrBranch"));
				params.put("gofcItemNo", Integer.parseInt(request.getParameter("gofcItemNo")));
				params.put("collnAmt", Integer.parseInt("0"));
				params.put("message", "");
				JSONObject obj = new JSONObject(giacOthFundOffCollnsService.getDefaultAmount(params));
				message = obj.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("chkGiacOthFundOffCol".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("gibrBranchCd", request.getParameter("branchCd"));
				params.put("gibrGfunFundCd", request.getParameter("fundCd"));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("message", "");
				JSONObject obj = new JSONObject(giacOthFundOffCollnsService.chkGiacOthFundOffCol(params));
				message = obj.toString();
				PAGE = "/pages/genericMessage.jsp";
			}
			
		}catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(JSONException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
