<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="statementOfAccountMainDiv" name="statementOfAccountMainDiv" >
	<div id="statementOfAccountExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="statementOfAccountExit">Exit</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Statement of Accounts - Booked Policies</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<!-- replaced with codes below : shan 12.08.2014
	 <div id="soaContentsDiv" name="soaContentsDiv" class="sectionDiv" style="margin-bottom: 40px;">
		<div id="soaChkDates" name="soaChkDates" style="width:800px; margin: 20px 20px 20px 60px;">
			<table id="extractTable" border="0" align="center" style="width:500px;">
				<tr>
					<td width="10px"><input type="checkbox" id="chkBookTag" name="chkBookTag" checked="checked" /></td>
					<td><label for="chkBookTag" id="lblChkBookTag">&nbsp; Accounting Entry Date</label></td>
					<td width="10px"><input type="checkbox" id="chkInceptTag" name="chkInceptTag" /></td>
					<td><label for="chkInceptTag" id="lblChkInceptTag">&nbsp; Inception Date</label></td>
					<td width="10px"><input type="checkbox" id="chkIssueTag" name="chkIssueTag" /></td>
					<td><label for="chkIssueTag" id="lblChkIssueTag">&nbsp; Issue Date</label></td>
				</tr>
			</table>
		</div> <!-- end: soaChkDates -- >
		
		<div id="soaDatesDiv" name="soaDatesDiv" style="width:800px; margin:20px 20px 20px 60px; ">
			<div id="soaDateFieldsDiv" name="soaDateFieldsDiv" style="float:left; ">
				<table border="0" align="center" style="float:left;width:500px; margin-left:100px;">
				<tr id="trDateAsOf">
					<td style="text-align:right; width:120px;">Date As Of</td>
					<td style="width:180px;">
						<div class="required" style="border: solid 1px gray; width:170px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" />
					    	<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="required" style="float:left;width:145px; border: none; height:12px;" readonly="readonly" />
					    	<img name="hrefAsOfDate" id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="AsOfDate" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -- >
						</div>
					</td>
					<td></td>
				</tr>
				<tr id="trBookDate">
					<td style="text-align:right; width:120px;">Acct Ent Date</td>
					<td style="width:180px;">
						<div class="required" style="border: solid 1px gray; width:170px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" />
					    	<input type="text" id="txtBookDateFrom" name="txtBookDateFrom" class="required" readonly="readonly" style="float:left;width:145px; border: none; height:12px;" />
					    	<img name="hrefBookDateFrom" id="hrefBookDateFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="BookDateFrom" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -- >
						</div>
					</td>
					<td style="width:180px;">
						<div class="required" style="border: solid 1px gray; width:170px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" />
					    	<input type="text" id="txtBookDateTo" name="txtBookDateTo" class="required" readonly="readonly" style="float:left;width:145px; border: none; height:12px;" />
					    	<img name="hrefBookDateTo" id="hrefBookDateTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="BookDateTo" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -- >
						</div>
					</td>
				</tr>
				<tr id="trInceptDate">
					<td style="text-align:right; width:120px;">Incept Date</td>
					<td style="width:180px;">
						<div class="required" style="border: solid 1px gray; width:170px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;"/>
					    	<input type="text" id="txtIncepDateFrom" name="txtIncepDateFrom" class="required" style="float:left;width:145px; border: none; height:12px;" readonly="readonly" />
					    	<img name="hrefIncepDateFrom" id="hrefIncepDateFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="IncepDateFrom" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -- >
						</div>
					</td>
					<td style="width:180px;">
						<div class="required" style="border: solid 1px gray; width:170px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" />
					    	<input type="text" id="txtIncepDateTo" name="txtIncepDateTo" class="required" readonly="readonly" style="float:left;width:145px; border: none; height:12px;"  />
					    	<img name="hrefIncepDateTo" id="hrefIncepDateTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="IncepDateTo" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -- >
						</div>
					</td>
				</tr>
				<tr id="trIssueDate">
					<td id="tdIssueDate1" style="text-Align:right; width:120px;">Issue Date</td>
					<td id="tdIssueDate3" style="width:180px;">
						<div class="required" style="border: solid 1px gray; width:170px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" />
					    	<input type="text" id="txtIssueDateFrom" name="txtIssueDateFrom" class="required" readonly="readonly"  style="float:left;width:145px; border: none; height:12px;"  />
					    	<img name="hrefIssueDateFrom" id="hrefIssueDateFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="IssueDateFrom" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -- >
						</div>
					</td>
					<td id="tdIssueDate2" style="width:180px;">
						<div class="required" style="border: solid 1px gray; width:170px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" />
					    	<input type="text" id="txtIssueDateTo" name="txtIssueDateTo" class="required" readonly="readonly" style="float:left;width:145px; border: none; height:12px;"   />
					    	<img name="hrefIssueDateTo" id="hrefIssueDateTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="IssueDateTo" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -- >
						</div>
					</td>
					<!-- <td><input type="button" id="btnExtract" name="btnExtract" class="button" value="Extract" style="width:90px" /></td> -- >
				</tr>
				<tr id="trCutOffDate">
					<td id="tdCutOffDate1" style="text-Align:right; width:120px;">Cut off Date</td>
					<td id="tdCutOffDate2" style="width:180px;">
						<div class="required" style="border: solid 1px gray; width:170px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" />
					    	<input type="text" id="txtCutOffDate" name="txtCutOffDate" class="required" readonly="readonly"  style="float:left;width:145px; border: none; height:12px;"   />
					    	<img name="hrefCutOffDate" id="hrefCutOffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="CutOffDate" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -- >
						</div>
					</td>
					<td style="width:180px;"><input type="button" id="btnExtract" name="btnExtract" class="button" value="Extract" style="width:90px; margin-left:5px;" /></td>
				</tr>
				</table>
			</div>  -->
			
			<!-- <div id="btnExtractDiv" name="btnExtractDiv" style="float:left; width:100px; height:75px; margin-bottom:0px; margin-left:20px;">
				<!-- <input type="button" id="btnExtract" name="btnExtract" class="button" value="Extract" style="width:90px" /> -- >
			</div> 
		</div> <!-- end: soaDatesDiv -- >
		
		
		<div id="soaRadioDiv" name="soaRadioDiv" class="sectionDiv" style="border:none; margin-top: 30px;">
			<div id="reportDateDiv" name="reportDateDiv" style="float:left; border:none; width:180px; margin: 20px 10px 10px 80px;">
				<fieldset id="fsReportDate" >
					<legend>Report Date</legend>
					<table border="0" cellspacing="2" cellpadding="2" >
						<!-- <tr><td colspan="2"><b>&nbsp;&nbsp;&nbsp;&nbsp;Report Date</b></td></tr> -- >
						<tr id="trRdoAsOf">
							<td><input type="radio" id="rdoAsOf" name="rdoReportDate" title="Report Date" value="asOf" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoAsOf"> As of</label></td>
						</tr>
						<tr id="trRdoFromTo">
							<td><input type="radio" id="rdoFromTo" name="rdoReportDate" title="Report Date" value="fromTo" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoFromTo"> From To</label></td>
						</tr>
					</table>
				</fieldset><br/>
				<fieldset>
					<legend>Branch of Policy</legend>
					<table>
						<tr>
							<td><input type="radio" id="rdoIssuing" name="rdoBranch" title="Branch of Policy" value="issuing" checked="checked" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoIssuing"> Issuing Source</label></td>
						</tr>
						<tr>
							<td><input type="radio" id="rdoCrediting" name="rdoBranch" title="Branch of Policy" value="crediting" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoCrediting"> Crediting Branch</label></td>
						</tr>					
					</table>
				</fieldset>
			</div>
			
			<div id="reportByDiv" name="reportByDiv" style="border:none; float:left; width:150px; margin: 20px 10px 10px 10px;">
				<fieldset>
					<legend>Print Report By</legend>
					<table border="0" cellspacing="2" cellpadding="2" >
						<!-- <tr><td colspan="2"><b>&nbsp;&nbsp;&nbsp;&nbsp;Print Report By</b></td></tr> -- >
						<tr id="trRdoByIntermediary">
							<td><input type="radio" id="rdoByIntermediary" name="rdoReportBy" title="Print Report By" value="intermediary" checked="checked" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoByIntermediary"> Intermediary</label></td>
						</tr>
						<tr id="trRdoByAssured">
							<td><input type="radio" id="rdoByAssured" name="rdoReportBy" title="Print Report By" value="assured" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoByAssured"> Assured</label></td>
						</tr>
						<tr id="trRdoByLicense">
							<td><input type="radio" id="rdoByLicense" name="rdoReportBy" title="Print Report By" value="license" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoByLicense"> License</label></td>
						</tr>
					</table>
				</fieldset>
			</div>
			
			<div id="reportTypeDiv" name="reportTypeDiv" style="float:left; width:215px; height:150px; margin: 20px 10px 10px 10px;">
				<fieldset>
					<legend>Report Type</legend>
					<table id="tblReportType" name="tblReportType" border="0" cellspacing="2" cellpadding="2">
						<!-- <tr><td colspan="2"><b>&nbsp;&nbsp;&nbsp;&nbsp;Report Type</b></td></tr> -- >
						<tr id="trRdoSummary">
							<td><input type="radio" id="rdoSummary" name="rdoReportType" title="Report Type" value="summary" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoSummary"> Summary</label></td>
						</tr>
						<tr id="trRdoDetail">
							<td><input type="radio" id="rdoDetail" name="rdoReportType" title="Report Type" value="detail" checked="checked" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoDetail"> Detail</label></td>
						</tr>
						<tr id="trRdoTaxBreakdown">
							<td><input type="radio" id="rdoTaxBreakdown" name="rdoReportType" title="Report Type" value="taxBreakdown" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoTaxBreakdown"> Tax Breakdown</label></td>
						</tr>
						<tr id="trRdoSOA">
							<td><input type="radio" id="rdoStatement" name="rdoReportType" title="Report Type" value="statement" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoStatement"> Statement of Account</label></td>
						</tr>
						<!-- LICENSED -- >
						<tr id="trRdoLicensed">
							<td><input type="radio" id="rdoLicensed" name="rdoReportType" title="Report Type" value="licensed" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoLicensed"> Licensed</label></td>
						</tr>
						<tr id="trRdoUnlicensed">
							<td><input type="radio" id="rdoUnlicensed" name="rdoReportType" title="Report Type" value="unlicensed" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoUnlicensed"> Unlicensed</label></td>
						</tr>
						<!-- LAYOUT2 -- >
						<tr id="trRdoWithNet">
							<td><input type="radio" id="rdoWithNet" name="rdoReportType" title="Report Type" value="withNet" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoWithNet"> With Net</label></td>
						</tr>
						<tr id="trRdoWithoutNet">
							<td><input type="radio" id="rdoWithoutNet" name="rdoReportType" title="Report Type" value="withoutNet" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoWithoutNet"> Without Net</label></td>
						</tr>
						<tr id="trRdoAssdWithoutNet">
							<td><input type="radio" id="rdoAssdWithoutNet" name="rdoReportType" title="Report Type" value="assdWithoutNet" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoAssdWithoutNet"> Assd Without Net</label></td>
						</tr>
						<tr id="trRdoSOANetComm">
							<td><input type="radio" id="rdoSOANetComm" name="rdoReportType" title="Report Type" value="soaNetComm" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoSOANetComm"> SOA Net of Commission</label></td>
						</tr>
					</table>
				</fieldset>
			</div>
			
			<div id="layoutTypeDiv" name="layoutTypeDiv" style="float:left; width:150px; margin: 20px 10px 10px 10px;">
				<fieldset>
					<legend>Layout Type</legend>
					<table border="0" cellspacing="2" cellpadding="2">
						<tr>
							<td><input type="radio" id="rdoLayout1" name="rdoLayoutType" title="Layout Type" value="1" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoLayout1"> Layout 1</label></td>
						</tr>
						<tr>
							<td><input type="radio" id="rdoLayout2"  name="rdoLayoutType" title="Layout Type" value="2" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoLayout2"> Layout 2</label></td>
						</tr>
						<tr>
							<td><input type="radio" id="rdoLayout3"  name="rdoLayoutType" title="Layout Type" value="3" style="float: left; margin-left: 13px;" /></td>
							<td><label for="rdoLayout3"> Layout 3</label></td>
						</tr>
						<tr><td>&nbsp;</td><td><input type="button" class="button" id="btnRemarks" name="btnRemarks" value="Remarks" style="width:90px;" /></td></tr>
					</table>
				</fieldset>
			</div>
			
		</div> <!-- end: soaRadioDiv -- >
		 as per enhancement AC-SPECS-2014-034 : shan 12.08.2014-->
		
	<div id="soaContentsDiv" name="soaContentsDiv" class="sectionDiv" style="margin-bottom: 40px;">		
		<div id="soaDates" name="soaDates" class="sectionDiv" style="width:800px; height:160px; margin: 20px 20px 1px 60px;">
			<table id="policyDateTable" border="0" style="float:left; width:110px; margin: 5px 0 0 25px;">
				<tr>
					<td colspan="2">Policy Date</td>
				</tr>
				<tr id="trRdoAsOf">
					<td width="8px"><input type="radio" id="rdoAsOf" name="rdoReportDate" title="Report Date" value="asOf" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoAsOf"> As of</label></td>
				</tr>
				<tr id="trRdoFromTo">
					<td width="8px"><input type="radio" id="rdoFromTo" name="rdoReportDate" title="Report Date" value="fromTo" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoFromTo"> From To</label></td>
				</tr>
			</table>
			
			<table id="chkDatesTable" border="0" style="float:left; width:170px; margin: 20px 0 0 25px;">				
				<tr>
					<td width="10px"><input type="checkbox" id="chkBookTag" name="chkBookTag" checked="checked" /></td>
					<td><label for="chkBookTag" id="lblChkBookTag">&nbsp; Accounting Entry Date</label></td>
				</tr>
				<tr>
					<td width="10px"><input type="checkbox" id="chkInceptTag" name="chkInceptTag" /></td>
					<td><label for="chkInceptTag" id="lblChkInceptTag">&nbsp; Inception Date</label></td>
				</tr>
				<tr>
					<td width="10px"><input type="checkbox" id="chkIssueTag" name="chkIssueTag" /></td>
					<td><label for="chkIssueTag" id="lblChkIssueTag">&nbsp; Issue Date</label></td>
				</tr>
			</table>
			
			<div id="soaDateFieldsDiv" name="soaDateFieldsDiv" style="float:left; height:90px; ">
				<table border="0" style="float:left;width:400px; margin: 20px 0 0 25px;">
				<tr id="trDateAsOf">
					<td style="text-align:right; width:120px;">Date As Of</td>
					<td style="width:140px;">
						<div class="required" style="border: solid 1px gray; width:130px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" />
					    	<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="required" style="float:left;width:105px; border: none; height:12px;" readonly="readonly" />
					    	<img name="hrefAsOfDate" id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="AsOfDate" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -->
						</div>
					</td>
					<td></td>
				</tr>
				<tr id="trBookDate">
					<td style="text-align:right; width:120px;">Acct Ent Date</td>
					<td style="width:140px;">
						<div class="required" style="border: solid 1px gray; width:130px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" />
					    	<input type="text" id="txtBookDateFrom" name="txtBookDateFrom" class="required" readonly="readonly" style="float:left;width:105px; border: none; height:12px;" />
					    	<img name="hrefBookDateFrom" id="hrefBookDateFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="BookDateFrom" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -->
						</div>
					</td>
					<td style="width:140px;">
						<div class="required" style="border: solid 1px gray; width:130px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" />
					    	<input type="text" id="txtBookDateTo" name="txtBookDateTo" class="required" readonly="readonly" style="float:left;width:105px; border: none; height:12px;" />
					    	<img name="hrefBookDateTo" id="hrefBookDateTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="BookDateTo" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -->
						</div>
					</td>
				</tr>
				<tr id="trInceptDate">
					<td style="text-align:right; width:120px;">Incept Date</td>
					<td style="width:140px;">
						<div class="required" style="border: solid 1px gray; width:130px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;"/>
					    	<input type="text" id="txtIncepDateFrom" name="txtIncepDateFrom" class="required" style="float:left;width:105px; border: none; height:12px;" readonly="readonly" />
					    	<img name="hrefIncepDateFrom" id="hrefIncepDateFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="IncepDateFrom" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -->
						</div>
					</td>
					<td style="width:140px;">
						<div class="required" style="border: solid 1px gray; width:130px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" />
					    	<input type="text" id="txtIncepDateTo" name="txtIncepDateTo" class="required" readonly="readonly" style="float:left;width:105px; border: none; height:12px;"  />
					    	<img name="hrefIncepDateTo" id="hrefIncepDateTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="IncepDateTo" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -->
						</div>
					</td>
				</tr>
				<tr id="trIssueDate">
					<td id="tdIssueDate1" style="text-Align:right; width:120px;">Issue Date</td>
					<td id="tdIssueDate3" style="width:140px;">
						<div class="required" style="border: solid 1px gray; width:130px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" />
					    	<input type="text" id="txtIssueDateFrom" name="txtIssueDateFrom" class="required" readonly="readonly"  style="float:left;width:105px; border: none; height:12px;"  />
					    	<img name="hrefIssueDateFrom" id="hrefIssueDateFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="IssueDateFrom" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -->
						</div>
					</td>
					<td id="tdIssueDate2" style="width:140px;">
						<div class="required" style="border: solid 1px gray; width:130px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" />
					    	<input type="text" id="txtIssueDateTo" name="txtIssueDateTo" class="required" readonly="readonly" style="float:left;width:105px; border: none; height:12px;"   />
					    	<img name="hrefIssueDateTo" id="hrefIssueDateTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="IssueDateTo" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -->
						</div>
					</td>
					<!-- <td><input type="button" id="btnExtract" name="btnExtract" class="button" value="Extract" style="width:90px" /></td> -->
				</tr>
				<tr id="trCutOffDate">
					<td id="tdCutOffDate1" style="text-Align:right; width:120px;">Cut off Date</td>
					<td id="tdCutOffDate2" style="width:140px;">
						<div class="required" style="border: solid 1px gray; width:130px; height: 20px; margin-right:0px; margin-left:5px; margin-top: 0px;" />
					    	<input type="text" id="txtCutOffDate" name="txtCutOffDate" class="required" readonly="readonly"  style="float:left;width:105px; border: none; height:12px;"   />
					    	<img name="hrefCutOffDate" id="hrefCutOffDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="CutOffDate" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -->
						</div>
					</td>
					<td style="width:140px;"></td>
				</tr>
				</table>
			</div>
			
			<table id="paymentDateTable" border="0" style="float:left; width:700px; margin: 10px 0 10px 25px; padding-right:400px;">
				<tr>
					<td colspan="2">Payment Date</td>
				</tr>
				<tr>
					<td width="8px"><input type="radio" id="rdoTranDate" name="rdoPaymentDate" title="Tran Date" value="T" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoTranDate"> Tran Date</label></td>
					<td width="8px"><input type="radio" id="rdoPostingDate" name="rdoPaymentDate" title="Posting Date" value="P" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoPostingDate"> Posting Date</label></td>
				</tr>
			</table>
		</div>
		
		<div id="soaParams" name="soaParams" class="sectionDiv" style="width:800px; height:120px; margin: 1px 20px 1px 60px;">
			<table id="branchPolicyTable" border="0" style="float:left; width:170px; margin: 5px 0 0 25px;">
				<tr>
					<td colspan="2">Branch Policy </td>
				</tr>
				<tr>
					<td width="8px"><input type="radio" id="rdoIssuing" name="rdoBranch" title="Branch of Policy" value="issuing" checked="checked" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoIssuing"> Issuing Source</label></td>
				</tr>
				<tr>
					<td width="8px"><input type="radio" id="rdoCrediting" name="rdoBranch" title="Branch of Policy" value="crediting" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoCrediting"> Crediting Branch</label></td>
				</tr>
			</table>
			
			<table id="screenLayoutTable" border="0" style="float:left; width:170px; margin: 5px 0 0 25px;">
				<tr>
					<td colspan="2">Screen Layout </td>
				</tr>
				<tr>
					<td width="8px"><input type="radio" id="rdoLayout1" name="rdoLayoutType" title="Layout Type" value="1" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoLayout1"> Layout 1</label></td>
				</tr>
				<tr>
					<td width="8px"><input type="radio" id="rdoLayout2"  name="rdoLayoutType" title="Layout Type" value="2" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoLayout2"> Layout 2</label></td>
				</tr>
				<tr>
					<td width="8px"><input type="radio" id="rdoLayout3"  name="rdoLayoutType" title="Layout Type" value="3" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoLayout3"> Layout 3</label></td>
				</tr>
			</table>
			
			<table id="printReportByTable" border="0" style="float:left; width:170px; margin: 5px 0 0 20px;">
				<tr>
					<td colspan="2">Print Report By </td>
				</tr>
				<tr id="trRdoByIntermediary">
					<td width="8px"><input type="radio" id="rdoByIntermediary" name="rdoReportBy" title="Print Report By" value="intermediary" checked="checked" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoByIntermediary"> Intermediary</label></td>
				</tr>
				<tr id="trRdoByAssured">
					<td width="8px"><input type="radio" id="rdoByAssured" name="rdoReportBy" title="Print Report By" value="assured" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoByAssured"> Assured</label></td>
				</tr>
				<tr id="trRdoByLicense">
					<td width="8px"><input type="radio" id="rdoByLicense" name="rdoReportBy" title="Print Report By" value="license" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoByLicense"> License</label></td>
				</tr>
			</table>
			
			<table id="printTypeTable" border="0" style="float:left; width:180px; margin: 5px 0 10px 20px;">
				<tr>
					<td colspan="2" id="tdPrintType">Print Type </td>
				</tr>
				<tr id="trRdoSummary">
					<td width="8px"><input type="radio" id="rdoSummary" name="rdoReportType" title="Report Type" value="summary" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoSummary"> Summary</label></td>
				</tr>
				<tr id="trRdoDetail">
					<td width="8px"><input type="radio" id="rdoDetail" name="rdoReportType" title="Report Type" value="detail" checked="checked" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoDetail"> Detail</label></td>
				</tr>
				<tr id="trRdoTaxBreakdown">
					<td width="8px"><input type="radio" id="rdoTaxBreakdown" name="rdoReportType" title="Report Type" value="taxBreakdown" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoTaxBreakdown"> Tax Breakdown</label></td>
				</tr>
				<tr id="trRdoSOA">
					<td width="8px"><input type="radio" id="rdoStatement" name="rdoReportType" title="Report Type" value="statement" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoStatement"> Statement of Account</label></td>
				</tr>
				<!-- LICENSED -->
				<tr id="trRdoLicensed">
					<td width="8px"><input type="radio" id="rdoLicensed" name="rdoReportType" title="Report Type" value="licensed" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoLicensed"> Licensed</label></td>
				</tr>
				<tr id="trRdoUnlicensed">
					<td width="8px"><input type="radio" id="rdoUnlicensed" name="rdoReportType" title="Report Type" value="unlicensed" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoUnlicensed"> Unlicensed</label></td>
				</tr>
				<!-- LAYOUT2 -->
				<tr id="trRdoWithNet">
					<td width="8px"><input type="radio" id="rdoWithNet" name="rdoReportType" title="Report Type" value="withNet" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoWithNet"> With Net</label></td>
				</tr>
				<tr id="trRdoWithoutNet">
					<td width="8px"><input type="radio" id="rdoWithoutNet" name="rdoReportType" title="Report Type" value="withoutNet" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoWithoutNet"> Without Net</label></td>
				</tr>
				<tr id="trRdoAssdWithoutNet">
					<td width="8px"><input type="radio" id="rdoAssdWithoutNet" name="rdoReportType" title="Report Type" value="assdWithoutNet" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoAssdWithoutNet"> Assd Without Net</label></td>
				</tr>
				<tr id="trRdoSOANetComm">
					<td width="8px"><input type="radio" id="rdoSOANetComm" name="rdoReportType" title="Report Type" value="soaNetComm" style="float: left; margin-left: 13px;" /></td>
					<td><label for="rdoSOANetComm"> SOA Net of Commission</label></td>
				</tr>
			</table>
		</div>
		
		<div id="combinedDivs" class="sectionDiv" style="border:none; margin-top:1px;">
			<div id="osAndChkDiv"  class="sectionDiv" style="width:400px; height: 170px; float:left; margin-left: 60px;">
				<div id="soaFieldsDiv" name="soaFieldsDiv"style="width:380px; margin:10px 10px 5px 15px; ">
					<table border="0" align="center" style="width:400px;">
						<tr id="trBranch">
							<td style="width:120px;">Branch</td>
							<td>
								<div style="float:left; border: solid 1px gray; width:70px; height:22px; margin: 2px 0px 0px 5px; " changeTagAttr="true">
									<input type="text" id="txtBranchCd" name="txtBranchCd" class="upper" lastValidValue="" style="width:45px;height:12px; border:none;  margin-left:0px;float:left;" maxlength="2" />
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osBranchCd" name="osBranchCd" alt="Go" />
								</div>
								<input type="text" id="txtBranch" name="txtBranch" value="All Branches" readonly="readonly" style="width:150px;height:16px;  margin-left:3px; float:left;" />					
							</td>					
						</tr>
						<tr id="trIntmType">
							<td style="width:120px;">Intermediary Type</td>
							<td>
								<div style="float:left; border: solid 1px gray; width:70px; height:22px; margin: 2px 0px 0px 5px; " changeTagAttr="true">
									<input type="text" id="txtIntmType" name="txtIntmType" maxlength="2" class="upper" lastValidValue="" style="width:45px;height:12px; border:none;  margin-left:0px;float:left;" />
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osIntmType" name="osIntmType" alt="Go" />
								</div>
								<input type="text" id="txtIntmDesc" name="txtIntmDesc" value="All Intm Type" readonly="readonly" style="width:150px;height:16px;  margin-left:3px; float:left;" />
							</td>
						</tr>
						<tr id="trIntmNo">
							<td style="width:120px;">Intermediary</td>
							<td>
								<div style="float:left; border: solid 1px gray; width:70px; height:22px; margin: 2px 0px 0px 5px; " changeTagAttr="true">
									<input type="text" id="txtIntmNo" name="txtIntmNo" maxlength="12" lastValidValue="" class="integerNoNegativeUnformattedNoComma" style="width:43px;height:12px; border:none;  margin-left:0px;float:left; text-align:right;" />
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osIntmNo" name="osIntmNo" alt="Go" />
								</div>
								<input type="text" id="txtIntmName" name="txtIntmName" value="All Intermediaries" readonly="readonly" style="width:150px;height:16px;  margin-left:3px; float:left;" />
							</td>					
						</tr>
						<tr id="trAssdNo">
							<td style="width:120px;">Assured</td>
							<td>
								<div style="float:left; border: solid 1px gray; width:70px; height:22px; margin: 2px 0px 0px 5px; " changeTagAttr="true">
									<input type="text" id="txtAssdNo" name="txtAssdNo" maxlength="12" class="integerNoNegativeUnformattedNoComma" lastValidValue="" style="width:45px;height:12px; border:none; text-align:right; margin-left:0px;float:left;" />
									<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osAssdNo" name="osAssdNo" alt="Go" />
								</div>
								<input type="text" id="txtAssdName" name="txtAssdName" value="All Assured" readonly="readonly" style="width:150px;height:16px;  margin-left:3px; float:left;" />
							</td>
						</tr>				
					</table> 
				</div> <!-- end: soaFieldsDiv -->					
			</div> <!-- end: osAndChkDiv -->
			
			<div id="printAndLimitDiv" class="sectionDiv" style="float:left; width:396px; height: 170px; margin-left: 2px;">
				<div id="soaChecksDiv" name="soaChecksDiv" style="width:350px; height: 80px; margin:5px 20px 5px 25px; ">
					<table cellpadding="2" cellspacing="2" style="float: left; width: 170px; margin-right: 5px;">
						<tr id="trChkIncludePDC">
							<td align="right">
								<input type="checkbox" id="chkIncludePDC" name="chkIncludePDC" /></td>
							<td colspan="2"><label for="chkIncludePDC">Include PDC</label></td>
						</tr>
						<tr id="trChkIncludeNotDue">
							<td align="right">
								<input type="checkbox" id="chkIncludeNotDue" name="chkIncludeNotDue" /></td>
							<td colspan="2"><label for="chkIncludeNotDue">Include Not Yet Due</label></td>
						</tr>
						<tr id="trChkBreakdownTax">
							<td align="right"><input type="checkbox" id="chkBreakdownTax" name="chkBreakdownTax" /></td>
							<td colspan="2" ><label for="chkBreakdownTax">Breakdown Tax</label></td>
						</tr>
						<tr id="trChkWholdingTax">
							<td align="right"><input type="checkbox" id="chkWholdingTax" name="chkWholdingTax" /></td>
							<td colspan="2" ><label for="chkWholdingTax">With witholding tax</label></td>
						</tr>
						<tr>
							<td>
								<input type="hidden" id="hidIncludePDC" name="hidIncludePDC" />
								<input type="hidden" id="hidSOARemarks" name="hidSOARemarks" />
							</td>
						</tr>
					</table>
					<table cellpadding="2" cellspacing="2"  style="float: left; width: 170px;">
						<tr id="trSpecialPol">
							<td align="right"><input type="checkbox" id="chkSpecialPol" name="chkSpecialPol" /></td>
							<td colspan="2" ><label for="chkSpecialPol">Include Special Policies</label></td>
						</tr>
						
					</table>
				</div>		
				<!-- <div id="soaPrintFieldsDiv" name="soaPrintFieldsDiv" style="float:left;width:400px; margin:10px 10px 10px 70px; ">
					<table border="0" align="center" style="width:350px;">
						<tr>
							<td style="text-align:right;">Destination</td>
							<td>
								<select id="selDestination" style="margin-left:5px; width:70%;" >
									<option value="screen">SCREEN</option>
									<option value="printer">PRINTER</option>
									<option value="local">LOCAL PRINTER</option> <!-- added by jeffdojello 02.04.2014-- >
									<option value="file">FILE</option>
								</select>
								<!-- <input type="text" id="txtDestination" name="txtDestination" style="margin-left:5px;" /> -- >
							</td>
						</tr>
						<tr id="trRdoFileType">
							<td>&nbsp;</td>
							<td>
								<table border="0">									
									<tr>
										<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="rdoFileType" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
										<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label>
										<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="rdoFileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td style="text-align:right;">Printer Name</td>
							<td>
								<select id="printerName" style="margin-left:5px; width:70%;">
									<option></option>
								<c:forEach var="p" items="${printers}">
									<option value="${p.name}">${p.name}</option>
								</c:forEach>
								</select>
								<input type="hidden" id="selPrinter" name="selPrinter" />
								<!-- <input type="text" id="txtPrinterName" name="txtPrinterName" style="margin-left:5px;" /> -- >
							</td>
						</tr>
						<tr>
							<td style="text-align:right;">No. of Copies</td>
							<td>
								<input type="text" id="txtNoOfCopies" style="margin-left:5px;float:left; text-align:right; width:155px;" class="integerNoNegativeUnformattedNoComma">
								<div style="float: left; width: 15px;">
									<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
									<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
									<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
									<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
								</div>		
								<!-- <input type="text" id="txtNoOfCopies" name="txtNoOfCopies" style="margin-left:5px;width:67%;" /> -- >
							</td>
						</tr>
					</table>
				</div>  --> <!-- end: soaPrintFieldsDiv -->
				<div id="soaLimitsDiv" name="soaLimitsDiv" class="sectionDiv" style="border:none;width:350px; margin:5px 20px 20px 20px; ">
					<table>
						<tr>
							<td style="text-align:right;">Extract policies not over</td>
							<td><input type="text" id="txtDays" name="txtDays" maxlength="5" style="margin-left:5px; width:100px; text-align:right;" class="integerNoNegativeUnformattedNoComma" /> days</td>
						</tr>
						<tr>
							<td style="text-align:right;">Outstanding Balance >=</td>
							<td><input type="text" id="txtOutstandingBal" name="txtOutstandingBal" class="money" style="margin-left:5px; width:140px; text-align:right;" /></td>
						</tr>
					</table>
				</div>
			</div> <!-- end: printAndLimitDiv -->
		<!-- </div> --> <!-- end: combinedDivs -->
		
		<!-- <div id="soaChecksDiv" name="soaChecksDiv" class="sectionDiv" style="float:left; width:200px; margin:10px 20px 20px 220px; ">
			<table cellpadding="2" cellspacing="2">
				<tr id="trChkBreakdownTax">
					<td align="right"><input type="checkbox" id="chkBreakdownTax" name="chkBreakdownTax" /></td>
					<td colspan="2" >Breakdown Tax</td>
				</tr>
				<tr id="trChkIncludeNotDue">
					<td align="right">
						<input type="checkbox" id="chkIncludeNotDue" name="chkIncludeNotDue" /></td>
					<td colspan="2">Include Not Yet Due</td>
				</tr>
				<tr id="trChkWholdingTax">
					<td align="right"><input type="checkbox" id="chkWholdingTax" name="chkWholdingTax" /></td>
					<td colspan="2" >With witholding tax</td>
				</tr>
				<tr id="trChkIncludePDC">
					<td align="right">
						<input type="checkbox" id="chkIncludePDC" name="chkIncludePDC" /></td>
					<td colspan="2">Include PDC</td>
				</tr>
				<tr>
					<td>
						<input type="hidden" id="hidIncludePDC" name="hidIncludePDC" />
						<input type="hidden" id="hidSOARemarks" name="hidSOARemarks" />
					</td>
				</tr>
			</table>
		</div> -->
		
		<!-- <div id="soaLimitsDiv" name="soaLimitsDiv" class="sectionDiv" style="float:left; width:350px; margin:30px 20px 20px 20px; ">
			<table>
				<tr id="trSpecialPol">
					<td colspan="2"><input type="checkbox" id="chkSpecialPol" name="chkSpecialPol" style="margin-left:10px; margin-top:5px;" />&nbsp;&nbsp;&nbsp;Include Special Policies</td>
					<td></td>
				</tr>
				<tr>
					<td style="text-align:right;">Extract policies not over</td>
					<td><input type="text" id="txtDays" name="txtDays" style="margin-left:5px;" /> days</td>
				</tr>
				<tr>
					<td style="text-align:right;">Outstanding Balance >=</td>
					<td><input type="text" id="txtOutstandingBal" name="txtOutstandingBal" style="margin-left:5px;" /></td>
				</tr>
			</table>
		</div> -->
		
		<div id="soaButtonsDiv" name="soaButtonsDiv" class="buttonsDiv" style="margin: 25px 20px 30px 20px;">
			<input type="button" id="btnExtract" name="btnExtract" class="button" value="Extract" style="width:90px" />
			<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print SOA" style="width:90px;" />
			<input type="button" class="button" id="btnPrintCollLetter" name="btnPrintCollLetter" value="Print Collection Letter" style="width:160px;" />
			<input type="button" class="button" id="btnReprintCollLetter" name="btnReprintCollLetter" value="Reprint Collection Letter" style="width:160px;" />
			<!-- <input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width:90px;" /> -->
			<input type="button" class="button" id="btnRemarks" name="btnRemarks" value="Remarks" style="width:90px;" />
		</div> <!-- end: soaButtonsDiv -->
	
	</div>
