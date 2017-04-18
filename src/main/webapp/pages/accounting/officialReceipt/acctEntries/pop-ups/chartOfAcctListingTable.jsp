<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="glAcctTableListDiv" style="overflow-x: scroll;">
	<div id="acctTableHeader" class="tableHeader" style="font-size: 9px; min-width: 100%; white-space: nowrap;">
		<label style="width: 400px; text-align: left; margin-left: 3px; float: left;" name="glName">Gl Acct Name</label>
		<label style="width: 50px; text-align: center; margin-left: 3px;" name="lblHeader">Acct Ctgy</label>
		<label style="width: 50px; text-align: center; margin-left: 3px;" name="lblHeader">Control Acct</label>
		<label style="width: 50px; text-align: center; margin-left: 3px;" name="lblHeader">Sub Acct 1</label>
		<label style="width: 50px; text-align: center; margin-left: 3px;" name="lblHeader">Sub Acct 2</label>
		<label style="width: 50px; text-align: center; margin-left: 3px;" name="lblHeader">Sub Acct 3</label>
		<label style="width: 50px; text-align: center; margin-left: 3px;" name="lblHeader">Sub Acct 4</label>
		<label style="width: 50px; text-align: center; margin-left: 3px;" name="lblHeader">Sub Acct 5</label>
		<label style="width: 50px; text-align: center; margin-left: 3px;" name="lblHeader">Sub Acct 6</label>
		<label style="width: 50px; text-align: center; margin-left: 3px;" name="lblHeader">Sub Acct 7</label>
	<!-- <label style="width: 50px; text-align: center; margin-left: 3px;" name="lblHeader">Acct Id</label> -->
	</div>
	<div id="glAcctTableDiv" name="glAcctTableDiv" style="white-space: nowrap;" class="tableContainer"></div>
</div>
<jsp:include page="/pages/common/utils/pager.jsp"></jsp:include>

