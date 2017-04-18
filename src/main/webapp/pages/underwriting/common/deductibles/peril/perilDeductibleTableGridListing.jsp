<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="perilDeductibleTable" name="perilDeductibleTable" style="width : 100%;">
	<div id="perilDeductibleTableGridSectionDiv" class="">
		<div id="perilDeductibleTableGridDiv" style="padding: 10px;">
			<div id="perilDeductibleTableGrid" style="height: 198px; width: 900px;"></div>
		</div>
		<div style="height:30px; width: 915px;">
			<table  align="right">
				<tr>
					<td class="rightAligned" style="padding-right: 20px;">Total Deductible Amount:</td>
					<td ><input class="rightAligned" style="width: 166px;"  type="text" id="perilAmtTotal" name="perilAmtTotal" readonly="readonly"/></td>
				</tr>
			</table>
		</div>
	</div>	
</div>

<script type="text/javascript">
	try{
		var objItemPerilDeductible = JSON.parse('${tgPerilDeductibles}');
		var amtTotal = 0;
		var tbPerilDeductibles = {
			url : contextPath + "/GIPIWDeductibleController?action=refreshPerilDeductibleTable&parId=" + objUWParList.parId + "&itemNo=" + $F("itemNo") + "&perilCd=" + $F("perilCd"),
			options : {
				width : '900px',
				masterDetail : true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					var objSelected = tbgPerilDeductible.geniisysRows[y];
					
					tbgPerilDeductible.keys.releaseKeys();
					setItemDeductibleForm(objSelected, 3);
				},
				onCellBlur : function(){
					//
				},
				onRemoveRowFocus : function(){
					tbgPerilDeductible.keys.releaseKeys();
					setItemDeductibleForm(null, 3);
				},				
				masterDetailValidation : function(){
					if(objDeductibles.filter(function(obj){	return obj.recordStatus != null && obj.perilCd > 0;	}).length > 0){
						return true;
					}else{
						return false;
					}
				},
				masterDetailSaveFunc : function(){
					$("btnSave").click();
				},
				masterDetailNoFunc : function(){
					objDeductibles = objItemTempStorage.objGIPIWDeductibles.slice(0);					
					setItemDeductibleForm(null, 3);								
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
					id : 'aggregateSw',
					title: '&#160;&#160;A',
					width : '23px',
					align : 'center',
					titleAlign : 'center',
					defaultValue: "N",
				  	otherValue: false,				  	
				  	editable: false,
				  	sortable : false,
				  	editor: new MyTableGrid.CellCheckbox({
				  		getValueOf: function(value){		            		
				  			return value ? "Y" : "N"; // changed by Kenneth 05.09.2014 return value == "Y" ? true : false;		            		
		            	}})		
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
					id : 'deductibleTitle',
					title : 'Deductible Title',
					width : '234px',
					filterOption : true
               },
               {
					id : 'deductibleText',
					title : 'Deductible Text',
					width : '270px',
					filterOption : true
               },
               {
					id : "deductibleRate",
					title : "Rate",
					width : '100px',
					align : 'right',			
					renderer : function(value){
						if(value != null){
							return formatToNineDecimal(value);
						}else{
							return "";
						}						
	          		}
			   },
               {
					id : 'deductibleAmount',
					title : 'Amount',
					width : '150px',
					type : 'number',
					geniisysClass : 'money'
               },
               {
	           		id : 'dedDeductibleCd',
	           		width : '0px',
	           		visible : false
	           },
               {
            		id : 'dedLineCd',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'dedSublineCd',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'userId',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'perilCd',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'ceilingSw',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'dedType',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'minimumAmount',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'maximumAmount',
            		width : '0px',
            		visible : false
            	},
            	{
            		id : 'rangeSw',
            		width : '0px',
            		visible : false
            	}
			],
			id : 5,
			rows : objItemPerilDeductible.rows
		};

		tbgPerilDeductible = new MyTableGrid(tbPerilDeductibles);
		tbgPerilDeductible.pager = objItemPerilDeductible;
		tbgPerilDeductible._mtgId = 5;
		tbgPerilDeductible.render('perilDeductibleTableGrid');
		tbgPerilDeductible.name = "tbgPerilDeductible";
		tbgPerilDeductible.afterRender = function(){					
			//objItemPerilDeductibles = objItemDeductibles.concat(objItemPerilDeductible.allRecords);
			setItemDeductibleForm(null, "3");
			if(tbgPerilDeductible.geniisysRows.length != 0){
				amtTotal=tbgPerilDeductible.geniisysRows[0].totalDeductible;
			}
			$("perilAmtTotal").value = formatCurrency(amtTotal).truncate(13, "...");
		};
	}catch(e){
		showErrorMessage("Peril Deductible Listing", e);
	}
</script>