</div>

<script type="text/javascript">
	
	objSOA.paramCollLetClient = null;
	var varSOAPDC = null;
	var defaultSOAParams = null;
	var soaRemarks = null;
	var varOutBal = null;
	var varSpecialPol = null;
	//var proceedToExtraction = null;
	//var proceedToTaxBreakdown = null;
	
	var tdIssueDate1HTML = $("tdIssueDate1").innerHTML;
	var tdIssueDate2HTML = $("tdIssueDate2").innerHTML;
	
	var variableLoSw = null; // holds the value for VARIABLES.LO_SW
	
	try {
		varSOAPDC = '${varSOAPDC}';   //giisp.v('IMPLEMENTATION_SW')
		defaultSOAParams = JSON.parse('${defaultSOAParams}');
		//var printerNamesList = '${printerNames}';
		soaRemarks = '${soaRemarks}';
		objSOA.paramCollLetClient = '${paramCollLetClient}';
	} catch(e){
		showErrorMessage("statementOfAccount.jsp", e);
	}
	
	function initializeFields(){
		//hidden
		$("hidSOARemarks").value = soaRemarks;
		
		if(varSOAPDC == "Y"){
			$("trChkIncludePDC").show();	
			$("chkIncludePDC").checked = true;
			$("hidIncludePDC").value = "Y";
		} else {
			$("trChkIncludePDC").hide();
			$("hidIncludePDC").value = "N";			
		}
		
		$("rdoLayout1").checked = true;
		$("rdoTranDate").checked = true;
		variableLoSw = "S";
		// TO DO: SET_ITEM_PROPERTY('MISC.license',DISPLAYED,PROPERTY_false);--issa, 02.17.2005
		$("trDateAsOf").hide();
		$("trBookDate").hide();
		$("trInceptDate").hide();
		$("trIssueDate").hide();
		
		//REPORT_TYPE RadioGroup
		//$("trRdoSOA").hide();
		
		$("trRdoLicensed").hide();
		$("trRdoUnlicensed").hide();
		$("trRdoWithNet").hide();
		$("trRdoWithoutNet").hide();
		$("trRdoSOANetComm").hide();
		$("trRdoAssdWithoutNet").hide();
		
		//CHECK_BOXES
		$("trChkWholdingTax").hide();
		//$("trChkIncludeNotDue").hide();
		$("chkIncludeNotDue").checked = true;
		
		//$("trSpecialPol").hide();
		
		// begin: set_default_dates
		$("chkBookTag").checked = defaultSOAParams.bookTag == "Y" ? true : false;
		$("chkInceptTag").checked = defaultSOAParams.incepTag == "Y" ? true : false;
		defaultSOAParams.incepTag == "Y" ? $("trSpecialPol").show() : $("trSpecialPol").hide();
		$("chkIssueTag").checked = defaultSOAParams.issueTag == "Y" ? true : false;
		
		if(nvl(defaultSOAParams.reportDate, "F") == "F"){
			$("rdoFromTo").checked = true;
			if(defaultSOAParams.dateTag == "BK"){
				$("trBookDate").show();
				$("txtBookDateTo").value = defaultSOAParams.bookDateTo == null ? "" : dateFormat(defaultSOAParams.bookDateTo, 'mm-dd-yyyy'); // == null ? "" : defaultSOAParams.bookDateTo;
				$("txtBookDateFrom").value = defaultSOAParams.bookDateFr == null ? "" : dateFormat(defaultSOAParams.bookDateFr, 'mm-dd-yyyy');
				fireEvent($("chkBookTag"), "change");
			} else if(defaultSOAParams.dateTag == "BKIN"){
				// display incept date below booking date
				$("trBookDate").show();
				$("trInceptDate").show();				
			} else if(defaultSOAParams.dateTag == "BKIS"){
				// display issue date below booking date
				$("trBookDate").show();
				//$("trInceptDate").hide();
				$("trIssueDate").show();
			} else if(defaultSOAParams.dateTag == "IS"){
				// display issue date only
				$("trIssueDate").show();
				//$("trDateAsOf").hide();
				//$("trInceptDate").hide();
			} else if(defaultSOAParams.dateTag == "IN"){
				// display incept date only
				$("trInceptDate").show();
				//$("trDateAsOf").hide();
				//$("tdCutOffDate1").hide();
				//$("tdCutOffDate2").hide();
			}
			$("trDateAsOf").hide();
		} else {
			$("rdoAsOf").checked = true;
			if($("chkBookTag").checked == false && $("chkInceptTag").checked == false && $("chkIssueTag").checked == false){
				$("trDateAsOf").hide();
				$("trBookDate").hide();
				$("trInceptDate").hide();
				$("trIssueDate").hide();
			} else {
				$("trDateAsOf").show();
				$("trBookDate").hide();
				$("trInceptDate").hide();
				$("trIssueDate").hide();
			}
		}
		/*pass the values to the items*/
		//modified by gab 10.14.2016 SR 4016
		if($("txtBookDateTo") != null){
			//$("txtBookDateTo").value = defaultSOAParams.bookDateTo == null ? "" : dateFormat(defaultSOAParams.bookDateTo, 'mm-dd-yyyy');
			//$("txtBookDateFrom").value = defaultSOAParams.bookDateFr == null ? "" : dateFormat(defaultSOAParams.bookDateFr, 'mm-dd-yyyy');
			$("txtBookDateTo").value = defaultSOAParams.dspBookDateTo == null ? "" : defaultSOAParams.dspBookDateTo;
			$("txtBookDateFrom").value = defaultSOAParams.dspBookDateFr == null ? "" : defaultSOAParams.dspBookDateFr;
		}
		if($("txtIncepDateTo") != null){
			//$("txtIncepDateTo").value = defaultSOAParams.incepDateTo == null ? "" : dateFormat(defaultSOAParams.incepDateTo, 'mm-dd-yyyy');
			//$("txtIncepDateFrom").value = defaultSOAParams.incepDateFr == null ? "" : dateFormat(defaultSOAParams.incepDateFr, 'mm-dd-yyyy');
			$("txtIncepDateTo").value = defaultSOAParams.dspIncepDateTo == null ? "" : defaultSOAParams.dspIncepDateTo;
			$("txtIncepDateFrom").value = defaultSOAParams.dspIncepDateFr == null ? "" : defaultSOAParams.dspIncepDateFr;
		}
		if($("txtIssueDateTo") != null){
			//$("txtIssueDateTo").value = defaultSOAParams.issueDateTo == null ? "" : dateFormat(defaultSOAParams.issueDateTo, 'mm-dd-yyyy');
			//$("txtIssueDateFrom").value = defaultSOAParams.issueDateFr == null ? "" : dateFormat(defaultSOAParams.issueDateFr, 'mm-dd-yyyy');
			$("txtIssueDateTo").value = defaultSOAParams.dspIssueDateTo == null ? "" : defaultSOAParams.dspIssueDateTo;
			$("txtIssueDateFrom").value = defaultSOAParams.dspIssueDateFr == null ? "" : defaultSOAParams.dspIssueDateFr;
		}
		if($("txtAsOfDate") != null){
			//$("txtAsOfDate").value = defaultSOAParams.asOfDate == null ? "" : dateFormat(defaultSOAParams.asOfDate, 'mm-dd-yyyy');
			$("txtAsOfDate").value = defaultSOAParams.dspAsOfDate == null ? "" : defaultSOAParams.dspAsOfDate;
		}
		if($("txtCutOffDate") != null){
			//$("txtCutOffDate").value = defaultSOAParams.cutOffDate == null ? "" : dateFormat(defaultSOAParams.cutOffDate, 'mm-dd-yyyy');	
			$("txtCutOffDate").value = defaultSOAParams.dspCutOffDate == null ? "" : defaultSOAParams.dspCutOffDate;
		}
		
		if(defaultSOAParams.branchCd != null && defaultSOAParams.branchName != null){
			$("txtBranchCd").value = defaultSOAParams.branchCd;
			$("txtBranch").value = unescapeHTML2(defaultSOAParams.branchName);
		} else if(defaultSOAParams.branchCd == null){
			$("txtBranchCd").value = "";
			$("txtBranch").value = "All Branches";
		}
		if(defaultSOAParams.intmType != null && defaultSOAParams.intmTypeDesc != null){
			$("trIntmType").show();
			$("trIntmNo").show();
			$("trAssdNo").hide();
			$("rdoByIntermediary").checked = true;
			$("txtIntmType").value = defaultSOAParams.intmType;
			$("txtIntmDesc").value = unescapeHTML2(defaultSOAParams.intmTypeDesc);
		}
		if(defaultSOAParams.intmNo != null && defaultSOAParams.intmName != null){
			$("trIntmType").show();
			$("trIntmNo").show();
			$("trAssdNo").hide();
			$("rdoByIntermediary").checked = true;
			$("txtIntmNo").value = defaultSOAParams.intmNo;
			$("txtIntmName").value = unescapeHTML2(defaultSOAParams.intmName);
		}
		if(defaultSOAParams.assdNo != null && defaultSOAParams.assdName != null){
			$("trIntmType").hide();
			$("trIntmNo").hide();
			$("trAssdNo").show();
			$("rdoByAssured").checked = true;
			$("txtAssdNo").value = defaultSOAParams.assdNo;
			$("txtAssdName").value = unescapeHTML2(defaultSOAParams.assdName);
		}
		
		if(defaultSOAParams.intmNo == null && defaultSOAParams.intmType == null && defaultSOAParams.assdNo == null){
			$("trIntmType").show();
			$("trIntmNo").show();
			$("trAssdNo").hide();	
			$("rdoByIntermediary").checked = true;
		}
		
		if(defaultSOAParams.extractAgingDays != null && defaultSOAParams.extractAgingDays != ""){
			$("txtDays").value = defaultSOAParams.extractAgingDays;
		}
		// end: set_default_dates
		
		//PRINT
		/*$("printerName").disabled = true;
		$("txtNoOfCopies").disabled = true;
		$("rdoPdf").checked = true;*/
		
		$$("input[name='rdoPaymentDate']").each(function(rb){
			if (defaultSOAParams.paytDate == rb.value){
				rb.checked = true;
			}
		});
		
		$$("input[name='rdoBranch']").each(function(rb){
			if (defaultSOAParams.branchParam == rb.value){
				rb.checked = true;
			}
		});
		
		if(objSOA.prevParams != null && (objSOA.prevParams.prevPage == "printCollectionLetter" || objSOA.prevParams.prevPage == "reprintCollectionLetter")){
			// i-assign ung mga params na pinili before lumipat ng page
			restorePrevParams();
		}
	}
	
	function restorePrevParams(){
		$("chkBookTag").checked  	= objSOA.prevParams.chkBookTag == "Y" ? true : false;
		$("chkInceptTag").checked  	= objSOA.prevParams.chkInceptTag == "Y" ? true : false;
		$("chkIssueTag").checked  	= objSOA.prevParams.chkIssueTag == "Y" ? true : false;
		if($("chkInceptTag").checked){
			$("trSpecialPol").show();
			$("chkSpecialPol").checked = objSOA.prevParams.chkSpecialPol == "Y" ? true : false;
		}
		
		$("rdoAsOf").checked = objSOA.prevParams.reportDate == "asOf" ? true : false;
		$("rdoFromTo").checked = objSOA.prevParams.reportDate == "fromTo" ? true : false;
		if($("rdoAsOf").checked){
			$("rdoAsOf").click();
		} else if($("rdoFromTo").checked){
			$("rdoFromTo").click();
		}
		
		/* if($("chkBookTag").checked){
			$("chkBookTag").click();
		} 
		if($("chkInceptTag").checked){
			$("chkInceptTag").click();
		}
		if($("chkIssueTag").checked){
			$("chkIssueTag").click();
		} */
		
		$("txtAsOfDate").value = objSOA.prevParams.asOfDate;
		$("txtBookDateFrom").value = objSOA.prevParams.bookDateFrom;
		$("txtBookDateTo").value = objSOA.prevParams.bookDateTo;
		$("txtIncepDateFrom").value = objSOA.prevParams.inceptDateFrom;
		$("txtIncepDateTo").value = objSOA.prevParams.inceptDateTo;
		$("txtIssueDateFrom").value = objSOA.prevParams.issueDateFrom;
		$("txtIssueDateTo").value = objSOA.prevParams.issueDateTo;
		$("txtCutOffDate").value = objSOA.prevParams.cutOffDate;
		
		// PRINT_REPORT_BY
		$("rdoByIntermediary").checked 	= objSOA.prevParams.printReportBy == "intermediary" ? true : false;
		$("rdoByAssured").checked 		= objSOA.prevParams.printReportBy == "assured" ? true : false;
		$("rdoByLicense").checked 		= objSOA.prevParams.printReportBy == "license" ? true : false;
		if($("rdoByIntermediary").checked){
			$("rdoByIntermediary").click();
		} else if($("rdoByAssured").checked){
			$("rdoByAssured").click();
		} else if($("rdoByLicense").checked){
			$("rdoByLicense").click();
		}
		
		$("rdoLayout1").checked			= objSOA.prevParams.layoutType == "1" ? true : false;
		$("rdoLayout2").checked			= objSOA.prevParams.layoutType == "2" ? true : false;
		$("rdoLayout3").checked			= objSOA.prevParams.layoutType == "3" ? true : false;
		if($("rdoLayout1").checked){
			$("rdoLayout1").click();
		} else if($("rdoLayout2").checked){
			$("rdoLayout2").click();
		} else if($("rdoLayout3").checked){
			$("rdoLayout3").click();
		}
		
		// REPORT_TYPE
		$("rdoSummary").checked 		= objSOA.prevParams.reportType == "summary" ? true : false;
		$("rdoDetail").checked 			= objSOA.prevParams.reportType == "detail" ? true : false;
		$("rdoTaxBreakdown").checked 	= objSOA.prevParams.reportType == "taxBreakdown" ? true : false;
		$("rdoStatement").checked 		= objSOA.prevParams.reportType == "statement" ? true : false;
		$("rdoLicensed").checked 		= objSOA.prevParams.reportType == "licensed" ? true : false;
		$("rdoUnlicensed").checked 		= objSOA.prevParams.reportType == "unlicensed" ? true : false;
		$("rdoWithNet").checked 		= objSOA.prevParams.reportType == "withNet" ? true : false;
		$("rdoWithoutNet").checked 		= objSOA.prevParams.reportType == "withoutNet" ? true : false;
		$("rdoSOANetComm").checked 		= objSOA.prevParams.reportType == "soaNetComm" ? true : false;
		$("rdoAssdWithoutNet").checked 	= objSOA.prevParams.reportType == "assdWithoutNet" ? true : false;
		
		$("rdoIssuing").checked 		= objSOA.prevParams.branchOfPolicy == "issuing" ? true : false;
		$("rdoCrediting").checked 		= objSOA.prevParams.branchOfPolicy == "crediting" ? true : false;
		
		$("chkBreakdownTax").checked 	= objSOA.prevParams.chkBreakdownTax == "Y" ? true : false;
		$("chkIncludeNotDue").checked 	= objSOA.prevParams.chkIncludeNotDue == "Y" ? true : false;
		$("chkIncludePDC").checked 		= objSOA.prevParams.chkIncludePDC == "Y" ? true : false;
		$("chkWholdingTax").checked 	= objSOA.prevParams.chkWholdingTax == "Y" ? true : false;
		
		$("txtDays").value = objSOA.prevParams.extractDays;
		$("txtOutstandingBal").value = formatCurrency(objSOA.prevParams.outstandingBal);
	}
	
	/*function insertPrinterNames(){
		var printerNames = $F("printerNames");
		var printers	 = printerNames.split(",");
		var selectContent = "<option value=''></option>";
		for (var i=0; i<printers.length; i++){
			//selectContent = selectContent + "<option value='"+printers[i].toUpperCase()+"'>"+printers[i].toUpperCase()+"</option>";
			selectContent = selectContent + "<option value='"+printers[i]+"'>"+printers[i]+"</option>";
		}
		$("printerName").update(selectContent);
	}*/
	
	// executes get_extract_date procedure
	function getExtractDate(){
		var proceedToExtraction = false;
		try {
			new Ajax.Request(contextPath + "/GIACCreditAndCollectionReportsController",{
				parameters : {
					action : "getExtractDate",
					reportDate : $("rdoFromTo").checked ? "F" : "A"  //defaultSOAParams.reportDate
				},
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						var extractParams = JSON.parse(response.responseText);
						var paytDate = ($("rdoTranDate").checked ? "T" : "P");
						var branchParam = $("rdoIssuing").checked ? "I" : "C";	//SR-4720 : shan 06.24.2015
						
						//check_date_ext procedure
						if($("rdoFromTo").checked){
							if($("chkBookTag").checked == true && $("chkInceptTag").checked == true){
								if($F("txtCutOffDate") == dateFormat(extractParams.cutOffDate, 'mm-dd-yyyy')
										&& $F("txtBookDateFrom") == dateFormat(extractParams.bookDateFr, 'mm-dd-yyyy') && $F("txtBookDateTo") == dateFormat(extractParams.bookDateTo, 'mm-dd-yyyy')
										&& $F("txtIncepDateFrom") == dateFormat(extractParams.incepDateFr, 'mm-dd-yyyy') && $F("txtIncepDateTo") == dateFormat(extractParams.incepDateTo, 'mm-dd-yyyy')
										&& extractParams.issueDateFr == null && extractParams.issueDateTo == null
										&& nvl($F("txtBranchCd"), "NONE") == nvl(extractParams.branchCd, "NONE") 
										&& parseInt(nvl($F("txtIntmNo"), -1)) == parseInt(nvl(extractParams.intmNo, -1)) 
						
										&& nvl($F("txtIntmType"), "NONE") == nvl(extractParams.intmType, "NONE") 
										&& parseInt(nvl($F("txtAssdNo"), -1)) == parseInt(nvl(extractParams.assdNo, -1))
										&& ($("chkSpecialPol").checked == false && extractParams.incSpecialPol == "N")
										&& paytDate == extractParams.paytDate
										&& branchParam == extractParams.branchParam){	//SR-4720 : shan 06.24.2015
											showConfirmBox("Aging Extract",
													   "The data within the extract parameters have already been extracted. \nDo you wish to continue anyway?",
													   "Yes", "No",
													   function(){ extractRecords(); },  //function for YES
													   function(){ proceedToExtraction = false; }, //function for NO
													   "");
								} else {
									extractRecords();
								}
							} else if($("chkBookTag").checked == true && $("chkIssueTag").checked == true){
								if($F("txtCutOffDate") == dateFormat(extractParams.cutOffDate, 'mm-dd-yyyy') 
										&& $F("txtBookDateFrom") == dateFormat(extractParams.bookDateFr, 'mm-dd-yyyy') && $F("txtBookDateTo") == dateFormat(extractParams.bookDateTo, 'mm-dd-yyyy')
										&& $F("txtIssueDateFrom") == dateFormat(extractParams.issueDateFr, 'mm-dd-yyyy') && $F("txtIssueDateTo") == dateFormat(extractParams.issueDateTo, 'mm-dd-yyyy')
										&& extractParams.incepDateFr == null && extractParams.incepDateTo == null
										&& nvl($F("txtBranchCd"), "NONE") == nvl(extractParams.branchCd, "NONE") 
										&& parseInt(nvl($F("txtIntmNo"), -1)) == parseInt(nvl(extractParams.intmNo, -1)) 
										&& nvl($F("txtIntmType"), "NONE") == nvl(extractParams.intmType, "NONE") 
										&& parseInt(nvl($F("txtAssdNo"), -1)) == parseInt(nvl(extractParams.assdNo, -1))
										&& ($("chkSpecialPol").checked == false && extractParams.incSpecialPol == "N") 
										&& paytDate == extractParams.paytDate
										&& branchParam == extractParams.branchParam){	//SR-4720 : shan 06.24.2015
											showConfirmBox("Aging Extract",
													   "The data within the extract parameters have already been extracted. \nDo you wish to continue anyway?",
													   "Yes", "No",
													   function(){ extractRecords(); },  //function for YES
													   function(){ proceedToExtraction = false; }, //function for NO
													   "");
								} else {
									extractRecords();
								}
							} else if($("chkBookTag").checked == true){
								/*var test = dateFormat(extractParams.cutOffDate, 'mm-dd-yyyy');
								var message = $F("txtCutOffDate") + " == " + test + "\n";
								test =  dateFormat(extractParams.bookDateFr, 'mm-dd-yyyy');
								message = message + $F("txtBookDateFrom") + " == " + test + "\n";
								test =  dateFormat(extractParams.bookDateTo, 'mm-dd-yyyy');
								message = message + $F("txtBookDateTo") + " == " + test + "\n";
								test =  extractParams.incepDateFr;
								message = message + "null" + " == " + test + "\n";
								test = extractParams.incepDateTo;
								message = message + "null" + " == " + test + "\n";
								test = nvl(extractParams.branchCd, "NONE") ;
								message = message + nvl($F("txtBranchCd"), "NONE") + " == " + test + "\n";
								test = parseInt(nvl(extractParams.intmNo, -1));
								message = message + parseInt(nvl($F("txtIntmNo"), -1)) + " == " + test + "\n";
								test = nvl(extractParams.intmType, "NONE");
								message = message + nvl($F("txtIntmType"), "NONE") + " == " + test + "\n";
								test = parseInt(nvl(extractParams.assdNo, -1));
								message = message + parseInt(nvl($F("txtAssdNo"), -1)) + " == " + test + "\n";
								test = extractParams.incSpecialPol;
								message = message + $("chkSpecialPol").checked + " == " + test + "\n";
								*/
								
								if($F("txtCutOffDate") == dateFormat(extractParams.cutOffDate, 'mm-dd-yyyy') 
										&& $F("txtBookDateFrom") == dateFormat(extractParams.bookDateFr, 'mm-dd-yyyy') && $F("txtBookDateTo") == dateFormat(extractParams.bookDateTo, 'mm-dd-yyyy')
										&& extractParams.incepDateFr == null && extractParams.incepDateTo == null
										&& extractParams.issueDateFr == null && extractParams.issueDateTo == null
										&& nvl($F("txtBranchCd"), "NONE") == nvl(extractParams.branchCd, "NONE") 
										&& parseInt(nvl($F("txtIntmNo"), -1)) == parseInt(nvl(extractParams.intmNo, -1)) 
										&& nvl($F("txtIntmType"), "NONE") == nvl(extractParams.intmType, "NONE") 
										&& parseInt(nvl($F("txtAssdNo"), -1)) == parseInt(nvl(extractParams.assdNo, -1))
										&& ($("chkSpecialPol").checked == false && extractParams.incSpecialPol == "N") 
										&& paytDate == extractParams.paytDate
										&& branchParam == extractParams.branchParam){	//SR-4720 : shan 06.24.2015
									showConfirmBox("Aging Extract",
													   "The data within the extract parameters have already been extracted. \nDo you wish to continue anyway?",
													   "Yes", "No",
													   function(){ extractRecords(); },  //function for YES
													   function(){ proceedToExtraction = false; }, //function for NO
													   "");
								} else {
									extractRecords();
								}
							} else if($("chkIssueTag").checked == true){
								if($F("txtCutOffDate") == dateFormat(extractParams.cutOffDate, 'mm-dd-yyyy') 
										&& $F("txtIssueDateFrom") == dateFormat(extractParams.issueDateFr, 'mm-dd-yyyy') && $F("txtIssueDateTo") == dateFormat(extractParams.issueDateTo, 'mm-dd-yyyy')
										&& extractParams.incepDateFr == null && extractParams.incepDateTo == null
										&& extractParams.bookDateFr == null && extractParams.bookDateTo == null
										&& nvl($F("txtBranchCd"), "NONE") == nvl(extractParams.branchCd, "NONE") 
										&& parseInt(nvl($F("txtIntmNo"), -1)) == parseInt(nvl(extractParams.intmNo, -1)) 
										&& nvl($F("txtIntmType"), "NONE") == nvl(extractParams.intmType, "NONE") 
										&& parseInt(nvl($F("txtAssdNo"), -1)) == parseInt(nvl(extractParams.assdNo, -1))
										&& ($("chkSpecialPol").checked == false && extractParams.incSpecialPol == "N") 
										&& paytDate == extractParams.paytDate
										&& branchParam == extractParams.branchParam){	//SR-4720 : shan 06.24.2015
									showConfirmBox("Aging Extract",
													   "The data within the extract parameters have already been extracted. \nDo you wish to continue anyway?",
													   "Yes", "No",
													   function(){ extractRecords(); },  //function for YES
													   function(){ proceedToExtraction = false; }, //function for NO
													   "");
								} else {
									extractRecords();
								}
							} else if($("chkInceptTag").checked == true){
								if($F("txtCutOffDate") == dateFormat(extractParams.cutOffDate, 'mm-dd-yyyy') 
										&& $F("txtIncepDateFrom") == dateFormat(extractParams.incepDateFr, 'mm-dd-yyyy') && $F("txtIncepDateTo") == dateFormat(extractParams.incepDateTo, 'mm-dd-yyyy')
										&& extractParams.issueDateFr == null && extractParams.issueDateTo == null
										&& extractParams.bookDateFr == null && extractParams.bookDateTo == null
										&& nvl($F("txtBranchCd"), "NONE") == nvl(extractParams.branchCd, "NONE") 
										&& parseInt(nvl($F("txtIntmNo"), -1)) == parseInt(nvl(extractParams.intmNo, -1)) 
										&& nvl($F("txtIntmType"), "NONE") == nvl(extractParams.intmType, "NONE") 
										&& parseInt(nvl($F("txtAssdNo"), -1)) == parseInt(nvl(extractParams.assdNo, -1))
										&& ($("chkSpecialPol").checked == false && extractParams.incSpecialPol == "N") 
										&& paytDate == extractParams.paytDate
										&& branchParam == extractParams.branchParam){	//SR-4720 : shan 06.24.2015
									showConfirmBox("Aging Extract",
													   "The data within the extract parameters have already been extracted. \nDo you wish to continue anyway?",
													   "Yes", "No",
													   function(){ extractRecords(); },  //function for YES
													   function(){ proceedToExtraction = false; }, //function for NO
													   "");
								} else {
									extractRecords();
								}
							} else {
								return null;
							}
						} // end of: $("rdoFromTo").checked == true
						else {
							if($("chkBookTag").checked == true && $("chkInceptTag").checked == true){
								if($F("txtCutOffDate") == dateFormat(extractParams.cutOffDate, 'mm-dd-yyyy') 
										&& $F("txtAsOfDate") == dateFormat(extractParams.asOfDate, 'mm-dd-yyyy') && extractParams.dateTag == "BKIN"
										&& nvl($F("txtBranchCd"), "NONE") == nvl(extractParams.branchCd, "NONE") 
										&& parseInt(nvl($F("txtIntmNo"), -1)) == parseInt(nvl(extractParams.intmNo, -1)) 
										&& nvl($F("txtIntmType"), "NONE") == nvl(extractParams.intmType, "NONE") 
										&& parseInt(nvl($F("txtAssdNo"), -1)) == parseInt(nvl(extractParams.assdNo, -1))
										&& ($("chkSpecialPol").checked == false && extractParams.incSpecialPol == "N") 
										&& paytDate == extractParams.paytDate
										&& branchParam == extractParams.branchParam){	//SR-4720 : shan 06.24.2015
									showConfirmBox("Aging Extract",
													   "The data within the extract parameters have already been extracted. \nDo you wish to continue anyway?",
													   "Yes", "No",
													   function(){ extractRecords(); },  //function for YES
													   function(){ proceedToExtraction = false; }, //function for NO
													   "");
								} else {
									extractRecords();
								}
							} else if($("chkBookTag").checked == true && $("chkIssueTag").checked == true){
								if($F("txtCutOffDate") == dateFormat(extractParams.cutOffDate, 'mm-dd-yyyy') 
										&& $F("txtAsOfDate") == dateFormat(extractParams.asOfDate, 'mm-dd-yyyy') && extractParams.dateTag == "BKIS"
										&& nvl($F("txtBranchCd"), "NONE") == nvl(extractParams.branchCd, "NONE") 
										&& parseInt(nvl($F("txtIntmNo"), -1)) == parseInt(nvl(extractParams.intmNo, -1)) 
										&& nvl($F("txtIntmType"), "NONE") == nvl(extractParams.intmType, "NONE") 
										&& parseInt(nvl($F("txtAssdNo"), -1)) == parseInt(nvl(extractParams.assdNo, -1))
										&& ($("chkSpecialPol").checked == false && extractParams.incSpecialPol == "N") 
										&& paytDate == extractParams.paytDate
										&& branchParam == extractParams.branchParam){	//SR-4720 : shan 06.24.2015
									showConfirmBox("Aging Extract",
													   "The data within the extract parameters have already been extracted. \nDo you wish to continue anyway?",
													   "Yes", "No",
													   function(){ extractRecords(); },  //function for YES
													   function(){ proceedToExtraction = false; }, //function for NO
													   "");
								} else {
									extractRecords();
								}
							} else if($("chkBookTag").checked == true){
								if($F("txtCutOffDate") == dateFormat(extractParams.cutOffDate, 'mm-dd-yyyy') 
										&& $F("txtAsOfDate") == dateFormat(extractParams.asOfDate, 'mm-dd-yyyy') && extractParams.dateTag == "BK"
										&& nvl($F("txtBranchCd"), "NONE") == nvl(extractParams.branchCd, "NONE") 
										&& parseInt(nvl($F("txtIntmNo"), -1)) == parseInt(nvl(extractParams.intmNo, -1)) 
										&& nvl($F("txtIntmType"), "NONE") == nvl(extractParams.intmType, "NONE") 
										&& parseInt(nvl($F("txtAssdNo"), -1)) == parseInt(nvl(extractParams.assdNo, -1))
										&& ($("chkSpecialPol").checked == false && extractParams.incSpecialPol == "N") 
										&& paytDate == extractParams.paytDate
										&& branchParam == extractParams.branchParam){	//SR-4720 : shan 06.24.2015
									showConfirmBox("Aging Extract",
													   "The data within the extract parameters have already been extracted. \nDo you wish to continue anyway?",
													   "Yes", "No",
													   function(){ extractRecords(); },  //function for YES
													   function(){ proceedToExtraction = false; }, //function for NO
													   "");
								} else {
									extractRecords();
								}
							} else if($("chkIssueTag").checked == true){
								if($F("txtCutOffDate") == dateFormat(extractParams.cutOffDate, 'mm-dd-yyyy') 
										&& $F("txtAsOfDate") == dateFormat(extractParams.asOfDate, 'mm-dd-yyyy') && extractParams.dateTag == "IS"
										&& nvl($F("txtBranchCd"), "NONE") == nvl(extractParams.branchCd, "NONE") 
										&& parseInt(nvl($F("txtIntmNo"), -1)) == parseInt(nvl(extractParams.intmNo, -1)) 
										&& nvl($F("txtIntmType"), "NONE") == nvl(extractParams.intmType, "NONE") 
										&& parseInt(nvl($F("txtAssdNo"), -1)) == parseInt(nvl(extractParams.assdNo, -1))
										&& ($("chkSpecialPol").checked == false && extractParams.incSpecialPol == "N") 
										&& paytDate == extractParams.paytDate
										&& branchParam == extractParams.branchParam){	//SR-4720 : shan 06.24.2015
									showConfirmBox("Aging Extract",
													   "The data within the extract parameters have already been extracted. \nDo you wish to continue anyway?",
													   "Yes", "No",
													   function(){ extractRecords(); },  //function for YES
													   function(){ proceedToExtraction = false; }, //function for NO
													   "");
								} else {
									extractRecords();
								}
							} else if($("chkInceptTag").checked == true){
								if($F("txtCutOffDate") == dateFormat(extractParams.cutOffDate, 'mm-dd-yyyy') 
										&& $F("txtAsOfDate") == dateFormat(extractParams.asOfDate, 'mm-dd-yyyy') && extractParams.dateTag == "IN"
										&& nvl($F("txtBranchCd"), "NONE") == nvl(extractParams.branchCd, "NONE") 
										&& parseInt(nvl($F("txtIntmNo"), -1)) == parseInt(nvl(extractParams.intmNo, -1)) 
										&& nvl($F("txtIntmType"), "NONE") == nvl(extractParams.intmType, "NONE") 
										&& parseInt(nvl($F("txtAssdNo"), -1)) == parseInt(nvl(extractParams.assdNo, -1))
										&& ($("chkSpecialPol").checked == false && extractParams.incSpecialPol == "N") 
										&& paytDate == extractParams.paytDate
										&& branchParam == extractParams.branchParam){	//SR-4720 : shan 06.24.2015
									showConfirmBox("Aging Extract",
													   "The data within the extract parameters have already been extracted. \nDo you wish to continue anyway?",
													   "Yes", "No",
													   function(){ extractRecords(); },  //function for YES
													   function(){ proceedToExtraction = false; }, //function for NO
													   "");
								} else {
									extractRecords();
								}
							} else {
								showMessageBox("No more conditions to execute.", "I");
							}
						} 
					}
				}
			});
		} catch(e){
			showErrorMessage("getExtractDate", e);
		}
		return proceedToExtraction;
	}
	
	function extractRecords(){
		varOutBal = $F("txtOutstandingBal");
		$("txtOutstandingBal").value = "";
		
		try{
			new Ajax.Request(contextPath + "/GIACCreditAndCollectionReportsController",{
				parameters : {
					action 		: "extractRecords",
					specialPol	: ($("chkSpecialPol").checked ? "Y" : "N"),
					branchCd	: $F("txtBranchCd"),
					intmNo		: $F("txtIntmNo"),
					intmType	: $F("txtIntmType"),
					assdNo		: $F("txtAssdNo"),
					reportDate	: ($("rdoFromTo").checked ? "F" : "A"), //defaultSOAParams.reportDate,
					bookTag		: ($("chkBookTag").checked ? "Y" : "N"),
					bookDateFr	: $F("txtBookDateFrom"), //($("txtBookDateFrom") == null ? dateFormat(defaultSOAParams.bookDateFr, 'mm-dd-yyyy') : $F("txtBookDateFrom")),
					bookDateTo	: $F("txtBookDateTo"), //($("txtBookDateTo") == null ? dateFormat(defaultSOAParams.bookDateTo, 'mm-dd-yyyy') : $F("txtBookDateTo")),
					incepTag	: ($("chkInceptTag").checked ? "Y" : "N"),
					incepDateFr	: $F("txtIncepDateFrom"), //($("txtIncepDateFrom") == null ? dateFormat(defaultSOAParams.incepDateFr, 'mm-dd-yyyy') : $F("txtIncepDateFrom")),
					incepDateTo	: $F("txtIncepDateTo"), //($("txtIncepDateTo") == null ? dateFormat(defaultSOAParams.incepDateTo, 'mm-dd-yyyy') : $F("txtIncepDateTo")),
					issueTag	: ($("chkIssueTag").checked ? "Y" : "N"),
					issueDateFr	: $F("txtIssueDateFrom"), //($("txtIssueDateFrom") == null ? dateFormat(defaultSOAParams.issueDateFr, 'mm-dd-yyyy') : $F("txtIssueDateFrom")),
					issueDateTo	: $F("txtIssueDateTo"), //($("txtIssueDateTo") == null ? dateFormat(defaultSOAParams.issueDateTo, 'mm-dd-yyyy') : $F("txtIssueDateTo")),
					dateAsOf	: $F("txtAsOfDate"), //($("txtAsOfDate") == null ? dateFormat(defaultSOAParams.asOfDate, 'mm-dd-yyyy') : $F("txtAsOfDate")),
					cutOffDate	: $F("txtCutOffDate"), //($("txtCutOffDate") == null ? dateFormat(defaultSOAParams.cutOffDate, 'mm-dd-yyyy') : $F("txtCutOffDate")),
					includePDC	: ($("chkIncludePDC") == null ? "N"/*$F("hidIncludePDC")*/ : ($("chkIncludePDC").checked ? "Y" : "N")),
					extractDays	: $F("txtDays"), //defaultSOAParams.extractAgingDays,
					branchParam	: $("rdoIssuing").checked ? "I" : "C", //defaultSOAParams.branchParam
					outstandingBal : $F("txtOutstandingBal"),
					paytDate:		($("rdoTranDate").checked ? "T" : "P")
				},
				onCreate: function(){
					showNotice("Extracting, please wait...");
				},
				onComplete : function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						//proceedToTaxBreakdown = false;
						var params = JSON.parse(response.responseText);
						defaultSOAParams = JSON.parse(response.responseText);	// SR-4129 : shan 06.19.2015
						if(params.message == "SUCCESS"){
							//proceedToTaxBreakdown = true;
							//showMessageBox("Extraction finished! " + params.rowCounter +"  records extracted.", "I");
							showWaitingMessageBox("Extraction finished! " + params.rowCounter +"  records extracted.", 
												  "info", 
												  function(){
														if($("chkBreakdownTax").checked == true){
															breakdownTaxPayments();
														} else {
															showConfirmBox("Confirm Tax Breakdown", 
																	   	   "Do you want to break down the taxes? This option is used by SOA report with tax breakdown. ('No' is recommended)", 
																	       "Yes", "No", 
																	       breakdownTaxPayments,
																		   "", //function(){ }, //function for NO 
																		   "");
														} 
													});
						} else {
							showMessageBox(params.message, "I");							
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("extractRecords", e);
		}
	}
	
	function breakdownTaxPayments(){
		try{
			new Ajax.Request(contextPath + "/GIACCreditAndCollectionReportsController",{
				parameters : {
					action : "breakdownTaxPayments",
					cutOffDate : $F("txtCutOffDate"),
					paytDate:		($("rdoTranDate").checked ? "T" : "P")
				},
				onCreate : function(){
					showNotice("Breaking down the tax payments, please wait...");
				},
				onComplete : function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						showMessageBox(response.responseText, "I");
						
						varSpecialPol = $("chkSpecialPol").checked ? "Y" : "N";
						setDefaultDates();
					}
				}
			});
		} catch (e) {
			showErrorMessage("breakdownTaxPayments", e);
		}
	}
	
	//executes set_default_dates1 procedure
	function setDefaultDates(){
		try{
			new Ajax.Request(contextPath + "/GIACCreditAndCollectionReportsController",{
				parameters : {
					action : "setDefaultDates",
					reportDate : ($("rdoFromTo").checked ? "F" : "A")
				},
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						var params = JSON.parse(response.responseText);
						if(params.message != "" && params.message != null){
							showMessageBox(params.message, "I");
							return true;
						}
						
						if($("rdoFromTo").checked){
							$("trBookDate").show();
							if($("chkBookTag").checked && $("chkInceptTag").checked){
								$("trInceptDate").show();								
							} else if($("chkBookTag").checked && $("chkIssueTag").checked){
								$("trIssueDate").show();
							} else if($("chkIssueTag").checked){
								$("trBookDate").hide();
								$("trIssueDate").show();
							} else if($("chkInceptTag").checked){
								$("trBookDate").hide();
								$("trInceptDate").show();
							} else if($("chkBookTag").checked == false){
								$("trBookDate").hide();
							}
							$("trDateAsOf").hide();
						} else {  // rdoAsOf is selected
							if($("chkBookTag").checked == false && $("chkInceptTag").checked == false && $("chkIssueTag").checked == false){
								$("trDateAsOf").hide();
								$("trBookDate").hide();
								$("trIssueDate").hide();
								$("trInceptDate").hide();	
							} else {
								$("trDateAsOf").show();
								$("trBookDate").hide();
								$("trIssueDate").hide();
								$("trInceptDate").hide();
							}
						}
						/*pass the values to the items*/
						$("txtBookDateFr").value = dateFormat(params.bookDateFr, 'mm-dd-yyyy');
						$("txtBookDateTo").value = dateFormat(params.bookDateTo, 'mm-dd-yyyy');
						$("txtIncepDateFr").value = dateFormat(params.incepDateFr, 'mm-dd-yyyy');
						$("txtIncepDateTo").value = dateFormat(params.incepDateTo, 'mm-dd-yyyy');
						$("txtIssueDateFr").value = dateFormat(params.issueDateFr, 'mm-dd-yyyy');
						$("txtIssueDateTo").value = dateFormat(params.issueDateTo, 'mm-dd-yyyy');
						$("txtAsOfDate").value = dateFormat(params.asOfDate, 'mm-dd-yyyy');
						$("txtCutOffDate").value = dateFormat(params.cutOffDate, 'mm-dd-yyyy');
					}
				}
			});
		} catch (e) {
			showErrorMessage("setDefaultDates", e);
		}
	}
	
	function showGIACS180BranchLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getGIACS180BranchCdLov",
				moduleId: "GIACS180",
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : "%")
			},
			title: "List of Branches",
			width: 405,
			height: 388,
			columnModel : [
			               {
			            	   id : "issCd",
			            	   title: "Code",
			            	   width: '80px'
			               },			               
			               {
			            	   id: "issName",
			            	   title: "Branch",
			            	   width: '308px'
			               }
			              ],
			draggable: true,
			filterText: ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : "%"), //findText,
			autoSelectOneRecord: true,
			onSelect: function(row) {
					$("txtBranchCd").value = unescapeHTML2(row.issCd);
					$("txtBranch").value = unescapeHTML2(row.issName);
					$("txtBranchCd").setAttribute("lastValidValue", row.issCd);
			},
	  		onCancel: function(){
	  			$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
	  		},
	  		onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}
	
	function showGIACS180IntmTypeLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "getIntmType2LOV",
				filterText : ($("txtIntmType").readAttribute("lastValidValue").trim() != $F("txtIntmType").trim() ? $F("txtIntmType").trim() : "%")
			},
			title: "Valid values for Intermediary Type",
			width: 405,
			height: 386,
			columnModel:[
			             	{	id : "intmType",
								title: "Intm Type",
								width: '80px'
							},
							{	id : "intmDesc",
								title: "Intm Description",
								width: '308px'
							}
						],
			draggable: true,
			filterText : ($("txtIntmType").readAttribute("lastValidValue").trim() != $F("txtIntmType").trim() ? $F("txtIntmType").trim() : "%"),
			autoSelectOneRecord: true,
			onSelect : function(row){
				if(row != undefined) {
					$("txtIntmType").value = unescapeHTML2(row.intmType);
					$("txtIntmDesc").value = unescapeHTML2(row.intmDesc);
					$("txtIntmType").setAttribute("lastValidValue", row.intmType);
					$("txtIntmNo").clear();
					$("txtIntmName").value = "All Intermediaries";
					$("txtIntmNo").setAttribute("lastValidValue", "");
				}
			},
	  		onCancel: function(){
	  			$("txtIntmType").value = $("txtIntmType").readAttribute("lastValidValue");
	  		},
	  		onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtIntmType").value = $("txtIntmType").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});		
	}
	
	function showGIACS180IntmNoLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "getGIACS180IntmNoLOV",
				intmType : $F("txtIntmType"),
				filterText : ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : "%")
			},
			title: "List of Intermediaries",
			width: 405,
			height: 386,
			columnModel:[
			             	{	id : "intmNo",
								title: "Intm No",
								width: '80px'
							},
							{	id : "intmName",
								title: "Intm Name",
								width: '308px'
							}
						],
			draggable: true,
			filterText : ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : "%"),
			autoSelectOneRecord: true,
			onSelect : function(row){
				if(row != undefined) {
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmName").value = unescapeHTML2(row.intmName);
					$("txtIntmNo").setAttribute("lastValidValue", row.intmNo);
				}
			},
	  		onCancel: function(){
	  			$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
	  		},
	  		onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});		
	}
	
	function showGIACS180AssuredLOV(findText) {
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getGiacs180AssdLOV",
				filterText : ($("txtAssdNo").readAttribute("lastValidValue").trim() != $F("txtAssdNo").trim() ? $F("txtAssdNo").trim() : "%")
			},
			title : "List of Assured",
			width : 405,
			height : 386,
			columnModel : [ {
				id : "assdNo",
				title : "Assured No.",
				
				width : '80px',
				type : 'number'
			}, {
				id : "assdName",
				title : "Assured Name",
				width : '308px'
			} ],
			draggable : true,
			filterText : ($("txtAssdNo").readAttribute("lastValidValue").trim() != $F("txtAssdNo").trim() ? $F("txtAssdNo").trim() : "%"),
			autoSelectOneRecord: true,
			onSelect : function(row) {
				if (row != undefined) {
					$("txtAssdNo").value = row.assdNo;
					$("txtAssdName").value = unescapeHTML2(row.assdName);
					$("txtAssdNo").setAttribute("lastValidValue", row.assdNo);
				}
			},
	  		onCancel: function(){
	  			$("txtAssdNo").value = $("txtAssdNo").readAttribute("lastValidValue");
	  		},
	  		onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtAssdNo").value = $("txtAssdNo").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}
	
	function showPrintCollLetter(){
		try{
			new Ajax.Request(contextPath + "/GIACCreditAndCollectionReportsController",{
				parameters : { 
					action : "showPrintCollectionLetter",
					viewType : objSOA.prevParams.viewType,
					intmOrAssdNo : "" //(objSOA.prevParams.viewType == "I" ? $F("txtIntmNo") : $F("txtAssdNo"))
				},
				onCreate : function(){
					showNotice("Loading Print Collection Letter page, please wait...");
				},
				onComplete : function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
		} catch(e){
			showErrorMessage("showPrintCollLetter", e);
		}		
	}
	
	function showReprintCollLetter(){
		try{
			new Ajax.Request(contextPath + "/GIACCreditAndCollectionReportsController",{
				parameters : { 
					action : "getCollnLetterList",
					viewType : objSOA.prevParams.viewType,
					intmOrAssdNo : 0
				},
				onCreate : function(){
					showNotice("Loading Reprint Collection Letter page, please wait...");
				},
				onComplete : function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
		} catch(e){
			showErrorMessage("showReprintCollLetter", e);
		}		
	}
	
	function preparePrevParams(){
		// remember the params before navigating other page
		var prevParams = new Object();
		
		prevParams.chkBookTag = $("chkBookTag").checked ? "Y" : "N";
		prevParams.chkInceptTag = $("chkInceptTag").checked ? "Y" : "N";
		prevParams.chkIssueTag = $("chkIssueTag").checked ? "Y" : "N";
		
		prevParams.asOfDate = $F("txtAsOfDate");
		prevParams.bookDateFrom = $F("txtBookDateFrom"); 
		prevParams.bookDateTo = $F("txtBookDateTo");
		prevParams.inceptDateFrom = $F("txtIncepDateFrom"); 
		prevParams.inceptDateTo = $F("txtIncepDateTo");
		prevParams.issueDateFrom = $F("txtIssueDateFrom"); 
		prevParams.issueDateTo = $F("txtIssueDateTo");
		prevParams.cutOffDate = $F("txtCutOffDate");
		
		prevParams.reportDate = $("rdoAsOf").checked ? "asOf" : "fromTo";
		prevParams.printReportBy = $("rdoByIntermediary").checked ? "intermediary" : ($("rdoByAssured").checked ? "assured" : "license");
		//for reportType
		if($("rdoSummary").checked){
			prevParams.reportType = "summary";
		} else if($("rdoDetail").checked){
			prevParams.reportType = "detail";
		} else if($("rdoTaxBreakdown").checked){
			prevParams.reportType = "taxBreakdown";
		} else if($("rdoStatement").checked){
			prevParams.reportType = "statement";
		} else if($("rdoLicensed").checked){
			prevParams.reportType = "licensed";
		} else if($("rdoUnlicensed").checked){
			prevParams.reportType = "unlicensed";
		} else if($("rdoWithNet").checked){
			prevParams.reportType = "withNet";
		} else if($("rdoWithoutNet").checked){
			prevParams.reportType = "withoutNet";
		} else if($("rdoSOANetComm").checked){
			prevParams.reportType = "soaNetComm";
		} else if($("rdoAssdWithoutNet").checked){
			prevParams.reportType = "assdWithoutNet";
		}		
		prevParams.layoutType = $("rdoLayout1").checked ? "1" : ($("rdoLayout2").checked ? "2" : "3");
		prevParams.branchOfPolicy = $("rdoIssuing").checked ? "issuing" : "crediting";
		prevParams.prevPage = "statementOfAccount";
		prevParams.viewType = null;
		prevParams.intmOrAssdNo = null;
		prevParams.intmOrAssdName = null;
		//prevParams.prevPage = "statementOfAccount";
		
		if($("rdoByIntermediary").checked){
			prevParams.viewType = "I"; 				
		} else if($("rdoByAssured").checked){
			prevParams.viewType = "A"; 
		} else if($("rdoByLicense").checked){
			prevParams.viewType = "L"; 
		}
		
		prevParams.chkBreakdownTax 	= $("chkBreakdownTax").checked ? "Y" : "N";
		prevParams.chkIncludeNotDue = $("chkIncludeNotDue").checked ? "Y" : "N";
		prevParams.chkIncludePDC 	= $("chkIncludePDC").checked ? "Y" : "N";
		prevParams.chkWholdingTax 	= $("chkWholdingTax").checked ? "Y" : "N";
		prevParams.chkSpecialPol	= $("chkSpecialPol").checked ? "Y" : "N";
		
		prevParams.extractDays = $F("txtDays");
		prevParams.outstandingBal = unformatCurrency("txtOutstandingBal");
		
		prevParams.intmNoList = null;
		prevParams.assdNoList = null;
		prevParams.agingIdList = null;
		
		objSOA.prevParams = prevParams;
	}
	
	function validateDateFormat(strValue, elemName){
		var text = strValue; 
		var comp = text.split('-');
		var m = parseInt(comp[0], 10);
		var d = parseInt(comp[1], 10);
		var y = parseInt(comp[2], 10);
		var status = true;
		var isMatch = text.match(/^(\d{1,2})-(\d{1,2})-(\d{4})$/);
		var date = new Date(y,m-1,d);
		
		if(isNaN(y) || isNaN(m) || isNaN(d) || y.toString().length < 4 || !isMatch ){
			customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, elemName);
			status = false;
		}
		if(0 >= m || 13 <= m){
			customShowMessageBox("Month must be between 1 and 12.", imgMessage.INFO, elemName);	
			status = false; 
		}
		if(date.getDate() != d){				
			customShowMessageBox("Day must be between 1 and the last of the month.", imgMessage.INFO, elemName);	
			status = false;
		}
		if(!status){
			$(elemName).value = "";
		}
		return status;
	}
	
	function validateFromToDate(elemNameFr, elemNameTo, currElemName){
		var isValid = true;		
		var elemDateFr = Date.parse($F(elemNameFr), "mm-dd-yyyy");
		var elemDateTo = Date.parse($F(elemNameTo), "mm-dd-yyyy");
		
		var output = compareDatesIgnoreTime(elemDateFr, elemDateTo);
		if(output < 0){
			if(currElemName == elemNameFr){
				customShowMessageBox("From Date should not be later than To Date.", "I", currElemName);
				$(currElemName).clear();
			} else {
				customShowMessageBox("From Date should not be later than To Date.", "I", currElemName);
				$(currElemName).clear();
			}
			isValid = false;
		}
		return isValid;
	}
	
	
	//print_record procedure
	function printRecord(reportId, reportTitle){
		try {
			
			//if(checkAllRequiredFieldsInDiv("soaPrintFieldsDiv")){
				
				new Ajax.Request(contextPath + "/GIACCreditAndCollectionReportsController",{
					parameters : {
						action : "checkExistingReport",
						reportId: reportId
					},
					onComplete : function(response){
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
							/* moved to printSOAReport
							var fileType = "";
											
							if($("rdoPdf").checked)
								fileType = "PDF";
							else if ($("rdoExcel").checked)
								fileType = "XLS";
							else if ($("rdoCsv").checked)
								fileType = "CSV";								 
							
							$("selPrinter").value = $F("printerName");
							var content = contextPath + "/CreditAndCollectionReportPrintController?action=printReport"
										+ "&txtNoOfCopies=" + $F("txtNoOfCopies")
										+ "&printerName=" + $F("printerName")
										+ "&destination=" + $F("selDestination")
										+ "&reportId=" + reportId
										+ "&fileType=" + fileType
										+ "&reportTitle=" + encodeURIComponent(reportTitle)
										
										+ "&branchCd="+ $F("txtBranchCd")
										+ "&includeNotDue=" + ($("chkIncludeNotDue").checked ? "I" : "N") // changed Y to I
										+ "&soaRemarks=" +  (objSOA.remarksUpdated == null ? soaRemarks : objSOA.remarks) //soaRemarks
										+ "&viewType=" + objSOA.prevParams.viewType
										+ "&cutOffDate=" + $F("txtCutOffDate")
										+ "&asOfDate=" + $F("txtAsOfDate")
										+ "&outstandingBal=" + unformatCurrency("txtOutstandingBal")
										
										+ "&intmType=" + $F("txtIntmType")
										+ "&intmNo=" + $F("txtIntmNo")
										+ "&intmName=" + ($F("txtIntmNo").trim() == "" ? "" : encodeURIComponent($F("txtIntmName")))
										+ "&assdNo=" + $F("txtAssdNo")
										+ "&assdName=" + ($F("txtIntmNo").trim() == "" ? "" : encodeURIComponent($F("txtAssdName")));
							
							if($F("selDestination") == "file" && $("rdoCsv").checked){
								new Ajax.Request(content, {
									method: "POST",
									asynchronous: false,
									onCreate: showNotice("Generating report, please wait..."),
									onComplete: function(response){
										hideNotice();
										if (checkErrorOnResponse(response)){
											copyFileToLocal(response, "csv");
											deleteCSVFileFromServer(response.responseText);
										}
									}
								});
							} else
								printGenericReport(content, reportTitle, null);*/
							
							if (reportId == "GIACR189P" || reportId == "GIACR193A" || 	// intm
									reportId == "GIACR191P" || reportId == "GIACR197A"){	// assured
								new Ajax.Request(contextPath + "/GIACCreditAndCollectionReportsController",{
									parameters : {
										action : "checkUserChildRecords",
										pdcExt: (reportId == "GIACR189P" || reportId == "GIACR191P"? "Y" : "N")
									},
									onComplete : function(response){
										if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
											if (response.responseText == "Y"){
												showGenericPrintDialog("Print Report", function(){
																							printSOAReport(reportId, reportTitle);
																						}, 
																			function(){
																				$("csvOptionDiv").show();		
																			}, 
																			true);
											}else{
												var str = (reportId == "GIACR189P" || reportId == "GIACR191P"? "PDC" : "tax breakdown");
												showMessageBox("No records are extracted with " + str + ". Please extract records first.","I");
											}
										}
									}
								});
							}else{
								showGenericPrintDialog("Print Report", function(){
																			printSOAReport(reportId, reportTitle);
																		}, 
															function(){
																$("csvOptionDiv").show();		
															}, 
															true);
							}
							
						}
					}
				});
			//}			
		} catch (e) {
			showErrorMessage("printRecord",e);
		}
	}
	
	function printSOAReport(reportId, reportTitle){ 
		var fileType = "";			
		
 		if($("rdoPdf").checked)
			fileType = "PDF";		
		else if ($("rdoCsv").checked) //Dren 05.12.206 SR-5340 - Start
			if($F("selDestination") == "file") { 
				if (reportId ==  "GIACR193") {
					fileType = "CSV2";	
					reportId = "GIACR193_CSV"
				} else {
					fileType = "CSV";
				}
			} else {
				fileType = "CSV";
			} //Dren 05.12.206 SR-5340 - End	 		
		
		var content = contextPath + "/CreditAndCollectionReportPrintController?action=printReport"
					+ "&txtNoOfCopies=" + $F("txtNoOfCopies")
					+ "&printerName="+$F("selPrinter")
					+ "&destination=" + $F("selDestination")
					+ "&reportId=" + reportId
					+ "&fileType=" + fileType
					+ "&reportTitle=" + encodeURIComponent(reportTitle)
					
					+ "&branchCd="+ $F("txtBranchCd")
					+ "&includeNotDue=" + ($("chkIncludeNotDue").checked ? "I" : "N") // changed Y to I
					+ "&soaRemarks=" +  (objSOA.remarksUpdated == null ? soaRemarks : objSOA.remarks) //soaRemarks
					+ "&viewType=" + objSOA.prevParams.viewType
					+ "&cutOffDate=" + $F("txtCutOffDate")
					+ "&asOfDate=" + $F("txtAsOfDate")
					+ "&outstandingBal=" + unformatCurrency("txtOutstandingBal")
					
					+ "&intmType=" + $F("txtIntmType")
					+ "&intmNo=" + $F("txtIntmNo")
					+ "&intmName=" + ($F("txtIntmNo").trim() == "" ? "" : encodeURIComponent($F("txtIntmName")))
					+ "&assdNo=" + $F("txtAssdNo")
					+ "&assdName=" + ($F("txtIntmNo").trim() == "" ? "" : encodeURIComponent($F("txtAssdName")))					
					// added for GIACR189 : shan 02.26.2015
					+ "&includePDC=" + ($("chkIncludePDC").checked ? "Y" : "N");	
		
		if($F("selDestination") == "file" ){ //Dren Niebres SR-5341 05.16.2016
			new Ajax.Request(content, {
				method: "POST",
				asynchronous: false,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();				
					
 					if (checkErrorOnResponse(response)){
 						if (fileType == "CSV2"){ 
 							copyFileToLocal(response, "csv");
 						} else if (fileType == "CSV") {
 							copyFileToLocal(response, "csv");
							deleteCSVFileFromServer(response.responseText);
 						} else {
 							copyFileToLocal(response);
 						} //Dren 05.12.206 SR-5340 - End
					}
				}
			});
		} else
			printGenericReport(content, reportTitle, null);
	}
	
	/////////////////////// END OF FUNCTIONS

	$("chkBookTag").observe("change", function(){
		if($("chkBookTag").checked == true){
			if($("chkInceptTag").checked == true && $("chkIssueTag").checked == true){ //$("chkBookTag").checked == true && 
				showMessageBox("Only Two Tags can be checked at the same time.", "E");					
				$("chkBookTag").checked = false;	
			/*if($("chkBookTag").checked == true){
					$("chkBookTag").checked = false;
				} else {
					$("chkBookTag").checked = true;
				}*/	
			}
			
			$("trBookDate").show();
		// } else {
			//$("txtAsOfDate").value = "";
			//if(nvl(defaultSOAParams.reportDate, "F") == "F"){
			if($("rdoFromTo").checked){
				if($("chkBookTag").checked == false){
					$("trBookDate").hide();
					if($("chkIssueTag").checked == true){
						$("trIssueDate").show();
						//$("tdIssueDate1").innerHTML = tdIssueDate1HTML; //show(); 
						//$("tdIssueDate2").innerHTML = tdIssueDate2HTML; //show();
						$("txtIssueDateTo").value = defaultSOAParams.issueDateTo == null ? "" : dateFormat(defaultSOAParams.issueDateTo, 'mm-dd-yyyy');
						$("txtIssueDateFrom").value = defaultSOAParams.issueDateFr == null ? "" : dateFormat(defaultSOAParams.issueDateFr, 'mm-dd-yyyy');
						$("txtIssueDateFrom").focus();
					} else if($("chkInceptTag").checked == true){
						$("trInceptDate").show();
						$("txtIncepDateTo").value = defaultSOAParams.incepDateTo == null ? "" : dateFormat(defaultSOAParams.incepDateTo, 'mm-dd-yyyy');
						$("txtIncepDateFrom").value = defaultSOAParams.incepDateFr == null ? "" : dateFormat(defaultSOAParams.incepDateFr, 'mm-dd-yyyy');
						$("txtIncepDateFrom").focus();
						$("trRdoSOA").show();
					}
				} else if($("chkBookTag").checked == true){
					$("trBookDate").show();
					$("txtBookDateTo").value = defaultSOAParams.bookDateTo == null ? "" : dateFormat(defaultSOAParams.bookDateTo, 'mm-dd-yyyy');
					$("txtBookDateFrom").value = defaultSOAParams.bookDateFr == null ? "" : dateFormat(defaultSOAParams.bookDateFr, 'mm-dd-yyyy');
					$("trRdoSOA").show();
					if($("chkIssueTag").checked == true){
						$("trIssueDate").show();
						$("txtIssueDateTo").value = defaultSOAParams.issueDateTo == null ? "" : dateFormat(defaultSOAParams.issueDateTo, 'mm-dd-yyyy');
						$("txtIssueDateFrom").value = defaultSOAParams.issueDateFr == null ? "" : dateFormat(defaultSOAParams.issueDateFr, 'mm-dd-yyyy');
						//$("tdIssueDate1").innerHTML = tdIssueDate1HTML; //show(); 
						//$("tdIssueDate2").innerHTML = tdIssueDate2HTML; //show();
					} else if($("chkInceptTag").checked == true){
						$("trInceptDate").show();
						$("txtIncepDateTo").value = defaultSOAParams.incepDateTo == null ? "" : dateFormat(defaultSOAParams.incepDateTo, 'mm-dd-yyyy');
						$("txtIncepDateFrom").value = defaultSOAParams.incepDateFr == null ? "" : dateFormat(defaultSOAParams.incepDateFr, 'mm-dd-yyyy');
					}
				}
				$("trDateAsOf").hide();
			} else {
				if($("chkBookTag").checked == false && $("chkInceptTag").checked == false && $("chkIssueTag").checked == false){
					$("trDateAsOf").hide();
					$("trBookDate").hide();
					$("trInceptDate").hide();
					$("trIssueDate").hide();
					//$("tdIssueDate1").innerHTML = ""; //hide();
					//$("tdIssueDate2").innerHTML = ""; //hide();
				} else {
					$("trDateAsOf").show();
					$("trBookDate").hide();
					$("trInceptDate").hide();
					$("trIssueDate").hide();
					//$("tdIssueDate1").innerHTML = ""; //hide();
					//$("tdIssueDate2").innerHTML = ""; //hide();
				}
			}
		
		} else {
			$("trBookDate").hide();
		}
		
		
		/////////////
		/*if($("rdoFromTo").checked){
			if(!$("chkBookTag").checked){  // UNCHECKED
				$("trDateAsOf").hide();
				
				// move the other field up y_pos if it exists
			} else if($("chkBookTag").checked){  // CHECKED
				$("trDateAsOf").show();
			} 
		}*/
	});
	
	$("chkInceptTag").observe("change", function(){
		$("txtIssueDateTo").value = "";	// SR-4129 : shan 06.19.2015
		$("txtIssueDateFrom").value = "";	// SR-4129 : shan 06.19.2015
		
		if($("chkInceptTag").checked && $("chkIssueTag").checked){
			$("chkIssueTag").checked = false;			
			$("trIssueDate").hide();
		}
		
		if($("chkInceptTag").checked){
			//$("chkInceptTag").checked = false;
			$("trIssueDate").hide();  
			$("trSpecialPol").show();
			//$("tdIssueDate2").innerHTML = "";			
		} else {
			//$("chkInceptTag").checked = true;
			//$("trIssueDate").show();  
			$("txtIssueDateFrom").value = "";
			$("txtIssueDateTo").value = "";
			$("trSpecialPol").hide();
		}
		//$("txtIssueDate").value = "";
		
		//if(defaultSOAParams.reportDate == "F"){
		if($("rdoFromTo").checked){
			if($("chkInceptTag").checked == false){
				$("chkSpecialPol").checked = false;
				$("trInceptDate").hide();
				$("trRdoSOA").show();
			} else if($("chkInceptTag").checked == true){
				$("trInceptDate").show();
				$("txtIncepDateTo").value = defaultSOAParams.incepDateTo == null ? "" : dateFormat(defaultSOAParams.incepDateTo, 'mm-dd-yyyy');
				$("txtIncepDateFrom").value = defaultSOAParams.incepDateFr == null ? "" :  dateFormat(defaultSOAParams.incepDateFr, 'mm-dd-yyyy');
			}
			$("trDateAsOf").hide();
		} else {
			if($("chkBookTag").checked == false && $("chkInceptTag").checked == false && $("chkIssueTag").checked == false){
				$("trDateAsOf").hide();
			} else {
				$("trDateAsOf").show();
			}
			$("trBookDate").hide();
			$("trInceptDate").hide();
			$("trIssueDate").hide(); 
		}
	});

	$("chkIssueTag").observe("change", function(){
		$("txtIncepDateFrom").value = "";	// SR-4129 : shan 06.19.2015
		$("txtIncepDateTo").value = "";	// SR-4129 : shan 06.19.2015
		
		if($("chkInceptTag").checked && $("chkIssueTag").checked){
			$("chkInceptTag").checked = false;	
			$("trInceptDate").hide();
		}		
		if($("chkIssueTag").checked){
			//$("chkIssueTag").checked = false;
			$("chkSpecialPol").checked = false;
			$("trSpecialPol").hide();
			//$("trIssueDate").hide(); 
			//$("tdIssueDate2").innerHTML = ""; //hide();
		}
		$("txtIssueDateTo").value = "";
		$("txtIssueDateFrom").value = "";
		
		//if(defaultSOAParams.reportDate == "F"){
		if($("rdoFromTo").checked){
			if($("chkIssueTag").checked == false){
				$("trIssueDate").hide();
				//$("tdIssueDate2").innerHTML = ""; //hide();
				
				if($("chkInceptTag").checked == true && $("chkBookTag").checked == false ){
					$("trRdoSOA").show();
				}
			} else if($("chkIssueTag").checked){
				if($("chkInceptTag").checked == false && $("chkBookTag").checked == false){
					//$("tdIssueDate1").innerHTML = tdIssueDate1HTML; //show(); 
					//$("tdIssueDate2").innerHTML = tdIssueDate2HTML; //show();
				} else {
					
				}
				$("trIssueDate").show();
				//$("tdIssueDate2").innerHTML = ""; //hide();
				$("txtIssueDateTo").value = defaultSOAParams.issueDateTo == null ? "" : dateFormat(defaultSOAParams.issueDateTo, "mm-dd-yyyy");
				$("txtIssueDateFrom").value = defaultSOAParams.issueDateFr == null ? "" : dateFormat(defaultSOAParams.issueDateFr, "mm-dd-yyyy");
			}
			$("trDateAsOf").hide();
		} else {
			if($("chkBookTag").checked == false && $("chkInceptTag").checked == false && $("chkIssueTag").checked == false){
				$("trDateAsOf").hide();
				$("trBookDate").hide();
				$("trInceptDate").hide();
				$("trIssueDate").hide();
			} else {
				$("trDateAsOf").show();
				$("trBookDate").hide();
				$("trInceptDate").hide();
				$("trIssueDate").hide();
			}
		}
	});
	
	/*$("txtIssueDateTo").observe("blur", function(){
		var issueDateFr = Date.parse($F("txtIssueDateTo"), "mm-dd-yyyy");
		var issueDateTo = Date.parse($F("txtIssueDateFrom"), "mm-dd-yyyy");
		
		if(issueDateFr > issueDateTo){
			showMessageBox("The date you entered is EARLIER THAN the FROM DATE.", "E");
		}
	});*/
	
	//REPORT_DATE RADIO GROUP
	$("rdoAsOf").observe("click", function(){
		if($("chkBookTag").checked == false && $("chkInceptTag").checked == false && $("chkIssueTag").checked == false){
			$("trDateAsOf").hide();
			$("trBookDate").hide();
			$("trInceptDate").hide();
			$("trIssueDate").hide();
		} else {
			setDefaultDates();
			$("trDateAsOf").show();
			$("trBookDate").show();
			$("trInceptDate").show();
			$("trIssueDate").show();
		}
	});
	
	$("rdoFromTo").observe("click", function(){
		setDefaultDates();
		$("trDateAsOf").hide();		
	});
	
	
	//PRINT_REPORT_BY RADIO GROUP
	$("rdoByIntermediary").observe("click", function(){
		if($("rdoLayout1").checked){
			$("trRdoLicensed").hide();
			$("trRdoUnlicensed").hide();
			$("trRdoSOANetComm").hide();
			$("trRdoAssdWithoutNet").hide();
			$("trRdoSummary").show(); 
			$("trRdoDetail").show();
			$("rdoDetail").checked = true;
			$("trRdoTaxBreakdown").show();
			$("trRdoSOA").show();
		} else if($("rdoLayout2").checked){
			$("trRdoWithNet").show();
			$("trRdoWithoutNet").show();
			$("trRdoSOANetComm").show();
			$("trRdoAssdWithoutNet").hide();
			
			$("trRdoSummary").hide(); 
			$("trRdoDetail").hide();
			$("trRdoTaxBreakdown").hide();
			$("trRdoSOA").hide();
			$("trRdoLicensed").hide();
			$("trRdoUnlicensed").hide();
			
			$("rdoWithNet").checked = true;
			$("trChkWholdingTax").show();	
		} else { //SHOW_VIEW('LAYOUT3');
			//$("tblReportType").hide();
			$("trRdoSummary").hide(); 
			$("trRdoDetail").hide();
			$("trRdoTaxBreakdown").hide();
			$("trRdoSOA").hide();
			$("trRdoLicensed").hide();
			$("trRdoUnlicensed").hide();
			$("trRdoWithNet").hide();
			$("trRdoWithoutNet").hide();
			$("trRdoSOANetComm").hide();
			$("trRdoAssdWithoutNet").hide();
		}		
		$("trIntmType").show();
		$("trIntmNo").show();
		$("txtAssdNo").clear(); //added by robert 01.29.2014
		$("txtAssdName").value = "All Assured"; //added by robert 01.29.2014
		$("trAssdNo").hide();
		
		$("txtBranchCd").clear();
		$("txtBranchCd").setAttribute("lastValidValue", "");
		$("txtBranch").value = "All Branches";
		$("txtIntmNo").clear();
		$("txtIntmName").value = "All Intermediaries";
		$("txtIntmType").clear();
		$("txtIntmDesc").value = "All Intm Types";
	});
	
	$("rdoByAssured").observe("click", function(){
		if($("rdoLayout1").checked){
			$("trRdoLicensed").hide();
			$("trRdoUnlicensed").hide();
			$("trRdoAssdWithoutNet").hide();
			$("trRdoSummary").show(); 
			$("trRdoDetail").show();
			$("rdoDetail").checked = true;
			$("trRdoTaxBreakdown").show();
			$("trRdoSOA").show();
		} else if($("rdoLayout2").checked){
			$("trRdoAssdWithoutNet").show();
			$("rdoAssdWithoutNet").checked = true;
			//fireEvent($("rdoLayout2"), "click");
			$("trRdoLicensed").hide();
			$("trRdoUnlicensed").hide();
			
			/*$("trRdoWithNet").show();
			$("trRdoWithoutNet").show();*/
			if('${hideSOANetAssd}' == "Y"){ //Added by Jerome Bautista SR 21424 02.12.2016
				$("trRdoSOANetComm").hide(); //show(); changed to hide by robert SR 5255 01.05.2015
			}else
				$("trRdoSOANetComm").show();
			//$("trRdoAssdWithoutNet").hide();			
			
			$("trRdoSummary").hide(); 
			$("trRdoDetail").hide();
			$("trRdoTaxBreakdown").hide();
			$("trRdoSOA").hide();
			
			$("trRdoWithNet").hide();
			$("trRdoWithoutNet").hide();
			$("trChkWholdingTax").hide();	
			$("trRdoLicensed").hide();
			$("trRdoUnlicensed").hide();
			
		} else {
			$("trRdoSummary").hide(); 
			$("trRdoDetail").hide();
			$("trRdoTaxBreakdown").hide();
			$("trRdoSOA").hide();
			$("trRdoLicensed").hide();
			$("trRdoUnlicensed").hide();
			$("trRdoWithNet").hide();
			$("trRdoWithoutNet").hide();
			$("trRdoSOANetComm").hide();
			$("trRdoAssdWithoutNet").hide();
		}
		
		$("trIntmType").hide();
		$("txtIntmNo").clear(); //added by robert 01.29.2014
		$("txtIntmName").value = "All Intermediaries"; //added by robert 01.29.2014
		$("trIntmNo").hide();
		$("trAssdNo").show();
		
		$("txtIntmType").clear();//carlo SR 23951 03-03-2017
		
		$("txtBranchCd").clear();
		$("txtBranchCd").setAttribute("lastValidValue", "");
		$("txtBranch").value = "All Branches";
		$("txtAssdNo").clear();
		$("txtAssdName").value = "All Assured";
		
		//$("trRdoSummary").show(); 
		//$("trRdoDetail").show();
		//$("trRdoTaxBreakdown").show();
		//$("trRdoSOA").show();
		//$("trRdoLicensed").hide();
		//$("trRdoUnlicensed").hide();
		
		//$("rdoDetail").checked = true;
		/*if($("trRdoWithNet") != null && $("trRdoWithoutNet") != null && $("trRdoSOANetComm") != null){
			$("trRdoWithNet").hide();
			$("trRdoWithoutNet").hide();
			//$("trRdoAssdWithoutNet").show();
			//$("rdoAssdWithoutNet").checked = true;
			$("trChkWholdingTax").hide();		
			
			//$("trRdoAssdWithoutNet").hide();
		} else {
			$("trRdoLicensed").hide();
			$("trRdoUnlicensed").hide();
		}*/
	});
	
	
	$("rdoByLicense").observe("click", function(){
		if($("trRdoWithNet") != null && $("trRdoWithoutNet") != null && $("trRdoSOANetComm") != null){
			$("trRdoSummary").hide();
			$("trRdoDetail").hide();
			$("trRdoTaxBreakdown").hide();
			$("trRdoSOA").hide();
			$("trRdoLicensed").show();
			$("rdoLicensed").checked = true;
			$("trRdoUnlicensed").show();
			$("trRdoWithNet").hide();
			$("trRdoWithoutNet").hide();
			$("trRdoSOANetComm").hide();
			$("trRdoAssdWithoutNet").hide();
			
			$("trIntmType").show();
			$("trIntmNo").show();
			$("txtAssdNo").clear(); //added by robert 01.29.2014
			$("txtAssdName").value = "All Assured"; //added by robert 01.29.2014
			$("trAssdNo").hide();
		}
		
		$("txtBranchCd").clear();
		$("txtBranchCd").setAttribute("lastValidValue", "");
		$("txtBranch").value = "All Branches";
		$("txtIntmNo").clear();
		$("txtIntmName").value = "All Intermediaries";
		$("txtIntmType").clear();
		$("txtIntmDesc").value = "All Intm Types";
	});
	
	$("rdoWithNet").observe("click", function(){
		if($("rdoWithNet").checked){
			$("trChkWholdingTax").show();	
		}
	});
	
	$("rdoWithoutNet").observe("click", function(){
		if($("rdoWithoutNet").checked){
			$("trChkWholdingTax").hide();	
		}
	});
	
	$("rdoSOANetComm").observe("click", function(){
		if($("rdoSOANetComm").checked){
			//$("trChkWholdingTax").show();	
			$("trChkWholdingTax").hide();
		}
	});
	
	$("rdoAssdWithoutNet").observe("click", function(){
		if($("rdoAssdWithoutNet").checked){
			$("trChkWholdingTax").show();	
		}
	});
	
	$("rdoLayout1").observe("click", function(){
		variableLoSw = "S";
		$("tdPrintType").innerHTML = "Print Type";
		if($("rdoByLicense").checked){
			$("trRdoLicensed").show();
			$("trRdoUnlicensed").show();
			$("trRdoSummary").hide();
			$("trRdoDetail").hide();
			$("trRdoTaxBreakdown").hide();
			$("trRdoSOA").hide();
			if($("rdoLicensed").checked){
				$("rdoLicensed").checked = true;
			} else if($("rdoUnlicensed").checked){
				$("rdoUnlicensed").checked = true;
			}
		} else {
			$("trChkWholdingTax").hide();	
			$("trRdoByAssured").show();
			$("trRdoByLicense").show();
			$("trRdoSummary").show();
			$("trRdoDetail").show();
			$("rdoDetail").checked = true;
			$("trRdoTaxBreakdown").show();
			$("trRdoSOA").show();
			$("trRdoLicensed").hide();
			$("trRdoUnlicensed").hide();
			
			$("trRdoWithNet").hide();
			$("trRdoWithoutNet").hide();
			$("trRdoSOANetComm").hide();
			$("trRdoAssdWithoutNet").hide();
		}
	});
	
	$("rdoLayout2").observe("click", function(){
		variableLoSw = "H";
		$("tdPrintType").innerHTML = "Print Type";
		$("trRdoWithNet").show();
		$("trRdoWithoutNet").show();
		$("trRdoSOANetComm").show();
		$("trRdoAssdWithoutNet").hide();
		$("trRdoSummary").hide();
		$("trRdoDetail").hide();
		$("trRdoTaxBreakdown").hide();
		$("trRdoSOA").hide();
		$("trRdoByAssured").show();
		$("trRdoByLicense").show();
		$("trRdoFromTo").show();
		
		if($("rdoByIntermediary").checked){
			$("trRdoWithNet").show();
			$("rdoWithNet").checked = true;
			$("trRdoWithoutNet").show();
			$("trRdoSOANetComm").show();
			$("trRdoAssdWithoutNet").hide();
			$("trChkWholdingTax").show();	
			$("chkWholdingTax").checked = true;
		} else if($("rdoByAssured").checked){
			$("trRdoWithNet").hide();
			$("trRdoWithoutNet").hide();
			$("trRdoAssdWithoutNet").show();
			$("rdoAssdWithoutNet").checked = true;
			fireEvent($("rdoAssdWithoutNet"), "click");
			$("trRdoSOANetComm").hide(); //show(); changed to hide by robert SR 5255 01.05.2015
			$("trChkWholdingTax").hide();	
		} else if($("rdoByLicense").checked){
			$("trRdoSummary").hide(); 
			$("trRdoDetail").hide();
			$("trRdoTaxBreakdown").hide();
			$("trRdoSOA").hide();
			$("trRdoLicensed").show();
			$("trRdoUnlicensed").show();
			$("trRdoWithNet").hide();
			$("trRdoWithoutNet").hide();
			$("trRdoSOANetComm").hide();
			$("trRdoAssdWithoutNet").hide();
			
			// may naiwan pa ung nagstart sa gantong comment... 
			/*HIDE THE INPUT FIELDS OF ASSD AND SHOW INTM FIELDS INSTEAD, CODES SAME**
		    **AS THAT OF :MISC.INTM_ASSD RADIO BUTTON*/ 
		    
		   /* if($("rdoByIntermediary").checked){
		    	fireEvent($("rdoByIntermediary"), "click");
		    } else if($("rdoByAssured").checked){
		    	fireEvent($("rdoByAssured"), "click");
		    } else if($("rdoByLicense").checked){
		    	fireEvent($("rdoByLicense"), "click");
		    }*/
		}
	});
	
	$("rdoLayout3").observe("click", function(){
		variableLoSw = "S";
		$("tdPrintType").innerHTML = "Aging of Premium Receivables";
		$("rdoByIntermediary").checked = true;
		fireEvent($("rdoByIntermediary"), "click");
		$("trRdoByAssured").hide();
		$("trRdoByLicense").hide();
		$("trRdoSummary").hide();
		$("trRdoDetail").hide();
		$("trRdoTaxBreakdown").hide();
		$("trRdoSOA").hide();
		$("trRdoWithNet").hide();
		$("trRdoWithoutNet").hide();
		$("trRdoSOANetComm").hide();
		$("trRdoAssdWithoutNet").hide();
		$("trChkWholdingTax").hide();	
		$("trIntmType").show();
		$("trIntmNo").show();
		$("trAssdNo").hide();
	});
	
	function togglePrintFields(destination){
		if(destination == "printer"){
			$("printerName").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("printerName").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			$("rdoPdf").disable();
			$("rdoCsv").disable();
		} else {
			if(destination == "file"){
				$("rdoPdf").enable();
				$("rdoCsv").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoCsv").disable();
			}				
			$("printerName").value = "";
			$("txtNoOfCopies").value = "";
			$("printerName").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("printerName").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();
		}
	}
	
	/*$("selDestination").observe("change", function(){
		//checkPrintDestinationFields();
		var destination = $F("selDestination");
		togglePrintFields(destination);
	});	*/
	$("hrefAsOfDate").observe("click", function(){
		scwShow($('txtAsOfDate'),this, null);
	});	
	$("hrefCutOffDate").observe("click", function(){
		scwShow($('txtCutOffDate'),this, null);
	});	
	$("hrefBookDateFrom").observe("click", function(){
		scwShow($('txtBookDateFrom'),this, null);
	});	
	$("hrefBookDateTo").observe("click", function(){
		scwShow($('txtBookDateTo'),this, null);
	});	
	$("hrefIncepDateFrom").observe("click", function(){
		scwShow($('txtIncepDateFrom'),this, null);
	});	
	$("hrefIncepDateTo").observe("click", function(){
		scwShow($('txtIncepDateTo'),this, null);
	});	
	$("hrefIssueDateFrom").observe("click", function(){
		scwShow($('txtIssueDateFrom'),this, null);
	});	
	$("hrefIssueDateTo").observe("click", function(){
		scwShow($('txtIssueDateTo'),this, null);
	});	
	/////
	
	function changeOnDate(fromDate, toDate, dateToCompare){
		if(dateToCompare == 1){ // 1 = fromDate
			if($F(fromDate) != "" && validateDateFormat($F(fromDate), fromDate)){
				if($F(toDate) != "" && validateDateFormat($F(toDate), toDate)){
					validateFromToDate(fromDate, toDate, fromDate);
				}
			}
		} else if(dateToCompare == 2){ // 2 = toDate
			if($F(toDate) != "" && validateDateFormat($F(toDate), toDate)){
				if($F(fromDate) != "" && validateDateFormat($F(fromDate), fromDate)){
					validateFromToDate(fromDate, toDate, toDate);
				}
			}
		}
	}
	
	$("txtOutstandingBal").observe("change", function(){
		$("txtOutstandingBal").value = formatCurrency($F("txtOutstandingBal"));
	});
	
	
	$("btnExtract").observe("click", function(){
		var proceed = true;
		if($("rdoFromTo").checked){
			if($("chkBookTag").checked){
				if($F("txtBookDateTo") == "" || $F("txtBookDateFrom") == ""){
					showMessageBox("Some dates entered are NULL.", "I");
					if($F("txtBookDateFrom") == ""){
						$("txtBookDateFrom").focus();
					} else if($F("txtBookDateTo") == ""){
						$("txtBookDateTo").focus();
					}
					proceed = false;
				} else {
					if(!validateFromToDate("txtBookDateFrom", "txtBookDateTo", "txtBookDateFrom")){
						proceed = false;
					}
				}
			}
			
			if($("chkInceptTag").checked){
				if($F("txtIncepDateTo") == "" || $F("txtIncepDateFrom") == ""){
					showMessageBox("Some dates entered are NULL.", "I");
					if($F("txtIncepDateFrom") == ""){
						$("txtIncepDateFrom").focus();
					} else if($F("txtIncepDateTo") == ""){
						$("txtIncepDateTo").focus();
					}
					proceed =  false;
				} else {
					if(!validateFromToDate("txtIncepDateFrom", "txtIncepDateTo", "txtIncepDateFrom")){
						proceed = false;
					}
				}
			}
			
			if($("chkIssueTag").checked){
				if($F("txtIssueDateTo") == "" || $F("txtIssueDateFrom") == ""){
					showMessageBox("Some dates entered are NULL.", "I");
					if($F("txtIssueDateFrom") == ""){
						$("txtIssueDateFrom").focus();
					} else if($F("txtIssueDateTo") == ""){
						$("txtIssueDateTo").focus();
					}
					proceed = false;
				} else {
					if(!validateFromToDate("txtIssueDateFrom", "txtIssueDateTo", "txtIssueDateFrom")){
						proceed = false;
					}
				}
			}
			
			if($("chkIssueTag").checked == false && $("chkInceptTag").checked == false && $("chkBookTag").checked == false){
				showMessageBox("No box checked. Please check a box and enter the period to extract.", "I");
				proceed = false;
			}
		}else {
			if($("chkBookTag").checked || $("chkInceptTag").checked || $("chkIssueTag").checked){
				if($("rdoAsOf").checked == false && $("rdoFromTo").checked == false){  //|| condition added by Kris 
					showMessageBox("Some dates entered are NULL.", "I");
					proceed = false;
					$("txtAsOfDate").focus();
				}
			}
			
			if($("chkIssueTag").checked == false){
				if($("chkInceptTag").checked == false){
					if($("chkBookTag").checked == false){
						showMessageBox("No box checked. Please check a box and enter the period to extract.", "I");
						proceed = false;
					}
				}
			}
		}
		
		if($("rdoAsOf").checked){
			if($F("txtAsOfDate") == ""){
				showMessageBox("Some dates entered are NULL.", "I");
				proceed = false;
			}			
		}
		
		if($F("txtCutOffDate") == ""){
			showConfirmBox("Aging Extract", 
						   "Cut-off date is null, would you like to use the current date?\n\n(Choose 'No' if you want to use a different value)", 
						   "Yes", "No", 
						   function(){ 
								$("txtCutOffDate").value = new Date().format('mm-dd-yyyy');
								proceed = true;
								getExtractDate(); //added by steven 08.26.2014
							},
						   function(){ 
								$("txtCutOffDate").focus();
								proceed = false;
							}, 
							"");
		}else{ //added by steven 08.26.2014
			if(proceed){
				getExtractDate();
			}	
		}
	});
	
	$("osBranchCd").observe("click", showGIACS180BranchLOV); 
	$("osAssdNo").observe("click", showGIACS180AssuredLOV);	
	$("osIntmType").observe("click", showGIACS180IntmTypeLOV);
	$("osIntmNo").observe("click", showGIACS180IntmNoLOV);
	
	$("txtBranchCd").observe("change", function(){
		if($F("txtBranchCd").trim() == ""){
			$("txtBranch").value = "All Branches";
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				showGIACS180BranchLOV();
			}
		}
	});
	$("txtIntmType").observe("change", function(){
		if($F("txtIntmType").trim() == ""){
			$("txtIntmDesc").value = "All Intm Type";
			$("txtIntmType").value = "";
			$("txtIntmType").setAttribute("lastValidValue", "");
		} else {
			if($F("txtIntmType").trim() != "" && $F("txtIntmType") != $("txtIntmType").readAttribute("lastValidValue")) {
				showGIACS180IntmTypeLOV();
			}
		}
	});
	$("txtIntmNo").observe("change", function(){
		if($F("txtIntmNo").trim() == ""){
			$("txtIntmName").value = "All Intermediaries";
			$("txtIntmNo").value = "";
			$("txtIntmNo").setAttribute("lastValidValue", "");
		} else {
			if($F("txtIntmNo").trim() != "" && $F("txtIntmNo") != $("txtIntmNo").readAttribute("lastValidValue")) {
				showGIACS180IntmNoLOV();
			}
		}
	});
	$("txtAssdNo").observe("change", function(){
		if($F("txtAssdNo").trim() == ""){
			$("txtAssdName").value = "All Assured";
			$("txtAssdNo").value = "";
			$("txtAssdNo").setAttribute("lastValidValue", "");
		} else {
			if($F("txtAssdNo").trim() != "" && $F("txtAssdNo") != $("txtAssdNo").readAttribute("lastValidValue")) {
				showGIACS180AssuredLOV();
			}
		}
	});
	
	$("btnRemarks").observe("click", function(){
		//showOverlayEditor("hidSOARemarks", 4000, true);
		overlayRemarks = Overlay.show(contextPath+"/GIACCreditAndCollectionReportsController", { 
			urlContent: true,
			urlParameters: {action 		: "showRemarksOverlay",
							ajax 		: "1"},
			title: "Remarks",							
		    height: 220,
		    width: 380,
		    draggable: true,
		    onCompleteFunction : function(){
		    }
		});
	});
	
	/*$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		$("txtNoOfCopies").value = no + 1;
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no > 1){
			$("txtNoOfCopies").value = no - 1;
		}
	});
	
	$("imgSpinUp").observe("mouseover", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});
	
	$("imgSpinDown").observe("mouseover", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});
	
	$("imgSpinUp").observe("mouseout", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});
	
	$("imgSpinDown").observe("mouseout", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});
	
	$("txtNoOfCopies").observe("change", function(){
		if( parseInt($F("txtNoOfCopies")) > 100 || parseInt(nvl($F("txtNoOfCopies"), "0")) == 0 ){
			customShowMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", "txtNoOfCopies");
			$("txtNoOfCopies").value = "";
		}
	});*/
	
	function checkParamChanges(func){
		var changed = false;
		new Ajax.Request(contextPath + "/GIACCreditAndCollectionReportsController",{
			parameters : {
				action : "getDefaultSOAParams",
			},
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var extractParams = JSON.parse(response.responseText);
					
					var reportDate = ($("rdoFromTo").checked ? "F" : "A");
					var paytDate = ($("rdoTranDate").checked ? "T" : "P");
					var branchParam = $("rdoIssuing").checked ? "I" : "C";
					var bookTag = ($("chkBookTag").checked ? "Y" : "N");
					var incepTag = ($("chkInceptTag").checked ? "Y" : "N");
					var issueTag = ($("chkIssueTag").checked ? "Y" : "N");
					var incSpecialPol = ($("chkSpecialPol").checked ? "Y" : "N");
					
					//modified by gab 10.14.2016 SR 4016
					if (reportDate != extractParams.reportDate || paytDate != extractParams.paytDate || branchParam != extractParams.branchParam	// radio buttons
							|| bookTag != extractParams.bookTag || incepTag != extractParams.incepTag || issueTag != extractParams.issueTag	// checkboxes
							/* || $F("txtCutOffDate") != dateFormat(extractParams.cutOffDate, "mm-dd-yyyy")
							|| (extractParams.asOfDate != null && $F("txtAsOfDate") != dateFormat(extractParams.asOfDate, "mm-dd-yyyy"))
							|| (extractParams.bookDateFr != null && $F("txtBookDateFrom") != dateFormat(extractParams.bookDateFr, "mm-dd-yyyy"))
							|| (extractParams.bookDateTo != null && $F("txtBookDateTo") != dateFormat(extractParams.bookDateTo, "mm-dd-yyyy"))
							|| (extractParams.incepDateFr != null && $F("txtIncepDateFrom") != dateFormat(extractParams.incepDateFr, "mm-dd-yyyy"))
							|| (extractParams.incepDateTo != null && $F("txtIncepDateTo") != dateFormat(extractParams.incepDateTo, "mm-dd-yyyy"))
							|| (extractParams.issueDateFr != null && $F("txtIssueDateFrom") != dateFormat(extractParams.issueDateFr, "mm-dd-yyyy"))
							|| (extractParams.issueDateTo != null && $F("txtIssueDateTo") != dateFormat(extractParams.issueDateTo, "mm-dd-yyyy")) */
							|| $F("txtCutOffDate") != extractParams.dspCutOffDate
							|| (extractParams.asOfDate != null && $F("txtAsOfDate") != extractParams.dspAsOfDate)
							|| (extractParams.bookDateFr != null && $F("txtBookDateFrom") != extractParams.dspBookDateFr)
							|| (extractParams.bookDateTo != null && $F("txtBookDateTo") != extractParams.dspBookDateTo)
							|| (extractParams.incepDateFr != null && $F("txtIncepDateFrom") != extractParams.dspIncepDateFr)
							|| (extractParams.incepDateTo != null && $F("txtIncepDateTo") != extractParams.dspIncepDateTo)
							|| (extractParams.issueDateFr != null && $F("txtIssueDateFrom") != extractParams.dspIssueDateFr)
							|| (extractParams.issueDateTo != null && $F("txtIssueDateTo") != extractParams.dspIssueDateTo)
							|| incSpecialPol != extractParams.incSpecialPol){
						changed = true;
					}
					
					if ((extractParams.branchCd != null && $F("txtBranchCd") != extractParams.branchCd)
							|| (extractParams.intmType != null && $F("txtIntmType") != extractParams.intmType)
							|| (extractParams.intmNo != null && $F("txtIntmNo") != extractParams.intmNo)
							|| (extractParams.assdNo != null && $F("txtAssdNo") != extractParams.assdNo)
							){
						changed = true;
					}
					
					if (!changed){
						func();
					}else{
						showConfirmBox("CONFIRMATION", "The specified parameter/s has not been extracted. Do you want to extract the data using the specified parameter/s?", "Yes", "No",  
								function(){
									fireEvent($("btnExtract"), "click");	
								}
						);
					}
				}
			}
		});			
	}
	
	function proceedPrinting(){
		if(variableLoSw == "H"){  //VARIABLES.lo_sw = H >> Layout2
			// INTERMEDIARY
			if($("rdoByIntermediary").checked){ 
				if($("rdoWithNet").checked){  // with_net
					if($("chkWholdingTax").checked){
						printRecord("GIACR199", "Statement of Accounts (Intermediary with NET and Witholding Tax)");
						/*if($F("selDestination") == "file"){
							//SOA_CSV2
						} else {
							printRecord("GIACR199");
						}*/
					} else {
						printRecord("GIACR196", "Statement Of Accounts (Intermediary with NET)");
					}
				} else if($("rdoWithoutNet").checked){ // no_net
					printRecord("GIACR193", "Statement of Accounts (Intermediary without NET)");
				} else if($("rdoSOANetComm").checked){ // SOA net of comm
					printRecord("SOA_NET", "Statement of Account Net of Commission");
				} else {
					showMessageBox("1 -- Unknown value in Layout Type radio button in Print Report.", "I");
				}
			
			// ASSURED
			} else if($("rdoByAssured").checked){
				if($("rdoAssdWithoutNet").checked){  // Assured without net
					printRecord("GIACR197", "Statement of Accounts (Assured without NET)");
				} else if($("rdoSOANetComm").checked){ // SOA net of comm
					printRecord("SOA_NET", "Statement of Account Net of Commission");
				} else {
					showMessageBox("2 -- Unknown value in Layout Type radio button in Print Report.", "I");
				}
			
			// LICENSE
			} else if($("rdoByLicense").checked){
				if($("rdoLicensed").checked){
					printRecord("GIACR257", "Statement of Account (Licensed)");
				} else if($("rdoUnlicensed").checked){
					printRecord("GIACR258", "Statement of Account (By Parent Intermediary)");
				} else {
					showMessageBox("Unknown value in License option.", "E");
				}
			} else {
				showMessageBox("Unknown value in Report By option.", "E");
			} //end: Layout2.checked = true   
		
		} else if($("rdoLayout3").checked){ //LAYOUT3
			printRecord("GIACR190E", "Reports on Premium Receivable");
		
		} else if(variableLoSw == "S"){
			// INTERMEDIARY
			if($("rdoByIntermediary").checked){
				if($("rdoSummary").checked){
					printRecord("GIACR190", "Statement Of Account (Intermediary Summary)");
				} else if($("rdoDetail").checked){
					/*if($("chkIncludePDC").checked){
						//showMessageBox(objCommonMessage.UNAVAILABLE_REPORT, "I");
							printRecord("GIACR189P", "Statement of Account (Intermediary Detail) - PDC");
					} else {*/ // both will use GIACR189, will only differ in printing of PDC [which is based on chkIncludePDC]
						printRecord("GIACR189", "Statement of Account (Intermediary Detail)");
					//}
				} else if($("rdoTaxBreakdown").checked){
					printRecord("GIACR193A", "Schedule of Account - Intm (AUI) Tax Breakdown");
				} else if($("rdoStatement").checked){
					printRecord("SOA", "Statement of Account");
				} else {
					showMessageBox("Unknown value in Report Type.", "E");
				}
				
			// ASSURED
			} else if($("rdoByAssured").checked){
				if($("rdoSummary").checked){
					printRecord("GIACR192", "Statement of Account (Assured Summary)");
				} else if($("rdoDetail").checked){
					if($("chkIncludePDC").checked){
						printRecord("GIACR191P", "Statement of Account (Assured Detailed) - PDC");
					} else {
						printRecord("GIACR191", "Statement of Account (Assured Detailed)");
					}
				} else if($("rdoTaxBreakdown").checked){
					printRecord("GIACR197A", "Schedule of Account - Assd (AUI) Tax Breakdown");
				} else if($("rdoStatement").checked){
					printRecord("SOA", "Statement of Account");
				} else {
					showMessageBox("Unknown value in Report Type.", "E");
				}
			
			// LICENSE
			} else if($("rdoByLicense").checked){
				if($("rdoLicensed").checked){
					printRecord("GIACR257", "Statement of Account (Licensed)");
				} else if($("rdoUnlicensed").checked){
					printRecord("GIACR258", "Statement of Account (By Parent Intermediary)");
				} else {
					showMessageBox("Unknown value in License Option.", "E");
				}
			}
		} else if(variableLoSw == "L"){
			if($("rdoLicensed").checked){
				printRecord("GIACR257", "Statement of Account (Licensed)");
			} else if($("rdoUnlicensed").checked){
				printRecord("GIACR258", "Statement of Account (By Parent Intermediary)");
			} else {
				showMessageBox("Unknown value in License Option.", "E");
			}
		} else {
			showMessageBox("Unknown value in variableLoSw in Print Record", "E");
		}
	}
	
	function checkRequiredParams(){
		var proceed = true;
		if($("rdoFromTo").checked){
			if($("chkBookTag").checked){
				if($F("txtBookDateTo") == "" || $F("txtBookDateFrom") == ""){
					showMessageBox("Some dates entered are NULL.", "I");
					if($F("txtBookDateFrom") == ""){
						$("txtBookDateFrom").focus();
					} else if($F("txtBookDateTo") == ""){
						$("txtBookDateTo").focus();
					}
					proceed = false;
				} else {
					if(!validateFromToDate("txtBookDateFrom", "txtBookDateTo", "txtBookDateFrom")){
						proceed = false;
					}
				}
			}
			
			if($("chkInceptTag").checked){
				if($F("txtIncepDateTo") == "" || $F("txtIncepDateFrom") == ""){
					showMessageBox("Some dates entered are NULL.", "I");
					if($F("txtIncepDateFrom") == ""){
						$("txtIncepDateFrom").focus();
					} else if($F("txtIncepDateTo") == ""){
						$("txtIncepDateTo").focus();
					}
					proceed =  false;
				} else {
					if(!validateFromToDate("txtIncepDateFrom", "txtIncepDateTo", "txtIncepDateFrom")){
						proceed = false;
					}
				}
			}
			
			if($("chkIssueTag").checked){
				if($F("txtIssueDateTo") == "" || $F("txtIssueDateFrom") == ""){
					showMessageBox("Some dates entered are NULL.", "I");
					if($F("txtIssueDateFrom") == ""){
						$("txtIssueDateFrom").focus();
					} else if($F("txtIssueDateTo") == ""){
						$("txtIssueDateTo").focus();
					}
					proceed = false;
				} else {
					if(!validateFromToDate("txtIssueDateFrom", "txtIssueDateTo", "txtIssueDateFrom")){
						proceed = false;
					}
				}
			}
			
			if($("chkIssueTag").checked == false && $("chkInceptTag").checked == false && $("chkBookTag").checked == false){
				showMessageBox("No box checked. Please check a box and enter the period to be used.", "I");
				proceed = false;
			}
		}else {
			if($("chkBookTag").checked || $("chkInceptTag").checked || $("chkIssueTag").checked){
				if($("rdoAsOf").checked == false && $("rdoFromTo").checked == false){  //|| condition added by Kris 
					showMessageBox("Some dates entered are NULL.", "I");
					proceed = false;
					$("txtAsOfDate").focus();
				}
			}
			
			if($("chkIssueTag").checked == false){
				if($("chkInceptTag").checked == false){
					if($("chkBookTag").checked == false){
						showMessageBox("No box checked. Please check a box and enter the period to be used.", "I");
						proceed = false;
					}
				}
			}
		}
		
		if($("rdoAsOf").checked){
			if($F("txtAsOfDate") == ""){
				showMessageBox("Some dates entered are NULL.", "I");
				proceed = false;
			}			
		}
		
		if($F("txtCutOffDate") == ""){
			showMessageBox("Some dates entered are NULL.", "I");
			proceed = false;
		}
		
		return proceed;
	}
	
	$("btnPrint").observe("click", function(){		
		if (checkRequiredParams()){
			var hasUserData = "";
			preparePrevParams();
			try {
				new Ajax.Request(contextPath + "/GIACCreditAndCollectionReportsController",{
					parameters : {
						action : "checkUserData"
					},
					onComplete : function(response){
						if(checkErrorOnResponse(response)){
							hasUserData = response.responseText;
							
							if(nvl(hasUserData, "N") == "N"){
								showMessageBox("You currently have no data in the extract table. Please extract the data by entering the desired period and clicking 'EXTRACT' button.");
							} else {
								/*if(variableLoSw == "H"){  //VARIABLES.lo_sw = H >> Layout2
									// INTERMEDIARY
									if($("rdoByIntermediary").checked){ 
										if($("rdoWithNet").checked){  // with_net
											if($("chkWholdingTax").checked){
												printRecord("GIACR199", "Statement of Accounts (Intermediary with NET and Witholding Tax)");
												/*if($F("selDestination") == "file"){
													//SOA_CSV2
												} else {
													printRecord("GIACR199");
												}* /
											} else {
												printRecord("GIACR196", "Statement Of Accounts (Intermediary with NET)");
											}
										} else if($("rdoWithoutNet").checked){ // no_net
											printRecord("GIACR193", "Statement of Accounts (Intermediary without NET)");
										} else if($("rdoSOANetComm").checked){ // SOA net of comm
											printRecord("SOA_NET", "Statement of Account Net of Commission");
										} else {
											showMessageBox("1 -- Unknown value in Layout Type radio button in Print Report.", "I");
										}
									
									// ASSURED
									} else if($("rdoByAssured").checked){
										if($("rdoAssdWithoutNet").checked){  // Assured without net
											printRecord("GIACR197", "Statement of Accounts (Assured without NET)");
										} else if($("rdoSOANetComm").checked){ // SOA net of comm
											printRecord("SOA_NET", "Statement of Account Net of Commission");
										} else {
											showMessageBox("2 -- Unknown value in Layout Type radio button in Print Report.", "I");
										}
									
									// LICENSE
									} else if($("rdoByLicense").checked){
										if($("rdoLicensed").checked){
											printRecord("GIACR257", "Statement of Account (Licensed)");
										} else if($("rdoUnlicensed").checked){
											printRecord("GIACR258", "Statement of Account (By Parent Intermediary)");
										} else {
											showMessageBox("Unknown value in License option.", "E");
										}
									} else {
										showMessageBox("Unknown value in Report By option.", "E");
									} //end: Layout2.checked = true   
								
								} else if($("rdoLayout3").checked){ //LAYOUT3
									printRecord("GIACR190E", "Reports on Premium Receivable");
								
								} else if(variableLoSw == "S"){
									// INTERMEDIARY
									if($("rdoByIntermediary").checked){
										if($("rdoSummary").checked){
											printRecord("GIACR190", "Statement Of Account (Intermediary Summary)");
										} else if($("rdoDetail").checked){
											if($("chkIncludePDC").checked){
												//showMessageBox(objCommonMessage.UNAVAILABLE_REPORT, "I");
													printRecord("GIACR189P", "Statement of Account (Intermediary Detail) - PDC");
											} else {
												printRecord("GIACR189", "Statement of Account (Intermediary Detail)");
											}
										} else if($("rdoTaxBreakdown").checked){
											printRecord("GIACR193A", "Schedule of Account - Intm (AUI) Tax Breakdown");
										} else if($("rdoStatement").checked){
											printRecord("SOA", "Statement of Account");
										} else {
											showMessageBox("Unknown value in Report Type.", "E");
										}
										
									// ASSURED
									} else if($("rdoByAssured").checked){
										if($("rdoSummary").checked){
											printRecord("GIACR192", "Statement of Account (Assured Summary)");
										} else if($("rdoDetail").checked){
											if($("chkIncludePDC").checked){
												printRecord("GIACR191P", "Statement of Account (Assured Detailed) - PDC");
											} else {
												printRecord("GIACR191", "Statement of Account (Assured Detailed)");
											}
										} else if($("rdoTaxBreakdown").checked){
											printRecord("GIACR197A", "Schedule of Account - Assd (AUI) Tax Breakdown");
										} else if($("rdoStatement").checked){
											printRecord("SOA", "Statement of Account");
										} else {
											showMessageBox("Unknown value in Report Type.", "E");
										}
									
									// LICENSE
									} else if($("rdoByLicense").checked){
										if($("rdoLicensed").checked){
											printRecord("GIACR257", "Statement of Account (Licensed)");
										} else if($("rdoUnlicensed").checked){
											printRecord("GIACR258", "Statement of Account (By Parent Intermediary)");
										} else {
											showMessageBox("Unknown value in License Option.", "E");
										}
									}
								} else if(variableLoSw == "L"){
									if($("rdoLicensed").checked){
										printRecord("GIACR257", "Statement of Account (Licensed)");
									} else if($("rdoUnlicensed").checked){
										printRecord("GIACR258", "Statement of Account (By Parent Intermediary)");
									} else {
										showMessageBox("Unknown value in License Option.", "E");
									}
								} else {
									showMessageBox("Unknown value in variableLoSw in Print Record", "E");
								}*/ // moved inside proceedPrinting() : shan 03.02.2015
	
								checkParamChanges(proceedPrinting);	// checking of parameter changes
							}
						}
					}
				});
			} catch(e){
				showErrorMessage("btnPrint", e);
			}
			//printRecord(reportId);			
		}
	});
	
	$("btnPrintCollLetter").observe("click", function(){
		//check first if QUERY_ALLOWED
		preparePrevParams();
		if(objSOA.prevParams.viewType == "A" || objSOA.prevParams.viewType == "I"){
			objSOA.prevParams.cutOffDate = $F("txtCutOffDate"); // bonok :: 10.09.2014
			showPrintCollLetter();		
		}
	});
		
	$("btnReprintCollLetter").observe("click", function(){
		preparePrevParams();
		showReprintCollLetter();	
	});
		
	/*$("btnCancel").observe("click", function(){
		objSOA.prevParams = null;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});*/
	
	// menu exit
	$("statementOfAccountExit").observe("click", function(){
		//$("btnCancel").click();
		// goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
		objSOA.prevParams = null;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
	
	observeReloadForm("reloadForm", showSOAMainPage);
	
	setModuleId("GIACS180");
	setDocumentTitle("Statement of Accounts - Booked Policies");
	initializeAll();
	initializeAllMoneyFields();
	makeInputFieldUpperCase();
	initializeFields();
	observeChangeTagOnDate("hrefBookDateFrom", "txtBookDateFrom", function(){changeOnDate("txtBookDateFrom", "txtBookDateTo", 1);});
	observeChangeTagOnDate("hrefBookDateTo", "txtBookDateTo", function(){changeOnDate("txtBookDateFrom", "txtBookDateTo", 2);});
	observeChangeTagOnDate("hrefIncepDateFrom", "txtIncepDateFrom", function(){changeOnDate("txtIncepDateFrom", "txtIncepDateTo", 1);});
	observeChangeTagOnDate("hrefIncepDateTo", "txtIncepDateTo", function(){changeOnDate("txtIncepDateFrom", "txtIncepDateTo", 2);});
	observeChangeTagOnDate("hrefIssueDateFrom", "txtIssueDateFrom", function(){changeOnDate("txtIssueDateFrom", "txtIssueDateTo", 1);});
	observeChangeTagOnDate("hrefIssueDateTo", "txtIssueDateTo", function(){changeOnDate("txtIssueDateFrom", "txtIssueDateTo", 2);});
</script>