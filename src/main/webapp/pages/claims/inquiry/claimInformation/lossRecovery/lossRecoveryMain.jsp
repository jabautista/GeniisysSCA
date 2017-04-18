<div class="sectionDiv" id="clmRecoveryTableGridSectionDiv" style="border-top: 0px; border-left: 0px; border-right: 0px;">
	<div id="clmRecoveryDiv" name="clmRecoveryDiv" style="width: 100%;">
		<div id="clmRecoveryTableGridDiv" style="padding: 10px;">
			<div id="clmRecoveryGrid" style="height: 185px; margin: 10px; margin-bottom: 5px; width: 880px;"></div>					
		</div>
	</div>
	<div id="clmRecoveryButtonDiv" class="sectionDiv" style="width: 100%; border: 0; margin-bottom: 15px;" align="center">
		<table border="0">
			<tr>
				<td class="rightAligned">Lawyer</td>
				<td class="leftAligned">
					<input id="txtLawyerCd"    name="txtLawyerCd"   type="text" style="width: 70px;"  value="" readonly="readonly"/>
					<input id="txtLawyerName"  name="txtLawyerName" type="text" style="width: 250px;" value="" readonly="readonly" />
				</td>
				<td class="rightAligned" style="width: 90px;">Plate Number</td>
				<td class="leftAligned"><input type="text" id="txtRecPlateNo" name="txtRecPlateNo" style="width: 150px;" class="allCaps" maxlength="10" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="rightAligned">Third Party Item Description</td>
				<td class="leftAligned" colspan="3">
					<div style="float:left; width: 600px;" class="withIconDiv">
						<textarea id="txtTpItemDesc" name="txtTpItemDesc" style="width: 570px; resize:none;" class="withIcon allCaps" readonly="readonly"> </textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtTpItemDesc" />
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>
<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Payor Details</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="recoveryPayorTableGridSectionDiv" style="border-top: 0px; border-left: 0px; border-right: 0px;">
	<div id="recoveryPayorDiv" name="recoveryPayorDiv" style="width: 100%;">
		<div id="recoveryPayorTableGridDiv" style="padding: 10px 45px;">
			<div id="recoveryPayorGrid" style="height: 185px; margin: 10px; margin-bottom: 5px; width: 810px;"></div>					
		</div>
	</div>
</div>
<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Recovery History</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="recHistTableGridSectionDiv" style="border: 0px;">
	<div id="recHistDiv" name="recHistDiv" style="width: 100%;">
		<div id="recHistTableGridDiv" style="padding: 10px;">
			<div id="recHistGrid" style="height: 185px; margin: 10px; margin-bottom: 5px; width: 880px;"></div>					
		</div>
	</div>
	<div id="recHistButtonDiv" class="sectionDiv" style="width: 100%; border: 0; margin-bottom: 15px;" align="center">
		<input type="button" id="btnPaymentDetails"	 name="btnPaymentDetails"  style="width: 150px;"  class="disabledButton"	value="Payment Details" />
	</div>
</div>

