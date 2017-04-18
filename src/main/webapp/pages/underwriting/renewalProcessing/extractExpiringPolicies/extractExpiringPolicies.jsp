<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="extractExpPolMainDiv" name="extractExpPolMainDiv" style="margin-top: 1px;">
	<div id="extractExpPolMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="extractExpPolForm" name="extractExpPolForm">
		<div id="extractExpPolFormDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Extract Expiring Policies</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
				 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
					</span>
				</div>
			</div>
			<div id="mainDiv" class="sectionDiv" style="border: 0px;">	
			<div id="fBLock" class="sectionDiv">
				<div id="range"  style="margin: 10px; margin-left: 180px; display: block; margin-top: 20px; float: left; width: 450px;">
					<input type="hidden" id="rangeTag" name="rangeTag">
					<input type="radio" value="1" id="byPolicy" name="fBLockTag" tabindex="1"  checked="checked"/> <label for="byPolicy" style="float: none;">by Policy</label><br>
					<input type="radio" value="2" id="byMonthYear" name="fBLockTag" tabindex="2" /> <label for="byMonthYear" style="float: none;">by Month/Year</label><br>
					<table style="margin-top: 0; width: 60%;">
							<tr>
								<td id="fmMonTitle" name="fmMonTitle" class="rightAligned" style="width: 5%;">From:</td>
								<!-- <td class="leftAligned" style="width: 15%;">
									<select id="fmMon" name="fmMon" style="width: 110px;" disabled="disabled"  >
										<option value=""></option>
										<option value="1">January</option>
										<option value="2">February</option>
										<option value="3">March</option>
										<option value="4">April</option>
										<option value="5">May</option>
										<option value="6">June</option>
										<option value="7">July</option>
										<option value="8">August</option>
										<option value="9">September</option>
										<option value="10">October</option>
										<option value="11">November</option>
										<option value="12">December</option>
									</select>
								</td>
								<td class="leftAligned"><input type="text" style="width: 60px;" id="fmYear" name="fmYear"  disabled="disabled"/></td> -->
								<td class="leftAligned" style="width: 15%;">
									<select id="fmMon" name="fmMon" style="width: 110px;" disabled="disabled"  >
												<option value=""></option>
												<option value="1">January</option>
												<option value="2">February</option>
												<option value="3">March</option>
												<option value="4">April</option>
												<option value="5">May</option>
												<option value="6">June</option>
												<option value="7">July</option>
												<option value="8">August</option>
												<option value="9">September</option>
												<option value="10">October</option>
												<option value="11">November</option>
												<option value="12">December</option>
											</select>
								</td>
								<td>
									<input id="fmYear" name="fmYear" type="text"  style="width: 60px; margin-bottom: 4px;" disabled="disabled">
								</td>
								<td id="fmMonTitle" name="fmMonTitle" class="rightAligned" style="width: 5%;">To:</td>
								<!-- <td class="leftAligned" style="width: 15%;">
									<select id="toMon" name="toMon" style="width: 110px;"   disabled="disabled">
										<option value=""></option>
										<option value="1">January</option>
										<option value="2">February</option>
										<option value="3">March</option>
										<option value="4">April</option>
										<option value="5">May</option>
										<option value="6">June</option>
										<option value="7">July</option>
										<option value="8">August</option>
										<option value="9">September</option>
										<option value="10">October</option>
										<option value="11">November</option>
										<option value="12">December</option>
									</select>
								</td> -->
								<!-- <td class="leftAligned" ><input type="text" style="width: 60px;" id="toYear" name="toYear"  disabled="disabled"/></td> -->
								<td class="leftAligned" style="width: 15%;">
									<select id="toMon" name="toMon" style="width: 110px;" disabled="disabled"  >
												<option value=""></option>
												<option value="1">January</option>
												<option value="2">February</option>
												<option value="3">March</option>
												<option value="4">April</option>
												<option value="5">May</option>
												<option value="6">June</option>
												<option value="7">July</option>
												<option value="8">August</option>
												<option value="9">September</option>
												<option value="10">October</option>
												<option value="11">November</option>
												<option value="12">December</option>
											</select>
								</td>
								<td>
									<input id="toYear" name="toYear" type="text"  style="width: 60px; margin-bottom: 4px;" disabled="disabled">
								</td>
							</tr>
					</table>
					<input type="radio" value="3" id="byDate" name="fBLockTag" tabindex="3" /> <label for="byDate" style="float: none;">by Date</label></span>
					<table style="margin-top: 0; width: 60%;">
							<tr>
								<td id="userIdTitle" name="userIdTitle" class="rightAligned" style="width: 5%;">From:</td>
								<td class="leftAligned"  style="width: 42%;">
									<div style="float: left; border: solid 1px gray; width: 108px; height: 20px; margin-right: 3px;">
										<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 74%; border: none;" name="fmDate" id="fmDate" readonly="readonly" disabled="disabled" />
										<img id="imgFmDate" alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('fmDate'),this, null);"/>						
									</div>
								</td>
								<td id="userIdTitle" name="userIdTitle" class="rightAligned" style="width: 7.5%;">To:</td>
								<td class="leftAligned"  style="width: 42%;">
									<div style="float: left; border: solid 1px gray; width: 108px; height: 20px; margin-right: 3px;">
										<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 74%; border: none;" name="toDate" id="toDate" readonly="readonly" disabled="disabled" />
										<img id="imgToDate"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('toDate'),this, null);"/>						
									</div>
								</td>
							</tr>
					</table>
				</div>
				<div id="rangeType" style="margin-top:50px; width:110px; height:70px;  float: left;" class="sectionDiv">
					<br>
					<input type="hidden" id="rangeTypeTag" name="rangeTypeTag">
					<input type="radio" value="1" id="onOrBefore" name="rangeType" tabindex="1" /> <label for="onOrBefore" style="float: none;">On or Before</label><br>
					<input type="radio" value="2" id="exactRange" name="rangeType" tabindex="2"  checked="checked"/> <label for="exactRange" style="float: none;">Exact Range</label>
					<br>
				</div>
			</div>
			<div id="f1BLock" class="sectionDiv">
				<div style="display: block; margin-top: 0; margin-left: 90px;">
					<table style="margin-top: 10px; width: 100%;">
						<tr>
							<td class="rightAligned" style="width: 25%;">Policy No.</td>
							<td class="leftAligned" style="width: 75%;">
								<span class="" style="">
									<input id="txtPolLineCd" class="leftAligned upper" type="text" name="txtPolLineCd" style="width: 7%;" value="" title="Line Code" maxlength="2"/>
									<input id="txtPolSublineCd" class="leftAligned upper" type="text" name="txtPolSublineCd" style="width: 13%;" value="" title="Subline Code"maxlength="7" readonly="readonly"/>
									<input id="txtPolIssCd" class="leftAligned upper" type="text" name="txtPolIssCd" style="width: 7%;" value="" title="Issource Code"maxlength="2"/>
									<input id="txtPolIssueYy" class="integerNoNegativeUnformattedNoComma leftAligned" type="text" name="txtPolIssueYy" style="width: 7%;" value="" title="Year" maxlength="2"/>
									<input id="txtPolPolSeqNo" class="integerNoNegativeUnformattedNoComma leftAligned" type="text" name="txtPolPolSeqNo" style="width: 13%;" value="" title="Policy Sequence Number" maxlength="7"/>
									<input id="txtPolRenewNo" class="integerNoNegativeUnformattedNoComma leftAligned" type="text" name="txtPolRenewNo" style="width: 7%;" value="" title="Renew Number" maxlength="2"/>
								 </span>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 25%;">Line Code</td>
							<td class="leftAligned" style="width: 75%;">
								<div style="float: left; border: solid 1px gray; width: 8%; height: 20px; margin-right: 3px; margin-bottom: 2px;">
									<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 44%; border: none;" name="txtLineCd" id="txtLineCd" disabled="disabled" class="upper" maxlength="2"/>
									<img id="lineCdLOV"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
								</div>
								<div style="float: left; width: 57%; margin-right: 3px;">
									<input id="txtDspLineName" class="leftAligned" type="text" name="txtDspLineName" style="float: left; margin-top: 0px; margin-right: 3px; width: 96.5%; border: solid 1px gray; height: 14px;" value="" title="Line Name" maxlength="30" disabled="disabled" readonly="readonly"/>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 25%;">Subline Code</td>
							<td class="leftAligned" style="width: 75%;">
								<div style="float: left; border: solid 1px gray; width: 18%; height: 20px; margin-right: 3px; margin-bottom: 2px;">
									<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 75%; border: none;" name="txtSublineCd" id="txtSublineCd" disabled="disabled"/>
									<img id="sublineCdLOV"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
								</div>
								<div style="float: left; width: 46%; margin-right: 3px;">
									<input id="txtDspSublineName" class="leftAligned upper" type="text" name="txtDspSublineName" style="float: left; margin-top: 0px; margin-right: 3px; width: 98%; border: solid 1px gray; height: 14px;" value="" title="Subline Name" maxlength="30" disabled="disabled" readonly="readonly"/>
								</div>
							</td>
						</tr>
						<tr>
							<!-- <td class="rightAligned" style="width: 25%;" id="lblCredBr">Branch Code</td>	Gzelle 06242015 SR3920 --> <!-- benjo 11.12.2015 comment out -->
							<td class="rightAligned" style="width: 25%;">Issue Source</td> <!-- benjo 11.12.2015 UW-SPECS-2015-087 -->
							<td class="leftAligned" style="width: 75%;">
								<div style="float: left; border: solid 1px gray; width: 8%; height: 20px; margin-right: 3px; margin-bottom: 2px;">
									<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 44%; border: none;" name="txtIssCd" id="txtIssCd" disabled="disabled"/>
									<img id="issCdLOV"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
								</div>
								<div style="float: left; width: 57%; margin-right: 3px;">
									<input id="txtDspIssName" class="leftAligned upper" type="text" name="txtDspIssName" style="float: left; margin-top: 0px; margin-right: 3px; width: 96.5%; border: solid 1px gray; height: 14px;" value="" title="Iss Name" maxlength="30" disabled="disabled" readonly="readonly"/>
								</div>
							</td>
						</tr>
						<tr> <!-- benjo 11.12.2015 UW-SPECS-2015-087 added crediting branch -->
							<td class="rightAligned" style="width: 25%;">Crediting Branch</td>
							<td class="leftAligned" style="width: 75%;">
								<div style="float: left; border: solid 1px gray; width: 8%; height: 20px; margin-right: 3px; margin-bottom: 2px;">
									<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 44%; border: none;" name="txtCredBranch" id="txtCredBranch" disabled="disabled"/>
									<img id="credBranchLOV"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
								</div>
								<div style="float: left; width: 57%; margin-right: 3px;">
									<input id="txtDspCredBranch" class="leftAligned upper" type="text" name="txtDspCredBranch" style="float: left; margin-top: 0px; margin-right: 3px; width: 96.5%; border: solid 1px gray; height: 14px;" value="" title="Cred Branch" maxlength="30" disabled="disabled" readonly="readonly"/>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 25%;">Intermediary</td>
							<td class="leftAligned" style="width: 75%;">
								<div style="float: left; border: solid 1px gray; width: 23%; height: 20px; margin-right: 3px;">
									<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 80%; border: none;" name="txtIntmNo" id="txtIntmNo" disabled="disabled"/>
									<img id="intmLOV"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
								</div>
								<div style="float: left; width: 41%; margin-right: 3px;">
									<input id="txtDspIntmName"  class="leftAligned upper" type="text" name="txtDspIntmName" style="float: left; margin-top: 0px; margin-right: 3px; width: 97.5%;  border: solid 1px gray; height: 14px;" value="" title="Subline Name" maxlength="240" disabled="disabled" readonly="readonly"/>
								</div>
							</td>
						</tr>
					</table>
					<table style="margin-top: 0; width: 100%;">
						<tr>
							<td class="rightAligned" style="width: 25%;">Plate No.</td>
							<td class="leftAligned" style="width: 5%;">
								<select id="plateNo" name="plateNo" style="width: 50px;"  disabled="disabled">
									<option value=""></option>
									<option value="0">0</option>
									<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">3</option>
									<option value="4">4</option>
									<option value="5">5</option>
									<option value="6">6</option>
									<option value="7">7</option>
									<option value="8">8</option>
									<option value="9">9</option>
								</select></td>
							<td class="leftAligned" style="width: 68%;">
								<input type="checkbox" id="includePackage" name="includePackage"  checked="checked" />
								<label for="includePackage" style="float: none;">Include Package Policies</label>
								<input type="hidden" id="packPolFlag" name="packPolFlag">
								<input type="hidden" id="issRi" name="issRi">
								<input type="hidden" id="incSpecialSw" name="incSpecialSw">
								<input type="hidden" id="defIsPolSummSw" name="defIsPolSummSw">
								<input type="hidden" id="defSamePolNoSw" name="defSamePolNoSw">
							</td>	
						</tr>
					</table>
					<div id="buttonsDiv" style="text-align: center; margin-top:10px; margin-right: 20px; margin-bottom: 10px;">
						<input type="button" class="button" id="btnExtract" value="Extract"  style="width: 15%;"/>
						<input type="button" class="button" id="btnCancel" value="Cancel"  style="width: 15%;"/>
					</div>
				</div>
			</div>
			<div id="historyBLock" class="sectionDiv" style="margin-bottom: 30px;">
				<div style="margin: 10px; margin-left: 180px; display: block; margin-top: 20px; margin-bottom: 20px">
					<table style="margin-top: 0; width: 80%;">
							<tr>
								<td><img src="${pageContext.request.contextPath}/images/misc/history.PNG" id="btnHistory" name="btnHistory" title="View History" onmouseover="this.style.cursor='pointer';"/></td>
								<td id="userIdTitle" name="userIdTitle" class="rightAligned" style="width: 12%;">User ID</td>
								<td class="leftAligned"><input type="text" style="width: 150px;" id="userId" name="userId" readonly="readonly"/></td>
								<td id="lastExtractionTitle" name="lastExtractionTitle" class="rightAligned"  style="width: 20%;">Last Extraction</td>
								<td class="leftAligned"><input type="text" style="width: 150px;" id="lastExtraction" name="lastExtraction" readonly="readonly" /></td>	
							</tr>
					</table>
				</div>
			</div>
			</div>
		</div>
	</form>
