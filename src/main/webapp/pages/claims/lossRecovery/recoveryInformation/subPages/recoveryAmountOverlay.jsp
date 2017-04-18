<div id="recoveryAmountMainDiv">
	<div id="recoveryAmountDiv" name="recoveryAmountDiv" style="margin-top: 10px; width: 99.5%;" class="sectionDiv">
		<div id="divRecoveryAmountTG" style="height: 150px; width:625px; margin: 10px; margin-top: 10px; margin-bottom: 25px;">
		</div>
		<div style="float: right;">
			<table style="margin: 5px 9px 10px 0;" align="right">
				<tr>
					<!-- <td class="rightAligned" width="50px">Item</td>
					<td class="leftAligned">
						<input id="txtItemNo" name="txtItemNo" type="text" style="width: 50px;" value="" readonly="readonly"/>
					</td>
					<td class="leftAligned">
						<input id="txtItemName" name="txtItemName" type="text" style="width: 200px;" value="" readonly="readonly"/>
					</td> -->
					<td class="rightAligned" width="150px">Total</td>
					<td class="leftAligned">
						<input id="txtTotalRecoverableAmt" name="txtTotalRecoverableAmt" type="text" class="rightAligned" style="width: 120px; margin-left: 2px;" value="" readonly="readonly"/>
					</td>
				</tr>
			</table>
		</div>
		<!-- added by apollo cruz 07.10.2015 UCPB SR 19584 - recoverable amt must be editable when checkbox is tagged -->
		<table style="clear: both; float:none; margin: auto;">
			<tr>
				<td style="padding-right: 5px;">Item</td>
				<td><input type="text" id="txtItemNo" style="width: 50px;" readonly="readonly"/></td>
				<td><input type="text" id="txtItemName" style="width: 200px;" readonly="readonly"/></td>
				<td style="padding-right: 5px; padding-left: 20px;">Recoverable Amt.</td>
				<td><input type="text" id="txtRecoverableAmount" class="required applyDecimalRegExp2"
					customlabel="Recoverable Amount" regexppatt="pDeci1402" 
					min="0.01" max="99999999999999.99" style="width: 120px; text-align: right;"/></td>				
			</tr>
		</table>
		<div class="buttonsDiv" style="margin-bottom: 10px; margin-top: 5px;">
			<input type="button" class="button" id="btnUpdate" value="Update" style="width: 80px;">
		</div>
	</div>
</div>
<div id="recoverableAmountButtonsDiv" name="recoverableAmountButtonsDiv" class="buttonsDiv" style="margin-top: 10px; margin-bottom: 0px;">
	<!-- <input type="button" class="button" id="btnReturn" name="btnReturn" value="Return" style="width: 80px;">
	<input type="button" class="button" id="btnSave" value="Save" style="width: 80px;"> -->
	<input type="button" class="button" id="btnRecOverlayOk" name="btnRecOverlayOk" value="Ok" style="width: 80px;">
	<input type="button" class="button" id="btnRecOverlayCancel" name="btnRecOverlayCancel" value="Cancel" style="width: 80px;">
	<input type="hidden" id="hidClaimId" name="hidClaimId" value="${claimId}"/>
	<input type="hidden" id="hidRecoveryId" name="hidRecoveryId" value="${recoveryId}"/>
	<input type="hidden" id="hidLineCd" name="hidLineCd" value="${lineCd}"/>
	<input type="hidden" id="hidPerilCd" name="hidPerilCd" value=""/>
	<input type="hidden" id="hidPerilSname" name="hidPerilSname" value=""/>
	<input type="hidden" id="hidNbtAnnTsiAmt" name="hidnbtAnnTsiAmt" value=""/>
</div>

