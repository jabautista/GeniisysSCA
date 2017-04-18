<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div id="policyDetailsDiv" name="policyDetailsDiv" changeTagAttr="true" style="width: 710px;">
	<span class="notice" id="noticePopup" name="noticePopup" style="display: none;">Saving, please wait...</span>
	<form id="policyDetailsForm" name="policyDetailsForm" style="margin-left: 0px; margin-top: 10px;">
				
		<div class="sectionDiv" style="width: 70%;">
			<table align="center" style="width: 100%; margin: 10px;">
				<tr>
					<td class="rightAligned" style="width: 140px;">Policy No.</td>
					<td class="leftAligned">
								<span class="" style="">
									<input id="basicLineCd" class="leftAligned upper" type="text" name="basicLineCd" style="width: 8%;" value="" title="Line Code" maxlength="2" />
									<input id="basicSublineCd" class="leftAligned upper" type="text" name="basicSublineCd" style="width: 16%;" value="" title="Subline Code"maxlength="7" />
									<input id="basicIssCd" class="leftAligned upper" type="text" name="basicIssCd" style="width: 8%;" value="" title="Issource Code"maxlength="2" />
									<input id="basicIssueYy" class="leftAligned" type="text" name="basicIssueYy" style="width: 8%;" value="" title="Year" maxlength="2" />
									<input id="basicPolSeqNo" class="leftAligned" type="text" name="basicPolSeqNo" style="width: 16%;" value="" title="Policy Sequence Number" maxlength="6"/>
									<input id="basicRenewNo" class="leftAligned" type="text" name="basicRenewNo" style="width: 8%;" value="" title="Renew Number" maxlength="2" />
								 </span>	
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="width: 70%;">
			<table align="center" style="width: 100%; margin: 10px;">
				<tr>
					<td class="rightAligned" style="width: 140px;">Intermediary</td>
					<td class="leftAligned" >
						<div style="float: left; border: solid 1px gray; width: 29.5%; height: 20px; margin-right: 4.3px; background-color: #fff;">
							<input type="text" style="height: 14px; float: left; margin-top: 0px; margin-right: 3px; width: 71%; border: none;" name="txtIntmNo" id="txtIntmNo" />
							<img id="intmLOV"  alt="goPolicyNo" style="height: 18px; " class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
						<div style="float: left; width: 52.5%; margin-right: 3px;">
							<input id="txtDspIntmName"  class="leftAligned upper" type="text" name="txtDspIntmName" style="float: left; margin-top: 0px; margin-right: 3px; width: 97.5%;  border: solid 1px gray; height: 14px;" readonly="readonly" value="" title="Subline Name" maxlength="240"/>
						</div>
					</td>
					</tr>
			</table>
		</div>
		<div id="unsettled" style="position: absolute; right:17px; width:28.75%; height:100px;  display: block; " class="sectionDiv">
				<br><label style="margin-left: 20px;">Unsettled Accounts</label><br><br>
				<input type="checkbox" id="balPrem" name="balPrem" tabindex="1"  value="" style="margin-left: 30px;"/> <label for="balPrem" style="float: none;">Balance Premiums</label><br><br>
				<input type="checkbox" id="onProc" name="onProc" tabindex="2"  value="" style="margin-left: 30px;"/> <label for="onProc" style="float: none;">Claims On-Process</label>
				<br>
		</div>
		<div id="fBLock" class="sectionDiv" style="margin-top: 5px; width: 718px;">
			<div id="innerDiv" name="innerDiv" style="background-color: #ccc">
				<label>Expiry Date</label>
			</div>
			<div id="range" style="margin: 30px; display: block; margin-top: 10px;" style="width: 85%;">
				<input type="hidden" id="rangeTag" name="rangeTag">
				<input type="radio" value="1" id="byMonthYear" name="fBLockTag" tabindex="1"  checked="checked"/> <label for="byMonthYear" style="float: none;">by Month/Year</label><br>
				<table style="margin-top: 0; width: 60%;">
						<tr>
							<td id="fmMonTitle" name="fmMonTitle" class="rightAligned" style="width: 5%;">From:</td>
							<td class="leftAligned" style="width: 15%;">
								<select id="fmMon" name="fmMon" style="width: 110px; margin-top: 1px;" disabled="disabled">
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
							<td class="leftAligned"><input type="text" style="width: 60px;" id="fmYear" name="fmYear"  disabled="disabled"/></td>
							<td id="fmMonTitle" name="fmMonTitle" class="rightAligned" style="width: 5%;">To:</td>
							<td class="leftAligned" style="width: 15%;">
								<select id="toMon" name="toMon" style="width: 110px; margin: 1px;" disabled="disabled">
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
							<td class="leftAligned" ><input type="text" style="width: 60px;" id="toYear" name="toYear" disabled="disabled"/></td>
						</tr>
				</table>
				<input type="radio" value="2" id="byDate" name="fBLockTag" tabindex="2" /> <label for="byDate" style="float: none;">by Date</label></span>
				<table style="margin-top: 0; width: 70%;">
						<tr>
							<td id="userIdTitle" name="userIdTitle" class="rightAligned" style="width: 5%;">From:</td>
							<td class="leftAligned"  style="width: 43%;">
								<div style="float: left; border: solid 1px gray; width: 108px; height: 20px; margin-right: 3px; background-color: #fff;">
									<input type="text" style="height: 14px; float: left; margin-top: 0px; margin-right: 3px; width: 74%; border: none;" name="fmDate" id="fmDate" readonly="readonly" disabled="disabled" cal=""/>
									<img id="imgFmDate" alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('fmDate'),this, null);"/>						
								</div>
							</td>
							<td id="userIdTitle" name="userIdTitle" class="rightAligned" style="width: 7.5%;">To:</td>
							<td class="leftAligned"  style="width: 43%;">
								<div style="float: left; border: solid 1px gray; width: 108px; height: 20px; margin-right: 3px; background-color: #fff;">
									<input type="text" style="height: 14px; float: left; margin-top: 0px; margin-right: 3px; width: 74%; border: none;" name="toDate" id="toDate" readonly="readonly" disabled="disabled" cal=""/>
									<img id="imgToDate"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('toDate'),this, null);"/>						
								</div>
							</td>
						</tr>
				</table>
			</div>
			<div id="rangeType" style="position: absolute; top:175px; right:60px; width:120px; height:105px;  display: block; " class="sectionDiv">
				<br><br>
				<input type="hidden" id="rangeTypeTag" name="rangeTypeTag">
				<input type="radio" value="1" id="onOrBefore" name="rangeType" tabindex="1"  style="margin-left: 10px;"/> <label for="onOrBefore" style="float: none;">On or Before</label><br><br>
				<input type="radio" value="2" id="exactRange" name="rangeType" tabindex="2"  checked="checked" style="margin-left: 10px;"/> <label for="exactRange" style="float: none;">Exact Range</label>
				<br>
			</div>
		</div>
	</form>
