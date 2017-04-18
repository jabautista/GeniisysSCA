<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>    
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<!-- <div id="packageBinderMenu">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnToolbarExit">Exit</a></li>
			</ul>
		</div>
	</div>
</div> -->
<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="packageBindersMainDiv">
	<form id="packageBindersForm" name="packageBindersForm">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="">Package Binders</label> 
				<span class="refreshers" style="margin-top: 0;">
				 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
				</span>
			</div>
		</div>
		<div id="packageBindersDetailsDiv1" name="packageBindersDetailsDiv1" class="sectionDiv" style="">
			<table style="margin: auto; margin-top: 10px; margin-bottom: 10px;" border="0">
				<tr>
					<td class="rightAligned" >Package Policy No. </td>
					<td class="leftAligned" >
						<input id="txtLineCd" class="required" type="text" title="Line Code" style="width: 30px;" maxlength="2"/>
						<input id="txtSublineCd" class="required" type="text" title="Subline Code" style="width: 60px;" maxlength="7"/>
						<input id="txtIssCd" class="required" type="text" title="Issue Code" style="width: 30px;" maxlength="2"/>
						<input id="txtIssueYy" class="required integerNoNegativeUnformattedNoComma" type="text" title="Issue Year" style="width: 30px; text-align: right;" maxlength="2"/>
						<input id="txtPolSeqNo" class="required integerNoNegativeUnformattedNoComma" type="text" title="Package Policy Sequence Number" style="width: 60px; text-align: right;" maxlength="7"/>
						<input id="txtRenewNo" class="required integerNoNegativeUnformattedNoComma" type="text" title="Renew Number" style="width: 25px; text-align: right;" maxlength="2"/>
					</td>
					<td>
						<img style="float: left; margin-bottom: 2px;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtDspPackPolNoIcon" name="txtDspPackPolNoIcon" alt="Go" />
					</td>	
					<td class="rightAligned" style="width: 100px;">Endt No. </td>
					<td class="leftAligned"	>
						<!-- <input style="width: 250px; text-align: right;" type="text" id="txtDspEndtNo" name="txtDspEndtNo" value="" readonly="readonly" /> -->
						<input id="txtEndtIssCd" class="" type="text" title="Endt. Issue Code" style="width: 30px;" maxlength="2"/>
						<input id="txtEndtYy" class="integerNoNegativeUnformattedNoComma" type="text" title="Endt. Year" style="width: 30px; text-align: right;" maxlength="2"/>
						<input id="txtEndtSeqNo" class="integerNoNegativeUnformattedNoComma" type="text" title="Endt. Sequence Number" style="width: 60px; text-align: right;" maxlength="7"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" >Assured Name </td>
					<td class="leftAligned" colspan="4">
						<input style="width: 583px;" type="text" id="txtDspAssdName" name="txtDspAssdName" value="" readonly="readonly" />
					</td>
				</tr>
			</table>
		</div>	
		<div id="packageBindersDetailsDiv2" name="packageBindersDetailsDiv2" class="sectionDiv" style="margin-top: 1px; padding-bottom: 10px;">
			<div id="packageBinderList"></div>
			<table style="margin: auto; margin-top: 5px;">
				<tr>
					<td class="rightAligned" >Policy No. </td>
					<td class="leftAligned" > <input style="width: 600px;" type="text" id="txtDspPolNo" name="txtDspPolNo" value="" readonly="readonly" /></td>
				</tr>
			</table>	
		</div>	
		<div class="buttonsDiv">
			<input type="button" id="btnGenPackageBinder"	name="btnGenPackageBinder" 	 class="button"	value="Generate Package Binder" />
			<input type="button" id="btnRevPackageBinder" 	name="btnRevPackageBinder" 	 class="button"	value="Reverse Package Binder" />
			<input type="button" id="btnPrintPackageBinder" name="btnPrintPackageBinder" class="button"	value="Print Package Binder" />			
		</div>
	</form>	
