/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gipi.pack.controllers
	File Name: GIPIWPackLineSublineController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 10, 2011
	Description: 
*/


package com.geniisys.gipi.pack.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.gipi.pack.entity.GIPIWPackLineSubline;
import com.geniisys.gipi.pack.service.GIPIWPackLineSublineService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIWPackLineSublineController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2847482465715500978L;
	private static Logger log = Logger.getLogger(GIPIWPackLineSublineController.class);
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPIWPackLineSublineService gipiwPackLineSublineService = (GIPIWPackLineSublineService) APPLICATION_CONTEXT.getBean("gipiwPackLineSublineService");
		System.out.println("ACTION IS "+ACTION);
		try{ 
			if("showLineSublineCoverages".equals(ACTION)){
				System.out.println(request.getParameter("lineCd"));
				String lineCd = request.getParameter("lineCd");
				int packParId = Integer.parseInt(request.getParameter("packParId"));
				System.out.println("packpar id: "+request.getParameter("packParId"));
				// apollo 07.27.2015 changed replaceQuotesInList to escapeHTMLInList4 SR#19757
				/*List<GIPIWPackLineSubline> lineSubline = (List<GIPIWPackLineSubline>) StringFormatter.replaceQuotesInList(gipiwPackLineSublineService.getGIPIWPackLineSublineList(lineCd));
				List<GIPIWPackLineSubline> lineSublineItems = (List<GIPIWPackLineSubline>) StringFormatter.replaceQuotesInList(gipiwPackLineSublineService.getGIPIWPackLineSublineListByPParId(packParId,lineCd));*/
				List<GIPIWPackLineSubline> lineSubline = (List<GIPIWPackLineSubline>) StringFormatter.escapeHTMLInList4(gipiwPackLineSublineService.getGIPIWPackLineSublineList(lineCd));
				List<GIPIWPackLineSubline> lineSublineItems = (List<GIPIWPackLineSubline>) StringFormatter.escapeHTMLInList4(gipiwPackLineSublineService.getGIPIWPackLineSublineListByPParId(packParId,lineCd));
				for(GIPIWPackLineSubline linesub: lineSubline){
					System.out.println(linesub.getPackLineCd());
				}
				request.setAttribute("objLineSublineItems", new JSONArray(lineSublineItems));
				request.setAttribute("objLineSubline", new JSONArray(lineSubline));
				PAGE = "/pages/underwriting/packPar/packLineSubline/packLineSublineCoverages.jsp";
			}else if("showEndtLineSublineCoverages".equals(ACTION)){ 
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				String lineCd = request.getParameter("lineCd");
				int packParId = Integer.parseInt(request.getParameter("packParId"));
				System.out.println("packpar id: "+request.getParameter("packParId"));
				List<GIPIWPackLineSubline> lineSubline = (List<GIPIWPackLineSubline>) StringFormatter.replaceQuotesInList(gipiwPackLineSublineService.getGIPIWPackEndtLineSublineList(params));
				//List<GIPIWPackLineSubline> lineSublineItems = (List<GIPIWPackLineSubline>) StringFormatter.replaceQuotesInList(gipiwPackLineSublineService.getGIPIWPackLineSublineListByPParId(packParId,lineCd)); // replace by: Nica 10.25.2011
				List<GIPIWPackLineSubline> lineSublineItems = (List<GIPIWPackLineSubline>) StringFormatter.replaceQuotesInList(gipiwPackLineSublineService.getGIPIWPackLineSublineList2(packParId,lineCd));
				for(GIPIWPackLineSubline linesub: lineSubline){
					System.out.println(linesub.getPackLineCd());
				}
				request.setAttribute("objLineSublineItems", new JSONArray(lineSublineItems));
				request.setAttribute("objLineSubline", new JSONArray(lineSubline));
				request.setAttribute("isPack", "Y");
				request.setAttribute("parType", "E");
				PAGE = "/pages/underwriting/packPar/packLineSubline/packEndtLineSublineCoverages.jsp";
			}else if("showPackParCreationLineSubline".equals(ACTION)){
				System.out.println("LINE CD:"+request.getParameter("lineCd"));
				System.out.println("PACK PAR ID:"+request.getParameter("packParId"));
				String lineCd = request.getParameter("lineCd");
				int packParId = Integer.parseInt(request.getParameter("packParId"));
				List<GIPIWPackLineSubline> lineSubline = (List<GIPIWPackLineSubline>) StringFormatter.replaceQuotesInList(gipiwPackLineSublineService.getGIPIWPackLineSublineList(lineCd));
				List<GIPIWPackLineSubline> lineSublineItems = (List<GIPIWPackLineSubline>) StringFormatter.replaceQuotesInList(gipiwPackLineSublineService.getGIPIWPackLineSublineListByPParId(packParId,lineCd));
				request.setAttribute("packParId", packParId);
				request.setAttribute("objLineSublineItems", new JSONArray(lineSublineItems));
				request.setAttribute("objLineSubline", new JSONArray(lineSubline));
				PAGE = "/pages/underwriting/packPar/subPages/packParCreationLineSubline.jsp";
			}else if("saveLineSubline".equals(ACTION)){
				System.out.println(request.getParameter("packParId"));
				System.out.println(request.getParameter("parameter"));
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("packParId", request.getParameter("packParId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("appUser", USER.getUserId());
				params.put("parameter", request.getParameter("parameter"));
				gipiwPackLineSublineService.saveGIPIWPackLineSubline(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveEndtPackLineSubline".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("packParId", request.getParameter("packParId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("appUser", USER.getUserId());
				params.put("parameter", request.getParameter("parameter"));
				gipiwPackLineSublineService.saveEndtGIPIWPackLineSubline(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkIfExistGIPIWPackItemPeril".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("packLineCd", request.getParameter("packLineCd") );
				params.put("packSublineCd", request.getParameter("packSublineCd") );
				params.put("items", null);
				params.put("perils", null);
				gipiwPackLineSublineService.checkIfExistGIPIWPackItemPeril(params);
				message = params.get("items")+","+params.get("perils");
				PAGE = "/pages/genericMessage.jsp";
			}else if("showPackParCreationLineSubline".equals(ACTION)){
				System.out.println("LINE CD:"+request.getParameter("lineCd"));
				System.out.println("PACK PAR ID:"+request.getParameter("packParId"));
				String lineCd = request.getParameter("lineCd");
				int packParId = Integer.parseInt(request.getParameter("packParId"));
				List<GIPIWPackLineSubline> lineSubline = (List<GIPIWPackLineSubline>) StringFormatter.replaceQuotesInList(gipiwPackLineSublineService.getGIPIWPackLineSublineList(lineCd));
				List<GIPIWPackLineSubline> lineSublineItems = (List<GIPIWPackLineSubline>) StringFormatter.replaceQuotesInList(gipiwPackLineSublineService.getGIPIWPackLineSublineListByPParId(packParId,lineCd));
				request.setAttribute("packParId", packParId);
				request.setAttribute("objLineSublineItems", new JSONArray(lineSublineItems));
				request.setAttribute("objLineSubline", new JSONArray(lineSubline));
				PAGE = "/pages/underwriting/reInsurance/enterPackInitialAcceptance/subpages/riPackParCreationLineSubline.jsp";
			}
		}catch(SQLException e){
			message = "SQL exception occured...<br />"+e.getCause();
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}catch(NullPointerException e){
			message = "Null pointer exception occured...<br />"+e.getCause();
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}catch (Exception e) {
			message = "Unhandled exception occured...<br />"+e.getCause();
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} finally {
			request.setAttribute("message", message);
			doDispatch(request, response, PAGE);
		}	
	}

}
