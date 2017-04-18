<div id="principalSignatoryMainDiv">
	<div id="principalSignatoryMenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="signatoryExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<input id="fromBond" value="${fromBond}" type="hidden"/>
	<input id="giiss022CallingForm" value="${callingForm}" type="hidden">
	<input id="userId" value="${userId}" name="${userId}" type="hidden"/>
	<input id="divToShow" value="${divToShow}" type="hidden"/>
<!-- added by steven 05.26.2014 -->
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Principal</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				<label id="signatoryReloadForm" name="signatoryReloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div id="principalDiv" class="sectionDiv" style="height: 370;">
		<div id="principalTableDiv" style= "padding: 10px;">
			<div id="principalTableGrid" style="height: 325px; width: 850px; padding-left: 110px;"></div>
			<div id="principalInfo" style="margin-top: 20px;">
				<table align="center">
					<tr>
						<td class="rightAligned">Principal</td>
						<td class="leftAligned" colspan="3">
							<input id="principalAssdNo" name="principalAssdNo" type="hidden"/>
			    			<input type="text" style="width: 523px;" readonly="readonly" id="principalAssdName" tabindex="101">
			    		</td>
		    		</tr>
		    		<tr>
						<td class="rightAligned">Control Type</td>
						<td class="leftAligned">
							<span style="width:65px; height: 21px; margin: 2px 4px 0 0; float: left;" class="lovSpan required">
								<input type="text" maxlength="5" lastvalidvalue="" style="width: 35px; float: left; margin-right: 4px; border: none; height: 13px;" id="selControlType" class="rightAligned required integerNoNegativeUnformatted" tabindex="102">	
								<img style="float: right;" alt="Go" id="searchControlType" src="/Geniisys/images/misc/searchIcon.png" tabindex="103">
							</span>
							<input type="text" readonly="readonly" style="height: 15px; width: 129px; float: left; text-align: left;" id="txtControlTypeName" tabindex="104">								
						</td>
						<td class="rightAligned">Number</td>
						<td class="leftAligned">
							<input type="text" style="width: 200px;" id="principalResNo" name="principalResNo" maxlength="15" tabindex="105"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Issued on</td>
						<td class="leftAligned">
							<div id="principalResDateDiv" class="withIconDiv" style="float: left; width: 206px; height:21px;">
								<input type="text" style="width: 181px;" readonly="readonly" class="withIcon" name="principalResDate" id="principalResDate" tabindex="106">
								<img alt="Date" src="/Geniisys/images/misc/but_calendar.gif" id="hrefPrincipalResDate" tabindex="107">
							</div>
						</td>
						<td class="rightAligned" style="padding-left: 47px">Issued at</td>
						<td class="leftAligned">
							<input type="text" style="width: 200px;" id="principalResPlace" name="principalResPlace" maxlength="15" class="allCaps" tabindex="108"/>
						</td>
					</tr>
				</table>
				<div align="center"><input type="button" id="btnAddPrin" name="btnAddPrin" value="Update" class="button" style="width: 80px; margin-top: 7px;" tabindex="109"/></div>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Principal Signatory</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	<div id="tableGridSectionDiv" class="sectionDiv" style="height: 370;">
		<div id="principalSignatoryTableGridDiv" style= "padding: 10px;">
			<div id="principalSignatoryTableGrid" style="height: 340px; width: 850px;"></div>
			<div id="principalSignatoryInfo" style="margin-top: 20px;">
				<table id="rdoTable" align="center" style="padding-left: 80px;">
					<tr>
						<td><div style="padding: 3px;"><input type="checkbox" id="chkBondSw" name="chkBondSw" tabindex="201"/></div></td>
						<td style="padding-right: 20px;"><label  for="chkBondSw">Bonds</label></td>
						
						<td><div style="padding: 3px;"><input type="checkbox" id="chkIndemSw" name="chkIndemSw" tabindex="202"/></div></td>
						<td style="padding-right: 20px;"><label  for="chkIndemSw">Indemnity</label></td>
						
						<td><div style="padding: 3px;"><input type="checkbox" id="chkAckSw" name="chkAckSw" tabindex="203"/></div></td>
						<td style="padding-right: 20px;"><label  for="chkAckSw">Acknowledgement</label></td>
					
						<td><div style="padding: 3px;"><input type="checkbox" id="chkCertSw" name="chkCertSw" tabindex="204"/></div></td>
						<td style="padding-right: 20px;"><label  for="chkCertSw">Certificate</label></td>
						
						<td><div style="padding: 3px;"><input type="checkbox" id="chkRiSw" name="chkRiSw" tabindex="205"/></div></td>
						<td><label  for="chkRiSw">RI Agreement</label></td>
					</tr>
				</table>
				<table align="center">
					<tr>
						<td class="rightAligned">Signatory ID</td>
						<td class="leftAligned"><input type="text" id="txtPrinId" name="txtPrinId" value="" readonly="readonly" style="width: 200px; text-align: right;" tabindex="206"/></td>
						
						<td class="rightAligned">Designation</td>
						<td class="leftAligned"><input type="text" id="txtDesignation" name ="txtDesignation" value="" style="width: 200px;" maxlength="30" class="required allCaps" tabindex="207"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Principal Signatory</td>
						<td class="leftAligned" colspan="3"><input type="text" id="txtPrinSign" name="txtPrinSign" value="" style="width: 538px;" maxlength="50" class="required allCaps" tabindex="208"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Control Type</td>
						<td class="leftAligned">
							<span style="width:60px; height: 21px; margin: 2px 4px 0 0; float: left;" class="lovSpan required">
								<input type="text" maxlength="5" lastvalidvalue="" style="width: 30px; float: left; margin-right: 4px; border: none; height: 13px;" id="selPrinControlType" class="rightAligned required integerNoNegativeUnformatted" tabindex="209">	
								<img style="float: right;" alt="Go" id="searchPrinControlType" src="/Geniisys/images/misc/searchIcon.png" tabindex="210">
							</span>
							<input type="text" readonly="readonly" style="height: 15px; width: 134px; float: left; text-align: left;" id="txtPrinControlTypeName" tabindex="211">
						</td>
						
						<td class="rightAligned">ID Number</td>
						<td class="leftAligned">
							<input type="text" id="txtCtcNo" name="txtCtcNo" value="" style="width: 200px;" maxlength="15" tabindex="212"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Issue Date</td>
						<td class="leftAligned">
							<div id="txtCtcDateDiv" class="withIconDiv" style="float: left; width: 206px; height:21px;">
								<input type="text" style="width: 181px;" readonly="readonly" class="withIcon" name="txtCtcDate" id="txtCtcDate" tabindex="213">
								<img alt="Date" src="/Geniisys/images/misc/but_calendar.gif" id="calCtcDate">
							</div>
						</td>
						
						<td class="rightAligned">Issue Place</td>
						<td class="leftAligned">
							<input type="text" id="txtCtcPlace" name ="txtCtcPlace" style="width: 200px;" maxlength="15" class="allCaps" tabindex="214"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Address</td>
						<td class="leftAligned" colspan="3">
							<input type="text" id="txtAddress" name ="txtAddress" style="width: 538px;" maxlength="150" tabindex="215"/>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td colspan="3" class="leftAligned">
							<div style="float: left; width: 544px; border: 1px solid gray; height: 22px;" name="remarksDiv" id="remarksDiv">
								<textarea onkeyup="limitText(this,4000);" maxlength="4000" name="txtRemarks" id="txtRemarks" style="float: left; height: 16px; width: 518px; margin-top: 0px; border: medium none; resize: none;" tabindex="216"></textarea>
								<img id="editRemarksText" alt="Edit" style="width: 14px; height: 14px; margin: 3px; float: right;" src="/Geniisys/images/misc/edit.png" tabindex="217">
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input type="text" readonly="readonly" style="width: 200px;" class="" id="txtUserId1" tabindex="218"></td>
						<td width="" style="padding-left: 47px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input type="text" readonly="readonly" style="width: 200px;" class="" id="txtLastUpdate1" tabindex="219"></td>
					</tr>
				</table>
				<div align="center"><input type="button" id="btnAddPSign" name="btnAddPSign" value="Add" class="button" style="width: 80px; margin-top: 7px;" tabindex="220"/></div>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Co-Signatory Information</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	<div id="tableGridSectionDivRes" class="sectionDiv" style="height: 370;">
		<div id="cosignorResTableGridDiv" style= "padding: 10px;">
			<div id="cosignorResTableGrid" style="height: 340px; width: 850px;"></div>
			<div id="coSignatoryInfo" style="margin-top: 20px;">
				<table align="center">
					<tr>
						<td class="rightAligned">Signatory ID</td>
						<td class="leftAligned"><input type="text" id="txtCoSignId" name="txtCoSignId" value="" readonly="readonly" style="width: 200px; text-align: right;" tabindex="301"></td>
						
						<td class="rightAligned">Designation</td>
						<td class="leftAligned"><input type="text" id="txtCoSignDesignation" name ="txtCoSignDesignation" value="" style="width: 200px;" maxlength="30" class="required allCaps" tabindex="302"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Co-Signatory </td>
						<td class="leftAligned" colspan="3" ><input type="text" id="txtCoSignor" name="txtCoSignor" value="" style="width: 538px;" maxlength="50" class="required allCaps" tabindex="303"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Control Type</td>
						<td class="leftAligned">
							<span style="width:60px; height: 21px; margin: 2px 4px 0 0; float: left;" class="lovSpan required">
								<input type="text" maxlength="5" lastvalidvalue="" style="width: 30px; float: left; margin-right: 4px; border: none; height: 13px;" id="selCoSignControlType" class="rightAligned required integerNoNegativeUnformatted" tabindex="304">	
								<img style="float: right;" alt="Go" id="searchCoSignControlType" src="/Geniisys/images/misc/searchIcon.png" tabindex="305">
							</span>
							<input type="text" readonly="readonly" style="height: 15px; width: 134px; float: left; text-align: left;" id="txtCoSignControlTypeName" tabindex="306">
						</td>
						
						<td class="rightAligned">ID Number</td>
						<td class="leftAligned"><input type="text" id="txtCoSignCtcNo" name="txtCoSignCtcNo" style="width: 200px;" maxlength="15" tabindex="307"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Issue Date</td>
						<td class="leftAligned">
							<div id="txtCoSignCtcDateDiv" class="withIconDiv" style="float: left; width: 206px; height:21px;">
								<input type="text" style="width: 181px;" readonly="readonly" class="withIcon" name="txtCoSignCtcDate" id="txtCoSignCtcDate" tabindex="308">
								<img alt="Date" src="/Geniisys/images/misc/but_calendar.gif" id="calCoSignCtcDate" tabindex="309">
							</div>
						</td>
						
						<td class="rightAligned">Issue Place</td>
						<td class="leftAligned"><input type="text" id="txtCoSignCtcPlace" name ="txtCoSignCtcPlace" style="width: 200px;" maxlength="15" class="allCaps" tabindex="310"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Address</td>
						<td class="leftAligned" colspan="3" ><input type="text" id="txtCoSignAddress" name ="txtCoSignAddress" style="width: 538px;" maxlength="150" tabindex="311"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td colspan="3" class="leftAligned">
							<div style="float: left; width: 544px; border: 1px solid gray; height: 22px;" name="remarksDiv2" id="remarksDiv2">
								<textarea onkeyup="limitText(this,4000);" maxlength="4000" name="txtCoSignRemarks" id="txtCoSignRemarks" style="float: left; height: 16px; width: 518px; margin-top: 0px; border: medium none; resize: none;" tabindex="312"></textarea>
								<img id="editCoSignRemarks" alt="Edit" style="width: 14px; height: 14px; margin: 3px; float: right;" src="/Geniisys/images/misc/edit.png" tabindex="313">
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input type="text" readonly="readonly" style="width: 200px;" class="" id="txtUserId2" tabindex="314"></td>
						<td width="" style="padding-left: 47px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input type="text" readonly="readonly" style="width: 200px;" class="" id="txtLastUpdate2" tabindex="315"></td>
					</tr>
				</table>
				<div align="center"><input type="button" id="btnAddCoSign" name="btnAddCoSign" value="Add" class="button" style="width: 80px; margin-top: 7px;" tabindex="316"/></div>
				
			</div>
		</div>
	</div>
	<div>
		<input type="hidden" id="hidControlTypeCd" />
	</div>
	<div class="buttonsDiv" style="float:left; width: 100%;">
		<input type="button" class="button" id="btnCancelSignatory" name="btnCancelSignatory" value="Cancel" tabindex="401"/>
		<input type="button" class="button" id="btnSaveSignatory" name="btnSaveSignatory" value="Save" tabindex="402"/>
	</div>
