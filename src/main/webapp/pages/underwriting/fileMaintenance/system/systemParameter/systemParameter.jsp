<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss085MainDiv" name="giiss085MainDiv" style="">
	<div id="systemParameterExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="uwExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>System Parameter Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss085" name="giiss085">		
		<div class="sectionDiv">			
			<div id="systemParameterFormDiv" style="width: 100%">
				<div>
					<div id="tabComponentsDiv1" class="tabComponents1" style="align:center;width:100%">
						<ul>
							<li class="tab1 selectedTab1" style="width:15%"><a id="dateFormatTab">Date Format</a></li>
							<li class="tab1" style="width:25%"><a id="autoParAssgnmntTab">Automatic Par Assignment</a></li>
							<li class="tab1" style="width:20%"><a id="retLimitFlagTab">Retention Limit Flag</a></li>
							<li class="tab1" style="width:15%"><a id="blkLimitFlagTab">Block Limit Flag</a></li>	
							<li class="tab1" style="width:15%"><a id="vslLimitFlagTab">Vessel Limit Flag</a></li>			
						</ul>			
					</div>
					<div class="tabBorderBottom1"></div>
				</div>						
				<div style="width: 100%;float: left">	
					<fieldset style="width: 500px;height: 229.5px;margin:15px 0 5px 90px; float: left">
						<div style="margin: 70px 0 65px 65px;float: left">	
							<table>
								<tr>
									<td style="width: 115px"><div id="divParamName" class="rightAligned">Parameter's Name</div></td>	
									<td><input id="txtParamName" type="text" style="width: 220px;" readonly="readonly" tabindex="200"/></td>									
								</tr>	
								<tr>
									<td style="width: 115px"><div id="divParamLength" class="rightAligned">Parameter's Length</div></td>	
									<td><input id="txtParamLength" type="text" style="width: 220px" readonly="readonly" class="rightAligned" tabindex="201"/></td>									
								</tr>		
								<tr>
									<td style="width: 115px"><div id="divParamType" class="rightAligned">Parameter's Type</div></td>	
									<td><input id="txtParamType" type="text" style="width: 220px" readonly="readonly" tabindex="202"/></td>									
								</tr>																								
							</table>
						</div>									
					</fieldset>
					<fieldset style="width: 200px; height: 235px;float: left;margin: 9px 0 0 10px">
						<legend><strong>Parameter's Value</strong></legend>											
						<div style="margin: 67px 0 74px 35px">
							<table>
								<tr>
									<td align="right"><input type="radio" id="rdo1" name="rdoParamValue" tabindex="203"/></td>
									<td><label for="rdo1" id="lblRdo1">MM-DD-YYYY</label></td>
								</tr>
									<tr>
									<td align="right"><input type="radio" id="rdo2" name="rdoParamValue" tabindex="204"/></td>
									<td><label for="rdo2" id="lblRdo2">MON DD, YYYY</label></td>
								</tr>
								<tr>
									<td align="right"><input type="radio" id="rdo3" name="rdoParamValue" tabindex="205"/></td>
									<td><label for="rdo3" id="lblRdo3">YYYY-MM-DD</label></td>
								</tr>
								<tr>
									<td align="right"><input type="radio" id="rdo4" name="rdoParamValue" tabindex="206"/></td>
									<td><label for="rdo4" id="lblRdo4">DD-MM-YYYY</label></td>
								</tr>
							</table>
						</div>	
					</fieldset>
				</div>			
			</div>	
			<div align="center" style="width: 100%; float: left">
				<table style="margin: 5px 0 5px 0;">													
					<tr>
						<td align="right">Remarks</td>
						<td colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 553px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 502px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="207"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" tabindex="208"/>
							</div>
						</td>
					</tr>
					<tr>
						<td align="right">User ID</td>
						<td><input id="txtUserId" type="text" style="width: 200px;" readonly="readonly" tabindex="209"></td>
						<td width="130px" align="right">Last Update</td>
						<td><input id="txtLastUpdate" type="text" style="width: 200px;" readonly="readonly" tabindex="210"></td>
					</tr>			
				</table>	
			</div>				
		</div>
	</div>		
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="211">
		<input type="button" class="button" id="btnSave" value="Save" tabindex="212">
	</div>
