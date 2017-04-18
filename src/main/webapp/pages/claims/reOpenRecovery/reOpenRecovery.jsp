<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="reOpenRecoveryMainDiv" name="reOpenRecoveryMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
			<ul>
				<li id="reOpenRecoveryExit"><a>Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Re-open Recovery</label>
		</div>
	</div>
	<div class="sectionDiv" style="width: 920px; height: 515px; padding-bottom: 10px;">	<!-- Gzelle 09102015 SR3292 -->
		<div id="reOpenRecoveryDiv" style="padding: 10px 10px 10px 10px;">
			<div id="reOpenRecoveryTable" style="height: 300px;"></div>
		</div>
		<div class="sectionDiv" style="margin: 10px; width: 97.5%;">
			<table style="margin: 5px 5px 5px 5px; float: left;">
				<tr>
					<td class="rightAligned" style="width: 110px">Policy Number</td>
					<td class="leftAligned"><input type="text" id="txtPolNo" style="width: 350px;" readonly="readonly" tabindex="301"/></td>
					<td class="rightAligned" style="width: 110px">Loss Date</td>
					<td class="leftAligned"><input type="text" id="txtLossDate" style="width: 300px;" readonly="readonly" tabindex="304"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Assured</td>
					<td class="leftAligned"><input type="text" id="txtAssured" style="width: 350px;" readonly="readonly" tabindex="302"/></td>
					<td class="rightAligned" style="width: 130px">Claim File Date</td>
					<td class="leftAligned"><input type="text" id="txtClaimFileDate" style="width: 300px;" readonly="readonly" tabindex="305"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Loss Category</td>
					<td class="leftAligned"><input type="text" id="txtLossCategory" style="width: 350px;" readonly="readonly" tabindex="303"/></td>
				</tr>
			</table>
		</div>
		<div style="float: left; width: 100%; margin-top: 15px;" align="center">
			<input type="button" class="button" id="btnReOpen" value="Re-open" tabindex="401" style="width: 150px;"/>
			<input type="button" class="button" id="btnDetails" value="Details" tabindex="402" style="width: 150px;"/>
			<input type="button" class="button" id="btnRecoveryHistory" value="Recovery History" tabindex="403" style="width: 150px;"/>
		</div>
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	setModuleId("GICLS125");
	setDocumentTitle("Re-open Recovery");
	setDetails(null);
	
	var currY = null;
	var objCheckBoxArray=[];
	objParams = new Object();
	var selectedRow = new Object();
	x = 0;
	checkboxVal = "";
	group = [];
	disableButton("btnReOpen");
	
	var objBatchRecovery = new Object();
	showTableGrid();
	
	$("reOpenRecoveryExit").observe("click", function(){
		if(objCLMGlobal.callingForm == "GICLS002"){
			objCLMGlobal.callingForm = "GICLS125";
			showRecoveryInformation();
		} else if(objCLMGlobal.callingForm == "GICLS052"){
			objCLMGlobal.callingForm = "GICLS125";
			showRecoveryInformation();
		/*} else if(objCLMGlobal.callingForm == "GICLS125"){ start - commented out by Gzelle 09102015 SR3292
			$("recoveryInfoDiv").innerHTML = "";	
			$("lossRecoveryListingDiv").show();
			$("lossRecoveryMenu").show();	end*/
		}else{
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
			changeTag = 0;
			changeTagFunc = "";		
		}
	});
	
	function setDetails(rec){
		try{
			$("txtPolNo").value 		= rec == null ? "" : unescapeHTML2(rec.policyNo);
			$("txtLossDate").value		= rec == null ? "" : dateFormat(rec.lossDate, "mm-dd-yyyy");
			$("txtAssured").value		= rec == null ? "" : unescapeHTML2(rec.assdName);
			$("txtClaimFileDate").value	= rec == null ? "" : dateFormat(rec.clmFileDate, "mm-dd-yyyy");
			$("txtLossCategory").value	= rec == null ? "" : unescapeHTML2(rec.lossCatDesc);
			if (rec != null){
				objParams.recoveryId 	 =  rec.recoveryId;
				objParams.lawyerCd 		 = 	rec.lawyerCd;
				objParams.lawyerName 	 = 	rec.lawyerName;
				objParams.tpItemDesc 	 = 	rec.tpItemDesc;
				objParams.recoverableAmt = 	rec.recoverableAmt;
				objParams.recoveredAmt 	 =	rec.recoveredAmt;
				objParams.plateNo		 =	rec.plateNo;
				enableButton("btnDetails");
				enableButton("btnRecoveryHistory");
			} else {
				objParams = [];
				disableButton("btnDetails");
				disableButton("btnRecoveryHistory");
			}
			
		} catch(e){	
			showErrorMessage("setDetails", e);
		}
	}
	
	/* start -  modified by Gzelle 09182015 SR3292 */
	function checkRowOnSelect(){
		try{
			if($("mtgInput" + tbgReopenRecovery._mtgId + "_2," + currY).checked){
				tableCheckBox("Y",selectedRow);
			}else if (!$("mtgInput" + tbgReopenRecovery._mtgId + "_2," + currY).checked) {
				tableCheckBox("N",selectedRow);
			}
		}catch(e){
			showErrorMessage("checkRowOnSelect",e);
		}
	}
	/* end -  modified by Gzelle 09182015 SR3292 */
	
	function addToGroup(rec){
		var notExist = true;
		if(group.length == 0){
			group.push(rec);
			notExist = false;
		} else {
			for ( var i = 0; i < group.length; i++) {
				if(group[i] == rec){
					notExist = false;
					break;
				}
			}
		}
		if(notExist){
			group.push(rec);
		}
	}
	
	function removeToGroup(rec){
		for (var i = 0; i < group.length; i++) {
			if(group[i] == rec){
				group.splice(i, 1);
			}
		}
	}
	
	function tableCheckBox(ctr,rec){
		if(ctr=="Y"){
			addToGroup(rec);
			x = x+1;
			enableButton("btnReOpen");	/* start -  Gzelle 09182015 SR3292 */
		} else if(ctr=="N") {
			removeToGroup(rec);
			x = x-1;
			disableButton("btnReOpen");
		}
		$('mtgIC'+tbgReopenRecovery._mtgId+'_2,'+currY).removeClassName('modifiedCell');
		/*if(x <= 0){
			disableButton("btnReOpen");
		} else {
			enableButton("btnReOpen");
		} end -  Gzelle 09182015 SR3292*/
	}
	
	function showTableGrid(){
		var lineCd = objCLMGlobal.claimId == null ? nvl(objCLMGlobal.lineCd,"") : "";	//Gzelle 09172015 SR3292
			try {
				reOpenRecoveryTable = {
					url : contextPath+ "/GICLClaimsController?action=showReOpenRecovery&refresh=1&claimId="+nvl(objCLMGlobal.claimId,"")+"&moduleId=GICLS125&lineCd="+lineCd,//+objCLMGlobal.callingForm,	//linecd - Gzelle 09172015 SR3292 
					id: "reOpenRecovery",
					options : {
						hideColumnChildTitle : true,
						pager : {},
						onCellFocus : function(element, value, x, y, id) {
							setDetails(tbgReopenRecovery.geniisysRows[y]);
							selectedRow = tbgReopenRecovery.geniisysRows[y];
							currY = Number(y);
							//start Gzelle 09182015 SR3292 moved other codes - onClick
							checkRowOnSelect();
						},
						onRemoveRowFocus : function(element, value, x, y, id) {
							setDetails(null);
							tbgReopenRecovery.keys.releaseKeys();
						},
						onSort : function(){
							setDetails(null);
							tbgReopenRecovery.keys.releaseKeys();
							group = [];
						},
						toolbar : {
							elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
							onFilter : function(){
								tbgReopenRecovery.keys.releaseKeys();
								setDetails(null);
								group = [];
							},
							onRefresh : function(){
								tbgReopenRecovery.keys.releaseKeys();
								setDetails(null);
								group = [];
							}
						}
					},
					columnModel : [ 
						{
						    id: 'recordStatus',
						    width: '0',
						    visible: false
						},
						{
							id: 'divCtrId',
							width: '0',
							visible: false 
						},
						{
							id: 'grpSw',
		              		title : 'R?',
			              	width: '30px',
			              	sortable: false,
			              	editable: true,
			              	editor: new MyTableGrid.CellCheckbox({
			              		onClick : function(value, checked) {	//Gzelle 09182015 SR3292
									tableCheckBox(value,selectedRow);
								},
			              		getValueOf : function(value) {
									if (value) {
										return "Y";
									} else {
										return "N";
									}
								}
			              	})
						},
						{
							id : "recoveryNo",
							title : "Recovery Number",
							align : "left",
							titleAlign: "left",
							width : '250px',
							filterOption : true
						},
						{
							id : "claimNo",
							title : "Claim Number",
							align : "left",
							titleAlign: "left",
							width : '250px',
							filterOption : true
						},
						{
							id : "recoveryType",
							title : "Recovery Type",
							align : "left",
							titleAlign: "left",
							width : '180px',
							filterOption : true
						},
						{
							id : "status",
							title : "Status",
							align : "left",
							titleAlign: "left",
							width : '130px',
							filterOption : true,
						}
					],
					rows : JSON.parse('${reOpenRecovery}').rows || []
				};
				tbgReopenRecovery = new MyTableGrid(reOpenRecoveryTable);
				tbgReopenRecovery.pager = JSON.parse('${reOpenRecovery}');	//Gzelle 09102015 SR3292
				tbgReopenRecovery.render('reOpenRecoveryTable');
				tbgReopenRecovery.afterRender = function(){ 
					objBatchRecovery.table = tbgReopenRecovery.geniisysRows;
				};
			} catch (e) {
				showErrorMessage("reOpenRecovery.jsp", e);
			}
		}
	
	function showGICLS269RecoveryDetails() {
		try {
			overlayRecoveryDetails = Overlay.show(contextPath
					+ "/GICLLossRecoveryStatusController", {
				urlContent : true,
				urlParameters : {
					action : "showGICLS269RecoveryDetails",
					Ajax : "1",
					claimId : objCLMGlobal.claimId,
					recoveryId :  objParams.recoveryId,				
					lawyerCd : objParams.lawyerCd,
					lawyer : objParams.lawyerName,
					tpItemDesc : objParams.tpItemDesc,
					recoverableAmt : objParams.recoverableAmt,
					recoveredAmtR : objParams.recoveredAmt,
					plateNo : objParams.plateNo 
				},	
				title : "Recovery Details",
				height: 430,
				width: 800,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	} 

	function showGICLS269RecoveryHistory(){
		try {
			overlayRecoveryHistory = Overlay.show(contextPath
					+ "/GICLLossRecoveryStatusController", {
				urlContent : true,
				urlParameters : {
					action : "showGICLS269RecoveryHistory",
					Ajax : "1",
					recoveryId :  objParams.recoveryId
				},	
				title : "Recovery History",
				height: 310,
				width: 800,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	} 
	
	function reopenRecovery(claimId, recoveryId){
		try{
			new Ajax.Request(contextPath+"/GICLClaimsController",{
				parameters:{
					action:		"gicls125ReopenRecovery",
					claimId:	claimId, 
					recoveryId: recoveryId
				},
				evalScript: true,
				asynchronous: true,
				onCreate: showNotice("Re-opening recovery, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						setDetails(null);
						disableButton("btnReOpen");	//Gzelle 09182015 SR3292
					}
				}
			});
		}catch(e){
			showErrorMessage("reopenRecovery", e);
		}		
	}
	
	$("btnDetails").observe("click", showGICLS269RecoveryDetails);
	$("btnRecoveryHistory").observe("click", showGICLS269RecoveryHistory);
	
	$("btnReOpen").observe("click",function(){
		for ( var i = 0; i < group.length; i++) {
			reopenRecovery(group[i].claimId, group[i].recoveryId);
		}
		tbgReopenRecovery._refreshList();
	});
</script>

