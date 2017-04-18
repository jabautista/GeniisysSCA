<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>  
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="claimsRecoveryRegisterMainDiv">
	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="clmRecoveryRegisterExit">Exit</a></li>
				</ul>
			</div>
		</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Claim Recovery Register</label>
		</div>
	</div>

	<div id="clmRecoveryRegDiv" name="clmRecoveryRegDiv" class="sectionDiv" style="height: 485px;">
		<div id="dateDiv" class="sectionDiv" align="center" style="height: 370px; width: 520px; margin: 20px 200px 0 200px">
			<table id="clmRecRegTbl" align="center" style="margin: 25px 10px 5px 20px;">
				<tr>
					<td colspan="2">
						<input id="fromToDateRB" name="dateRG" type="radio" value="1" checked="checked" style="float: left; margin-left: 10px;"><label for="fromToDateRB" style="margin: 2px 8px 4px 10px">From :</label>
						<div id="fromDateDiv" name="fromDateDiv" class="required withIcon" style="float: left; border: 1px solid gray; width: 160px; height: 20px; ">
							<input id="txtFromDate" name="txtFromDate" readonly="readonly" type="text" class="leftAligned required" maxlength="10" style="border: none; float: left; width: 135px; height: 13px; margin: 0px;" value="" tabindex="101"/>
							<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="102" />
						</div>
						<label id="lblTo" style="margin: 0 5px 0 20px;">To :</label>
						<div id="toDateDiv" name="toDateDiv" class="required withIcon" style="float: left; border: 1px solid gray; width: 160px; height: 20px;">
							<input id="txtToDate" name="txtToDate" readonly="readonly" type="text" class="leftAligned required" maxlength="10" style="border: none; float: left; width: 135px; height: 13px; margin: 0px;" value="" tabindex="103"/>
							<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="104" />
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<input id="asOfDateRB" name="dateRG" type="radio" value="2" style="float: left; margin: 10px 0 0 10px;"><label for="asOfDateRB" style="margin: 10px 8px 4px 10px">Outstanding Claims Recovery as of :</label>
						<div id="asOfDateDiv" name="asOfDateDiv" style="float: left; border: 1px solid gray; width: 160px; height: 20px; margin: 5px 0 35px 41px;">
							<input id="txtAsOfDate" name="txtAsOfDate" readonly="readonly" type="text" class="leftAligned" maxlength="10" style="border: none; float: left; width: 135px; height: 13px; margin: 0px;" value="" tabindex="105"/>
							<img id="imgAsOfDate" alt="imgAsOfDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtAsOfDate'),this, null);"  tabindex="106"/>
						</div>
					</td>
				</tr>	
				<tr>
					<td style="text-align: right; margin-right: 10px;">Line</td>
					<td>
						<div id="lineCdDiv" name="lineCdDiv" style="border: 1px solid gray; width: 100px; height: 20px; margin: 2px 7px 0 0; float: left;">
							<input id="txtLineCd" name="txtLineCd" class="leftAligned upper" type="text" maxlength="2" style="border: none; float: left; width: 70px; height: 13px; margin: 0px;" value="" tabindex="107"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;" tabindex="108"/>
						</div>	
						<input id="txtLineName" name="txtLineName" type="text" readonly="readonly" style="width: 230px; height: 14px;">
					</td>
				</tr>	
				<tr>
					<td style="text-align: right; margin-right: 7px;">Branch</td>
					<td>
						<div id="issCdDiv" name="issCdDiv" style="border: 1px solid gray; width: 100px; height: 20px; margin: 2px 7px 0 0; float: left;">
							<input id="txtIssCd" name="txtIssCd" class="leftAligned upper" type="text" maxlength="2" style="border: none; float: left; width: 70px; height: 13px; margin: 0px;" value="" tabindex="109"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCd" name="searchIssCd" alt="Go" style="float: right;" tabindex="110"/>
						</div>	
						<input id="txtIssName" name="txtIssName" type="text" readonly="readonly" style="width: 230px;">
					</td>
				</tr>
				<tr>
					<td style="text-align: right; margin-right: 7px;">Recovery Type</td>
					<td>
						<div id="recTypeCdDiv" name="recTypeCdDiv" style="border: 1px solid gray; width: 100px; height: 20px; margin: 2px 7px 0 0; float: left;">
							<input id="txtRecTypeCd" name="txtRecTypeCd" class="leftAligned upper" type="text" maxlength="5" style="border: none; float: left; width: 70px; height: 13px; margin: 0px;" value="" tabindex="111"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRecTypeCd" name="searchRecTypeCd" alt="Go" style="float: right;" tabindex="112"/>
						</div>	
						<input id="txtRecTypeDesc" name="txtRecTypeDesc" type="text" readonly="readonly" style="width: 230px;">
					</td>
				</tr>			
			</table>			
			
			<div id="regDiv" class="sectionDiv" style="width: 150px; height: 100px; margin: 20px 150px 0 200px;">
				<table style="margin: 15px 10px 5px 10px;">
					<tr>
						<td><input id="lossDateRB" name="regDateRG" type="radio" value="1" checked="checked" style="float: left;"><label for="lossDateRB" style="margin: 2px 8px 4px 8px">Loss Date</label></td>
					</tr>
					<tr>
						<td><input id="claimFileDateRB" name="regDateRG" type="radio" value="2" style="float: left;"><label for="claimFileDateRB" style="margin: 2px 8px 4px 8px">Claim File Date</label></td>
					</tr>
					<tr>
						<td><input id="recoveryDateRB" name="regDateRG" type="radio" value="3" style="float: left;"><label for="recoveryDateRB" style="margin: 2px 8px 4px 8px">Recovery Date</label></td>
					</tr>
				</table>
			</div>
		</div>
		
		<div id="clmRecoveryRegBtnsDiv" class="buttonsDiv" style="margin-top: 20px;">
			<input id="btnPrint" name="btnPrint" type="button" class="button" value="Print" style="width: 100px;" tabindex="113">
		</div>
	</div>
