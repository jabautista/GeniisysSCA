package com.geniisys.claims.reports.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.jasperreports.engine.JRException;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="PrintPreliminaryLossAdviceController", urlPatterns="/PrintPreliminaryLossAdviceController")
public class PrintPreliminaryLossAdviceController extends BaseController{

	private Logger log = Logger.getLogger(PrintPreliminaryLossAdviceController.class);
	private static final long serialVersionUID = 1L;
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		ApplicationWideParameters reportParam = (ApplicationWideParameters) APPLICATION_CONTEXT.getBean("appWideParams");
		GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
		message = "SUCCESS";
		
		try{
			Map<String, Object> params = new HashMap<String, Object> ();
			String reportDir = null;
			
			if("poopulateGiclr028XOL".equals(ACTION)){
				String reportId = "GICLR028_XOL";
				String reportFont = reportParam.getDefaultReportFont();
				String reportVersion = reportsService.getReportVersion("GICLR028_XOL");
				String reportName = reportVersion == "" ? reportId : reportId+"_"+reportVersion;
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_CL");
				String filename = "PLA_XOL-"+request.getParameter("plaNo");
				
				log.info("CREATING REPORT : "+reportName);
				
				params.put("P_CLAIM_ID", "".equals(request.getParameter("claimId")) ? null :Integer.parseInt(request.getParameter("claimId")));
				params.put("P_GRP_SEQ_NO", "".equals(request.getParameter("grpSeqNo")) ? null :Integer.parseInt(request.getParameter("grpSeqNo")));
				params.put("P_CURRENCY_CD", "".equals(request.getParameter("currencyCd")) ? null :Integer.parseInt(request.getParameter("currencyCd"))); 
				params.put("P_PLA_ID", "".equals(request.getParameter("plaId")) ? null :Integer.parseInt(request.getParameter("plaId")));
				params.put("P_RI_CD", "".equals(request.getParameter("riCd")) ? null :Integer.parseInt(request.getParameter("riCd"))); //added by Nica 04.05.2013
				params.put("P_ITEM_NO", "".equals(request.getParameter("plaId")) ? null :Integer.parseInt(request.getParameter("itemNo")));
				params.put("P_PERIL_CD", "".equals(request.getParameter("plaId")) ? null :Integer.parseInt(request.getParameter("perilCd")));
				params.put("P_TSI_AMT", "".equals(request.getParameter("tsiAmt")) ? null :new BigDecimal(request.getParameter("tsiAmt"))); 
				params.put("P_LINE_CD", request.getParameter("lineCd"));
				params.put("P_PLA_TITLE", request.getParameter("plaTitle"));
				params.put("P_PLA_HEADER", request.getParameter("plaHeader"));
				params.put("P_PLA_FOOTER", request.getParameter("plaFooter"));				
				params.put("P_FONT_SW", reportFont);
				params.put("P_USER_NAME", USER.getUsername());
				params.put("MAIN_REPORT", reportName+".jasper");
				params.put("OUTPUT_REPORT_FILENAME", filename);
				params.put("reportName", reportName);
				log.info("GICLR028 PLA XOL parmeters : "+params);
				
			}else if("poopulateGiclr028".equals(ACTION)){
				String reportId = "GICLR028";
				String reportFont = reportParam.getDefaultReportFont();
				String reportVersion = reportsService.getReportVersion("GICLR028");
				String reportName = reportVersion == "" ? reportId : reportId+"_"+reportVersion;
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				reportDir = giisParameterService.getParamValueV2("CONFIG_DOC_PATH_CL");
				String filename = "PLA-"+request.getParameter("plaNo");
				
				log.info("CREATING REPORT : "+reportName);
				
				params.put("P_CLAIM_ID", "".equals(request.getParameter("claimId")) ? null :Integer.parseInt(request.getParameter("claimId")));				
				params.put("P_RI_CD", "".equals(request.getParameter("riCd")) ? null : Integer.parseInt(request.getParameter("riCd")));				
				params.put("P_CURRENCY_CD", request.getParameter("currencyCd"));				
				params.put("P_LINE_CD", request.getParameter("lineCd"));				
				params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));				
				params.put("P_ISS_CD", request.getParameter("issCd"));				
				params.put("P_ISSUE_YY", "".equals(request.getParameter("issueYy")) ? null : Integer.parseInt(request.getParameter("issueYy")));
				params.put("P_POL_SEQ_NO", "".equals(request.getParameter("polSeqNo")) ? null: Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("P_RENEW_NO", "".equals(request.getParameter("renewNo")) ? null : Integer.parseInt(request.getParameter("renewNo")));
				params.put("P_FROM", request.getParameter("polEffDate"));
				params.put("P_TO", request.getParameter("expiryDate"));				
				params.put("P_LOSS_CAT_CD", request.getParameter("lossCatCd"));
				params.put("P_SHARE_TYPE", request.getParameter("shareType"));
				params.put("P_LA_YY", "".equals(request.getParameter("laYy")) ? null : Integer.parseInt(request.getParameter("laYy")));
				params.put("P_PLA_SEQ_NO", "".equals(request.getParameter("plaSeqNo")) ? null :Integer.parseInt(request.getParameter("plaSeqNo")));
                params.put("P_PLA_ID", "".equals(request.getParameter("plaId")) ? null :Integer.parseInt(request.getParameter("plaId")));
				params.put("P_GRP_SEQ_NO", "".equals(request.getParameter("grpSeqNo")) ? null :Integer.parseInt(request.getParameter("grpSeqNo")));
                params.put("P_CLM_RES_HIST_ID", "".equals(request.getParameter("clmResHistId")) ? null :Integer.parseInt(request.getParameter("clmResHistId")));
                params.put("P_ITEM_NO", "".equals(request.getParameter("itemNo")) ? null : Integer.parseInt(request.getParameter("itemNo")));                
                params.put("P_PERIL_CD", "".equals(request.getParameter("perilCd")) ? null : Integer.parseInt(request.getParameter("perilCd")));
                params.put("P_RES_PLA_ID", "".equals(request.getParameter("resPlaId")) ? null :Integer.parseInt(request.getParameter("resPlaId")));
                params.put("P_GROUPED_ITEM_NO", "".equals(request.getParameter("groupedItemNo")) ? null : Integer.parseInt(request.getParameter("groupedItemNo")));                
            	params.put("P_PLA_TITLE", request.getParameter("plaTitle"));
            	params.put("P_PLA_HEADER", request.getParameter("plaHeader"));
            	params.put("P_PLA_FOOTER", request.getParameter("plaFooter"));
            	
				params.put("P_FONT_SW", reportFont);
                params.put("P_USER_NAME", USER.getUsername());
                params.put("MAIN_REPORT", reportName+".jasper");
                params.put("OUTPUT_REPORT_FILENAME", filename);
    			params.put("reportName", reportName);
    			log.info("GICLR028 PLA parmeters : "+params);
				
			}
			
			this.doPrintReport(request, response, params, reportDir);
			
		} catch (JRException e){
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (SQLException e){
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (IOException e) {	
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}

}
