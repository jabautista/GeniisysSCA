<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="wtRateListingMainDiv" name="wtRateListingMainDiv">
	<div id="wtRateTableGridDiv" align="center">
		<div id="wtRateGridDiv" style="height: 350px;">
			<div id="wtRateTableGrid" style="height: 306px; width: 900px;"></div>
		</div>
		<div class="buttonsDiv" align="center">
			<input type="button" id="btnOk"    	  name="btnOk"    		style="width: 90px;" class="button hover"   value="Ok" />
		</div>
	</div>
</div>

<script type="text/javascript">

	var selectedRecord = null;

	try{
		var objWtRate = new Object();
		objWtRate.objWtRateListTableGrid = JSON.parse('${wtRateTableGrid}'.replace(/\\/g, '\\\\'));
		objWtRate.objWtRateList = objWtRate.objWtRateListTableGrid.rows || [];
		var refreshAction = '${refreshAction}';

		var wtRateTableModel = {
			url: contextPath+"/GIPIWCommInvoiceController?action="+refreshAction,
			options:{
				title: '',
				width: '400px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN]
				},
				onCellFocus: function(element, value, x, y, id){
					selectedRecord = wtRateTableGrid.geniisysRows[y];
				},
				onRemoveRowFocus : function(){
					selectedRecord = null;				  		
			  	},
				onRowDoubleClick: function(y){
					selectedRecord = wtRateTableGrid.geniisysRows[y];
					onSelectWtRate();
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
				{	id: 'rec',
					title: 'Policy',
					width: '100',
					filterOption: true,
					visible: true
				},
				{	id: 'wtr',
					title: 'Policy Id',
					width: '0',
					filterOption: true,
					visible: false
				},
				{	id: 'pol',
					title: 'WH Tax Rate',
					width: '200',
					filterOption: false,
					visible: true
				}
			],
			rows: objWtRate.objWtRateList
		};

		wtRateTableGrid = new MyTableGrid(wtRateTableModel);
		wtRateTableGrid.pager = objWtRate.objWtRateListTableGrid;
		wtRateTableGrid.render('wtRateTableGrid');

	}catch(e){
		showErrorMessage("wtRateLOV", e);
	}

	$("btnOk").observe("click", function(){
		if(selectedRecord == null){
			showMessageBox("Please select record first.");
		}else{
			onSelectWtRate();		
		}
	});

	function onSelectWtRate(){
		/*var moduleId = $("lblModuleId").getAttribute("moduleId");
		
		objWtRate = selectedRecord;
		populateDistrPolicyInfoFields(objWtRate);
		
		if(moduleId == "GIUWS010"){
			loadGIUWWitemdsTableListing(); // nica 07.08.2011
		}else if(moduleId == "GIUWS018"){
			loadGIUWWPerildsTableListing(); //belle 07.11.2011
		}else if(moduleId == "GIUWS013"){ //tonio 07.15.2011
			loadDistributionByGroups();
		}else if(moduleId == "GIUWS012"){ // emman 07.19.2011
			loadDistributionByPeril();
		}else if(moduleId == "GIUWS017"){ // nok 07.28.2011
			//loadDistByTsiPremPeril();
		}
		fireEvent($("modal_dialog_polbasicDistV1_close"), "click");*/
	}

</script>