</div>

<script>
// 	$("principalAssdNo").value = "${assdNo}";
// 	$("principalAssdName").value = unescapeHTML2("${assdName}");  //unescapeHTML2 added by jeffdojello 04.30.2013 
// 	$("principalSignatoryMenuDiv").show();
	var assdNo = '${assdNo}';
	var callingForm = $("giiss022CallingForm").value; // added by: Nica 05.25.2012 - to indicate from which module it was called
	setDocumentTitle("Principal Signatory Maintenance");
	setModuleId("GIISS022");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	
	var principalSignatoryTableGrid;
	var cosignorResTableGrid;
	changeTag = 0;
	var changeTagPrincipal = 0;
	var changeTagPrincipalSign = 0;
	var changeTagCosign = 0;
	var defControlTypeDesc = null;
	var defControlTypeCode = null;
	var allPrinSign = {};
	var allCosign = {};
	var origPrinSignCtcNo = null;
	var origCoSignCtcNo = null;
	
	var origPrinSignControlTypeCd = null;
	var origCoSignControlTypeCd = null;
	
	var dummyPrinId = null;
	var dummyCosignId = null;
	var objGIISS022 = {};
	objGIISS022.exitPage = null;
	disableButton("btnAddPSign");
	disableButton("btnAddCoSign");
	var principalResDate = null;
	var signPrincipalDate = null;
	var coSignResDate = null;
	if($("quotationMenus") != null && callingForm == "GIIMM011"){ // called from Marketing Bond Policy data
		$("mainNav").hide();
	}else if($("parInfoMenu") != null && callingForm == "GIPIS017"){ // called from UW Bond Policy data
		$("parInfoMenu").hide();
		
	}
	function exitPrincipalSignatory(){
		if(callingForm == "GIIMM011"){ // called from Marketing Bond Policy data
			$("quotationMenus").show();
			$("mainNav").show();
			showBondPolicyData();
		}else if(callingForm == "GIPIS017"){ // called from UW Bond Policy data
			$("parInfoMenu").show();
			showBondPolicyDataPage();
		}else{ // called from UW Main
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
		}
	}
	
	function reloadPrincipalSignatory(){
		if(callingForm == "GIIMM011"){ // called from Marketing Bond Policy data
			showPrincipalSignatory("GIIMM011", assdNo, $("principalAssdName").value);
		}else if(callingForm == "GIPIS017"){ // called from UW Bond Policy data
			showPrincipalSignatory("GIPIS017", assdNo, $("principalAssdName").value);
		}else{
			showPrincipalSignatory("GIPIS000");
		}
	}
	
	observeReloadForm("signatoryReloadForm", reloadPrincipalSignatory);
	
 	$("btnSaveSignatory").observe("click", function() {
		if(changeTag == 0){
			showMessageBox("No changes to save.", imgMessage.INFO);
		}else{
			preSave();
		}	
	}); 
	function preSave(){
		    var setPrincipal = getAddedAndModifiedJSONObjects(principalTableGrid.geniisysRows);
			var setRowsPrincipal = getAddedAndModifiedJSONObjects(principalSignatoryTableGrid.geniisysRows);
			var setRowsCosignor = getAddedAndModifiedJSONObjects(cosignorResTableGrid.geniisysRows);
			
			var objParameters = new Object();
			objParameters.setPrincipal 	= setPrincipal;
			objParameters.setRowsPrincipal 	= setRowsPrincipal;
			objParameters.setRowsCosignor = setRowsCosignor;
			var strParameters = JSON.stringify(objParameters);
			savePrincipalSignatories(strParameters);
	}
	
	function savePrincipalSignatories(strParameters){
		new Ajax.Request(contextPath+"/GIISPrincipalSignatoryController",{
			parameters:{
				action: "savePrincipalSignatory",
				assdNo: $F("principalAssdNo"),
				principalResNo :$F("principalResNo"),
				principalResDate : $F("principalResDate"),
				principalResPlace: $F("principalResPlace"),
				controlTypeCd: $F("selControlType"), 
				strParameters: strParameters
			},onCreate: function(){
				showNotice("Saving, please wait...");
			},onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS022.exitPage != null) {
							principalTableGrid.keys.releaseKeys();
							principalSignatoryTableGrid.keys.releaseKeys();
							cosignorResTableGrid.keys.releaseKeys();
							objGIISS022.exitPage();
						} else {
							principalTableGrid._refreshList();
							principalTableGrid.keys.releaseKeys();
							principalSignatoryTableGrid.keys.releaseKeys();
							cosignorResTableGrid.keys.releaseKeys();
						}
					});
					changeTag = 0;
					changeTagPrincipal = 0;
					changeTagPrincipalSign = 0;
					changeTagCosign = 0;
				 	allPrinSign = {};
					allCosign = {};
				 	origPrinSignCtcNo = null;
					origCoSignCtcNo = null;
					origPrinSignControlTypeCd = null;
					origCoSignControlTypeCd = null;
					dummyPrinId = null;
					dummyCosignId = null;
					principalResDate = null;
					signPrincipalDate = null;
					coSignResDate = null;
				}
			}
		});
	}

