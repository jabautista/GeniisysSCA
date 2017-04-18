<div id="policyByAssuredTableGridSectionDiv" class="sectionDiv" style="border: none;">
		<div id="policyByAssuredTableGridDiv" class="sectionDiv" style="border: none;">
			<div id="policyByAssuredListing" class="sectionDiv" style="border: none; height:281px;width:856px;"></div>
		</div>
</div>

<script type="text/javascript" src="underwriting.js">
	var policyByAssuredSelectedIndex;
	var objPolicyByAssured = new Object();
	objPolicyByAssured.objPolicyByAssuredListTableGrid = JSON.parse('${policyListByAssured}'.replace(/\\/g, '\\\\'));
	objPolicyByAssured.objPolicyByAssuredList = objPolicyByAssured.objPolicyByAssuredListTableGrid.rows || [];

	try{
		var policyByAssuredTableModel = {
			url:contextPath+"/GIPIPolbasicController?action=getPolicyListByAssured"+
				"&refresh=1&assdNo="+encodeURIComponent($F("txtAssdNo")),
			options:{
					title: '',
					width:'856px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = policyByAssuredTableGrid._mtgId;
						policyByAssuredSelectedIndex = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							policyByAssuredSelectedIndex = y;
							enableButton("btnSummarizedInfo");
							enableButton("btnPolEndtDetails");
						}
						policyByAssuredTableGrid.releaseKeys();
					},
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						policyByAssuredSelectedIndex = -1;
						policyByAssuredTableGrid.releaseKeys();
						disableButton("btnSummarizedInfo");
						disableButton("btnPolEndtDetails");
					},
					onRowDoubleClick: function(param){
						
						var row = policyByAssuredTableGrid.geniisysRows[param];
						//objGIPIS100.callingForm = "GIPIS100"; commented out by gab 08.17.2015
						objGIPIS100.assdNo = row.assdNo;
						objGIPIS100.assdName = $F("txtAssdName");
						objGIPIS100.query = "Y";
						getPolicyEndtSeq0(row.policyId);
						policyByAssuredTableGrid.releaseKeys();
					}
			},
			columnModel:[
			 		{   id: 'recordStatus',
					    title: '',
					    width: '0px',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	id: 'divCtrId',
						width: '0px',
						visible: false
					},
					{	id: 'rowNum',
						title: 'rowNum',
						width: '0px',
						visible: false
					},
					{	id: 'rowCount',
						title: 'rowCount',
						width: '0px',
						visible: false
					},
					{	id: 'policyId',
						title: 'policyId',
						width: '0px',
						visible: false
					},
					{	id: 'policyNo',
						title: 'Policy No.',
						width: '200px',
						visible: true,
						filterOption : true
					},
					{	id: 'endtNo',
						title: 'Endorsement No.',
						width: '120px',
						visible: true
					},
					{	id: 'strInceptDate',	//changed to strInceptDate gzelle 06.27.2013
						title: 'Incept Date',
						width: '80px',
						type: 'date',
						visible: true,
						filterOption : true,
						filterOptionType: 'formattedDate' // added by gab 07.22.2015
						//sortable: false		
					},
					{	id: 'strExpiryDate',	//changed to strExpiryDate gzelle 06.27.2013
						title: 'Expiry Date',
						width: '80px',
						type: 'date',
						visible: true,
						filterOption : true,
						filterOptionType: 'formattedDate' // added by gab 07.22.2015
						//sortable: false		
					},
					{	id: 'meanPolFlag',
						title: 'Status',
						titleAlign: 'center',
						width: '120px',
						visible: true,
						//sortable: false		
					},
					{	id: 'tsiAmt',
						title: 'TSI Amount',
						width: '110px',
						visible: true,
						titleAlign: 'right',
						align: 'right',
						//sortable: false,		
						geniisysClass : 'money',     
			            geniisysMinValue: '-999999999999.99',     
			            geniisysMaxValue: '999,999,999,999.99'
						
					},
					{	id: 'premAmt',
						title: 'Premium Amount',
						width: '120px',
						visible: true,
						//sortable: false,		
						titleAlign: 'right',
						align: 'right',
						geniisysClass : 'money',     
			            geniisysMinValue: '-999999999999.99',     
			            geniisysMaxValue: '999,999,999,999.99'
					}
			],
			rows:objPolicyByAssured.objPolicyByAssuredList
		};
		policyByAssuredTableGrid = new MyTableGrid(policyByAssuredTableModel);
		policyByAssuredTableGrid.pager = objPolicyByAssured.objPolicyByAssuredListTableGrid;
		policyByAssuredTableGrid.render('policyByAssuredListing');
		policyByAssuredTableGrid.afterRender = function(){
			disableButton("btnSummarizedInfo");
			disableButton("btnPolEndtDetails");
			policyByAssuredTableGrid.releaseKeys();
			policyByAssuredSelectedIndex = -1;
		};
		
	}catch(e){
		showErrorMessage("policyByAssured", e);
	}
	
	// edited by gab 08.04.2015
	$("btnSummarizedInfo").observe("click", function () {		
		try{
			var row = policyByAssuredTableGrid.geniisysRows[policyByAssuredSelectedIndex];
			//objGIPIS100.callingForm = "GIPIS100"; commented out by gab 08.17.2015
			objGIPIS100.assdNo = row.assdNo;
			objGIPIS100.assdName = $F("txtAssdName");
			objGIPIS100.query = "Y";
			getPolicyEndtSeq0(row.policyId);
		}catch(e){}
	});
	
	$("btnPolEndtDetails").observe("click", function () {
		var div = objGIPIS100.callingForm == "GIPIS000" ? "mainContents" : "dynamicDiv";
		/* objGIPIS100.policyId = policyByAssuredTableGrid.geniisysRows[policyByAssuredSelectedIndex].policyId; */
		var row = policyByAssuredTableGrid.geniisysRows[policyByAssuredSelectedIndex];
		//objGIPIS100.callingForm = "GIPIS100"; commented out by gab 08.17.2015
		objGIPIS100.policyId = row.policyId;
		objGIPIS100.assdNo = row.assdNo;
		objGIPIS100.assdName = $F("txtAssdName");
		objGIPIS100.query = "Y";
		objGIPIS100.prevDocumentTitle = "Policies by Assured";
		new Ajax.Request(contextPath + "/GIPIPolbasicController", {
		    parameters : {
		    	action : "showPolicyMainInfo",
		    	policyId : 	objGIPIS100.policyId
		    },
		    onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				try {
					if(checkErrorOnResponse(response)){
						$(div).update(response.responseText);
					}
				} catch(e){
					showErrorMessage("btnPolEndtDetails", e);
				}								
			} 
		});		
	});
	hideNotice();
</script>