<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="uwReportsMainDiv" name="uwReportsMainDiv">
	<div id="uwReportsMenuDiv" name="uwReportsMenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit" name="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>UW Reports</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div id="groDiv" name="groDiv" class="sectionDiv" style="margin-bottom: 30px;">
		<input type="hidden">
		<div id="tabComponentsDiv1" class="tabComponents1" style="float: left;">
			<ul>
				<li class="tab1 selectedTab1"><a id="perPolicyEndorsement">Per Policy/Endorsement</a></li>
				<li class="tab1"><a id="distribution">Distribution</a></li>
				<li class="tab1"><a id="outwardRi">Outward RI</a></li>
				<li class="tab1"><a id="perPerilAgent">Per Peril/Agent</a></li>
				<li class="tab1"><a id="perAssdIntm">Per Assd/Intm</a></li>
				<li class="tab1"><a id="inwardRi">Inward RI</a></li>
				<li class="tab1"><a id="undistributed">Undistributed</a></li>
				<li class="tab1"><a id="policyRegister">Policy Register</a></li>
			</ul>
		</div>
		<div class="tabBorderBottom1"></div>
		
		<div id="uwReportsSubDiv" name="uwReportsSubDiv">
			<div class="" style="float: left; padding:15px 0 15px 0;">
				<div id="txtFieldsDiv" name="txtFieldsDiv" class="sectionDiv" style="margin-left: 15px; padding-top: 5px; width: 586px; height: 251px;" align="center">
					<table align="center" style="margin-top: 45px;">
						<tr>
							<td class="rightAligned" id="lblCreditingBranch" name="lblCreditingBranch">&nbsp&nbsp&nbsp&nbsp&nbspIssue Source :</td>
							<td>
								<span class="lovSpan" style="width: 90px;">
									<input id="issCd" name="issCd" class="leftAligned upper" type="text" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="">
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCd" name="searchIssCd" alt="Go" style="float: right;"/>
								</span>
							</td>
							<td style="padding-bottom: 3px;"><input tabindex="-1" id="issName" name="issName" type="text" readonly="readonly" style="height: 14px; width: 225px;" value=""></td>
						</tr>
						<tr>
							<td class="rightAligned">Line :</td>
							<td>
								<span class="lovSpan" style="width: 90px;">
									<input id="lineCd" name="lineCd" class="leftAligned upper" type="text" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="">
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
								</span>
							</td>
							<td style="padding-bottom: 3px;"><input tabindex="-1" id="lineName" name="lineName" type="text" readonly="readonly" style="height: 14px; width: 225px;" value=""></td>
						</tr>
						<tr>
							<td class="rightAligned">Subline :</td>
							<td>
								<span class="lovSpan" style="width: 90px;">
									<input id="sublineCd" name="sublineCd" class="leftAligned upper" type="text" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="">
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCd" name="searchSublineCd" alt="Go" style="float: right;"/>
								</span>
							</td>
							<td style="padding-bottom: 3px;"><input tabindex="-1" id="sublineName" name="sublineName" type="text" readonly="readonly" style="height: 14px; width: 225px;" value=""></td>
						</tr>
					</table>
					<table align="center" style="margin-top: 25px; margin-left: 135px;">
						<tr>
							<td class="rightAligned">From :</td>
							<td>
								<div style="float: left; border: solid 1px gray; width: 148px; height: 20px; margin-right: 3px;">
									<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 81%; border: none;" name="fromDate" id="fromDate" readonly="readonly"/>
									<img id="imgFmDate" alt="goPolicyNo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('fromDate'),this, null);"/>						
								</div>
							</td>
							<td class="leftAligned"><label style="padding-top: 2px; margin-top: 2px;">To :</label>
								<div style="float: left; border: solid 1px gray; width: 148px; height: 20px; margin-right: 3px;">
									<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 81%; border: none;" name="toDate" id="toDate" readonly="readonly"/>
									<img id="imgToDate" alt="goPolicyNo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('toDate'),this, null);"/>						
								</div>
							</td>
						</tr>
					</table>
				</div>
				
				<div id="optionsDiv" name="optionsDiv" class="sectionDiv" style="width: 300px; float: right; margin-right: 15px;">
					<label style="text-align: center; padding-left: 9px; padding-top: 5px; padding-bottom: 2px; font-weight: bold; border-bottom: 1px solid #E0E0E0; width: 290px;">Parameter</label>
					<table align="left" style="margin: 3px;">
						<tr><td><input value="1" title="Crediting Branch" type="radio" id="creditingBranch" name="parameterRG" style="margin: 0 5px 0 5px; float: left;"><label for="creditingBranch">Crediting Branch</label></td></tr>
						<tr><td><input value="2" title="Issue Source" type="radio" id="issueSource" name="parameterRG" style="margin: 0 5px 0 5px; float: left;"><label for="issueSource">Issue Source</label></td></tr>
					</table>
				</div>
				<div id="dateDiv" name="dateDiv" class="sectionDiv" style="width: 300px; float: right; margin-right: 15px;">
					<label style="padding-left: 9px; padding-top: 5px; padding-bottom: 2px; font-weight: bold; text-align: center; border-bottom: 1px solid #E0E0E0; width: 290px;">Date</label>
					<table align="left" style="margin: 3px;">
						<tr><td><input value="1" title="Issue Date" type="radio" id="issueDate" name="dateRG" style="margin: 0 5px 0 5px; float: left;"><label for="issueDate">Issue Date</label></td></tr>
						<tr><td><input value="2" title="Incept Date" type="radio" id="inceptDate" name="dateRG" style="margin: 0 5px 0 5px; float: left;"><label for="inceptDate">Incept Date</label></td></tr>
						<tr><td><input value="3" title="Booking Month/Year" type="radio" id="booking" name="dateRG" style="margin: 0 5px 0 5px; float: left;"><label for="booking">Booking Month/Year</label></td></tr>
						<tr><td><input value="4" title="Acctg Entry Date" type="radio" id="acctgEntry" name="dateRG" style="margin: 0 5px 0 5px; float: left;"><label for="acctgEntry">Acctg Entry Date</label></td></tr>
					</table>
				</div>
				<div id="scopeDiv" name="scopeDiv" class="sectionDiv" style="width: 300px; float: right; margin-right: 15px;">
					<label style="padding-left: 9px; padding-top: 5px; padding-bottom: 2px; font-weight: bold; text-align: center; border-bottom: 1px solid #E0E0E0; width: 290px;">Scope</label>
					<table align="left" style="margin: 3px;">
						<tr><td><input value="1" title="Policies Only" type="radio" id="policiesOnly" name="scopeRG" style="margin: 0 5px 0 5px; float: left;"><label for="policiesOnly">Policies Only</label></td></tr>
						<tr><td><input value="2" title="Endorsements Only" type="radio" id="endorsementsOnly" name="scopeRG" style="margin: 0 5px 0 5px; float: left;"><label for="endorsementsOnly">Endorsements Only</label></td></tr>
						<tr><td><input value="3" title="Cancelled" type="radio" id="cancelled" name="scopeRG" style="margin: 0 5px 0 5px; float: left;"><label for="cancelled">Cancelled</label></td></tr>
						<tr><td><input value="4" title="Spoiled Policies" type="radio" id="spoiledPolicies" name="scopeRG" style="margin: 0 5px 0 5px; float: left;"><label for="spoiledPolicies">Spoiled Policies</label></td></tr>
							<tr><td style="padding-left:20px"><input value="4" title="Reinstated Policies Only" type="checkbox" id="reinstateTag" name="scopeRG" style="margin: 0 5px 0 5px; float: left;" disabled="disabled"><label id="reinstateTagLabel" for="reinstateTag" style="color:#bbbbbb;">Reinstated Policies Only</label></td></tr>
						<tr><td><input value="5" title="All (except spoiled policies)" type="radio" id="allExcSpoiled" name="scopeRG" style="margin: 0 5px 0 5px; float: left;"><label for="allExcSpoiled">All (except spoiled policies)</label></td></tr>
						<tr><td><input value="6" title="All (including spoiled policies)" type="radio" id="allIncSpoiled" name="scopeRG" style="margin: 0 5px 0 5px; float: left;"><label for="allIncSpoiled">All (including spoiled policies)</label></td></tr><!-- Added by pjsantos 03/14/2017, GENQA 5955-->
					</table>
				</div>
				
				<div class="sectionDiv" style="margin-left: 15px; float: left; width: 586px; height: 181px;" id="printDialogFormDiv">
					<table style="float: left; padding: 30px 0 0 80px;">
						<tr>
							<td class="rightAligned">Destination</td>
							<td class="leftAligned">
								<select id="selDestination" style="width: 200px;">
									<option value="SCREEN">Screen</option>
									<option value="PRINTER">Printer</option>
									<option value="FILE">File</option>
									<option value="LOCAL">Local Printer</option>
								</select>
							</td>
						</tr>
						<tr>
							<td></td>
							<td>
								<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0">PDF</label>
								<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left; display: none;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0; display: none;">Excel</label> <!-- apollo cruz 05.06.2015 - hides excel option - GENQA SR# 4359 -->
								<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 50px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0">CSV</label>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Printer</td>
							<td class="leftAligned">
								<select id="selPrinter" style="width: 200px;" class="required">
									<option></option>
									<c:forEach var="p" items="${printers}">
										<option value="${p.name}">${p.name}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">No. of Copies</td>
							<td class="leftAligned">
								<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required">
								<div style="float: left; width: 15px;">
									<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
									<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
									<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
									<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
								</div>					
							</td>
						</tr>
					</table>
					<table style="float: left; padding-top: 40px;">
						<tr><td><input type="button" class="button" style="width: 120px; margin-left: 15px;" id="btnExtract" name="btnExtract" value="Extract"></td></tr>
						<tr><td><input type="button" class="button" style="width: 120px; margin-left: 15px;" id="btnPrint" name="btnPrint" value="Print"></td></tr>
						<tr><td><input type="button" class="button" style="width: 120px; margin-left: 15px;" id="btnCancel" name="btnCancel" value="Cancel"></td></tr>
					</table>
				</div>
				
				<div id="typeDiv" name="typeDiv" class="sectionDiv" style="width: 300px; float: right; margin-right: 15px;">
					<label style="padding-left: 9px; padding-top: 5px; padding-bottom: 2px; font-weight: bold;  text-align: center; border-bottom: 1px solid #E0E0E0; width: 290px;">Type</label>
					<table align="left" style="margin: 3px;">
						<tr><td><input value="1" title="Summary" type="radio" id="summary" name="typeRG" style="margin: 0 5px 0 5px; float: left;"><label for="summary">Summary</label></td></tr>
						<tr><td><input value="2" title="Detail" type="radio" id="detail" name="typeRG" style="margin: 0 5px 0 5px; float: left;"><label for="detail">Detail</label></td></tr>
						<tr><td><input value="3" title="With Acct Ent Date Break" type="radio" id="withAcctEntDate" name="typeRG" style="margin: 0 5px 0 5px; float: left;"><label for="withAcctEntDate">With Acct Ent Date Break</label></td></tr>
						<tr><td><input value="4" title="With Distribution" type="radio" id="withDistribution" name="typeRG" style="margin: 0 5px 0 5px; float: left;"><label for="withDistribution">With Distribution</label></td></tr>
					</table>
				</div>
				<div id="edstDiv" name=""edstDiv"" class="sectionDiv" style="width: 300px; float: right; margin-right: 15px;">
					<table align="center" style="padding: 3px;">
						<tr><td><input title="Include Special Policies" type="checkbox" id="incSpecialPolicies" name="incSpecialPolicies" style="margin: 0 5px 0 5px; float: left;"><label for="incSpecialPolicies">Include Special Policies</label></td></tr>
						<c:if test="${allowEdstReport eq 'Y'}"> <!-- marco - 05.23.2013 - added condition -->
							<tr><td><input type="button" class="button" style="width: 120px; margin-left: 15px;" id="btnEdst" name="btnEdst" value="EDST"></td></tr>
						</c:if>
					</table>
				</div>
				<div id="lastExtractDiv" name="lastExtractDiv">
					<input id="lastFromDate" name="lastFromDate" type="hidden">
					<input id="lastToDate" name="lastToDate" type="hidden">
					<input id="lastDateParam" name="lastDateParam" type="hidden">
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	if(objGIPIS100.callingForm == "GIACS000"){
		$("mainNav").hide();
	}
	
	initializeAll();
	initializeAccordion();
	setDocumentTitle("UW Reports");
	setModuleId("GIPIS901A");
	toggleRequiredFields("screen");
	initializeDefaultParameters();
	makeInputFieldUpperCase();
	initializeTabs();
	
	objUW.uwReports = new Object();
	objUW.uwReports.edst = 'N';
	objUW.uwReports.edstScope = 1;
	objUW.uwReports.edstCtpPol = 1;
	
	observeReloadForm("reloadForm", showUWProductionReportsMainPage);
	objUW.lastExtractInfo = JSON.parse('${lastExtractInfo}'.replace(/\\/g, '\\\\'));
	initializeLastExtractInfo();
	
	var dateParam = 0;
	var branchParam = 0;
	var scopeParam = 0;
	function toggleRequiredFields(dest){
		if(dest == "PRINTER"){			
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("selPrinter").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			$("pdfRB").disabled = true;
			$("excelRB").disabled = true;
			$("csvRB").disabled = true;
		} else {
			$("selPrinter").value = "";
			$("txtNoOfCopies").value = "";
			$("selPrinter").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("selPrinter").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();
			if(dest == "FILE"){
				$("pdfRB").disabled = false;
				$("excelRB").disabled = false;
				$("csvRB").disabled = false;
			}else{
				$("pdfRB").disabled = true;
				$("excelRB").disabled = true;
				$("csvRB").disabled = true;
			}
		}
	}
	