// 	$("principalResNo").observe("change", function(){
// 		if(checkSignatoryCTCNo($F("principalResNo"),'','N')){
// 			$("principalResNo").value = '';
// 		}else if(checkCosignorCTCNo($F("principalResNo"),'', 'N')){
// 			$("principalResNo").value = '';
// 		}
// 	});
	
	function getAllRecord(mode) {
		try {
			var objReturn = {};
			new Ajax.Request(contextPath + "/GIISPrincipalSignatoryController", {
				parameters : {action : "showAllGiiss022",
							  assdNo : $F("principalAssdNo"),
							  mode : mode},
			    asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var obj = {};
						obj = JSON.parse((response.responseText).replace(/\\\\/g,'\\'));
						objReturn = obj.rows;
					}
				}
			});
			return objReturn;
		} catch (e) {
			showErrorMessage("getAllRecord",e);
		}
	}
	
//added by steven 05.26.2014 ***Principal Signatory	
	initPrincipalFields(null);
	initPrincipalSignFields(null);
	initCoSignFields(null);
	try{
		var selectedPrincipal = -1;
		var objGIISS022 = {};
		var objPrincipal = null;
		objGIISS022.principal = JSON.parse('${giiss022Principal}');
		var principalTableModel = {
			url: contextPath + "/GIISPrincipalSignatoryController?action=showPrincipalSignatory&refresh=1&assdNo="+assdNo,
			options: {
				title: '',
				querySort: true,
		      	height:'310px',
		      	width:'685px',
		      	beforeClick: function(){
					if(changeTagCosign == 1 || changeTagPrincipalSign == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveSignatory").focus();
						});
						return false;
					}
				},
		      	onCellFocus: function(element, value, x, y, id){
					var obj = principalTableGrid.geniisysRows[y];
					setPrincipalField(obj);
					selectedPrincipal = y;
					if( obj.controlTypeDesc == defControlTypeDesc){
						$("principalResDate").addClassName("required");
						$("principalResPlace").addClassName("required");
						$("principalResDateDiv").addClassName("required");
					} else {
						$("principalResDate").removeClassName("required");
						$("principalResPlace").removeClassName("required");
						$("principalResDateDiv").removeClassName("required");
					}
					principalTableGrid.keys.releaseKeys();
			  	},	
			  	onRemoveRowFocus : function(){
			  		setPrincipalField(null);
					selectedPrincipal = -1;
					principalTableGrid.keys.releaseKeys();
			  	},
			  	toolbar:{
			 		elements: [MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN],
			 		onFilter: function(){
						setPrincipalField(null);
						selectedPrincipal = -1;
						principalTableGrid.keys.releaseKeys();
					}
		  		},
			  	postPager : function(){
			  		setPrincipalField(null);
					selectedPrincipal = -1;
					principalTableGrid.keys.releaseKeys();
				},
				onSort: function () {
					setPrincipalField(null);
					selectedPrincipal = -1;
					principalTableGrid.keys.releaseKeys();
				},
				onRefresh: function(){
					setPrincipalField(null);
					selectedPrincipal = -1;
					principalTableGrid.keys.releaseKeys();
				},
				beforeSort : function(){
					if(changeTagPrincipal == 1 || changeTagCosign == 1 || changeTagPrincipalSign == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveSignatory").focus();
						});
						return false;
					}
				},
				prePager: function(){
					if(changeTagPrincipal == 1 || changeTagCosign == 1 || changeTagPrincipalSign == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveSignatory").focus();
						});
						return false;
					}
					setPrincipalField(null);
					selectedPrincipal = -1;
					principalTableGrid.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTagPrincipal == 1 || changeTagCosign == 1 || changeTagPrincipalSign == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTagPrincipal == 1 || changeTagCosign == 1 || changeTagPrincipalSign == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTagPrincipal == 1 || changeTagCosign == 1 || changeTagPrincipalSign == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTagPrincipal == 1 || changeTagCosign == 1 || changeTagPrincipalSign == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTagPrincipal == 1 || changeTagCosign == 1 || changeTagPrincipalSign == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTagPrincipal == 1 || changeTagCosign == 1 || changeTagPrincipalSign == 1 ? true : false);
				}
			},
			columnModel:[
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
		        {	id: 'divCtrId',
						width: '0px',
						visible: false						    
				},
				{	id: 'assdName',
					width: '350px',
					title: 'Principal',
					filterOption: true
				},
				{	id: 'controlTypeDesc',
					width: '150px',
					title: 'Control Type',
					filterOption: true
				},
				{	id: 'principalResNo',
					width: '150px',
					title: 'Number',
				    filterOption: true
				}
			],
			rows: objGIISS022.principal.rows
		};
		principalTableGrid = new MyTableGrid(principalTableModel);
		principalTableGrid.pager = objGIISS022.principal;	
		principalTableGrid.render('principalTableGrid');	
		principalTableGrid.afterRender = function(){
			for ( var i = 0; i < principalTableGrid.geniisysRows.length; i++) {
				defControlTypeCode = nvl(principalTableGrid.geniisysRows[i].defControlTypeCd, "");
				defControlTypeDesc = nvl(principalTableGrid.geniisysRows[i].defControlTypeDesc, "");
				break;
			}
		};
	}catch (e) {
		showErrorMessage("principal tbg", e);
	}
	
	function showControlTypeLOV(param){
		var filterText = null;
		if (param == 1) {
			filterText = ($("selControlType").readAttribute("lastValidValue").trim() != $F("selControlType").trim() ? $F("selControlType").trim() : "");
		} else if(param == 2) {
			filterText = ($("selPrinControlType").readAttribute("lastValidValue").trim() != $F("selPrinControlType").trim() ? $F("selPrinControlType").trim() : "");
		}else{
			filterText = ($("selCoSignControlType").readAttribute("lastValidValue").trim() != $F("selCoSignControlType").trim() ? $F("selCoSignControlType").trim() : "");
		}
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss022ControlTypeLOV",
							filterText : filterText,
							page : 1},
			title: "List of Control Types",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "controlTypeCd",
								title: "Code",
								width : '100px',
								align : 'right',
								titleAlign : 'right'
							}, {
								id : "controlTypeDesc",
								title : "Description",
								width : '385px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : filterText,
				onSelect: function(row) {
					if (param == 1) {
						$("selControlType").value = row.controlTypeCd;
						$("txtControlTypeName").value = unescapeHTML2(row.controlTypeDesc);
						$("selControlType").setAttribute("lastValidValue", (row.controlTypeCd));
						setPrincipalFieldProperty(row.controlTypeCd);
						if(row.controlTypeDesc == defControlTypeDesc){
							$("principalResDate").addClassName("required");
							$("principalResPlace").addClassName("required");
							$("principalResDateDiv").addClassName("required");
						} else {
							$("principalResDate").removeClassName("required");
							$("principalResPlace").removeClassName("required");
							$("principalResDateDiv").removeClassName("required");
						}
					} else if(param == 2) {
						$("selPrinControlType").value = row.controlTypeCd;
						$("txtPrinControlTypeName").value = unescapeHTML2(row.controlTypeDesc);
						$("selPrinControlType").setAttribute("lastValidValue", (row.controlTypeCd));
						setPrincipalSignFieldProperty(row.controlTypeCd);
						if(row.controlTypeDesc == defControlTypeDesc){
							$("txtCtcDate").addClassName("required");
							$("txtCtcPlace").addClassName("required");
							$("txtCtcDateDiv").addClassName("required");
						} else {
							$("txtCtcDate").removeClassName("required");
							$("txtCtcPlace").removeClassName("required");
							$("txtCtcDateDiv").removeClassName("required");
						}
					}else{
						$("selCoSignControlType").value = row.controlTypeCd;
						$("txtCoSignControlTypeName").value = unescapeHTML2(row.controlTypeDesc);
						$("selCoSignControlType").setAttribute("lastValidValue", (row.controlTypeCd));
						setCoSignFieldProperty(row.controlTypeCd);
						if(row.controlTypeDesc == defControlTypeDesc){
							$("txtCoSignCtcDate").addClassName("required");
							$("txtCoSignCtcPlace").addClassName("required");
							$("txtCoSignCtcDateDiv").addClassName("required");
						} else {
							$("txtCoSignCtcDate").removeClassName("required");
							$("txtCoSignCtcPlace").removeClassName("required");
							$("txtCoSignCtcDateDiv").removeClassName("required");
						}
					}
					
				},
				onCancel: function (){
					if (param == 1) {
						$("selControlType").value = $("selControlType").readAttribute("lastValidValue");
						setPrincipalFieldProperty($("selControlType").readAttribute("lastValidValue"));
					} else if(param == 2) {
						$("selPrinControlType").value = $("selPrinControlType").readAttribute("lastValidValue");
						setPrincipalSignFieldProperty($("selPrinControlType").readAttribute("lastValidValue"));
					}else{
						$("selCoSignControlType").value = $("selCoSignControlType").readAttribute("lastValidValue");
						setCoSignFieldProperty(row.controlTypeCd);
					}
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					if (param == 1) {
						$("selControlType").value = $("selControlType").readAttribute("lastValidValue");
						setPrincipalFieldProperty($("selControlType").readAttribute("lastValidValue"));
					} else if(param == 2) {
						$("selPrinControlType").value = $("selPrinControlType").readAttribute("lastValidValue");
						setPrincipalSignFieldProperty($("selPrinControlType").readAttribute("lastValidValue"));
					}else{
						$("selCoSignControlType").value = $("selCoSignControlType").readAttribute("lastValidValue");
						setCoSignFieldProperty(row.controlTypeCd);
					}
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function enableDisableCheckbox(param) {
		if (param == "enable") {
			$$("table#rdoTable  input[type='checkbox']").each(function(a) {
				$(a).enable();
			});
		} else {
			$$("table#rdoTable  input[type='checkbox']").each(function(a) {
				$(a).disable();
			});
		}
	}
	
	function initPrincipalFields(rec) {
		if (rec == null) {
			$("selControlType").readOnly = true;
			disableSearch("searchControlType");
			disableButton("btnAddPrin");
			setPrincipalFieldProperty("1");
			enableDisableCheckbox("disable");
		} else {
			$("selControlType").readOnly = false;
			enableSearch("searchControlType");
			enableButton("btnAddPrin");
			setPrincipalFieldProperty(rec.controlTypeCd);
			enableDisableCheckbox("enable");
		}
	}
	
	function setPrincipalFieldProperty(param) {
		if (param != "1") {
			$("principalResNo").readOnly = false;
			$("principalResPlace").readOnly = false;
			enableDate("hrefPrincipalResDate");
			$("principalResNo").addClassName("required");
			if (param == defControlTypeCode) {
				$("principalResDateDiv").addClassName("required");
				$("principalResDate").addClassName("required");
				$("principalResPlace").addClassName("required");
			}else{
				$("principalResDateDiv").removeClassName("required");
				$("principalResDate").removeClassName("required");
				$("principalResPlace").removeClassName("required");	
			}
		} else {
			$("principalResNo").readOnly = true;
			$("principalResPlace").readOnly = true;
			disableDate("hrefPrincipalResDate");
			$("principalResNo").removeClassName("required");
			$("principalResDateDiv").removeClassName("required");
			$("principalResDate").removeClassName("required");
			$("principalResPlace").removeClassName("required");
			$("principalResNo").clear();
			$("principalResPlace").clear();
			$("principalResDate").clear();
		}
	}
	
	function setPrincipalField(rec){
		try{
			$("principalAssdName").value = (rec == null ? "" : unescapeHTML2(rec.assdName));
			$("principalAssdNo").value = (rec == null ? "" : rec.assdNo);
			$("selControlType").value = (rec == null ? "" : rec.controlTypeCd);
			$("selControlType").setAttribute("lastValidValue", (rec == null ? "" : rec.controlTypeCd));
			$("txtControlTypeName").value = (rec == null ? "" : unescapeHTML2(rec.controlTypeDesc));
			$("principalResNo").value = (rec == null ? "" : unescapeHTML2(rec.principalResNo));
			$("principalResDate").value = (rec == null ? "" : rec.principalResDate);
			$("principalResPlace").value = (rec == null ? "" : unescapeHTML2(rec.principalResPlace));
			principalResDate = (rec == null ? "" : rec.principalResDate);
			
			rec == null ? disableButton("btnAddPSign") : enableButton("btnAddPSign");
			rec == null ? disableButton("btnAddCoSign") : enableButton("btnAddCoSign");
			if (rec == null) {
				showPrincipalSign(null);
			} else {
				showPrincipalSign(rec.assdNo);
				
				$("selPrinControlType").value = defControlTypeCode;
				$("selPrinControlType").setAttribute("lastValidValue", defControlTypeCode);
				$("txtPrinControlTypeName").value = defControlTypeDesc;
				
				$("selCoSignControlType").value = defControlTypeCode;
				$("selCoSignControlType").setAttribute("lastValidValue", defControlTypeCode);
				$("txtCoSignControlTypeName").value = defControlTypeDesc;
			}
			initPrincipalFields(rec);
			objPrincipal = rec;
		} catch(e){
			showErrorMessage("setPrincipalField", e);
		}
	}
	
	function setPrincipalRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.controlTypeCd = $F("selControlType");
			obj.controlTypeDesc = escapeHTML2($F("txtControlTypeName"));
			obj.principalResNo = escapeHTML2($F("principalResNo"));
			obj.principalResDate = $F("principalResDate");
			obj.principalResPlace = escapeHTML2($F("principalResPlace"));
			return obj;
		} catch(e){
			showErrorMessage("setPrincipalRec", e);
		}
	}
	
	function updateRec(){
		try {
			if(checkAllRequiredFieldsInDiv("principalInfo")){
				changeTagFunc = preSave;
				var dept = setPrincipalRec(objPrincipal);
				if (changeTagPrincipalSign == 1 || changeTagCosign == 1) {
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSaveSignatory").focus();
					});
					return;
				} else {
					principalTableGrid.updateVisibleRowOnly(dept, selectedPrincipal, false);
				}
				changeTag = 1;
				changeTagPrincipal = 1;
				setPrincipalField(null);
				principalTableGrid.keys.removeFocus(principalTableGrid.keys._nCurrentFocus, true);
				principalTableGrid.keys.releaseKeys();
			}
		} catch(e){
			showErrorMessage("updateRec", e);
		}
	}	
	
	function showPrincipalSign(assdNo) {
		if (assdNo != null) {
			principalSignatoryTableGrid.url = contextPath + "/GIISPrincipalSignatoryController?action=refreshPrincipalSignatory&assdNo="+assdNo;
			principalSignatoryTableGrid._refreshList();
			cosignorResTableGrid.url = contextPath + "/GIISPrincipalSignatoryController?action=refreshCosignRes&assdNo="+assdNo;
			cosignorResTableGrid._refreshList();
			initPrincipalSignFields(1);
			initCoSignFields(1);
			allPrinSign = getAllRecord("prinSign");
			allCosign = getAllRecord("coSign");
		} else {
			principalSignatoryTableGrid.url = contextPath + "/GIISPrincipalSignatoryController?action=refreshPrincipalSignatory";
			principalSignatoryTableGrid._refreshList();
			cosignorResTableGrid.url = contextPath + "/GIISPrincipalSignatoryController?action=refreshCosignRes";
			cosignorResTableGrid._refreshList();
			initPrincipalSignFields(null);
			initCoSignFields(null);
			$("selPrinControlType").clear();
			$("txtPrinControlTypeName").clear();
			$("selCoSignControlType").clear();
			$("txtCoSignControlTypeName").clear();
			allPrinSign = {};
			allCosign = {};
		}
	}
	
	$("btnAddPrin").observe("click",updateRec);
	$("searchControlType").observe("click",function(){
		showControlTypeLOV(1);
	});
	$("selControlType").observe("change", function() {
		if($F("selControlType").trim() == "") {
			$("selControlType").value = "";
			$("selControlType").setAttribute("lastValidValue", "");
			$("txtControlTypeName").value = "";
		} else {
			if($F("selControlType").trim() != "" && $F("selControlType") != $("selControlType").readAttribute("lastValidValue")) {
				showControlTypeLOV(1);
			}
		}
	});
	$("hrefPrincipalResDate").observe("click", function() {
		principalResDate = $F("principalResDate");
		scwShow($('principalResDate'),this, null);
	});
	$("principalResDate").observe("focus", function(){
		if (this.value != "") {
			if (compareDatesIgnoreTime(Date.parse(this.value),new Date()) == -1) {
				customShowMessageBox("Issue Date should not be later than Current Date.","I","principalResDate");
				this.value = principalResDate;
				return;
			}
		}
	});
	
