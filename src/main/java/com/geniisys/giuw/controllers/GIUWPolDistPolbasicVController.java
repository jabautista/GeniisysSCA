package com.geniisys.giuw.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
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
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.ApplicationContextReader;

public class GIUWPolDistPolbasicVController extends BaseController{

	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIUWPolDistPolbasicVController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		
		try{
			log.info("Initializing: " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			if("getGIUWPolDistPolbasicVList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("moduleId", "GIUWS015");
				params.put("ACTION", ACTION);
				params.put("userId", USER.getUserId());
			    Map<String, Object> giisCurrencyListTableGrid = TableGridUtil.getTableGrid(request, params);
			    JSONObject json = new JSONObject(giisCurrencyListTableGrid);
			    
			    if("1".equals(request.getParameter("refresh"))){
			    	message = json.toString();
			    	PAGE = "/pages/genericMessage.jsp";
			    }else{
			    	request.setAttribute("giuwPolDistPolbasicTableGrid", json);
			    	PAGE = "/pages/underwriting/distribution/batchDistribution/batchDistributionMain.jsp";
			    }
			}else if("showBatchDistParameterPage".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				String[] args = {"GIUWS015", USER.getUserId()};
				request.setAttribute("lineListing", lovHelper.getList((LOVHelper.LINE_LISTING), args));
				request.setAttribute("sublineListing", lovHelper.getList(LOVHelper.ALL_GIIS_SUBLINE_LIST));
				request.setAttribute("issCdListing", lovHelper.getList(LOVHelper.BRANCH_SOURCE_LISTING));
				PAGE = "/pages/underwriting/distribution/batchDistribution/batchDistParameters.jsp";
			}
		}catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
