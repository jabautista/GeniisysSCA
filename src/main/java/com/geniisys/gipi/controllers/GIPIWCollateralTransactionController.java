package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.util.HashMap;

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
import com.geniisys.gipi.service.GIPICollateralService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIWCollateralTransactionController extends BaseController {

	private static final long serialVersionUID = 1L;
	public static Logger log = Logger.getLogger(GIPIWCollateralTransactionController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub	
			try{
				ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				//GIISCollateralService giisCollateralService = (GIISCollateralService) APPLICATION_CONTEXT.getBean("giisCollateralService");
				GIPICollateralService gipiCollateralService = (GIPICollateralService) APPLICATION_CONTEXT.getBean("gipiCollateralService");
				if( "showCollateralTransactionPage".equals(ACTION)){
					//int parId = Integer.parseInt((request.getParameter("globalParId") == null) ? "0" : request.getParameter("globalParId"));
					int parId = Integer.parseInt((request.getParameter("parId") == null) ? "0" : request.getParameter("parId"));				
					request.setAttribute("parId", parId);
					request.setAttribute("collateralListing", lovHelper.getList(LOVHelper.COLLATERAL_TYPE_LISTING));
					request.setAttribute("collateralDescList", lovHelper.getList(LOVHelper.COLLATERAL_DESC_LISTING));
					request.setAttribute("collateralDescList2", new JSONArray (lovHelper.getList(LOVHelper.COLLATERAL_DESC_LISTING)));
													
					HashMap<String, Object> params = new HashMap<String, Object>();
					params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
					params.put("parId", request.getParameter("parId"));
					//params = gipiCollateralService.getCollateralList(params); //
					
					if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
						params.put("sortColumn", request.getParameter("sortColumn"));
						params.put("ascDescFlg", request.getParameter("ascDescFlg"));
						params = gipiCollateralService.getCollateralList(params);
						JSONObject json = new JSONObject(params);
						System.out.println(params);
						message = json.toString();					
						PAGE = "/pages/genericMessage.jsp";
					} else {
						System.out.println(params);
						params = gipiCollateralService.getCollateralList(params);
						request.setAttribute("jsonCollList", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
						PAGE = "/pages/underwriting/collateralTransaction.jsp";
					}

					
				}else if ("insertNewCollateral".equals(ACTION)){
					System.out.println("insert collateral ******************");
					System.out.println(request.getParameter("strAdded")+"qwerty");
					gipiCollateralService.addCollateralPar(request.getParameter("strAdded"), Integer.parseInt(request.getParameter("parId")));	
					gipiCollateralService.delCollateralPar(request.getParameter("strAdded"), Integer.parseInt(request.getParameter("parId")));
					gipiCollateralService.updateCollateralPar(request.getParameter("strAdded"), Integer.parseInt(request.getParameter("parId")));
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				}else if ("getCollDesc".equals(ACTION)){
					String[] params = {request.getParameter("collType")};
					JSONArray array = new JSONArray(lovHelper.getList(LOVHelper.COLLATERAL_DESC_LISTING,params));
					message = array.toString();
					PAGE = "/pages/genericMessage.jsp";
				}			
				
			/*}catch (SQLException e) {
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";*/
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