//added by steven 05.26.2014 ***Principal Signatory	
	try{
		var selectedPrincipalSign = -1;
		var principalSignatoryObj = new Object();
		var objPrincipalSign = null;
		objGIISS022.principalSignatory = JSON.parse('${principalSignatoryObj}');
		
		var principalSignatoryTableModel = {
			url: contextPath + "/GIISPrincipalSignatoryController?action=getPrincipalSignatory&assdNo="+$F("principalAssdNo"),
			options: {
				title: '',
				querySort: true,
		      	height:'330px',
		      	width:'900px',
		      	onCellFocus: function(element, value, x, y, id){
					var obj = principalSignatoryTableGrid.geniisysRows[y];
					setPrincipalSignField(obj); 
					selectedPrincipalSign = y;
					principalSignatoryTableGrid.keys.releaseKeys();
					if(obj.controlTypeDesc == defControlTypeDesc){
						$("txtCtcDate").addClassName("required");
						$("txtCtcPlace").addClassName("required");
						$("txtCtcDateDiv").addClassName("required");
					} else {
						$("txtCtcDate").removeClassName("required");
						$("txtCtcPlace").removeClassName("required");
						$("txtCtcDateDiv").removeClassName("required");
					}
			  	},	
			  	onRemoveRowFocus : function(){
			  		selectedPrincipalSign = -1;
			  		principalSignatoryTableGrid.keys.releaseKeys();
			  		setPrincipalSignField(null); 
			  	},
			  	toolbar:{
			 		elements: [MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN],
			 		onFilter: function(){
						selectedPrincipalSign = -1;
						principalSignatoryTableGrid.keys.releaseKeys();
						setPrincipalSignField(null);
					}
		  		},
			  	postPager : function(){
			  		selectedPrincipalSign = -1;
			  		principalSignatoryTableGrid.keys.releaseKeys();
					setPrincipalSignField(null);
				},
				onSort: function () {
					selectedPrincipalSign = -1;
					principalSignatoryTableGrid.keys.releaseKeys();
					setPrincipalSignField(null);
				},
				onRefresh: function(){
					selectedPrincipalSign = -1;
		 			principalSignatoryTableGrid.keys.releaseKeys();
					setPrincipalSignField(null);
				},
				beforeSort : function(){
					if(changeTagPrincipalSign == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveSignatory").focus();
						});
						return false;
					}
				},
				prePager: function(){
					if(changeTagPrincipalSign == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveSignatory").focus();
						});
						return false;
					}
					selectedPrincipalSign = -1;
					setPrincipalSignField(null);
					principalSignatoryTableGrid.keys.removeFocus(principalSignatoryTableGrid.keys._nCurrentFocus, true);
					principalSignatoryTableGrid.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTagPrincipalSign == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTagPrincipalSign == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTagPrincipalSign == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTagPrincipalSign == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTagPrincipalSign == 1  ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTagPrincipalSign == 1 ? true : false);
				}
			},
			columnModel:[
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
		        {	id: 'divCtrId',
						width: '0px',
						visible: false						    
				},
				{
					id: 'bondSw',
					title: 'B',
					width: '19px',
					tooltip: 'Bond Switch',
					altTitle: 'Bond Switch',
					align: 'center',
					titleAlign: 'center',
					filterOption: true,
					filterOptionType: 'checkbox',
					editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				},
				{
					id: 'indemSw',
					title: 'I',
					width: '19px',
					tooltip: 'Indemnity Switch',
					altTitle: 'Indemnity Switch',
					align: 'center',
					titleAlign: 'center',
					filterOption: true,
					filterOptionType: 'checkbox',
					editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				},
				{
					id: 'ackSw',
					title: 'A',
					width: '19px',
					tooltip: 'Acknowledgement Switch',
					altTitle: 'Acknowledgement Switch',
					align: 'center',
					titleAlign: 'center',
					filterOption: true,
					filterOptionType: 'checkbox',
					editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				},
				{
					id: 'certSw',
					title: 'C',
					width: '19px',
					tooltip: 'Certificate Switch',
					altTitle: 'Certificate Switch',
					align: 'center',
					titleAlign: 'center',
					filterOption: true,
					filterOptionType: 'checkbox',
					editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				},
				{
					id: 'riSw',
					title: 'R',
					width: '19px',
					tooltip: 'RI Switch',
					altTitle: 'RI Switch',
					align: 'center',
					titleAlign: 'center',
					filterOption: true,
					filterOptionType: 'checkbox',
					editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				},
				{	id: 'prinId',
					titleAlign: 'right',
					width: '70px',
					title: 'Signatory ID',
					align: 'right',
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'prinSignor',
					width: '150px',
					title: 'Principal Signatory',
					filterOption: true
				},
				{	id: 'designation',
					width: '150px',
					title: 'Designation',
					filterOption: true
				},
				{	id: 'controlTypeDesc',
					width: '150px',
					title: 'Control Type',
					filterOption: true
				},
				{	id: 'resCert',
					width: '150px',
					title: 'ID Number',
				    filterOption: true
				},
				{	id: 'issueDate',
					titleAlign: 'center',
					width: '150px',
					title: 'Issue Date',
					align: 'center',
					filterOption: true,
					filterOptionType: 'formattedDate'
				},
				{	id: 'issuePlace',
					width: '150px',
					title: 'Issue Place',
					filterOption: true
				},
				{	id: 'address',
					width: '150px',
					title: 'Address',
					filterOption: true
				}
			],
			rows: objGIISS022.principalSignatory.rows
		};
		principalSignatoryTableGrid = new MyTableGrid(principalSignatoryTableModel);
		principalSignatoryTableGrid.pager = objGIISS022.principalSignatory;	
		principalSignatoryTableGrid.render('principalSignatoryTableGrid');	
		principalSignatoryTableGrid.afterRender = function(){
		};
	}catch (e) {
		showErrorMessage("principal signatory tbg", e);
	}
	
	function initPrincipalSignFields(rec) {
		if (rec == null) {
			$("txtDesignation").readOnly = true;
			$("txtPrinSign").readOnly = true;
			$("selPrinControlType").readOnly = true;
			$("txtCtcNo").readOnly = true;
			$("txtCtcPlace").readOnly = true;
			$("txtAddress").readOnly = true;
			$("txtRemarks").readOnly = true;
			disableSearch("searchPrinControlType");
			disableDate("calCtcDate");
			setPrincipalSignFieldProperty(1);
		} else {
			$("txtDesignation").readOnly = false;
			$("txtPrinSign").readOnly = false;
			$("selPrinControlType").readOnly = false;
			$("txtCtcNo").readOnly = false;
			$("txtCtcPlace").readOnly = false;
			$("txtAddress").readOnly = false;
			$("txtRemarks").readOnly = false;
			enableSearch("searchPrinControlType");
			enableDate("calCtcDate");
			setPrincipalSignFieldProperty(nvl(rec.controlTypeCd,defControlTypeCode));
		}
	}
	
	function setPrincipalSignFieldProperty(param) {
		if (param == 1) {
			$("txtCtcNo").readOnly = true;
			$("txtCtcPlace").readOnly = true;
			disableDate("calCtcDate");
			$("txtCtcNo").removeClassName("required");
			$("txtCtcDateDiv").removeClassName("required");
			$("txtCtcDate").removeClassName("required");
			$("txtCtcPlace").removeClassName("required");
			$("txtCtcNo").clear();
			$("txtCtcPlace").clear();
			$("txtCtcDate").clear();
		} else {
			$("txtCtcNo").readOnly = false;
			$("txtCtcPlace").readOnly = false;
			enableDate("calCtcDate");
			$("txtCtcNo").addClassName("required");
			if (param == defControlTypeCode) {
				$("txtCtcDateDiv").addClassName("required");
				$("txtCtcDate").addClassName("required");
				$("txtCtcPlace").addClassName("required");
			}else{
				$("txtCtcDateDiv").removeClassName("required");
				$("txtCtcDate").removeClassName("required");
				$("txtCtcPlace").removeClassName("required");
			}
		}
	}
	
	function setPrincipalSignField(rec){
		try{ 
			$("txtPrinId").value 		= (rec == null ? ""  : rec.prinId);
			$("txtPrinSign").value 		= (rec == null ? "" : unescapeHTML2(rec.prinSignor));
			$("txtCtcNo").value 		= (rec == null ? "" : unescapeHTML2(rec.resCert));
			$("txtCtcDate").value 		= (rec == null ? "" : unescapeHTML2(rec.issueDate));
			$("txtDesignation").value 	= (rec == null ? "" : unescapeHTML2(rec.designation));
			$("txtCtcPlace").value	 	= (rec == null ? "" : unescapeHTML2(rec.issuePlace));
			$("txtAddress").value 		= (rec == null ? "" : unescapeHTML2(rec.address));
			$("txtRemarks").value 		= (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("chkBondSw").checked 		= (rec == null ? false : rec.bondSw == "Y" ? true : false);
			$("chkIndemSw").checked 	= (rec == null ? false : rec.indemSw == "Y" ? true : false);
			$("chkAckSw").checked 		= (rec == null ? false : rec.ackSw == "Y" ? true : false);
			$("chkCertSw").checked 		= (rec == null ? false : rec.certSw == "Y" ? true : false);
			$("chkRiSw").checked 		= (rec == null ? false : rec.riSw == "Y" ? true : false);
			$("selPrinControlType").value 	= (rec == null ? "" : rec.controlTypeCd);
			$("selPrinControlType").setAttribute("lastValidValue", (rec == null ? "" : rec.controlTypeCd));
			$("txtPrinControlTypeName").value = (rec == null ? ""  : unescapeHTML2(rec.controlTypeDesc));
			$("txtUserId1").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate1").value = (rec == null ? "" : rec.lastUpdate);
			$("btnAddPSign").value 		= (rec == null ? "Add" : "Update");
			origPrinSignCtcNo  			= (rec == null ? "" : unescapeHTML2(rec.resCert));
			origPrinSignControlTypeCd 	= (rec == null ? "" : rec.controlTypeCd);
			dummyPrinId					= (rec == null ? genDummyPrinId() : rec.dummyPrinId);
			signPrincipalDate = (rec == null ? "" : rec.issueDate);
			
			if (rec == null) {
				if ($F("principalAssdNo").trim() != "") {
					setPrincipalSignFieldProperty(defControlTypeCode);
					$("selPrinControlType").value = defControlTypeCode;
					$("selPrinControlType").setAttribute("lastValidValue", defControlTypeCode);
					$("txtPrinControlTypeName").value = defControlTypeDesc;
				}
			} else {
				setPrincipalSignFieldProperty(nvl(rec.controlTypeCd,defControlTypeCode));
			}
			objPrincipalSign = rec;
		}catch(e){
			showErrorMessage("setPrincipalSignField", e);
		} 
	}
	
	function genDummyPrinId() {
		var dummy = 0;
		for ( var i = 0; i < allPrinSign.length; i++) {
			if (allPrinSign[i].dummyPrinId > dummy) {
				dummy = allPrinSign[i].dummyPrinId;
			}
		}
		return parseInt(dummy) + 1;
	}
	
	function setPrinSignatoryObj(rec){
		try{
			var obj = (rec == null ? {} : rec);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			obj.prinId  = ($F("txtPrinId"));
			obj.dummyPrinId = dummyPrinId;
			obj.prinSignor =  escapeHTML2($F("txtPrinSign"));
			obj.resCert = escapeHTML2($F("txtCtcNo"));
			obj.issueDate = escapeHTML2($F("txtCtcDate"));
			obj.designation = escapeHTML2($F("txtDesignation"));
			obj.issuePlace = escapeHTML2($F("txtCtcPlace"));
			obj.address = escapeHTML2($F("txtAddress"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			obj.controlTypeCd = $F("selPrinControlType");
			obj.controlTypeDesc = $F("txtPrinControlTypeName");
			obj.idNumber = obj.controlTypeDesc + (obj.resCert == "" ? "" : "-" + obj.resCert);
			obj.tbgBondSw = $("chkBondSw").checked;
			obj.tbgIndemSw = $("chkIndemSw").checked;
			obj.tbgAckSw = $("chkAckSw").checked;
			obj.tbgCertSw = $("chkCertSw").checked;
			obj.tbgRiSw = $("chkRiSw").checked;
			obj.bondSw = obj.tbgBondSw == true ? "Y" : "N";
			obj.indemSw = obj.tbgIndemSw == true ? "Y" : "N";
			obj.ackSw = obj.tbgAckSw == true ? "Y" : "N";
			obj.certSw = obj.tbgCertSw == true ? "Y" : "N";
			obj.riSw = obj.tbgRiSw == true ? "Y" : "N";
			
			return obj;
		}catch(e){
			showErrorMessage("setPrinSignatoryObj", e);
		}
	}
	
	function addPrinSignatory(){
		try{
		changeTagFunc = preSave;
		var dept = setPrinSignatoryObj(objPrincipalSign);
		var newObj = setPrinSignatoryObj(null);
		if($F("btnAddPSign") == "Add"){
			principalSignatoryTableGrid.addBottomRow(dept);
			newObj.recordStatus = 0;
			allPrinSign.push(newObj);
		} else {
			principalSignatoryTableGrid.updateVisibleRowOnly(dept, selectedPrincipalSign, false);
			for(var i = 0; i<allPrinSign.length; i++){
				if ((allPrinSign[i].dummyPrinId == newObj.dummyPrinId)&&(allPrinSign[i].recordStatus != -1)){
					newObj.recordStatus = 1;
					allPrinSign.splice(i, 1, newObj);
				}
			}
		}
		changeTag = 1;
		changeTagPrincipalSign = 1;
		setPrincipalSignField(null);
		principalSignatoryTableGrid.keys.removeFocus(principalSignatoryTableGrid.keys._nCurrentFocus, true);
		principalSignatoryTableGrid.keys.releaseKeys();
		}catch (e) {
			showErrorMessage("addPrinSignatory",e);
		}
	}
	
	function valAddUpdatePrinSign() {
		if(checkAllRequiredFieldsInDiv("principalSignatoryInfo")){
			for(var i=0; i<allCosign.length; i++){
				if(allCosign[i].recordStatus != -1 ){
					if($F("txtPrinSign") == unescapeHTML2(allCosign[i].cosignName)){
						showMessageBox("Cannot enter the same name for signor and co-signor.", "I");
						return;
					}
				}
			}
			for(var i=0; i<allPrinSign.length; i++){
				if(allPrinSign[i].recordStatus != -1 ){
					if ($F("btnAddPSign") == "Add") {
						if(unescapeHTML2(allPrinSign[i].resCert) == $F("txtCtcNo") && allPrinSign[i].controlTypeCd == $F("selPrinControlType") && $F("selPrinControlType") != "1"){
							showMessageBox("Record already exists with the same assd_no, control_type_cd and res_cert.", "E");
							return;
						}
					} else{
						if((origPrinSignControlTypeCd != $F("selPrinControlType") || origPrinSignCtcNo != $F("txtCtcNo")) && unescapeHTML2(allPrinSign[i].resCert) == $F("txtCtcNo") && allPrinSign[i].controlTypeCd == $F("selPrinControlType")  && $F("selPrinControlType") != "1"){
							showMessageBox("Record already exists with the same assd_no, control_type_cd and res_cert.", "E");
							return;
						}
					}
				} 
			}
			addPrinSignatory();
		}
	}
	
	$("editRemarksText").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("searchPrinControlType").observe("click",function(){
		showControlTypeLOV(2);
	});
	$("selPrinControlType").observe("change", function() {
		if($F("selPrinControlType").trim() == "") {
			$("selPrinControlType").value = "";
			$("selPrinControlType").setAttribute("lastValidValue", "");
			$("txtPrinControlTypeName").value = "";
		} else {
			if($F("selPrinControlType").trim() != "" && $F("selPrinControlType") != $("selPrinControlType").readAttribute("lastValidValue")) {
				showControlTypeLOV(2);
			}
		}
	});
	$("calCtcDate").observe("click", function() {
		signPrincipalDate = $F("txtCtcDate");
		scwShow($('txtCtcDate'),this, null);
	});
	$("txtCtcDate").observe("focus", function(){
		if (this.value != "") {
			if (compareDatesIgnoreTime(Date.parse(this.value),new Date()) == -1) {
				customShowMessageBox("Issue Date should not be later than Current Date.","I","txtCtcDate");
				this.value = signPrincipalDate;
				return;
			}
		}
	});
	$("btnAddPSign").observe("click", valAddUpdatePrinSign);

//added by steven 05.26.2014 ***Cosignatory	
	try{
		var selectedCosign = -1;
		var cosignorResObj = new Object();
		var objCoSign = null;
		objGIISS022.coSignatory = JSON.parse('${cosignorResObj}');
		var cosignorResTableModel = {
			url: contextPath + "/GIISPrincipalSignatoryController?action=getCosignorRes&assdNo="+$F("principalAssdNo"),
			options: {
				title: '',
				querySort: true,
		      	height:'330px',
		      	width:'900px',
		      	onCellFocus: function(element, value, x, y, id){
					var obj = cosignorResTableGrid.geniisysRows[y];
					selectedCosign = y;
					cosignorResTableGrid.keys.releaseKeys();
					setCoSignFields(obj);  
					if(obj.controlTypeDesc == defControlTypeDesc){
						$("txtCoSignCtcDate").addClassName("required");
						$("txtCoSignCtcPlace").addClassName("required");
						$("txtCoSignCtcDateDiv").addClassName("required");
					} else {
						$("txtCoSignCtcDate").removeClassName("required");
						$("txtCoSignCtcPlace").removeClassName("required");
						$("txtCoSignCtcDateDiv").removeClassName("required");
					}
			  	},	
			  	onRemoveRowFocus : function(){
			  		selectedCosign = -1;
			  		cosignorResTableGrid.keys.releaseKeys();
			  		setCoSignFields(null);
			  	},
			  	toolbar:{
			 		elements: [MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN],
			 		onFilter : function(){
			 			cosignorResTableGrid.keys.releaseKeys();
			 			setCoSignFields(null);
			 		}
		  		},
			  	postPager : function(){
			  		selectedCosign = -1;
			  		cosignorResTableGrid.keys.releaseKeys();
			  		setCoSignFields(null);
				},
				onSort: function () {
					selectedCosign = -1;
			  		cosignorResTableGrid.keys.releaseKeys();
			  		setCoSignFields(null);
				},
				onRefresh : function(){
		 			cosignorResTableGrid.keys.releaseKeys();
		 			setCoSignFields(null);
		 		},
		  		beforeSort : function(){
					if(changeTagCosign == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveSignatory").focus();
						});
						return false;
					}
				},
		  		prePager: function(){
					if(changeTagCosign == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveSignatory").focus();
						});
						return false;
					}
					selectedCosign = -1;
					setCoSignFields(null);
					cosignorResTableGrid.keys.removeFocus(cosignorResTableGrid.keys._nCurrentFocus, true);
					cosignorResTableGrid.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTagCosign == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTagCosign == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTagCosign == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTagCosign == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTagCosign == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTagCosign == 1 ? true : false);
				}
			},
			columnModel:[
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
		        {	id: 'divCtrId',
						width: '0px',
						visible: false						    
				},
				{	id: 'cosignId',
					titleAlign: 'right',
					width: '100px',
					title: 'Signatory ID',
					align: 'right',
					visible: true,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'cosignName',
					width: '200px',
					title: 'Co-Signatory',
					visible: true,
					filterOption: true,
					toUpperCase: true
					
				},
				{	id: 'designation',
					width: '150px',
					title: 'Designation',
					visible: true,
					filterOption: true
				},
				{	id: 'controlTypeDesc',
					titleAlign: 'left',
					width: '150px',
					title: 'Control Type',
					align: 'left',
					filterOption: true
				},
				{	id: 'cosignResNo',
					width: '150px',
					title: 'ID Number',
					filterOption: true,
					visible: true
				},
				{	id: 'cosignResDate',
					titleAlign: 'center',
					width: '150px',
					title: 'Issue Date',
					align: 'center',
					visible: true,
					filterOption: true,
					filterOptionType: 'formattedDate'
				},
				{	id: 'cosignResPlace',
					width: '150px',
					title: 'Issue Place',
					visible: true,
					filterOption: true
				},
				{	id: 'address',
					width: '150px',
					title: 'Address',
					visible: true,
					filterOption: true
				}
			],
			rows: objGIISS022.coSignatory.rows
		}; 
		cosignorResTableGrid = new MyTableGrid(cosignorResTableModel);
		cosignorResTableGrid.pager = objGIISS022.coSignatory;	
		cosignorResTableGrid.render('cosignorResTableGrid');
		cosignorResTableGrid.afterRender = function(){
		};
	}catch (e) {
		showErrorMessage("cosignatory tbg", e);
	}
	
	function initCoSignFields(rec) {
		if (rec == null) {
			$("txtCoSignDesignation").readOnly = true;
			$("txtCoSignor").readOnly = true;
			$("selCoSignControlType").readOnly = true;
			$("txtCoSignCtcNo").readOnly = true;
			$("txtCoSignCtcPlace").readOnly = true;
			$("txtCoSignAddress").readOnly = true;
			$("txtCoSignRemarks").readOnly = true;
			disableSearch("searchCoSignControlType");
			disableDate("calCoSignCtcDate");
			setCoSignFieldProperty(1);
		} else {
			$("txtCoSignDesignation").readOnly = false;
			$("txtCoSignor").readOnly = false;
			$("selCoSignControlType").readOnly = false;
			$("txtCoSignCtcNo").readOnly = false;
			$("txtCoSignCtcPlace").readOnly = false;
			$("txtCoSignAddress").readOnly = false;
			$("txtCoSignRemarks").readOnly = false;
			enableSearch("searchCoSignControlType");
			enableDate("calCoSignCtcDate");
			setCoSignFieldProperty(nvl(rec.controlTypeCd,defControlTypeCode));
		}
	}
	
	function setCoSignFieldProperty(param) {
		if (param == 1) {
			$("txtCoSignCtcNo").readOnly = true;
			$("txtCoSignCtcPlace").readOnly = true;
			disableDate("calCoSignCtcDate");
			$("txtCoSignCtcNo").removeClassName("required");
			$("txtCoSignCtcDateDiv").removeClassName("required");
			$("txtCoSignCtcDate").removeClassName("required");
			$("txtCoSignCtcPlace").removeClassName("required");
			$("txtCoSignCtcNo").clear();
			$("txtCoSignCtcPlace").clear();
			$("txtCoSignCtcDate").clear();
		} else {
			$("txtCoSignCtcNo").readOnly = false;
			$("txtCoSignCtcPlace").readOnly = false;
			enableDate("calCoSignCtcDate");
			$("txtCoSignCtcNo").addClassName("required");
			if (param == defControlTypeCode) {
				$("txtCoSignCtcDateDiv").addClassName("required");
				$("txtCoSignCtcDate").addClassName("required");
				$("txtCoSignCtcPlace").addClassName("required");
			}else{
				$("txtCoSignCtcDateDiv").removeClassName("required");
				$("txtCoSignCtcDate").removeClassName("required");
				$("txtCoSignCtcPlace").removeClassName("required");	
			}
		}
	}
	
	function setCoSignFields(rec){
		try{ 
			$("txtCoSignId").value	 		= (rec==null ? "" : (rec.cosignId));
			$("txtCoSignor").value 			= (rec==null ? "" : unescapeHTML2(rec.cosignName));
			$("txtCoSignCtcNo").value 		= (rec==null ? "" : unescapeHTML2(rec.cosignResNo));
			$("txtCoSignCtcDate").value 	= (rec==null ? "" : unescapeHTML2(rec.cosignResDate));
			$("txtCoSignDesignation").value = (rec==null ? "" : unescapeHTML2(rec.designation));
			$("txtCoSignCtcPlace").value 	= (rec==null ? "" : unescapeHTML2(rec.cosignResPlace));
			$("txtCoSignAddress").value 	= (rec==null ? "" : unescapeHTML2(rec.address));
			$("txtCoSignRemarks").value 	= (rec==null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId2").value 			= (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate2").value 		= (rec == null ? "" : rec.lastUpdate);
			$("btnAddCoSign").value 		= (rec == null ? "Add" : "Update");
			$("selCoSignControlType").value = (rec == null ? "" : rec.controlTypeCd);
			$("selCoSignControlType").setAttribute("lastValidValue", (rec == null ? "" : rec.controlTypeCd));
			$("txtCoSignControlTypeName").value = (rec == null ? ""  : unescapeHTML2(rec.controlTypeDesc));
			$("btnAddCoSign").value 		= (rec == null ? "Add" : "Update");
			origCoSignCtcNo  				= (rec == null ? "" : unescapeHTML2(rec.cosignResNo));
			origCoSignControlTypeCd			= (rec == null ? "" : rec.controlTypeCd);
			dummyCosignId  					= (rec == null ? genDummyCosignId() : rec.dummyCosignId);
			coSignResDate 					= (rec == null ? "" : rec.issueDate);
			if (rec == null) {
				if ($F("principalAssdNo").trim() != "") {
					setCoSignFieldProperty(defControlTypeCode);
					$("selCoSignControlType").value = defControlTypeCode;
					$("selCoSignControlType").setAttribute("lastValidValue", defControlTypeCode);
					$("txtCoSignControlTypeName").value = defControlTypeDesc;
				}
			} else {
				setCoSignFieldProperty(nvl(rec.controlTypeCd,defControlTypeCode));
			}
			recCoSign = rec;
		}catch(e){
			showErrorMessage("setCoSignFields", e);
		}
	}
	
	function genDummyCosignId() {
		var dummy = 0;
		for ( var i = 0; i < allCosign.length; i++) {
			if (allCosign[i].dummyCosignId > dummy) {
				dummy = allCosign[i].dummyCosignId;
			}
		}
		return parseInt(dummy) + 1;
	}
	
	function setCoSignObj(rec){
		try{
			var obj = (rec == null ? {} : rec);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			obj.cosignId = escapeHTML2($F("txtCoSignId"));
			obj.dummyCosignId = dummyCosignId;
			obj.cosignName = escapeHTML2($F("txtCoSignor"));
			obj.cosignResNo = escapeHTML2($F("txtCoSignCtcNo"));
			obj.cosignResDate = escapeHTML2($F("txtCoSignCtcDate"));
			obj.designation = escapeHTML2($F("txtCoSignDesignation"));
			obj.cosignResPlace = escapeHTML2($F("txtCoSignCtcPlace"));
			obj.address = escapeHTML2($F("txtCoSignAddress"));
			obj.remarks = escapeHTML2($F("txtCoSignRemarks"));
			obj.userId = userId;
			obj.controlTypeCd = $F("selCoSignControlType");
			obj.controlTypeDesc = $F("txtCoSignControlTypeName");
			obj.idNumber = obj.controlTypeDesc + (obj.cosignResNo == "" ? "" : "-" + obj.cosignResNo);
			return obj;
		}catch(e){
			showErrorMessage("setCoSignObj",e);
		}
	}
	
	function addCoSignatory(obj){
		changeTagFunc = preSave;
		var dept = setCoSignObj(objCoSign);
		var newObj = setCoSignObj(null);
		if($F("btnAddCoSign") == "Add"){
			cosignorResTableGrid.addBottomRow(dept);
			newObj.recordStatus = 0;
			allCosign.push(newObj);
		} else {
			cosignorResTableGrid.updateVisibleRowOnly(dept, selectedCosign, false);
			for(var i = 0; i<allCosign.length; i++){
				if ((allCosign[i].dummyCosignId == newObj.dummyCosignId)&&(allCosign[i].recordStatus != -1)){
					newObj.recordStatus = 1;
					allCosign.splice(i, 1, newObj);
				}
			}
		}
		changeTag = 1;
		changeTagCosign = 1;
		setCoSignFields(null);
		cosignorResTableGrid.keys.removeFocus(cosignorResTableGrid.keys._nCurrentFocus, true);
		cosignorResTableGrid.keys.releaseKeys();
	}
	
	function valAddUpdateCoSign() {
		if(checkAllRequiredFieldsInDiv("coSignatoryInfo")){
			for(var i=0; i<allPrinSign.length; i++){
				if(allPrinSign[i].recordStatus != -1 ){
					if($F("txtCoSignor") == unescapeHTML2(allPrinSign[i].prinSignor)){
						showMessageBox("Cannot enter the same name for signor and co-signor.", "I");
						return;
					}
				}
			}
			for(var i=0; i<allCosign.length; i++){
				if(allCosign[i].recordStatus != -1 ){
					if ($F("txtCoSignCtcNo") == "Add") {
						if(unescapeHTML2(allCosign[i].cosignResNo) == $F("txtCoSignCtcNo") && allCosign[i].controlTypeCd == $F("selCoSignControlType") && $F("selCoSignControlType") != "1"){
							showMessageBox("Record already exists with the same assd_no, control_type_cd and cosign_res_no.", "E");
							return;
						}
					} else{
						if((origCoSignControlTypeCd != $F("selCoSignControlType") || origCoSignCtcNo != $F("txtCoSignCtcNo")) && unescapeHTML2(allCosign[i].cosignResNo) == $F("txtCoSignCtcNo") && allCosign[i].controlTypeCd == $F("selCoSignControlType") && $F("selCoSignControlType") != "1"){
							showMessageBox("Record already exists with the same assd_no, control_type_cd and cosign_res_no.", "E");
							return;
						}
					}
				} 
			}
			addCoSignatory();
		}
	}
	
	$("calCoSignCtcDate").observe("click", function() {
		coSignResDate = $F("txtCoSignCtcDate");
		scwShow($('txtCoSignCtcDate'),this, null);
	});
	$("txtCoSignCtcDate").observe("focus", function(){
		if (this.value != "") {
			if (compareDatesIgnoreTime(Date.parse(this.value),new Date()) == -1) {
				customShowMessageBox("Issue Date should not be later than Current Date.","I","txtCoSignCtcDate");
				this.value = coSignResDate;
				return;
			}
		}
	});
	
	$("editCoSignRemarks").observe("click", function(){
		showOverlayEditor("txtCoSignRemarks", 4000, $("txtCoSignRemarks").hasAttribute("readonly"));
	});
	
	$("searchCoSignControlType").observe("click",function(){
		showControlTypeLOV(3);
	});
	$("selCoSignControlType").observe("change", function() {
		if($F("selCoSignControlType").trim() == "") {
			$("selCoSignControlType").value = "";
			$("selCoSignControlType").setAttribute("lastValidValue", "");
			$("txtCoSignControlTypeName").value = "";
		} else {
			if($F("selCoSignControlType").trim() != "" && $F("selCoSignControlType") != $("selCoSignControlType").readAttribute("lastValidValue")) {
				showControlTypeLOV(3);
			}
		}
	});
	$("btnAddCoSign").observe("click", valAddUpdateCoSign);
	
	function exitPage(){
		if(callingForm == "GIIMM011"){ // called from Marketing Bond Policy data
			$("mainNav").show();
			showBondPolicyData();
		}else if(callingForm == "GIPIS017"){ // called from UW Bond Policy data
			showBondPolicyDataPage();
			$("parInfoMenu").show();
		}else{
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
		}
	}
	function exitGiiss022() {
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS022.exitPage = exitPage;
						preSave();
					}, function(){
						exitPage();	
					}, "");
		} else {
			exitPage();	
		}
	}
	$("signatoryExit").observe("click", exitGiiss022);
	$("btnCancelSignatory").observe("click", exitGiiss022);
</script>