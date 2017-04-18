<div id="policyByObligeeTableGridSectionDiv" class="sectionDiv" style="border: none; padding:25px; padding-top:5px;">
		<div id="policyByObligeeTableGridDiv" class="sectionDiv" style="border: none;">
			<div id="policyByObligeeListing" class="sectionDiv" style="border: none; height:310px;width:850px;"></div>
		</div>
</div>

<script type="text/javascript" src="underwriting.js">
	var policyByObligeeSelectedIndex;
	var objPolicyByObligee = new Object();
	objPolicyByObligee.objPolicyByObligeeListTableGrid = JSON.parse('${policyListByObligee}'.replace(/\\/g, '\\\\'));
	objPolicyByObligee.objPolicyByObligeeList = objPolicyByObligee.objPolicyByObligeeListTableGrid.rows || [];
	try{
		var policyByObligeeTableModel = {
			url:contextPath+"/GIPIPolbasicController?action=getPolicyListByObligee"+
				"&refresh=1&obligeeNo="+encodeURIComponent($F("txtObligeeNo")),
			options:{
					pager: {},
					title: '',
					width:'850px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = policyByObligeeTableGrid._mtgId;
						policyByObligeeTableGrid.releaseKeys();
						policyByObligeeSelectedIndex = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							policyByObligeeSelectedIndex = y;
							enableButton("btnSummarizedInfo");
							enableButton("btnPolEndtDetails");
						}
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						policyByObligeeSelectedIndex = -1;
						policyByObligeeTableGrid.releaseKeys();
						disableButton("btnSummarizedInfo");
						disableButton("btnPolEndtDetails");
					},
					onRowDoubleClick: function(param){
						
						var row = policyByObligeeTableGrid.geniisysRows[param];
						getPolicyEndtSeq0(row.policyId);
						policyByObligeeTableGrid.releaseKeys();
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
						titleAlign: 'center',
						width: '220%',
						visible: true,
						//sortable: false
					},
					{	id: 'endtNo',
						title: 'Endorsement No.',
						titleAlign: 'center',
						width: '200%',
						visible: true,
						//sortable: false
					},
					{	id: 'inceptDate',
						title: 'Incept Date',
						titleAlign: 'center',
						width: '0px',
						visible: false
					},
					{	id: 'expiryDate',
						title: 'Expiry Date',
						width: '0px',
						visible: false
					},
					{	id: 'meanPolFlag',
						title: 'Status',
						width: '0px',
						visible: false
					},
					{	id: 'tsiAmt',
						title: 'TSI Amount',
						width: '200%',
						align: 'right',
						titleAlign: 'right',
						visible: true,
						//sortable: false,
						geniisysClass : 'money',     
			            geniisysMinValue: '-999999999999.99',     
			            geniisysMaxValue: '999,999,999,999.99'
					},
					{	id: 'premAmt',
						title: 'Premium Amount',
						width: '200%',
						align: 'right',
						titleAlign: 'right',
						visible: true,
						//sortable: false,
						geniisysClass : 'money',     
			            geniisysMinValue: '-999999999999.99',     
			            geniisysMaxValue: '999,999,999,999.99'
						
					}
			],
			rows:objPolicyByObligee.objPolicyByObligeeList
		};
		policyByObligeeTableGrid = new MyTableGrid(policyByObligeeTableModel);
		policyByObligeeTableGrid.pager = objPolicyByObligee.objPolicyByObligeeListTableGrid;
		policyByObligeeTableGrid.render('policyByObligeeListing');
		policyByObligeeTableGrid.afterRender = function(){
			disableButton("btnSummarizedInfo");
			disableButton("btnPolEndtDetails");
			policyByObligeeTableGrid.releaseKeys();
			policyByObligeeSelectedIndex = -1;
		};
	}catch(e){
		showErrorMessage("PolicyByObligeeTable", e);
	}

	$("btnSummarizedInfo").observe("click", function () {		
		try{
			var row = policyByObligeeTableGrid.geniisysRows[policyByObligeeSelectedIndex];
			getPolicyEndtSeq0(row.policyId);
		}catch(e){}
	});
	
	$("btnPolEndtDetails").observe("click", function () {
		var div = objGIPIS100.callingForm == "GIPIS000" ? "mainContents" : "dynamicDiv";
		objGIPIS100.policyId = policyByObligeeTableGrid.geniisysRows[policyByObligeeSelectedIndex].policyId;
		objGIPIS100.prevDocumentTitle = "Policies by Obligee";
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