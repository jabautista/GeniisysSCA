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

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLExpPayeesService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GICLClmClaimantController", urlPatterns="/GICLClmClaimantController")
public class GICLClmClaimantController extends BaseController{
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GICLClmClaimantController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		try{
			if("showGICLS260LossPayees".equals(ACTION)){
				GICLExpPayeesService giclExpPayeesService = (GICLExpPayeesService) APPLICATION_CONTEXT.getBean("giclExpPayeesService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGICLClmClaimantList");
				params.put("claimId", request.getParameter("claimId"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				
				if("1".equals(request.getParameter("ajax"))){
					log.info("Getting claim payees: "+params);
					request.setAttribute("expPayeesExist", giclExpPayeesService.checkGiclExpPayeesExist(params));
					request.setAttribute("jsonGiclClmClaimant", json);
					PAGE = "/pages/claims/inquiry/claimInformation/payees/lossPayees.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
		}catch(JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
		
}

