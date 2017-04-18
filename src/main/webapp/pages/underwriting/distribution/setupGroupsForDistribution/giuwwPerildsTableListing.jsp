<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="giuwwPerildsTableGrid" style="height: 220px; width: 900px;"></div>

<script type="text/javascript">
	try{
		var objGIUWWPerilds = new Object();
		objGIUWWPerilds.objGIUWWPerildsListTableGrid = JSON.parse('${objGIUWWPerilds}'.replace(/\\/g, '\\\\'));
		objGIUWWPerilds.objGIUWWPerildsList = objGIUWWPerilds.objGIUWWPerildsListTableGrid.rows || [];		
		var url = contextPath+"/GIUWWPerildsController?action=refreshGIUWWPerildsTableListing";
		if(objGIPIPolbasicPolDistV1 != null){
			url = url+"&policyId="+objGIPIPolbasicPolDistV1.policyId+"&distNo="+objGIPIPolbasicPolDistV1.distNo;
		}		
	
		if(objGIUWWPerilds.objGIUWWPerildsList != 0){
			$("btnCreateItems").value = "Recreate Items";
			enableButton("btnCreateItems");
		}else{
			$("btnCreateItems").value = "Create Items";
			//disableButton("btnCreateItems"); // commented out by jhing 12.05.2014 for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871
			if(objGIPIPolbasicPolDistV1 != null){ // jhing 12.05.2014 used if-else condition 
				enableButton("btnCreateItems"); 			
			}else {
				disableButton("btnCreateItems"); 
			}
			disableButton("btnNewGrp");
			disableButton("btnJoinGrp");
			changedCheckedTag = 0 ; // added by jhing 12.05.2014 
		}
		
		var giuwwPerildsTableModel = {
			url: url,
			options:{
				title: '',
				width: '900px',
				hideColumnChildTitle: true,
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN]
				},
				onCellFocus : function(element, value, x, y, id) {
					if(x == giuwwPerildsTableGrid.getColumnIndex('groupTag')){
						setDistrFinalBtnsBehaviors();
					}
				},
				checkChanges : false,// added by jhing 12.05.2014 for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871		
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
				  	width: 25,
				  	editable: true,
				  	sortable: false,
				  	defaultValue: true,
				  	otherValue: true ,
				  	editor: /*'checkbox'*/ new MyTableGrid.CellCheckbox({	// shan 08.06.2014
				  		onClick: function(value, checked){
				  			if (!checked){
				  				setDistrFinalBtnsBehaviors();
				  			}
				  		}
				  	})				  	
				},
				{	id: 'perilType',
					width: '0',
					visible: false
				},
				{ 	id: 'perilCd',
					title : '&#160;Code',
					titleAlign: 'center',
					align: 'right',
					sortable: false,
					width : '45px'
				},
				{	id: 'bascPerlCd',
					width: '0',
					visible: false
				},
				{	id: 'distSeqNo',
					title: '&#160;Grp',
					align: 'right',
					sortable: false,
					width: '35px'
				},
				{ 	id: 'perilName',
					title : 'Peril Name',
					sortable: false,
					width : '200px'
				},
				{ 	id: 'tsiAmt',
					title : 'Sum Insured',
					titleAlign : 'right',
					sortable: false,
					geniisysClass: 'money',
					align: 'right',
					width : '145px'
				},
				{ 	id: 'premAmt',
					title : 'Premium',
					titleAlign: 'right',
					sortable: false,
					geniisysClass: 'money',
					align: 'right',
					width : '125px'
				},
				{	id: 'itemGrp',
					title: '&#160;Item Grp.',
					align: 'right',
					sortable: false,
					width: '60px'
				},
				{ 	id: 'currencyCd',
					width: '0',
					visible: false
				},
				{	id: 'currencyShrtName currencyRt',
					title: 'Currency Rate',
					width : '110px',
					children : [
			            {	id : 'currencyShrtName',
			                width : 30,
			                editable: false		
			            },
			            {	id : 'currencyRt',
			                width : 80,
			                editable: false,
			                geniisysClass: 'rate',
			                align: 'right',
			                defaultValue: "" 		
			            }
					]
				},
				{	id: 'packLineCd packSublineCd',
					title: 'Package Line',
					width : '128px',
					children : [
			            {	id : 'packLineCd',
			                width : 40,
			                editable: false		
			            },
			            {	id : 'packSublineCd',
			                width : 88,
			                editable: false,
			                defaultValue: "" 		
			            }
					]
				},
				{ 	id: 'maxDistSeqNo',
					width: '0',
					visible: false
				},
				{ 	id: 'rowNum', // added by jhing 12.05.2014
					width: '0',
					visible: false
				}, 
			],
			//requiredColumns: 'itemNo tsiAmt',
			rows: objGIUWWPerilds.objGIUWWPerildsList
		};
		
		giuwwPerildsTableGrid = new MyTableGrid(giuwwPerildsTableModel);
		giuwwPerildsTableGrid.pager = objGIUWWPerilds.objGIUWWPerildsListTableGrid;
		giuwwPerildsTableGrid.render('giuwwPerildsTableGrid');
			
	
	}catch(e){
		showErrorMessage("giuwwPerilds", e);
	}
	
	function checkIfItemsSelectedExist(){
		var check = false;
		var rows = giuwwPerildsTableGrid.getModifiedRows();
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
			validatePeril();
		}else{
			disableButton("btnNewGrp");
			disableButton("btnJoinGrp");
			// shan 08.06.2014
			giuwwPerildsTableGrid.modifiedRows = [];	
			var columnIndex = giuwwPerildsTableGrid.getColumnIndex("groupTag");
			for (var j=0; j<giuwwPerildsTableGrid.geniisysRows.length; j++){
				$("mtgInput"+giuwwPerildsTableGrid._mtgId+"_"+columnIndex+","+j).checked = false;
				$("mtgIC"+giuwwPerildsTableGrid._mtgId+"_"+columnIndex+","+j).removeClassName('modifiedCell');
			}
			// end 08.06.2014
			changedCheckedTag = 0 ; // added by jhing 12.05.2014 
		}
	}

	function uncheckGridCheckbox(divCtrId){	// shan 08.06.2014
		var objArray = giuwwPerildsTableGrid.geniisysRows;
		var columnIndex = giuwwPerildsTableGrid.getColumnIndex("groupTag");
		for (var j=0; j<objArray.length; j++){
			if (divCtrId == objArray[j].divCtrId){
				$("mtgInput"+giuwwPerildsTableGrid._mtgId+"_"+columnIndex+","+j).checked = false;
				$("mtgIC"+giuwwPerildsTableGrid._mtgId+"_"+columnIndex+","+j).removeClassName('modifiedCell');
			}
		}
		giuwwPerildsTableGrid.unselectRows;	
	}
	
	function validatePeril(){
		var rows = giuwwPerildsTableGrid.getModifiedRows();
		var objArray = giuwwPerildsTableGrid.geniisysRows;
		var previousCurrCd = "";
		var currentCurrCd = "";
		var previousCurrRt = "";
		var currentCurrRt = "";
		var groupItemGrp = "";	// shan 08.06.2014

		for(var i=0; i<rows.length; i++){
			if (i == 0) groupItemGrp = rows[i].itemGrp;	// shan 08.06.2014
			
			if (rows[i].groupTag == true){
				if (rows[i].perilType == 'B' && rows[i].groupTag == true) {
					var basicPerils = objArray.filter(function(obj){ return obj.distSeqNo == rows[i].distSeqNo && obj.perilType == 'B';});
					var alliedPerils = objArray.filter(function(obj){ return obj.distSeqNo == rows[i].distSeqNo && obj.perilType == 'A';});
					if ((basicPerils.length < 2)  && (alliedPerils.length > 0)){
						showMessageBox("Allied peril(s) for this Basic peril is still existing in its group, you are not allowed to change its grouping.", imgMessage.INFO);
						//uncheckTableGridCheckboxes(giuwwPerildsTableGrid, "groupTag"); // replaced by code below to untag only the currently selected record : shan 08.06.2014
						uncheckGridCheckbox(rows[i].divCtrId);
						return false;
					}else{
						enableButton("btnNewGrp");
						enableButton("btnJoinGrp");
						changedCheckedTag = 1 ; // added by jhing 12.05.2014 
					}
			    }
				previousCurrCd = currentCurrCd;
				currentCurrCd = rows[i].currencyCd;
				if (previousCurrCd != currentCurrCd && previousCurrCd != "" ){
					showMessageBox("Only items of the same item currency, currency rate may be grouped together as one.", imgMessage.INFO);
					/*uncheckTableGridCheckboxes(giuwwPerildsTableGrid, "groupTag"); // replaced by code below to untag only the currently selected record : shan 08.06.2014
					/giuwwPerildsTableGrid.modifiedRows = [];*/
					uncheckGridCheckbox(rows[i].divCtrId);
					return false;
				}else if (previousCurrRt != currentCurrRt && previousCurrRt != "" ){
					showMessageBox("Only items of the same item currency, currency rate may be grouped together as one.", imgMessage.INFO);
					/*uncheckTableGridCheckboxes(giuwwPerildsTableGrid, "groupTag"); // replaced by code below to untag only the currently selected record : shan 08.06.2014
					/giuwwPerildsTableGrid.modifiedRows = [];*/
					uncheckGridCheckbox(rows[i].divCtrId);
					return false;
				}else if (groupItemGrp != rows[i].itemGrp){	// shan 08.06.2014
					showMessageBox("Only items of the same item group/bill group may be grouped together as one.", imgMessage.INFO);
					uncheckGridCheckbox(rows[i].divCtrId);
					return false;
				}else {
					enableButton("btnNewGrp");
					enableButton("btnJoinGrp");
					changedCheckedTag = 1 ; // added by jhing 12.05.2014 
				}
			}/* else if (rows[i].perilType == 'B' && rows[i].groupTag == true) {	// moved above : shan 08.06.2014
				var basicPerils = objArray.filter(function(obj){ return obj.distSeqNo == rows[i].distSeqNo && obj.perilType == 'B';});
				var alliedPerils = objArray.filter(function(obj){ return obj.distSeqNo == rows[i].distSeqNo && obj.perilType == 'A';});				
				if ((basicPerils.length < 2)  && (alliedPerils.length > 0)){
					showMessageBox("Allied peril(s) for this Basic peril is still existing in its group, you are not allowed to change its grouping.", imgMessage.INFO);
					uncheckTableGridCheckboxes(giuwwPerildsTableGrid, "groupTag");
					return false;
				}else{
					enableButton("btnNewGrp");
					enableButton("btnJoinGrp");
				}
		    } */else{
				enableButton("btnNewGrp");
				enableButton("btnJoinGrp");
				uncheckGridCheckbox(rows[i].divCtrId);	// shan 08.06.2014
				changedCheckedTag = 1 ; // added by jhing 12.05.2014 
			}
		}
		
	}
</script>

