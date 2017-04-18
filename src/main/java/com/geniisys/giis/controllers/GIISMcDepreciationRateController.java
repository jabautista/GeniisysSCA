package com.geniisys.giis.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.service.GIISMcDepreciationRateService;
import com.seer.framework.util.ApplicationContextReader;

import common.Logger;

@WebServlet(name="GIISMcDepreciationRateController", urlPatterns={"/GIISMcDepreciationRateController"})
public class GIISMcDepreciationRateController extends BaseController {

	private static final long serialVersionUID = -4444130444204953615L;
	private static Logger log = Logger.getLogger(GIISMcDepreciationRateController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
			log.info("do processing");
		try{
			log.info("Initializing : "+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISMcDepreciationRateService giisMcDepreciationRateService = (GIISMcDepreciationRateService) APPLICATION_CONTEXT.getBean("giisMcDepreciationRateService");					
			LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
			
			if("showSourceMcDepreciationRateMaintenance".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				String modId = "GIISS224";
				params.put("ACTION", "getGIISS224SourceList");				
				params.put("pageSize", 10);
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				
				String[] params2 = {"GIISS224", USER.getUserId()};
				request.setAttribute("modelYearListing", lovHelper.getList(LOVHelper.MODEL_YEAR_LISTING,params2));
				
				Map<String, Object> mcDepRateListing = TableGridUtil.getTableGrid(request,params);
				JSONObject json = new JSONObject(mcDepRateListing);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("mcDepRateListing", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/mcDepreciationRates/mcDepreciationRateMain.jsp";					
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("saveMcDr".equals(ACTION)) {
				message = giisMcDepreciationRateService.saveMcDr(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateAddMcDepRate".equals(ACTION)) {
				log.info("Validating MC Depreciation Rate Entry...");
				message = giisMcDepreciationRateService.validateAddMcDepRate(request).toString();
				PAGE = "/pages/genericMessage.jsp";	
			}else if ("validateMcPerilRec".equals(ACTION)) {
				log.info("Validating MC Depreciation Peril Entry...");
				message = giisMcDepreciationRateService.validateMcPerilRec(request).toString();
				PAGE = "/pages/genericMessage.jsp";			
			}else if ("deleteMcPerilRec".equals(ACTION)) {
				log.info("Deleting MC Depreciation Peril Entry...");
				message = giisMcDepreciationRateService.deleteMcPerilRec(request).toString();
				PAGE = "/pages/genericMessage.jsp";							
			}else if ("getGIISMcDrPeril".equals(ACTION)) {
				String id = request.getParameter("id");
				String lineCd = request.getParameter("lineCd");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("id", id);
				params.put("lineCd", lineCd);
				Map<String, Object> giisMcDrPeril = TableGridUtil.getTableGrid(request, params);
				log.info("test: " + giisMcDrPeril);
				JSONObject json = new JSONObject(giisMcDrPeril);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("giisMcDrPeril", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/mcDepreciationRates/subPages/mcDepRatePeril.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if(ACTION.equals("savePerilDepRate")){ 
				message = giisMcDepreciationRateService.savePerilDepRate(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