</div>
<div class="buttonsDivPopup">
	<input type="button" class="button" id="btnOk" name="btnOk" value="OK" style="width:120px;" />
	<input type="button" class="button" id="btnListAll" name="btnListAll" value="List All" style="width:120px;" />
	<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 120px;" />
</div>

<script>
	makeInputFieldUpperCase();
	$("basicLineCd").focus();
	var allUser = '${allUser}';
	
	function checkPolicyGIEXS004() {
		try{
			new Ajax.Request(contextPath+"/GIEXExpiriesVController?action=checkPolicyGIEXS004", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {
						lineCd: $F("basicLineCd"),
						sublineCd: $F("basicSublineCd"),
						issCd:$F("basicIssCd"),
						issueYy: $F("basicIssueYy"),
						polSeqNo: $F("basicPolSeqNo"),
						renewNo:$F("basicRenewNo")
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							if(result.msg != ""){
								if(result.msg =="Policy does not exist..."){
									showMessageBox(result.msg,"E");
								}else{
									showMessageBox(result.msg,"I");
								}
							}else{
								refreshExpPol();
							};
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("postQueryGIEXS004", e);
		}
	}
	
	function showByMonthYear(){
		$("rangeTag").value = 1;
		$("byMonthYear").checked = true;
		$("fmDate").disable();
		$("imgFmDate").hide();
		//$("fmDate").up("div",0).addClassName("disabled");
		$("toDate").disable();
		$("imgToDate").hide();
		//$("toDate").up("div",0).addClassName("disabled");
		$("fmMon").enable();
		$("fmYear").enable();
		$("fmDate").setStyle('width : 102px');
		$("toDate").setStyle('width : 102px');
		$("fmDate").value = "";
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
		$("rangeTag").value = 2;
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
			//$("toDate").up("div",0).addClassName("disabled");
			$("toDate").setStyle('width : 102px');
		}else{
			$("toDate").enable();
			$("imgToDate").show();
			//$("toDate").up("div",0).removeClassName("disabled");
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
		if($F("rangeTag") == 1){
			$("toMon").disable();
			$("toYear").disable();
		}else{
			$("toDate").disable();
			$("imgToDate").hide();
			$("toDate").up("div",0).addClassName("disabled");
			$("toDate").setStyle('width : 102px');
		}
	}
	
	function showExactRange(){
		$("rangeTypeTag").value = 2;
		if($F("rangeTag") == 1){
			$("toMon").enable();
			$("toYear").enable();
		}else{
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
			showMessageBox("From month and year cannot be earlier than to month and year.","E");
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
			showMessageBox("To month and year cannot be later than from month and year.","E");
		}
		if($F("toYear") != "" ){
			if ($F("toYear").length != 4 || isNaN($F("toYear"))){
				customShowMessageBox("Invalid year.","E", "toYear");
			}
		}
	}
	
	function showIntmCdNameLOV() {
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getIntmCdNameLOV",
							notIn: "",
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
	  		onSelect: function(row){
				 if(row != undefined) {
					$("txtIntmNo").value = formatNumberDigits(row.intmNo,8);
					$("txtDspIntmName").value = unescapeHTML2(row.intmName);
				 }
	  		}
		});
	}
	
	function validatePolLineCd(){
		new Ajax.Request(contextPath+"/GIEXExpiryController", {
			method: "POST",
			parameters: {action : "validatePolLineCd",
									   polLineCd : $F("basicLineCd"),
									   polSublineCd : "",
									   polIssCd : "",
									   lineCd : "",
									   issCd :"",
									   moduleId : "GIEXS004"},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var arr = response.responseText.split(",");
					var packPolFlag = arr[0];
					var msg = arr[1];
					if(msg == 1){
						showWaitingMessageBox("Line code does not exist in table giis_line.","I", function(){
							$("basicLineCd").value = "";
							$("basicLineCd").focus();});
					}else if(msg == 4){
						showWaitingMessageBox("Too many records found with this line code in table giis_line.","I", function(){
							$("basicLineCd").value = "";
							$("basicLineCd").focus();});
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
									   lineCd : $F("basicLineCd"),
									   issCd : "",
									   sublineCd : $F("basicSublineCd")},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var msg= response.responseText;
					if(msg == 1){
						showWaitingMessageBox("Subline code does not exist in table giis_subline.","I", function(){
							$("basicSublineCd").value = "";
							$("basicSublineCd").focus();});
					}
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
									   polLineCd : "",
									   polIssCd : $F("basicIssCd"),
									   issRi : "",
									   moduleId : "GIEXS004"},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var msg= response.responseText;
					if(msg == 2){
						showWaitingMessageBox("Issuing code does not exist in table giis_issource.","I", function(){
							$("basicIssCd").value = "";
							$("basicIssCd").focus();});
					}else if (msg == 4){
						showWaitingMessageBox("Too many records found with this issuing code in table giis_issource.","I", function(){
							$("basicIssCd").value = "";
							$("basicIssCd").focus();});
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	function populateVariables(){
		objGIEXExpiry.intmNo = $F("txtIntmNo");
		objGIEXExpiry.intmName = $F("txtDspIntmName");
		objGIEXExpiry.claimSw = $F("onProc");
		objGIEXExpiry.balanceSw = $F("balPrem");
		objGIEXExpiry.rangeType = $F("rangeTypeTag");
		objGIEXExpiry.range = $F("rangeTag");
		objGIEXExpiry.fmDate = $F("fmDate");
		objGIEXExpiry.toDate = $F("toDate");
		objGIEXExpiry.fmMon = $F("fmMon");
		objGIEXExpiry.fmYear = $F("fmYear");
		objGIEXExpiry.toMon = $F("toMon");
		objGIEXExpiry.toYear = $F("toYear");
		objGIEXExpiry.lineCd = $F("basicLineCd");
		objGIEXExpiry.sublineCd = $F("basicSublineCd");
		objGIEXExpiry.issCd = $F("basicIssCd");
		objGIEXExpiry.issueYy= $F("basicIssueYy");
		objGIEXExpiry.polSeqNo = $F("basicPolSeqNo");
		objGIEXExpiry.renewNo = $F("basicRenewNo");
	}
	
	function populateFields(){
		$("txtIntmNo").value = objGIEXExpiry.intmNo;
		$("txtDspIntmName").value = objGIEXExpiry.intmName;
		$("fmDate").value = objGIEXExpiry.fmDate;
		$("toDate").value = objGIEXExpiry.toDate ;
		$("fmMon").value = objGIEXExpiry.fmMon;
		$("fmYear").value = objGIEXExpiry.fmYear;
		$("toMon").value = objGIEXExpiry.toMon;
		$("toYear").value = objGIEXExpiry.toYear;
		$("basicLineCd").value = objGIEXExpiry.lineCd;
		$("basicSublineCd") .value = objGIEXExpiry.sublineCd;
		$("basicIssCd").value = objGIEXExpiry.issCd;
		$("basicIssueYy").value = objGIEXExpiry.issueYy;
		$("basicPolSeqNo").value = objGIEXExpiry.polSeqNo;
		$("basicRenewNo").value = objGIEXExpiry.renewNo;
		$("onProc").value = objGIEXExpiry.claimSw;
		$("balPrem").value = objGIEXExpiry.balanceSw;
		$("rangeTypeTag").value = objGIEXExpiry.rangeType;
	    $("rangeTag").value = objGIEXExpiry.range;
	    if($("onProc").value == "Y"){
	    	$("onProc").checked = true;
	    }
	    if($("balPrem").value == "Y"){
	    	$("balPrem").checked = true;
	    }
	    if($("rangeTypeTag").value == "1"){
	    	$("toMon").disable();
			$("toYear").disable();
	    	$("onOrBefore").checked = true;
	    }else{
	    	$("exactRange").checked = true;
	    	$("toMon").enable();
			$("toYear").enable();
			$("toDate").value = "";
	    }
	    if($("rangeTag").value == "1"){
	    	$("byMonthYear").checked = true;
	    }else{
	    	$("byDate").checked = true;
	    }
	}
	
	function refreshExpPol(){
		//Modalbox.hide();
		overlayQuery.close();
		$("selectedPolicies").checked = true;
		
		expPolGrid.url = contextPath+"//GIEXExpiriesVController?action=refreshQueriedExpPolListing&allUser="+allUser+"&intmNo="+objGIEXExpiry.intmNo
		+"&intmName="+objGIEXExpiry.intmName+"&claimSw="+objGIEXExpiry.claimSw+"&balanceSw="+objGIEXExpiry.balanceSw+"&rangeType="+objGIEXExpiry.rangeType
		+"&range="+objGIEXExpiry.range+"&fmDate="+objGIEXExpiry.fmDate+"&toDate="+objGIEXExpiry.toDate+"&fmMon="+objGIEXExpiry.fmMon+"&fmYear="+objGIEXExpiry.fmYear
		+"&toMon="+objGIEXExpiry.toMon+"&toYear="+objGIEXExpiry.toYear+"&lineCd="+objGIEXExpiry.lineCd+"&sublineCd="+encodeURIComponent(objGIEXExpiry.sublineCd) // objGIEXExpiry.sublineCd  //dren 09.09.2015 SR: 0020086 - Modified to display subline correctly for "H+1/H+2" when doing query
		+"&issCd="+objGIEXExpiry.issCd+"&issueYy="+objGIEXExpiry.issueYy+"&polSeqNo="+objGIEXExpiry.polSeqNo+"&renewNo="+objGIEXExpiry.renewNo;
		
		expPolGrid._refreshList();
	}
	
	$("byMonthYear").observe("click", showByMonthYear);
	$("byDate").observe("click", showByDate);
	$("onOrBefore").observe("click", showOnOrBefore);
	$("exactRange").observe("click", showExactRange);
	$("fmMon").observe("blur", checkFmMonYear);
	$("fmYear").observe("blur",checkFmMonYear); 
	$("toMon").observe("blur", checkToMonYear); 
	$("toYear").observe("blur", checkToMonYear); 
	
	$("fmDate").observe("blur", function(){
		fmDate = Date.parse($F("fmDate"));
		toDate = Date.parse($F("toDate"));
		if($F("fmDate") != "" && $F("toDate") != "" && (fmDate > toDate)){
			showMessageBox("From date should not be later than to date.","E");
		}
	}); 
	
	$("toDate").observe("blur", function(){
		fmDate = Date.parse($F("fmDate"));
		toDate = Date.parse($F("toDate"));
		if($F("fmDate") != "" && $F("toDate") != "" && (fmDate > toDate)){
			showMessageBox("To date should not be earlier than from date.","E");
		}
	});
	
	$("basicIssueYy").observe("blur", function(){
		if($F("basicIssueYy") != ""){
			if (isNaN($F("basicIssueYy"))){
				customShowMessageBox("Field must be of form 09.", "E", "basicIssueYy");
			}else{
				$("basicIssueYy").value = formatNumberDigits($F("basicIssueYy"),2);
			}
		}
	}); 
	
	$("basicPolSeqNo").observe("blur", function(){
		if($F("basicPolSeqNo") != ""){
			if (isNaN($F("basicPolSeqNo"))){
				customShowMessageBox("Field must be of form 0999999.", "E", "basicPolSeqNo");
			}else{
				$("basicPolSeqNo").value = formatNumberDigits($F("basicPolSeqNo"), 7);
			}
		}
	}); 
	
	$("txtIntmNo").observe("blur", function(){
		if($F("txtIntmNo") != ""){
			if (isNaN($F("txtIntmNo"))){
				customShowMessageBox("Field must be of form 00000009.", "E", "txtIntmNo");
			}else{
				$("txtIntmNo").value = formatNumberDigits($F("txtIntmNo"), 8);
			}
		}
	}); 
	
	$("basicRenewNo").observe("blur", function(){
		if($F("basicRenewNo") != ""){
			if (isNaN($F("basicRenewNo"))){
				customShowMessageBox("Field must be of form 09.", "E", "basicRenewNo");
			}else{
				$("basicRenewNo").value = formatNumberDigits($F("basicRenewNo"),2);
			}
		}
	});
	
	$("intmLOV").observe("click", function () {
			showIntmCdNameLOV();
	});
	
	$("btnCancel").observe("click", function(){
		//Modalbox.hide();
		overlayQuery.close();
	}); 
	
	$("btnOk").observe("click", function () {
		populateVariables();
		if ($F("rangeTypeTag")==2){
			if($F("rangeTag")== 2 && ($F("fmDate")!="" || $F("toDate")!="")){
				if($F("fmDate")==""){
					showMessageBox("Please enter from date to query records.","I");
					return false;
				}else if($F("toDate")==""){
					showMessageBox("Please enter to date to query records.","I");
					return false;
				}
			}else if ($F("rangeTag")==1 && (($F("toMon")!="" || $F("toYear")!="" || $F("fmMon")!="" || $F("fmYear")!=""))){
				if($F("fmMon")=="" || $F("fmYear")==""){
					showMessageBox("Please enter from month and year to query records.","I");
					return false;
				}else if($F("toMon")=="" || $F("toYear")==""){
					showMessageBox("Please enter to month and year to query records.","I");
					return false;
				}
			}
		}
		if($F("basicLineCd") != "" && $F("basicSublineCd") != "" &&  $F("basicIssCd") != "" 
			 &&  $F("basicIssueYy") != ""  &&  $F("basicPolSeqNo") != ""  &&  $F("basicRenewNo") != "" ){
			checkPolicyGIEXS004();
			return false;
		}
		
		if($F("txtIntmNo") == "" && $F("onProc") == null && $F("balPrem") == null 
				&& $F("fmDate") == "" && $F("toDate") == ""	&& $F("fmMon") == ""
				&& $F("fmYear") == "" && $F("toMon") == "" && $F("toYear") == ""
				&& $F("basicLineCd") == "" && $F("basicSublineCd") == "" && $F("basicIssCd") == ""
				&& $F("basicIssueYy") == ""	&& $F("basicPolSeqNo") == "" && $F("basicRenewNo") == ""){			
			showWaitingMessageBox("Please enter at least one parameter.", function(){
				$("basicLineCd").focus();			
			});
		} else {
			objGIEXExpiry.querySw = "Y";
			refreshExpPol();
		}
	});
	
	$("basicLineCd").observe("blur", function(){
		if($F("basicLineCd") == ""){
			$("basicSublineCd").writeAttribute("readonly","readonly");
		}else {
			validatePolLineCd();
			$("basicSublineCd").writeAttribute("readonly",false);
		}
	}); 

	$("basicSublineCd").observe("blur", function(){
		if($F("basicSublineCd") != ""){
			validateSublineCd();
		}
	}); 
	
	$("basicIssCd").observe("blur", function(){
		if($F("basicIssCd") != ""){
			validatePolIssCd();
		}
	}); 
	
	$("balPrem").observe("click",function(){
		if($("balPrem").checked == true){
			$("balPrem").writeAttribute("value","Y");
		}
	});
	
	$("onProc").observe("click",function(){
		if($("onProc").checked == true){
			$("onProc").writeAttribute("value","Y");
		}
	});
	
	populateFields();
	showByMonthYear();
	showExactRange();
	
	// override 
	/* if(nvl(objGIEXExpiry.rangeType,"") == "1"){
		$("toMon").disable();
		$("toYear").disable();
	}
	
	if(nvl(objGIEXExpiry.range ,"") == "2"){
		$("toMon").disable();
		$("toYear").disable();
		$("fmMon").disable();
		$("fmYear").disable();
		
		
	} */
	
	 if(nvl(objGIEXExpiry.rangeType,"") != "" || nvl(objGIEXExpiry.range ,"") != ""){
		 $("rangeTypeTag").value = objGIEXExpiry.rangeType; 
		 $("rangeTag").value = objGIEXExpiry.range;
		 if(objGIEXExpiry.range == "1"){
			 showByMonthYear();
		 }else{
			 showByDate();
			 $("byDate").checked = true;
		 }
	 }
	 
	 $("btnListAll").observe("click", function(){
		objGIEXExpiry.intmNo = "";
		objGIEXExpiry.intmName = "";
		objGIEXExpiry.claimSw = "";
		objGIEXExpiry.balanceSw = "";
		objGIEXExpiry.rangeType = "";
		objGIEXExpiry.range = "";
		objGIEXExpiry.fmDate = "";
		objGIEXExpiry.toDate = "";
		objGIEXExpiry.fmMon = "";
		objGIEXExpiry.fmYear = "";
		objGIEXExpiry.toMon = "";
		objGIEXExpiry.toYear = "";
		objGIEXExpiry.lineCd = "";
		objGIEXExpiry.sublineCd = "";
		objGIEXExpiry.issCd = "";
		objGIEXExpiry.issueYy= "";
		objGIEXExpiry.polSeqNo = "";
		objGIEXExpiry.renewNo = "";
		
		showConfirmBox("Confirmation", "Do you want to load all records assigned to you?", "Yes", "No", refreshExpPol, ""); 
	 });
</script>