// 	$("spoiledPolicies").observe("click", function(){
// 		if($("spoiledPolicies").checked){
// 			$("reinstateTag").enable();
// 		}else{
// 			$("reinstateTag").disable();
// 		}
// 	});
	
	$$("div#scopeDiv input[type='radio']").each(function (a) { //added by steven 1/30/2013
		a.observe("click", function(){
			if($("spoiledPolicies").checked){
				$("reinstateTag").enable();
				$("reinstateTagLabel").style.color = "";
			}else{
				$("reinstateTag").disable();
				$("reinstateTagLabel").setStyle("color:#bbbbbb;");
				$("reinstateTag").checked = false;
			}
		});
	});
	
	$("imgSpinUp").observe("click", function(){
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
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});
	
	function setCurrentTab(id){
		$$("div.tabComponents1 a").each(function(a){
			if(a.id == id) {
				$(id).up("li").addClassName("selectedTab1");					
			}else{
				a.up("li").removeClassName("selectedTab1");	
			}	
		});
	}
	observeAccessibleModule(accessType.MENU, "GIPIS901A", "perPolicyEndorsement", function(){
		setCurrentTab("perPolicyEndorsement");
		showUWProductionReportsMainPage();
	});
	observeAccessibleModule(accessType.MENU, "GIPIS901A", "distribution", function(){
		setCurrentTab("distribution");
		showUWProductionReportsPage("showDistributionTab");
	});
	observeAccessibleModule(accessType.MENU, "GIPIS901A", "outwardRi", function(){
		setCurrentTab("outwardRi");
		showUWProductionReportsPage("showOutwardRiTab");
	});
	observeAccessibleModule(accessType.MENU, "GIPIS901A", "perPerilAgent", function(){
		setCurrentTab("perPerilAgent");
		showUWProductionReportsPage("perPeril");
	});
	observeAccessibleModule(accessType.MENU, "GIPIS901A", "perAssdIntm", function(){
		setCurrentTab("perAssdIntm");
		showUWProductionReportsPage("perAssd");
	});
	observeAccessibleModule(accessType.MENU, "GIPIS901A", "inwardRi", function(){
		setCurrentTab("inwardRi");
		showUWProductionReportsPage("showInwardRiTab");
	});
	observeAccessibleModule(accessType.MENU, "GIPIS901A", "undistributed", function(){
		setCurrentTab("undistributed");
		showUWProductionReportsPage("showUndistributedTab");
	});
	observeAccessibleModule(accessType.MENU, "GIPIS901A", "policyRegister", function(){
		setCurrentTab("policyRegister");
		showUWProductionReportsPage("showPolicyRegisterTab");
	});
	
	function initializeLastExtractInfo(){
		$("fromDate").value = objUW.lastExtractInfo.fromDate == null ? "" : dateFormat(unescapeHTML2(objUW.lastExtractInfo.fromDate), 'mm-dd-yyyy'); //change by steven 1/30/2013; dapat kapag null hindi sysdate ung lumabas
		$("toDate").value = objUW.lastExtractInfo.toDate == null ? "" : dateFormat(unescapeHTML2(objUW.lastExtractInfo.toDate), 'mm-dd-yyyy'); //change by steven 1/30/2013; dapat kapag null hindi sysdate ung lumabas
		$("issCd").value = unescapeHTML2(objUW.lastExtractInfo.issCd == null ? "" : objUW.lastExtractInfo.issCd);
		$("issName").value = unescapeHTML2(objUW.lastExtractInfo.issName == null ? "ALL ISSUE SOURCE" : objUW.lastExtractInfo.issName);
		$("lineCd").value = unescapeHTML2(objUW.lastExtractInfo.lineCd == null ? "" : objUW.lastExtractInfo.lineCd);
		$("lineName").value = unescapeHTML2(objUW.lastExtractInfo.lineName == null ? "ALL LINES" : objUW.lastExtractInfo.lineName);
		$("sublineCd").value = unescapeHTML2(objUW.lastExtractInfo.sublineCd == null ? "" : objUW.lastExtractInfo.sublineCd);
		$("sublineName").value = unescapeHTML2(objUW.lastExtractInfo.sublineName == null ? "ALL SUBLINES" : objUW.lastExtractInfo.sublineName);
		objUW.lastExtractInfo.specialPol == 'Y' ? $("incSpecialPolicies").checked = true : $("incSpecialPolicies").checked = false;
		objUW.lastExtractInfo.issParam == 1 ? credBranch()  : issSource();
		$$("input[name='dateRG']").each(function(checkbox) {
			if(objUW.lastExtractInfo.paramDate == checkbox.value){
				checkbox.checked = true;
				$("lastDateParam").value = checkbox.value;
			}
		});
		//benjo 09.28.2015 added scope
		$$("input[name='scopeRG']").each(function(checkbox) {
			if(objUW.lastExtractInfo.scope == checkbox.value){
				checkbox.checked = true;
			}
		});
		$("lastFromDate").value = $F("fromDate");
		$("lastToDate").value = $F("toDate");
		function credBranch(){
			$("creditingBranch").checked = true;
			document.getElementById("lblCreditingBranch").innerHTML = "Crediting Branch :";
		}
		function issSource(){
			$("issueSource").checked = true;
			document.getElementById("lblCreditingBranch").innerHTML = "&nbsp&nbsp&nbsp&nbsp&nbspIssue Source :";
		}
	}
	
	function showEdstOverlay(){
		edstOverlay = Overlay.show(contextPath+"/GIPIUwreportsExtController", {
			urlContent : true,
			draggable: true,
			urlParameters: {action: "showEdstOverlay"},
		    title: "EDST",
		    height: 260,
		    width: 312
		});
	}
	
	function initializeDefaultParameters(){
		$("summary").checked = true;
		$("allExcSpoiled").checked = true;
		$("issueSource").checked = true;
		$("issueDate").checked = true;
		$("incSpecialPolicies").checked = false;
		document.getElementById("lblCreditingBranch").innerHTML = "&nbsp&nbsp&nbsp&nbsp&nbspIssue Source :";
	}
	
	$("issCd").observe("blur", function(){
		if($("issCd").value != ""){
			validateUwReportsIssCd();
		}else{
			$("issName").value = "ALL ISSUE SOURCE";
		}
	});
	
	$("lineCd").observe("blur", function(){
		if($("lineCd").value != ""){
			validateUwReportsLineCd();
		}else{
			$("lineName").value = "ALL LINES";
		}
	});
	
	$('sublineCd').observe("blur", function(){
		if($("sublineCd").value != ""){
			if($("lineCd").value == null || $("lineCd").value == ""){
				clearFocusElementOnError("sublineCd", "Invalid value for field SUBLINE_CD.");
			}else{
				validateUwReportsSublineCd();
			}
		}else{
			$("sublineName").value = "ALL SUBLINES";
		}
	});
	
	$("searchIssCd").observe("click", function(){
		showUwReportsIssLOV();
	});
	
	$("searchLineCd").observe("click", function(){
		showUwReportsLineLOV();
	});
	
	$("searchSublineCd").observe("click", function(){
		$F("lineCd") == '' || $F("lineCd") == null ? showMessageBox("List Of Values contains no entries.", "I") : showUwReportsSublineLOV();
	});
	
	if('${allowEdstReport}' == "Y"){ //marco - 05.23.2013 - added condition
		$("btnEdst").observe("click", function(){
			showEdstOverlay();
		});
	}
	
	$("btnExtract").observe("click", extract);
	
	function extract(){
		if($("fromDate").value == "" || $("fromDate").value == null){
			clearFocusElementOnError("fromDate", "Please enter a From Date");
		}else if($("toDate").value == "" || $("toDate").value == null){
			clearFocusElementOnError("toDate", "Please enter a To Date");
		}else if(Date.parse($("fromDate").value) > Date.parse($("toDate").value)){
			showMessageBox("From Date should be earlier than To Date.", "I");
		}else{
			getUwReportsParams();
		}
	}
	
	function getUwReportsParams(){
		$$("input[name='parameterRG']").each(function(checkbox) {
			checkbox.checked == true ? branchParam = checkbox.value : null;  
		});
		$$("input[name='dateRG']").each(function(checkbox) {
			checkbox.checked == true ? dateParam = checkbox.value : null;  
		});
		$$("input[name='scopeRG']").each(function(checkbox) {
			checkbox.checked == true ? scopeParam = checkbox.value : null;  
		});
		if(objUW.uwReports.edst == 'Y'){
			checkUwReportsEdst();
		}else{
			checkUwReports();
		}
	}
	
	function checkUwReportsEdst(){
		new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
			parameters: {
						action      : "checkUwReports",
						tabCheck    : "edst",
						edstScope   : objUW.uwReports.edstScope,
						dateParam   : dateParam,
						fromDate    : $F("fromDate"),
						toDate      : $F("toDate"),
						branchParam : branchParam,
						lineCd 	    : $F("lineCd"),
						sublineCd   : $F("sublineCd"),
						issCd       : $F("issCd")
						},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Processing information, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(response.responseText == 'Y'){
						showConfirmBox("", "Data based from the given parameters were already extracted. Do you still want to continue?", "Ok", "Cancel", extractUwReports, "", "");
					}else{
						extractUwReports();
					}
				}
			}
		});
	}
	
	function checkUwReports(){
		new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
			parameters: {
						action          : "checkUwReports",
						tabCheck        : "nonEdst",
						scopeParam      : scopeParam,
						dateParam       : dateParam,
						fromDate        : $F("fromDate"),
						toDate          : $F("toDate"),
						branchParam     : branchParam,
						specialPolParam : $("incSpecialPolicies").checked ? 'Y' : 'N',
						lineCd 	    	: $F("lineCd"),
						sublineCd       : $F("sublineCd"),
						issCd           : $F("issCd")
						},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Processing information, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(response.responseText == 'Y'){
						showConfirmBox("", "Data based from the given parameters were already extracted. Do you still want to continue?", "Ok", "Cancel", extractUwReports, "", "");
					}else{
						extractUwReports();
					}
				}
			}
		});
	}
	
	var extracted = "Y";
	function extractUwReports(){
		new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
			parameters: {
						action      	: "extractUwReports",
						tabExtract		: "polEndt",
						edstCtr     	: objUW.uwReports.edst,
						edstScope   	: objUW.uwReports.edstScope,
						edstCtpPol		: objUW.uwReports.edstCtpPol,
						dateParam   	: dateParam,
						fromDate    	: $F("fromDate"),
						toDate      	: $F("toDate"),
						issCd	    	: $F("issCd"),
						lineCd      	: $F("lineCd"),
						sublineCd   	: $F("sublineCd"),
						branchParam 	: branchParam,
						scopeParam      : scopeParam,
						specialPolParam : $("incSpecialPolicies").checked ? 'Y' : 'N',
						reinstateTag    : $("reinstateTag").checked ? 'Y' : 'N', //added reinstateTag and withdist parameters : edgar 03/06/2015
						withdist		: 'Y'		
						},
			asynchronous: false,
			evalScripts: true,
			onCreate : function() {
				showNotice("Working, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){ //apollo cruz 06.23.2015 - added checkCustomErrorOnResponse to handle raise application errors
					showMessageBox(response.responseText, "I");
					if(response.responseText == "Extraction Process Done."){
						extracted = "Y";
						$("lastFromDate").value = $F("fromDate");
						$("lastToDate").value = $F("toDate");
						$("lastDateParam").value = dateParam;
					}else{
						extracted = "N";
					}
				}
			}
		});
	}
	
	$("btnPrint").observe("click", function(){
		if(extracted == "Y"){
			if(isLastExtract()){
				validateBeforePrint();
			}else{
				var dateTitle = "";
				$$("input[name='dateRG']").each(function(checkbox) {
					if(checkbox.checked){
						dateTitle = checkbox.title;
					}
				});
				showConfirmBox("", "Your last extract was based on " + dateTitle + " from " + dateFormat($F("lastFromDate"), 'mmmm dd, yyyy') +
						" to " + dateFormat($F("lastToDate"), 'mmmm dd, yyyy') + ". Click Ok to print a report based on your last extract " +
						"or press Cancel to abort.", "Ok", "Cancel", validateBeforePrint, "", "");
			}
		}else{
			showMessageBox("No Data Extracted.", "I");
		}
	});
	
	function validateBeforePrint(){
		$$("input[name='parameterRG']").each(function(checkbox) {
			checkbox.checked == true ? branchParam = checkbox.value : null;  
		});
		new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
			parameters: {
						action      : "validatePrint",
						printTab    : "polEndt",
						edstCtr		: objUW.uwReports.edst,
						branchParam : branchParam,
						issCd		: $F("issCd"),
						lineCd		: $F("lineCd"),
						sublineCd	: $F("sublineCd")
						},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Processing information, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(response.responseText == null || response.responseText == ""){
						showMessageBox("No Data Extracted.", "I");
					}else{
						proceedPrint();
					}
				}
			}
		});
	}
	
	function proceedPrint(){
		if($F("selDestination") == "PRINTER" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
			showMessageBox(objCommonMessage.REQUIRED, "I");
		}else if($F("selDestination") == "PRINTER" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
			showMessageBox("Invalid number of copies.", "I");
		}else{
			printUwReports();
		}
	}
	
	var prodReport = '${prodReport}';
	function printUwReports(){
		if(objUW.uwReports.edst == "Y"){
			//showMessageBox("Report is not yet existing.", "I");//here yosh
			printProdReport("printEDST"); //added by clperello 06.10.2014
		}else{
			if($("summary").checked){
				if($("cancelled").checked != true){
					if(prodReport == 1){
						printProdReport("printGIPIR924");  
					}else if(prodReport == 2){
						//showMessageBox("Report is not yet existing.", "I");
						//GIPIR924_MX
						printProdReport("printGIPIR924");  // added by Jhing 08.05.2015 UW-SPECS-2015-057-FULLWEB
					}else if(prodReport == null || prodReport == ""){
						showMessageBox("Parameter 'PROD_REPORT_EXTRACT' does not exist in GIIS_PARAMETERS.", "E");
					}
				}else{
					//showMessageBox("Report is not yet existing.", "I");
					printProdReport("printGIPIR924J"); //added by steven 1/17/2013
				}
			}else if($("detail").checked){
				if($("cancelled").checked){
					//printProdReport("printGIPIR923J");
					printProdReport("printGIPIR923"); // added by apollo cruz 06.16.2015 - UW-SPECS-2015-057-FULLWEB
				}else if($("spoiledPolicies").checked){
					//printProdReport("printGIPIR923E");
					printProdReport("printGIPIR923"); // added by apollo cruz 06.16.2015 - UW-SPECS-2015-057-FULLWEB
				}else{
					if("${prodReport}" == 1){
						printProdReport("printGIPIR923");
					}else if("${prodReport}" == 2){
						//showMessageBox("Report is not yet existing.", "I");
						//GIPIR923_MX
						printProdReport("printGIPIR923"); // added by apollo cruz 06.16.2015 - UW-SPECS-2015-057-FULLWEB
					}else if("${prodReport}" == null || "${prodReport}" == ""){
						showMessageBox("Parameter 'PROD_REPORT_EXTRACT' does not exist in GIIS_PARAMETERS.", "E");
					}
				}
			}else if($("withAcctEntDate").checked){
				/*if($("cancelled").checked){
					printProdReport("printGIPIR923D");
				}else if($("spoiledPolicies").checked){
					printProdReport("printGIPIR923F");
				}else{
					printProdReport("printGIPIR923C");
				}*/ //benjo 09.24.2015 comment out
				
				//benjo 09.24.2015 UW-SPECS-2015-054-FULLWEB
				var vDate = "";
				$$("input[name='dateRG']").each(function(checkbox) {
					if(checkbox.checked){
						vDate = checkbox.id;
					}
				});
				
				if (vDate == 'acctgEntry'){
					showMessageBox("Break by Acct Ent Date Report is not available for extractions based on Acctg Entry Date.", "I");
				}else{
					printProdReport("printGIPIR923C");
				}
			}else if($("withDistribution").checked){		//added by: kenneth L. 02.28.2013
				printProdReport("printGIPIR924K");
			}else{
				showMessageBox("Report is not yet existing.", "I");
			}
		}
	}
	
	function isLastExtract(){
		var checkDateParam = 0;
		var result = true;
		$$("input[name='dateRG']").each(function(checkbox) {
			if(checkbox.checked){
				checkDateParam = checkbox.value;
			}
		});
		if($F("fromDate") != $F("lastFromDate") || $F("toDate") != $F("lastToDate") || checkDateParam != $F("lastDateParam")){
			result = false;
		}
		return result;
	}
	
	$("btnCancel").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("btnExit").observe("click", function(){
		if(objGIPIS100.callingForm == "GIACS000"){
			objGIPIS100.callingForm = null;			
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
			$("mainNav").show();
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	});
	
	$("creditingBranch").observe("click", function(){
		document.getElementById("lblCreditingBranch").innerHTML = "Crediting Branch :";
	});
	
	$("issueSource").observe("click", function(){
		document.getElementById("lblCreditingBranch").innerHTML = "&nbsp&nbsp&nbsp&nbsp&nbspIssue Source :";
	});
		
	function printProdReport(action){
		$$("input[name='parameterRG']").each(function(checkbox) {
			checkbox.checked == true ? branchParam = checkbox.value : null;  
		});
		//benjo 09.28.2015 UW-SPECS-2015-057
		$$("input[name='dateRG']").each(function(checkbox) {
			checkbox.checked == true ? dateParam = checkbox.value : null;  
		});
		$$("input[name='scopeRG']").each(function(checkbox) {
			checkbox.checked == true ? scopeParam = checkbox.value : null;  
		});
		try {
			var specialPolParam = $("incSpecialPolicies").checked ? 'Y' : 'N';
			var edstCtpPol = objUW.uwReports.edstCtpPol;
			//var negAmountTag = objUW.uwReports.edstScope=1 ? 'Y' : 'N'; //removed by robert 01.13.15
			var negAmountTag = objUW.uwReports.edstScope == 1 ? 'Y' : 'N'; //added by robert 01.13.15
			if(objUW.uwReports.edst == 'Y'){ //added by robert SR 21836 03.10.2016
				scopeParam = objUW.uwReports.edstScope;
			}
			var content = contextPath+"/UWProductionReportPrintController?action="+action+"&issParam="+branchParam+
					"&scope="+scopeParam+"&issCd="+$F("issCd")+"&lineCd="+$F("lineCd")+"&sublineCd="+$F("sublineCd")+
					"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")+
					"&reportId="+action.substring(5) + "&fromDate=" + $F("fromDate") + "&toDate=" + $F("toDate")
					+ "&inc=" + specialPolParam + "&ctpl=" + edstCtpPol + "&negAmount=" + negAmountTag //added by clperello 06.11.2014
					+ "&paramDate=" + dateParam //benjo 09.28.2015 UW-SPECS-2015-057
					+ "&reinstated=" + ($("reinstateTag").checked ? "Y" : "N") + "&tabNumber=1"; //apollo cruz 06.16.2015 - UW-SPECS-2015-057-FULLWEB
			
			if($F("selDestination") == "SCREEN"){
				showPdfReport(content, getReportTitle(action));
			}else if($F("selDestination") == "PRINTER"){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "I");
						}
					}
				});
			}else if("FILE" == $F("selDestination")){
				var fileType = "PDF";
				
				if($("pdfRB").checked)
					fileType = "PDF";
				else if ($("excelRB").checked)
					fileType = "XLS";
				else if ($("csvRB").checked)
					fileType = "CSV";
					
				new Ajax.Request(content, {
					method: "POST",
					parameters : {
						destination : "FILE",
						fileType : fileType
					},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if ($("csvRB").checked){
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							}else
								copyFileToLocal(response);
						}
					}
				});
			}else if("LOCAL" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "LOCAL"},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							printToLocalPrinter(response.responseText);
						}
					}
				});
			}
		}catch(e){
			showErrorMessage("printProdReport: " + action, e);
		}
	}
	
	function getReportTitle(action){
		var title = "";
		if(action == "printGIPIR923"){
			title = "Premium Register Book"; /* changed report title of GIPIR923 from "Detailed Production Register" to "Premium Register Book" by SHARIE 04/10/2017 SR-5975 */
		}else if(action == "printGIPIR924"){
			title = "Summarized Production Register";
		}else if(action == "printGIPIR923J"){
			title = "List of Cancelled Policies";
		}else if(action == "printGIPIR923E"){
			title = "List of Spoiled Policies";
		}else if(action == "printGIPIR923D"){
			title = "List of Cancelled Policies";
		}else if(action == "printGIPIR923F"){
			title = "List of Spoiled Policies";
		}else if(action == "printGIPIR923C"){
			title = "Detailed Production Register";
		}else if(action == "printGIPIR924K"){		//added by: kenneth L. 02.28.2013
			title = "Production Register with Distribution Details";
		}
		return title;
	}
	
</script>