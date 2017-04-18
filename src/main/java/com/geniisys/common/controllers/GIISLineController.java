package com.geniisys.common.controllers;

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
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIISLineController", urlPatterns="/GIISLineController")
public class GIISLineController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 359746053128621099L;
	
	private static Logger log = Logger.getLogger(GIISLineController.class);
	
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("");
		
		try {
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
			GIISParameterFacadeService giisParameterFacadeService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
			if("getLineMaintenance".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				String modId = "GIISS001";
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				Map<String, Object> lineMaintenance = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(lineMaintenance);
				//request.setAttribute("recapsCdList", giisLineService.getAllRecapsCd());
				request.setAttribute("allowSpecialDist", giisParameterFacadeService.getParamValueV2("ALLOW_SPECIAL_DIST"));
				request.setAttribute("printOtherCert", giisParameterFacadeService.getParamValueV2("PRINT_OTHER_CERTIFICATE"));
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonGIISLine", json);
					PAGE="/pages/common/line/lineMaintenance.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("getAllLine".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				String modId = "GIISS001";
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				Map<String, Object> lineMaintenance = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(lineMaintenance);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			//added by steven 12.12.2013
			}else if ("valDeleteRec".equals(ACTION)){
				giisLineService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisLineService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss001".equals(ACTION)) {
				giisLineService.saveGiiss001(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("valMenuLineCd".equals(ACTION)){
				giisLineService.valMenuLineCd(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				//end steven 12.12.2013
			} else if("saveLine".equals(ACTION)){
				message = giisLineService.saveLine(request,  USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("valDeleteLine".equals(ACTION)){
				System.out.println(request.getParameter("validating line to delete"));
				message = giisLineService.validateDeleteLine(request.getParameter("parameters"));
				System.out.println("done delete validation");
				PAGE = "/pages/genericMessage.jsp";
			}else if("valAddLine".equals(ACTION)){
				System.out.println("validating line to add");
				message = giisLineService.validateAddLine(request.getParameter("parameters"));
				System.out.println("done Add validation");
				PAGE = "/pages/genericMessage.jsp";
			}else if("valAcctLineCd".equals(ACTION)){
				System.out.println("validating acct line cd");
				message = giisLineService.validateAcctLineCd(request.getParameter("parameters"));
				System.out.println("end validating acct line cd");
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateLineCd2".equals(ACTION)) {
				request.setAttribute("object", giisLineService.validateLineCd2(request));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateGIACS102LineCd".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giisLineService.validateGIACS102LineCd(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if("getGIISLineName".equals(ACTION)){
				message = giisLineService.getGiisLineName2(request.getParameter("lineCd"));
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
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
