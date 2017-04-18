package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLClmAdjHistService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLClmAdjHistController", urlPatterns={"/GICLClmAdjHistController"})
public class GICLClmAdjHistController extends BaseController{

	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GICLClmAdjHistService giclClmAdjHistService = (GICLClmAdjHistService) APPLICATION_CONTEXT.getBean("giclClmAdjHistService");
			if ("showClmAdjHist".equals(ACTION)){
				giclClmAdjHistService.getClmAdjHistListGrid(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/claimBasicInformation/subPages/adjusterHist.jsp";
			}else if("showClmAdjHistSubList".equals(ACTION)){
				giclClmAdjHistService.getClmAdjHistListGrid2(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/claimBasicInformation/subPages/adjusterSubHist.jsp";
			}else if("showGICLS260ClmAdjusterHistory".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getClmAdjHistListGrid2");
				params.put("userId", USER.getUserId());
				params.put("claimId", request.getParameter("claimId"));
				params.put("adjCompanyCd", request.getParameter("adjCompanyCd"));
				params.put("privAdjCd", request.getParameter("privAdjCd"));
				params.put("pageSize", 5);
				
				JSONObject json = new JSONObject(TableGridUtil.getTableGrid(request, params));
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("adjCompanyCd", request.getParameter("adjCompanyCd"));
					request.setAttribute("adjCompanyName", request.getParameter("adjCompanyName"));
					request.setAttribute("privAdjCd", request.getParameter("privAdjCd"));
					request.setAttribute("privAdjName", request.getParameter("privAdjName"));
					request.setAttribute("jsonAdjusterHist", json);
					PAGE = "/pages/claims/inquiry/claimInformation/basicInformation/overlay/adjusterHistory.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		//}catch(ParseException e) {
		//	message = ExceptionHandler.handleException(e, USER);
		//	PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
