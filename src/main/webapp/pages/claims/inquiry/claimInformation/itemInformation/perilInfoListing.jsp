<div id="perilListingDiv" name="perilListingDiv" style="width: 100%;">
	<div id="perilListingTableGridDiv" style="padding: 10px 50px;">
		<div id="perilListingGrid" style="height: 185px; margin: 10px; margin-bottom: 5px; width: 800px;"></div>					
	</div>
</div>

<script type="text/javascript">
	try{
		var claimPerilTableModel = {
			id : 'PRL',
			url : contextPath + "/GICLItemPerilController?action=getItemPerilGrid&claimId="+ nvl(objCLMGlobal.claimId, 0)
								+"&lineCd="+(objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : $("lineCd").value),
			options : {
				title : '',
				width : '800px',
				pager: {}, 
				hideColumnChildTitle: true,
				toolbar : {
					elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onRefresh : function() {
						claimPerilTableGrid.keys.removeFocus(claimPerilTableGrid.keys._nCurrentFocus, true);
						claimPerilTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus : function(element, value, x, y, id) {
					claimPerilTableGrid.keys.removeFocus(claimPerilTableGrid.keys._nCurrentFocus, true);
					claimPerilTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					claimPerilTableGrid.keys.removeFocus(claimPerilTableGrid.keys._nCurrentFocus, true);
					claimPerilTableGrid.keys.releaseKeys();
				},
				onSort : function() {
					claimPerilTableGrid.keys.removeFocus(claimPerilTableGrid.keys._nCurrentFocus, true);
					claimPerilTableGrid.keys.releaseKeys();
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
		            id: 'histIndicator',
		            title: '&#160;&#160;R',
		            altTitle: 'With Reserve',
		            width: 25,
		            maxlength: 1,
		            sortable:	false,
		            defaultValue: false,	
		            otherValue: false,
		            editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "U";
		            		}else{
								return "D";	
		            		}	
		            	}
		            })
		        },
			   	{
					id: 'perilCd dspPerilName',
					title: 'Peril',
					width : 250,
					children : [
			            {
			                id : 'perilCd',
			                title: 'Peril Code',
			                width : 50,
			                editable: false,
			                filterOption: true,
			                filterOptionType: 'integerNoNegative'
			            },
			            {
			                id : 'dspPerilName',
			                title: 'Peril Name',
			                width : 240,
			                editable: false,
			                filterOption: true
			            }
					]
				},
			   	{
					id: 'lossCatCd dspLossCatDes',
					title: 'Loss Category',
					width : 250,
					children : [
			            {
			                id : 'lossCatCd',
			                title : 'Loss Category Code',
			                width : 50,
			                editable: false,
			                filterOption: true
			            },
			            {
			                id : 'dspLossCatDes',
			                title : 'Loss Category Desc',
			                width : 240,
			                editable: false,
			                filterOption: true
			            }
					]
				} ,
				{
				   	id: 'aggregateSw',
				   	title: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? '&#160;A' : '' ,
				   	altTitle: 'Aggregate Switch',
				   	align: 'center',
				   	width: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? '20' : '0' ,
				   	visible: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? true : false 
				},
				{
				   	id: 'allowTsiAmt',
				   	title: 'Allowable TSI',
					type : 'number',
				  	width: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? 160 : '0',
				  	geniisysClass : 'money',
				   	visible: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? true : false,
				   	filterOption: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? true : false,
				   	filterOptionType: 'number'
				},
				{
				   	id: 'annTsiAmt',
				   	title: 'Total Sum Insured',
				   	type : 'number',
				  	width: objCLMGlobal.lineCd == objLineCds.AC|| objCLMGlobal.menuLineCd == 'AC' ? '0' : 160,
				  	geniisysClass : 'money',
				  	visible: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? false : true,
				  	filterOption: objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == 'AC' ? false : true,
				  	filterOptionType: 'number'
				}
			],
			rows : []
		};
			
		claimPerilTableGrid = new MyTableGrid(claimPerilTableModel);
		claimPerilTableGrid.render('perilListingGrid');	
	}catch(e){
		showErrorMessage("Claims Information - Peril Information", e);
	}
</script>