</div>
<script type="text/javascript">	
	setModuleId("GIISS085");
	setDocumentTitle("System Parameter Maintenance");
	initializeAll();
	initializeTabs();
	initializeAccordion();
	changeTag = 0;
	insertTag = 0;
	var objGIISS085 = {};
	var objParameter ={};	
	objGIISS085.exitPage = null;	
	
	function saveGiiss085(){
		if(objParameter.paramValueV==null){
			showMessageBox("Please select a parameter value.", "I");
			return;
		}
		var parameters = new Array();
		parameters[0] = objParameter;	
		new Ajax.Request(contextPath+"/GIISParameterController", {
			method: "POST",
			parameters : {action : "saveGiiss085",
				parameters : prepareJsonAsParameter(parameters)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					changeTag = 0;
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS085.exitPage != null) {
							objGIISS085.exitPage();
						} else {				
							getGiiss085Rec(objParameter.paramName);
						}
					});
					
				}
			}
		}); 
	}		
		
	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting",
				"Underwriting Main", null);
	}

	function cancelGiiss085() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS085.exitPage = exitPage;
						saveGiiss085();
					}, function() {
						goToModule(
								"/GIISUserController?action=goToUnderwriting",
								"Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting",
					"Underwriting Main", null);
		}		
	}	
	
	function getGiiss085Rec(paramName){
		try{				
			new Ajax.Request(contextPath + "/GIISParameterController", {
				method : "POST",
				parameters : {
					action : "getGiiss085Rec",
					paramName : paramName,
					refresh : 1
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function(){
					showNotice("Extracting records...");
				},
				onComplete : function(response) {
					hideNotice();
					objGIISS085 = JSON.parse(response.responseText);				
					if (checkErrorOnResponse(response)){					
						if(objGIISS085.currRecord == null){
							objGIISS085.currRecord = setObjNoRecord(paramName);
							setRec(objGIISS085.currRecord);
							setFieldValues(objGIISS085.currRecord);	
							setRdoParamValue(objGIISS085.currRecord);
						}else{
							setRec(objGIISS085.currRecord);
							setFieldValues(objGIISS085.currRecord);	
							setRdoParamValue(objGIISS085.currRecord);
						}						
					}
				}
			});				
		}catch(e){
			showErrorMessage("getGiiss085Rec", e);
		}
	}
	
	function setRec(rec){
		try{
			objParameter.paramName = (rec == null ? "" : rec.paramName);
			objParameter.paramLength = (rec == null ? "" : rec.paramLength);
			objParameter.paramType = (rec == null ? "" : rec.paramType);
			objParameter.paramValueV = (rec == null ? "" : rec.paramValueV);
			objParameter.remarks = (rec == null ? "" : escapeHTML2(rec.remarks));
			objParameter.userId = (rec == null ? "" : rec.userId);
			objParameter.lastUpdate = (rec == null ? "" : rec.lastUpdate);		
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function setFieldValues(rec){
		try{
			$("txtParamName").value = (rec == null ? "" : rec.paramName);
			$("txtParamLength").value = (rec == null ? "" : rec.paramLength);
			$("txtParamType").value = (rec == null ? "" : rec.paramType);
			$("txtRemarks").value = (rec == null ? "" : rec.remarks);
			$("txtUserId").value = (rec == null ? "" : rec.userId);
			$("txtLastUpdate").value = (rec == null ? "" :rec.lastUpdate);		
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setObjNoRecord(paramName){
		try{
			var obj = new Object();
			if(paramName=="DATE_FORMAT"){			
				obj.paramName = "DATE_FORMAT";
				obj.paramLength = 1;
				obj.paramType = "V";
				obj.remarks = "";
				obj.paramValueV = null;	
				obj.userId = null;
				obj.lastUpdate = null;
			}else if(paramName=="AUTOMATIC_PAR_ASSIGNMENT_FLAG"){
				obj.paramName = "AUTOMATIC_PAR_ASSIGNMENT_FLAG";
				obj.paramLength = 1;
				obj.paramType = "V";
				obj.remarks = "";
				obj.paramValueV = null;	
				obj.userId = null;
				obj.lastUpdate = null;				
			}else if(paramName=="RETENTION_LIMIT_FLAG"){
				obj.paramName = "RETENTION_LIMIT_FLAG";
				obj.paramLength = 1;
				obj.paramType = "V";
				obj.remarks = "";
				obj.paramValueV = null;	
				obj.userId = null;
				obj.lastUpdate = null;		
			}else if(paramName=="BLOCK_LIMIT_FLAG"){
				obj.paramName = "BLOCK_LIMIT_FLAG";
				obj.paramLength = 1;
				obj.paramType = "V";
				obj.remarks = "";
				obj.paramValueV = null;	
				obj.userId = null;
				obj.lastUpdate = null;					
			}else if(paramName=="VESSEL_LIMIT_FLAG"){
				obj.paramName = "VESSEL_LIMIT_FLAG";
				obj.paramLength = 1;
				obj.paramType = "V";
				obj.remarks = "";
				obj.paramValueV = null;	
				obj.userId = null;
				obj.lastUpdate = null;					
			}
			return obj;
		} catch(e){
			showErrorMessage("setObjNoRecord", e);
		}
	}
	
	function setRdoParamValue(rec) {
		try {
			if(rec != null){
				if(rec.paramName=="DATE_FORMAT"){
					if(rec.paramValueV=="MM-DD-RRRR") {
						$("rdo1").checked = true;				
					}else if(rec.paramValueV=="MON DD, YYYY") {
						$("rdo2").checked = true;				
					}else if(rec.paramValueV=="YYYY-MM-DD") {
						$("rdo3").checked = true;
					}else if(rec.paramValueV=="DD-MM-YYYY") {
						$("rdo4").checked = true;
					}else{
						$("rdo1").checked = false;			
						$("rdo2").checked = false;		
						$("rdo3").checked = false;		
						$("rdo4").checked = false;		
					}
				}else if(rec.paramName=="AUTOMATIC_PAR_ASSIGNMENT_FLAG"){
					if(rec.paramValueV=="Y") {
						$("rdo1").checked = true;				
					}else if(rec.paramValueV=="N") {
						$("rdo2").checked = true;				
					}else{
						$("rdo1").checked = false;			
						$("rdo2").checked = false;								
					}
				}else if(rec.paramName=="RETENTION_LIMIT_FLAG"){
					if(rec.paramValueV=="ALLOW") {
						$("rdo1").checked = true;				
					}else if(rec.paramValueV=="DON'T ALLOW") {
						$("rdo2").checked = true;				
					}else if(rec.paramValueV=="WARN") {
						$("rdo3").checked = true;				
					}else{
						$("rdo1").checked = false;			
						$("rdo2").checked = false;		
						$("rdo3").checked = false;							
					}
				}else if(rec.paramName=="BLOCK_LIMIT_FLAG"){
					if(rec.paramValueV=="ALLOW") {
						$("rdo1").checked = true;				
					}else if(rec.paramValueV=="DON'T ALLOW") {
						$("rdo2").checked = true;				
					}else if(rec.paramValueV=="WARN") {
						$("rdo3").checked = true;				
					}else{
						$("rdo1").checked = false;			
						$("rdo2").checked = false;		
						$("rdo3").checked = false;	
					}
				}else if(rec.paramName=="VESSEL_LIMIT_FLAG"){
					if(rec.paramValueV=="ALLOW") {
						$("rdo1").checked = true;				
					}else if(rec.paramValueV=="DON'T ALLOW") {
						$("rdo2").checked = true;				
					}else if(rec.paramValueV=="WARN") {
						$("rdo3").checked = true;				
					}else{
						$("rdo1").checked = false;			
						$("rdo2").checked = false;		
						$("rdo3").checked = false;								
					} 
				}
			}			
		} catch(e) {
			showErrorMessage("setRdoParamValue", e);
		}
	}
	
	function initializeFields(paramName){
		if(paramName == "DATE_FORMAT"){		
			$("rdo3").show();
			$("rdo4").show();		
			$("lblRdo1").innerHTML = "MM-DD-YYYY";
			$("lblRdo2").innerHTML = "MON DD, YYYY";
			$("lblRdo3").innerHTML = "YYYY-MM-DD";
			$("lblRdo4").innerHTML = "DD-MM-YYYY";
			$("lblRdo3").show();
			$("lblRdo4").show();
		}else if(paramName == "AUTOMATIC_PAR_ASSIGNMENT_FLAG"){
			$("rdo3").hide();
			$("rdo4").hide();		
			$("lblRdo1").innerHTML = "YES";
			$("lblRdo2").innerHTML = "NO";
			$("lblRdo3").hide();
			$("lblRdo4").hide();
		}else if(paramName == "RETENTION_LIMIT_FLAG"){
			$("rdo3").show();
			$("rdo4").hide();		
			$("lblRdo1").innerHTML = "ALLOW";
			$("lblRdo2").innerHTML = "DON'T ALLOW";
			$("lblRdo3").innerHTML = "WARN";
			$("lblRdo3").show();
			$("lblRdo4").hide();
		}else if(paramName == "BLOCK_LIMIT_FLAG"){
			$("rdo3").show();
			$("rdo4").hide();		
			$("lblRdo1").innerHTML = "ALLOW";
			$("lblRdo2").innerHTML = "DON'T ALLOW";
			$("lblRdo3").innerHTML = "WARN";
			$("lblRdo3").show();
			$("lblRdo4").hide();
		}else if(paramName == "VESSEL_LIMIT_FLAG"){
			$("rdo3").show();
			$("rdo4").hide();		
			$("lblRdo1").innerHTML = "ALLOW";
			$("lblRdo2").innerHTML = "DON'T ALLOW";
			$("lblRdo3").innerHTML = "WARN";
			$("lblRdo3").show();
			$("lblRdo4").hide();
		}		
	}
	
	function initializeGiiss085(){
		fireEvent($("dateFormatTab"), "click");
		$("dateFormatTab").focus();
	}
	function checkChangesOnTab(tab,paramName){		
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");				
		} else {
			initializeFields(paramName);
			getGiiss085Rec(paramName);
		}			
	}
	$("dateFormatTab").observe("click", function() {
		checkChangesOnTab("dateFormatTab","DATE_FORMAT");
	});	 
	
	$("autoParAssgnmntTab").observe("click", function() {
		checkChangesOnTab("autoParAssgnmntTab","AUTOMATIC_PAR_ASSIGNMENT_FLAG");		
	});	 
	
	$("retLimitFlagTab").observe("click", function() {
		checkChangesOnTab("retLimitFlagTab","RETENTION_LIMIT_FLAG");		
	});	 
	
	$("blkLimitFlagTab").observe("click", function() {
		checkChangesOnTab("blkLimitFlagTab","BLOCK_LIMIT_FLAG");			
	});	 
	
	$("vslLimitFlagTab").observe("click", function() {
		checkChangesOnTab("vslLimitFlagTab","VESSEL_LIMIT_FLAG");		
	});	 

	$("editRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"), function(){
			changeTag = 1;
			objParameter.remarks = escapeHTML2($("textarea").value);
		});
	});
	
	$("txtRemarks").observe("change", function() {
		objParameter.remarks = escapeHTML2($F("txtRemarks"));
		if (objGIISS085.currRecord.paramValueV != objParameter.paramValueV||objGIISS085.currRecord.remarks != objParameter.remarks){
			changeTag = 1;
			changeTagFunc = saveGiiss085;
		}else{
			changeTag = 0;
			changeTagFunc = "";
		}
	});
	
	$("rdo1").observe("click", function() {			
		if(objParameter.paramName == "DATE_FORMAT"){
			objParameter.paramValueV = "MM-DD-RRRR";
		}else if(objParameter.paramName == "AUTOMATIC_PAR_ASSIGNMENT_FLAG"){
			objParameter.paramValueV = "Y";
		}else if(objParameter.paramName == "RETENTION_LIMIT_FLAG"){
			objParameter.paramValueV = "ALLOW";
		}else if(objParameter.paramName == "BLOCK_LIMIT_FLAG"){
			objParameter.paramValueV = "ALLOW";
		}else if(objParameter.paramName == "VESSEL_LIMIT_FLAG"){
			objParameter.paramValueV = "ALLOW";
		}
	
		if (objGIISS085.currRecord.paramValueV != objParameter.paramValueV||objGIISS085.currRecord.remarks != objParameter.remarks){
			changeTag = 1;
			changeTagFunc = saveGiiss085;
		}else{
			changeTag = 0;
			changeTagFunc = "";
		}
	});
	
	$("rdo2").observe("click", function() {		
		if(objParameter.paramName == "DATE_FORMAT"){
			objParameter.paramValueV = "MON DD, YYYY";
		}else if(objParameter.paramName == "AUTOMATIC_PAR_ASSIGNMENT_FLAG"){
			objParameter.paramValueV = "N";
		}else if(objParameter.paramName == "RETENTION_LIMIT_FLAG"){
			objParameter.paramValueV = "DON'T ALLOW";
		}else if(objParameter.paramName == "BLOCK_LIMIT_FLAG"){
			objParameter.paramValueV = "DON'T ALLOW";
		}else if(objParameter.paramName == "VESSEL_LIMIT_FLAG"){
			objParameter.paramValueV = "DON'T ALLOW";
		}
		
		if (objGIISS085.currRecord.paramValueV != objParameter.paramValueV||objGIISS085.currRecord.remarks != objParameter.remarks){
			changeTag = 1;
			changeTagFunc = saveGiiss085;
		}else{
			changeTag = 0;
			changeTagFunc = "";
		}
	});
	
	$("rdo3").observe("click", function() {		
		if(objParameter.paramName == "DATE_FORMAT"){
			objParameter.paramValueV = "YYYY-MM-DD";
		}else if(objParameter.paramName == "RETENTION_LIMIT_FLAG"){
			objParameter.paramValueV = "WARN";
		}else if(objParameter.paramName == "BLOCK_LIMIT_FLAG"){
			objParameter.paramValueV = "WARN";
		}else if(objParameter.paramName == "VESSEL_LIMIT_FLAG"){
			objParameter.paramValueV = "WARN";
		}
		
		if (objGIISS085.currRecord.paramValueV != objParameter.paramValueV||objGIISS085.currRecord.remarks != objParameter.remarks){
			changeTag = 1;
			changeTagFunc = saveGiiss085;
		}else{
			changeTag = 0;
			changeTagFunc = "";
		}
	});
	
	$("rdo4").observe("click", function() {
		if(objParameter.paramName == "DATE_FORMAT"){
			objParameter.paramValueV = "DD-MM-YYYY";
		}
		if (objGIISS085.currRecord.paramValueV != objParameter.paramValueV||objGIISS085.currRecord.remarks != objParameter.remarks){
			changeTag = 1;
			changeTagFunc = saveGiiss085;
		}else{
			changeTag = 0;
			changeTagFunc = "";
		}
	});
	
	observeReloadForm("reloadForm", showGiiss085);	
	observeSaveForm("btnSave", saveGiiss085);
	$("btnCancel").observe("click", cancelGiiss085);
	$("uwExit").stopObserving("click");
	$("uwExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	initializeGiiss085();
</script>