package com.geniisys.quote.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.quote.entity.GIPIQuoteItem;
import com.geniisys.quote.service.GIPIQuoteItemService;
import com.geniisys.quote.service.GIPIQuotePicturesService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIPIQuoteItemController", urlPatterns={"/GIPIQuoteItemController"})
public class GIPIQuoteItemController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GIPIQuoteItemController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			log.info("Initializing :"+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIQuoteItemService gipiQuoteItemService = (GIPIQuoteItemService) APPLICATION_CONTEXT.getBean("gipiQuoteItemService");
			GIPIQuotePicturesService gipiQuotePicturesService = (GIPIQuotePicturesService) APPLICATION_CONTEXT.getBean("gipiQuotePicturesService2");
						
			if ("saveAllQuotationInformation".equals(ACTION)){
				gipiQuoteItemService.saveAllQuotationInformation(request, USER.getUserId());
				
				// delete attachments
				JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("delItemRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delItemRows")), USER.getUserId(), GIPIQuoteItem.class));
				List<GIPIQuoteItem> delItemRows = (List<GIPIQuoteItem>) params.get("delItemRows");
				
				if (delItemRows.size() > 0) {
					gipiQuotePicturesService.deleteItemAttachments2(delItemRows);
				}
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
			
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){ //added by steven 01/11/2013
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			/*log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);*/
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
