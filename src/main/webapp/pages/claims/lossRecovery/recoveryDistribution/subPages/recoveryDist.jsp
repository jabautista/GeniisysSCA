<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
  		<label>Recovery Distribution</label>
  		<span class="refreshers" style="margin-top: 0;">
  			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
	</div>
</div>
<div id="recoveryDistDtlsSectionDiv" class="sectionDiv">
	<div id="recoveryDistDtlsGrid" style="height: 140px; margin: 10px; margin-bottom: 50px;"></div>
	<div style="width: 100%;">
		<table border="0" style="margin-bottom: 10px;" align="center">
			<tr>
				<td class="rightAligned" >Treaty Name</td>
				<td class="leftAligned">
					<input type="text" id="txtTreatyName"  name="txtTreatyName" value="" style="width: 200px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Share Percentage</td>
				<td class="leftAligned">
					<input type="text" id="txtSharePct" name="txtSharePct" value="" style="width: 200px; text-align: right;" readonly="readonly">
				</td>
			</tr>	
			<tr>
				<td class="rightAligned" >Share Recovery Amount</td>
				<td class="leftAligned">
					<input type="text" id="txtShareRecovAmt" name="txtShareRecovAmt" value="" style="width: 200px; text-align: right;" readonly="readonly">
				</td>
			</tr>
		</table>
	</div>
	<div class="buttonsDiv" style="margin-bottom: 10px;" align="center" >
		<input type="button" id="btnUpdate" name="btnUpdate"  style="width: 115px;" class="button hover"   value="Update" />
		<input type="button" id="btnDelete" name="btnDelete"  style="width: 115px;" class="button hover"   value="Delete" />
	</div>
</div>