<script type="text/javascript">
	try{
		initializeAccordion();
		
		var objClmRecovery = JSON.parse('${jsonGiclClmRecovery}');
		var currClmRecovery = null;
		
		var clmRecoveryTableModel = {
			id : 'Crec',
			url : contextPath + "/GICLClmRecoveryController?action=showGICLS260LossRecovery&claimId="+ nvl(objCLMGlobal.claimId, 0),
			options:{
				title: '',
				pager: { },
				width: '880px',
				hideColumnChildTitle: true,
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function(){
						currClmRecovery = null;
						setGICLClmRecoverySubDetails(null);
						clmRecoveryTableGrid.keys.removeFocus(clmRecoveryTableGrid.keys._nCurrentFocus, true);
						clmRecoveryTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					currClmRecovery = clmRecoveryTableGrid.geniisysRows[y];
					setGICLClmRecoverySubDetails(currClmRecovery);
					clmRecoveryTableGrid.keys.removeFocus(clmRecoveryTableGrid.keys._nCurrentFocus, true);
					clmRecoveryTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function() {
					currClmRecovery = null;
					setGICLClmRecoverySubDetails(null);
					clmRecoveryTableGrid.keys.removeFocus(clmRecoveryTableGrid.keys._nCurrentFocus, true);
					clmRecoveryTableGrid.keys.releaseKeys();
				},
				onSort: function() {
					currClmRecovery = null;
					setGICLClmRecoverySubDetails(null);
					clmRecoveryTableGrid.keys.removeFocus(clmRecoveryTableGrid.keys._nCurrentFocus, true);
					clmRecoveryTableGrid.keys.releaseKeys();
				}
			},
			columnModel: [
				{
				    id: 'recordStatus',
				    title : '',
		            width: '0',
		            visible: false,
		            editor: "checkbox"
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false
				},
	        	{
	    		    id: 'lineCd recYear recSeqNo',
	    		    title: 'Recovery Number',
	    		    width : '217px',
	    		    children : [
	    	            {
	    	                id : 'lineCd',
	    	                title: 'Line Code',
	    	                width: 30,
	    	                filterOption: true,
	    	                defaultValue: objCLMGlobal.lineCd
	    	            },
	    	            {
	    	                id : 'recYear',
	    	                title: 'Recovery Year',
	    	                type: "number",
	    	                align: "right",
	    	                width: 40,
	    	                filterOption: true,
	    		            filterOptionType: 'number' 
	    	            },
	    	            {
	    	                id : 'recSeqNo',
	    	                title: 'Recovery Sequence Number',
	    	                type: "number",
	    	                align: "right",
	    	                width: 66,
	    	                filterOption: true,
	    		            filterOptionType: 'number',
	    	                renderer: function (value){
	    						return nvl(value,'') == '' ? '' :formatNumberDigits(value,3);
	    					}
	    	            }
	    	    	]        
	    		},
	        	{
	    		    id: 'recTypeCd dspRecTypeDesc',
	    		    title: 'Recovery Type',
	    		    width : '170px',
	    		    children : [
	    	            {
	    	                id : 'recTypeCd',
	    	                title: 'Recovery Type Code',
	    	                width: 50,
	    	                filterOption: true
	    	            },
	    	            {
	    	                id : 'dspRecTypeDesc', 
	    	                title: 'Recovery Type Desc',
	    	                width: 120,
	    	                filterOption: true
	    	            }
	    	        ]
	        	},
	        	{
	        		id: 'dspCurrencyDesc',
	        		title: 'Currency',
	        		width: '150',
	        		filterOption: true
	        	},
	        	{
	        		id: 'convertRate',
	        		title: 'Rate',
	        		titleAlign: 'right',
	        		align: 'right',
	        		width: '100',
	        		geniisysClass: 'rate',
		            deciRate: 9,
		            filterOption: true,
		            filterOptionType: 'number' 	
	        	},
	        	{
	        		id: 'recoverableAmt',
	        		title: 'Recoverable Amt.',
	        		titleAlign: 'right',
	        		align: 'right',
	        		width: '150',
	        		geniisysClass: 'money'
	        	},
	        	{
	        		id: 'recoveredAmt',
	        		title: 'Recovered Amt.',
	        		titleAlign: 'right',
	        		align: 'right',
	        		width: '150',
	        		geniisysClass: 'money'
	        	}
			],
			rows : objClmRecovery.rows,
			requiredColumns: ''
		};
		
		clmRecoveryTableGrid = new MyTableGrid(clmRecoveryTableModel);
		clmRecoveryTableGrid.pager = objClmRecovery;
		clmRecoveryTableGrid.render('clmRecoveryGrid');
		
		var recoveryPayorTableModel = {
				id : 'CPay',
				url : contextPath+"/GICLClmRecoveryController?action=refreshGICLS260RecoveryPayor"
						+"&claimId="+ nvl(objCLMGlobal.claimId, 0)+"&recoveryId=0",
				options:{
					title: '',
					pager: { },
					hideColumnChildTitle: true,
					width: '810px',
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onRefresh: function(){
							recoveryPayorTableGrid.keys.removeFocus(recoveryPayorTableGrid.keys._nCurrentFocus, true);
							recoveryPayorTableGrid.keys.releaseKeys();
						}
					},
					onCellFocus: function(element, value, x, y, id){
						recoveryPayorTableGrid.keys.removeFocus(recoveryPayorTableGrid.keys._nCurrentFocus, true);
						recoveryPayorTableGrid.keys.releaseKeys();
						
					},
					onRemoveRowFocus: function() {
						recoveryPayorTableGrid.keys.removeFocus(recoveryPayorTableGrid.keys._nCurrentFocus, true);
						recoveryPayorTableGrid.keys.releaseKeys();
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
					    id: 'recordStatus',
					    title : '',
			            width: '0',
			            visible: false,
			            editor: "checkbox"
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false
					},	
					{
					    id: 'payorClassCd classDesc',
					    title: 'Payor Class',
					    width : '250px',
					    children : [
				            {
				                id : 'payorClassCd',
				                title: 'Payor Class Code',
				                type: 'number',
				                width: 75,
				                filterOption: true,
				                filterOptionType: 'integer' 
				            },
				            {
				                id : 'classDesc', 
				                title: 'Payor Class Description',
				                width: 175,
				                filterOption: true
				            }
						]
					},
					{
					    id: 'payorCd payorName',
					    title: 'Payor',
					    width : '375px',
					    children : [
				            {
				                id : 'payorCd',
				                title: 'Payor Code',
				                type: 'number',
				                width: 75,
				                filterOption: true,
				                filterOptionType: 'integer'
				            },
				            {
				                id : 'payorName', 
				                title: 'Payor Name',
				                width: 300,
				                filterOption: true
				            } 
						]
					}, 
					{
						id: 'recoveredAmt',
						title: 'Recovered Amount',
						type: 'number',
						geniisysClass: 'money',
						width: '165',
						visible: true,
						filterOption: true,
						filterOptionType: 'number' 		
					}
				],
				rows : [],
				requiredColumns: ''
			};
			
			recoveryPayorTableGrid = new MyTableGrid(recoveryPayorTableModel);
			recoveryPayorTableGrid.render('recoveryPayorGrid');
			
			var recHistTableModel = {
					id : 'Chis',
					url : contextPath+"/GICLClmRecoveryController?action=refreshGICLS260GiclLRecHist"
						  +"&claimId="+ nvl(objCLMGlobal.claimId, 0)+"&recoveryId=0",
					options:{
						title: '',
						pager: { },
						width: '880px',
						hideColumnChildTitle: true,
						toolbar: {
							elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
							onRefresh: function(){
								recHistTableGrid.keys.removeFocus(recHistTableGrid.keys._nCurrentFocus, true);
								recHistTableGrid.keys.releaseKeys();
							}
						},
						onCellFocus: function(element, value, x, y, id){
							recHistTableGrid.keys.removeFocus(recHistTableGrid.keys._nCurrentFocus, true);
							recHistTableGrid.keys.releaseKeys();
						},
						onRemoveRowFocus: function() {
							recHistTableGrid.keys.removeFocus(recHistTableGrid.keys._nCurrentFocus, true);
							recHistTableGrid.keys.releaseKeys();
						}
					},
					columnModel: [
						{
						    id: 'recordStatus',
						    title : '',
				            width: '0',
				            visible: false,
				            editor: "checkbox"
						},
						{
							id: 'divCtrId',
							width: '0',
							visible: false
						},
						{
							id: 'recHistNo',
							title: 'History',
							width: '75',
							type: 'number',
							align: 'right',
							renderer: function (value){
								return nvl(value,'') == '' ? '' :formatNumberDigits(value,3);
							},
							visible: true,
							filterOption: true,
							filterOptionType: 'integer' 
						},	
						{
						    id: 'recStatCd dspRecStatDesc',
						    title: 'Recovery Status',
						    width : '245px',
						    children : [
					            {
					                id : 'recStatCd',
					                title: 'Status Code',
					                width: 65,
					                filterOption: true
					            },
					            {
					                id : 'dspRecStatDesc', 
					                title: 'Status Description',
					                width: 180,
					                filterOption: true
					            }
							]
						},
						{
							id: 'remarks',
							title: 'Remarks',
							width: '310',
							visible: true,
							filterOption: true
						},
						{
							id: 'userId',
							title: 'User Id',
							width: '100',
							visible: true,
							filterOption: true
						},
						{
							id: 'strLastUpdate',
							title: 'Last Update',
							width: '130', 
							visible: true,
							filterOption: true,
							filterOptionType: 'formattedDate',
							format: 'mm-dd-yyyy'
						}
					],
					rows : [],
					requiredColumns: ''
				};
				
				recHistTableGrid = new MyTableGrid(recHistTableModel);
				recHistTableGrid.render('recHistGrid');
				disableButton("btnPaymentDetails");
				
		function setGICLClmRecoverySubDetails(obj){
			$("txtLawyerCd").value = obj == null ? "" : obj.lawyerCd;
			$("txtLawyerName").value = obj == null ? "" : unescapeHTML2(obj.dspLawyerName);
			$("txtRecPlateNo").value = obj == null ? "" : unescapeHTML2(obj.plateNo);
			$("txtTpItemDesc").value = obj == null ? "" : unescapeHTML2(obj.tpItemDesc);
			obj == null ? disableButton("btnPaymentDetails") : enableButton("btnPaymentDetails"); 
			
			recoveryPayorTableGrid.url = contextPath+"/GICLClmRecoveryController?action=refreshGICLS260RecoveryPayor"
										 +"&claimId="+ nvl(objCLMGlobal.claimId, 0)+"&recoveryId="+(obj == null ? "0" : nvl(obj.recoveryId, 0));
			recoveryPayorTableGrid._refreshList();
			recHistTableGrid.url = contextPath+"/GICLClmRecoveryController?action=refreshGICLS260GiclLRecHist"
						 		   +"&claimId="+ nvl(objCLMGlobal.claimId, 0)+"&recoveryId="+(obj == null ? "0" : nvl(obj.recoveryId, 0));
			recHistTableGrid._refreshList();
		}
		
		$("editTxtTpItemDesc").observe("click", function(){
			showEditor("txtTpItemDesc", 4000, 'true');
		});
		
		$("btnPaymentDetails").observe("click", function(){
			if(currClmRecovery == null){
				showMessageBox("Please select recovery record first.", "I");
				return false;
			}
			overlayRecPayt = Overlay.show(contextPath+"/GICLRecoveryPaytController", {
				urlContent: true,
				urlParameters: {action : "showGICLS260RecoveryPayt",
								claimId : objCLMGlobal.claimId,
								recoveryId: currClmRecovery.recoveryId,
								ajax: 1},
				title: "Payment Details",	
				id: "rec_payt_canvas",
				width: 850,
				height: 290,
				showNotice: true,
			    draggable: false,
			    closable: true
			});
		});
		
	}catch(e){
		showErrorMessage("Claim Information - Loss Recovery", e);
	}

</script>