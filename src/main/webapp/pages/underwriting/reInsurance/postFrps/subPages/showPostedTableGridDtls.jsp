<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="contentsDiv">
	<table>
		<tr>
			<td class="rightAligned"><b>FRPS No. :</b></td>
			<td class="leftAligned"><b><label id="lblParNo" style="margin-left:10px;"></label></b></td>
		</tr>
	</table>

	<div style="padding: 10px; height: 230px; background-color: #ffffff; overflow: auto;" id="binderListTableGrid" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 10;">
		<input type="button" id="btnOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnSavePosted"class="button" value="Save" style="width: 60px;" />
	</div>
</div>
<script type="text/javascript">
	objUW.modifiedRows = null;
	try {
		objUW.objBinderListTableGrid = JSON.parse('${binderListTableGrid}'.replace(/\\/g, '\\\\'));
		objUW.objBinderList = objUW.objBinderListTableGrid.rows || [];
			
		var binderTableModel = {
				//url: contextPath+"/GIRIFrpsRiController?action=refreshBinderTableGridListing" , // replaced by andrew - 1.8.2012
				url: contextPath+"/GIRIFrpsRiController?action=refreshBinderListTableGrid&frpsYy="+objRiFrps.frpsYy+"&lineCd="+objRiFrps.lineCd+"&frpsSeqNo="+objRiFrps.frpsSeqNo,
				options:{
					title: '',
					hideColumnChildTitle: true,
					width: '565px',
					height:'230px',
					pager: {
					},
					onRowDoubleClick: function(y){
						var row = binderListTableGrid.geniisysRows[y];
						
					},
					onCellFocus: function(element, value, x, y, id){
						var mtgId = binderListTableGrid._mtgId;
					},
					onCellBlur: function (element, value, x, y, id) {
						objUW.modifiedRows = binderListTableGrid.getModifiedRows();
					},
					prePager : function(){ 
						objUW.modifiedRows = binderListTableGrid.getModifiedRows(); 
						if (objUW.modifiedRows.length > 0){
							showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
						}  else {
							return true;
						}		
					},
					masterDetailValidation: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetail: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetailRequireSaving: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetailNoFunc: function(){
						return (changeTag == 1 ? true : false);
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN]
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
						id: 'fnlBinderId',
						title: 'FnlBinderId',
						width: '0px',
						sortable: false,
						align: 'left',
						visible: false
					},	
						
					{
						id: 'riName',
						//title: 'Ri Name',
						title: 'Reinsurer', // bonok :: 10.16.2013 :: SR473 - genqa
						width: '240px',
						sortable: false,
						align: 'left',
						visible: true
					},	
	
					{
						id: 'binderNo',
						title: 'Binder No.',
						width: '90px',
						sortable: false,
						align: 'left',
						visible: true
					},		
	
					{
						id: 'binderDate',
						title: 'Binder Date',
						width: '80px',
						sortable: false,
						editable: true,
						align: 'center',
						visible: true,
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {

							if(checkDate2(value)){
								var inputDate = Date.parse(value);
								var coords = binderListTableGrid.getCurrentPosition();
			                    var x = coords[0]*1;
			                    var y = coords[1]*1;
									if (inputDate != null){
					                    binderListTableGrid.setValueAt(inputDate.format("mm-dd-yyyy"), binderListTableGrid.getColumnIndex('binderDate'), y);
					                    return true;
									}else if (inputDate == null && binderListTableGrid.getRow(y).binderDate != ""){
										showMessageBox("Binder Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO);
										binderListTableGrid.setValueAt("", binderListTableGrid.getColumnIndex('binderDate'), y);
										return false;
									}
									return true;
								}	
							}
						})	
					},	
	
					{
						id: 'refBinderNo',
						title: 'Ref Binder No.',
						width: '120px',
						sortable: false,
						editable: true,
						align: 'left',
						visible: true,
						maxlength: '30',
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								var coords = binderListTableGrid.getCurrentPosition();
			                    var x = coords[0]*1;
			                    var y = coords[1]*1;
								if (value != null){
				                    binderListTableGrid.setValueAt(value, binderListTableGrid.getColumnIndex('refBinderNo'), y);
				                    return true;
								}
								return true;
							}
						})
					},	
				],
				resetChangeTag: true,
				rows: objUW.objBinderList
		};
	
		binderListTableGrid = new MyTableGrid(binderTableModel);
		binderListTableGrid.pager = objUW.objBinderListTableGrid;
		binderListTableGrid.render('binderListTableGrid');
			
	} catch(e){
		showErrorMessage("showPostedTableGridDtls.jsp", e);
	}

	function saveBinderDtls(){
		try {
			objUW.modifiedRows = binderListTableGrid.getModifiedRows(); 
			if (objUW.modifiedRows.length == 0){
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
				return false;
			}
			
			new Ajax.Request(contextPath + "/GIRIBinderController?action=saveBinderDtlsGiris026", {
				method: "POST",
				parameters: {
					modifiedRows: prepareModifiedRows()
				} ,
				evalScripts: true,
				asynchronous: false,
				onComplete: function (response){
					var result = response.responseText;
					if (result == "SUCCESS") {
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						changeTag = 0;
						binderListTableGrid.keys.removeFocus(binderListTableGrid.keys._nCurrentFocus, true);
						binderListTableGrid.keys.releaseKeys();
						binderListTableGrid._refreshList();
					}
				}	
			});
		}catch (e){
			showErrorMessage("showPostedTableGridDtls.jsp", e);
		}
	}

	function prepareModifiedRows(){
		var modifiedBinderDtls	= getModifiedJSONObject(objUW.modifiedRows);
		
		var objParameters = new Object();
		objParameters.modifiedBinderDtls = modifiedBinderDtls;

		return JSON.stringify(objParameters);
	}

	function getModifiedJSONObject(obj){
		var tempObjArray = new Array();
		if (obj != null) {
			for(var i=0; i<obj.length; i++) {	
				tempObjArray.push(obj[i]);
			}
		}
		
		return tempObjArray;
	}
	
	$("btnOk").observe("click", function() {
		//Modalbox.hide(); 
		overlayOpenPostFrps.close(); // bonok :: 10.16.2013 :: changed Modalbox to Overlay.show
	});

	$("btnSavePosted").observe("click", function() {
		saveBinderDtls();
	});
	
	$("lblParNo").innerHTML = $F("frpsNo");
	
	// bonok :: 10.16.2013 :: copied from common.js, edited the message to comply with testcase / SR473
	function checkDate2(value){
		var reLong = /\b\d{1,2}[\/-]\d{1,2}[\/-]\d{4}\b/;
	   // var reShort = /\b\d{1,2}[\/-]\d{1,2}[\/-]\d{2}\b/;
		var returnval=false;
		
		if (reLong.test(value) /*|| reShort.test(inputDate.value)*/){
			var delimChar = (value.indexOf("/") != -1) ? "/" : "-";
			var monthfield=value.split(delimChar)[0];
			var dayfield=value.split(delimChar)[1];
			var yearfield=value.split(delimChar)[2];

			var testDate = new Date(yearfield, monthfield-1, dayfield);
				if (testDate.getDate() == dayfield) {
		        	if (testDate.getMonth() + 1 == monthfield) {
						if (testDate.getFullYear() == yearfield) {
			                return true;
			            } else {
			            	showMessageBox("Invalid year.", imgMessage.INFO);
			            	return false;
			            }
			        } else {
			        	showMessageBox("Invalid month.", imgMessage.INFO);
			        	return false;
			        }
			    } else {
			    	showMessageBox("Invalid date.", imgMessage.INFO);
			    	return false;
			    }
		}else{
			showMessageBox("Binder Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO);
			return false;
		}
	}
</script>