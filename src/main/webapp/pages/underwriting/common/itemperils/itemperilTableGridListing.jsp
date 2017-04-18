<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="parItemPerilTable" name="parItemPerilTable" style="width : 100%;">
	<div id="parItemPerilTableGridSectionDiv" class="">
		<div id="parItemPerilTableGridDiv" style="padding: 10px;">
			<div id="parItemPerilTableGrid" style="height: 198px; width: 900px;"></div>
		</div>
	</div>
</div>

<script type="text/javascript">
	try{
		objUW.hidObjGIPIS010 = {};
		objUW.hidObjGIPIS010.perilChangeTag = 0;
		objGIPIWPolWC = JSON.parse('${jsonWPolWCList}'.replace(/\\/g, '\\\\'));
		var objItemPerils = JSON.parse('${tgItemPerils}');	
		//belle 09132012
		var cntItmperlGrp = 0; 
		for (var i=0; i<objGIPIWItmperlGrouped.length; i++){
			if(objGIPIWItmperlGrouped[i].itemNo == $F("itemNo")){
				cntItmperlGrp++;
			}
		} 
		
		function setPerilForAccident(){
			//if(getLineCd() == "AC" && objGIPIWItmperlGrouped.length > 0){ 
			if(getLineCd() == "AC" && cntItmperlGrp > 0){ //belle 09132012
				//showMessageBox("There are existing grouped item perils and you cannot modify, add or delete perils in current item.", imgMessage.INFO); // andrew - 05.18.2012 - comment out - message should be on the onCellFocus event only
				
				$("hrefPeril").hide();
				disableButton($("btnAddItemPeril"));
				disableButton($("btnDeletePeril"));
				disableButton($("btnCreatePerils"));
				disableButton($("btnCopyPeril"));
				//belle 09132012
				$("perilRate").readOnly = true;
				$("perilTsiAmt").readOnly = true;
				$("premiumAmt").readOnly = true;
				$("compRem").readOnly = true;
				$("perilBaseAmt").readOnly = true;
				$("chkAggregateSw").disabled = true; //vondanix 7.13.2016 - MAC 22652

			}else{
				//$("hrefPeril").show();
				//enableButton($("btnDeletePeril"));
				//enableButton($("btnCreatePerils"));
				enableButton($("btnAddItemPeril"));
				if(objGIPIWItem.length > 1) {
					enableButton($("btnCopyPeril"));
				} else {
					disableButton($("btnCopyPeril"));
				}
				
				if(objItemPerils.rows.length > 0){ //added by Apollo Cruz 09.10.2014 (temp solution)
					disableButton("btnCreatePerils");
				} else if(objItemPerils.defaultTag == "Y") {
					enableButton($("btnCreatePerils"));
				} else {
					disableButton($("btnCreatePerils"));
				}
				
				//belle 09132012
				$("perilRate").readOnly = false;
				$("perilTsiAmt").readOnly = false;
				$("premiumAmt").readOnly = false;
				$("compRem").readOnly = false;
				$("perilBaseAmt").readOnly = false;
			}
		}
		
		var tbItemPerils = {
			url : contextPath + "/GIPIWItemPerilController?action=refreshItemPerilsTable&parId=" + objUWParList.parId + "&itemNo=" + $F("itemNo") +
				"&lineCd=" + objUWParList.lineCd + "&issCd=" + objUWParList.issCd,
			options : {
				width : '900px',
				masterDetail : true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					var objSelected = tbgItemPeril.geniisysRows[y];
					objCurrItemPeril = tbgItemPeril.geniisysRows[y];
					
					objSelected.totalNoOfRecords = objItemPerils.rows.length;
					
					tbgItemPeril.keys.releaseKeys();
					setItemPerilForm(objSelected);
					setItemDeductibleForm(null, 3);

					// retrieve child records
					retrieveDeductibles(objCurrItem.parId, objSelected.itemNo, 3, objSelected.perilCd);
					
					setPerilForAccident();
					setPackagePlanPeril();	//added by Gzelle 09262014
					getDefPerilAmts("delete");	//added by Gzelle 12022014
					//if(getLineCd() == "AC" && objGIPIWItmperlGrouped.length > 0){ // andrew - 05.18.2012 
					if(getLineCd() == "AC" && cntItmperlGrp > 0){ //belle 09132012
						showMessageBox("There are existing grouped item perils and you cannot modify, add or delete perils in current item.", imgMessage.INFO);
					}
					//added by steve 10/24/2012
					if(changeTag == 1 && objUW.hidObjGIPIS010.perilChangeTag == 1){
						showConfirmBox4("Save", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
									function(){
										$("btnSave").click();
									}, 
									function(){
										resetItemObjects();
										changeTag = 0;
										objUW.hidObjGIPIS010.perilChangeTag = 0;
									}, "");						
					}
					//steven: end
				},
				onCellBlur : function(){
					//
				},
				onRemoveRowFocus : function(){
					objCurrItemPeril = null;									
					setItemPerilForm(null);
					setPerilForAccident();
					deleteParItemTG(tbgPerilDeductible);
					setItemDeductibleForm(null, 3);
					
					//added by steve 10/24/2012
					if(changeTag == 1 && objUW.hidObjGIPIS010.perilChangeTag == 1){
						showConfirmBox4("Save", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
									function(){
										$("btnSave").click();
									}, 
									function(){
										resetItemObjects();
										changeTag = 0;
										objUW.hidObjGIPIS010.perilChangeTag = 0;
									}, "");						
					}
					//steven: end
					tbgItemPeril.keys.releaseKeys();
				},
				beforeSort: function(){ // Nica - 05.24.2012
					var objArrFiltered = getAddedAndModifiedJSONObjects(objDeductibles).concat(getDeletedJSONObjects(objDeductibles));
					var objArrFilteredByPeril = objArrFiltered.filter(function(obj){	return nvl(obj.perilCd, 0) > 0;	});

					if(objArrFilteredByPeril.length > 0 || 
							(getAddedAndModifiedJSONObjects(objGIPIWItemPeril).length > 0 || getDeletedJSONObjects(objGIPIWItemPeril).length > 0)){						
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				masterDetailValidation : function(){
					var objArrFiltered = getAddedAndModifiedJSONObjects(objDeductibles).concat(getDeletedJSONObjects(objDeductibles));
					var objArrFilteredByPeril = objArrFiltered.filter(function(obj){	return nvl(obj.perilCd, 0) > 0;	});

					if(objArrFilteredByPeril.length > 0 || 
							(getAddedAndModifiedJSONObjects(objGIPIWItemPeril).length > 0 || getDeletedJSONObjects(objGIPIWItemPeril).length > 0)){						
						return true;
					}else{						
						return false;
					}					
				},
				masterDetailSaveFunc : function(){
					$("btnSave").click();
				},
				masterDetailNoFunc : function(){
					objGIPIWItemPeril 	= objItemTempStorage.objGIPIWItemPeril.slice(0);				
					setItemPerilForm(null);
					//tbgPerilDeductible.empty();					
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				}
			},
			columnModel : [
				{
					id : 'recordStatus',
					width : '23px',
					editor : 'checkbox',
					visible : false
				},
				{
					id : 'divCtrId',
					width : '0px',
					visible : false
				},
				{
					id : 'parId',
					width : '0px',
					visible : false
				},				
				{
					id : 'lineCd',
					width : '0px',
					visible : false
				},				
				{
					id : 'itemNo',
					title : 'Item No.',
					width : '60px',
					sortable : false,			
					renderer : function(value){
						return lpad(value.toString(), 9, "0");
	           		}
				},				
				{
					id : 'perilName',
					title : 'Peril Name',
					width : '178px',
					filterOption : true
				},
				{
					id : "premRt",
					title : "Rate",
					titleAlign : 'right',
					width : '100px',					
					type : 'number',					
					geniisysClass : 'rate'
				},
				{
					id : 'tsiAmt',
					title : 'TSI Amount',
					titleAlign : 'right',
					width : '100px',
					type : 'number',
					geniisysClass : 'money'
				},
				{
					id : 'premAmt',
					title : 'Prem Amount',
					titleAlign : 'right',
					width : '100px',
					type : 'number',
					geniisysClass : 'money'
				},
				{
					id : 'compRem',
					title : 'Remarks',
					width : '220px',
					filterOption : true,			
					renderer : function(value){
						return unescapeHTML2(value);
	           		}
               	},
               	{
					id : 'aggregateSw',
					title: '&#160;&#160;A',
					width : '23px',
					align : 'center',
					altTitle: 'Aggregate Switch',
					titleAlign : 'center',
					//defaultValue: "N",
					defaultValue: false,
				  	otherValue: false,				  	
				  	editable: false,
				  	sortable : false,
				  	editor: new MyTableGrid.CellCheckbox({					  	
						getValueOf: function(value){		            		
							//return value == "Y" ? true : false;
							if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}
		            	}})					
				},
				{
					id : 'surchargeSw',
					title: '&#160;&#160;S',
					width : '23px',
					align : 'center',
					altTitle: 'With Surcharge',
					titleAlign : 'center',
					defaultValue: "N",
				  	otherValue: false,				  	
				  	editable: false,
				  	sortable : false,
				  	editor: new MyTableGrid.CellCheckbox({					  	
						getValueOf: function(value){		            		
							return (value) ? "Y" : "N";		            		
		            	}})
				},
				{
					id : 'discountSw',
					title: '&#160;&#160;D',
					width : '23px',
					align : 'center',
					altTitle: 'With Discount',
					titleAlign : 'center',
					defaultValue: "N",
				  	otherValue: false,				  	
				  	editable: false,
				  	sortable : false,
				  	editor: new MyTableGrid.CellCheckbox({					  	
						getValueOf: function(value){		            		
							return (value) ? "Y" : "N";		            		
		            	}})
				}/*,
				{
					id : 'perilCd',
					width : '0px',
					visible : false
					
				},
				{
					id : 'tarfCd',
					width : '0px',
					visible : false
					
				},
				{
					id : 'annTsiAmt',
					width : '0px',
					visible : false
					
				},
				{
					id : 'annPremAmt',
					width : '0px',
					visible : false
					
				},
				{
					id : 'recFlag',
					width : '0px',
					visible : false
					
				},
				{
					id : 'prtFlag',
					width : '0px',
					visible : false
					
				},
				{
					id : 'riCommRate',
					width : '0px',
					visible : false
					
				},
				{
					id : 'riCommAmt',
					width : '0px',
					visible : false
					
				},
				{
					id : 'asChargeSw',
					width : '0px',
					visible : false
					
				},
				{
					id : 'baseAmt',
					width : '0px',
					visible : false
					
				},
				{
					id : 'noOfDays',
					width : '0px',
					visible : false
					
				}*/
			],
			id : 4,
			rows : objItemPerils.rows
		};
		
		tbgItemPeril = new MyTableGrid(tbItemPerils);
		tbgItemPeril.pager = objItemPerils;
		tbgItemPeril._mtgId = 4;
		tbgItemPeril.render('parItemPerilTableGrid');
		tbgItemPeril.afterRender = function(){
			//objGIPIWItemPeril = objItemPerils.allRecords;
			objGIISPerilClauses = objItemPerils.perilClauses;
			objGIISPeril = objItemPerils.defaultPerils;
			objGIISPackPlanPeril = objItemPerils.packPlanPerils;	//added by Gzelle 09092014
			setItemPerilForm(null);

			getTotalAmounts2();
			
			setPerilForAccident();
		};
		
		function setPackagePlanPeril() {	//added by Gzelle 09262014
			if (objGIPIWPolbas.planSw == "Y" && objFormParameters.paramOra2010Sw == "Y") {
				$("hrefPeril").hide();
				$("perilRate").readOnly = true;
				$("premiumAmt").readOnly = true;
				$("perilBaseAmt").readOnly = true;
				$("txtPerilTarfDesc").readOnly = true;
			}
		}
		
	}catch(e){
		showErrorMessage("Item Peril Listing", e);
	}
</script>