<div id="distributionDtlsMainDiv">
	<div id="reserveDsDiv" name="reserveDsDiv" style="margin-top: 5px; width: 99.5%;" class="sectionDiv">
		<div id="reserveDsGrid" style="height: 180px; width: 700px; margin: 10px; margin-top: 10px; margin-bottom: 5px;"></div>
		<table align="center" border="0" style="margin-bottom: 10px;">
			<tr>
				<td id="lossCatTitle" name="lossCatTitle" class="rightAligned" width="160px">Treaty Name</td>
				<td class="leftAligned" width="150px"><input type="text" style="width: 190px;" id="txtTreatyName" name="txtTreatyName" readonly="readonly" value="" /></td>		
				<td id="lossCatTitle" name="lossCatTitle" class="rightAligned" width="160px">Share Pct.</td>
				<td class="leftAligned" width="150px"><input type="text" style="width: 190px;" id="txtTrtyShrPct" name="txtTrtyShrPct" readonly="readonly" value="" class="moneyRate"  maxlength="13"/></td>			
			</tr>
			<tr>
				<td id="lossCatTitle" name="lossCatTitle" class="rightAligned" width="160px">Treaty Share Loss Res Amt.</td>
				<td class="leftAligned" width="150px"><input type="text" style="width: 190px;" id="txtTrtyShrLoss" name="txtTrtyShrLoss" readonly="readonly" value="" class="money" maxlength="15"/></td>		
				<td id="lossCatTitle" name="lossCatTitle" class="rightAligned" width="160px">Treaty Share Exp Res Amt.</td>
				<td class="leftAligned" width="150px"><input type="text" style="width: 190px;" id="txtTrtyShrExp" name="txtTrtyShrExp" readonly="readonly" value="" class="money" maxlength="15"/></td>			
			</tr>
		</table>
		<!-- <div align="center">
			<input type="button" class="button" id="btnTrtyUpdate" value="Update" style="width: 80px; margin-bottom: 5px; margin-top: 5px;">
		</div> -->
	</div>
	<div id="reserveRIDsDiv" name="reserveRIDsDiv" style="width: 99.5%;" class="sectionDiv">
		<div id="reserveRidsGrid" style="height: 180px; width: 700px; margin: 10px; margin-top: 10px; margin-bottom: 10px;"></div>
		<!-- <table align="center" border="0">
			<tr>
				<td id="lossCatTitle" name="lossCatTitle" class="rightAligned" width="160px">RI Name</td>
				<td class="leftAligned" width="150px"><input type="text" style="width: 190px;" id="txtRIName" name="txtRIName" readonly="readonly" value=""  /></td>		
				<td id="lossCatTitle" name="lossCatTitle" class="rightAligned" width="160px">Share Pct.</td>
				<td class="leftAligned" width="150px"><input type="text" style="width: 190px;" id="txtRiShrPct" name="txtRiShrPct" readonly="readonly" value="" class="moneyRate" /></td>			
			</tr>
			<tr>
				<td id="lossCatTitle" name="lossCatTitle" class="rightAligned" width="160px">Share Loss Reserve Amt.</td>
				<td class="leftAligned" width="150px"><input type="text" style="width: 190px;" id="txtRIShrLoss" name="txtRIShrLoss" readonly="readonly" value="" class="money" /></td>		
				<td id="lossCatTitle" name="lossCatTitle" class="rightAligned" width="160px">Share Exp. Reserve Amt.</td>
				<td class="leftAligned" width="150px"><input type="text" style="width: 190px;" id="txtRIShrExp" name="txtRIShrExp" readonly="readonly" value="" class="money" /></td>			
			</tr>
		</table>
		<div align="center">
			<input type="button" class="button" id="btnRIUpdate" value="Update" style="width: 80px; margin-bottom: 5px; margin-top: 5px;">
		</div> -->
	</div>
</div>
<div id="invoiceButtonsDiv" name="invoiceButtonsDiv" class="buttonsDiv" style="margin-top: 10px; margin-bottom: 0px;">
	<input type="button" class="button" id="btnXOLDeductible" name="btnXOLDeductible" value="XOL Deductible" style="width: 110px;">
	<input type="button" class="button" id="btnDistDtlsReturn" name="btnDistDtlsReturn" value="Return"  style="width: 110px;">
</div>

