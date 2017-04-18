<div class="sectionDiv" id="claimReserveItemPerilTableGridSectionDiv" style="border: 0px;">
	<div id="claimReserveItemPerilDiv" name="claimReserveItemPerilDiv" style="width: 100%;">
		<div id="claimReserveItemPerilTableGridDiv" style="padding: 10px;">
				<div id="claimReserveItemPerilGrid" style="height: 185px; margin: 10px; margin-bottom: 5px; width: 880px;"></div>					
		</div>
	</div>
</div>
<div  id="claimReserveSectionDiv" class="sectionDiv" style="border: 0px;">
	<div style="margin-top: 10px;  margin-left:60px; float: left; width: 780px;  ">
		<table align="center" border="0">
			<tr>
				<td class="rightAligned"  width="120px">Loss Reserve</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="txtCRLossReserve" name="txtCRLossReserve" readonly="readonly" value="" class="money"  maxlength="18"/></td>
				<td class="rightAligned" width="250px">Losses Paid</td>
				<td class="leftAligned" width="150px"><input type="text" style="width: 250px;" id="txtCRLossesPaid" name="txtCRLossesPaid" readonly="readonly" value="" class="money" /></td>					
			</tr>
			<tr>
				<td class="rightAligned">Expense Reserve</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="txtCRExpenseReserve" name="txtCRExpenseReserve" readonly="readonly" value="" class="money"  maxlength = "18" /></td>
				<td class="rightAligned"><label style="float: right;">Expense Paid</label></td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="txtCRExpensesPaid" name="txtCRExpensesPaid" readonly="readonly" value="" class="money" /></td>
			</tr>
			<tr>
				<td class="rightAligned">Total Reserve</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="txtCRTotalReserve" name="txtCRTotalReserve" readonly="readonly" value="" class="money" /></td>
				<td class="rightAligned"><label style="float: right;">Total Claim Payment</label></td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="txtCRTotalClaimPayment" name="txtCRTotalClaimPayment" readonly="readonly" value="" class="money" /></td>
			</tr>
			<tr>
				<td colspan="6"><div style="border-top: 1.25px solid #c0c0c0; margin: 10px 0;"></div></td>
			</tr>
			<tr>
				<td class="rightAligned"  width="90px">History Number</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="txtCRHistoryNumber" name="txtCRHistoryNumber" readonly="readonly" value="" class="rightAligned"/></td>
				<td class="rightAligned" width="150px">Booking Date</td>
				<td class="leftAligned">
					<div style="width:250px; border: none;">
						<input type="text" style="width: 160px;" id="txtCRBookingMonth" name="txtCRBookingMonth" value="" readonly="readonly" class="upper applyChange" maxlength="10"/>
						<input type="text" style="width: 65px;" id="txtCRBookingYear" name="txtCRBookingYear" value="" class="rightAligned integerNoNegativeUnformattedNoComma" readonly="readonly" maxlength="4"/>
					</div>
				</td>					
			</tr>
			<tr>
				<td class="rightAligned">Convert Rate</td>
				<td class="leftAligned">
					<div>
						<input type="text" style="width: 120px; float: left;" id="txtCRConvertRate" name="txtCRConvertRate" readonly="readonly" value="" class="moneyRate"/>
						<label id="lblCurrency" style="float: left; font-weight: bolder; margin-top: 5px; margin-left: 10px;">&nbsp;</label>
					</div>
				</td>
				<td class="rightAligned"></td>
				<td class="leftAligned"><label id="lblDistType" style="float: left; font-weight: bolder;">&nbsp;</label></td>
			</tr>
			<tr>
				<td colspan="6"><div style="border-top: 1.25px solid #c0c0c0; margin: 10px 0;"></div></td>
			</tr>
			<tr>
				<td class="rightAligned"  width="220px">Remarks</td>
				<td class="leftAligned" colspan="3"  width="600px">
					<div style="border: 1px solid gray; height: 20px; width: 99.75%">
						<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtCRRemarks" name="txtCRRemarks" style="width: 95.5%; border: none; height: 13px; resize:none;" readonly="readonly"></textarea>
						<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editCRRemarks" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned"  width="120px">User Id</td>
				<td class="leftAligned"><input type="text" style="width: 120px;" id="txtCRUserId" name="txtCRUserId" readonly="readonly" value=""/></td>
				<td class="rightAligned" width="300px">Last Update</td>
				<td class="leftAligned" width="150px"><input type="text" style="width: 160px;" id="txtCRLastUpdate" name="txtCRLastUpdate" readonly="readonly" value=""/></td>					
			</tr>
		</table>
	</div>
	<div class="buttonsDiv" style="margin: 25px 0px;;">
		<input id="btnReserveDistDetails" name="btnReserveDistDetails" type="button" class="button" value="Reserve Distribution Details" width="150px;">
		<input id="btnPaymentHistory" 	  name="btnPaymentHistory" 	   type="button" class="button" value="Payment History" width="150px;">
		<input id="btnReserveHistory" 	  name="btnReserveHistory"     type="button" class="button" value="Reserve History" width="150px;">
	</div>