</div>
<script type="text/javascript">
try{
	hideToolbarButton("btnToolbarPrint");
	$("btnToolbarPrintSep").hide();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	objGIRIS053A = {};
	
	function getPackageBinderList(packPolicyId){
		try{
			new Ajax.Updater("packageBinderList", contextPath+"/GIRIFrpsRiController",{
				parameters: {
					action: "getPackageBinderList",
					packPolicyId: nvl(packPolicyId,"")
				},
				evalScripts: true,
				onCreate: showNotice("Loading, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						 
					}
				}	
			});
		}catch(e){
			showErrorMessage("getPackageBinderList", e);	
		}	
	}
	
	function setQueryFieldsToReadOnly(bool){
		try{
			$("txtLineCd").readOnly = bool;
			$("txtSublineCd").readOnly = bool;
			$("txtIssCd").readOnly = bool;
			$("txtIssueYy").readOnly = bool;
			$("txtPolSeqNo").readOnly = bool;
			$("txtRenewNo").readOnly = bool;
			$("txtEndtIssCd").readOnly = bool;
			$("txtEndtYy").readOnly = bool;
			$("txtEndtSeqNo").readOnly = bool;
		}catch(e){
			showErrorMessage("setQueryFieldsToReadOnly", e);
		}
	}	
	
	function showPackageBinderLOV() {
		LOV.show({	controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getPackageBindersLOV",
						moduleId : "GIRIS053A",
						lineCd: $F("txtLineCd"),
						sublineCd: $F("txtSublineCd"),
						issCd: $F("txtIssCd"),
						issueYy: $F("txtIssueYy"),
						polSeqNo: $F("txtPolSeqNo"),
						renewNo: $F("txtRenewNo"),
						endtIssCd: $F("txtEndtIssCd"),
						endtYy: $F("txtEndtYy"),
						endtSeqNo: $F("txtEndtSeqNo"),
						page : 1
					},
					title : "List of Package Binder",
					width : 584,
					height : 386,
					hideColumnChildTitle : true,
					filterVersion : "2",
					columnModel : [
							{
								id : 'lineCd sublineCd issCd issueYy polSeqNo renewNo',
								title : 'Package Policy No.',
								width : 230,
								children : [ {
									id : 'lineCd',
									title : 'Line Code',
									width : 30,
									filterOption : true
								}, {
									id : 'sublineCd',
									title : 'Subline Code',
									width : 55,
									filterOption : true
								}, {
									id : 'issCd',
									title : 'Issue Code',
									width : 30,
									filterOption : true
								}, {
									id : 'issueYy',
									title : 'Issue Year',
									type : 'number',
									align : 'right',
									width : 30,
									filterOption : true,
									filterOptionType : 'number',
									renderer : function(value) {
										return formatNumberDigits(value, 2);
									}
								}, {
									id : 'polSeqNo',
									title : 'Pol Sequence No.',
									type : 'number',
									align : 'right',
									width : 50,
									filterOption : true,
									filterOptionType : 'number',
									renderer : function(value) {
										return formatNumberDigits(value, 7);
									}
								}, {
									id : 'renewNo',
									title : 'Renew No.',
									type : 'number',
									align : 'right',
									width : 30,
									filterOption : true,
									filterOptionType : 'number',
									renderer : function(value) {
										return formatNumberDigits(value, 2);
									}
								} ]
							},
							{
								id : 'endtIssCd endtYy issCd',
								title : 'Endt No.',
								width : 117,
								children : [
										{
											id : 'endtIssCd',
											title : 'Endt Code',
											width : 30,
											filterOption : true
										},
										{
											id : 'endtYy',
											title : 'Endt Year',
											type : 'number',
											align : 'right',
											width : 30,
											filterOption : true,
											filterOptionType : 'number',
											renderer : function(value) {
												return (nvl(value, null) != null ? formatNumberDigits(
														value, 2)
														: null);
											}
										},
										{
											id : 'endtSeqNo',
											title : 'Endt Sequence No.',
											type : 'number',
											align : 'right',
											width : 60,
											filterOption : true,
											filterOptionType : 'number',
											renderer : function(value) {
												return (nvl(value, null) != null ? formatNumberDigits(
														value, 6)
														: null);
											}
										} ]
							}, {
								id : 'dspAssdName',
								title : 'Assured',
								width : 205,
								filterOption : true
							}, {
								id : 'packPolicyId',
								title : '',
								width : '0',
								visible : false
							} ],
					draggable : true,
					onSelect : function(row) {
						$("txtLineCd").value = row.lineCd;
						$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtIssCd").value = row.issCd;
						$("txtIssueYy").value = formatNumberDigits(row.issueYy, 2);
						$("txtPolSeqNo").value = formatNumberDigits(row.polSeqNo, 7);
						$("txtRenewNo").value = formatNumberDigits(row.renewNo, 2);
						$("txtEndtIssCd").value = nvl(row.endtIssCd, null) == null ? null : row.endtIssCd;
						$("txtEndtYy").value = nvl(row.endtIssCd, null) == null ? null : formatNumberDigits(row.issueYy, 2);
						$("txtEndtSeqNo").value = nvl(row.endtIssCd, null) == null ? null : formatNumberDigits(row.endtSeqNo, 7);
						$("txtDspAssdName").value = unescapeHTML2(row.dspAssdName);
						$("txtLineCd").focus();
						setQueryFieldsToReadOnly(true);
						disableSearch("txtDspPackPolNoIcon");
						enableToolbarButton("btnToolbarExecuteQuery");						
						objGIRIS053A.packPolicyId = row.packPolicyId;
						objGIRIS053A.lineCd = row.lineCd;
					},
					onCancel : function() {
						$("txtLineCd").focus();
					}
				});
	}
	
	//Observe LOV in Package Policy No.
	$("txtDspPackPolNoIcon").observe("click", function(){
		if($F("txtLineCd").trim() == ""){
			showWaitingMessageBox("Please enter Line Code first.", "I", function(){
				$("txtLineCd").focus();
			});
		} else {
			showPackageBinderLOV();
		}
	});
	
	//Observe Print package Binder button
	$("btnPrintPackageBinder").observe("click", function(){
		overlayPrintBinder = Overlay.show(contextPath+"/GIRIPackBinderHdrController", {
			urlContent: true,
			urlParameters: {
				action : "showPrintPackageBinder",
				packPolicyId : nvl(objGIRIS053A.packPolicyId,"")
			},
			title: "Package Binder",	
			id: "print_package_binder_view",
			width: 690,
			height: 480,
		    draggable: false,
		    closable: false
		});
	});
	
	//Save all reverse package binder
	function reversePackageBinder(){
		try{
			new Ajax.Request(contextPath+"/GIRIFrpsRiController",{
				method: "POST",
				parameters:{
					action: "reversePackageBinder",
					packageBinders: objGIRIS053A.selectedRowsForReverse.toString()
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Processing, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)) {
						if (response.responseText == "SUCCESS"){
							objGIRIS053A.selectedRowsForReverse = [];
							showMessageBox(objCommonMessage.SUCCESS, "S");
							objUW.packageBinderListTG.refresh();
						} 
					}else{
						showMessageBox(response.responseText, "E");
						ok = false;
					}
				}	 
			});	
		}catch(e){
			showErrorMessage("reversePackageBinder", e);	
		}	
	}
	
	function generatePackageBinder(){
		try{
			if (objUW.packageBinderListTG.rows.length > 0){
				var objParams = {};
				objParams.packLineCd = objGIRIS053A.lineCd;
				objParams.packPolicyId = objGIRIS053A.packPolicyId;
				
				new Ajax.Request(contextPath+"/GIRIFrpsRiController",{
					method: "POST",
					parameters:{
						action: "generatePackageBinder",
						parameters: JSON.stringify(objParams)
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: function(){
						showNotice("Processing, please wait...");
					},
					onComplete: function(response){
						hideNotice();
						if(checkErrorOnResponse(response)) {
							if (response.responseText == "SUCCESS"){
								showMessageBox(objCommonMessage.SUCCESS, "S");
								objUW.packageBinderListTG.refresh();
							} 
						}else{
							showMessageBox(response.responseText, "E");
							ok = false;
						}
					}	 
				});	
			}	
		}catch(e){
			showErrorMessage("generatePackageBinder", e);	
		}	
	}	
	
	//Observe Reverse Package Binder button
	$("btnRevPackageBinder").observe("click", function(){
		if(objGIRIS053A.selectedRowsForReverse.length == 0){
			showMessageBox("Please tag a record for reversal first.", "I");
		} else {
			reversePackageBinder();	
		}		
	});
	
	//Observe Generate Package Binder button
	$("btnGenPackageBinder").observe("click", function(){
		if (objGIRIS053A.selectedRowsForReverse.length != 0){
			showMessageBox("You cannot create package binders if you had already checked a record to be reversed.", "I");
			return false;
		} else if(objGIRIS053A.genSw == "Y"){
			showMessageBox("Package binders has already been generated.", "I");
		} else{
			generatePackageBinder();
		}	
	});
	
	getPackageBinderList(0);
	
	observeReloadForm("reloadForm", function() {showGeneratePackageBinders();});
	observeGoToModule("btnToolbarExit", function(){goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);});
	
	setDocumentTitle("Package Binders");
	window.scrollTo(0,0); 	
	hideNotice("");
	setModuleId("GIRIS053A");
	
	function clearFields(){
		try{
			$("txtLineCd").clear();
			$("txtSublineCd").clear();
			$("txtIssCd").clear();
			$("txtIssueYy").clear();
			$("txtPolSeqNo").clear();
			$("txtRenewNo").clear();
			$("txtEndtIssCd").clear();
			$("txtEndtYy").clear();
			$("txtEndtSeqNo").clear();
			$("txtDspAssdName").clear();
			$("txtDspPolNo").clear();			
			
			if($("txtLineCd").readOnly) {
				enableSearch("txtDspPackPolNoIcon");
				getPackageBinderList(0);	
			}
		}catch(e){
			showErrorMessage("clearFields", e);
		}
	}
	
	$("btnToolbarEnterQuery").observe("click", function(){
		clearFields();
		setQueryFieldsToReadOnly(false);
		disableToolbarButton("btnToolbarExecuteQuery");
		disableButton("btnGenPackageBinder");
		disableButton("btnRevPackageBinder");
		disableButton("btnPrintPackageBinder");
		$("txtLineCd").focus();
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		getPackageBinderList(objGIRIS053A.packPolicyId);
		disableToolbarButton("btnToolbarExecuteQuery");
		enableButton("btnGenPackageBinder");
		enableButton("btnRevPackageBinder");
		enableButton("btnPrintPackageBinder");
	});
	
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	
	$("txtSublineCd").observe("keyup", function(){
		$("txtSublineCd").value = $F("txtSublineCd").toUpperCase();
	});
	
	$("txtIssCd").observe("keyup", function(){
		$("txtIssCd").value = $F("txtIssCd").toUpperCase();
	});
	
	$("txtEndtIssCd").observe("keyup", function(){
		$("txtEndtIssCd").value = $F("txtEndtIssCd").toUpperCase();
	});
	
	disableButton("btnGenPackageBinder");
	disableButton("btnRevPackageBinder");
	disableButton("btnPrintPackageBinder");
	disableToolbarButton("btnToolbarExecuteQuery");
	$("txtLineCd").focus();
}catch(e){
	showErrorMessage("Generate Package Binders page", e);
}	
</script>