<div id="thirdAdverseMainDiv" name="thirdAdverseMainDiv">
	<div id="thirdAdverseTableGridDiv" style="margin: 10px 12px">
		<div id="thirdAdverseGridDiv" style="height: 225px; margin-top: 5px;">
			<div id="thirdAdverseTableGrid" style="height: 210px; width: 810px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="button" id="btnOk" 		 name="btnOk" 		   style="width: 120px;" class="button hover"  value="Return" />
			<input type="button" id="btnMcOtherDtls" name="btnMcOtherDtls" style="width: 120px;" class="disabledButton hover"  value="Other Details" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try{
		var objThirdAdverse = JSON.parse('${jsonGiclMcTPDtl}');
		objThirdAdverse.giclMcTpDtlListing = objThirdAdverse.rows || [];
		var selectedRecord = null;
		
		var thirdAdverseTableModel = {
			url : contextPath + "/GICLMotorCarDtlController?action=showGICLS260ThirdAdverseParty&claimId="+ nvl(objCLMGlobal.claimId, 0)
					          + "&sublineCd="+objCLMGlobal.sublineCd+"&itemNo="+$("txtItemNo").value,
			options : {
				title : '',
				width : '810px',
				pager: {}, 
				hideColumnChildTitle: true,
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN],
					onRefresh : function() {
						selectedRecord = null;
						disableButton("btnMcOtherDtls");
						thirdAdverseTableGrid.keys.removeFocus(thirdAdverseTableGrid.keys._nCurrentFocus, true);
						thirdAdverseTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus : function(element, value, x, y, id) {
					selectedRecord = thirdAdverseTableGrid.geniisysRows[y];
					var tpType = nvl(selectedRecord.tpType, "T");
					(tpType == "T" ||  tpType == "A") ? enableButton("btnMcOtherDtls") : disableButton("btnMcOtherDtls");
					thirdAdverseTableGrid.keys.removeFocus(thirdAdverseTableGrid.keys._nCurrentFocus, true);
					thirdAdverseTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					selectedRecord = null;
					disableButton("btnMcOtherDtls");
					thirdAdverseTableGrid.keys.removeFocus(thirdAdverseTableGrid.keys._nCurrentFocus, true);
					thirdAdverseTableGrid.keys.releaseKeys();
				},
				onSort : function() {
					selectedRecord = null;
					disableButton("btnMcOtherDtls");
					thirdAdverseTableGrid.keys.removeFocus(thirdAdverseTableGrid.keys._nCurrentFocus, true);
					thirdAdverseTableGrid.keys.releaseKeys();
				}
			},
			columnModel:[
			   {
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
					id: 'classDesc payeeName',
					title: 'Third Party/Adverse Party',
					titleAlign : 'center',
					width: 300,
					sortable: true,
					align : 'center',
					children: [
						{
							id : 'classDesc',
							width: 100,
							visible: true,
							maxlength: 10,
							editable: false
						},{
							id : 'payeeName',
			                width :230,
			                editable: false,
			                sortable: false		
						}           
					]
				},
				{
					id : 'payeeAddress',
	                width : 350,
	                title: 'Address',
	                editable: false,
	                sortable: true		
				},
				{
					id:"tpType",
					sortable:false,
					editable:false,
					align: 'center',
					title: '&#160;&#160;T',
					altTitle: 'Third Party',
					width: '27px',
					defaultValue: false,
					otherValue: false,
					radioGroup: 'tpTypeGroup',
					editor: new MyTableGrid.CellRadioButton({
						getValueOf: function (value){
							if (value){
								return "T";
							}
						}
					})
				},
				{
					id:"tpType",
					sortable:false,
					editable:false,
					align: 'center',
					title: '&#160;&#160;A',
					altTitle: 'Adverse Party',
					width: '27px',
					defaultValue: false,
					otherValue: false,
					radioGroup: 'tpTypeGroup',
					editor: new MyTableGrid.CellRadioButton({
						getValueOf: function (value){
							if (value){
								return "A";
							} 
						}
					})
				},
				{
					id:"tpType",
					sortable:false,
					editable:false,
					align: 'center',
					title: '&#160;&#160;B',
					altTitle: 'Bodily Injured Third Party',
					width: '27px',
					defaultValue: false,
					otherValue: false,
					radioGroup: 'tpTypeGroup',
					editor: new MyTableGrid.CellRadioButton({
						getValueOf: function (value){
							if (value){
								return "B";
							}
						}
					})
				},
				{
					id:"tpType",
					sortable:false,
					editable:false,
					align: 'center',
					title: '&#160;&#160;P',
					altTitle: 'Property Damage Third Party',
					width: '27px',
					defaultValue: false,
					otherValue: false,
					radioGroup: 'tpTypeGroup',
					editor: new MyTableGrid.CellRadioButton({
						getValueOf: function (value){
							if (value){
								return "P";
							} 
						}
					})
				}
			],
			rows : objThirdAdverse.giclMcTpDtlListing
		};
			
		thirdAdverseTableGrid = new MyTableGrid(thirdAdverseTableModel);
		thirdAdverseTableGrid.pager = objThirdAdverse;
		thirdAdverseTableGrid.render('thirdAdverseTableGrid');
		
		$("btnOk").observe("click", function(){
			Windows.close("third_adverse_canvas");
		});
		
		$("btnMcOtherDtls").observe("click", function(){
			if(selectedRecord == null){
				showMessageBox("Please select a record first.", "I");
				return false;
			}
			
			overlayMcOtherDtls = Overlay.show(contextPath+"/GICLMotorCarDtlController", {
				urlContent: true,
				urlParameters: {action : "showGICLS260ThirdAdvOtherDtls",
								claimId : objCLMGlobal.claimId,
								itemNo: $("txtItemNo").value,
								payeeClassCd: selectedRecord.payeeClassCd,
								payeeNo: selectedRecord.payeeNo,
								sublineCd: objCLMGlobal.sublineCd,
								ajax: 1},
				title: "Other Details",	
				id: "mc_other_dtls_canvas",
				width: 725,
				height: 370,
			    draggable: false,
			    closable: true
			});
		});
		
	}catch(e){
		showErrorMessage("Claims Information - Third Adverse Party", e);
	}
	
</script>