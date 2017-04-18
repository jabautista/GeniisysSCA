package com.geniisys.giex.controllers;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giex.service.GIEXItmperilService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIEXItmperilController", urlPatterns={"/GIEXItmperilController"})
public class GIEXItmperilController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GIEXItmperilController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIEXItmperilService giexItmperilService = (GIEXItmperilService) APPLICATION_CONTEXT.getBean("giexItmperilService");
			
			if ("getGIEXS007B480Info".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("policyId", request.getParameter("policyId"));
				Map<String, Object> b480Dtls = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(b480Dtls);
				request.setAttribute("perilCdExist", json.getString("total"));
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("b480Dtls", json);
					PAGE = "/pages/underwriting/renewalProcessing/processExpiringPolicies/editPerilInfo/subPages/itmPerilInfo.jsp";
				}
			}else if ("getPackSubPolicies".equals(ACTION)){ //joanne 12.17.13
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("packPolicyId", request.getParameter("packPolicyId"));
				params.put("summarySw", request.getParameter("summarySw")); //joanne 02.03.14
				System.out.println("summarySw"+ request.getParameter("summarySw"));
				Map<String, Object> packSubPolicyList = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(packSubPolicyList);
				//request.setAttribute("perilCdExist", json.getString("total"));
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("packSubPolicyList", json);
					PAGE = "/pages/underwriting/renewalProcessing/processExpiringPolicies/editPerilInfo/subPages/packSubPolicyList.jsp";
				}					
			}else if ("getGIEXS007B490Info".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("policyId", request.getParameter("policyId"));
				params.put("itemNo", request.getParameter("itemNo"));
				Map<String, Object> b490Dtls = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(b490Dtls);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("b490Dtls", json);
					PAGE = "/pages/underwriting/renewalProcessing/processExpiringPolicies/editPerilInfo/subPages/editItmPeril.jsp";
				}
			}else if("deletePerilGIEXS007".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = giexItmperilService.deletePerilGIEXS007(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("createPerilGIEXS007".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId());
				params = giexItmperilService.createPerilGIEXS007(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveGIEXItmperil".equals(ACTION)){
				giexItmperilService.saveGIEXItmperil(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("computeTsiGIEXS007".equals(ACTION) || "computePremiumGIEXS007".equals(ACTION)){
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				Date effDate = request.getParameter("effDate").equals("") ? null : df.parse(request.getParameter("effDate"));
				Date endtExpiryDate = request.getParameter("endtExpiryDate").equals("") ? null : df.parse(request.getParameter("endtExpiryDate"));
				Date expiryDate = request.getParameter("expiryDate").equals("") ? null : df.parse(request.getParameter("expiryDate"));
				params.put("userId", USER.getUserId());
				params.put("effDate", effDate);
				params.put("endtExpiryDate", endtExpiryDate);
				params.put("expiryDate", expiryDate);
				if ("computeTsiGIEXS007".equals(ACTION)){
					params = giexItmperilService.computeTsiGIEXS007(params);
				}else{
					params = giexItmperilService.computePremiumGIEXS007(params);
				}
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("updateWitemGIEXS007".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("userId", USER.getUserId()); //joanne 06.10.14
				params = giexItmperilService.updateWitemGIEXS007(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("deleteOldPEril".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				giexItmperilService.deleteOldPEril(params);
			}else if("computeDeductibleAmt".equals(ACTION)){
				message = giexItmperilService.computeDeductibleAmt(request, USER);
				PAGE = "/pages/genericMessage.jsp"; //joanne 06.06.14
			}else if("validateItemperil".equals(ACTION)){ //joanne 12-02-13
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = giexItmperilService.validateItemperil(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";	
			}else if("deleteItemperil".equals(ACTION)){ //joanne 12-02-13
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = giexItmperilService.deleteItemperil(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";					
			}
			
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