</div>

<script type="text/javascript">
	setModuleId("GICLS201");
	setDocumentTitle("Claim Recovery Register");
	initializeAll();
	
	disableDate("imgAsOfDate");

	objGICLS201.dateRG = $F("fromToDateRB");
	objGICLS201.regDateRG = $F("lossDateRB");
		
	/*$("txtLineName").value = "ALL LINES";
	$("txtIssName").value = "ALL BRANCHES";
	$("txtRecTypeDesc").value = "ALL RECOVERY TYPES";*/
	
	$("clmRecoveryRegisterExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	$$("input[name='dateRG']").each(function(radio){
		radio.observe("click", function(){
			if(radio.value == 1){
				$("txtAsOfDate").value = "";
				disableDate("imgAsOfDate");
				enableDate("imgFromDate");
				enableDate("imgToDate");
				$("lossDateRB").disabled = false;
				$("claimFileDateRB").disabled = false;
				$("recoveryDateRB").disabled = false;
				$("txtFromDate").focus();
				$("fromDateDiv").addClassName("required");
				$("toDateDiv").addClassName("required");
				$("txtFromDate").addClassName("required");
				$("txtToDate").addClassName("required");
				$("asOfDateDiv").removeClassName("required");
				$("txtAsOfDate").removeClassName("required");
			}else{
				$("txtFromDate").value = "";
				$("txtToDate").value = "";
				disableDate("imgFromDate");
				disableDate("imgToDate");
				enableDate("imgAsOfDate");
				$("lossDateRB").disabled = true;
				$("claimFileDateRB").disabled = true;
				$("recoveryDateRB").disabled = true;
				$("txtAsOfDate").value = dateFormat(new Date(), 'mm-dd-yyyy');
				$("txtAsOfDate").focus();
				$("asOfDateDiv").addClassName("required");
				$("txtAsOfDate").addClassName("required");
				$("fromDateDiv").removeClassName("required");
				$("toDateDiv").removeClassName("required");
				$("txtFromDate").removeClassName("required");
				$("txtToDate").removeClassName("required");
			}
			
			objGICLS201.dateRG = radio.value;
		});
	});
	
	$$("input[name='regDateRG']").each(function(radio){
		radio.observe("click", function(){
			objGICLS201.regDateRG = radio.value;
		});
	});
	
	/*$("txtFromDate").observe("blur", function(){
		if ($("fromToDateRB").checked){
			if ($F("txtFromDate") > $F("txtToDate") && $F("txtToDate") != ""){
				showMessageBox("Start date should not be later than the End date.", "I");
			}
		}
	});
	
	$("txtToDate").observe("blur", function(){
		if($("fromToDateRB").checked){
			if($F("txtFromDate") != "" && $F("txtToDate") == ""){
				showMessageBox("Please enter ending date.", "I");
			}else if ($F("txtToDate") < $F("txtFromDate")){
				showMessageBox("End date should not be earlier than the Start date.", "I");
			}
		}
	});*/
	
	$("imgFromDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtFromDate", "txtFromDate", "txtToDate");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtFromDate"),this, null);
	});
	
	$("imgToDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtToDate", "txtFromDate", "txtToDate");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtToDate"),this, null);
	});
	
	$("searchLineCd").observe("click", function(){
		showGicls201LineLOV(true);
	});
	
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $("txtLineCd").value.toUpperCase();	
	});
	
	$("txtLineCd").observe("change", function(){
		if($F("txtLineCd") == ""){
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "ALL LINES";
		}else{
			showGicls201LineLOV(false); //getLineNameGicls201();
		}
	});
	

	$("searchIssCd").observe("click", function(){
		showGicls201IssueLOV(true);
	});
	
	$("txtIssCd").observe("keyup", function(){
		$("txtIssCd").value = $("txtIssCd").value.toUpperCase();	
	});
	
	$("txtIssCd").observe("change", function(){
		if($F("txtIssCd") == ""){
			$("txtIssCd").setAttribute("lastValidValue", "");
			$("txtIssName").value = "ALL BRANCHES";
		}else{
			showGicls201IssueLOV(false); //getIssNameGicls201();
		}
	});
	

	$("searchRecTypeCd").observe("click", function(){
		showGicls201RecTypeLOV(true);
	});
	
	$("txtRecTypeCd").observe("keyup", function(){
		$("txtRecTypeCd").value = $("txtRecTypeCd").value.toUpperCase();	
	});
		
	$("txtRecTypeCd").observe("change", function(){
		if($F("txtRecTypeCd") == ""){
			$("txtRecTypeCd").setAttribute("lastValidValue", "");
			$("txtRecTypeDesc").value = "ALL RECOVERY TYPES";
		}else{
			showGicls201RecTypeLOV(false); //getRecTypeDescGicls201(0);
		}
	});
	
	$("btnPrint").observe("click", function(){
		/*if($("fromToDateRB").checked){
			if($F("txtFromDate") == "" && $F("txtToDate") == ""){
				showMessageBox("Please enter date.", "I");
				return false;
			}else if($F("txtFromDate") == "" && $F("txtToDate") != ""){
				showMessageBox("Please enter Start date.", "I");
				return false;
			}else if($F("txtToDate") == "" && $F("txtFromDate") != ""){
				showMessageBox("Please enter End date.", "I");
				return false;
			}
		}else if($("asOfDateRB").checked){
			if($F("txtAsOfDate") == ""){
				showMessageBox("Please enter date.", "I");
				return false;
			}
		}*/
		
		if (checkAllRequiredFieldsInDiv('dateDiv')){
			objGICLS201.fromDate = $F("txtFromDate");
			objGICLS201.toDate = $F("txtToDate");
			objGICLS201.asOfDate = $F("txtAsOfDate");
			objGICLS201.lineCd = $F("txtLineCd");
			objGICLS201.issCd = $F("txtIssCd");
			objGICLS201.recTypeCd = $F("txtRecTypeCd");
			
			showPrintWindow();
		}
		
	});
	
	
	function showGicls201LineLOV(isIconClicked) {
		var searchString = isIconClicked ? "%" : ($F("txtLineCd").trim() == "" ? "%" : $F("txtLineCd"));
		
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getAllLineLOV",
					issCd : "",
					moduleId : "GICLS201",
					searchString: searchString
				},
				title: 'List of Lines',
				width : 405,
				height : 386,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				columnModel : [ {
					id : "lineCd",
					title : "Line Cd",
					width : '80px'
				}, {
					id : "lineName",
					title : "Line Name",
					width : '308px'
				} ],
				draggable : true,
				onSelect: function(row){
					if(row != undefined){
						$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
						$("txtLineCd").value = row.lineCd;
						$("txtLineName").value = unescapeHTML2(row.lineName);
					}
				},
				onCancel: function(){
					$("txtLineCd").focus();
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				} 
			});
		} catch (e) {
			showErrorMessage("showGicls201LineLOV", e);
		}
	}

	function showGicls201RecTypeLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtRecTypeCd").trim() == "" ? "%" : $F("txtRecTypeCd"));
		
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {
					action : 		"getGiisRecoveryTypeLOV",
					searchString:	searchString,	
					page : 			1 
				},
				title: 'List of Recovery Types',
				width: 405,
				height: 386,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				columnModel:[	
				             	{	id : "recTypeCd",
									title: "Recovery Type",
									width: '100px'
								},
								{	id : "recTypeDesc",
									title: "Recovery Type Description",
									width: '320px'
								} 
							],
				draggable: true,
				onSelect: function(row){
					if(row != undefined){
						$("txtRecTypeCd").setAttribute("lastValidValue", row.recTypeCd);
						$("txtRecTypeCd").value = row.recTypeCd;
						$("txtRecTypeDesc").value = unescapeHTML2(row.recTypeDesc);
					}
				},
				onCancel: function(){
					$("txtRecTypeCd").focus();
					$("txtRecTypeCd").value = $("txtRecTypeCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtRecTypeCd").value = $("txtRecTypeCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtRecTypeCd");
				}
			});
		}catch(e){
			showErrorMessage("showGicls201RecTypeLOV",e);
		}
	}
	
	function showGicls201IssueLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtIssCd").trim() == "" ? "%" : $F("txtIssCd"));
		
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {
					action : 		"getIssSourceGicls201LOV",
					moduleId:		"GICLS201",	
					searchString:	searchString,
					page : 			1 
				},
				title: 'List of Branches',
				width: 405,
				height: 386,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				columnModel:[	
				             	{	id : "issCd",
									title: "Branch",
									width: '70px'
								},
								{	id : "issName",
									title: "Branch Name",
									width: '320px'
								} 
							],
				draggable: true,
				onSelect: function(row){
					if(row != undefined){
						$("txtIssCd").setAttribute("lastValidValue", row.issCd);
						$("txtIssCd").value = row.issCd;
						$("txtIssName").value = unescapeHTML2(row.issName);
					}
				},
				onCancel: function(){
					$("txtIssCd").focus();
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIssCd");
				} 
			});
		}catch(e){
			showErrorMessage("showGicls201IssueLOV",e);
		}
	}
	
	function getLineNameGicls201(){
		try{
			new Ajax.Request(contextPath+"/GICLClaimsRecoveryRegisterController",{
				method: "GET",
				parameters: {
					action:		"getLineNameGicls201",
					moduleId:	"GICLS201",
					lineCd:		$F("txtLineCd")
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						
						if(obj.found == "Y"){
							$("txtLineName").value = obj.lineName;
						}else{
							$("txtLineCd").value = "";
							$("txtLineCd").focus();
							showMessageBox("Invalid value for Line CD", "E");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("getLineNameGicls201", e);
		}
	}
	
	function getIssNameGicls201(){
		try{
			new Ajax.Request(contextPath+"/GICLClaimsRecoveryRegisterController",{
				method: "GET",
				parameters: {
					action:		"getIssNameGicls201",
					moduleId:	"GICLS201",
					issCd:		$F("txtIssCd")
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						
						if(obj.found == "Y"){
							$("txtIssName").value = obj.issName;
						}else{
							$("txtIssCd").value = "";
							$("txtIssCd").focus();
							showMessageBox("Invalid value for Issue CD", "E");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("getIssNameGicls201", e);
		}
	}
	
	function getRecTypeDescGicls201(){
		try{
			new Ajax.Request(contextPath+"/GICLClaimsRecoveryRegisterController",{
				method: "GET",
				parameters: {
					action:		"getRecTypeDescGicls201",
					recTypeCd:		$F("txtRecTypeCd")
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						
						if(obj.found == "Y"){
							$("txtRecTypeDesc").value = obj.recTypeDesc;
						}else{
							$("txtRecTypeCd").value = "";
							$("txtRecTypeCd").focus();
							showMessageBox("Invalid value for Recovery Type CD", "E");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("getRecTypeDescGicls201", e);
		}
	}
	
	function showPrintWindow(){
		try{
			genericObjOverlay = Overlay.show(contextPath+"/GICLClaimsRecoveryRegisterController",{
				urlContent: true,
				urlParameters: {
					action: "showPrintWindow"
				},
				title: "Print Recovery Register",
				height: 250,
				width: 505,
				draggable: true
			});
		}catch(e){
			showErrorMessage("showPrintWindow", e);
		}
	}
	
</script>