<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="giuwPolDistPolbasicVTableGridDiv" name="giuwPolDistPolbasicVTableGridDiv" style="padding: 10px;">
	<div id="giuwPolDistPolbasicVDiv" style="height: 330px;">
		<div id="giuwPolDistPolbasicVTableGrid" style="height: 306px; width: 900px;"></div>
	</div>
</div>

<script type="text/javascript">

	var selectedRecord = null;
	var selectedIndex = null;

	try{
		var objGiuwPolDistPolbasicV = new Object();
		objGiuwPolDistPolbasicV.objGiuwPolDistPolbasicVTableGrid = JSON.parse('${giuwPolDistPolbasicTableGrid}'.replace(/\\/g, '\\\\'));
		objGiuwPolDistPolbasicV.objGiuwPolDistPolbasicVList = objGiuwPolDistPolbasicV.objGiuwPolDistPolbasicVTableGrid.rows || [];

		var giuwPolDistPolbasicVTableModel = {
			url: contextPath+"/GIUWPolDistPolbasicVController?action=getGIUWPolDistPolbasicVList&refresh=1",
			options:{
				title: '',
				width: '900px',
				validateChangesOnPrePager: false,
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){	// shan 08.06.2014
						objGIUWS015.filterByParam = false;
						objGIUWS015.tempTaggedRecords = [];
						objGIUWS015.tempUntaggedRecords = [];
						giuwPolDistPolbasicVTableGrid.keys.releaseKeys();
						giuwPolDistPolbasicVTableGrid.keys.removeFocus(giuwPolDistPolbasicVTableGrid.keys._nCurrentFocus, true);
						giuwPolDistPolbasicVTableGrid.onRemoveRowFocus();
					}
				},
				onCellBlur: function(element, value, x, y, id){
				},
				onCellFocus: function(element, value, x, y, id){
					var mtgId = giuwPolDistPolbasicVTableGrid._mtgId;
					var lineCd = giuwPolDistPolbasicVTableGrid.geniisysRows[y].lineCd;
					selectedRecord = null;
					selectedIndex = y;
					
					if(x == giuwPolDistPolbasicVTableGrid.getColumnIndex("batchIdTag")){
						observeBatchIdTag(lineCd, x, y, mtgId);
					}
					
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
						selectedRecord = giuwPolDistPolbasicVTableGrid.geniisysRows[y];
						objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV = selectedRecord; 
						onSelectGiuwPolDistPolbasicRec(selectedRecord);
					}
				},
				onRemoveRowFocus: function(element, value, x, y, id){
					selectedRecord = null;
					selectedIndex = null;
					objUW.hidObjGIUWS015.selectedGiuwPolDistPolbasicV = null;
					disableButton("btnDistribute");
				}, 
				onRefresh: function(){	// shan 08.06.2014
					objGIUWS015.filterByParam = false;
					objGIUWS015.tempTaggedRecords = [];
					objGIUWS015.tempUntaggedRecords = [];
					giuwPolDistPolbasicVTableGrid.keys.releaseKeys();
					giuwPolDistPolbasicVTableGrid.keys.removeFocus(giuwPolDistPolbasicVTableGrid.keys._nCurrentFocus, true);
					giuwPolDistPolbasicVTableGrid.onRemoveRowFocus();
					giuwPolDistPolbasicVTableGrid.afterRender();
				}, 
				prePager: function(){
					giuwPolDistPolbasicVTableGrid.keys.releaseKeys();					
				},
				postPager: function(){
					tagUntagRecords();
					giuwPolDistPolbasicVTableGrid.keys.releaseKeys();					
				},
				onSort: function(){
					tagUntagRecords();
					giuwPolDistPolbasicVTableGrid.keys.releaseKeys();					
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
				{	id: 'policyId',		// added by shan 08.07.2014
					width: '0',
					visible: false
				},
				{	id: 'lineCd',
					title: 'Line Code',
					width: '0',
					filterOption: true,
					visible: false
				},
				{	id: 'sublineCd',
					title: 'Subline Code',
					width: '0',
					filterOption: true,
					visible: false
				},
				{	id: 'issCd',
					title: 'Issue Code',
					width: '0',
					filterOption: true,
					visible: false
				},
				{	id: 'issueYy',
					width: '0',
					title: 'Issue Year',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'polSeqNo',
					width: '0',
					title: 'Pol. Seq No.',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'renewNo',
					width: '0',
					title: 'Renew No.',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'endtIssCd',
					width: '0',
					title: 'Endt Iss Code',
					visible: false,
					filterOption: true
				},
				{	id: 'endtYy',
					width: '0',
					title: 'Endt. Year',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'endtSeqNo',
					width: '0',
					title: 'Endt Seq No.',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'distNo',
					width: '0',
					title: 'Distribution No.',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{ 	id: 'batchIdTag',
				  	sortable: false,
				  	align: 'center',
				  	altTitle: 'Mark check box and Press <Save> to save and to generate batch ID.',
				  	title: '&#160;&#160;P',
				  	titleAlign: 'center',
				  	width: '28px',
				  	editable: true,
				  	defaultValue: false,
				  	otherValue: false,
				  	hideSelectAllBox: true,
				  	editor: /*'checkbox'*/new MyTableGrid.CellCheckbox({
				  		onClick : function(value, checked) {
							if (checked){
								giuwPolDistPolbasicVTableGrid.geniisysRows[selectedIndex].batchIdTag = true;
								objGIUWS015.tempTaggedRecords.push(giuwPolDistPolbasicVTableGrid.geniisysRows[selectedIndex]);
								for (var i=0; i < objGIUWS015.tempUntaggedRecords.length; i++){
									if (objGIUWS015.tempUntaggedRecords[i].policyId == giuwPolDistPolbasicVTableGrid.geniisysRows[selectedIndex].policyId){
										objGIUWS015.tempUntaggedRecords.splice(i, 1);
									}
								}
							}else{
								giuwPolDistPolbasicVTableGrid.geniisysRows[selectedIndex].batchIdTag = false;
								objGIUWS015.tempUntaggedRecords.push(giuwPolDistPolbasicVTableGrid.geniisysRows[selectedIndex]);								
								for (var i=0; i < objGIUWS015.tempTaggedRecords.length; i++){
									if (objGIUWS015.tempTaggedRecords[i].policyId == giuwPolDistPolbasicVTableGrid.geniisysRows[selectedIndex].policyId){
										objGIUWS015.tempTaggedRecords.splice(i, 1);
									}
								}
							}
						}
				  	})
				},
				{ 	id: 'batchId',
					title : 'Batch No.',
					titleAlign: 'center',
					align: 'center',
					width : '90px',
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					renderer: function (value){
						return nvl(value,'') == '' ? '' :formatNumberDigits(value,9);
					}
				},
				{ 	id: 'policyNo',
					title : 'Policy Number',
					titleAlign: 'center',
					width : '160px'
				},
				{ 	id: 'endtNo',
					title : 'Endorsement No.',
					titleAlign: 'center',
					width : '160px'
				},
				{ 	id: 'distNo',
					title : 'Distribution No.',
					titleAlign: 'center',
					align: 'center',
					width : '90px',
					renderer: function (value){
						return nvl(value,'') == '' ? '' :formatNumberDigits(value,8);
					}
				},
				{ 	id: 'effDate',
					title : 'Effectivity Date',
					titleAlign: 'center',
					align: 'center',
					type: 'date',
					width : '100px',
					filterOption: true,
					filterOptionType: 'formattedDate'	// shan 08.28.2014
				},
				{ 	id: 'tsiAmt',
					title : 'Sum Insured',
					titleAlign: 'right',
					type : 'number',
					width : '115px',
					geniisysClass: 'money'
				},
				{ 	id: 'premAmt',
					title : 'Premium Amt.',
					titleAlign: 'right',
					type : 'number',
					width : '115px',
					geniisysClass: 'money'
				},
					
			],
			requiredColumns: 'policyNo',
			rows: objGiuwPolDistPolbasicV.objGiuwPolDistPolbasicVList
		};

		giuwPolDistPolbasicVTableGrid = new MyTableGrid(giuwPolDistPolbasicVTableModel);
		giuwPolDistPolbasicVTableGrid.pager = objGiuwPolDistPolbasicV.objGiuwPolDistPolbasicVTableGrid;
		giuwPolDistPolbasicVTableGrid.render('giuwPolDistPolbasicVTableGrid');
		giuwPolDistPolbasicVTableGrid.afterRender = function(){
			var geniisysRows = giuwPolDistPolbasicVTableGrid.geniisysRows;
			var mtgId = giuwPolDistPolbasicVTableGrid._mtgId;
			var x = giuwPolDistPolbasicVTableGrid.getColumnIndex("batchIdTag");
			for(var y=0; y<geniisysRows.length; y++){
				if (objGIUWS015.filterByParam){	// added if-else condition : shan 08.06.2014
					if(geniisysRows[y].batchId == null){
						$('mtgInput'+mtgId+'_'+x+','+y).checked = true;
						$('mtgIC'+mtgId+'_'+x+','+y).addClassName('modifiedCell');
						giuwPolDistPolbasicVTableGrid.setValueAt(true, giuwPolDistPolbasicVTableGrid.getColumnIndex('batchIdTag'), y);
						changeTag = 1;
					}else{
					 	$('mtgInput'+mtgId+'_'+x+','+y).disable();
					}
				}else{
				 	if(geniisysRows[y].batchId != null){
				 		$('mtgInput'+mtgId+'_'+x+','+y).checked = true;
					 	$('mtgInput'+mtgId+'_'+x+','+y).disable();
					 	$('mtgIC'+mtgId+'_'+x+','+y).setAttribute("editableDiv", "false");
				 	}else{
						$('mtgInput'+mtgId+'_'+x+','+y).checked = false;
				 	}
					$('mtgIC'+mtgId+'_'+x+','+y).removeClassName('modifiedCell');
			 	}
			}
		};
	}catch(e){
		showErrorMessage("giuwPolDistPolbasicV", e);
	}

	function onSelectGiuwPolDistPolbasicRec(obj){
		if(obj.batchId != null && obj.batchId != ""){
			enableButton("btnDistribute");
		}else{
			disableButton("btnDistribute");
		}
	}

	function observeBatchIdTag(lineCd, x, y, mtgId){
		var objArray = giuwPolDistPolbasicVTableGrid.getModifiedRows();
		objArray = objArray.filter(function(obj){ return obj.batchIdTag == true;});
		var ctr = 0;
		for(var i=0; i<objArray.length; i++){
			if(lineCd != objArray[i].lineCd){
				showMessageBox("Only policies of the same line can be batch distributed.", "I");
				$('mtgInput'+mtgId+'_'+x+','+y).checked = false;
				$('mtgIC'+mtgId+'_'+x+','+y).removeClassName('modifiedCell');
				$('mtgIC'+mtgId+'_'+x+','+y).setAttribute("editableDiv", "true");
			}else{
				ctr++;
			}
		}
		for(var i=0; i<objGIUWS015.tempTaggedRecords.length; i++){	// added to handle records in other page : shan 08.28.2014
			if(lineCd != objGIUWS015.tempTaggedRecords[i].lineCd){
				showMessageBox("Only policies of the same line can be batch distributed.", "I");
				$('mtgInput'+mtgId+'_'+x+','+y).checked = false;
				$('mtgIC'+mtgId+'_'+x+','+y).removeClassName('modifiedCell');
				$('mtgIC'+mtgId+'_'+x+','+y).setAttribute("editableDiv", "true");
			}else{
				ctr++;
			}
		}
		if(ctr == 0){
			changeTag = 0;
		}else{
			changeTag = 1;
		}
	}
	
	function tagUntagRecords(){
		var x = giuwPolDistPolbasicVTableGrid.getColumnIndex("batchIdTag");
		var mtgId = giuwPolDistPolbasicVTableGrid._mtgId;
		
		for (var a=0; a<giuwPolDistPolbasicVTableGrid.geniisysRows.length; a++){
			// tagging
			for (var b=0; b<objGIUWS015.tempTaggedRecords.length; b++){
				if (giuwPolDistPolbasicVTableGrid.geniisysRows[a].batchId == null){
					if (giuwPolDistPolbasicVTableGrid.geniisysRows[a].policyId == objGIUWS015.tempTaggedRecords[b].policyId){
						$('mtgInput'+mtgId+'_'+x+','+a).checked = true;
						$('mtgIC'+mtgId+'_'+x+','+a).addClassName('modifiedCell');
						giuwPolDistPolbasicVTableGrid.setValueAt(true, giuwPolDistPolbasicVTableGrid.getColumnIndex('batchIdTag'), a);	
						tagged = true;
						break;
					}
				}else{
			 		$('mtgInput'+mtgId+'_'+x+','+a).checked = true;
				 	$('mtgInput'+mtgId+'_'+x+','+a).disable();
				 	$('mtgIC'+mtgId+'_'+x+','+a).setAttribute("editableDiv", "false");
				}
			}
			// untagging
			for (var b=0; b<objGIUWS015.tempUntaggedRecords.length; b++){
				if (giuwPolDistPolbasicVTableGrid.geniisysRows[a].batchId == null && giuwPolDistPolbasicVTableGrid.geniisysRows[a].policyId == objGIUWS015.tempUntaggedRecords[b].policyId){
					$('mtgInput'+mtgId+'_'+x+','+a).checked = false;
					$('mtgIC'+mtgId+'_'+x+','+a).removeClassName('modifiedCell');
					giuwPolDistPolbasicVTableGrid.setValueAt(false, giuwPolDistPolbasicVTableGrid.getColumnIndex('batchIdTag'), a);	
					break;
				}
			}
		}
	}
</script>