<script type="text/javascript">
	try{
		addStyleToInputs();
		initializeAll();
		initializeAllMoneyFields();
		
		objCLM.recoveryDistCurrRow = null;
		objCLM.recoveryDistNetRetRow = {};
		
		var recDistSelectedIndex;
		
		/* function adjustRiShares(){
			if(objCLM.recoveryDistCurrRow.shareType != 1) {	
				
				for(var count = 0; count < objGICLS054RiDist.length; count ++){
					var row = objGICLS054RiDist[count];
					row.shareRiPct = shrPct * row.shareRiPctReal / 100;
					row.shrRiRecoveryAmt = shrRecoveryAmt * row.shareRiPctReal / 100;
					row.recordStatus = 1;
					recRIDistTB.updateVisibleRowOnly(row, count);
				}
			}
		} */
		
		function adjustRiShares(){
			if(objCLM.recoveryDistCurrRow.shareType != 1) {					
				for(var count = 0; count < objGICLS054RiDist.length; count ++){
					var row = objGICLS054RiDist[count];
					row.shareRiPct = parseFloat(objCLM.recoveryDistCurrRow.sharePct) * parseFloat(row.shareRiPctReal) / 100;
					row.shrRiRecoveryAmt = parseFloat(objCLM.recoveryDistCurrRow.shrRecoveryAmt) * parseFloat(row.shareRiPctReal) / 100;
					recRIDistTB.updateVisibleRowOnly(row, count);
				}
			}
		}
			
		var tableModel = {
			options:{
				hideColumnChildTitle: true,
				onCellFocus : function(element, value, x, y, id) {
					objCLM.recoveryDistCurrRow = recDistTB.geniisysRows[y];
					recDistSelectedIndex = y;
					/* if (objCLM.recoveryDistCurrRow.shareType == 1){
						$("txtSharePct").readOnly = true;
						disableButton("btnUpdate");
						disableButton("btnDelete");
					}else{
						$("txtSharePct").readOnly = false; 
						enableButton("btnDelete");
					} */
					
					var totalRec = $("mtgPagerMsg20").childElements()[0].innerHTML;
					
					//if(parseInt(totalRec) > 1)
					
					if(parseInt(totalRec) > 1){
						$("txtSharePct").readOnly = false;
						//enableButton("btnUpdate");
						enableButton("btnDelete");
					} else {
						$("txtSharePct").readOnly = true;
						disableButton("btnUpdate");
						disableButton("btnDelete");
					}
					
					getNetRetRow();
					objCLM.populateRecovDist(objCLM.recoveryDistCurrRow);
				    recRIDistTB.url = contextPath+"/GICLClmRecoveryDistController?action=getClmRecoveryRIDistGrid&recoveryId="+objCLM.recoveryDistCurrRow.recoveryId+
						  "&recoveryPaytId="+objCLM.recoveryDistCurrRow.recoveryPaytId+"&recDistNo="+objCLM.recoveryDistCurrRow.recDistNo+"&grpSeqNo="+objCLM.recoveryDistCurrRow.grpSeqNo,
				    recRIDistTB._refreshList();
				    
					if(changeTag == 1)
						adjustRiShares();
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					objCLM.populateRecovDist(null);
					clearTableGridDetails(recRIDistTB);
					disableButton("btnUpdate");
					disableButton("btnDelete");
					recDistSelectedIndex = -1;
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
				{	id: 'recoveryId',
					width: '0',
					visible: false
				},
				{	id: 'recoveryPaytId',
					width: '0',
					visible: false
				},
				{	id: 'recDistNo',
					width: '0',
					visible: false
				},
				{	id: 'grpSeqNo',
					width: '0',
					visible: false
				},
				{	id: 'shareType',
					width: '0',
					visible: false
				},
				{	id: 'dspShareName',
					width: '350',
					title: 'Treaty Name'
				},
				{	id: 'sharePct',
					width: '160',
					title: 'Share Percentage',
					titleAlign: 'right',
					geniisysClass: 'money',
					align: 'right'	
					
				},
				{	id: 'distYear',
					width: '130',
					title: 'Distribution Year',
					titleAlign: 'right',
					type: "number",
					align: "right"					
				},
				{	id: 'shrRecoveryAmt',
					title: 'Share Recovery Amount',
					titleAlign: 'right',
					width: '230',
					geniisysClass: 'money',
					align: 'right'				
				}
			],
			
			rows: [],
			id: 20
		};
			recDistTB = new MyTableGrid(tableModel);
			recDistTB.pager = {};
			recDistTB.render('recoveryDistDtlsGrid');
			recDistTB.afterRender = function(){
				if(recDistTB.geniisysRows.length > 1){
					objCLM.populateRecovDist(null);
					clearTableGridDetails(recRIDistTB);
					disableButton("btnUpdate");
					disableButton("btnDelete");	
					recDistSelectedIndex = -1;
				}
			};
		
	}catch(e){
		showErrorMessage("Recovery Dist", e);
	}
	
	function getNetRetRow(){
		rows = recDistTB.geniisysRows;

		for(var i=0; i<rows.length; i++){
			if(rows[i].shareType == 1){
				objCLM.recoveryDistNetRetRow = rows[i];
			}
		} 
	}
	
	function updateShrPctShrRecAmt(){
		try{
			var shrPct = unformatNumber($F("txtSharePct"));
			var shrRecoveryAmt = unformatNumber($F("txtShareRecovAmt"));
			var netRetShrPct = 100 - parseFloat(shrPct);
			var netRetShrRecAmt = objCLM.recoveryDistDtlsCurrRow.recoveredAmt - shrRecoveryAmt;
			
			var sharePercentageDiff = parseFloat(objCLM.recoveryDistCurrRow.sharePct) - parseFloat(shrPct);
			var shareRecovertAmtDiff = parseFloat(objCLM.recoveryDistCurrRow.shrRecoveryAmt) - parseFloat(shrRecoveryAmt);
			
			/* objCLM.recoveryDistCurrRow.sharePct = shrPct;
			objCLM.recoveryDistCurrRow.shrRecoveryAmt = shrRecoveryAmt;
			recDistTB.updateRowAt(objCLM.recoveryDistCurrRow, objCLM.recoveryDistCurrRow.divCtrId); */
			
			recDistTB.geniisysRows[recDistSelectedIndex].sharePct = shrPct;
			recDistTB.geniisysRows[recDistSelectedIndex].shrRecoveryAmt = shrRecoveryAmt;
			recDistTB.updateVisibleRowOnly(recDistTB.geniisysRows[recDistSelectedIndex], recDistSelectedIndex);
			
			//for updating recovery ri dist table grid
			if(objCLM.recoveryDistCurrRow.shareType != 1) {				
				for(var count = 0; count < objGICLS054RiDist.length; count ++){
					var row = objGICLS054RiDist[count];
					row.shareRiPct = (shrPct * row.shareRiPctReal / 100) * 100; //added * 100 by jdiago 08.01.2014
					row.shrRiRecoveryAmt = (shrRecoveryAmt * row.shareRiPctReal / 100) * 100; //added * 100 by jdiago 08.01.2014
					row.recordStatus = 1;
					recRIDistTB.updateVisibleRowOnly(row, count);
				}
			}
			
			//for adjusting other share percantage
			if (recDistSelectedIndex != recDistTB.geniisysRows.length - 1){
				var index = recDistSelectedIndex + 1;
				recDistTB.geniisysRows[index].sharePct = parseFloat(recDistTB.geniisysRows[index].sharePct) +  sharePercentageDiff;
				recDistTB.geniisysRows[index].shrRecoveryAmt = parseFloat(recDistTB.geniisysRows[index].shrRecoveryAmt) + shareRecovertAmtDiff;
				recDistTB.geniisysRows[index].recordStatus = 1;
				recDistTB.updateVisibleRowOnly(recDistTB.geniisysRows[index], index);
			} else {
				recDistTB.geniisysRows[0].sharePct = parseFloat(recDistTB.geniisysRows[0].sharePct) +  sharePercentageDiff;
				recDistTB.geniisysRows[0].shrRecoveryAmt = parseFloat(recDistTB.geniisysRows[0].shrRecoveryAmt) + shareRecovertAmtDiff;
				recDistTB.geniisysRows[0].recordStatus = 1;
				recDistTB.updateVisibleRowOnly(recDistTB.geniisysRows[0], 0);
			}
			
			recDistTB.selectRow(recDistSelectedIndex);
			
			changeTag = 1;
			
 			/* objCLM.recoveryDistNetRetRow.sharePct = netRetShrPct;
			objCLM.recoveryDistNetRetRow.shrRecoveryAmt = netRetShrRecAmt;
			recDistTB.updateRowAt(objCLM.recoveryDistNetRetRow, objCLM.recoveryDistNetRetRow.divCtrId);
			
			objCLM.recoveryDistRidsRows = recRIDistTB.geniisysRows;
			
			 for (var i=0; i<objCLM.recoveryDistRidsRows.length; i++ ){
				 objCLM.recoveryDistRidsRows[i].shareRiPct = shrPct * objCLM.recoveryDistRidsRows[i].shareRiPctReal;
				 objCLM.recoveryDistRidsRows[i].shrRiRecoveryAmt = shrRecoveryAmt * objCLM.recoveryDistRidsRows[i].shareRiPctReal; 
				 recRIDistTB.updateRowAt(objCLM.recoveryDistRidsRows[i], objCLM.recoveryDistRidsRows[i].divCtrId);
			 }			
			
			populateRecovDist(null);
			clearTableGridDetails(recRIDistTB);
			changeTag = 1; */
		}catch(e){
			showErrorMessage("updateShrPctShrRecAmt", e);
		}
	}
	
	function deleteShrRecord(){
		try{
			/* var recRIDistRows = recRIDistTB.geniisysRows;
			var netRetShrPct = JSON.parse(objCLM.recoveryDistNetRetRow.sharePct) + JSON.parse(objCLM.recoveryDistCurrRow.sharePct); 
			var netRetShrRecAmt = JSON.parse(objCLM.recoveryDistNetRetRow.shrRecoveryAmt) + JSON.parse(objCLM.recoveryDistCurrRow.shrRecoveryAmt); 
			
			objCLM.recoveryDistNetRetRow.sharePct = netRetShrPct;
			objCLM.recoveryDistNetRetRow.shrRecoveryAmt = netRetShrRecAmt;
			recDistTB.updateRowAt(objCLM.recoveryDistNetRetRow, objCLM.recoveryDistNetRetRow.divCtrId); */
			
		 	//recDistTB.deleteRow(objCLM.recoveryDistCurrRow.divCtrId);
			var shrPct = unformatNumber(recDistTB.geniisysRows[recDistSelectedIndex].sharePct);
			var shrRecoveryAmt = unformatNumber(recDistTB.geniisysRows[recDistSelectedIndex].shrRecoveryAmt);
			recDistTB.geniisysRows[recDistSelectedIndex].recordStatus = -1;
		 	recDistTB.deleteRow(recDistTB.geniisysRows[recDistSelectedIndex].divCtrId);
		 	populateRecovDist(null);
		 	
		 	for(var count = 0; count < recDistTB.geniisysRows.length; count++){
		 		if(recDistTB.geniisysRows[count].recordStatus != -1){
		 			recDistTB.geniisysRows[count].sharePct = parseFloat(unformatNumber(recDistTB.geniisysRows[count].sharePct)) + parseFloat(shrPct);
		 			recDistTB.geniisysRows[count].shrRecoveryAmt = parseFloat(unformatNumber(recDistTB.geniisysRows[count].shrRecoveryAmt)) + parseFloat(shrRecoveryAmt);
		 			recDistTB.updateVisibleRowOnly(recDistTB.geniisysRows[count], count);
		 			break;
		 		}
		 	}
		 	
		 	clearTableGridDetails(recRIDistTB);
		 	
		 	/* recDistTB.geniisysRows[0].sharePct = parseFloat(recDistTB.geniisysRows[0].sharePct) +  sharePercentageDiff;
			recDistTB.geniisysRows[0].shrRecoveryAmt = parseFloat(recDistTB.geniisysRows[0].shrRecoveryAmt) + shareRecovertAmtDiff;
			recDistTB.geniisysRows[0].recordStatus = 1;
			recDistTB.updateVisibleRowOnly(recDistTB.geniisysRows[0], 0); */
		 	
		 	/* for (var i=0; i<recRIDistRows.length; i++){
		 		recRIDistTB.deleteRow(recRIDistRows[i].divCtrId); 
		 	} */
		 	changeTag = 1;
		 	
		 	$("txtSharePct").readOnly = true;
		 	$("txtSharePct").clear();
			disableButton("btnUpdate");
			disableButton("btnDelete");
		}catch(e){
			showErrorMessage("deleteShrRecord", e);
		}
	}
	
	function populateRecovDist(obj){
		$("txtTreatyName").value = nvl(obj, null) == null ? null : nvl(unescapeHTML2(obj.dspShareName), "");
		$("txtSharePct").value = nvl(obj, null) == null ? null : nvl(formatCurrency(obj.sharePct), "");
		$("txtShareRecovAmt").value = nvl(obj, null) == null ? null : nvl(formatCurrency(obj.shrRecoveryAmt), "");
	}
	
	objCLM.populateRecovDist = populateRecovDist;
	objCLM.disableButtons();

	function validateTxtShrPct(){
		var recoveredAmt = objCLM.recoveryDistDtlsCurrRow.recoveredAmt;
		
		if (!isNaN($F("txtSharePct")) && $F("txtSharePct") != null && $F("txtSharePct") != "" && !($F("txtSharePct") < 0) ){
			if(!($F("txtSharePct") > 100)){
				$("txtShareRecovAmt").value = formatCurrency(recoveredAmt * ($F("txtSharePct")/100));  
				$("txtSharePct").value = formatCurrency($F("txtSharePct"));  
				enableButton("btnUpdate");
			}else{
				showMessageBox("Share rate must not exceed 100%.", imgMessage.ERROR);
			}
		}else{
			showMessageBox("Valid value is from 0.00 to 100.00.", imgMessage.ERROR);
		}
	}
	
	$("txtSharePct").observe("keypress", function(event){
		if(event.keyCode == 13){
			validateTxtShrPct();	
		}
	});
	
	$("txtSharePct").observe("change", function(){
		validateTxtShrPct();		
	}); 
	
	$("btnUpdate").observe("click", function(){
		/* if (objCLM.recoveryDistCurrRow.shareType !=1){
			showConfirmBox("Confirmation", "Distribution shares will be recomputed accordingly.Do you wish to continue?", 
					"Yes", "No", function(){updateShrPctShrRecAmt();}, "");
		} */
		showConfirmBox("Confirmation", "Distribution shares will be recomputed accordingly.Do you wish to continue?", 
				"Yes", "No", function(){updateShrPctShrRecAmt();}, "");
	});
	
	$("btnDelete").observe("click", function(){
		/* if(objCLM.recoveryDistCurrRow.shareType == 1){
			showMessageBox("Distribution record cannot be deleted.", imgMessage.ERROR);
		}else{
			showConfirmBox("Confirmation", "Are you sure you want to delete this share record?",
					"Yes", "No", function(){
							showConfirmBox("Confirmation", "Distribution shares will be recomputed accordingly. Do you wish to continue?",
								"Yes", "No", function(){deleteShrRecord();}, "");}, "");
		} */
		
		showConfirmBox("Confirmation", "Are you sure you want to delete this share record?",
				"Yes", "No", function(){
						showConfirmBox("Confirmation", "Distribution shares will be recomputed accordingly. Do you wish to continue?",
							"Yes", "No", function(){deleteShrRecord();}, "");}, "");
	});
	
</script>