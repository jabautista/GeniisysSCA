<div id="recPaytDetailsMainDiv" name="recPaytDetailsMainDiv">
	<div id="recPaytDetailsTableGridDiv" style="margin: 10px 12px">
		<div id="recPaytDetailsGridDiv" style="height: 225px; margin-top: 5px;">
			<div id="recPaytDetailsTableGrid" style="height: 225px; width: 825px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="hidden" id="hidRecoveryId"  	name="hidRecoveryId" 	value="${recoveryId}">
			<input type="button" id="btnRecoveyDist" 	name="btnRecoveyDist" 	style="width: 120px;"   class="disabledButton hover"  value="Distribution" />
			<input type="button" id="btnRecOk" 			name="btnRecOk" 		style="width: 120px;" 	class="button hover"	value="Return" 	/>
		</div>
	</div>
</div>

<script type="text/javascript">
	try{
		var objRecoveryPayt = JSON.parse('${jsonRecoveryPayt}');
		objRecoveryPayt.recoveryPaytListing = objRecoveryPayt.rows || [];
		var selectedRecord = null;
		
		var recPaytTableModel = {
			url : contextPath + "/GICLRecoveryPaytController?action=showGICLS260RecoveryPayt"+
				  "&claimId="+ nvl(objCLMGlobal.claimId, 0)+"&recoveryId="+$("hidRecoveryId").value,
			options:{
				title: '',
				pager: { },
				width: '825px',
				hideColumnChildTitle: true,
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN],
					onRefresh: function(){
						selectedRecord = null;
						disableButton("btnRecoveyDist");
						recPaytTableGrid.keys.removeFocus(recPaytTableGrid.keys._nCurrentFocus, true);
						recPaytTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					selectedRecord = recPaytTableGrid.geniisysRows[y];
					nvl(selectedRecord.dspCheckDist, "N") == "Y" ? enableButton("btnRecoveyDist") : disableButton("btnRecoveyDist");
					recPaytTableGrid.keys.removeFocus(recPaytTableGrid.keys._nCurrentFocus, true);
					recPaytTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function() {
					selectedRecord = null;
					disableButton("btnRecoveyDist");
					recPaytTableGrid.keys.removeFocus(recPaytTableGrid.keys._nCurrentFocus, true);
					recPaytTableGrid.keys.releaseKeys();
				},
				onSort: function() {
					selectedRecord = null;
					disableButton("btnRecoveyDist");
					recPaytTableGrid.keys.removeFocus(recPaytTableGrid.keys._nCurrentFocus, true);
					recPaytTableGrid.keys.releaseKeys();
				}
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
	            {
	                id : 'dspRefCd', 
	                title: 'Reference No.',
	                width: 125,
	                filterOption: true
	            },     
				{
				    id: 'payorClassCd payorCd dspPayorName',
				    title: 'Payor',
				    width : '370px',
				    children : [
						{
						    id : 'payorClassCd',
						    title: 'Payor Class Code',
						    type: 'number',
						    width: 40,
						    filterOption: true,
						    filterOptionType: 'integer' 
						},        
			            {
			                id : 'payorCd',
			                title: 'Payor Code',
			                type: 'number',
			                width: 60,
			                filterOption: true,
			                filterOptionType: 'integer' 
			            },
			            {
			                id : 'dspPayorName', 
			                title: 'Payor Name',
			                width: 280,
			                filterOption: true
			            }
					]
				},
		        {
					id: 'recoveredAmt',
					title: 'Recovered Amount',
					titleAlign: 'right',
					width: 150,
					maxlength: 19,
					editable: false,
					align: 'right',
					geniisysClass: 'money',
		            filterOption: true,
		            filterOptionType: 'number' 
		        },
		        {
	                id : 'tranDate', 
	                width: '0px',
	                filterOption: true,
	                type: 'date',
	                visible: false
	            },
	            {
	                id : 'sdfTranDate',  //added by steven 6/3/2013 
	                title: 'Recovery Date',
	                width: 100
	            },
				{
		            id: 'cancelTag',
		            title: '&#160;C',
		            altTitle: '',
		            titleAlign: 'center',
		            width: 22,
		            maxlength: 1, 
		            sortable: false, 
				   	hideSelectAllBox: true,
				   	editor: new MyTableGrid.CellCheckbox({ 
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	}
				   	})
				},
				{
		            id: 'distSw',
		            title: '&#160;D',
		            altTitle: '',
		            titleAlign: 'center',
		            width: 22,
		            maxlength: 1, 
		            sortable: false, 
				   	hideSelectAllBox: true,
				   	editor: new MyTableGrid.CellCheckbox({ 
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	}
				   	})
				}
			],
			rows : objRecoveryPayt.recoveryPaytListing,
			requiredColumns: ''
		};
		
		recPaytTableGrid = new MyTableGrid(recPaytTableModel);
		recPaytTableGrid.pager = objRecoveryPayt;
		recPaytTableGrid.render('recPaytDetailsTableGrid');
		
		$("btnRecOk").observe("click", function(){
			Windows.close("rec_payt_canvas");
		});
		
		$("btnRecoveyDist").observe("click", function(){
			if(selectedRecord == null){
				showMessageBox("Please select record first.", "I");
				return false;
			}
			
			overlayDist = Overlay.show(contextPath+"/GICLRecoveryPaytController", {
				urlContent: true,
				urlParameters: {action : "showGICLS260RecoveryDist",
								claimId : objCLMGlobal.claimId,
								recoveryId: selectedRecord.recoveryId,
								recoveryPaytId: selectedRecord.recoveryPaytId,
								ajax: 1
				},
				title: "View Distribution Details",	
				id: "view_dist_canvas",
				width: 800,
				height: 450,
				showNotice: true,
			    draggable: false,
			    closable: true
			});
		});
		
	}catch(e){
		showErrorMessage("Claim Information - Loss Recovery - Payment Details", e);
	}
</script>