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
	<div id="uwReportsSubDiv" name="uwReportsSubDiv">
		<div class="" style="float: left; padding:15px 0 15px 0;">
			<div id="txtFieldsDiv" name="txtFieldsDiv" class="sectionDiv" style="padding-top: 5px; width: 586px; height: 251px; margin-left: 15px;" align="center">
				<table align="center" style="margin-top: 1px; margin-left: 5px;">
					<tr>
						<td class="rightAligned">Assured :</td>
						<td>
							<span class="lovSpan" style="width: 115px;">
								<input id="assdNo" name="assdNo" class="leftAligned upper" type="text" style="border: none; float: left; width: 85px; height: 13px; margin: 0px;" value="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssdNo" name="searchAssdNo" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td style="padding-bottom: 3px;"><input tabindex="-1" id="assdName" name="assdName" type="text" readonly="readonly" style="height: 14px; width: 325px;" value=""></td>
					</tr>
					<tr>
						<td class="rightAligned">Intermediary Type :</td>
						<td>
							<span class="lovSpan" style="width: 115px;">
								<input id="intmType" name="intmType" class="leftAligned upper" type="text" style="border: none; float: left; width: 85px; height: 13px; margin: 0px;" value="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmType" name="searchIntmType" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td style="padding-bottom: 3px;"><input tabindex="-1" id="intmTypeDesc" name="intmTypeDesc" type="text" readonly="readonly" style="height: 14px; width: 325px;" value=""></td>
					</tr>
					<tr>
						<td class="rightAligned">Intermediary :</td>
						<td>
							<span class="lovSpan" style="width: 115px;">
								<input id="intmNo" name="intmNo" class="leftAligned upper" type="text" style="border: none; float: left; width: 85px; height: 13px; margin: 0px;" value="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNo" name="searchIntmNo" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td style="padding-bottom: 3px;"><input tabindex="-1" id="intmName" name="intmName" type="text" readonly="readonly" style="height: 14px; width: 325px;" value=""></td>
					</tr>
				</table>
				
				<table align="center" style="margin-top: 10px;">
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
				<table align="center" style="margin-top: 10px; margin-left: 135px;">
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
			<div id="scopeDiv" name="scopeDiv" class="sectionDiv" style="width: 300px; float: right; margin-right: 15px; height: 88px;">
				<label style="padding-left: 9px; padding-top: 5px; padding-bottom: 2px; font-weight: bold; text-align: center; border-bottom: 1px solid #E0E0E0; width: 290px;">Scope</label>
				<table align="left" style="margin: 3px; margin-top: 6px;">
					<tr><td><input value="1" title="Policies Only" type="radio" id="policiesOnly" name="scopeRG" style="margin: 0 5px 0 5px; float: left;"><label for="policiesOnly">Policies Only</label></td></tr>
					<tr><td><input value="2" title="Endorsements Only" type="radio" id="endorsementsOnly" name="scopeRG" style="margin: 0 5px 0 5px; float: left;"><label for="endorsementsOnly">Endorsements Only</label></td></tr>
					<tr><td><input value="3" title="All" type="radio" id="all" name="scopeRG" style="margin: 0 5px 0 5px; float: left;"><label for="allExcSpoiled">All</label></td></tr>
				</table>
			</div>
			
			<div class="sectionDiv" style="float: left; width: 586px; height: 181px; margin-left: 15px;" id="printDialogFormDiv">
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
				<div style="border-bottom: 1px solid #E0E0E0; width: 300px; float: right;">
					<table align="left" style="margin: 3px;">
						<tr><td><input value="1" title="Per Assured" type="radio" id="perAssured" name="perilAssdRG" style="margin: 0 5px 0 5px; float: left;"><label for="perAssured">Per Assured</label></td></tr>
						<tr><td><input value="2" title="Per Intermediary" type="radio" id="perIntermediary" name="perilAssdRG" style="margin: 0 5px 0 5px; float: left;"><label for="perIntermediary">Per Intermediary</label></td></tr>
					</table>
				</div>
				<div style="border-bottom: 1px solid #E0E0E0; width: 300px; float: right;">
					<table align="left" style="margin: 3px;">
						<tr><td><input value="1" title="Summary" type="radio" id="summary" name="typeRG" style="margin: 0 5px 0 5px; float: left;"><label for="summary">Summary</label></td></tr>
						<tr><td><input value="2" title="Detail" type="radio" id="detail" name="typeRG" style="margin: 0 5px 0 5px; float: left;"><label for="detail">Detail</label></td></tr>
					</table>
				</div>
			</div>
			<div id="edstDiv" name="edstDiv"" class="sectionDiv" style="width: 300px; float: right; margin-right: 15px; height: 28px;">
				<table align="center" style="padding: 3px;">
					<tr><td><input title="Include Special Policies" type="checkbox" id="incSpecialPolicies" name="incSpecialPolicies" style="margin: 0 5px 0 5px; float: left;"><label for="incSpecialPolicies">Include Special Policies</label></td></tr>
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