<script type="text/javascript">
try{
	var claimId = $F("hidClaimId");
	var recoveryId = $F("hidRecoveryId");
	var lineCd = $F("hidLineCd");
	var recoverableAmt = 0;
	var recoveryAmountSelectedIndex;
	var objRA = new Object();
	
	initializeAll();
	objRecoveryAmount = JSON.parse('${recoveryAmountTG}');
	objCurrRecoveryAmount = {};
	objRA.objRATableGrid = JSON.parse('${recoveryAmountTG}');
	objRA.objRAmount = objRA.objRATableGrid.rows || [];
	
	var objTempRAI=[]; //added by robert 10.26.2013
	
	var recoveryAmtTableModel = {
			id: 3,
			url: contextPath
			+ "/GICLRecoveryPaytController?action=showRecovAmtOverlay"
			+ "&claimId=" + claimId
			+ "&lineCd=" + lineCd
			+ "&recoveryId=" + recoveryId
			+ "&ajax=1&refresh=1",
		options : {
			title: '',
			width : '700px',
			hideColumnChildTitle: true,
			toolbar : {
				elements : [ MyTableGrid.REFRESH_BTN],
				onRefresh : function() {
					recoveryAmountTableGrid.keys.releaseKeys();
				},
				onFilter : function() {
					recoveryAmountTableGrid.keys.releaseKeys();
				}
			},
			onCellFocus: function(element, value, x, y, id){
				recoveryAmountSelectedIndex = y;
				var obj = recoveryAmountTableGrid.geniisysRows[y];
				populateRecoveryAmount(obj); // apollo cruz 07.10.2015 UCPB SR 19584
				recoveryAmountTableGrid.keys.removeFocus(recoveryAmountTableGrid.keys._nCurrentFocus, true);
			},
			onRemoveRowFocus: function() {
				recoveryAmountSelectedIndex = -1;
				populateRecoveryAmount(null); // apollo cruz 07.10.2015 UCPB SR 19584
				recoveryAmountTableGrid.keys.removeFocus(recoveryAmountTableGrid.keys._nCurrentFocus, true);
				recoveryAmountTableGrid.keys.releaseKeys();
				//disableButton("btnUpdate");
			}
		},
		columnModel : [
		     {
				id : 'recordStatus',
				title : 'Record Status',
				width : '0',
				visible : false,
				editor : 'checkbox'
			},
			{
				id : 'divCtrId',
				width : '0',
				visible : false
			},
			/* {	id : "chkChoose", //added by robert 05.27.2013 sr 13135
				width : '0',
				visible : false
			}, */
			{	id:	'chkChoose', //marco - modified - 10.17.2013
				title: '',
				tooltip: '',
				altTitle: '',
				sortable: false,
				align: 'center',
				width: '25px',
				editable: true,
				hideSelectAllBox: true,
				editor: new MyTableGrid.CellCheckbox({
		            getValueOf: function(value){
	            		return value ? "Y" : "N";
	            	},
	            	onClick: function(value){
	            		if(value == "Y"){
	            			objRA.rows[recoveryAmountSelectedIndex].chkChoose = "Y";
	            			$("txtRecoverableAmount").readOnly = false; // apollo cruz 07.10.2015 UCPB SR 19584
	            		}else{
	            			objRA.rows[recoveryAmountSelectedIndex].chkChoose = "N";
	            			$("txtRecoverableAmount").readOnly = true; // apollo cruz 07.10.2015 UCPB SR 19584
	            		}
	            		getRecTotal(); // added by j.diago 07.30.2014 to recompute total recovery amounts.
 			    	}
            	})
			},
			{
				id: 'itemNo itemTitle',
				title: 'Item',
				width : '205px',
				children : [
		            {
		                id : 'itemNo',
		                title: 'Item No.',
		                width : 50,
		                align: 'right',
		                filterOption: true,
		                filterOptionType: 'integer',
		                editable: false 		
		            }, 
		            {
		                id : 'itemTitle', 
		                title: 'Item Title',
		                width : 155,
		                filterOption: true, 
		                editable: false
		            } 
				]
			},{
				id: 'perilCd perilSname',
				title: 'Peril',
				width : '200px',
				children : [
		            {
		                id : 'perilCd',
		                title: 'Peril Code',
		                width : 50,
		                align: 'right',
		                filterOption: true,
		                filterOptionType: 'integer',
		                editable: false 		
		            }, 
		            {
		                id : 'perilSname', 
		                title: 'Peril Name',
		                width : 150,
		                filterOption: true, 
		                editable: false
		            } 
				]
			},{	id : "nbtAnnTsiAmt",
				title: "TSI Amount",
				width: '120px',
				align: 'right',
				geniisysClass: 'money',
				filterOption: true,
                filterOptionType: 'number'
			},{	id : "nbtPaidAmt",
				title: "Recoverable",
				width: '126px',
				align: 'right',
				geniisysClass: 'money',
				filterOption: true,
                filterOptionType: 'number'
			},{	id : "lossReserve",
				title: "",
				width: '0',
				visible: false
			},{	id : "clmLossId",
				title: "",
				width: '0',
				visible: false
			}
		],
		resetChangeTag: true,
		rows: objRA.objRAmount,
		requiredColumns: ''
	};
	
	recoveryAmountTableGrid = new MyTableGrid(recoveryAmtTableModel);
	recoveryAmountTableGrid.pager = objRA.objRATableGrid;
	recoveryAmountTableGrid.mtgId = 3;
	recoveryAmountTableGrid.render('divRecoveryAmountTG');
	recoveryAmountTableGrid.afterRender = function(){
		objRA.rows = recoveryAmountTableGrid.geniisysRows;
		recoveryAmountTableGrid.onRemoveRowFocus(); //marco - 10.17.2013
		getRecTotal();								//
	};
	
	/* added by apollo cruz 07.10.2015 UCPB SR 19584 - recoverable amt must be editable when checkbox is tagged */
	$("btnUpdate").observe("click", function(){
		if ($("txtRecoverableAmount").value == "") {
			showMessageBox("Recoverable Amount must not be null.", imgMessage.ERROR);
			$("txtRecoverableAmount").focus();
		} else if (isNaN(parseInt($("txtRecoverableAmount").value))) {
			showMessageBox("Recoverable Amount must be form of 99,999,999,999,990.00", imgMessage.ERROR);
			$("txtRecoverableAmount").focus();
		} else if (parseFloat($("txtRecoverableAmount").value.replace(/,/g, "")) > parseFloat(objRA.rows[recoveryAmountSelectedIndex].origNbtPaidAmt)) {
			showMessageBox("Recoverable Amount must not be greater than Reserve Amount (" + formatCurrency(objRA.rows[recoveryAmountSelectedIndex].origNbtPaidAmt) + ").");
			$("txtRecoverableAmount").focus();
		} 
		else {
			var newObj = objRA.rows[recoveryAmountSelectedIndex];
			objRA.rows[recoveryAmountSelectedIndex].nbtPaidAmt = $("txtRecoverableAmount").value.replace(/,/g, "");
			recoveryAmountTableGrid.updateVisibleRowOnly(newObj, recoveryAmountSelectedIndex);
			recoveryAmountTableGrid.onRemoveRowFocus();
			getRecTotal();
		}
	});
	
	//marco - replaced buttons and functions - 10.17.2013
	/* $("btnUpdate").observe("click", function(){		
		try{
			var newObj = new Object;
			newObj = objTempRAI; //added by robert 10.26.2013
			newObj.nbtPaidAmt = $("txtRecoverableAmount").value.replace(/,/g, ""); // added replace by robert 05.27.2013 sr 13135
			newObj.itemNo = $("txtItemNo").value;
			newObj.itemTitle = $("txtItemName").value;
			newObj.perilCd = $("hidPerilCd").value;
			newObj.perilSname = $("hidPerilSname").value;
			newObj.nbtAnnTsiAmt = $("hidNbtAnnTsiAmt").value;
			
			if ($("txtRecoverableAmount").value == "") {
				showMessageBox("Recoverable Amount should not be null.", imgMessage.ERROR);
				$("txtRecoverableAmount").focus();
			}else if (parseInt($("txtRecoverableAmount").value) < 0) {
				showMessageBox("Recoverable Amount should not be less than 0.", imgMessage.ERROR);
				$("txtRecoverableAmount").focus();
			}else if (isNaN(parseInt($("txtRecoverableAmount").value))) {
				showMessageBox("Recoverable Amount must be form of 999,999,999,990.00", imgMessage.ERROR);
				$("txtRecoverableAmount").focus();
			}else{
				//for(var i = 0; i < objRAI.length; i++){ // commented out by robert 05.27.2013 sr 13135
					var i = recoveryAmountSelectedIndex;
					if ((objRAI[i].itemNo == newObj.itemNo)&& (objRAI[i].itemTitle == newObj.itemTitle)&& (objRAI[i].recordStatus != -1)){
						recoverableAmt = newObj.nbtPaidAmt;
						newObj.recordStatus = 1;
						newObj.chkChoose = 'Y'; // added by robert 05.27.2013 sr 13135
						objRAI.splice(i, 1, newObj);
						recoveryAmountTableGrid.updateVisibleRowOnly(newObj, recoveryAmountTableGrid.getCurrentPosition()[1]);
						recoveryAmountTableGrid.keys.releaseKeys();
						enableButton("btnSave");
					}
				//}
			}
			recoveryAmountSelectedIndex = -1;
			populateRecoveryAmount(null);			
		} catch(e){
			showErrorMessage("updateRecoveryAmount()", e);
		}
	}); */
	
	/* $("btnSave").observe("click",function(){
		objCLM.recoveryDetailsLOV = objRAI; //added by robert 05.27.2013 sr 13135
		$("txtRecoverableAmt").value  = nvl(recoverableAmt,"") == "" ? "0.00" : formatCurrency(recoverableAmt);
		$("txtRecoverableAmt2").value = nvl(recoverableAmt,"") == "" ? "0.00" : formatCurrency(recoverableAmt);
		$("txtRecoverableAmt2").focus();
		fireEvent($("btnAdd"), "click");
		recoveryAmountOverlay.close();
		delete recoveryAmountOverlay;
	}); */
	
	function getRecTotal(){
		var totalRecAmt = 0;
		for(var i = 0; i < objRA.rows.length; i++){
			if($("mtgInput"+recoveryAmountTableGrid._mtgId+"_2,"+i).checked){ //added by j.diago 07.30.2014 only tagged recovery amounts will be added to total 
				totalRecAmt += parseFloat(objRA.rows[i].nbtPaidAmt);	
			}
		}
		$("txtTotalRecoverableAmt").value = formatCurrency(totalRecAmt);
	}
	
	function onOverlayOk(){
		var totalRecAmt = 0;
		for(var i = 0; i < objRA.rows.length; i++){
			if(nvl(objRA.rows[i].chkChoose, "N") == "Y"){
				totalRecAmt += parseFloat(objRA.rows[i].nbtPaidAmt);
			}
		}
		
		$("txtRecoverableAmt").value = formatCurrency(totalRecAmt);
		$("txtRecoverableAmt2").value = formatCurrency(totalRecAmt);
		$("txtRecoverableAmt2").focus();
		
		objCLM.recoveryDetailsLOV = objRA.rows;
		fireEvent($("btnAdd"), "click");
		exitRecOverlay();
	}
	
	function exitRecOverlay(){
		recoveryAmountOverlay.close();
		delete objRA;
		delete recoveryAmountOverlay;
	}
	
	$("btnRecOverlayOk").observe("click", function(){
		showConfirmBox("Confirmation", "Would you like to continue saving?", "Yes", "No", onOverlayOk, exitRecOverlay);
	});
	$("btnRecOverlayCancel").observe("click", exitRecOverlay);	
	//end 10.17.2013
	
	function populateRecoveryAmount(obj){
		$("txtItemNo").value    = (obj) == null ? "" : nvl(obj.itemNo,"");
		$("txtItemName").value    = (obj) == null ? "" : nvl(unescapeHTML2(obj.itemTitle),"");
		$("txtRecoverableAmount").value    = (obj) == null ? "" : nvl(formatCurrency(obj.nbtPaidAmt),"");
		
		// added by apollo cruz 07.10.2015 UCPB SR 19584
		/* $("hidPerilCd").value    = (obj) == null ? "" : nvl(obj.perilCd,"");
		$("hidPerilSname").value    = (obj) == null ? "" : nvl(unescapeHTML2(obj.perilSname),"");
		$("hidNbtAnnTsiAmt").value    = (obj) == null ? "" : nvl(obj.nbtAnnTsiAmt,""); */
		
		if(obj != null && obj.chkChoose == "Y")
			$("txtRecoverableAmount").readOnly = false;
		else
			$("txtRecoverableAmount").readOnly = true;
		
		if(obj != null)
			enableButton("btnUpdate");
		else
			disableButton("btnUpdate");
	}
}catch(e){
	showErrorMessage("Recovery Amount Overlay.", e);
}
</script>