package com.geniisys.giac.service.impl;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.dao.GIACAmlaCoveredTransactionDAO;
import com.geniisys.giac.service.GIACAmlaCoveredTransactionService;
import com.seer.framework.util.StringFormatter;

public class GIACAmlaCoveredTransactionServiceImpl implements GIACAmlaCoveredTransactionService {

	private GIACAmlaCoveredTransactionDAO giacAmlaCoveredTransactionDAO;

	public void setGiacAmlaCoveredTransactionDAO(GIACAmlaCoveredTransactionDAO giacAmlaCoveredTransactionDAO) {
		this.giacAmlaCoveredTransactionDAO = giacAmlaCoveredTransactionDAO;
	}

	public GIACAmlaCoveredTransactionDAO getGiacAmlaCoveredTransactionDAO() {
		return giacAmlaCoveredTransactionDAO;
	}

	@Override
	public String getAmlaBranch(HttpServletRequest request, GIISUser USER) throws SQLException, IOException {

		List<Map<String, Object>> amlaBranches = this.getGiacAmlaCoveredTransactionDAO().getAmlaBranch(USER.getUserId());
		
		String instCd = null;
		String newDate = null;
		String agency = request.getParameter("agency");
		String submission = request.getParameter("submission");
		String totalAmount = request.getParameter("totDetailAmt");
		String cnt = request.getParameter("cnt");

		for (Map<String, Object> mapBranch : amlaBranches) {
			instCd = (String) mapBranch.get("instCd");
			newDate = (String) mapBranch.get("newDate");
		}
		System.out.println(totalAmount);
		return request.getHeader("Referer") + "csv/amla/" + generateAmlaCSVFile(amlaBranches, totalAmount, cnt, newDate, instCd, 
				agency, submission, request.getSession().getServletContext().getRealPath(""), USER.getUserId());
	}

	@Override
	public List<Map<String, Object>> getAmlaRecords(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userId", USER.getUserId());
		return this.getGiacAmlaCoveredTransactionDAO().getAmlaRecords(params);
	}

	@Override
	public Map<String, Object> insertAmlaRecord(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		//params.put("tranType", request.getParameter("tranType"));		//commented out by Mark C. 07212015
		params.put("userId", USER.getUserId());
		params.put("cnt", request.getParameter("cnt"));
		params.put("totDetailAmt", request.getParameter("totDetailAmt"));
		return this.getGiacAmlaCoveredTransactionDAO().insertAmlaRecord(params);
	}

	@Override
	public String deleteAmlaRecord(GIISUser USER) throws SQLException {
		return this.getGiacAmlaCoveredTransactionDAO().deleteAmlaRecord(USER.getUserId());
	}

	@SuppressWarnings("unchecked")
	private String generateAmlaCSVFile(List<Map<String, Object>> rows, String totalAmount, String cnt, String newDate, String instCd,
			String agency, String submission, String realPath, String userId) throws IOException, SQLException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");		//uncomment by Mark C. 07232015
		//SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");  //commented by Mark C. 07232015
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");		//added by Mark C. 07142015
		//String fileName = instCd.substring(0, 6) + sdf.format(new Date()) + "01" + ".csv";
		String fileName = (instCd == null?"":instCd.substring(0, 6)) + sdf.format(new Date()) + "01" + ".csv"; //replaced by Mark C. 07062015
		realPath = realPath + "/csv/amla\\";

