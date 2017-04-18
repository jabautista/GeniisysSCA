<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control","no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Recovery Details</label>
		   		<span class="refreshers" style="margin-top: 0;">
		   			<label name="gro" style="margin-left: 5px;">Hide</label>
		   		</span>
		   	</div>
		</div>
		<div id="recoveryDistInfoSectionDiv" class="sectionDiv" style="height: 240px;">
			<div id="recoveryInfoGrid" style="height: 140px; margin: 10px; margin-bottom: 35px;"></div>
			<div class="buttonsDiv" align="center">
				<input type="button" id="btnDistribute" name="btnDistribute"  style="width: 115px;" class="button hover"   value="Distribute" />
				<input type="button" id="btnNegate" name="btnNegate"  style="width: 115px;" class="button hover"   value="Negate" />
			</div>				
		</div>
</div>
<script type="text/javascript">
	try{
		addStyleToInputs();
		initializeAll();
		initializeAllMoneyFields();
		
		objCLM.recoveryDistDtlsGrid = JSON.parse('${recoveryDistTG}');
		objCLM.recoveryDistDtlsCurrRow = null;	
		
		var tableModel = {
			url: contextPath+"/GICLClmRecoveryDistController?action=showClmRecoveryDistribution&refresh=1&claimId="+objCLMGlobal.claimId,
			//url: contextPath+"/GICLClmRecoveryDistController?action=showClmRecoveryDistribution&claimId="+objCLMGlobal.claimId,
			options:{
				hideColumnChildTitle: true,
				onCellFocus : function(element, value, x, y, id) {
					objCLM.recoveryDistDtlsCurrRow = recDistInfoTB.geniisysRows[y];
					objCLMGlobal.recoveryId  = objCLM.recoveryDistDtlsCurrRow.recoveryId;
					objCLMGlobal.recoveryPaytId = objCLM.recoveryDistDtlsCurrRow.recoveryPaytId;
					var xx= x;
					validateChanges(xx);
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					 if(changeTag == 1){
						 showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
									function(){
										objCLM.saveRecoveryDist();
										clearTableGridDetails(recDistTB); 
									    clearTableGridDetails(recRIDistTB);
									}, 
									function(){
										changeTag = 0;
										clearTableGridDetails(recDistTB); 
									    clearTableGridDetails(recRIDistTB);
									},
									function(){
										recDistInfoTB.unselectRows(objCLM.recoveryDistDtlsCurrRow.divCtrId);
										recDistInfoTB.selectRow(prevRow); 
									}
							);
	 				}else{ 
						objCLM.disableButtons();
						clearTableGridDetails(recDistTB);
						clearTableGridDetails(recRIDistTB);
						objCLM.populateRecovDist(null);
					 } 
				},
				onSort: function(){
					objCLM.disableButtons();
					clearTableGridDetails(recDistTB);
					clearTableGridDetails(recRIDistTB);
					objCLM.populateRecovDist(null);
				},
				beforeSort: function(){
					if(changeTag == 1){
						showMessageBox("Please save changes first.", "I");
						return false;
					}
				}
			},
			columnModel: [
				{	id: 'recordStatus',
				    title : '',
				    width: '0',
				    visible: false,
				    editor: "checkbox"
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{	id: 'claimId',
					width: '0',
					visible: false
				},
				{	id: 'recoveryId',
					width: '0',
					visible: false
				},
				{	id: 'distSw',
					width: '0',
					visible: false
				},
				{	id: 'statSw',
					width: '0',
					visible: false
				},	
				{	id: 'recoveryAcctId',
					width: '0',
					visible: false
				},
				{	id: 'nbtChk',
					width: '25',
					editor: 'checkbox',
					editable: true,
				  	sortable: false,
				  	defaultValue: false,
				  	hideSelectAllBox : true,
				  	altTitle: "Tag for Distribution"
				}, 
				{	id: 'dspLineCd dspIssCd dspRecYear dspRecSeqNo',
					width: '220px',
					title: 'Recovery Number',
					children: [
						{	id: 'dspLineCd',
							width: 35,
							title: 'Line Code'
						},
						{	id: 'dspIssCd',
							width: 45,
							title: 'Issue Code'
						},
						{	id: 'dspRecYear',
							width: 60,
							title: 'Recovery Year',
							type: "number",
							align: "right"
						},
						{	id: 'dspRecSeqNo',
							width: 70,
							title: 'Recovery Sequence Number',
							type: "number",
							align: "right"
						}
					]
				},
				{	id: 'dspRefNo',
					width: '155',
					title: 'Reference No.'
				},
				{
					id: 'payorClassCd payorCd dspPayorName',
					width: '295px',
					title: 'Payor',
					children: [
						{	id: 'payorClassCd',
							width: 55,
						  	title: 'Payor Class Cd',
						  	type: "number",
						  	align: "right"
						},
						{	id: 'payorCd',
							width: 65,
							title: 'Payor Cd',
							type: "number",
							align: "right"			
						},
						{	id: 'dspPayorName',
							width: 200,
							title: 'Payor Name'
						}
					]
				},
				{	id: 'recoveredAmt',
					width: '155',
					title: 'Recovery Amount',
					titleAlign: 'right',
					align: 'right',
					geniisysClass: 'money'
				}
			],
			rows: objCLM.recoveryDistDtlsGrid.rows || [],
			id: 10
		};
			recDistInfoTB = new MyTableGrid(tableModel);
			recDistInfoTB.pager = objCLM.recoveryDistDtlsGrid;
			recDistInfoTB.render('recoveryInfoGrid');
			
	}catch(e){
		showErrorMessage("Recovery Dist Info", e);
	}

	function tagUntagBtns(rowId){
		var check = false;
		var enable = false;
		var rows = recDistInfoTB.getModifiedRows();
		for(var i=0; i<rows.length; i++){
			if(rows[i].nbtChk == true){
				if (rows[i].divCtrId == rowId){
					check = true;
					enable = true;
				}else{
					check = false;
					//recDistInfoTB.setValueAt(false, recDistInfoTB.getColumnIndex('nbtChk'), rows[i].divCtrId); //benjo 08.27.2015 comment out
				}
			}	
		}
		
		if (enable == true){
			enableButton("btnDistribute");
		}else{
			disableButton("btnDistribute");
		}
	}
	
	function validateDist(){
		var rows = recDistInfoTB.getModifiedRows();
		for(var i=0; i<rows.length; i++){
			if(rows[i].nbtChk == true){
				if (rows[i].distSw == 'Y'){
					showMessageBox("Record cannot be updated; distribution has been made for this record.", imgMessage.INFO);
					recDistInfoTB.setValueAt(false, recDistInfoTB.getColumnIndex('nbtChk'), rows[i].divCtrId);
					enableButton("btnNegate");
					return;
				}else if (rows[i].statSw == 'N'){
					showMessageBox("Cannot perform distribution; payment receipt must be printed first.", imgMessage.INFO);
					recDistInfoTB.setValueAt(false, recDistInfoTB.getColumnIndex('nbtChk'), rows[i].divCtrId);
					return;
				}	
			}
		}

	}
	
	function validateChanges(xx){
		if (changeTag == 1){
			if(xx == recDistInfoTB.getColumnIndex('nbtChk')){
				//tick checkbox
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
						function(){
							recDistInfoTB.selectRow(objCLM.recoveryDistDtlsCurrRow.divCtrId);
							objCLM.saveRecoveryDist();
							validateDist();
							tagUntagBtns(objCLM.recoveryDistDtlsCurrRow.divCtrId);
							recDistTB.url = contextPath+"/GICLClmRecoveryDistController?action=getClmRecoveryDistGrid&recoveryId="+objCLM.recoveryDistDtlsCurrRow.recoveryId+"&recoveryPaytId="+objCLM.recoveryDistDtlsCurrRow.recoveryPaytId,
							recDistTB._refreshList(); 
							
						    clearTableGridDetails(recRIDistTB);
						}, 
						function(){
							changeTag = 0;
							validateDist();
							tagUntagBtns(objCLM.recoveryDistDtlsCurrRow.divCtrId);
						    recDistTB.url = contextPath+"/GICLClmRecoveryDistController?action=getClmRecoveryDistGrid&recoveryId="+objCLM.recoveryDistDtlsCurrRow.recoveryId+"&recoveryPaytId="+objCLM.recoveryDistDtlsCurrRow.recoveryPaytId,
							recDistTB._refreshList(); 
						    clearTableGridDetails(recRIDistTB);
						},
						function(){
							recDistInfoTB.setValueAt(false, recDistInfoTB.getColumnIndex('nbtChk'), objCLM.recoveryDistDtlsCurrRow.divCtrId);
							recDistInfoTB.unselectRows(objCLM.recoveryDistDtlsCurrRow.divCtrId);
							recDistInfoTB.selectRow(prevRow); 
						}
				);
			}else{
				//on select
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
						function(){
							recDistInfoTB.selectRow(objCLM.recoveryDistDtlsCurrRow.divCtrId); 
							objCLM.saveRecoveryDist();
							recDistTB.url = contextPath+"/GICLClmRecoveryDistController?action=getClmRecoveryDistGrid&recoveryId="+objCLM.recoveryDistDtlsCurrRow.recoveryId+"&recoveryPaytId="+objCLM.recoveryDistDtlsCurrRow.recoveryPaytId,
							recDistTB._refreshList(); 
						    clearTableGridDetails(recRIDistTB);
						}, 
						function(){
							changeTag = 0;
						    recDistTB.url = contextPath+"/GICLClmRecoveryDistController?action=getClmRecoveryDistGrid&recoveryId="+objCLM.recoveryDistDtlsCurrRow.recoveryId+"&recoveryPaytId="+objCLM.recoveryDistDtlsCurrRow.recoveryPaytId,
							recDistTB._refreshList(); 
						    clearTableGridDetails(recRIDistTB);
						},
						function(){
							recDistInfoTB.unselectRows(objCLM.recoveryDistDtlsCurrRow.divCtrId);
							recDistInfoTB.selectRow(prevRow); 
						}
				);
			}
		}else{ 
			recDistTB.url = contextPath+"/GICLClmRecoveryDistController?action=getClmRecoveryDistGrid&recoveryId="+objCLM.recoveryDistDtlsCurrRow.recoveryId+"&recoveryPaytId="+objCLM.recoveryDistDtlsCurrRow.recoveryPaytId,
			recDistTB._refreshList();	
			if (objCLM.recoveryDistDtlsCurrRow.distSw == 'Y'){
				enableButton("btnNegate");
			}else{
				disableButton("btnNegate");
			};
			if(xx == recDistInfoTB.getColumnIndex('nbtChk')){
				validateDist();
				tagUntagBtns(objCLM.recoveryDistDtlsCurrRow.divCtrId);
			}
			tagUntagBtns(objCLM.recoveryDistDtlsCurrRow.divCtrId);
			prevRow = objCLM.recoveryDistDtlsCurrRow.divCtrId;
		} 
	}
		
	function distRecovery(){
		try{
			new Ajax.Request(contextPath+"/GICLClmRecoveryDistController", {
				parameters:{
					action: "distributeRecovery",
					recoveryId: objCLMGlobal.recoveryId,
					recoveryPaytId: objCLMGlobal.recoveryPaytId,
					dspLineCd: objCLMGlobal.lineCd, 
					dspSublineCd: objCLMGlobal.sublineCd, 
					//dspIssCd: objCLMGlobal.polIssCd, //change by steven 12/07/2012 from: issCd    to: polIssCd
					dspIssCd: nvl(objCLMGlobal.polIssCd, objCLMGlobal.policyIssueCode), //marco - added nvl to handle null polIssCd
					dspIssueYy: objCLMGlobal.issueYy, 
					dspPolSeqNo: objCLMGlobal.polSeqNo,
					dspRenewNo: objCLMGlobal.renewNo,
					effDate: objCLMGlobal.strPolicyEffectivityDate2, 
					expiryDate: objCLMGlobal.strExpiryDate2,
					lossDate: objCLMGlobal.strLossDate2  
				},
				asynchronous: false,
				evalscripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						showMessageBox("Distibution Complete.", imgMessage.INFO);
						/*
						recDistTB.url = contextPath+"/GICLClmRecoveryDistController?action=getClmRecoveryDistGrid&recoveryId="+objCLMGlobal.recoveryId+"&recoveryPaytId="+objCLMGlobal.recoveryPaytId,
						recDistTB._refreshList(); 
						recDistInfoTB.setValueAt('Y', recDistInfoTB.getColumnIndex('distSw'), objCLM.recoveryDistDtlsCurrRow.divCtrId);
						recDistInfoTB.setValueAt(false, recDistInfoTB.getColumnIndex('nbtChk'), objCLM.recoveryDistDtlsCurrRow.divCtrId);
						disableButton("btnDistribute");
						enableButton("btnNegate");
						changeTag = 0;*/
						
						showRecoveryDistribution(); // irwin  8.22.2012
						
						if(document.getElementById("generateRecoveryAcctEnt") != null){
							enableMenu("generateRecoveryAcctEnt");
						}
					}	
				}
			});
		}catch (e){
			showErrorMessage("distRecovery", e);
		}
	}
	
	/**
	 * pol cruz
	 * 10.17.2013
	**/
	function getParameters(){
		var claimNo = $F("claimNo").split("-");
		var policyNo = $F("policyNo").split("-");
		
		objGICLS054Params = new Object();
		
		objGICLS054Params.recoveryId = objCLMGlobal.recoveryId;
		objGICLS054Params.recoveryPaytId =objCLMGlobal.recoveryPaytId;
		objGICLS054Params.lineCd = claimNo[0];
		objGICLS054Params.sublineCd = claimNo[1];
		objGICLS054Params.polIssCd = policyNo[2];
		objGICLS054Params.issueYy = policyNo[3];
		objGICLS054Params.polSeqNo = removeLeadingZero(policyNo[4]);
		objGICLS054Params.renewNo = removeLeadingZero(policyNo[5]);
		objGICLS054Params.polEffDate = objCLM.recoveryDistDtlsCurrRow.polEffDate;
		objGICLS054Params.expiryDate = objCLM.recoveryDistDtlsCurrRow.expiryDate;
		objGICLS054Params.lossDate = objCLM.recoveryDistDtlsCurrRow.lossDate;
	}
	
	/* pol cruz, 10.17.2013 */
	function distRecovery2(){
		try{
			getParameters();
			new Ajax.Request(contextPath+"/GICLClmRecoveryDistController", {
				parameters:{
					action: "distributeRecovery",
					recoveryId: objGICLS054Params.recoveryId,
					recoveryPaytId: objGICLS054Params.recoveryPaytId,
					dspLineCd: objGICLS054Params.lineCd, 
					dspSublineCd: objGICLS054Params.sublineCd, 
					//dspIssCd: objCLMGlobal.polIssCd, //change by steven 12/07/2012 from: issCd    to: polIssCd
					dspIssCd: nvl(objGICLS054Params.polIssCd, objCLMGlobal.policyIssueCode), //marco - added nvl to handle null polIssCd
					dspIssueYy: objGICLS054Params.issueYy, 
					dspPolSeqNo: objGICLS054Params.polSeqNo,
					dspRenewNo: objGICLS054Params.renewNo,
					effDate: objGICLS054Params.polEffDate, 
					expiryDate: objGICLS054Params.expiryDate,
					lossDate: objGICLS054Params.lossDate  
				},
				asynchronous: false,
				evalscripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						showMessageBox("Distibution Complete.", imgMessage.INFO);
						/*
						recDistTB.url = contextPath+"/GICLClmRecoveryDistController?action=getClmRecoveryDistGrid&recoveryId="+objCLMGlobal.recoveryId+"&recoveryPaytId="+objCLMGlobal.recoveryPaytId,
						recDistTB._refreshList(); 
						recDistInfoTB.setValueAt('Y', recDistInfoTB.getColumnIndex('distSw'), objCLM.recoveryDistDtlsCurrRow.divCtrId);
						recDistInfoTB.setValueAt(false, recDistInfoTB.getColumnIndex('nbtChk'), objCLM.recoveryDistDtlsCurrRow.divCtrId);
						disableButton("btnDistribute");
						enableButton("btnNegate");
						changeTag = 0;*/
						
						showRecoveryDistribution(); // irwin  8.22.2012
						
						if(document.getElementById("generateRecoveryAcctEnt") != null){
							enableMenu("generateRecoveryAcctEnt");
						}
					}	
				}
			});
		}catch (e){
			showErrorMessage("distRecovery2", e);
		}
	}
	
	/* benjo 08.27.2015 UCPBGEN-SR-19654 */
	function distRecovery3(rowId){
		var rows = recDistInfoTB.geniisysRows;
		var claimNo = $F("claimNo").split("-");
		var policyNo = $F("policyNo").split("-");
		
		for(var i=0; i<rows.length; i++){
			if(rows[i].divCtrId == rowId){
				try{
					new Ajax.Request(contextPath+"/GICLClmRecoveryDistController", {
						parameters:{
							action: "distributeRecovery",
							recoveryId: rows[i].recoveryId,
							recoveryPaytId: rows[i].recoveryPaytId,
							dspLineCd: claimNo[0], 
							dspSublineCd: claimNo[1],
							dspIssCd: nvl(policyNo[2], objCLMGlobal.policyIssueCode),
							dspIssueYy: policyNo[3], 
							dspPolSeqNo: removeLeadingZero(policyNo[4]),
							dspRenewNo: removeLeadingZero(policyNo[5]),
							effDate: rows[i].polEffDate, 
							expiryDate: rows[i].expiryDate,
							lossDate: rows[i].lossDate 
						},
						onComplete: function(response){
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								showMessageBox("Distibution Complete.", imgMessage.INFO);
								showRecoveryDistribution();
								if(document.getElementById("generateRecoveryAcctEnt") != null){
									enableMenu("generateRecoveryAcctEnt");
								}
							}	
						}
					});
				}catch (e){
					showErrorMessage("distRecovery3", e);
				}
			}
		}
	}
	
	function negateDist(){
		try{
			new Ajax.Request(contextPath+"/GICLClmRecoveryDistController", {
				parameters:{
					action: "negateDistRecovery",
					recoveryId: objCLMGlobal.recoveryId,
					recoveryPaytId: objCLMGlobal.recoveryPaytId,
				},
				asynchronous: false,
				evalscripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){		
						showMessageBox("Negation Complete", imgMessage.INFO);
						showRecoveryDistribution();
						changeTag = 0;
						if(document.getElementById("generateRecoveryAcctEnt") != null){
							disableMenu("generateRecoveryAcctEnt");
						}
					}	
				}
			});
		}catch (e){
			showErrorMessage("negateDist", e);
		}
	}
	
	function negateDistRecovery(){
		if(!nvl(objCLM.recoveryDistDtlsCurrRow.recoveryAcctId,"") == ""){
			showMessageBox("Recovery distribution can no longer be negated. Accounting entries for this record have already been generated.", imgMessage.INFO);
		}else{
			showConfirmBox("Confirmation", "Are you sure you want to negate this distribution?", "Yes", "No",
							function(){negateDist();}, "");
		}
	}
	
	function disableButtons() {
		disableButton("btnUpdate");
		disableButton("btnDelete");
		disableButton("btnDistribute");
		disableButton("btnNegate");
	}
	
	objCLM.disableButtons = disableButtons;
	objCLM.disableButtons();
	
	$("btnDistribute").observe("click", function(){
		//distRecovery2(); //benjo 08.27.2015 comment out
		
		/* benjo 08.27.2015 UCPBGEN-SR-19654 */
		var rows = recDistInfoTB.getModifiedRows();
		for(var i=0; i<rows.length; i++){
			if(rows[i].nbtChk == true){
				distRecovery3(rows[i].divCtrId);
			}
		}
		/* benjo end */
	});
	
	$("btnNegate").observe("click", function(){
		negateDistRecovery();
	});
</script>		