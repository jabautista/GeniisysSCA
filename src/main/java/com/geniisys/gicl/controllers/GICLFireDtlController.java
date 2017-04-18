package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
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
import com.geniisys.gicl.service.GICLFireDtlService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLFireDtlController", urlPatterns={"/GICLFireDtlController"})
public class GICLFireDtlController extends BaseController{

	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GICLFireDtlController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			log.info("Initializing :"+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLFireDtlService fireService = (GICLFireDtlService) APPLICATION_CONTEXT.getBean("giclFireDtlService");
			if ("getFireDtl".equals(ACTION)){
				log.info("Getting fire item information...");
				fireService.getGiclFireDtlGrid(request, USER, APPLICATION_CONTEXT);
				PAGE = ("1".equals(request.getParameter("ajax")) ? "/pages/claims/claimItemInfo/fire/fireItemInfo.jsp" : "/pages/genericObject.jsp");
			}else if("validateClmItemNo".equals(ACTION)){
				log.info("Validating item no. ... ");
				message = fireService.validateClmItemNo(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveClmItemFire".equals(ACTION)){
				message = fireService.saveClmItemFire(request, USER);
				PAGE= "/pages/genericMessage.jsp";
			}else if("getGiclFireDtlExist".equals(ACTION)){
				message = fireService.getGiclFireDtlExist(request.getParameter("claimId"));
				PAGE= "/pages/genericMessage.jsp";
			}else if("showGICLS260FireItemInfo".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclFireDtlGrid");
				params.put("pageSize", 5);
				params.put("userId", USER.getUserId());
				params.put("claimId", request.getParameter("claimId"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("url", request.getParameter("url"));
					request.setAttribute("jsonClaimItem", json);
					PAGE = "/pages/claims/inquiry/claimInformation/itemInformation/fire/fireItemMain.jsp";
				}else{
					message = json;
					PAGE = "/pages/genericMessage.jsp";
				}
			}
		} catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

	
}
