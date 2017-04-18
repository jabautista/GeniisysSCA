package com.geniisys.giis.controllers;

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
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.service.GIISPerilMaintenanceService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISSPerilMaintenanceController", urlPatterns="/GIISSPerilMaintenanceController")
public class GIISSPerilMaintenanceController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5294649608120690217L;
	
	private static Logger log = Logger.getLogger(GIISSPerilMaintenanceController.class);

	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		GIISPerilMaintenanceService perilService = (GIISPerilMaintenanceService) appContext.getBean("giisPerilMaintenanceService");
		try {
			if(ACTION.equals("getPerilMaintenanceDisplay")){ 
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				String modId = "GIISS003";
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				params.put("userId", USER.getUserId());
				Map<String, Object> perilMaintenance = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(perilMaintenance);
				if("1".equals(request.getParameter("ajax"))){ 
					request.setAttribute("perilMaintenance", json);
					System.out.println(json.toString());
					PAGE="/pages/underwriting/fileMaintenance/general/peril/perilMaintenance/perilMaintenance.jsp";
				}else{ 
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}  else if ("getGIISWarrClauses".equals(ACTION)) {
				String lineCd = request.getParameter("lineCd");
				String perilCd = request.getParameter("perilCd");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("lineCd", lineCd);
				params.put("perilCd", perilCd);
				Map<String, Object> giisWarrClauses = TableGridUtil.getTableGrid(request, params);
				log.info("test: " + giisWarrClauses);
				JSONObject json = new JSONObject(giisWarrClauses);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("giisWarrClauses", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/peril/perilMaintenance/subpages/warrantiesAndClauses.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("getGIISTariff".equals(ACTION)) {
				String lineCd = request.getParameter("lineCd");
				String perilCd = request.getParameter("perilCd");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("lineCd", lineCd);
				params.put("perilCd", perilCd);
				Map<String, Object> giisTariff = TableGridUtil.getTableGrid(request, params);
				log.info("test: " + giisTariff);
				JSONObject json = new JSONObject(giisTariff);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("giisTariff", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/peril/perilMaintenance/subpages/tariffCodes.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("getGIISPerilGIISS003".equals(ACTION)) {
				message = perilService.getPerilList(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("validateDeletePeril")){
				message = perilService.validateDeletePeril(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("validateAddPeril")){ 
				message = perilService.perilIsExist(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("validatePerilSname")){ 
				message = perilService.validatePerilSname(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("validatePerilName")){ 
				message = perilService.validatePerilName(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("savePeril")){ 
				message = perilService.savePeril(request,  USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("validateDeleteTariff")){
				message = perilService.validateDeleteTariff(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("saveTariff")){ 
				message = perilService.saveTariff(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("saveWarrCla")){ 
				message = perilService.saveWarrCla(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("validateDefaultTsi")){ 
				message = perilService.validateDefaultTsi(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("getSublineCdName")){ 
				message = perilService.getSublineCdName(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("getBasicPerilCdName")){ 
				message = perilService.getBasicPerilCdName(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("getZoneNameFiName")){ 
				message = perilService.getZoneNameFiName(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("getZoneNameMcName")){ 
				message = perilService.getZoneNameMcName(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("checkAvailableWarrcla")){ 
				message = perilService.checkAvailableWarrcla(request);
				PAGE = "/pages/genericMessage.jsp";
		    } else if(ACTION.equals("validateSublineName")){ 
				message = perilService.validateSublineName(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("validateFiList")){ 
				message = perilService.validateFiList(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("validateMcList")){ 
				message = perilService.validateMcList(request);
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
