<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="giuwWitemdsTableGrid" style="height: 220px; width: 900px;"></div>

<script type="text/javascript">
	try{
		var isExistGiuwWpolicyds = '${isExistGiuwWpolicyds}';
		var objGiuwWitemds = new Object();
		objGiuwWitemds.objGiuwWitemdsListTableGrid = JSON.parse('${objGiuwWitemds}'.replace(/\\/g, '\\\\'));
		objGiuwWitemds.objGiuwWitemdsList = objGiuwWitemds.objGiuwWitemdsListTableGrid.rows || [];		
		var url = contextPath+"/GIUWWitemdsController?action=refreshGIUWWitemdsTableListing";	
		
		if(objGIPIPolbasicPolDistV1 != null){
			url = url+"&policyId="+objGIPIPolbasicPolDistV1.policyId+"&distNo="+objGIPIPolbasicPolDistV1.distNo;
			enableButton("btnCreateItems");
		}else{
			disableButton("btnCreateItems");
		}

		if(isExistGiuwWpolicyds == 'Y'){
			$("btnCreateItems").setAttribute("enValue", "Recreate Items");
			$("btnCreateItems").value = "Recreate Items";
		}else{
			$("btnCreateItems").setAttribute("enValue", "Create Items");
			$("btnCreateItems").value = "Create Items";
		}
		
		var giuwWitemdsTableModel = {
			url: url,
			options:{
				title: '',
				width: '900px',
				hideColumnChildTitle: true,
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN]
				},
				onCellFocus : function(element, value, x, y, id) {
					if(x == giuwWitemdsTableGrid.getColumnIndex('groupTag')){
						setDistrFinalBtnsBehaviors();
					}
				},
				checkChanges : false,// added by jhing 12.05.2014	
				prePager : function () { // added by jhing 12.05.2014 for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871
					if (changedCheckedTag == 1 && newGroupTag != 1 && joinGroupTag != 1 ) {
						showWaitingMessageBox("You have tagged some items for grouping. Please separate the items into a new group or join them into existing distribution group before navigating to other pages.", "I", function(){
							$("btnNewGrp").focus();
						});
						return false;	 	
					}else if ( newGroupTag == 1 || joinGroupTag == 1 ) {
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;	 					
					}
				}, 	
				onRefresh : function () {
					// added by jhing 12.05.2014 for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871
					newGroupTag = 0 ; 
					joinGroupTag = 0 ; 
					changedCheckedTag = 0 ;  
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
				{ 	id: 'groupTag',
				  	align: 'center',
				  	title: '&#160;&#160;G',
				  	titleAlign: 'center',
				  	altTitle: 'Group',
				  	width: '25px',
				  	editable: true,
				  	defaultValue: false,
				  	otherValue: false,
				  	sortable: false,
				  	hideSelectAllBox: true,
				  	editor: /*'checkbox'*/ new MyTableGrid.CellCheckbox({	// shan 08.06.2014
				  		onClick: function(value, checked){
				  			if (!checked){
				  				setDistrFinalBtnsBehaviors();
				  			}
				  		}
				  	})	
				},
				{ 	id: 'itemNo',
					title : 'Item',
					titleAlign: 'center',
					sortable: false,
					width : '30px',
					renderer: function (value){
						return nvl(value,'') == '' ? '' :formatNumberDigits(value,3);
					}
				},
				{	id: 'distSeqNo',
					title: 'Seq.',
					sortable: false,
					width: '30px',
					align: 'center'
				},
				{ 	id: 'nbtItemTitle',
					title : 'Item Title',
					sortable: false,
					width : '130px'
				},
				{ 	id: 'nbtItemDesc',
					title : 'Item Description',
					sortable: false,
					width : '130px'
				},
				{ 	id: 'tsiAmt',
					title : 'Sum Insured',
					titleAlign : 'right',
					sortable: false,
					geniisysClass: 'money',
					align: 'right',
					width : '100px'
				},
				{ 	id: 'premAmt',
					title : 'Premium',
					titleAlign: 'right',
					sortable: false,
					geniisysClass: 'money',
					align: 'right',
					width : '100px'
				},
				{	id: 'itemGrp',
					title: 'Item Grp.',
					align: 'right',
					sortable: false,
					width: '60px',
					renderer: function (value){
						return nvl(value,'') == '' ? '' :formatNumberDigits(value,5);
					}
				},
				{ 	id: 'dspShortName dspCurrencyRt',
					title: 'Currency Rate',
					width : 140,
					sortable: false,
					children : [
			            {
			                id : 'dspShortName',
			                width : 50,
			                editable: false,
			                sortable: false 		
			            },
			            {
			                id : 'dspCurrencyRt', 
			                width : 100,
			                editable: false,
			                sortable: false,
			                align: 'right',
							renderer: function (value){
								return nvl(value,'') == '' ? '' :formatToNthDecimal(nvl(value, 0),9);
							}		
			            }
					]
				},
				{ 	
					id: 'dspPackLineCd dspPackSublineCd',
					title: 'Package / Line',
					width : 120,
					sortable: false,
					children : [
			            {
			                id : 'dspPackLineCd',
			                width : 50,
			                editable: false,
			                sortable: false		
			            },
			            {
			                id : 'dspPackSublineCd',
			                width : 80,
			                editable: false,
			                sortable: false,
			                defaultValue: "" 		
			            }
					]
				},
				{ 	id: 'rowNum', // added by jhing 12.05.2014 
					width: '0',
					visible: false
				}  
			],
			requiredColumns: 'itemNo tsiAmt',
			rows: objGiuwWitemds.objGiuwWitemdsList
		};
		
		giuwWitemdsTableGrid = new MyTableGrid(giuwWitemdsTableModel);
		giuwWitemdsTableGrid.pager = objGiuwWitemds.objGiuwWitemdsListTableGrid;
		giuwWitemdsTableGrid.render('giuwWitemdsTableGrid');
	
	}catch(e){
		showErrorMessage("giuwWitemdsListing", e);
	}

	function checkIfItemsSelectedExist(){
		var check = false;
		var rows = giuwWitemdsTableGrid.getModifiedRows();
		for(var i=0; i<rows.length; i++){
			if(rows[i].groupTag == true){
				check = true;
				break;
			}
		}
		return check;
	}

	function setDistrFinalBtnsBehaviors(){
		if(checkIfItemsSelectedExist()){
			/*enableButton("btnNewGrp");	// replaced with code below : shan 08.06.2014
			enableButton("btnJoinGrp");*/
			validateItem();
		}else{
			disableButton("btnNewGrp");
			disableButton("btnJoinGrp");
			changedCheckedTag = 0 ; // added by jhing 12.05.2014
			
			// shan 08.06.2014
			giuwWitemdsTableGrid.modifiedRows = [];	
			var columnIndex = giuwWitemdsTableGrid.getColumnIndex("groupTag");
			for (var j=0; j<giuwWitemdsTableGrid.geniisysRows.length; j++){
				$("mtgInput"+giuwWitemdsTableGrid._mtgId+"_"+columnIndex+","+j).checked = false;
				$("mtgIC"+giuwWitemdsTableGrid._mtgId+"_"+columnIndex+","+j).removeClassName('modifiedCell');
			}
			// end 08.06.2014
		}
	}
	
	// shan 08.06.2014
	function uncheckGridCheckbox(divCtrId){
		var objArray = giuwWitemdsTableGrid.geniisysRows;
		var columnIndex = giuwWitemdsTableGrid.getColumnIndex("groupTag");
		for (var j=0; j<objArray.length; j++){
			if (divCtrId == objArray[j].divCtrId){
				$("mtgInput"+giuwWitemdsTableGrid._mtgId+"_"+columnIndex+","+j).checked = false;
				$("mtgIC"+giuwWitemdsTableGrid._mtgId+"_"+columnIndex+","+j).removeClassName('modifiedCell');
			}
		}
		giuwWitemdsTableGrid.unselectRows;	
	}
	
	function validateItem(){
		var rows = giuwWitemdsTableGrid.getModifiedRows();
		var previousCurrRt = "";
		var currentCurrRt = "";
		var groupItemGrp = "";	

		for(var i=0; i<rows.length; i++){
			if (i == 0) groupItemGrp = rows[i].itemGrp;
			
			if (rows[i].groupTag == true){
				previousCurrRt = currentCurrRt;
				currentCurrRt = rows[i].dspCurrencyRt;
				if (previousCurrRt != currentCurrRt && previousCurrRt != "" ){
					showMessageBox("Only items of the same item currency, currency rate may be grouped together as one.", imgMessage.INFO);
					uncheckGridCheckbox(rows[i].divCtrId);
					return false;
				}else if (groupItemGrp != rows[i].itemGrp){	
					showMessageBox("Only items of the same item group/bill group may be grouped together as one.", imgMessage.INFO);
					uncheckGridCheckbox(rows[i].divCtrId);
					return false;
				}else {
					enableButton("btnNewGrp");
					enableButton("btnJoinGrp");
					changedCheckedTag = 1; // added by jhing 12.05.2014 
				}
			}else{
				enableButton("btnNewGrp");
				enableButton("btnJoinGrp");
				changedCheckedTag = 1 ; // added by jhing 12.05.2014 
				uncheckGridCheckbox(rows[i].divCtrId);	
			}
		}		
	}
</script>