		StringBuilder strBuilder = new StringBuilder();

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);

		strBuilder.append("H," + agency + "," + instCd + "," + newDate + ",CTR,1," + submission + ",\r\n");  // replaced by Mark C. 07062015, changed the format code from 21 to 1
		
		for (Map<String, Object> row : rows) {
			System.out.println(row.get("branchCd"));
			//strBuilder.append("\"H\",\"" + agency + "\",\"" + instCd + "\",\"" + newDate + "\",\"CTR\",\"21\",\"" + submission + "\",\r\n");
			//strBuilder.append("H," + agency + "," + instCd + "," + newDate + ",CTR,21," + submission + ",\r\n");  
			params.put("branchCd", row.get("branchCd"));
			
			List<Map<String, Object>> amlaRecords = (List<Map<String, Object>>) StringFormatter.escapeHTMLInList3(this.getGiacAmlaCoveredTransactionDAO().getAmlaRecords(params));

			for (Map<String, Object> record : amlaRecords) {
				System.out.println(record.get("clientType"));

				String effDateString = (String) record.get("effDate");				// added by Mark C. 07142015, to determine policy term
				String expiryDateString = (String) record.get("expiryDate");
				Date effDateFormat, expiryDateFormat;
				long diff;
				double policyTerm = 0.0;
				try {
					effDateFormat = formatter.parse(effDateString);
					expiryDateFormat = formatter.parse(expiryDateString);
				    diff = expiryDateFormat.getTime() - effDateFormat.getTime();
				    policyTerm = Math.round(((diff / (24 * 60 * 60 * 1000)) / 365.0) * 10) / 10.0;
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			    
				if (record.get("clientType").equals("2")) {
					/*strBuilder.append("D,"
									+ record.get("tranDate")
									+ ","
									+ record.get("tranType")
									+ ","
									+ record.get("refNo")
									+ ","
									+ record.get("clientType")
									+ ",,"
									+ record.get("localAmt")
									+ ","
									+ record.get("foreignAmt")
									+ ","
									+ record.get("currencySname")
									+ ","
									+ record.get("payorType")
									+ ","
									+ record.get("corporateName")
									+ ",N,"
									+ record.get("address1")
									+ ","
									+ record.get("address2")
									+ ","
									+ record.get("address3")
									+ ","
									+ record.get("birthDate")
									+ ",Y,,Y,,Y,,Y,,Y,,Y,,,Y,,,Y,,Y,,,,,,"
									+ record.get("foreignAmt") + ",\r\n"); */
					
					strBuilder.append("D,"							//replaced by Mark C. 07092015
							+ record.get("tranDate")
							+ ","
							+ record.get("tranType")
							+ ","
							+ record.get("refNo")
							+ ","			
							+ record.get("policyNo")
							+ ",,"
							+ record.get("localAmt")
							+ ","
							+ record.get("foreignAmt")
							+ ","
							+ record.get("currencySname")
							+ ",,"
							+ record.get("effDate")
							+ ","
							+ record.get("expiryDate")
							+ ",,"					//+ ","
							+ record.get("tsiAmt")	//+ ",,,"
							+ ","
							+ record.get("fcTsiAmt") // added by gab 04.08.2016 SR 21922
							+ ","
							+ "NON-LIFE INSURANCE,"
							+ policyTerm
							+ ","					//+ ",\r\n");					
							+ "O,"					//strBuilder.append(
							+ " ,"
							+ "Y,"
							+ record.get("corporateName")
							+ ","
							+ record.get("address1")
							+ ","
							+ record.get("address2")
							+ ","
							+ record.get("address3")
							+ ","
							+ record.get("birthDate") //added by gab 04.08.2016 SR 21922
							+ ",,,,,,,"				//+ ",,,,,,"
							+ "I,"
							+ " ,"
							+ "Y,"
							+ record.get("corporateName")
							+ ","
							+ record.get("address1")
							+ ","
							+ record.get("address2")
							+ ","
							+ record.get("address3")
							+ ","
							+ record.get("birthDate")
							+ ",,,,,,,"
							+ "B,"
							+ " ,"
							+ "Y,"
							+ record.get("corporateName")
							+ ","
							+ record.get("address1")
							+ ","
							+ record.get("address2")
							+ ","
							+ record.get("address3")
							+ ","
							+ record.get("birthDate")
							+ ",,,,"		//end gab 04.08.2016 SR 21922
							+ ",\r\n");			//added by Mark C. 07092015
					
				} else if (record.get("clientType").equals("1")) {
					/*strBuilder.append("D,"
									+ record.get("tranDate")
									+ ","
									+ record.get("tranType")
									+ ","
									+ record.get("refNo")
									+ ","
									+ record.get("clientType")
									+ ",,"
									+ record.get("localAmt")
									+ ","
									+ record.get("foreignAmt")
									+ ","
									+ record.get("currencySname")
									+ ","
									+ record.get("payorType")
									+ ","
									+ record.get("lastName")
									+ ","
									+ record.get("firstName")
									+ ","
									+ record.get("middleName")
									+ ",N,"
									+ record.get("address1")
									+ ","
									+ record.get("address2")
									+ ","
									+ record.get("address3")
									+ ","
									+ record.get("birthDate")
									+ ",Y,,Y,,Y,,Y,,Y,,Y,,,Y,,,Y,,Y,,,,,,"
									+ record.get("foreignAmt") + ",\r\n");*/

					strBuilder.append("D,"							//replaced by Mark C. 07092015
							+ record.get("tranDate")
							+ ","
							+ record.get("tranType")
							+ ","
							+ record.get("refNo")
							+ ","			
							+ record.get("policyNo")
							+ ",,"
							+ record.get("localAmt")
							+ ","
							+ record.get("foreignAmt")
							+ ","
							+ record.get("currencySname")
							+ ",,"
							+ record.get("effDate")
							+ ","
							+ record.get("expiryDate")
							+ ",,"					//+ ","
							+ record.get("tsiAmt")	//+ ",,,"
							+ ","
							+ record.get("fcTsiAmt") // added by gab 04.08.2016 SR 21922
							+ ","
							+ "NON-LIFE INSURANCE,"
							+ policyTerm
							+ ","					//+ ",\r\n");					
							+ "O,"					//strBuilder.append(
							+ " ,"
							+ "N,"
							+ record.get("lastName")
							+ ","
							+ record.get("firstName")
							+ ","
							+ record.get("middleName")	
							+ ","
							+ record.get("address1")
							+ ","
							+ record.get("address2")
							+ ","
							+ record.get("address3")
							+ ","
							+ record.get("birthDate") //added by gab 04.08.2016 SR 21922
							+ ",,,,,,,"				//+ ",,,,,,"
							+ "I,"
							+ " ,"
							+ "N,"
							+ record.get("lastName")
							+ ","	
							+ record.get("firstName")
							+ ","
							+ record.get("middleName")	
							+ ","
							+ record.get("address1")
							+ ","
							+ record.get("address2")
							+ ","
							+ record.get("address3")
							+ ","
							+ record.get("birthDate")
							+ ",,,,,,,"	
							+ "B,"
							+ " ,"
							+ "N,"
							+ record.get("lastName")
							+ ","
							+ record.get("firstName")
							+ ","
							+ record.get("middleName")	
							+ ","
							+ record.get("address1")
							+ ","
							+ record.get("address2")
							+ ","
							+ record.get("address3")
							+ ","
							+ record.get("birthDate")
							+ ",,,,"		//end gab 04.08.2016 SR 21922
							+ ",\r\n"); 		//added by Mark C. 07092015				
				}
			}
		}
	
		strBuilder.append("T," + totalAmount + "," + cnt + ",\r\n");

		File file = new File(realPath + fileName);
		FileUtils.writeStringToFile(file, strBuilder.toString());
		return file.getName();
	}

}
