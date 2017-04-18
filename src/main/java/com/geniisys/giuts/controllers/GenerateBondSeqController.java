package com.geniisys.giuts.controllers;

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

import com.geniisys.common.entity.GIISLine;
import com.geniisys.common.entity.GIISSubline;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISBondSeqService;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISSublineFacadeService;
import com.geniisys.common.service.impl.GIISBondSeqServiceImpl;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GenerateBondSeqController", urlPatterns="/GenerateBondSeqController")
public class GenerateBondSeqController extends BaseController {

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GenerateBondSeqController.class);
	private JSONObject res = null;
	private GIISLine line = null;
	private GIISSubline subline = null;
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException{
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISLineFacadeService lineServices = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
		GIISSublineFacadeService sublineServices = (GIISSublineFacadeService) APPLICATION_CONTEXT.getBean("giisSublineFacadeService");
		try {
			res = new JSONObject();
			if ("showGenerateBondSeqNoPage".equals(ACTION)){
				PAGE = "/pages/underwriting/utilities/generateNumber/generateBondSequenceNumberMain.jsp";
			
			} else if ("validateLineCd".equals(ACTION)){
				log.info("Validating User input: ");
				log.info("lineCd: " + request.getParameter("lineCd").toUpperCase());
				if (isValidLineCd(lineServices, request)){
					log.info("lineCd is valid");
				} else {
					log.info("lineCd is invalid");
				}
				message = res.toString();
				PAGE = "/pages/genericMessage.jsp";
			
			} else if ("validateSublineCd".equals(ACTION)){
				log.info("Validating User input: ");
				log.info("lineCd: " + request.getParameter("lineCd").toUpperCase());
				log.info("sublineCd: " + request.getParameter("sublineCd").toUpperCase());
				
				if (isValidLineCd(lineServices, request)){
					log.info("lineCd is valid");
					if (isValidSublineCd(sublineServices, request)){
						log.info("sublineCd is valid");
					} else {
						log.info("sublineCd is invalid");
					}
				} else {
					log.info("lineCd is invalid");
				}
				
				message = res.toString();
				PAGE = "/pages/genericMessage.jsp";
			
			} else if ("generateBondSequence".equals(ACTION)){
				log.info("Validating User input: ");
				log.info("lineCd: " + request.getParameter("lineCd").toUpperCase());
				log.info("sublineCd: " + request.getParameter("sublineCd").toUpperCase());
				log.info("noOfSequence: " + request.getParameter("noOfSequence"));

				if (isValidLineCd(lineServices, request)){
					log.info("lineCd is valid");
					if (isValidSublineCd(sublineServices, request)){
						log.info("sublineCd is valid");
						generateBondSequence(request, (GIISBondSeqServiceImpl) APPLICATION_CONTEXT.getBean("giisBondSeqService"), USER);
					} else {
						log.info("sublineCd is invalid");
					}
				} else {
					log.info("lineCd is invalid");
				}
				message = res.toString();
				PAGE = "/pages/genericMessage.jsp";
			
			} else if ("showBondSeqHistoryOverlay".equals(ACTION)){
				log.info("Getting Bond Sequence History for table grid...");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getBondSeqHistList");
				params.put("moduleId", request.getParameter("moduleId") == null ? "GIUTS036" : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				this.res = new JSONObject(TableGridUtil.getTableGrid(request, params));
				if ("1".equals(request.getParameter("refresh"))){
					message = this.res.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonBondSeqHistGrid", this.res);
					PAGE = "/pages/underwriting/utilities/generateNumber/subPages/bondSeqHistOverlay.jsp";					
				}
			}
		} catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
	private boolean isValidLineCd(GIISLineFacadeService lineServices, HttpServletRequest request) throws SQLException, JSONException{
		this.line = lineServices.getGiisLineGiuts036(request.getParameter("lineCd").toUpperCase());
		if (line != null){
			this.res.put("result", "VALID");
			this.res.put("giisLine", new JSONObject(line));
			return true;
		} else {
			this.res.put("result", "INVALID_LINECD");
			return false;
		}
	}
	
	private boolean isValidSublineCd(GIISSublineFacadeService sublineServices, HttpServletRequest request) throws SQLException, JSONException{
		this.subline = sublineServices.getSublineDetails2(this.line.getLineCd(), request.getParameter("sublineCd").toUpperCase());
		if (this.subline.getSublineCd() != null){
			this.res.put("result", "VALID");
			this.res.put("giisSubline", new JSONObject(subline));
			return true;
		} else {
			this.res.put("result", "INVALID_SUBLINE");
			return false;
		}
	}
	
	private void generateBondSequence(HttpServletRequest request,
			GIISBondSeqService bondSeqService, GIISUser USER) throws SQLException, JSONException{
		Integer noOfSequence = null;
		try {
			noOfSequence = Integer.parseInt(request.getParameter("noOfSequence"));
			if (noOfSequence < 1){
				throw new NumberFormatException(); // treat 0 as invalid number input
			} else {
				log.info("noOfSequence is valid");
			}
			Integer g = bondSeqService.generateBondSeq(request, noOfSequence, USER);
			res.put("result", "VALID");
			if (noOfSequence == 1){
				res.put("generatedBondSeq", g);
			}
		} catch (NumberFormatException e){
			log.info("noOfSequence is invalid");
			this.res.put("result", "INVALID_NOOFSEQUENCE");
		} catch (SQLException e){
			if (e.getErrorCode() == 1438){ // ORA-1438
				this.res.put("result", "ERROR");
				this.res.put("errorMessage", "Maximum length of sequence number reached. Generation failed.");
				log.info("ERROR: " + this.res.get("errorMessage"));
				message = this.res.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else {
				throw e;
			}
		}
	}
}
