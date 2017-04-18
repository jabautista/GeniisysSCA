<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<!--nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles -->
<!--nieko new JSP-->

<div id="quotationDeductibleTable" name="quotationDeductibleTable" style="width : 100%;">
	<div id="quotationDeductibleTableGridSectionDiv" class="">
		<div id="quotationDeductibleTableGridDiv" style="padding: 10px;">
			<div id="quotationDeductibleTableGrid" style="height: 198px; width: 900px;"></div>
		</div>
		<div style="height:30px; width: 915px;">
			<table  align="right">
				<tr>
					<td class="rightAligned" style="padding-right: 20px;">Total Deductible Amount</td>
					<td ><input class="rightAligned" style="width: 166px;"  type="text" id="amtTotal" name="amtTotal" readonly="readonly"/></td>
				</tr>
			</table>
		</div>
	</div>	
</div>

<script type="text/javascript">
	var objSelected = null;
	var rowIndex = -1;

	function setQuote(obj){		
		$("txtDeductibleCd1").value				= (obj == null ? "" : obj.dedDeductibleCd);
		$("txtDeductibleDesc1").value			= (obj == null ? "" : obj.deductibleTitle);
		$("deductibleText1").value				= (obj == null ? "" : obj.deductibleText);
		$("deductibleRate1").value				= (obj == null ? "" : formatToNineDecimal(obj.deductibleRate)); //Modified by Jerome 11.18.2016 SR 5737
		$("btnAddDeductible1").value			= (obj == null ? "Add" : "Update");
		
		$("inputDeductibleAmount1").value 		= (obj == null ? "" : formatCurrency(obj.deductibleAmt));
		$("aggregateSw1").checked				= (obj == null ? false : nvl(obj.aggregateSW, "N") == "Y" ? true : false);
		$("ceilingSw1").checked 				= obj != null ? (obj.ceilingSw == "Y" ? true : false) : false;
		
		if(obj == null){
			$("hrefDeductible1").show();
			disableButton("btnDeleteDeductible1");
		}else{
			$("hrefDeductible1").hide();
			enableButton("btnDeleteDeductible1");
		}
		
	}

	try{		
		var objQuoteDeduc = {};
		objQuoteDeduc.rowlist = JSON.parse('${tbgQuotationDeductible}');
		objQuoteDeduc.exitPage = null;
		
		var amtTotal = 0;
		var quotationDeductibleTableGrid = {
			url : contextPath + "/GIPIQuotationDeductiblesController?action=refreshQuoteDeductibleTable&refresh=1&quoteId=" + objGIPIQuote.quoteId ,
			options : {
				width : '900px',
				masterDetail : true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objSelected = tbgQuotationDeductible.geniisysRows[y];
					
					tbgQuotationDeductible.keys.releaseKeys();
					setQuote(objSelected);
				},
				onCellBlur : function(){
				},
				onRemoveRowFocus : function(){
					setQuote(null);
				},
				masterDetailValidation : function(){
				},
				masterDetailSaveFunc : function(){
				},
				masterDetailNoFunc : function(){
					setQuote(null);
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				onRefresh : function(){
					setQuote(null);
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
					id : 'quoteId',
					width : '0px',
					visible : false
				},
				{
					id : 'aggregateSW',
					title: '&#160;&#160;A',
					width : '23px',
					align : 'center',
					titleAlign : 'center',
					defaultValue: false,
				  	otherValue: false,				  	
				  	editable: false,
				  	sortable : false,
				  	editor: new MyTableGrid.CellCheckbox({					  	
						getValueOf: function(value){		      	
							if (value){
								return "Y";
		            		}else{
								return "N";	
		            		} 		
		            	}})	
				},
				{
					id : 'ceilingSw',
					title: '&#160;&#160;C',
					width : '23px',
					align : 'center',
					titleAlign : 'center',
					defaultValue: false,
				  	otherValue: false,				  	
				  	editable: false,
				  	sortable : false,
				  	editor: new MyTableGrid.CellCheckbox({					  	
						getValueOf: function(value){		       	
							if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}            		
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
					width : '250px',
					filterOption : true
               },
               {
					id : 'deductibleRate',
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
					id : 'deductibleAmt',
					title : 'Amount',
					width : '150px',
					type : 'number',
					geniisysClass : 'money'
               }
			],
			rows : objQuoteDeduc.rowlist.rows
		};
		tbgQuotationDeductible = new MyTableGrid(quotationDeductibleTableGrid);
 		tbgQuotationDeductible.pager =  objQuoteDeduc.rowlist;
		tbgQuotationDeductible.render("quotationDeductibleTableGrid");
		tbgQuotationDeductible.afterRender = function(){			
			setQuote(null);
			if(tbgQuotationDeductible.geniisysRows.length != 0){
				amtTotal=tbgQuotationDeductible.geniisysRows[0].totalDeductible;
			}
			$("amtTotal").value = formatCurrency(amtTotal).truncate(13, "...");
		}; 		
	}catch(e){
		showErrorMessage("Quotation Deductible Listing", e);
	}
	
	$("btnDeleteDeductible1").observe("click", function ()	{
		try {
			deleteRec();
		} catch (e) {
			showErrorMessage("btnDeleteDeductible1" , e);
		}		
	});
	
	function deleteRec(){
		objSelected.recordStatus = -1;
		tbgQuotationDeductible.deleteRow(rowIndex);
		computeTotalAmountInTable(-1*parseFloat(nvl(unformatCurrency("inputDeductibleAmount1"),0)));
		changeTag = 1;
		setQuote(null);
		updateTGPager(tbgQuotationDeductible);	
	}
	
	$("btnAddDeductible1").observe("click", function ()	{
		try {
			if(checkAllRequiredFieldsInDiv("quotationDeductDiv")){
				checkQuoteDeductibles();
			}
		} catch (e) {
			showErrorMessage("btnAddDeductible1" , e);
		}		
	});
	
	function addRec(){
		try {
			var dept = setDeductibleObj();
			if($F("btnAddDeductible1") == "Add"){
				tbgQuotationDeductible.addBottomRow(dept);
				computeTotalAmountInTable(unformatCurrency("inputDeductibleAmount1"));
			} else {
				tbgQuotationDeductible.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setQuote(null);
			tbgQuotationDeductible.keys.removeFocus(tbgQuotationDeductible.keys._nCurrentFocus, true);
			tbgQuotationDeductible.keys.releaseKeys();
			updateTGPager(tbgQuotationDeductible);

		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function checkQuoteDeductibles(){
		try {
			var dept = setDeductibleObj();
			if($F("btnAddDeductible1") == "Add"){
				new Ajax.Request(contextPath+"/GIPIQuotationDeductiblesController", {
					method: "POST",
					parameters: {action: 		  "checkQuoteDeductibles",
								 deductibleType:  dept.deductibleType,
								 dedLevel: 		  1,
								 globalQuoteId:	  objGIPIQuote.quoteId,
								 itemNo: 		  0
								 },
					onCreate: function() {	
						setCursor("wait");
						$("btnAddDeductible1").disable();	
					},
					onComplete: function (response) {					
						setCursor("default");
						$("btnAddDeductible1").enable();	
						if(checkErrorOnResponse(response)){
							if ("SUCCESS" == response.responseText) {
								addRec();
								return;
							} else {
								showMessageBox(response.responseText, imgMessage.ERROR);
								setQuote(null);
								return false;
							}
						}
					}
				});
			}
			else{
				addRec();
			}
		} catch(e){
			showErrorMessage("checkQuoteDeductibles", e);
		}
	}

	function computeTotalAmountInTable(deductibleAmt) {
		try {
			var total=unformatCurrency("amtTotal");
			total =parseFloat(total) + (parseFloat(nvl(deductibleAmt,0)));
			$("amtTotal").value = formatCurrency(total).truncate(13, "...");
		} catch (e) {
			showErrorMessage("computeTotalAmountInTable", e);
		}
	}
	
	function setDeductibleObj(){
		try{
			var objDeductible = new Object();
			
			objDeductible.quoteId				= objGIPIQuote.quoteId;
			objDeductible.dedLineCd				= objGIPIQuote.lineCd;
			objDeductible.dedSublineCd			= nvl($("subline").getAttribute("sublineCd"), $F("subline"));
			
			objDeductible.itemNo 			= 0;
			objDeductible.perilCd 			= 0;
			objDeductible.dedDeductibleCd 	= escapeHTML2($F("txtDeductibleCd1"));	
			objDeductible.deductibleTitle 	= escapeHTML2($F("txtDeductibleDesc1"));	
			objDeductible.deductibleAmt 	= $F("inputDeductibleAmount1") == "" ? null : $F("inputDeductibleAmount1"); 
			objDeductible.deductibleRate 	= $F("deductibleRate1") == "" ? null : $F("deductibleRate1"); 
			objDeductible.deductibleText	= escapeHTML2($F("deductibleText1"));	
			objDeductible.aggregateSW		= $("aggregateSw1").checked ? "Y" : "N";	
			objDeductible.ceilingSw		 	= $("ceilingSw1").checked ? "Y" : "N"; 	
			objDeductible.deductibleType 	= $("txtDeductibleCd1").getAttribute("deductibleType");
			
			objDeductible.maxAmt			= $("txtDeductibleCd1").getAttribute("maxAmt");
			objDeductible.minAmt			= $("txtDeductibleCd1").getAttribute("minAmt");
			objDeductible.rangeSw			= $("txtDeductibleCd1").getAttribute("rangeSw");
			
			
			return objDeductible;
		}catch(e){
			showErrorMessage("setDeductibleObj", e);
		}
	}
</script>
