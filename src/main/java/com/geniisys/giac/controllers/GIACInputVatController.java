package com.geniisys.giac.controllers;

import java.io.IOException;
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
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACChartOfAccts;
import com.geniisys.giac.entity.GIACInputVat;
import com.geniisys.giac.entity.GIACSlLists;
import com.geniisys.giac.service.GIACInputVatService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACInputVatController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIACInputVatController.class);

	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			/*default attributes*/
			log.info("Initializing..."+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			String strGaccTranId = request.getParameter("globalGaccTranId") == null ? "0" : request.getParameter("globalGaccTranId");
			Integer gaccTranId= strGaccTranId.trim().equals("") ? 0 : Integer.parseInt(strGaccTranId);
			String gaccBranchCd = request.getParameter("globalGaccBranchCd") == null ? "" :request.getParameter("globalGaccBranchCd");
			String gaccFundCd = request.getParameter("globalGaccFundCd") == null ? "" :request.getParameter("globalGaccFundCd");

			log.info("Tran ID   : " + gaccTranId);
			log.info("Branch Cd : " + gaccBranchCd);
			log.info("Fund Cd   : " + gaccFundCd);
			log.info("USER ID   : " + USER.getUserId());
			
			if ("showDirectTransInputVat".equals(ACTION)){
				GIACInputVatService giacInputVatService = (GIACInputVatService) APPLICATION_CONTEXT.getBean("giacInputVatService");
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				HashMap<String, String> params = new HashMap<String, String>();
				params.put("gaccTranId", gaccTranId.toString());
				params.put("gaccFundCd", gaccFundCd);
				List<GIACInputVat> giacInputVats = giacInputVatService.getGiacInputVat(params);
				JSONArray giacInputVatsJSON = new JSONArray(giacInputVats);
				String[] rvDomain = {"GIAC_INPUT_VAT.TRANSACTION_TYPE"};
				request.setAttribute("transactionTypeList", helper.getList(LOVHelper.RISK_TAG_LISTING, rvDomain));
				request.setAttribute("payeeClassList", helper.getList(LOVHelper.PAYEE_CLASS_LISTING));
				request.setAttribute("itemNoList", helper.getList(LOVHelper.GL_ACCT_LISTING));
				//request.setAttribute("vatSlList", helper.getList(LOVHelper.VAT_SL_LISTING)); commented out by reymon 10292013
				//request.setAttribute("vatSlListJSON", new JSONArray((List<GIACSlLists>) StringFormatter.replaceQuotesInList(helper.getList(LOVHelper.VAT_SL_LISTING)))); commented out by reymon 10292013
				request.setAttribute("giacInputVatsJSON", giacInputVatsJSON);
				request.setAttribute("inputVatRt", giacParamService.getParamValueN("INPUT_VAT_RT"));
				PAGE = "/pages/accounting/officialReceipt/directTrans/inputVat.jsp";
			}else if ("showDirectTransInputVatTableGrid".equals(ACTION)){
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", gaccTranId.toString());
				params.put("gaccFundCd", gaccFundCd);
				params.put("ACTION", "getGIACInputVatsTableGrid");
				
				Map<String, Object> giacInputVats = TableGridUtil.getTableGrid(request,params);
				JSONObject giacInputVatsJSON = new JSONObject(giacInputVats);
				System.out.println("rows:" + giacInputVatsJSON.toString());
				if("1". equals(request.getParameter("ajax"))){
					String[] rvDomain = {"GIAC_INPUT_VAT.TRANSACTION_TYPE"};
					request.setAttribute("transactionTypeList", helper.getList(LOVHelper.RISK_TAG_LISTING, rvDomain));
					request.setAttribute("payeeClassList", helper.getList(LOVHelper.PAYEE_CLASS_LISTING));
					request.setAttribute("itemNoList", helper.getList(LOVHelper.GL_ACCT_LISTING));
					//request.setAttribute("vatSlList", helper.getList(LOVHelper.VAT_SL_LISTING)); commented out by reymon 10292013
					//request.setAttribute("vatSlListJSON", new JSONArray((List<GIACSlLists>) StringFormatter.replaceQuotesInList(helper.getList(LOVHelper.VAT_SL_LISTING)))); commented out by reymon 10292013
					request.setAttribute("giacInputVatsJSON", giacInputVatsJSON);
					request.setAttribute("inputVatRt", giacParamService.getParamValueN("INPUT_VAT_RT"));
					PAGE = "/pages/accounting/officialReceipt/directTrans/inputVat.jsp";
				} else{
					message = giacInputVatsJSON.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("openSearchPayeeInputVat".equals(ACTION)){
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchPayeeInputVat.jsp";
			}else if ("getPayeeInputVatListing".equals(ACTION)){
				log.info("Getting Payee Listing records.");
				GIACInputVatService giacInputVatService = (GIACInputVatService) APPLICATION_CONTEXT.getBean("giacInputVatService");
				
				String keyword = request.getParameter("keyword");
				if(null==keyword){
					keyword = "";
				}
				
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("payeeName", keyword);
				log.info("Parameters: "+params);
				
				PaginatedList searchResult = null;
				searchResult = giacInputVatService.getPayeeList(params,pageNo);
				request.setAttribute("keyword", keyword);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchPayeeInputVatAjaxResult.jsp";
			}else if ("openSearchSlNameInputVat".equals(ACTION)){
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchSlNameInputVat.jsp";
			}else if ("getSlNameInputVatListing".equals(ACTION)){
				log.info("Getting SL Name Listing records.");
				GIACInputVatService giacInputVatService = (GIACInputVatService) APPLICATION_CONTEXT.getBean("giacInputVatService");
				
				String keyword = request.getParameter("keyword");
				if(null==keyword){
					keyword = "";
				}
				
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				HashMap<String, Object> params =  new HashMap<String, Object>();
				params.put("gsltSlTypeCd", request.getParameter("gsltSlTypeCd"));
				params.put("slName", keyword);
				//params.put("keyword", keyword);
				log.info("Parameters: "+params);
				
				PaginatedList searchResult = null;
				searchResult = giacInputVatService.getSlNameList(params,pageNo);
				request.setAttribute("keyword", keyword);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchSlNameInputVatAjaxResult.jsp";
			}else if ("openSearchAcctCodeInputVat".equals(ACTION)){
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchAccountCodeInputVat.jsp";
			}else if ("getAcctCodeInputVatListing".equals(ACTION)){
				log.info("Getting Account Code Listing records.");
				GIACInputVatService giacInputVatService = (GIACInputVatService) APPLICATION_CONTEXT.getBean("giacInputVatService");
				
				String keyword = request.getParameter("keyword");
				if(null==keyword){
					keyword = "";
				}
				
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				
				HashMap<String, Object> params =  new HashMap<String, Object>();
				//params.put("glAcctName", keyword);
				params.put("keyword", keyword);
				log.info("Parameters: "+params);
				
				PaginatedList searchResult = null;
				searchResult = giacInputVatService.getAcctCodeList(params,pageNo);
				request.setAttribute("keyword", keyword);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				JSONArray searchResultJSON = new JSONArray(searchResult);
				request.setAttribute("searchResultJSON", searchResultJSON);
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchAccountCodeInputVatAjaxResult.jsp";
			}else if ("validateAcctCode".equals(ACTION)){
				GIACInputVatService giacInputVatService = (GIACInputVatService) APPLICATION_CONTEXT.getBean("giacInputVatService");
				HashMap<String, String> params = new HashMap<String, String>();
				params.put("glAcctCategory", request.getParameter("glAcctCategory"));
				params.put("glControlAcct", request.getParameter("glControlAcct"));
				params.put("glSubAcct1", request.getParameter("glSubAcct1"));
				params.put("glSubAcct2", request.getParameter("glSubAcct2"));
				params.put("glSubAcct3", request.getParameter("glSubAcct3"));
				params.put("glSubAcct4", request.getParameter("glSubAcct4"));
				params.put("glSubAcct5", request.getParameter("glSubAcct5"));
				params.put("glSubAcct6", request.getParameter("glSubAcct6"));
				params.put("glSubAcct7", request.getParameter("glSubAcct7"));
				GIACChartOfAccts giacChartOfAccts = giacInputVatService.validateAcctCode(params);
				JSONObject giacChartOfAcctsJSON = new JSONObject(giacChartOfAccts);
				message = giacChartOfAcctsJSON.toString(); 
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveInputVat".equals(ACTION)){
				GIACInputVatService giacInputVatService = (GIACInputVatService) APPLICATION_CONTEXT.getBean("giacInputVatService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", gaccTranId);
				params.put("gaccBranchCd", gaccBranchCd);
				params.put("gaccFundCd", gaccFundCd);
				params.put("userId", USER.getUserId());
				params.put("globalTranSource", request.getParameter("globalTranSource"));
				params.put("globalOrFlag", request.getParameter("globalOrFlag"));
				params.put("setRows", giacInputVatService.prepareGIACInputVatJSON(new JSONArray(request.getParameter("setRows")), USER.getUserId()));
				params.put("delRows", giacInputVatService.prepareGIACInputVatJSON(new JSONArray(request.getParameter("delRows")), USER.getUserId()));

				System.out.println("SET: " + request.getParameter("setRows"));
				System.out.println("DELETE: " + request.getParameter("delRows"));
				message = giacInputVatService.saveInputVat(params);
				PAGE = "/pages/genericMessage.jsp";
			}
			
		}catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		//} catch (ParseException e) {
		//	message = "Date Parse Exception occured...<br />"+e.getCause();
		//	PAGE = "/pages/genericMessage.jsp";
		//	e.printStackTrace();
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}