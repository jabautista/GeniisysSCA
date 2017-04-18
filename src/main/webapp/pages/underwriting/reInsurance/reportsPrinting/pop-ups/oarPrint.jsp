<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="oarPrintMainDiv">
	<table id="oarPrintDateTbl" name="oarPrintDateTbl" align="center" style="margin-top: 15px;">
		<tr>
			<td>As of: &nbsp</td>
			<td>
				<div id="asOfDateDiv" style="float: left; border: 1px solid gray; width: 175px; height: 20px; margin-bottom: 5px;">
					<input id="txtAsOfDate" name="txtAsOfDate" type="text" class="rightAligned" readonly="readonly" maxlength="10" value="${serverDate}" style="border: none; float: left; height: 13px; width: 150px; margin: 0px;">
					<img id="imgAsOfDate" alt="imgAsOfDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" />
				</div>
			</td>
		</tr>
		<tr>
			<td></td>
			<td>
				<input id="fortyFiveRB" name="daysRG" type="radio" value="1" style="float: left;"><label for="fortyFiveRb" style="margin: 2px 0 4px 0">45 Days</label>
			</td>
		</tr>
		<tr>
			<td></td>
			<td>
				<input id="seventyFiveRB" name="daysRG" type="radio" value="2" style="float: left;"><label for="seventyFiveRb" style="margin: 2px 0 4px 0">75 Days</label>
			</td>
		</tr>
		<tr>
			<td></td>
			<td>
				<input id="sysDateRB" name="daysRG" type="radio" value="3" checked="checked" style="float: left;"><label for="sysDateRb" style="margin: 2px 0 4px 0">As of SYSTEM DATE</label>
			</td>
		</tr>
	</table>
	
	<div id="btnDiv" name="btnDiv" class="buttonsDiv" style="margin:15px 0 10px 0; width: 100%">
		<input id="btnOk" name="btnOk" type="button" class="button" value="Ok">
	</div>
</div>

<script type="text/javascript">
	var rbVal = $("sysDateRB").value;
	objRiReports.oar.oar_print_date = '${serverDate}';
	
	$("imgAsOfDate").observe("click", function(){
		if (!$("sysDateRB").checked){
			scwShow($('txtAsOfDate'),this, null);
		}	
	});
	
	$$("input[name='daysRG']").each(function(radio){
		radio.observe("click", function(){
			rbVal = radio.value;
			if(radio.value == "3"){
				$("txtAsOfDate").value = objRiReports.oar.oar_print_date;
			}
		});
	});
	
	$("btnOk").observe("click", function(){
		var alert_msg = "";
		if($("fortyFiveRB").checked){
			alert_msg = "Entered date (" + dateFormat($F("txtAsOfDate"), "dd-mmm-yy") + ") will be saved in records to be extracted. "+
						"Do you want to continue?";
		}else {
			alert_msg = "Entered date (" + dateFormat($F("txtAsOfDate"), "dd-mmm-yy") + ") will be used for the report. "+
						"Do you want to continue?";
		}
		
		objRiReports.oar.date_sw = 0;
		
		showConfirmBox("", alert_msg, "Yes", "No",
				function(){
					objRiReports.oar.oar_print_date = $F("txtAsOfDate");
					
					if($("seventyFiveRB").checked){
						objRiReports.oar.more_than = 65;
						objRiReports.oar.less_than = 90000000;
						objRiReports.oar.date_sw = 1;
						prepareOARDate();
						genericObjOverlay.close();
					}else{
						checkOARPrintDate();
					}
				},
				function(){
					genericObjOverlay.close();
				}
		);
		
	});
	
	function checkOARPrintDate(){
		try{
			objRiReports.oar.more_than = 0;
			objRiReports.oar.less_than = 9000000;
			
			if($("fortyFiveRB").checked){
				objRiReports.oar.more_than = 45;
				objRiReports.oar.less_than = 64;
				
				new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
					method: "GET",
					parameters: {
						action: 	"checkOARPrintDate",
						riCd:		objRiReports.oar.ri_cd_accept, //== ""? '' : objRiReports.oar.ri_cd_accept,
						lineCd:		objRiReports.oar.line_cd_accept,
						asOfDate:	objRiReports.oar.oar_print_date,
						moreThan:	objRiReports.oar.more_than,
						lessThan:	objRiReports.oar.less_than
					},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
							var obj = JSON.parse(response.responseText);
							
							if (obj.printChk == "Y"){
								var alert_msg = "Entered date (" + dateFormat($F("txtAsOfDate"), "dd-mmm-yy") + ") has been extracted. This will untag all the records "+
												"with this date and will be extracted again. Do you want to continue?";
								showConfirmBox("", alert_msg, "Yes", "No",
										function(){
											updateOARPrintDate(obj.printChk);
											prepareOARDate();
											genericObjOverlay.close();
										},
										function(){
											genericObjOverlay.close();
										}
								);
							}else{
								prepareOARDate();
								updateOARPrintDate(obj.printChk);
								genericObjOverlay.close();
							}
						}
					}
				});
			}else if($("sysDateRB").checked){
				objRiReports.oar.oar_print_date = "";
				prepareOARDate();
				genericObjOverlay.close();
			}
		}catch(e){
			showErrorMessage("checkOARPrintDate", e);
		}
	}
	
	function updateOARPrintDate(printChk){
		try{
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
				method: "GET",
				parameters: {
					action:		"updateOARPrintDate",
					riCd:		objRiReports.oar.ri_cd_accept,
					lineCd:		objRiReports.oar.line_cd_accept,
					asOfDate:	objRiReports.oar.oar_print_date,
					moreThan:	objRiReports.oar.more_than,
					lessThan:	objRiReports.oar.less_than,
					printChk:	printChk
					
				},
				evalScripts: true,
				asynchronous: true
			});
		}catch(e){
			showErrorMessage("updateOARPrintDate", e);
		}
	}
</script>