</div>

<script>
	try{
		var selectedRecord = null;
		var objClaimReserveItemPeril = JSON.parse('${jsonClaimReserveItemPeril}'.replace(/\\/g, '\\\\'));
		objClaimReserveItemPeril.giclItemPerilList = objClaimReserveItemPeril.rows || [];
		
		var giclItemPerilTableModel = {
			id: 'CRes',
			url : contextPath+ "/GICLClaimReserveController?action=showGICLS260ClaimReserve&claimId="+ objCLMGlobal.claimId,
			options : {
				title : '',
				width : '880px',
				pager: {}, 
				hideColumnChildTitle: true,
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh : function() {
						populateClaimReserveFields(null);
						claimReserveTableGrid.keys.removeFocus(claimReserveTableGrid.keys._nCurrentFocus, true);
						claimReserveTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus : function(element, value, x, y, id) {
					var giclItemPeril = claimReserveTableGrid.geniisysRows[y];
					populateClaimReserveFields(giclItemPeril);
					claimReserveTableGrid.keys.removeFocus(claimReserveTableGrid.keys._nCurrentFocus, true);
					claimReserveTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					populateClaimReserveFields(null);
					claimReserveTableGrid.keys.removeFocus(claimReserveTableGrid.keys._nCurrentFocus, true);
					claimReserveTableGrid.keys.releaseKeys();
				}
			},columnModel:[{
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false,
				editor : 'checkbox'
			},
			{
				id : 'divCtrId',
				width : '0',
				visible : false
			}, 
			{
				id : 'groupedItemNo',
				width : '0',
				visible : false
			}, 
			{
				id : 'itemNo dspItemTitle',
				title : 'Item',
				width : '210px',
				sortable : false,
				children : [
					{
						id : 'itemNo',
						title : 'Item No.',
						width : 50,							
						sortable : false,
						editable : false,	
						align: 'right',
						filterOption : true,
						filterOptionType: 'integerNoNegative'
					},
					{
						id : 'dspItemTitle',
						title : 'Item Title',
						width : 170,
						sortable : false,
						editable : false,
						filterOption : true
					}
				            ]					
			},	
			{
				id : 'perilCd dspPerilName',
				title : 'Peril',
				width : '210px',
				sortable : false,					
				children : [
					{
						id : 'perilCd',
						title : 'Peril Cd',
						width : 50,							
						sortable : false,
						editable : false,	
						align: 'right',
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{
						id : 'dspPerilName',
						title : 'Peril Name',
						width : 170,
						sortable : false,
						editable : false,
						fitlerOption : true
					}
				            ]					
			}, 
			{
				id : 'annTsiAmt',
				title : 'Total Sum Insured',
				titleAlign : 'center',
				type : 'number',
				width : '150px',
				geniisysClass : 'money',
				filterOption : true,
				filterOptionType : 'number'
			}, 
			{
				id : 'nbtCloseFlag',
				title : 'Loss Status',
				width : '130',
				editable : false,
				filterOption : true
			}, 
			{
				id : 'nbtCloseFlag2',
				title : 'Expense Status',
				width : '130',
				editable : false,
				filterOption : true
			}, 
			{
				id : 'noOfDays',
				width : '0',
				visible : false
			}, 
			{
				id : 'baseAmt',
				width : '0',
				visible : false
			}, 
			{
				id : 'allowTsiAmt',
				width : '0',
				visible : false
			}],
			rows : objClaimReserveItemPeril.giclItemPerilList
		};
			
		claimReserveTableGrid = new MyTableGrid(giclItemPerilTableModel);
		claimReserveTableGrid.pager = objClaimReserveItemPeril;
		claimReserveTableGrid.render('claimReserveItemPerilGrid');
		claimReserveTableGrid.afterRender = function(){
			populateClaimReserveFields(null);
		};
		
		function populateClaimReserveFields(giclItemPeril){
			if(giclItemPeril != null){
				selectedRecord = giclItemPeril;
				var reserve = giclItemPeril.giclClaimReserve;
				var clmResHist = giclItemPeril.giclClmResHist;
				setReserveInformation(reserve);
				setClaimReserveHistory(clmResHist);
				enableButton("btnReserveDistDetails");
				nvl(giclItemPeril.reserveDtlExist, "N") == "Y" ? enableButton("btnReserveHistory") : disableButton("btnReserveHistory");
				nvl(giclItemPeril.paymentDtlExist, "N") == "Y" ? enableButton("btnPaymentHistory") : disableButton("btnPaymentHistory");
			}else{
				selectedRecord = null;
				setReserveInformation(null);
				setClaimReserveHistory(null);
				disableButton("btnReserveDistDetails");
				disableButton("btnPaymentHistory");
				disableButton("btnReserveHistory");
			}
			
		}
		
		function setReserveInformation(obj){	
			var totalResAmount = null;
			var totalPaid = null;
			if(nvl(obj,null) != null){
				totalResAmount = parseFloat(nvl(obj.lossReserve,0)) + parseFloat(nvl(obj.expenseReserve,0));
				totalPaid = parseFloat(nvl(obj.lossesPaid,0)) + parseFloat(nvl(obj.expensesPaid,0));
			}
			
			$("txtCRLossReserve").value 		= nvl(obj,null) != null ? formatCurrency(obj.lossReserve) :null;
			$("txtCRLossesPaid").value 			= nvl(obj,null) != null ? formatCurrency(obj.lossesPaid) :null;
			$("txtCRExpenseReserve").value 		= nvl(obj,null) != null ? formatCurrency(obj.expenseReserve) :null;
			$("txtCRExpensesPaid").value 		= nvl(obj,null) != null ? formatCurrency(obj.expensesPaid) :null;
			$("txtCRTotalReserve").value 		= nvl(obj,null) != null ? formatCurrency(nvl(obj.dspTotalResAmount,nvl(totalResAmount,0))) : null; 
			$("txtCRTotalClaimPayment").value 	= nvl(obj,null) != null ? formatCurrency(nvl(obj.dspTotalPaid,nvl(totalPaid,0))) : null;
		}
		
		function setClaimReserveHistory(obj){
			$("txtCRHistoryNumber").value 	= nvl(obj, null) != null ? (nvl(obj.histSeqNo, null) != null ? obj.histSeqNo.toPaddedString(3) : null) : null;
			$("txtCRConvertRate").value 	= nvl(obj, null) != null ? formatToNineDecimal(obj.convertRate): null;
			$("txtCRBookingMonth").value 	= nvl(obj, null) != null ? unescapeHTML2(obj.bookingMonth): null;
			$("txtCRBookingYear").value 	= nvl(obj, null) != null ? obj.bookingYear: null;
			$("lblCurrency").innerHTML 		= nvl(obj, null) != null ? unescapeHTML2(obj.dspCurrencyDesc): null;
			$("txtCRRemarks").value 		= nvl(obj, null) != null ? unescapeHTML2(obj.remarks): null;
			$("txtCRUserId").value 			= nvl(obj, null) != null ? unescapeHTML2(obj.userId): null;
// 			$("txtCRLastUpdate").value 		= nvl(obj, null) != null ? (nvl(obj.lastUpdate, null) != null ? dateFormat(obj.lastUpdate, "mm-dd-yyyy hh:MM:ss TT") : null): null;
			$("txtCRLastUpdate").value 		= nvl(obj, null) != null ? (nvl(obj.lastUpdate, null) != null ? obj.sdfLastUpdate : null): null;//added by steven 06/03/2013;to handle the issue on formatting date.
			
			if(obj != null){
				if(nvl(obj.tranId, "") != ""){
					$("lblDistType").innerHTML = nvl(obj.cancelTag, "N") == "Y" ? "CANCELLED PAYMENT" : null;
				}else{
					$("lblDistType").innerHTML = nvl(obj.distSw, "N") == "Y" ? "DISTRIBUTED" : null;
				}
			}else{
				$("lblDistType").innerHTML = null;
			}
		}
		
		function showPopupClaimReserveListing(action1,title,width,height){
			if(selectedRecord == null){
				showMessageBox("Please select a record first.", "I");
				return false;
			}
			
			var contentDiv = new Element("div", {id : "modal_content_lov"});
		    var contentHTML = '<div id="modal_content_lov"></div>';
		    claimReservePopupGrid = Overlay.show(contentHTML, {
								id: 'modal_dialog_lov',
								title: nvl(title,""),
								width: nvl(width,700),
								height: nvl(height,340),
								draggable: false,
								closable: true
							});
		    
		    new Ajax.Updater("modal_content_lov", contextPath+"/GICLClaimReserveController?action=showGICLS260ClaimReserveOverlay", {
				evalScripts: true,
				asynchronous: false,
				parameters:{
					action1: action1,
					claimId: objCLMGlobal.claimId,
					itemNo: selectedRecord.itemNo,
					perilCd: selectedRecord.perilCd,
					groupedItemNo: selectedRecord.groupedItemNo,
					clmResHistId: selectedRecord.giclClmResHist.clmResHistId,
					ajax: 1
				},
				onCreate: function(){
					showNotice("Loading, please wait...");
				},
				onComplete: function (response) {			
					hideNotice();
					if (!checkErrorOnResponse(response)) {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
		
		$("editCRRemarks").observe("click", function(){showEditor("txtCRRemarks", 4000, 'true');});
		
		// Reserve Distribution Details
		$("btnReserveDistDetails").observe("click", function(){
			showPopupClaimReserveListing("getGiclReserveDsGrid3", "Reserve Distribution Details", 800, 450);
		});
		
		// Payment History
		$("btnPaymentHistory").observe("click", function(){
			showPopupClaimReserveListing("getPaymentHistoryGrid", "Payment History", 705, 350);
		});
		
		// Reserve History
		$("btnReserveHistory").observe("click", function(){
			showPopupClaimReserveListing("getResHistTranIdNull", "Reserve History", 700, 350);
		});
		
	}catch(e){
		showErrorMessage("Claim Information - Claim Reserve");
	}
	
</script>