<script type="text/javascript">
	var glAcctObjArray = JSON.parse('${glAcctList}'.replace(/\\/g, '\\\\'));
	var selectedObj;
	
	var acctCtgy;
	var ctrlAcct;
	var subAcct1;
	var subAcct2;
	var subAcct3;
	var subAcct4;
	var subAcct5;
	var subAcct6;
	var subAcct7;
	var acctName;
	var acctId;
	var slTypeCd;
	
	var itemSelected = 0;
	var keyword = "";
	var pageNo = 1;
	
	createGlAcctsTable(glAcctObjArray);
	
	function createGlAcctsTable(objArray) {
		try {
			var tableContainer = $("glAcctTableDiv");
			for(var i=0; i<objArray.length; i++) {
				var content = prepareAcctList(objArray[i]);
				var newRow = new Element("div");
				newRow.setAttribute("id", 	"acct" + objArray[i].glAcctId);
				newRow.setAttribute("name", "acct");
				newRow.setAttribute("class","tableRow");
				newRow.setStyle("overflow", "visible");
				newRow.setStyle({fontSize: '9px'});
				
				newRow.update(content);
				tableContainer.insert({bottom:newRow});
	
				$("acctTableHeader").style.width = "950px";
				$("glAcctTableDiv").style.width = "950px";
				//checkIfToResizeTable("glAcctTableListDiv", "acct");
				checkTableIfEmpty("acct", "glAcctListingDiv");
			}
		} catch(e) {
			showErrorMessage("createGlAcctsTable", e);
			//showMessageBox("createGlAcctsTable: " + e.message);
		}
	}
	
	function prepareAcctList(obj) {
		var acct = "";
		try {
			acct = 	'<label style="width: 400px; text-align: left; margin-left: 0px;" name="glName">'+ obj.glAcctName.truncate(65, "...") +'</label>' +
					'<label style="width: 50px; text-align: center; margin-left: 3px;">'+ obj.glAcctCategory +'</label>' +
					'<label style="width: 50px; text-align: center; margin-left: 3px;">'+ obj.glControlAcct +'</label>' +
					'<label style="width: 50px; text-align: center; margin-left: 3px;">'+ obj.glSubAcct1 +'</label>' +
					'<label style="width: 50px; text-align: center; margin-left: 3px;">'+ obj.glSubAcct2 +'</label>' +
					'<label style="width: 50px; text-align: center; margin-left: 3px;">'+ obj.glSubAcct3 +'</label>' +
					'<label style="width: 50px; text-align: center; margin-left: 3px;">'+ obj.glSubAcct4 +'</label>' +
					'<label style="width: 50px; text-align: center; margin-left: 3px;">'+ obj.glSubAcct5 +'</label>' +
					'<label style="width: 50px; text-align: center; margin-left: 3px;">'+ obj.glSubAcct6 +'</label>' +
					'<label style="width: 50px; text-align: center; margin-left: 3px;">'+ obj.glSubAcct7 +'</label>' +
					'<input type="hidden" id="listedAcctId" value="'+ obj.glAcctId +'" />' +
					'<input type="hidden" id="listedSlTypeCd" value="'+ obj.gsltSlTypeCd +'"'/* +
					'<label style="width: 50px; text-align: center; margin-left: 3px;">'+ obj.glAcctId +'</label>'*/;
			return acct;
		} catch (e) {
			showErrorMessage("prepareAcctList", e);
			//showMessageBox("prepare Acct List: " + e.message);
		}
	}
	
	$$("div[name='acct']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
	
			row.observe("dblclick", function() {
				if(itemSelected == 1) {
					loadSelected();
				} else {
					hideOverlay();
				} 
			});
	
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					try {
						$$("div[name='acct']").each(function (r)	{
							if (row.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
								itemSelected = 0;
							}
						});
						
						var temp = row.down("input", 0).value;
						for(var i=0; i<glAcctObjArray.length; i++) {
							if(temp == glAcctObjArray[i].glAcctId) {
								acctCtgy	=	glAcctObjArray[i].glAcctCategory;
								ctrlAcct	=	glAcctObjArray[i].glControlAcct;
								subAcct1	=	glAcctObjArray[i].glSubAcct1;
								subAcct2	=	glAcctObjArray[i].glSubAcct2;
								subAcct3	=	glAcctObjArray[i].glSubAcct3;
								subAcct4	=	glAcctObjArray[i].glSubAcct4;
								subAcct5	=	glAcctObjArray[i].glSubAcct5;
								subAcct6	=	glAcctObjArray[i].glSubAcct6;
								subAcct7	=	glAcctObjArray[i].glSubAcct7;
								acctName	=	glAcctObjArray[i].glAcctName;
								acctId		= 	glAcctObjArray[i].glAcctId;
								slTypeCd	=	glAcctObjArray[i].gsltSlTypeCd;
								
								itemSelected =  1;
							}
						}
						
					} catch (e){
						showErrorMessage("chartOfAcctListingTable.jsp - div[name='acct']", e);
					}
				}
				else {
					
			}});
		}
	);
	
	$("okSelected").observe("click", function() {
		if(itemSelected == 1) {
			loadSelected();
		} else {
			hideOverlay();
		} 
	});
	
