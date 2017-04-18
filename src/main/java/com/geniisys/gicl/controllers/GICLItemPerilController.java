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
import com.geniisys.gicl.service.GICLItemPerilService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GICLItemPerilController", urlPatterns="/GICLItemPerilController")
public class GICLItemPerilController extends BaseController{

	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GICLItemPerilController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			log.info("Initializing : "+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLItemPerilService giclItemPerilService = (GICLItemPerilService) APPLICATION_CONTEXT.getBean("giclItemPerilService");
			if("getItemPerilGrid".equals(ACTION)){
				log.info("Getting item peril info...");
				giclItemPerilService.getGiclItemPerilGrid(request, USER);
				PAGE = ("1".equals(request.getParameter("ajax")) ? "/pages/claims/claimItemInfo/peril/subPages/perilInfoAddtl.jsp" : ("2".equals(request.getParameter("ajax")) ? "/pages/claims/claimItemInfo/peril/subPages/perilStatusAddtl.jsp" :"/pages/genericObject.jsp"));
			}else if("getItemPerilGrid2".equals(ACTION)){
				log.info("Getting item peril info...");
				//giclItemPerilService.getGiclItemPerilGrid2(request, USER);
				//PAGE = "/pages/claims/claimReportsPrintDocs/subPages/claimInfoTableListing.jsp";
				
				// bonok :: 04.14.2014 :: fix for Item Information tablegrid sort
				JSONObject json = giclItemPerilService.getGiclItemPerilGrid2(request, USER);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("giclItemPeril2", json);
					PAGE = "/pages/claims/claimReportsPrintDocs/subPages/claimInfoTableListing.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("getItemPerilGrid3".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclItemPerilGrid3");
				params.put("claimId", request.getParameter("claimId"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("giclItemPerilList", json);
					PAGE = "/pages/claims/lossExpenseHistory/subPages/giclItemPerilList.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("checkAggPeril".equals(ACTION)){
				log.info("Validating peril...");
				message = giclItemPerilService.checkAggPeril(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkPerilStatus".equals(ACTION)) {
				log.info("checking peril status...");
				message = giclItemPerilService.checkPerilStatus(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGICLS260ItemPeril".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclItemPerilGrid");
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("lineCd", request.getParameter("lineCd"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("giclItemPerilList", json);
					PAGE = "/pages/claims/inquiry/claimInformation/itemInformation/perilInfoListing.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("getGICLS260PerilStatus".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclItemPerilGrid");
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("lineCd", request.getParameter("lineCd"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonPerilStatusList", json);
					PAGE = "/pages/claims/inquiry/claimInformation/itemInformation/overlay/perilStatusListing.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		//} catch (ParseException e) {
		//	message = ExceptionHandler.handleException(e, USER);
		//	PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			System.out.println("ACTION : " + ACTION);
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}