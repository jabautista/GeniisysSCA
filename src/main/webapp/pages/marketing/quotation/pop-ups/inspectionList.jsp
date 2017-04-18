<!-- For Deletion, converted to LOV
Developer : andrew
Date : 05.11.2012 -->

<div id="inspectionListMainDiv">
	<form id="inspectionListForm">
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Inspection List</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		
		<div id="tableGridSectionDiv" class="sectionDiv" style="height: 370;">
			<div id="" style= "padding: 10px;">
				<div id="inspectionListTableGrid" style="height: 350px; width: 900px;"></div>
			</div>
		</div>
	
		<div id="inspectionListButttonDiv" name="inspectionListButttonDiv" class="sectionDiv" style="border: none; margin: 10px 0;">
			<table align="center" border="0">
				<tr>
					<td><input type="button" class="button" id="btnReturn" value="Return" style="width: 90px;"></input></td>
					<td><input type="button" class="button" id="btnOk" value="Ok"></input></td>
				</tr>
			</table>
		</div>
	</form>
</div>

<script>
	var quoteId = "${quoteId}";
	var inspListObj = new Object();
	inspListObj.inspListTableGrid = JSON.parse('${gipiInspListTableGrid}'.replace(/\\/g,'\\\\'));	
	inspListObj.inspListRows = inspListObj.inspListTableGrid.rows || [];
	var arrInspListButtons = [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN];
	var inspListTableModel = {
		url: contextPath + "/GIPIQuotationController?action=refreshInspectionList&assdNo="+$F("assuredNo"),
		options: {
			title: '',
	      	height:'325px',
	      	width:'960px',
	      	onCellFocus: function(element, value, x, y, id){
				var mtgId = inspListTableGrid._mtgId;
				selectedIndex = -1;
				if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
			     	selectedIndex = y;
			     	selectedQuoteListingIndex = y;
				}
				observeChangeTagInTableGrid(inspListTableGrid);
		  	},	onCellBlur: function(){
					observeChangeTagInTableGrid(inspListTableGrid);			  			
		  	},	onRemoveRowFocus : function(){
		  		selectedQuoteListingIndex = -1;
		  	},
		  	onRowDoubleClick: function(param){
			  	showConfirmBox("Confirmation", "Do you want to save the inspection details?", "Yes", "No", saveInspectionDetails,"");
          	},
	      	toolbar:{
		 		elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
      		}
		},
		columnModel:[
		     {	id: 'divCtrId',
				width: '0px',
				visible: false						    
			},
			{	id: 'assdName',
				titleAlign: 'center',
				width: '120px',
				title: 'Assured Name',
				align: 'center',
				visible: true,
				filterOption: true
			},
			{	id: 'inspName',
				titleAlign: 'center',
				width: '120px',
				title: 'Inspector Name',
				align: 'center',
				visible: true,
				filterOption: true
			},
			{	id: 'itemDesc',
				titleAlign: 'center',
				width: '120px',
				title: 'Item Description',
				align: 'center',
				visible: true,
				filterOption: true
			},
			{	id: 'province',
				titleAlign: 'center',
				width: '120px',
				title: 'Province',
				align: 'center',
				visible: true,
				filterOption: true
			},
			{	id: 'city',
				titleAlign: 'center',
				width: '120px',
				title: 'City',
				align: 'center',
				visible: true,
				filterOption: true
			},
			{	id: 'districtDesc',
				titleAlign: 'center',
				width: '120px',
				title: 'District',
				align: 'center',
				visible: true,
				filterOption: true
			},
			{	id: 'blockDesc',
				titleAlign: 'center',
				width: '120px',
				title: 'Block',
				align: 'center',
				visible: true,
				filterOption: true
			},
			{	id: 'locRisk1',
				titleAlign: 'center',
				width: '120px',
				title: 'Loc Risk1',
				align: 'center',
				visible: true,
				filterOption: true
			},
			{	id: 'locRisk2',
				titleAlign: 'center',
				width: '120px',
				title: 'Loc Risk2',
				align: 'center',
				visible: true,
				filterOption: true
			},
			{	id: 'locRisk3',
				titleAlign: 'center',
				width: '120px',
				title: 'Loc Risk3',
				align: 'center',
				visible: true,
				filterOption: true
			},
			{	id: 'itemNo',
				title:  'itemNo',
				width: '0',
				visible: false,
				filterOption: false
			},
			{	id: 'inspNo',
				width: '0',
				visible: false,
				filterOption: false
			},
			{	id: 'provinceCd',
				width: '0',
				visible: false,
				filterOption: false
			},
			{	id: 'districtNo',
				width: '0',
				visible: false,
				filterOption: false
			},
			{	id: 'blockNo',
				width: '0',
				visible: false,
				filterOption: false
			},
			
		],
		rows: inspListObj.inspListRows
	};
	var inspListTableGrid = new MyTableGrid(inspListTableModel);
	inspListTableGrid.pager = inspListObj.inspListTableGrid;	
	inspListTableGrid.render('inspectionListTableGrid');	

	function saveInspectionDetails(){
		try{
			var inspRow = inspListTableGrid.geniisysRows[selectedIndex];
	      	
			new Ajax.Request(contextPath+ "/GIPIQuotationController",{
				method: "POST",
				parameters: {
					action: "saveQuoteInspectionDetails",
					quoteId: quoteId,
					inspNo:  inspRow.inspNo,
					itemNo:  inspRow.itemNo,
					provinceCd: inspRow.provinceCd,
					itemDesc: inspRow.itemDesc,
					blockNo: inspRow.blockNo,
					districtNo: inspRow.districtNo,
					locRisk1: inspRow.locRisk1,
					locRisk2: inspRow.locRisk2,
					locRisk3: inspRow.locRisk3
				},onCreate : function(){
					showNotice("Saving inspection details.");
				},onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){		
						showWaitingMessageBox(response.responseText,imgMessage.SUCCESS, function(){
							Modalbox.hide();
							reloadForm();
						});					
					}
				}
			});
		}catch(e){
			showErrorMessage("saveInspectionDetails",e);
		}	
	}
	initializeAccordion();
</script>