</div>

<script>
try{
	initializeAccordion();
	initializeAll();
	addStyleToInputs();
	makeInputFieldUpperCase();
	$("rangeTypeTag").value = 2;

	/* //Gzelle 06242015 SR3920
	var allowRenCredBrExtrct = '${allowRenCredBrExtrct}';
	
	function checkAllowRenCredParam() {
		if (allowRenCredBrExtrct == "Y") {
			$("lblCredBr").innerHTML = "Crediting Branch";
		}else if (allowRenCredBrExtrct == "N") {
			$("lblCredBr").innerHTML = "Issue Source";
		}
	}	//end */ //benjo 11.12.2015 comment out
	
	function checkForm(){
		validateUser();
		var result = true;
		if ($F("rangeTag") == 1 ){
			if($F("txtPolLineCd") == "" || $F("txtPolSublineCd")  == "" || $F("txtPolIssCd")  == "" ||
				$F("txtPolIssueYy")  == "" || $F("txtPolPolSeqNo")  == "" || $F("txtPolRenewNo") ==""){
				result = false;
				customShowMessageBox("Policy Number is incomplete.","E", "txtPolLineCd");
			}
		}
		if($F("rangeTypeTag") == 2){
			if ($F("rangeTag") == 3 ){
				if($F("fmDate")  == "" && $F("toDate") == "" ){
					result = false;
					customShowMessageBox("Please enter date to proceed with the extraction.","E", "fmDate");
				}else if($F("fmDate")  == "" ){
					result = false;
					customShowMessageBox("Please enter from date to proceed with the extraction.","E", "fmDate");
				}else if($F("toDate")  == "" ){
					result = false;
					customShowMessageBox("Please enter to date to proceed with the extraction.","E", "toDate");
				}
			}else if ($F("rangeTag") == 2 ){
				if(($F("fmMon")  == "" || $F("fmYear")  == "") && ($F("toMon") == "" || $F("toYear") == "")){
					result = false;
					customShowMessageBox("Please enter month and year to proceed with extraction.","E", "fmMon");
				}else if($F("fmMon")  == "" || $F("fmYear")  == "" ){
					result = false;
					customShowMessageBox("Please enter from month and year to proceed with the extraction.","E", "fmMon");
				}else if($F("toMon") == "" || $F("toYear") == ""){
					result = false;
					customShowMessageBox("Please enter to month and year to proceed with the extraction.","E", "toMon");
				}
			}
		}else{
			if ($F("rangeTag") == 3 ){
				if($F("fmDate")  == "" ){
					result = false;
					customShowMessageBox("Please enter date to proceed with the extraction.","E", "fmDate");
				}
			}else if ($F("rangeTag") == 2 ){
				if($F("fmMon")  == "" || $F("fmYear")  == "" ){
					result = false;
					customShowMessageBox("Please enter month and year to proceed with the extraction.","E", "fmMon");
				}
			}
		}
		return result;
	}
	
	function showByPolicy(){
		$("rangeTag").value = 1;
		enablePolNo();
		clearPolNo();
		clearFilter();
		disableFilter();
		disableFields();
		$("fmMon").value = "";
		$("fmYear").value = "";
		$("toMon").value = "";
		$("toYear").value = "";
		$("fmDate").value = "";
		$("toDate").value = "";
		$("fmMon").disable();
		$("fmYear").disable();
		$("toMon").disable();
		$("toYear").disable();
		$("fmDate").disable();
		$("imgFmDate").hide();
		//$("fmDate").up("div",0).addClassName("disabled");
		$("toDate").disable();
		$("imgToDate").hide();
		//$("toDate").up("div",0).addClassName("disabled");
		$("fmDate").setStyle('width : 102px');
		$("toDate").setStyle('width : 102px');
		$("txtPolLineCd").focus();
	}
	
	function showByMonthYear(){
		$("rangeTag").value = 2;
		disablePolNo();
		clearPolNo(); //koks
		enableFields();
		$("fmDate").disable();
		$("imgFmDate").hide();
		//$("fmDate").up("div",0).addClassName("disabled");
		$("toDate").disable();
		$("imgToDate").hide();
		//$("toDate").up("div",0).addClassName("disabled");
		$("fmMon").enable();
		$("fmYear").enable();
		$("fmDate").value = "";
		$("fmDate").setStyle('width : 102px');
		$("toDate").setStyle('width : 102px');
		if ($F("rangeTypeTag") == 1){
			$("toMon").disable();
			$("toYear").disable();
		}else{
			$("toMon").enable();
			$("toYear").enable();
			$("toDate").value = "";
		}
	}
	
	function showByDate(){
		$("rangeTag").value = 3;
		disablePolNo();
		clearPolNo(); //koks
		enableFields();
		$("fmMon").disable();
		$("fmYear").disable();
		$("toMon").disable();
		$("toYear").disable();
		$("fmDate").enable();
		//$("fmDate").up("div",0).removeClassName("disabled");
		$("fmDate").setStyle('width : 80px');
		$("imgFmDate").show();
		$("fmMon").value = "";
		$("fmYear").value = "";
		if ($F("rangeTypeTag") == 1){
			$("toDate").disable();
			$("imgToDate").hide();
			$("toDate").up("div",0).addClassName("disabled");
			$("toDate").setStyle('width : 102px');
		}else{
			$("toDate").enable();
			$("imgToDate").show();
			$("toDate").up("div",0).removeClassName("disabled");
			$("toDate").setStyle('width : 80px');
			$("toMon").value = "";
			$("toYear").value = "";
		}
	}
	
	function showOnOrBefore(){
		$("rangeTypeTag").value = 1;
		$("fmMon").value = "";
		$("fmYear").value = "";
		$("toMon").value = "";
		$("toYear").value = "";
		$("fmDate").value = "";
		$("toDate").value = "";
		if($F("rangeTag") == 2){
			$("toMon").disable();
			$("toYear").disable();
		//}else{ comment out by MAC 04/18/2013
		}else if ($F("rangeTag") == 3){ //enabled only To Date field if by Date option is selected by MAC 04/18/2013
			$("toDate").disable();
			$("imgToDate").hide();
			$("toDate").up("div",0).addClassName("disabled");
			$("toDate").setStyle('width : 102px');
		}
	}
	
	function showExactRange(){
		$("rangeTypeTag").value = 2;
		if($F("rangeTag") == 2){
			$("toMon").enable();
			$("toYear").enable();
		//}else{ comment out by MAC 04/18/2013
		}else if ($F("rangeTag") == 3){ //enabled only To Date field if by Date option is selected by MAC 04/18/2013
			$("toDate").enable();
			$("imgToDate").show();
			$("toDate").up("div",0).removeClassName("disabled");
			$("toDate").setStyle('width : 80px');
		}
	}
	
	var fmDate = "";
	var toDate = "";
	
	function checkFmMonYear(){
		fmDate = Date.parse(dateFormat(formatNumberDigits($F("fmMon"),2) +"-"+$F("fmYear"), "mm-yyyy"));
		toDate = Date.parse(dateFormat(formatNumberDigits($F("toMon"),2) +"-"+$F("toYear"), "mm-yyyy"));
		if($F("fmMon") != "" && $F("fmYear") != "" && $F("toMon") != "" && $F("toYear") != ""  && (fmDate > toDate)){
			showMessageBox("From month and year cannot be later than to month and year.","E");
		}
		if($F("fmYear") != "" ){
			if ($F("fmYear").length != 4 || isNaN($F("fmYear"))){
				customShowMessageBox("Invalid year.","E", "fmYear");
			}
		}
	}
	
	function checkToMonYear(){
		fmDate = Date.parse(dateFormat(formatNumberDigits($F("fmMon"),2) +"-"+$F("fmYear"), "mm-yyyy"));
		toDate = Date.parse(dateFormat(formatNumberDigits($F("toMon"),2) +"-"+$F("toYear"), "mm-yyyy"));
		if($F("fmMon") != "" && $F("fmYear") != "" && $F("toMon") != "" && $F("toYear") != ""  && (fmDate > toDate)){
			showMessageBox("To month and year cannot be earlier than from month and year.","E");
		}
		if($F("toYear") != "" ){
			if ($F("toYear").length != 4 || isNaN($F("toYear"))){
				customShowMessageBox("Invalid year.","E", "toYear");
			}
		}
	}
	
	function getLastExtractionHistory (){
		new Ajax.Request(contextPath+"/GIEXExpiryController", {
			method: "POST",
			parameters: {action : "getLastExtractionHistory",
									   moduleId : "GIEXS001"},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var arr = response.responseText.split(",");
					var user = arr[0];
					var date = arr[1];
					var issRi = arr[2];
					$("userId").value = user;
					$("lastExtraction").value = date;
					$("issRi").value = issRi;
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function disablePolNo(){
		$("txtPolLineCd").disable();
		$("txtPolSublineCd").disable();
		$("txtPolIssCd").disable();
		$("txtPolIssueYy").disable();
		$("txtPolPolSeqNo").disable();
		$("txtPolRenewNo").disable();
	}
	
	function enablePolNo(){
		$("txtPolLineCd").enable();
		$("txtPolSublineCd").enable();
		$("txtPolIssCd").enable();
		$("txtPolIssueYy").enable();
		$("txtPolPolSeqNo").enable();
		$("txtPolRenewNo").enable();
	}
	
	function clearPolNo(){
		$("txtPolLineCd").value = "";
		$("txtPolSublineCd").value = "";
		$("txtPolIssCd").value = "";
		$("txtPolIssueYy").value = "";
		$("txtPolPolSeqNo").value = "";
		$("txtPolRenewNo").value = "";
	}

	function clearFilter(){
		$("txtLineCd").value = ""; //koks
		$("txtDspLineName").value = "";
		$("txtSublineCd").value = "";
		$("txtDspSublineName").value = "";
		$("txtIssCd").value = "";
		$("txtDspIssName").value = "";
		//benjo 11.12.2015 UW-SPECS-2015-087
		$("txtCredBranch").value = "";
		$("txtDspCredBranch").value = "";
		//end
		$("txtIntmNo").value = "";
		$("txtDspIntmName").value = "";
	}
	
	function disableFilter(){
		$("txtLineCd").disable(); //koks
		$("txtDspLineName").disable();
		$("txtSublineCd").disable();
		$("txtDspSublineName").disable();
		$("txtIssCd").disable();
		$("txtDspIssName").disable();
		//benjo 11.12.2015 UW-SPECS-2015-087
		$("txtCredBranch").disable();
		$("txtDspCredBranch").disable();
		//end
		$("txtIntmNo").disable();
		$("txtDspIntmName").disable();
	}
	
	function disableFields(){
		$("txtLineCd").disable();
		$("lineCdLOV").hide();
		$("txtLineCd").up("div",0).addClassName("disabled");
		$("txtDspLineName").disable();
		$("txtSublineCd").disable();
		$("sublineCdLOV").hide();
		$("txtSublineCd").up("div",0).addClassName("disabled");
		$("txtDspSublineName").disable();
		$("txtIssCd").disable();
		$("issCdLOV").hide();
		$("txtIssCd").up("div",0).addClassName("disabled");
		$("txtDspIssName").disable();
		//benjo 11.12.2015 UW-SPECS-2015-087
		$("txtCredBranch").disable();
		$("credBranchLOV").hide();
		$("txtCredBranch").up("div",0).addClassName("disabled");
		$("txtDspCredBranch").disable();
		//end
		$("txtIntmNo").disable();
		$("intmLOV").hide();
		$("txtIntmNo").up("div",0).addClassName("disabled");
		$("txtDspIntmName").disable();
		$("plateNo").disable();
		$("includePackage").checked = false;
		$("includePackage").disable();
		$("txtLineCd").setStyle('width : 43px');
		$("txtSublineCd").setStyle('width : 105px');
		$("txtIssCd").setStyle('width : 43px');
		$("txtCredBranch").setStyle('width : 43px'); //benjo 11.12.2015 UW-SPECS-2015-087
		$("txtIntmNo").setStyle('width : 135px');
	}
	
	function enableFields(){
		$("txtLineCd").enable();
		$("lineCdLOV").show();
		$("txtLineCd").up("div",0).removeClassName("disabled");
		$("txtDspLineName").enable();
		/* $("txtSublineCd").enable();
		$("sublineCdLOV").show();
		$("txtSublineCd").up("div",0).removeClassName("disabled");
		$("txtDspSublineName").enable(); */
		$("txtIssCd").enable();
		$("issCdLOV").show();
		$("txtIssCd").up("div",0).removeClassName("disabled");
		$("txtDspIssName").enable();
		//benjo 11.12.2015 UW-SPECS-2015-087
		$("txtCredBranch").enable();
		$("credBranchLOV").show();
		$("txtCredBranch").up("div",0).removeClassName("disabled");
		$("txtDspCredBranch").enable();
		//end
		$("txtIntmNo").enable();
		$("intmLOV").show();
		$("txtIntmNo").up("div",0).removeClassName("disabled");
		$("txtDspIntmName").enable();
		$("plateNo").enable();
		$("includePackage").enable();
		$("txtLineCd").setStyle('width : 21px');
		$("txtSublineCd").setStyle('width : 83px');
		$("txtIssCd").setStyle('width : 21px');
		$("txtCredBranch").setStyle('width : 21px'); //benjo 11.12.2015 UW-SPECS-2015-087
		$("txtIntmNo").setStyle('width : 113px');
	}
	
	function showLineCdFlagLOV() {
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getLineCdFlagLOV",
							issCd: $F("txtIssCd"),
							moduleId: "GIEXS001",
							notIn: "",
							filterText : $F("txtLineCd").trim() != "" ? $F("txtLineCd").trim() : "%",
							page : 1},
			title: "Line Name",
			width: 380,
			height: 386,
			columnModel: [ {   id: 'recordStatus',
								    title: '',
								    width: '0',
								    visible: false,
								    editor: 'checkbox' 			
								},
								{	id: 'divCtrId',
									width: '0',
									visible: false
								},
								{
									id: 'lineCd',
									title: 'Line Code',
									titleAlign: 'left',
									width: '80px'
								},
								{
									id: 'lineName',
									title: 'Line Name',
									titleAlign: 'left',
									width: '209px'
								},
								{	id: 'packPolFlag',
									title: 'Flag',
									titleAlign: 'left',
									width: '70px'
								}
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : $F("txtLineCd").trim() != "" ? $F("txtLineCd").trim() : "%",
	  		onSelect: function(row){
				 if(row != undefined) {
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtDspLineName").value = unescapeHTML2(row.lineName);
					validateSublineCd();
					$("txtSublineCd").enable();
					$("sublineCdLOV").show();
					$("txtSublineCd").up("div",0).removeClassName("disabled");
					$("txtDspSublineName").enable();
				 }
	  		},
	  		onCancel: function (){
	  			$("txtLineCd").focus();
				$("txtLineCd").value = "";
				$("txtDspLineName").value = "";
				$("txtSublineCd").value = "";
				$("txtDspSublineName").value = "";
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtLineCd").value = "";
				$("txtDspLineName").value = "";
				$("txtSublineCd").value = "";
				$("txtDspSublineName").value = "";
			}
		});
	}
	
	function showSublineCdNameLOV() {
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getSublineCdNameLOV",
							lineCd: $F("txtLineCd"),
							notIn: "",
							filterText : $F("txtSublineCd").trim() != "" ? $F("txtSublineCd").trim() : "%",
							page : 1},
			title: "Subline Name",
			width: 380,
			height: 386,
			columnModel: [ {   id: 'recordStatus',
								    title: '',
								    width: '0',
								    visible: false,
								    editor: 'checkbox' 			
								},
								{	id: 'divCtrId',
									width: '0',
									visible: false
								},
								{
									id: 'sublineCd',
									title: 'Subline Code',
									titleAlign: 'left',
									width: '100px'
								},
								{
									id: 'sublineName',
									title: 'Subline Name',
									titleAlign: 'left',
									width: '261px'
								}
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : $F("txtSublineCd").trim() != "" ? $F("txtSublineCd").trim() : "%",
	  		onSelect: function(row){
				 if(row != undefined) {
					$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
					$("txtDspSublineName").value = unescapeHTML2(row.sublineName);
				 }
	  		},
	  		onCancel: function (){
	  			$("txtSublineCd").focus();
				$("txtSublineCd").value = "";
				$("txtDspSublineName").value = "";
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtSublineCd").focus();
				$("txtSublineCd").value = "";
				$("txtDspSublineName").value = "";
			}
		});
	}
	
	function showIssCdNameLOV() {
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getIssCdNameLOV",
							lineCd: $F("txtLineCd"),
							moduleId: "GIEXS001",
							filterText : $F("txtIssCd").trim() != "" ? $F("txtIssCd").trim() : "%",
							notIn: "",
							page : 1},
			title: "Branch Name",
			width: 380,
			height: 386,
			columnModel: [ {   id: 'recordStatus',
								    title: '',
								    width: '0',
								    visible: false,
								    editor: 'checkbox' 			
								},
								{	id: 'divCtrId',
									width: '0',
									visible: false
								},
								{
									id: 'issCd',
									title: 'Issue Code',
									titleAlign: 'left',
									width: '100px'
								},
								{
									id: 'issName',
									title: 'Issue Name',
									titleAlign: 'left',
									width: '261px'
								}
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : $F("txtIssCd").trim() != "" ? $F("txtIssCd").trim() : "%",
	  		onSelect: function(row){
				 if(row != undefined) {
					$("txtIssCd").value = unescapeHTML2(row.issCd);
					$("txtDspIssName").value = unescapeHTML2(row.issName);
				 }
	  		},
	  		onCancel: function (){
	  			$("txtIssCd").focus();
				$("txtIssCd").value = "";
				$("txtDspIssName").value = "";
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtIssCd").focus();
				$("txtIssCd").value = "";
				$("txtDspIssName").value = "";
			}
		});
	}
	
	//benjo 11.12.2015 UW-SPECS-2015-087
	function showCredBranchLOV() {
		LOV.show({
			controller: "UWRenewalProcessingLOVController",
			urlParameters: {action : "getGiexs001CredBranchLOV",
							lineCd: $F("txtLineCd"),
							moduleId: "GIEXS001",
							filterText : $F("txtCredBranch").trim() != "" ? $F("txtCredBranch").trim() : "%",
							notIn: "",
							page : 1},
			title: "Branch Name",
			width: 380,
			height: 386,
			columnModel: [ {   id: 'recordStatus',
								    title: '',
								    width: '0',
								    visible: false,
								    editor: 'checkbox' 			
								},
								{	id: 'divCtrId',
									width: '0',
									visible: false
								},
								{
									id: 'issCd',
									title: 'Issue Code',
									titleAlign: 'left',
									width: '100px'
								},
								{
									id: 'issName',
									title: 'Issue Name',
									titleAlign: 'left',
									width: '261px'
								}
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : $F("txtCredBranch").trim() != "" ? $F("txtCredBranch").trim() : "%",
	  		onSelect: function(row){
				 if(row != undefined) {
					$("txtCredBranch").value = unescapeHTML2(row.issCd);
					$("txtDspCredBranch").value = unescapeHTML2(row.issName);
				 }
	  		},
	  		onCancel: function (){
	  			$("txtCredBranch").focus();
				$("txtCredBranch").value = "";
				$("txtDspCredBranch").value = "";
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtCredBranch").focus();
				$("txtCredBranch").value = "";
				$("txtDspCredBranch").value = "";
			}
		});
	}
	
	function showIntmCdNameLOV() {
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getIntmCdNameLOV",
							notIn: "",
							filterText : $F("txtIntmNo").trim() != "" ? $F("txtIntmNo").trim() : "%",
							page : 1},
			title: "Intermediary Name",
			width: 380,
			height: 386,
			columnModel: [ {   id: 'recordStatus',
								    title: '',
								    width: '0',
								    visible: false,
								    editor: 'checkbox' 			
								},
								{	id: 'divCtrId',
									width: '0',
									visible: false
								},
								{
									id: 'intmNo',
									title: 'Intermediary No.',
									titleAlign: 'right',
									align: 'right',
									width: '100px'
								},
								{
									id: 'intmName',
									title: 'Intermediary Name',
									titleAlign: 'left',
									width: '261px'
								}
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : $F("txtIntmNo").trim() != "" ? $F("txtIntmNo").trim() : "%",
	  		onSelect: function(row){
				 if(row != undefined) {
					$("txtIntmNo").value = row.intmNo;
					$("txtDspIntmName").value = unescapeHTML2(row.intmName);
				 }
	  		},
	  		onCancel: function (){
	  			$("txtIntmNo").focus();
				$("txtIntmNo").value = "";
				$("txtDspIntmName").value = "";
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtIntmNo").focus();
				$("txtIntmNo").value = "";
				$("txtDspIntmName").value = "";
			}
		});
	}
	
	function validatePolLineCd(){
		new Ajax.Request(contextPath+"/GIEXExpiryController", {
			method: "POST",
			parameters: {action : "validatePolLineCd",
									   polLineCd : $F("txtPolLineCd"),
									   polSublineCd : $F("txtPolSublineCd"),
									   polIssCd : $F("txtPolIssCd"),
									   lineCd : $F("txtLineCd"),
									   issCd : $F("txtIssCd"),
									   moduleId : "GIEXS001"},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var arr = response.responseText.split(",");
					var packPolFlag = arr[0];
					var msg = arr[1];
					if(msg == 1){
						$("txtPolLineCd").value = "";
						customShowMessageBox("Line code does not exist in table giis_line.","E", "txtPolLineCd");
					}else if(msg == 2){
						$("txtPolSublineCd").value = "";
					}else if(msg == 3){
						$("txtPolLineCd").value = "";
						showMessageBox("User is not allowed to access this line.","E");
					}else if(msg == 4){
						$("txtPolLineCd").value = "";
						showMessageBox("Too many records found with this line code in table giis_line.","E");
					}
					$("packPolFlag").value = packPolFlag;
					checkPackPolFlag();
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function validatePolIssCd(){
		new Ajax.Request(contextPath+"/GIEXExpiryController", {
			method: "POST",
			parameters: {action : "validatePolIssCd",
									   polLineCd : $F("txtPolLineCd"),
									   polIssCd : $F("txtPolIssCd"),
									   issRi : $F("issRi"),
									   moduleId : "GIEXS001"},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var msg= response.responseText;
					if (msg == 1){
						customShowMessageBox("Inward Reinsurance cannot be processed for expiry.","E", "txtPolIssCd");
						$("txtPolIssCd").value = "";
					}else if(msg == 2){
						customShowMessageBox("Issue code does not exist in table giis_issource.","E", "txtPolIssCd");
					}else if (msg == 3){
						customShowMessageBox("User is not allowed to access this issue source.","E", "txtPolIssCd");
						$("txtPolIssCd").value = "";
					}else if (msg == 4){
						customShowMessageBox("Too many records found with this issuing code in table giis_issource.","E", "txtPolIssCd");
						$("txtPolIssCd").value = "";
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function validateSublineCd(){
		new Ajax.Request(contextPath+"/GIEXExpiryController", {
			method: "POST",
			parameters: {action : "validateSublineCd",
									   lineCd : $F("txtLineCd"),
									   issCd : $F("txtIssCd"),
									   sublineCd : $F("txtSublineCd")},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var msg= response.responseText;
					if(msg == 1){
						$("txtSublineCd").value = "";
						$("txtDspSublineName").value = "";
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function initializeParameters(){
		new Ajax.Request(contextPath+"/GIEXExpiryController", {
			method: "POST",
			parameters: {action : "initializeParamsGIEXS001"},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var arr = response.responseText.split(",");
					$("incSpecialSw").value = arr[0];
					$("defIsPolSummSw").value = arr[1];
					$("defSamePolNoSw").value = arr[2];
					
					//Apollo Cruz 11.25.2014
					if(arr[3] == null || arr[3] == ""){
						showMessageBox("The parameter ALLOW_OTHER_BRANCH_RENEWAL does not exists in giis_parameters.", imgMessage.INFO);
						return;
					}
					
					extractExpiringPolicies(); //call function extractExpiringPolicies after populating necessary variables by MAC 04/18/2013.
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function validateUser(){
		new Ajax.Request(contextPath+"/GIEXExpiryController", {
			method: "POST",
			parameters: {action : "validateUserGIEXS001",
									   lineCd : $F("txtLineCd"),
									   issCd :  $F("txtIssCd")},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var msg= response.responseText;
					if (msg != ""){
						showMessageBox(msg,"I");
						return false;
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function checkPackPolFlag(){
		if($F("packPolFlag")=="Y"){
			$("includePackage").checked = true;
			$("includePackage").enable();
		}else{
			$("includePackage").checked = false;
			$("includePackage").disable();
		}
	}
	
	function extractExpiringPoliciesFinal(){
		new Ajax.Request(contextPath+"/GIEXExpiryController", {
			method: "POST",
			parameters: {action : "extractExpiringPoliciesFinal",
										fmMon : $F("fmMon"), 						
										fmYear : $F("fmYear"),						
										toMon : $F("toMon"), 						
										toYear : $F("toYear"), 						
										fmDate : $F("fmDate"), 						
										toDate : $F("toDate"), 						
										rangeType : $F("rangeTypeTag"), 				
										range : $F("rangeTag"), 						
										polLineCd : $F("txtPolLineCd"), 					
										polSublineCd : $F("txtPolSublineCd"), 			
										polIssCd : $F("txtPolIssCd"), 					
										lineCd : $F("txtLineCd"), 						
										sublineCd : $F("txtSublineCd"), 					
										issCd : $F("txtIssCd"), 							
										credBranch : $F("txtCredBranch"), //benjo 11.12.2015 UW-SPECS-2015-087
										intmNo : $F("txtIntmNo"), 						
										plateNo : $F("plateNo"), 					
										packPolFlag : $F("packPolFlag"), 			
										includePackage : $F("includePackage"), 		
										polIssueYy : $F("txtPolIssueYy"), 				
										polPolSeqNo : $F("txtPolPolSeqNo"), 			
										polRenewNo : $F("txtPolRenewNo"), 			
										incSpecialSw : $F("incSpecialSw"), 			
										defIsPolSummSw : $F("defIsPolSummSw"), 	
										defSamePolNoSw: $F("defSamePolNoSw")},
			onCreate: function(){
				showNotice("Extracting expiry records..");
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var arr = response.responseText.split(",");
					var msg= arr[0];
					var policyCount = arr[1];
						showWaitingMessageBox("Finish extracting "+ policyCount +" policy(s).","S", showExtractExpiringPoliciesPage);
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function extractExpiringPolicies(){
		new Ajax.Request(contextPath+"/GIEXExpiryController", {
			method: "POST",
			parameters: {action : "extractExpiringPolicies",
										fmMon : $F("fmMon"), 						
										fmYear : $F("fmYear"),						
										toMon : $F("toMon"), 						
										toYear : $F("toYear"), 						
										fmDate : $F("fmDate"), 						
										toDate : $F("toDate"), 						
										rangeType : $F("rangeTypeTag"), 				
										range : $F("rangeTag"), 						
										polLineCd : $F("txtPolLineCd"), 					
										polSublineCd : $F("txtPolSublineCd"), 			
										polIssCd : $F("txtPolIssCd"), 					
										lineCd : $F("txtLineCd"), 						
										sublineCd : $F("txtSublineCd"), 					
										issCd : $F("txtIssCd"), 							
										credBranch : $F("txtCredBranch"), //benjo 11.12.2015 UW-SPECS-2015-087
										intmNo : $F("txtIntmNo"), 						
										plateNo : $F("plateNo"), 					
										packPolFlag : $F("packPolFlag"), 			
										includePackage : $F("includePackage"), 		
										polIssueYy : $F("txtPolIssueYy"), 				
										polPolSeqNo : $F("txtPolPolSeqNo"), 			
										polRenewNo : $F("txtPolRenewNo"), 			
										incSpecialSw : $F("incSpecialSw"), 			
										defIsPolSummSw : $F("defIsPolSummSw"), 	
										defSamePolNoSw: $F("defSamePolNoSw")},
			onCreate: function(){
				showNotice("Please wait..");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var arr = response.responseText.split(",");
					var msg= arr[0];
					var policyCount = arr[1];
					if(msg==1){
						showMessageBox("Policy Number does not exist.", imgMessage.ERROR);
					}else if(msg == 2){
						showMessageBox("There is no policy that can be extracted for the given parameters.", "I");
					}else{
						showConfirmBox("", msg, "Yes", "No", extractExpiringPoliciesFinal , "");
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
				
	$("byPolicy").observe("click", showByPolicy);
	$("byMonthYear").observe("click", showByMonthYear);
	$("byDate").observe("click", showByDate);
	$("onOrBefore").observe("click", showOnOrBefore);
	$("exactRange").observe("click", showExactRange);
	$("fmMon").observe("blur", checkFmMonYear);
	$("fmYear").observe("blur",checkFmMonYear); 
	$("toMon").observe("blur", checkToMonYear); 
	$("toYear").observe("blur", checkToMonYear); 
	
	$("btnExtract").observe("click", function(){
		if (checkForm()){
			initializeParameters();
			//extractExpiringPolicies(); transferred in function initializeParameters to make sure that necessary variables are populated before calling function extractExpiringPolicies by MAC 04/18/2013.
		}
	});
	
	$("txtPolLineCd").observe("blur", function(){
		if($F("txtPolLineCd") == ""){
			clearPolNo();
			$("txtPolSublineCd").writeAttribute("readonly","readonly");
			$("packPolFlag").value = "Y";
		}else {
			validatePolLineCd();
			$("txtPolSublineCd").writeAttribute("readonly",false);
		}
	}); 
	
	$("txtPolIssCd").observe("blur", function(){
		if($F("txtPolIssCd") != ""){
			validatePolIssCd();
		}
	}); 
	
	$("txtPolIssueYy").observe("blur", function(){
		if($F("txtPolIssueYy") != ""){
			if (isNaN($F("txtPolIssueYy"))){
				customShowMessageBox("Field must be of form 09.", "E", "txtPolIssueYy");
			}else{
				$("txtPolIssueYy").value = formatNumberDigits($F("txtPolIssueYy"),2);
			}
		}
	}); 
	
	$("txtPolPolSeqNo").observe("blur", function(){
		if($F("txtPolPolSeqNo") != ""){
			if (isNaN($F("txtPolPolSeqNo"))){
				customShowMessageBox("Field must be of form 000009.", "E", "txtPolPolSeqNo");
			}else{
				$("txtPolPolSeqNo").value = formatNumberDigits($F("txtPolPolSeqNo"), 7);
			}
		}
	}); 
	
	$("txtPolRenewNo").observe("blur", function(){
		if($F("txtPolRenewNo") != ""){
			if (isNaN($F("txtPolRenewNo"))){
				customShowMessageBox("Field must be of form 09.", "E", "txtPolRenewNo");
			}else{
				$("txtPolRenewNo").value = formatNumberDigits($F("txtPolRenewNo"),2);
			}
		}
	}); 
		
	$("btnHistory").observe("click", function(){		
		action = "getExtractionHistory"; 
	    var contentDiv = new Element("div", {id : "modal_content_extractionHistory"});
	    var contentHTML = '<div id="modal_content_extractionHistory"></div>';
	    
	    winWorkflow = Overlay.show(contentHTML, {
							id: 'modal_dialog_extractionHistory',
							title: "History",
							width: 480,
							height: 440,
							draggable: true
							//closable: true
						});
	    
	    new Ajax.Updater("modal_content_extractionHistory", contextPath+"/GIEXExpiryController?action="+action, {
	    	evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {			
				if (!checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	});
	
	$("fmDate").observe("blur", function(){
		fmDate = Date.parse($F("fmDate"));
		toDate = Date.parse($F("toDate"));
		if($F("fmDate") != "" && $F("toDate") != "" && (fmDate > toDate)){
			//showMessageBox("From date should not be later than to date.","E"); Gzelle 06242015 SR3928
			customShowMessageBox("From Date should not be later than To Date.", "I", "fmDate");
			$("fmDate").clear();
			return false;
		}
	}); 
	
	$("toDate").observe("blur", function(){
		fmDate = Date.parse($F("fmDate"));
		toDate = Date.parse($F("toDate"));
		if($F("fmDate") != "" && $F("toDate") != "" && (fmDate > toDate)){
			//showMessageBox("To date should not be earlier than from date.","E"); Gzelle 06242015 SR3928
			customShowMessageBox("From Date should not be later than To Date.", "I", "toDate");
			$("toDate").clear();
			return false;
		}
	}); 
			
	$("btnExit").observe("click", function () {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("btnCancel").observe("click", function () {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("lineCdLOV").observe("click", function () {
		if ($("rangeTag").value != 1){
			showLineCdFlagLOV();
		}
	});
	
	$("sublineCdLOV").observe("click", function () {
		if ($("rangeTag").value != 1){
			showSublineCdNameLOV();
		}
	});

	$("issCdLOV").observe("click", function () {
		if ($("rangeTag").value != 1){
			showIssCdNameLOV();
		}
	});
	
	//benjo 11.12.2015 UW-SPECS-2015-087
	$("credBranchLOV").observe("click", function () {
		if ($("rangeTag").value != 1){
			showCredBranchLOV();
		}
	});
	
	$("intmLOV").observe("click", function () {
		if ($("rangeTag").value != 1){
			showIntmCdNameLOV();
		}
	});
	
	showByPolicy();
	$("includePackage").checked = true;
	$("includePackage").enable();
	observeReloadForm("reloadForm", showExtractExpiringPoliciesPage);
	getLastExtractionHistory();
	setModuleId("GIEXS001");
	/* checkAllowRenCredParam();	//Gzelle 06242015 SR3920 */ //benjo 11.12.2015 comment out
	
	$("txtLineCd").observe("change", function () {
		if($F("txtLineCd") != ""){
			if ($("rangeTag").value != 1){
				showLineCdFlagLOV();
			}
		} else {
			$("txtDspLineName").value = "";
			$("txtSublineCd").disable();
			$("sublineCdLOV").hide();
			$("txtSublineCd").up("div",0).addClassName("disabled");
			$("txtDspSublineName").disable();
			$("txtSublineCd").value = "";
			$("txtDspSublineName").value = "";
		}
	});
	
	$("txtSublineCd").observe("change", function () {
		if($F("txtSublineCd") != ""){
			if ($("rangeTag").value != 1){
				showSublineCdNameLOV();
			}
		} else {
			$("txtDspSublineName").value = "";
		}
	});
	
	$("txtIssCd").observe("change", function () {
		if($F("txtIssCd") != ""){
			if ($("rangeTag").value != 1){
				showIssCdNameLOV();
			}
		} else {
			$("txtDspIssName").value = "";
		}
	});
	
	//benjo 11.12.2015 UW-SPECS-2015-087
	$("txtCredBranch").observe("change", function () {
		if($F("txtCredBranch") != ""){
			if ($("rangeTag").value != 1){
				showCredBranchLOV();
			}
		} else {
			$("txtDspCredBranch").value = "";
		}
	});
	
	$("txtIntmNo").observe("change", function () {
		if($F("txtIntmNo") != ""){
			if ($("rangeTag").value != 1){
				showIntmCdNameLOV();
			}
		} else {
			$("txtDspIntmName").value = "";
		}
	});
	
}catch(e){
	showErrorMessage("GIEXS001 page", e);
}
</script>