<script type="text/javascript">
try{
	initializeAll();
	initializeAllMoneyFields();
	
	disableButton("btnXOLDeductible");
	/* disableButton("btnTrtyUpdate"); */
	/* disableButton("btnRIUpdate"); */
	
	var triggerItem;

	objGICLS024.getPerilStatusGICLS024();
	
	var objTrty = {};
	var objRI = {};
	
	objReserveDsGrid = JSON.parse('${reserveDsTG}');
	objCurrReserveDS = {};
	objReserveRidsGrid = new Object();
	
	function setTrtyInfo(obj){	
		$("txtTreatyName").value 				= nvl(obj,null) != null ? unescapeHTML2(obj.dspTrtyName) :null;
		$("txtTrtyShrPct").value 					= nvl(obj,null) != null ? formatToNineDecimal(obj.shrPct) :null;
		$("txtTrtyShrLoss").value 				= nvl(obj,null) != null ? formatCurrency(obj.shrLossResAmt) :null;
		$("txtTrtyShrExp").value 				= nvl(obj,null) != null ? formatCurrency(obj.shrExpResAmt) :null;
	}
	
	/* function setRidsInfo(obj){	
		$("txtRIName").value 					= nvl(obj,null) != null ? unescapeHTML2(obj.riName) :null;
		$("txtRiShrPct").value 					= nvl(obj,null) != null ? formatToNineDecimal(obj.shrRiPct) :null;
		$("txtRIShrLoss").value 				= nvl(obj,null) != null ? formatCurrency(obj.shrLossRiResAmt) :null;
		$("txtRIShrExp").value 				= nvl(obj,null) != null ? formatCurrency(obj.shrExpRiResAmt) :null;
	} */
	
	var giclReserveRidsTableModel = {
			id: 4,
		options : {
			title: '',
			pager : {}, 
			width : '730px',
			toolbar : {
				elements : [ MyTableGrid.REFRESH_BTN,/*  MyTableGrid.FILTER_BTN */ ],
				onRefresh : function() {
					giclReserveRidsTableGrid.keys.releaseKeys();
				},
				onFilter : function() {
					giclReserveRidsTableGrid.keys.releaseKeys();
				}
			},
			beforeSort : function() {
				if(giclReserveRidsTableGrid.url == null){
					return false;
				};
			},
			onCellFocus: function(element, value, x, y, id){
				objCurrReserveRIDS = giclReserveRidsTableGrid.geniisysRows[y];
				giclReserveRidsTableGrid.keys.releaseKeys();
				/* setRidsInfo(objCurrReserveRIDS);
				enableButton("btnRIUpdate"); */
			},
			onRemoveRowFocus: function(){
				objCurrReserveRIDS = null;
				giclReserveRidsTableGrid.keys.releaseKeys();
				/* setRidsInfo(null);
				disableButton("btnRIUpdate"); */
			},
			onCellBlur: function(){
				giclReserveRidsTableGrid.keys.removeFocus(giclReserveRidsTableGrid.keys._nCurrentFocus, true);
				giclReserveRidsTableGrid.keys.releaseKeys();
			}
		},
		columnModel : [
			{   id: 'recordStatus',
			    width: '0px',
			    visible: false,
			    editor: 'checkbox'
			},
			{	id: 'divCtrId',
				width: '0px',
				visible: false
			},{
				id: 'riCd',
				title: 'RI Code',
				titleAlign: 'center',
				align : 'left',
				width : '100px'
			},{
				id: 'riName',
				title: 'RI Name',
				titleAlign: 'left',
				align : 'left',
				width : '215px'
			},{
				id: 'shrRiPct',
				title: 'Share Pct.',
				titleAlign: 'center',
				align : 'right',
				width : '90px',
				geniisysClass: 'rate'
			},{
				id: 'shrLossRiResAmt',
				title : 'Share Loss Reserve Amt.',
				titleAlign : 'center',
				align : 'right',
				width : '145px',
				editable : false,
				sortable : true,
				type: 'number',
				geniisysClass: 'money'
			},{
				id: 'shrExpRiResAmt',
				title : 'Share Exp. Reserve Amt.',
				titleAlign : 'center',
				align : 'right',
				width : '145px',
				editable : false,
				sortable : true,
				type: 'number',
				geniisysClass: 'money'
			}
		],
		resetChangeTag: true,
		rows: []
	};
	
	giclReserveRidsTableGrid = new MyTableGrid(giclReserveRidsTableModel);
	giclReserveRidsTableGrid.pager = objReserveRidsGrid;
	giclReserveRidsTableGrid.mtgId = 4;
	giclReserveRidsTableGrid.render('reserveRidsGrid');
	/* giclReserveRidsTableGrid.afterRender = function(){
		objRI = giclReserveRidsTableGrid.geniisysRows;
		setRidsInfo(null);
		disableButton("btnRIUpdate");
	}; */
	
	var giclReserveDsTableModel = {
			id: 3,
			url: contextPath
			+ "/GICLClaimReserveController?action=showDistDtlsOverlay"
			+ "&claimId=" + objCLMGlobal.claimId
			+ "&clmResHistId=" +objCurrGICLItemPeril.giclClmResHist.clmResHistId
			+ "&itemNo=" + objCurrGICLItemPeril.giclClmResHist.itemNo
			+ "&perilCd=" + objCurrGICLItemPeril.giclClmResHist.perilCd
			+ "&ajax=1&refresh=1",
		options : {
			title: '',
			pager : {}, 
			width : '730px',
			toolbar : {
				elements : [ MyTableGrid.REFRESH_BTN],
				onRefresh : function() {
					giclReserveDsTableGrid.keys.releaseKeys();
					showReserveRidsTG(false);
					setTrtyInfo(null);
				},
				onFilter : function() {
					giclReserveDsTableGrid.keys.releaseKeys();
				}
			},
			onCellFocus: function(element, value, x, y, id){
				objCurrReserveDS = giclReserveDsTableGrid.geniisysRows[y];
				objCurrReserveDS.selectedIndex = y;
				giclReserveDsTableGrid.keys.releaseKeys();
				setTrtyInfo(objCurrReserveDS);
				objGICLS024.vars.dspXolDed = objCurrReserveDS.xolDedAmt;
				objGICLS024.vars.prevLossResAmt = objCurrReserveDS.shrLossResAmt;
				objGICLS024.vars.prevExpResAmt = objCurrReserveDS.shrExpResAmt;
				showReserveRidsTG(true);
				checkFields(objCurrReserveDS);
			},
			onCellBlur: function(){
				giclReserveDsTableGrid.keys.removeFocus(giclReserveDsTableGrid.keys._nCurrentFocus, true);
				giclReserveDsTableGrid.keys.releaseKeys();
			},
			onRemoveRowFocus: function() {
				objCurrReserveDS = null;
				giclReserveDsTableGrid.keys.releaseKeys();
				setTrtyInfo(null);
				objGICLS024.vars.prevLossResAmt = null;
				objGICLS024.vars.prevExpResAmt = null;
				objGICLS024.vars.dspXolDed = null;
				showReserveRidsTG(false);
				checkFields(null);
			}
		},
		columnModel : [{
				id : 'recordStatus',
				title : 'Record Status',
				width : '0',
				visible : false,
				editor : 'checkbox'
			},{
				id : 'divCtrId',
				width : '0',
				visible : false
			},{
				id: 'claimId',
				width : '0',
				visible : false
			},{
				id: 'clmResHistId',
				width : '0',
				visible : false
			},{
				id: 'lineCd',
				width : '0',
				visible : false
			},{
				id: 'grpSeqNo',
				width : '0',
				visible : false
			},{
				id: 'clmDistNo',
				width : '0',
				visible : false
			},{
				id: 'dspTrtyName',
				title: 'Treaty Name',
				titleAlign: 'center',
				align : 'left',
				width : '216px',
				editable : false,
				sortable : true
			},{
				id: 'distYear',
				title: 'Distribution Year',
				titleAlign: 'center',
				align : 'left',
				width : '100px'
			},{
				id: 'shrPct',
				title: 'Share Pct.',
				titleAlign: 'center',
				align : 'right',
				width : '90px',
				geniisysClass: 'rate'
			},{
				id: 'shrLossResAmt',
				title : 'Treaty Share Loss Res Amt.',
				titleAlign : 'center',
				align : 'right',
				width : '140px',
				editable : false,
				sortable : true,
				filterOption : true,
				filterType: 'numberNoNegative',
				type: 'number',
				geniisysClass: 'money'
			},{
				id: 'shrExpResAmt',
				title : 'Treaty Share Exp Res Amt.',
				titleAlign : 'center',
				align : 'right',
				width : '140px',
				editable : false,
				sortable : true,
				filterOption : true,
				filterType: 'numberNoNegative',
				type: 'number',
				geniisysClass: 'money'
			}
		],
		resetChangeTag: true,
		rows: objReserveDsGrid.rows,
		requiredColumns: ''
	};
	
	giclReserveDsTableGrid = new MyTableGrid(giclReserveDsTableModel);
	giclReserveDsTableGrid.pager = objReserveDsGrid;
	giclReserveDsTableGrid.mtgId = 3;
	giclReserveDsTableGrid.render('reserveDsGrid');
	giclReserveDsTableGrid.afterRender = function(){
		objTrty = giclReserveDsTableGrid.geniisysRows;
		setTrtyInfo(null);
		checkFields(null);
		showReserveRidsTG(false);
		//setRidsInfo(null);
		//disableButton("btnRIUpdate");
	};
	
	function checkFields(obj){
		if (obj != null){
			//enableButton("btnTrtyUpdate");
			if (obj.shareType != '2' || obj.prtfolioSw != 'P'){
				disableButton("btnXOLDeductible");
				disableInputField("txtTrtyShrPct");
				disableInputField("txtTrtyShrLoss");
				disableInputField("txtTrtyShrExp");
				if(obj.shareType == '4' && obj.updResDist == 'Y'){
					if(objGICLS024.vars.closeFlag!='AP'){
						disableInputField("txtTrtyShrPct");
					}else{
						enableInputField("txtTrtyShrPct");
						if(unformatCurrencyValue($F("txtLossReserve")) != '0'){
							enableInputField("txtTrtyShrLoss");
							if (obj.xolDedAmt != null && obj.xolDedAmt !='0'){
								enableButton("btnXOLDeductible");
							}
						}else{
							disableInputField("txtTrtyShrLoss");
						}
						if(unformatCurrencyValue($F("txtExpenseReserve")) != '0'){
							enableInputField("txtTrtyShrExp");
							if (obj.xolDedAmt != null && obj.xolDedAmt !='0'){
								enableButton("btnXOLDeductible");
							}
						}else{
							disableInputField("txtTrtyShrExp");
						}
					}
				}
			}else if(obj.shareType == '2'){
				disableButton("btnXOLDeductible");
				if(objGICLS024.vars.closeFlag != 'AP'){
					disableInputField("txtTrtyShrPct");
				}else{
					enableInputField("txtTrtyShrPct");
					if($F("txtLossReserve") != '0'){
						enableInputField("txtTrtyShrLoss");
					}else{
						disableInputField("txtTrtyShrLoss");
					}
					if($F("txtExpenseReserve") != '0'){
						enableInputField("txtTrtyShrExp");
					}else{
						disableInputField("txtTrtyShrExp");
					}
				}
			}else if(obj.shareType == '4' && obj.updResDist == 'Y'){
				if(objGICLS024.vars.closeFlag!='AP'){
					disableInputField("txtTrtyShrPct");
				}else{
					if($F("txtLossReserve") != '0'){
						enableInputField("txtTrtyShrLoss");
					}else{
						disableInputField("txtTrtyShrLoss");
					}
					if($F("txtExpenseReserve") != '0'){
						enableInputField("txtTrtyShrExp");
					}else{
						disableInputField("txtTrtyShrExp");
					}
				}
			}
		}else{
			//disableButton("btnTrtyUpdate");
			disableButton("btnXOLDeductible");
			disableInputField("txtTrtyShrPct");
			disableInputField("txtTrtyShrLoss");
			disableInputField("txtTrtyShrExp");
		}
	}
	
	function checkXOLAmtLimits() {
		try {
			new Ajax.Request(
					contextPath + "/GICLReserveDsController",
					{
						method : "GET",
						parameters : {
							action : "checkXOLAmtLimits",
							grpSeqNo   : objCurrReserveDS.grpSeqNo,
							lineCd  : objCurrReserveDS.lineCd,
							claimId  : objCurrReserveDS.claimId,
							itemNo  : objCurrGICLItemPeril.giclClmResHist.itemNo,
							perilCd  : objCurrGICLItemPeril.giclClmResHist.perilCd,
							clmDistNo  : objCurrReserveDS.clmDistNo,
							cmlResHistId  : objCurrReserveDS.clmResHistId,
							nbtCatCd  : nvl(objGICLClaims.catastrophicCode,""),
							triggerItem  : triggerItem,
							expenseReserve  : unformatCurrencyValue(nvl($F("txtExpenseReserve"),'0')),
							lossReserve  : unformatCurrencyValue(nvl($F("txtLossReserve"),'0')),
							groupedItemNo  : objCurrGICLItemPeril.giclClmResHist.groupedItemNo,
							shrLossResAmt  : unformatCurrencyValue(nvl($F("txtTrtyShrLoss"),'0')),
							prevLossResAmt  : nvl(objCurrReserveDS.shrLossResAmt,0),
							xolDed  : objCurrReserveDS.xolDedAmt,
							dspXolDed  : objGICLS024.vars.dspXolDed,
							shrExpResAmt  : unformatCurrencyValue(nvl($F("txtTrtyShrExp"),'0')),
							prevExpResAmt  : nvl(objCurrReserveDS.shrExpResAmt,0),
							shrPct  : unformatCurrencyValue(nvl($F("txtTrtyShrPct"),'0')),
							prevShrPct  : objCurrReserveDS.shrPct
						},
						evalScripts : true,
						asynchronous : true,
						onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								var res = JSON.parse(response.responseText);
								var msg = res.msg;
								var msg2 = res.msg2;
								var newLossResAmt = res.newLossResAmt;
								var newExpResAmt = res.newExpResAmt;
								var newPct = res.newPct;
								if (msg != null){
									if(triggerItem == 'SHR_LOSS_RES_AMT'){
										showWaitingMessageBox(msg, "I", function(){
											if (msg2 != null){
												showMessageBox(msg2,"I");
											}
											$("txtTrtyShrLoss").value = formatCurrency(newLossResAmt);
											$("txtTrtyShrLoss").focus();
										});
									}else if(triggerItem == 'SHR_EXP_RES_AMT'){
										showWaitingMessageBox(msg, "I", function(){
											if (msg2 != null){
												showMessageBox(msg2,"I");
											}
											$("txtTrtyShrExp").value = formatCurrency(newExpResAmt);
											$("txtTrtyShrExp").focus();
										});
									}else if(triggerItem == 'SHR_PCT'){
										showWaitingMessageBox(msg, "I", function(){
											if (msg2 != null){
												showMessageBox(msg2,"I");
											}
											$("txtTrtyShrPct").value = formatToNineDecimal(newPct);
											$("txtTrtyShrPct").focus();
										});
									}
								}else{
									if(triggerItem == 'SHR_LOSS_RES_AMT'){
											if (msg2 != null){
												showMessageBox(msg2,"I");
												$("txtTrtyShrLoss").value = formatCurrency(newLossResAmt);
												$("txtTrtyShrLoss").focus();
												return false;
											}
									}else if(triggerItem == 'SHR_EXP_RES_AMT'){
											if (msg2 != null){
												showMessageBox(msg2,"I");
												$("txtTrtyShrExp").value = formatCurrency(newExpResAmt);
												$("txtTrtyShrExp").focus();
												return false;
											}
									}else if(triggerItem == 'SHR_PCT'){
											if (msg2 != null){
												showMessageBox(msg2,"I");
												$("txtTrtyShrPct").value = formatToNineDecimal(newPct);
												$("txtTrtyShrPct").focus();
												return false;
											}
									}
									var rowObj = createDsInfoDtls();		
									objTrty.splice(objCurrReserveDS.selectedIndex, 1, rowObj);
									giclReserveDsTableGrid.updateVisibleRowOnly(rowObj, objCurrReserveDS.selectedIndex, true);
									objCurrReserveDS = rowObj;
									validateShare();
								}
							}
						}
					});
		} catch (e) {
			showErrorMessage("checkXOLAmtLimits", e);
		}
	}
	
	function createDsInfoDtls(){
		try {		
			var obj 						= objCurrReserveDS;
			obj.recordStatus 			= 1;
			obj.shrPct      				= $F("txtTrtyShrPct");
			obj.shrLossResAmt      	= unformatCurrencyValue($F("txtTrtyShrLoss"));
			obj.shrExpResAmt			= unformatCurrencyValue($F("txtTrtyShrExp"));
			return obj;
		} catch (e){
			showErrorMessage("createDsInfoDtls", e);
		}			
	}
	
	function showReserveRidsTG(show){	
		try{	
			if(show){
				var claimId = objCurrReserveDS.claimId;
				var clmDistNo = objCurrReserveDS.clmDistNo;
				var grpSeqNo = objCurrReserveDS.grpSeqNo;
				var clmResHistId = objCurrReserveDS.clmResHistId;
				giclReserveRidsTableGrid.url = contextPath+"/GICLClaimReserveController?action=refreshReserveRidsTG&claimId="+claimId+
						"&clmDistNo="+clmDistNo+"&grpSeqNo="+grpSeqNo+"&clmResHistId="+clmResHistId;
				giclReserveRidsTableGrid._refreshList();
			}else{
				if($("reserveRIDsDiv") != null){
					clearTableGridDetails(giclReserveRidsTableGrid); 
				}
			}
		}catch(e){
			showErrorMessage("showReserveHistoryTG",e);
		}
	}
	
	function showXolDeducOverlay(){
		xolDeducOverlay = Overlay.show(contextPath+"/GICLClaimReserveController", {
			urlContent: true,
			draggable: true,
			urlParameters: {
				action     		: "showXolDeducOverlay"
			},
		    title: "XOL Deductible",
		    height: 168,
		    width: 350
		});
	}
	
	function refreshDsTg(){
		/* giclReserveDsTableGrid.url = contextPath+"/GICLClaimReserveController?action=showDistDtlsOverlay&claimId="+objCLMGlobal.claimId+
			+ "&clmResHistId=" +objCurrGICLItemPeril.giclClmResHist.clmResHistId
			+ "&itemNo=" + objCurrGICLItemPeril.giclClmResHist.itemNo
			+ "&perilCd=" + objCurrGICLItemPeril.giclClmResHist.perilCd
			+ "refresh=1"; */
		giclReserveDsTableGrid._refreshList();
	}
	
	function updateShrLossResGICLS024() {
		try {
			new Ajax.Request(
					contextPath + "/GICLReserveDsController",
					{
						method : "GET",
						parameters : {
							action : "updateShrLossResGICLS024",
							claimId   : objCurrReserveDS.claimId,
							clmResHistId  : objCurrReserveDS.clmResHistId,
							itemNo  : objCurrGICLItemPeril.giclClmResHist.itemNo,
							perilCd  : objCurrGICLItemPeril.giclClmResHist.perilCd,
							grpSeqNo  : objCurrReserveDS.grpSeqNo,
							clmDistNo  : objCurrReserveDS.clmDistNo,
							lossReserve  : objCurrGICLItemPeril.giclClmResHist.lossReserve,
							totLossResAmt  : objGICLS024.vars.totLossResAmt,
							totExpResAmt  : objGICLS024.vars.totExpResAmt,
							shrLossResAmt  : unformatCurrencyValue($F("txtTrtyShrLoss")),
							prevLossResAmt	: objGICLS024.vars.prevLossResAmt,
							annTsiAmt : objCurrGICLItemPeril.annTsiAmt,
							distributionDate : dateFormat(nvl(objGICLS024.distributionDate, new Date()), "yyyy"),
							netRet : objCurrReserveDS.netRet,
							c022LossReserve : $F("txtLossReserve") == "" ? "0" : unformatCurrency("txtLossReserve"),
							c022ExpenseReserve : $F("txtExpenseReserve") == "" ? "0" : unformatCurrency("txtExpenseReserve"),
							bookingMonth : $F("txtBookingMonth"),
							bookingYear : $F("txtBookingYear"),
							remarks : escapeHTML2($F("txtRemarks"))
						},
						evalScripts : true,
						asynchronous : true,
						onCreate: showNotice("Please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)) {
								if (response.responseText == 'SUCCESS'){
									refreshDsTg();
								}
								
							}
						}
					});
		} catch (e) {
			showErrorMessage("updateShrLossResGICLS024", e);
		}
	}
	
	function validateShareLossRes(){
		if (parseFloat(objGICLS024.vars.totLossResAmt) > parseFloat(objCurrGICLItemPeril.giclClmResHist.lossReserve)){
			if(objCurrReserveDS.netRet == 'N'){
				showWaitingMessageBox('There is no Net Retention to get added loss reserve share amount.'+
	  		            'Unable to adjust distribution shares.', "E", refreshDsTg);
			}else{
				showConfirmBox("Confirmation", 'Distribution shares will be recomputed accordingly. Do you wish to continue? ', "Yes", "No", 
						function(){
							var checkLossRes = parseFloat($F("txtTrtyShrLoss").replace(/,/g, "")) - (parseFloat(objGICLS024.vars.totLossResAmt) - parseFloat(objCurrGICLItemPeril.giclClmResHist.lossReserve));
							if (parseFloat(checkLossRes) < 0){
								showWaitingMessageBox('Unable to adjust distribution shares. '+
				                           'Total share distribution exceeds 100%. ', "I", refreshDsTg);
							}else{
								updateShrLossResGICLS024();
							}
						},
						refreshDsTg);
			}
		}else if(parseFloat(objGICLS024.vars.totLossResAmt) < parseFloat(objCurrGICLItemPeril.giclClmResHist.lossReserve)){
			if(objCurrReserveDS.netRet == 'Y'){
				showConfirmBox("Confirmation", 'Distribution shares will be recomputed accordingly. Do you wish to continue? ', "Yes", "No", 
						updateShrLossResGICLS024,
						refreshDsTg);
			}else{
				showConfirmBox("Confirmation", 'There is no Net Retention to transfer deducted loss reserve share amount.'+
                        'The system is about to create Net Retention to recompute '+
                        'distribution shares. Do you want to continue? ', "Yes", "No", 
                        updateShrLossResGICLS024,
						refreshDsTg);
			}
		}
	}
	
	function updateShrPctGICLS024() {
		try {
			new Ajax.Request(
					contextPath + "/GICLReserveDsController",
					{
						method : "GET",
						parameters : {
							action : "updateShrPctGICLS024",
							claimId   : objCurrReserveDS.claimId,
							clmResHistId  : objCurrReserveDS.clmResHistId,
							itemNo  : objCurrGICLItemPeril.giclClmResHist.itemNo,
							perilCd  : objCurrGICLItemPeril.giclClmResHist.perilCd,
							grpSeqNo  : objCurrReserveDS.grpSeqNo,
							clmDistNo  : objCurrReserveDS.clmDistNo,
							lossReserve  : objCurrGICLItemPeril.giclClmResHist.lossReserve,
							totLossResAmt  : objGICLS024.vars.totLossResAmt,
							totExpResAmt  : objGICLS024.vars.totExpResAmt,
							totShrPct  : objGICLS024.vars.totShrPct,
							shrPct  : unformatCurrencyValue($F("txtTrtyShrPct")),
							annTsiAmt : objCurrGICLItemPeril.annTsiAmt,
							distributionDate : dateFormat(nvl(objGICLS024.distributionDate, new Date()), "yyyy"),
							netRet : objCurrReserveDS.netRet,
							c022LossReserve : $F("txtLossReserve") == "" ? "0" : unformatCurrency("txtLossReserve"),
							c022ExpenseReserve : $F("txtExpenseReserve") == "" ? "0" : unformatCurrency("txtExpenseReserve"),
							bookingMonth : $F("txtBookingMonth"),
							bookingYear : $F("txtBookingYear"),
							remarks : escapeHTML2($F("txtRemarks"))
						},
						evalScripts : true,
						asynchronous : true,
						onCreate: showNotice("Please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)) {
								if (response.responseText == 'SUCCESS'){
									refreshDsTg();
								}
								
							}
						}
					});
		} catch (e) {
			showErrorMessage("updateShrPctGICLS024", e);
		}
	}
	
	function validateSharePct(){
		if (parseFloat(objGICLS024.vars.totShrPct) > 100){
			if(objCurrReserveDS.netRet == 'N'){
				showWaitingMessageBox('There is no Net Retention to get added loss reserve share amount.'+
	  		            'Unable to adjust distribution shares.', "E", refreshDsTg);
			}else{
				showConfirmBox("Confirmation", 'Distribution shares will be recomputed accordingly. Do you wish to continue? ', "Yes", "No", 
						function(){
							var checkShrPct = parseFloat($F("txtTrtyShrPct").replace(/,/g, "")) - (parseFloat(objGICLS024.vars.totShrPct) - parseFloat(100));
							if (parseFloat(checkShrPct) < 0){
								showWaitingMessageBox('Unable to adjust distribution shares. '+
				                           'Total share distribution exceeds 100%. ', "I", refreshDsTg);
							}else{
								updateShrPctGICLS024();
							}
						},
						refreshDsTg);
			}
		}else if(parseFloat(objGICLS024.vars.totShrPct) < 100){
			if(objCurrReserveDS.netRet == 'Y'){
				showConfirmBox("Confirmation", 'Distribution shares will be recomputed accordingly. Do you wish to continue? ', "Yes", "No", 
						updateShrPctGICLS024,
						refreshDsTg);
			}else{
				showConfirmBox("Confirmation", 'There is no Net Retention to transfer deducted share percent to.'+
                        'The system is about to create Net Retention to recompute '+
                        'distribution shares. Do you want to continue? ', "Yes", "No", 
                        updateShrPctGICLS024,
                        refreshDsTg);
			}
		}
	}
	
	function updateShrExpResGICLS024() {
		try {
			new Ajax.Request(
					contextPath + "/GICLReserveDsController",
					{
						method : "GET",
						parameters : {
							action : "updateShrExpResGICLS024",
							claimId   : objCurrReserveDS.claimId,
							clmResHistId  : objCurrReserveDS.clmResHistId,
							itemNo  : objCurrGICLItemPeril.giclClmResHist.itemNo,
							perilCd  : objCurrGICLItemPeril.giclClmResHist.perilCd,
							grpSeqNo  : objCurrReserveDS.grpSeqNo,
							clmDistNo  : objCurrReserveDS.clmDistNo,
							expenseReserve  : objCurrGICLItemPeril.giclClmResHist.expenseReserve,
							totLossResAmt  : objGICLS024.vars.totLossResAmt,
							totExpResAmt  : objGICLS024.vars.totExpResAmt,
							shrExpResAmt  : unformatCurrencyValue($F("txtTrtyShrExp")),
							prevExpResAmt	: objGICLS024.vars.prevExpResAmt,
							annTsiAmt : objCurrGICLItemPeril.annTsiAmt,
							distributionDate : dateFormat(nvl(objGICLS024.distributionDate, new Date()), "yyyy"),
							netRet : objCurrReserveDS.netRet,
							c022LossReserve : $F("txtLossReserve") == "" ? "0" : unformatCurrency("txtLossReserve"),
							c022ExpenseReserve : $F("txtExpenseReserve") == "" ? "0" : unformatCurrency("txtExpenseReserve"),
							bookingMonth : $F("txtBookingMonth"),
							bookingYear : $F("txtBookingYear"),
							remarks : escapeHTML2($F("txtRemarks"))
						},
						evalScripts : true,
						asynchronous : true,
						onCreate: showNotice("Please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)) {
								if (response.responseText == 'SUCCESS'){
									refreshDsTg();
								}
								
							}
						}
					});
		} catch (e) {
			showErrorMessage("updateShrExpResGICLS024", e);
		}
	}
	
	function validateShareExpRes(){
		if (parseFloat(objGICLS024.vars.totExpResAmt) > parseFloat(objCurrGICLItemPeril.giclClmResHist.expenseReserve)){
			if(objCurrReserveDS.netRet == 'N'){
				showWaitingMessageBox('There is no Net Retention to get added expense reserve share amount.'+
	  		            'Unable to adjust distribution shares.', "E", refreshDsTg);
			}else{
				showConfirmBox("Confirmation", 'Distribution shares will be recomputed accordingly. Do you wish to continue? ', "Yes", "No", 
						function(){
							var checkLossRes = parseFloat($F("txtTrtyShrExp").replace(/,/g, "")) - (parseFloat(objGICLS024.vars.totExpResAmt) - parseFloat(objCurrGICLItemPeril.giclClmResHist.expenseReserve));
							if (parseFloat(checkLossRes) < 0){
								showWaitingMessageBox('Unable to adjust distribution shares. '+
				                           'Total share distribution exceeds 100%. ', "I", refreshDsTg);
							}else{
								updateShrExpResGICLS024();
							}
						},
						refreshDsTg);
			}
		}else if(parseFloat(objGICLS024.vars.totExpResAmt) < parseFloat(objCurrGICLItemPeril.giclClmResHist.expenseReserve)){
			if(objCurrReserveDS.netRet == 'Y'){
				showConfirmBox("Confirmation", 'Distribution shares will be recomputed accordingly. Do you wish to continue? ', "Yes", "No", 
						updateShrExpResGICLS024,
						refreshDsTg);
			}else{
				showConfirmBox("Confirmation", 'There is no Net Retention to transfer deducted expense reserve share amount.'+
                        'The system is about to create Net Retention to recompute '+
                        'distribution shares. Do you want to continue? ', "Yes", "No", 
                        updateShrExpResGICLS024,
						refreshDsTg);
			}
		}
	}
	
	function validateShare(){
		objGICLS024.vars.totShrPct = 0;
		objGICLS024.vars.totLossResAmt = 0;
		objGICLS024.vars.totExpResAmt = 0;
		for(var i = 0; i < objTrty.length; i++){
			if(objTrty[i].recordStatus != -1){
				objGICLS024.vars.totShrPct += parseFloat(objTrty[i].shrPct);
				objGICLS024.vars.totLossResAmt += parseFloat(objTrty[i].shrLossResAmt);
				objGICLS024.vars.totExpResAmt += parseFloat(objTrty[i].shrExpResAmt);
			}
		}
		if(triggerItem == 'SHR_LOSS_RES_AMT'){
			validateShareLossRes();
		}else if(triggerItem == 'SHR_EXP_RES_AMT'){
			validateShareExpRes();
		}else if(triggerItem == 'SHR_PCT'){
			validateSharePct();
		}
	}
	
	$("txtTrtyShrLoss").observe("change", function(){
		if(parseFloat($F("txtTrtyShrLoss").replace(/,/g, "")) > parseFloat(999999999999.99)){
			showWaitingMessageBox("Field must be of form 999,999,999,999.99", "I", function(){
				$("txtTrtyShrLoss").value 	=formatCurrency(objGICLS024.vars.prevLossResAmt);
				return false;
			});
		}
		triggerItem = 'SHR_LOSS_RES_AMT';
		checkXOLAmtLimits();
	});
	
	$("txtTrtyShrExp").observe("change", function(){
		if(parseFloat($F("txtTrtyShrExp").replace(/,/g, "")) > parseFloat(999999999999.99)){
			showWaitingMessageBox("Field must be of form 999,999,999,999.99", "I", function(){
				$("txtTrtyShrExp").value 	=formatCurrency(objGICLS024.vars.prevExpResAmt);
				return false;
			});
		}
		triggerItem = 'SHR_EXP_RES_AMT';
		checkXOLAmtLimits();
	});
	
	$("txtTrtyShrPct").observe("change", function(){
		if(parseFloat($F("txtTrtyShrPct").replace(/,/g, "")) > parseFloat(990.999999999)){
			showWaitingMessageBox("Field must be of form 990.999999999", "I", function(){
				$("txtTrtyShrPct").value 	=formatToNineDecimal(objCurrReserveDS.shrPct);
				return false;
			});
		}
		if(objCurrReserveDS.shareType==4){
			triggerItem = 'SHR_PCT';
			checkXOLAmtLimits();
		}
	});
	
	/* $("btnTrtyUpdate").observe("click", function(){
		
	}); */
	
	$("btnXOLDeductible").observe("click", showXolDeducOverlay);
	
	$("btnDistDtlsReturn").observe("click", function(){
		distDtlsOverlay.close();
		delete distDtlsOverlay;
	});
	
}catch(e){
	showErrorMessage("distribution details overlay.", e);
}
</script>