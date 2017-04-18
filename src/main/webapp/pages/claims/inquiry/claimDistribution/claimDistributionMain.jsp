<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<style>
.required {
	backgroundColor: '#FFFACD'
}
</style>
<div id="mainNavClaimDist">
	<div id="clmDistMainDiv" name="clmDistMainDiv">
		<jsp:include page="/pages/toolbar.jsp"></jsp:include>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Claim Distribution</label>
			</div>
		</div>
		<div id="clmDistDiv" align="center" class="sectionDiv">
			<div style="margin: 5px; margin-left: 10px; float: left;">
				<table border="0" align="center">
					<tr>
						<td class="rightAligned" style="width: 75px;">Claim No.</td>
						<td class="rightAligned">
							<div id="clmLineCdDiv" style="width: 47px; float: left;"
								class="withIconDiv required">
								<input type="text" id="txtNbtClmLineCd" name="txtNbtClmLineCd" ignoreDelKey="1" value="" style="width: 22px;" class="withIcon allCaps required" maxlength="2" tabindex="101"> 
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtClmLineCdIcon" name="txtNbtClmLineCdIcon" alt="Go" />
							</div>
							<div id="clmsSblineCdDiv" style="width: 89px; float: left;"
								class="withIconDiv">
								<input type="text" ignoreDelKey="1" id="txtNbtClmSublineCd" name="txtNbtClmSublineCd" value="" style="width: 64px;" class="withIcon allCaps" maxlength="7" tabindex="102">
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtClmSublineCdIcon" name="txtNbtClmSublineCdIcon" alt="Go" />
							</div>

							<div style="width: 47px; float: left;" class="withIconDiv">
								<input type="text" id="txtNbtClmIssCd" name="txtNbtClmIssCd" value="" style="width: 22px;" class="withIcon allCaps" ignoreDelKey="1" maxlength="2" tabindex="103"> <img
									style="float: right;"
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="txtNbtClmIssCdIcon" name="txtNbtClmIssCdIcon" alt="Go" />
							</div> <input type="text" id="txtNbtClmYy" name="txtNbtClmYy" ignoreDelKey="1" value=""
							style="width: 20px; float: left;"
							class="integerNoNegativeUnformattedNoComma" maxlength="2"
							tabindex="104"> <input type="text" id="txtNbtClmSeqNo"
							name="txtNbtClmSeqNo" value="" ignoreDelKey="1"
							style="width: 115px; float: left; margin-left: 4px;"
							class="integerNoNegativeUnformattedNoComma" maxlength="7"
							tabindex="105">
							<div class="withIconDiv" style="border: 0px; float: right;">
								<img style="margin-left: 3px; float: right;"
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="nbtSearchClmByClmIcon" name="nbtSearchClmByClmIcon"
									alt="Go" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 75px;">Policy No.</td>
						<td class="rightAligned">
							<div id="lineCdDiv" style="width: 47px; float: left;"
								class="withIconDiv required">
								<input type="text" id="txtNbtLineCd" name="txtNbtLineCd" ignoreDelKey="1"
									value="" style="width: 22px;" class="withIcon allCaps required"
									maxlength="2" tabindex="201"> <img
									style="float: right;"
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="txtNbtLineCdIcon" name="txtNbtLineCdIcon" alt="Go" />
							</div>
							<div id="sublineCdDiv" style="width: 89px; float: left;"
								class="withIconDiv">
								<input type="text" id="txtNbtSublineCd" name="txtNbtSublineCd" ignoreDelKey="1"
									value="" style="width: 64px;" class="withIcon allCaps"
									maxlength="7" tabindex="202"> <img
									style="float: right;"
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="txtNbtSublineCdIcon" name="txtNbtSublineCdIcon" alt="Go" />
							</div>

							<div style="width: 47px; float: left;" class="withIconDiv">
								<input type="text" id="txtNbtPolIssCd" name="txtNbtPolIssCd" ignoreDelKey="1"
									value="" style="width: 22px;" class="withIcon allCaps"
									maxlength="2" tabindex="203"> <img
									style="float: right;"
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="txtNbtPolIssCdIcon" name="txtNbtPolIssCdIcon" alt="Go" />
							</div> <input type="text" id="txtNbtIssueYy" name="txtNbtIssueYy" ignoreDelKey="1"
							value="" style="width: 20px; float: left;"
							class="integerNoNegativeUnformattedNoComma" maxlength="2"
							tabindex="204"> <input type="text" id="txtNbtPolSeqNo" ignoreDelKey="1"
							name="txtNbtPolSeqNo" value=""
							style="width: 71px; float: left; margin-left: 4px;"
							class="integerNoNegativeUnformattedNoComma" maxlength="7"
							tabindex="205"> <input type="text" id="txtNbtRenewNo" ignoreDelKey="1"
							name="txtNbtRenewNo" value=""
							style="width: 33px; float: left; margin-left: 4px;"
							class="integerNoNegativeUnformattedNoComma" maxlength="2"
							tabindex="206">
							<div class="withIconDiv" style="border: 0px; float: right;">
								<img style="margin-left: 3px; float: right;"
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="nbtSearchClmByPolIcon" name="nbtSearchClmByPolIcon"
									alt="Go" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Assured</td>
						<td class="rightAligned"><input
							style="float: left; width: 370px;" type="text"
							id="txtNbtAssuredName" name="txtNbtAssuredName"
							readonly="readonly" tabindex="307"></td>
					</tr>
				</table>
			</div>
			<div style="float: right; width: 350px; margin-right: 30px">
				<table border="0" align="center" style="margin: 8px;">
					<tr>
						<td class="rightAligned" style="width: 120px;">Loss Category</td>
						<td class="leftAligned" style="width: 230px;"><input
							id="txtLossCategory" style="width: 230px;" type="text" value=""
							readonly="readonly" /></td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 120px;">Loss Date</td>
						<td class="leftAligned" style="width: 230px;"><input
							id="txtLossDate" style="width: 230px;" type="text" value=""
							readonly="readonly" /></td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 120px;">Claim Status</td>
						<td class="leftAligned" style="width: 230px;"><input
							id="txtClmStatus" style="width: 230px;" type="text" value=""
							readonly="readonly" /></td>
					</tr>
				</table>
			</div>


			<div id="tabComponentsDiv2" class="tabComponents1" style="align: center;">
				<ul>
					<li class="tab1 selectedTab1" style="width: 17%"><a id="reserveDsTab" class="leftAligned" style="width:100%;">Reserve Distribution</a></li>
					<li class="tab1 " style="width: 21%"><a id="lossExpDsTab" class="leftAligned" style="width:100%;">Loss/Expense Distribution</a></li>
				</ul>
			</div>
			<div class="tabBorderBottom1"></div>

			<div id="tabPageContents" name="tabPageContents"
				style="width: 100%; float: left;">
				<div id="tabReserveDsContents" name="tabReserveDsContents"
					style="width: 100%; height: 540px; float: left;">
				</div>
				<div id="tabLossExpDsContents" name="tabLossExpDsContents"
					style="width: 100%; height: 540px; float: left;">
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$("txtNbtClmLineCd").focus();
$("tabLossExpDsContents").hide(); 
try{
	var select = 0;
	obj = new Object();
	obj.exec = false;
	function initializeGICLS255(){
		hideToolbarButton("btnToolbarPrint"); 	
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		initializeTabs();
		initializeAccordion();
		initializeAll();	
		showClaimItemInfoGICLS255();
	}

	function showClaimItemInfoGICLS255(){
		try{
			new Ajax.Request( contextPath+"/GICLClaimsController" , {
				method: "POST",
				parameters: {
					action: "getItemReserveInfo",
					claimId: nvl(objCLMGlobal.claimId,0)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function() {
					showLoading("tabReserveDsContents", "Loading, please wait...", "30px");
				},
				onComplete: function (response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						$("tabReserveDsContents").update(response.responseText);
					}else{
						showMessageBox(response.responseText, "E");
					}
				}
			});		
		}catch(e){
			showErrorMessage("showClaimItemInfoGICLS255", e);	
		}
	}	
	
	objCLMGlobal.claimId = 0;
	objCLMGlobal.clmResHistId = 0;
	function showLossExpInfoGICLS255(){
		try{
			new Ajax.Request( contextPath+"/GICLClaimsController" , {
				method: "POST",
				parameters: {
					action: "getClmLossExpInfo",
					claimId: objCLMGlobal.claimId,
					lineCd : objCLMGlobal.lineCd
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function() {
					showLoading("tabLossExpDsContents", "Loading, please wait...", "30px");
				},
				onComplete: function (response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						$("tabLossExpDsContents").update(response.responseText);
					}else{
						showMessageBox(response.responseText, "E");
					}
				}
			});		
		}catch(e){
			showErrorMessage("showLossExpInfoGICLS255", e);	
		}
	}		
	
	function resetFields(){
		$$("input[type='text']").each(function(x){
			x.clear();
		});
		objCLMGlobal.claimId = "";
		$("txtNbtClmLineCd").readOnly = false;
		$("txtNbtClmSublineCd").readOnly = false;
		$("txtNbtClmIssCd").readOnly = false;
		$("txtNbtClmYy").readOnly = false;
		$("txtNbtClmSeqNo").readOnly = false;
		$("txtNbtLineCd").readOnly = false;
		$("txtNbtSublineCd").readOnly = false;
		$("txtNbtPolIssCd").readOnly = false;
		$("txtNbtIssueYy").readOnly = false;
		$("txtNbtPolSeqNo").readOnly = false;
		$("txtNbtRenewNo").readOnly = false;
		$("txtNbtClmLineCd").focus();
	}

	function enable(){
		enableSearch("txtNbtClmLineCdIcon");
		enableSearch("txtNbtClmSublineCdIcon");
		enableSearch("txtNbtClmIssCdIcon");
		enableSearch("nbtSearchClmByClmIcon");
		enableSearch("txtNbtLineCdIcon");
		enableSearch("txtNbtSublineCdIcon");
		enableSearch("txtNbtPolIssCdIcon");
		enableSearch("nbtSearchClmByPolIcon");
	}
	
	function resetForm(){
		resetFields();
		enable();
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");	
		obj.exec = false;
		if($("tabReserveDsContents").visible()){
			showClaimItemInfoGICLS255();
		}else {
			showLossExpInfoGICLS255();
		}	
	}
	
	function checkWhenUserTypes(event){
		if(event.keyCode == 0 || event.keyCode == 8){
			enableToolbarButton('btnToolbarEnterQuery');
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	}
	
	//Observe Enter Query BUTTON
	$("btnToolbarEnterQuery").observe("click", resetForm);
	

	$("btnToolbarExecuteQuery").observe("click", function(){
		obj.exec = true;
		disableToolbarButton("btnToolbarExecuteQuery");
		fireEvent($("reserveDsTab"), "click");
		if($("tabReserveDsContents").visible()){
			showClaimItemInfoGICLS255();
		}else {
			showLossExpInfoGICLS255();
		}
	});
	
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	$("reserveDsTab").observe("click", function(){
		if(obj.exec){	
			if (select!=0){
				$("tabReserveDsContents").show();
				$("tabLossExpDsContents").hide(); 
				select = 0;
				showClaimItemInfoGICLS255();
			}
		}
	});
	
	$("lossExpDsTab").observe("click", function(){
		if(obj.exec){
			if(select!=1){
				$("tabLossExpDsContents").show();
				$("tabReserveDsContents").hide(); 
				select = 1;
				showLossExpInfoGICLS255();
			}
		}	
	});

	//Claim Line code/name LOV
	$("txtNbtClmLineCdIcon").observe("click", function() {
		showClaimLineCdLOV("GICLS255",$F("txtNbtClmLineCd"));
	});
	
	$("txtNbtClmLineCd").observe("change", function() {
		if ($F("txtNbtClmLineCd") != "") {
			showClaimLineCdLOV("GICLS255",$F("txtNbtClmLineCd"));
		}
	}); 
	
	//Claim Subline Cd LOV
	$("txtNbtClmSublineCd").observe("change", function(event){
		if(!$("txtNbtClmLineCd").readOnly){
			checkWhenUserTypes(event);
		} 
		if (trim($("txtNbtClmLineCd").value) == ""){
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtNbtClmLineCd");
			$("txtNbtClmSublineCd").value = '';
		}else {
			showClaimSublineCdLOV("GICLS255", $("txtNbtClmLineCd").value, $("txtNbtClmSublineCd").value);				
		}
	});
	
	$("txtNbtClmSublineCdIcon").observe("click", function() {
		if(trim($("txtNbtClmLineCd").value) == ""){
			$("txtNbtClmSublineCd").clear();
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtNbtClmLineCd");
			return false;
		}
		showClaimSublineCdLOV("GICLS255", $("txtNbtClmLineCd").value, $("txtNbtClmSublineCd").value);
	});
	
	//Claim Iss Cd LOV
	$("txtNbtClmIssCd").observe("change", function(event){
		if(!$("txtNbtClmIssCd").readOnly){
			checkWhenUserTypes(event);
		}
		if(trim($("txtNbtClmLineCd").value) == ""){
			$("txtNbtClmIssCd").clear();
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtNbtClmLineCd");
		} else {
			showClaimIssCdLOV("GICLS255",$F("txtNbtClmIssCd"), $("txtNbtClmLineCd").value);
		}	
	});
	
	$("txtNbtClmIssCdIcon").observe("click", function() {
		if(trim($("txtNbtClmLineCd").value) == ""){
			$("txtNbtClmLineCd").value = "";
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtNbtClmLineCd");
			return false;
		}
		showClaimIssCdLOV("GICLS255",$F("txtNbtClmIssCd"),$("txtNbtClmLineCd").value);
		//getClmIssCdNameLOV($F("txtNbtClmLineCd"), $("txtNbtClmIssCd").id, $F("txtNbtClmIssCd"));
	});
	

	//Policy Line code/name LOV
	$("txtNbtLineCd").observe("change", function(event){
		if(!$("txtNbtLineCd").readOnly){
			checkWhenUserTypes(event);
		}
		showPolicyLineCdLOV("GICLS255", $("txtNbtLineCd").value);
	});
	
	$("txtNbtLineCdIcon").observe("click", function() {
		//getClmLineCdLOV($F("txtNbtPolIssCd"),  $("txtNbtLineCd").id, $F("txtNbtLineCd"));
		showPolicyLineCdLOV("GICLS255", $("txtNbtLineCd").value);
	});
	
	//Policy Subline Cd LOV
	$("txtNbtSublineCd").observe("change", function(event){
		if(!$("txtNbtLineCd").readOnly){
			checkWhenUserTypes(event);
		}
		if (trim($("txtNbtLineCd").value) == ""){
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtNbtLineCd");
			$("txtNbtSublineCd").value = '';
		}else {
			showPolicySublineCdLOV($F("txtNbtLineCd"), $F("txtNbtSublineCd"),"GICLS255");			
		}
	});
	
	$("txtNbtSublineCdIcon").observe("click", function() {
		if(trim($("txtNbtLineCd").value) == ""){
			$("txtNbtSublineCd").value = '';
			 customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtNbtLineCd");	
			 return false;
		}
		showPolicySublineCdLOV($F("txtNbtLineCd"), $F("txtNbtSublineCd"),"GICLS255");
	});		
		
	
	//Policy Iss Cd LOV
	$("txtNbtPolIssCd").observe("change", function(event){
		if(!$("txtNbtLineCd").readOnly){
			checkWhenUserTypes(event);
		}
		if(trim($("txtNbtLineCd").value) == ""){
			$("txtNbtPolIssCd").value = "";
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtNbtLineCd");
		}else {
			showClmIssCdLOV2("GICLS250", $F("txtNbtLineCd"),$F("txtNbtSublineCd"));
		}			
	
	});
	
	$("txtNbtPolIssCdIcon").observe("click", function() {
		if(trim($("txtNbtLineCd").value) == ""){
			$("txtNbtPolIssCd").value = "";
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtNbtLineCd");	
			return false;
		}
		showClmIssCdLOV2("GICLS250", $F("txtNbtLineCd"),$F("txtNbtSublineCd"));
	});	
	
	//Search Claim ICON CLICK event
	$("nbtSearchClmByClmIcon").observe("click",function() {
		if(trim($("txtNbtClmLineCd").value) != ""){
			showClmListLOV(objCLMGlobal.moduleId);			
		}else customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO, "txtNbtClmLineCd");		
	});
	
	//Search Policy ICON CLICK event
	$("nbtSearchClmByPolIcon").observe("click",function() {
		if(trim($("txtNbtLineCd").value) != ""){
			showPolicyLOV("GICLS255", $("txtNbtLineCd").value, $("txtNbtSublineCd").value, $("txtNbtPolIssCd").value, $("txtNbtIssueYy").value, $("txtNbtPolSeqNo").value, $("txtNbtRenewNo").value);
		}else {
			customShowMessageBox(objCommonMessage.REQUIRED,imgMessage.INFO,"txtNbtLineCd");		
		}
	});
	
	function disablePolicyNoFields(bool){
		$("txtNbtLineCd").readOnly = bool;
		$("txtNbtSublineCd").readOnly = bool;
		$("txtNbtPolIssCd").readOnly = bool;
		$("txtNbtIssueYy").readOnly = bool;
		$("txtNbtPolSeqNo").readOnly = bool;
		$("txtNbtRenewNo").readOnly = bool;
		if(bool){
			disableSearch("txtNbtLineCdIcon");
			disableSearch("txtNbtSublineCdIcon");
			disableSearch("txtNbtPolIssCdIcon");
			disableSearch("nbtSearchClmByPolIcon");
		} else {
			enableSearch("txtNbtLineCdIcon");
			enableSearch("txtNbtSublineCdIcon");
			enableSearch("txtNbtPolIssCdIcon");
			enableSearch("nbtSearchClmByPolIcon");
		}
		
	}
	
	$("txtNbtClmYy").observe("change",function(){
		$("txtNbtClmYy").value = lpad(nvl($("txtNbtClmYy").value,""), 2, '0');
	});
	$("txtNbtIssueYy").observe("change",function(){
		$("txtNbtIssueYy").value = lpad(nvl($("txtNbtIssueYy").value,""), 2, '0');
	});
	$("txtNbtClmSeqNo").observe("change",function(){
		$("txtNbtClmSeqNo").value = lpad(nvl($("txtNbtClmSeqNo").value,""), 7, '0');
	});
	$("txtNbtPolSeqNo").observe("change",function(){
		$("txtNbtPolSeqNo").value = lpad(nvl($("txtNbtPolSeqNo").value,""), 7, '0');
	});
	$("txtNbtRenewNo").observe("change",function(){
		$("txtNbtRenewNo").value = lpad(nvl($("txtNbtRenewNo").value,""), 2, '0');
	});

	initializeGICLS255();
	
	$$("input[type='text']").each(function(a){
		$(a).observe("change",function(){
			if($(a).value != ""){
				enableToolbarButton("btnToolbarEnterQuery");
			}
		});
	});
	
}catch(e){
	showErrorMessage("Claim Distribution page.", e);
} 

</script>