<script type="text/javascript">
	toggleRequiredFields("screen");
	makeInputFieldUpperCase();
	initializeDefaultParameters();
	
	var dateParam = 0;
	var branchParam = 0;
	var scopeParam = 0;
	
	objUW.lastExtractInfo = JSON.parse('${lastExtractInfo}'.replace(/\\/g, '\\\\'));
	initializeLastExtractInfo();
	
	function initializeDefaultParameters(){
		$("summary").checked = true;
		$("perAssured").checked = true;
		$("all").checked = true;
		$("issueSource").checked = true;
		$("incSpecialPolicies").checked = false;
		$("issueDate").checked = true;
	}
	
	function initializeLastExtractInfo(){
		$("fromDate").value =objUW.lastExtractInfo.fromDate == null ? "" :  dateFormat(unescapeHTML2(objUW.lastExtractInfo.fromDate), 'mm-dd-yyyy'); //change by steven 1/30/2013; dapat kapag null hindi sysdate ung lumabas
		$("toDate").value = objUW.lastExtractInfo.toDate == null ? "" : dateFormat(unescapeHTML2(objUW.lastExtractInfo.toDate), 'mm-dd-yyyy'); //change by steven 1/30/2013; dapat kapag null hindi sysdate ung lumabas
		$("issCd").value = unescapeHTML2(objUW.lastExtractInfo.issCd == null ? "" : objUW.lastExtractInfo.issCd);
		$("issName").value = unescapeHTML2(objUW.lastExtractInfo.issName == null ? "ALL ISSUE SOURCE" : objUW.lastExtractInfo.issName);
		$("lineCd").value = unescapeHTML2(objUW.lastExtractInfo.lineCd == null ? "" : objUW.lastExtractInfo.lineCd);
		$("lineName").value = unescapeHTML2(objUW.lastExtractInfo.lineName == null ? "ALL LINES" : objUW.lastExtractInfo.lineName);
		$("sublineCd").value = unescapeHTML2(objUW.lastExtractInfo.sublineCd == null ? "" : objUW.lastExtractInfo.sublineCd);
		$("sublineName").value = unescapeHTML2(objUW.lastExtractInfo.sublineName == null ? "ALL SUBLINES" : objUW.lastExtractInfo.sublineName);
		$("assdNo").value = objUW.lastExtractInfo.assdNo == null ? "" : Number(objUW.lastExtractInfo.assdNo).toPaddedString(12);
		$("assdName").value = unescapeHTML2(objUW.lastExtractInfo.assdName == null ? "ALL ASSURED" : objUW.lastExtractInfo.assdName);
		$("intmType").value = unescapeHTML2(objUW.lastExtractInfo.intmType == null ? "" : objUW.lastExtractInfo.intmType);
		$("intmTypeDesc").value = unescapeHTML2(objUW.lastExtractInfo.intmDesc == null ? "ALL INTERMEDIARY TYPES" : objUW.lastExtractInfo.intmDesc);
		$("intmNo").value = objUW.lastExtractInfo.intmNo == null ? "" : Number(objUW.lastExtractInfo.intmNo).toPaddedString(12);
		$("intmName").value = unescapeHTML2(objUW.lastExtractInfo.intmName == null ? "ALL INTERMEDIARIES" : objUW.lastExtractInfo.intmName);
		objUW.lastExtractInfo.specialPol == 'Y' ? $("incSpecialPolicies").checked = true : $("incSpecialPolicies").checked = false;
		objUW.lastExtractInfo.issParam == 1 ? credBranch()  : issSource();
		$$("input[name='dateRG']").each(function(checkbox) {
			if(objUW.lastExtractInfo.paramDate == checkbox.value){
				checkbox.checked = true;
				$("lastDateParam").value = checkbox.value;
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
	
	$("btnCancel").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("creditingBranch").observe("click", function(){
		document.getElementById("lblCreditingBranch").innerHTML = "Crediting Branch :";
	});
	
	$("issueSource").observe("click", function(){
		document.getElementById("lblCreditingBranch").innerHTML = "&nbsp&nbsp&nbsp&nbsp&nbspIssue Source :";
	});
	
	$("searchAssdNo").observe("click", function(){
		showAssdNoLOV();
	});
	
	function showAssdNoLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action : "getAllAssdLOV"},
				title: "Valid values for Assured",
				width: 405,
				height: 386,
				columnModel:[
				             	{	id : "assdNo",
									title: "Assd No",
									width: '80px'
								},
								{	id : "assdName",
									title: "Assd Name",
									width: '308px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("assdNo").value = row.assdNo;
						$("assdName").value = row.assdName;
					}
				}
			});
		}catch(e){
			showErrorMessage("showAssdNoLOV",e);
		}
	}
	
	$("assdNo").observe("blur", function(){
		if($F("assdNo") != "" && (isNaN($F("assdNo") || $F("assdNo") < 0))){
			$("assdName").value = "ALL ASSURED";
			clearFocusElementOnError("assdNo", "Invalid value for field ASSD_NO.");
		}else if($("assdNo").value != ""){
			validateAssdNo();
		}else{
			$("assdName").value = "ALL ASSURED";
		}
	});
	
	function validateAssdNo(){
		new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
			method: "GET",
			parameters: {action : "validateAssdNo",
						 assdNo : $F("assdNo")},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.assdName == null){
						$("assdName").value = "ALL ASSURED";
						clearFocusElementOnError("assdNo", "Invalid value for field ASSD_NO.");
					}else{
						$("assdNo").value = Number($F("assdNo")).toPaddedString(12);
						$("assdName").value = obj.assdName;
					}
				}
			}
		});
	}
	
	var vIntmType = null; //benjo 10.28.2015 KB-334
	$("searchIntmType").observe("click", function(){
		vIntmType = $F("intmType"); //benjo 10.28.2015 KB-334
		showIntmTypeLOV();
	});
	
	function showIntmTypeLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action : "getIntmTypeLOV"},
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
				onSelect : function(row){
					if(row != undefined) {
						$("intmType").value = row.intmType;
						$("intmTypeDesc").value = row.intmDesc;
						if(row.intmType != vIntmType){ //benjo 10.27.2015 KB-334
							$("intmNo").value = "";
							$("intmName").value = "ALL INTERMEDIARIES";
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("showIntmTypeLOV",e);
		}
	}
	
	$("intmType").observe(/*"blur"*/"change", function(){ //benjo 10.28.2015 blur -> change
		$("intmType").value = trim($F("intmType")); //benjo 10.28.2015 KB-334
		if($("intmType").value != ""){
			validateIntmType();
		}else{
			$("intmTypeDesc").value = "ALL INTERMEDIARY TYPES";
		}
		$("intmNo").value = ""; //benjo 10.28.2015 KB-334
		$("intmName").value = "ALL INTERMEDIARIES"; //benjo 10.28.2015 KB-334
	});
	
	function validateIntmType(){
		new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
			method: "GET",
			parameters: {action   : "validateIntmType",
						 intmType : $F("intmType")},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.intmDesc == null){
						$("intmTypeDesc").value = "ALL INTERMEDIARY TYPES";
						clearFocusElementOnError("intmType", "Invalid value for field INTM_TYPE.");
					}else{
						$("intmTypeDesc").value = obj.intmDesc;
					}
				}
			}
		});
	}
	
	$("searchIntmNo").observe("click", function(){
		//showIntmLOV(); //benjo 10.28.2015 comment out
		showIntmLOV2(null); //benjo 10.28.2015 KB-334
	});
	
	function showIntmLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action : "getPrintExpReportIntmLOV"},
				title: "Valid values for Intermediary",
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
				onSelect : function(row){
					if(row != undefined) {
						$("intmNo").value = row.intmNo;
						$("intmName").value = row.intmName;
					}
				}
			});
		}catch(e){
			showErrorMessage("showIntmTypeLOV",e);
		}
	}
	
	/* benjo 10.28.2015 KB-334 */
	function showIntmLOV2(vIntmNo){
		try{
			LOV.show({
				controller: "UWReportsPrintingLOVController",
				urlParameters: {action   : "getGIPIS901AIntmLOV",
								intmType : $F("intmType"),
								intmNo   : vIntmNo == null ? "" : vIntmNo
							   },
				title: "Valid values for Intermediary",
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
			    autoSelectOneRecord : true,
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("intmNo").value = Number(row.intmNo).toPaddedString(12);
						$("intmName").value = row.intmName;
						$("intmType").value = row.intmType;
						$("intmTypeDesc").value = row.intmTypeDesc;
					}
				}
			});
		}catch(e){
			showErrorMessage("showIntmLOV",e);
		}
	}
	
	$("intmNo").observe(/*"blur"*/"change", function(){
		$("intmType").value = ""; //benjo 10.28.2015 KB-334
		$("intmTypeDesc").value = "ALL INTERMEDIARY TYPES"; //benjo 10.28.2015 KB-334
		$("intmNo").value = trim($F("intmNo")); //benjo 10.28.2015 KB-334
		if($F("intmNo") != "" && (isNaN($F("intmNo") || $F("intmNo") < 0))){
			$("intmName").value = "ALL INTERMEDIARIES";
			clearFocusElementOnError("intmNo", "Invalid value for field INTM_NO.");
		}else if($("intmNo").value != ""){
			validateIntmNo();
		}else{
			$("intmName").value = "ALL INTERMEDIARIES";
		}
	});
	
	function validateIntmNo(){
		new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
			method: "GET",
			parameters: {action : "validateIntmNo",
						 intmNo : $F("intmNo")},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.intmName == null){
						$("intmName").value = "ALL INTERMEDIARIES";
						clearFocusElementOnError("intmNo", "Invalid value for field INTM_NO.");
					}else{
						/* $("intmNo").value = Number($F("intmNo")).toPaddedString(12);
						$("intmName").value = obj.intmName; */ //benjo 10.28.2015 comment out
						showIntmLOV2(removeLeadingZero($F("intmNo"))); //benjo 10.28.2015 KB-334
					}
				}
			}
		});
	}

	$("btnPrint").observe("click", function(){
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
	});
	
	function validateBeforePrint(){
		$$("input[name='parameterRG']").each(function(checkbox) {
			checkbox.checked == true ? branchParam = checkbox.value : null;  
		});
		$$("input[name='scopeRG']").each(function(checkbox) {
			checkbox.checked == true ? scopeParam = checkbox.value : null;  
		});
		new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
			parameters: {
						action      : "validatePrint",
						printTab    : "perAssd",
						branchParam : branchParam,
						scope		: scopeParam,
						issCd		: $F("issCd"),
						lineCd		: $F("lineCd"),
						sublineCd	: $F("sublineCd"),
						assdNo		: $F("assdNo"),
						intmNo		: $F("intmNo"),
						intmType    : $F("intmType")
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
		if(extracted == "Y"){
			if($F("selDestination") == "PRINTER" && ($("selPrinter").value == "" || $("txtNoOfCopies").value == "")){
				showMessageBox(objCommonMessage.REQUIRED, "I");
			}else if($F("selDestination") == "PRINTER" && (isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0)){
				showMessageBox("Invalid number of copies.", "I");
			}else{
				printUwReports();
			}
		}else{
			showMessageBox("No Data Extracted.", "I");	
		}
	}
		
	function printUwReports(){
		if($("detail").checked && $("perAssured").checked){
			printProdReport("printGIPIR923A");
		}else if($("summary").checked && $("perAssured").checked){
			printProdReport("printGIPIR924A");
		}else if($("detail").checked && $("perIntermediary").checked){
			printProdReport("printGIPIR923B");
		}else if($("summary").checked && $("perIntermediary").checked){
			printProdReport("printGIPIR924B");
		}
	}
	
	function printProdReport(action){
		$$("input[name='parameterRG']").each(function(checkbox) {
			checkbox.checked == true ? branchParam = checkbox.value : null;  
		});
		$$("input[name='scopeRG']").each(function(checkbox) {
			checkbox.checked == true ? scopeParam = checkbox.value : null;  
		});
		try {
			var content = contextPath+"/UWProductionReportPrintController?action="+action+"&issParam="+branchParam+
					"&scope="+scopeParam+"&issCd="+$F("issCd")+"&lineCd="+$F("lineCd")+"&sublineCd="+$F("sublineCd")+
					"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")+
					"&reportId="+action.substring(5)+"&assdNo="+$F("assdNo")+"&intmNo="+$F("intmNo")+"&intmType="+$F("intmType");
			
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
		if(action == "printGIPIR923A"){
			title = "Detailed Production Register";
		}else if(action == "printGIPIR924A"){
			title = "Summarized Prodution Register Per Assured";
		}else if(action == "printGIPIR924B"){
			title = "Summarized Production Register Per Intermediary";
		}else if(action == "printGIPIR923B"){
			title = "Detailed Production Register per Intermediary";
		}
		
		return title;
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
		checkUwReports();
	}
	
	function checkUwReports(){
		new Ajax.Request(contextPath+"/GIPIUwreportsExtController", {
			parameters: {
						action          : "checkUwReports",
						tabCheck        : "perAssd",
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
						tabExtract		: "perAssd",
						dateParam   	: dateParam,
						fromDate    	: $F("fromDate"),
						toDate      	: $F("toDate"),
						scopeParam      : /*"3",*/scopeParam, //benjo 10.28.2015 "3" -> scopeParam
						issCd	    	: $F("issCd"),
						lineCd      	: $F("lineCd"),
						sublineCd   	: $F("sublineCd"),
						assdNo			: $F("assdNo"),
						intmNo			: $F("intmNo"),
						branchParam 	: branchParam,
						specialPolParam : $("incSpecialPolicies").checked ? 'Y' : 'N',
						intmType		: $F("intmType")
						},
			asynchronous: false,
			evalScripts: true,
			onCreate : function() {
				showNotice("Working, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
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
	
	observeReloadForm("reloadForm", function(){showUWProductionReportsPage("perAssd");});
	
</script>