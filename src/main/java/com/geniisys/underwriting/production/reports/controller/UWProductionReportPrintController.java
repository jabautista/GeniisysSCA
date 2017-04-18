package com.geniisys.underwriting.production.reports.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.underwriting.reinsurance.reports.controller.ReinsuranceAcceptanceController;

@WebServlet(name="UWProductionReportPrintController", urlPatterns="/UWProductionReportPrintController")
public class UWProductionReportPrintController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(ReinsuranceAcceptanceController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			Map<String, Object> params = new HashMap<String, Object> ();
			String reportsLocation = "/com/geniisys/underwriting/production/reports/";
			String reportDir = getServletContext().getRealPath("WEB-INF/classes/"+reportsLocation+"/")+"/";
			String reportId = request.getParameter("reportId");
			String filename = reportId;
			SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
			SimpleDateFormat sdf2 = new SimpleDateFormat("dd-MMM-yyyy");
			
			//common params
			params.put("packageName", "CSV_UNDRWRTNG");
			params.put("csvAction", ACTION);
			params.put("P_ISS_PARAM", request.getParameter("issParam"));
			params.put("P_SCOPE", request.getParameter("scope"));				
			params.put("P_LINE_CD", request.getParameter("lineCd"));
			params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
			params.put("P_ISS_CD", request.getParameter("issCd"));
			params.put("P_PARAM_DATE", request.getParameter("paramDate")); //benjo 09.28.2015 UW-SPECS-2015-057
			params.put("P_TAB", request.getParameter("tabNumber")); //benjo 06.29.2015 GENQA-AFPGEN-SR-4616
			
			if("printGIPIR923".equals(ACTION)){ //apollo cruz 06.23.2015 - modified parameters for csv printing				 
				/*params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("functionName", "GET_GIPIR923");*/
				params.put("createCSVFromString", "Y");
				params.put("csvAction", "printGIPIR923CSV");
				params.put("P_REINSTATED", request.getParameter("reinstated")); //apollo cruz 06.16.2015				
			}else if("printGIPIR924".equals(ACTION)){
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope").replaceAll(" ", "")));	// change from string to integer shan 02.01.2013
				params.put("functionName", "CSV_GIPIR924");
				params.put("createCSVFromString", "Y");
				params.put("csvAction", "printGIPIR924CSV");
				params.put("P_REINSTATED", request.getParameter("reinstated")); //apollo cruz 07.03.2015
			}else if("printGIPIR923J".equals(ACTION)){
				params.put("functionName", "CSV_GIPIR923J");
			}else if("printGIPIR923E".equals(ACTION)){
				params.put("functionName", "CSV_GIPIR923E");
			}else if("printGIPIR923D".equals(ACTION)){
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				params.put("functionName", "CSV_GIPIR923D");
			}else if("printGIPIR923F".equals(ACTION)){
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				params.put("functionName", "CSV_GIPIR923F");
			}else if("printGIPIR923C".equals(ACTION)){
				//Modified by benjo 06.29.2015 GENQA-AFPGEN-SR-4616
				/*params.put("p_iss_param", Integer.parseInt(request.getParameter("issParam")));
				params.put("p_scope", Integer.parseInt(request.getParameter("scope")));
			    params.put("p_iss_cd", request.getParameter("issCd"));
				params.put("p_line_cd", request.getParameter("lineCd"));
				params.put("p_subline_cd", request.getParameter("sublineCd"));
				params.put("functionName", "CSV_GIPIR923C");*/
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				//params.put("functionName", "GET_GIPIR928C");
				//params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("createCSVFromString", "Y");
				params.put("csvAction", ACTION + "CSV");
				params.put("P_REINSTATED", request.getParameter("reinstated")); // jhing 08.25.2015 
				//params.put("csvVersion", "dynamicSQL");
				//End 06.29.2015
			}else if("printGIPIR928A".equals(ACTION)){
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR928A");
				params.put("functionName", "GET_GIPIR928A");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR928B".equals(ACTION)){
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR928B");
				params.put("functionName", "GET_GIPIR928B");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR928C".equals(ACTION)){
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR928C");
				params.put("functionName", "GET_GIPIR928C");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR928D".equals(ACTION)){
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR928D");
				params.put("functionName", "GET_GIPIR928D");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR923A".equals(ACTION) || "printGIPIR924A".equals(ACTION)){
				params.put("P_ASSD_NO", request.getParameter("assdNo"));
				params.put("P_INTM_NO", request.getParameter("intmNo"));
				params.put("P_ISS_PARAM", request.getParameter("issParam"));
				params.put("P_SCOPE", request.getParameter("scope"));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				if("printGIPIR923A".equals(ACTION))
					//params.put("functionName", "CSV_GIPIR923A");
					params.put("functionName", "GET_GIPIR923A");
				else
					//params.put("functionName", "CSV_GIPIR924A");
				    params.put("functionName", "GET_GIPIR924A");
				//End 06.16.2015
			}else if("printGIPIR924B".equals(ACTION)){
				params.put("P_ASSD_NO", request.getParameter("assdNo"));
				params.put("P_INTM_NO", request.getParameter("intmNo"));
				params.put("P_INTM_TYPE", request.getParameter("intmType"));
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				params.put("P_SCOPE", request.getParameter("scope"));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR924B");
				params.put("functionName", "GET_GIPIR924B");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR924C".equals(ACTION)){
				params.put("p_direct", Integer.parseInt(request.getParameter("direct")));
				params.put("p_ri", Integer.parseInt(request.getParameter("ri")));
				params.put("p_iss_param", Integer.parseInt(request.getParameter("issParam")));
				params.put("p_line_cd", request.getParameter("lineCd"));
				params.put("p_iss_cd", request.getParameter("issCd"));
				params.put("P_USER_ID", USER.getUserId()); //marco - 11.18.2013
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR924C");
				params.put("functionName", "GET_GIPIR924C");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR924D".equals(ACTION)){
				params.put("P_DIRECT", request.getParameter("direct"));
				params.put("P_RI", request.getParameter("ri"));
				params.put("P_ISS_PARAM", request.getParameter("issParam"));
				params.put("P_USER_ID", USER.getUserId()); //robert 01.02.2014
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR924D");
				params.put("functionName", "GET_GIPIR924D");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR924F".equals(ACTION)){
				params.put("P_ISS_PARAM", request.getParameter("issParam"));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR924F");
				params.put("functionName", "GET_GIPIR924F");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR924J".equals(ACTION)){ //added by steven 1/17/2013
				params.put("P_ISS_PARAM", request.getParameter("issParam"));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
				params.put("P_LINE_CD", request.getParameter("lineCd"));
				params.put("P_ISS_CD", request.getParameter("issCd"));
				params.put("P_USER_ID", USER.getUserId());
				//added by clperello | 06.10.2014
				params.put("functionName", "csv_gipir924j");
			}else if("printGIPIR924E".equals(ACTION)){
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR924E");
				params.put("functionName", "GET_GIPIR924E");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR928E".equals(ACTION)){
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR928E");
				params.put("functionName", "GET_GIPIR928E");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR923B".equals(ACTION)){
				params.put("P_ASSD_NO", request.getParameter("assdNo"));
				params.put("P_INTM_NO", request.getParameter("intmNo"));
				params.put("P_INTM_TYPE", request.getParameter("intmType")); //benjo 11.26.2015 AFPGEN-SR-21048
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				params.put("P_SCOPE", request.getParameter("scope"));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR923B");
				params.put("functionName", "GET_GIPIR923B");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR946".equals(ACTION)){
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR946");
				params.put("functionName", "GET_GIPIR946");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR946B".equals(ACTION)){
				params.put("P_ISS_PARAM", request.getParameter("issParam"));
				params.put("P_SCOPE", request.getParameter("scope"));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR946B");
				params.put("functionName", "GET_GIPIR946B");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR946D".equals(ACTION) || "printGIPIR946F".equals(ACTION)){
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				params.put("P_SCOPE", request.getParameter("scope"));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				if("printGIPIR946D".equals(ACTION))
					//params.put("functionName", "CSV_GIPIR946D");
				    params.put("functionName", "GET_GIPIR946D");
				else
					//params.put("functionName", "CSV_GIPIR946F");
					params.put("functionName", "GET_GIPIR946F");
				//End 06.16.2015
			}else if("printGIPIR929A".equals(ACTION)){
				params.put("P_ISS_PARAM", request.getParameter("issParam"));
				params.put("P_SCOPE", request.getParameter("scope"));
				params.put("P_RI_CD", request.getParameter("riCd").equals("")? null : Integer.parseInt(request.getParameter("riCd")));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR929A");
				/*params.put("functionName", "GET_GIPIR929A");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");*/
				//End 06.16.2015
			}else if("printGIPIR929B".equals(ACTION) || "printGIPIR929B_CSV".equals(ACTION)){
				params.put("P_ISS_PARAM", request.getParameter("issParam"));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				params.put("P_RI_CD", request.getParameter("riCd"));
				System.out.println("Test" + ACTION);
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR929B");
			  /*params.put("functionName", "GET_GIPIR929B");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");*/
				//End 06.16.2015
			}else if("printGIPIR930".equals(ACTION)){ //Modified by Apollo Cruz 05.27.2015 - AFPGEN-IMPLEM-SR 4564 - breakdown of CSV.xml
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				params.put("functionName", "GET_GIPIR930");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
			}else if("printGIPIR930A".equals(ACTION)){ //Modified by Apollo Cruz 05.27.2015 - AFPGEN-IMPLEM-SR 4564 - breakdown of CSV.xml
				params.put("P_ISS_PARAM", request.getParameter("issParam"));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				params.put("functionName", "GET_GIPIR930A");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
			}else if("printGIPIR928".equals(ACTION)){ //added by : kenneth L. 01.18.2012
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR928");
				params.put("functionName", "GET_GIPIR928");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR928F".equals(ACTION)){ //added by : gzelle 02.04.2013
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "CSV_GIPIR928F");
				params.put("functionName", "GET_GIPIR928F");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if("printGIPIR928G".equals(ACTION)){ //added by Kris 02.13.2013
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam")));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				params.put("functionName", "CSV_GIPIR928G");
			}else if("printGIPIR924K".equals(ACTION)){ //added by Kenneth L. 02.28.2013
				params.put("P_PARAMETER", request.getParameter("issParam"));
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope")));
				params.put("P_FROM_DATE", request.getParameter("fromDate"));
				params.put("P_TO_DATE", request.getParameter("toDate"));
				//Modified by Benjo 06.15.2015 GENQA-AFPGEN-IMPLEM-SR-4165
				//params.put("functionName", "GET_GIPIR924K"/*"CSV_GIPIR924K"*/);
				//params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//params.put("csvVersion", "dynamicSQL");				
				params.put("createCSVFromString", "Y"); // jhing 08.22.2015 GENQA-AFPGEN-IMPLEM-SR-4165
				params.put("P_PARAM_DATE", request.getParameter("paramDate"));
				params.put("P_REINSTATED", request.getParameter("reinstated")); // jhing 08.25.2015 
				//End 06.15.2015
			}else if("printEDST".equals(ACTION)){ //added by clperello 06.10.2014
				params.put("P_FROM_DATE", sdf2.format(sdf.parseObject(request.getParameter("fromDate"))));
				params.put("P_TO_DATE", sdf2.format(sdf.parseObject(request.getParameter("toDate"))));
				//params.put("P_FROM_DATE", sdf.parseObject(request.getParameter("fromDate"))); //Commented out by Jerome Bautista 11.09.2015 SR 5007
				//params.put("P_TO_DATE", sdf.parseObject(request.getParameter("toDate")));
				params.put("P_CTPL_POL", Integer.parseInt(request.getParameter("ctpl"))); //Modified by Jerome Bautista 11.09.2015 SR 5007
				params.put("P_INC_SPO", request.getParameter("inc"));
				params.put("P_NEGATIVE_AMT", request.getParameter("negAmount"));
				params.put("P_USER_ID", USER.getUserId());
				params.put("P_ISS_PARAM", Integer.parseInt(request.getParameter("issParam"))); //Added by Jerome Bautista 11.09.2015 SR 5007
				params.put("P_SCOPE", Integer.parseInt(request.getParameter("scope"))); //Added by Jerome Bautista 11.09.2015 SR 5007
				//Modified by Benjo 06.16.2015 GENQA-AFPGEN-SR-4564
				//params.put("functionName", "csv_edst");
				params.put("functionName", "GET_EDST");
				params.put("packageName", "CSV_UW_PRODREPORT");
				params.put("csvAction", ACTION + "CSV");
				//End 06.16.2015
			}else if ("printGIPIR902A".equals(ACTION) || "printGIPIR902B".equals(ACTION) || "printGIPIR902C".equals(ACTION)
					|| "printGIPIR902D".equals(ACTION) || "printGIPIR902E".equals(ACTION) || "printGIPIR902F".equals(ACTION)){ //apollo cruz 09.08.2014
				params.put("P_LINE_CD", request.getParameter("lineCd"));
				params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
				params.put("P_USER_ID", USER.getUserId());
				params.put("P_DATE_FROM", request.getParameter("dateFrom"));
				params.put("P_DATE_TO", request.getParameter("dateTo"));
				params.put("P_LOSS_DATE_FROM", request.getParameter("lossDateFrom"));
				params.put("P_LOSS_DATE_TO", request.getParameter("lossDateTo"));
				params.put("P_CLAIM_DATE", request.getParameter("claimDate"));
				params.put("P_PARAM_DATE", request.getParameter("paramDate"));
				params.put("P_ALL_LINE_TAG", request.getParameter("allLineTag"));
			}
			
			params.put("MAIN_REPORT", reportId+".jasper");
			params.put("OUTPUT_REPORT_FILENAME", filename);
			params.put("reportName", reportId);			
			params.put("mediaSizeName", "US_STD_FANFOLD");
			
			params.put("P_ISS_CD", request.getParameter("issCd"));
			params.put("P_LINE_CD", request.getParameter("lineCd"));
			params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
			params.put("P_USER_ID", USER.getUserId()); //robert 01.02.2014
			log.info("CREATING REPORT : " + reportId);
			Debug.print("Print " + reportId +  ": " + params);
			
			this.doPrintReport(request, response, params, reportDir);
			
		}catch(Exception e) {
			this.setPrintErrorMessage(request, USER, e);
			this.doDispatch(request, response, PAGE);
		}
	}
}
