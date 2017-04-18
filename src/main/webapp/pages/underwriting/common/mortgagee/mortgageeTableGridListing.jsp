<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="mortgageeTable" name="mortgageeTable" style="width : 100%;">
	<div id="mortgageeTableGridSectionDiv" class="">
		<div id="mortgageeTableGridDiv" style="padding: 10px;">
			<div id="mortgageeTableGrid" style="height: 198px; width: 900px;"></div>
		</div>
	</div>	
</div>

<script type="text/javascript">
	try{		
		var objMortgs = JSON.parse('${tgMortgagees}');
		var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
		var itemNo = $F("mortgageeLevel") == 0 ? 0 : $F("itemNo");
		$("userId").value = '${userId}';
		
		var tbMortgagee = {
			url : contextPath + "/GIPIParMortgageeController?action=refreshMortgageeTable&parId=" + parId + "&itemNo=" + itemNo +
					"&issCd=" + objUWParList.issCd,
			options : {
				width : '900px',
				masterDetail : true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					var objSelected = tbgMortgagee.geniisysRows[y];
					
					tbgMortgagee.keys.releaseKeys();
					setMortgageeFormTG(objSelected);
				},
				onCellBlur : function(){
					//
				},
				onRemoveRowFocus : function(){
					setMortgageeFormTG(null);
				},
				masterDetailValidation : function(){
					if(getAddedAndModifiedJSONObjects(objMortgagees).length > 0 || getDeletedJSONObjects(objMortgagees).length > 0){
						return true;
					}else{
						return false;
					}
				},
				masterDetailSaveFunc : function(){
					$("btnSave").click();
				},
				masterDetailNoFunc : function(){
					objMortgagees = objItemTempStorage.objGIPIWMortgagee.slice(0);				
					setMortgageeFormTG(null);						
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				}
			},
			columnModel : [
               {
					id : 'recordStatus',
					width : '20px',
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
					id : 'issCd',
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
               		},
               		visible : false
               },
               {
					id : 'mortgCd',
					title : 'Mortgagee Cd',
					width : '90px'
               },
               {
					id : 'mortgName',
					title : 'Mortgagee Name',
					width : '250px',					
					filterOption : true
               },
               {
					id : 'amount',
					title : 'Amount',
					width : '135px',
					type : 'number',					
					geniisysClass : 'money'
               },
               {
					id : 'remarks',
					title : 'Remarks',
					width : '275px',					
					filterOption : true,
					renderer: function(value) {		//added by Gzelle 02032015
						return unescapeHTML2(value);	
					}
               },
				//added deleteSw kenneth SR 5483 05.26.2016
               {
					id : 'deleteSw',
					title : 'D',
					altTitle : 'Delete Switch',
					width : '30px',
					align : 'center',
					titleAlign : 'center',
					defaultValue : false,
					otherValue : false,
					visible: $("lblModuleId").getAttribute("moduleId") != "GIPIS031" ? false : true,
					editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				}
			],
			rows : objMortgs.rows,
			id : 6	
		};

		tbgMortgagee = new MyTableGrid(tbMortgagee);
		tbgMortgagee.pager = objMortgs;
		tbgMortgagee._mtgId = 6;
		tbgMortgagee.render('mortgageeTableGrid');		
		tbgMortgagee.afterRender = function(){
			tbgMortgagee.keys.releaseKeys();
			
			if($F("mortgageeLevel") == 0){
				objMortgagees = objMortgs.allRecords;
				objItemTempStorage.objGIPIWMortgagee = objMortgs.allRecords.slice(0);
			}			
		};
	}catch(e){
		showErrorMessage("Mortgagee Listing", e);
	}
</script>