/*	$("cancelSelect").observe("click", function() {
		modalBox.hide();
	});*/
	
	function loadSelected() {
		$("inputGlAcctCtgy").value 	= formatToTwoDecimal(acctCtgy);
		$("inputGlCtrlAcct").value 	= formatToTwoDecimal(ctrlAcct);
		$("inputSubAcct1").value 	= formatToTwoDecimal(subAcct1);
		$("inputSubAcct2").value 	= formatToTwoDecimal(subAcct2);
		$("inputSubAcct3").value 	= formatToTwoDecimal(subAcct3);
		$("inputSubAcct4").value 	= formatToTwoDecimal(subAcct4);
		$("inputSubAcct5").value 	= formatToTwoDecimal(subAcct5);
		$("inputSubAcct6").value 	= formatToTwoDecimal(subAcct6);
		$("inputSubAcct7").value 	= formatToTwoDecimal(subAcct7);
		$("inputGlAcctName").value 	= acctName;
		$("inputGlAcctId").value 	= acctId;
		hideOverlay();
		$("hidSlTypeCd").value = slTypeCd;
		if(slTypeCd == null || slTypeCd == "") {
			$("inputSlName").removeClassName("required");
			$("selectSlDiv").removeClassName("required");
		} else {
			$("inputSlName").addClassName("required");
			$("selectSlDiv").addClassName("required");
		}
		$("inputGlAcctName").setAttribute("readonly", "readonly");
		$("inputSlName").clear();
	}
	
	$$("label[name='lblHeader']").each(function (label)	{
		if ((label.innerHTML).length > 5)	{
			label.update((label.innerHTML).truncate(8, ""));
		}
	});
	/*	
	$$("label[name='glName']").each(function (label)	{
		if ((label.innerHTML).length > 52)	{
			label.update((label.innerHTML).truncate(50, "..."));
		}
	});
	*/	
	if (!$("pager").innerHTML.blank()) {
		try {
			var acctIdObj = getGlAcctObj();
			keyword=$("keyword").value;
			initializePagination("glAcctListingDiv", "/GIACAcctEntriesController?gaccTranId="+
					objACGlobal.gaccTranId+"&acctIdObj="+acctIdObj+"&act=1&keyword="+keyword, "showChartOfAccts");
		} catch (e) {
			showErrorMessage("chartOfAcctListingTable.jsp - pager", e);
			//showMessageBox("pager: " + e.message);
		}
	}
	
	function getGlAcctObj() {
		var acctIdObj = new Object();
		acctIdObj.glAcctCategory	=	$F("inputGlAcctCtgy") == "" ? null : parseInt($F("inputGlAcctCtgy"));
		acctIdObj.glControlAcct		=	$F("inputGlCtrlAcct") == "" ? null : removeLeadingZero($F("inputGlCtrlAcct"));
		acctIdObj.glSubAcct1		=	$F("inputSubAcct1") == "" ? null : removeLeadingZero($F("inputSubAcct1"));
		acctIdObj.glSubAcct2		=	$F("inputSubAcct2") == "" ? null : removeLeadingZero($F("inputSubAcct2"));
		acctIdObj.glSubAcct3		=	$F("inputSubAcct3") == "" ? null : removeLeadingZero($F("inputSubAcct3"));
		acctIdObj.glSubAcct4		=	$F("inputSubAcct4") == "" ? null : removeLeadingZero($F("inputSubAcct4"));
		acctIdObj.glSubAcct5		=	$F("inputSubAcct5") == "" ? null : removeLeadingZero($F("inputSubAcct5"));
		acctIdObj.glSubAcct6		=	$F("inputSubAcct6") == "" ? null : removeLeadingZero($F("inputSubAcct6"));
		acctIdObj.glSubAcct7		=	$F("inputSubAcct7") == "" ? null : removeLeadingZero($F("inputSubAcct7"));
		return JSON.stringify(acctIdObj);
	}
	
	function formatToTwoDecimal(num) {
		num = parseInt(num);
		return num.toPaddedString(2);
	}
	
	$("pager").setStyle("margin-top: 10px;");
	
	$("search").observe("click", function () {
		toggleDisplayElement("searchSpan", .3, "appear", focusSearchText);
	});
	
	$("searchEntry").observe("click", function () {
		keyword=$("keyword").value;
		var acctIdObj = getGlAcctObj();
		goToPageNoSearchSpanFixed("glAcctListingDiv", "/GIACAcctEntriesController?gaccTranId="+
				objACGlobal.gaccTranId+"&acctIdObj="+acctIdObj+"&act=1&keyword="+keyword, "showChartOfAccts", 1);
	});
	
	$("keyword").observe("keypress", function (evt) {
		if (13 == evt.keyCode) {
			keyword = $("keyword").value;
			var acctIdObj = getGlAcctObj();
			goToPageNoSearchSpanFixed("glAcctListingDiv", "/GIACAcctEntriesController?gaccTranId="+
					objACGlobal.gaccTranId+"&acctIdObj="+acctIdObj+"&act=1&keyword="+keyword, "showChartOfAccts", 1);
		}
	});
</script>