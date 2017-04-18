<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div style="width: 100%; text-align: center;" id="acctCdListingTable" name="acctCdListingTable">
	<div class="tableHeader">
	     <label style="width: 100px; margin-left: 15px; ">Account Code</label>
		<label style="width: 100px; margin-left: 210px; ">Account Name</label>
		<label style="width: 100px; margin-left: 220px;">SL Type</label>
	</div>
</div>
<div id="acctCdTableContainer"  style="width: 100%; text-align: center;"  class="tableContainer">	
			
</div>
<div class="pager" id="pager">
	<c:if test="${noOfPages>1}">
		<div align="right">
		Page:
			<select onChange="openAccountCodeModal2(this.value);">
				<c:forEach var="i" begin="1" end="${noOfPages}" varStatus="status">
					<option value="${i}"
						<c:if test="${pageNo==i}">
							selected="selected"
						</c:if>
					>${i}</option>
				</c:forEach>
			</select> of ${noOfPages}
		</div>
	</c:if>
</div>
<script>
var objLblValues = new Object();
var objSlListingValues = new Object();
var objArray = eval('${JSONAcctCdSearchResults}');

showSearhResults(objArray);

function showSearhResults(objArray){
	try {
		var itemTable = $("acctCdTableContainer");
		
		for(var i=0; i<objArray.length; i++) {				
			var content = prepareAcctCdListInfo(objArray[i]);										
			var newDiv = new Element("div");
			newDiv.setAttribute("id", "row"+objArray[i].glAcctId);
			newDiv.setAttribute("name", "acctCdRow");
			newDiv.addClassName("tableRow");
			
			newDiv.update(content);
			itemTable.insert({bottom : newDiv});
			divEvents(newDiv);
		}
	} catch (e) {
		showErrorMessage("showSearhResults", e);
		//showMessageBox("Show account code List : " + e.message);
	}
}

function prepareAcctCdListInfo(obj){
	var slType = obj.gsltSlTypeCd == null ? "" : obj.gsltSlTypeCd;
	try {				
		var acctCdListInfo  = '<label style="width: 25px; text-align: right; margin-left: 60px;" id="lblGlAcctCategory">'+obj.glAcctCategory+'</label>' +						
						'<label style="width: 25px; text-align: right; " id="lblGlControlAcct">'+parseInt(obj.glControlAcct).toPaddedString(2)+'</label>'+
						'<label style="width: 25px; text-align: right; " id="lblGlSubAcct1">'+parseInt(obj.glSubAcct1).toPaddedString(2)+'</label>'+
						'<label style="width: 25px; text-align: right; " id="lblglSubAcct2">'+parseInt(obj.glSubAcct2).toPaddedString(2)+'</label>'+
						'<label style="width: 25px; text-align: right; " id="lblglSubAcct3">'+parseInt(obj.glSubAcct3).toPaddedString(2)+'</label>'+
						'<label style="width: 25px; text-align: right; " id="lblglSubAcct4">'+parseInt(obj.glSubAcct4).toPaddedString(2)+'</label>'+
						'<label style="width: 25px; text-align: right; " id="lblglSubAcct5">'+parseInt(obj.glSubAcct5).toPaddedString(2)+'</label>'+
						'<label style="width: 25px; text-align: right; " id="lblglSubAcct6">'+parseInt(obj.glSubAcct6).toPaddedString(2)+'</label>'+
						'<label style="width: 25px; text-align: right; " id="lblglSubAcct7">'+parseInt(obj.glSubAcct7).toPaddedString(2)+'</label>'+
						'<label style="width: 290px; text-align: left; margin-left: 40px;" name="lblAcctName">'+obj.glAcctName+'</label>' +
						'<label style="width: 50px; text-align: left; margin-left: 33px;" id="lblSlType">'+slType +'</label>' +
						'<label style="width: 50px; text-align: left; margin-left: 33px; display: none;" id="lblGlAcctId">'+ obj.glAcctId +'</label>' +
						'<label style="width: 50px; text-align: left; margin-left: 33px; display: none;" id="lblSlCd">'+ obj.slCd +'</label>' +
						'<label style="width: 50px; text-align: left; margin-left: 33px; display: none;" id="lblGuncTranId">'+ obj.guncTranId +'</label>';

						
						
		return acctCdListInfo;
	} catch (e) {
		showErrorMessage("prepareAcctCdListInfo", e);
		//showMessageBox("prepareItemNoListInfo : " + e.message);
	}
}


function divEvents(div) {
	div.observe("mouseover", function () {
		div.addClassName("lightblue");
	});
	
	div.observe("mouseout", function ()	{
		div.removeClassName("lightblue");
	});

	div.observe("click", function () {
		selectedRowId = div.getAttribute("id");
		div.toggleClassName("selectedRow");
		if (div.hasClassName("selectedRow"))	{
			$$("div[name='acctCdRow']").each(function (r)	{
				if (div.getAttribute("id") != r.getAttribute("id"))	{
					r.removeClassName("selectedRow");
				}
		    });
			setObjectValues(div);
			enableButton("acctCdBtn");
		}else{
			objLblValues = null;
			disableButton("acctCdBtn");
		} 
	});
}

$("acctCdBtn").observe("click", function (){
	$("glAcctCategory").value = objLblValues.glAcctCategory;
	$("glControlAcct").value = objLblValues.glControlAcct;
	$("acctCode1").value = objLblValues.glSubAcct1;
	$("acctCode2").value = objLblValues.glSubAcct2;
	$("acctCode3").value = objLblValues.glSubAcct3;
	$("acctCode4").value = objLblValues.glSubAcct4;
	$("acctCode5").value = objLblValues.glSubAcct5;
	$("acctCode6").value = objLblValues.glSubAcct6;
	$("acctCode7").value = objLblValues.glSubAcct7;
	$("ucAcctName").value = objLblValues.glAcctName;
	$("ucHiddenSlTypeCd").value = objLblValues.gsltSlTypeCd;
	$("ucHiddenGlAcctId").value = objLblValues.glAcctId;
	$("ucHiddenSlCd").value = objLblValues.slCd;
	$("ucHiddenGuncTranId").value = objLblValues.guncTranId;

	if ($F("ucHiddenSlTypeCd") == ""){
		$("ucSlName").disabled = true;
		$("ucSlName").style.backgroundColor = "rgb(212, 208, 200)";
	}else{
		$("ucSlName").disabled = false;
		$("ucSlName").style.backgroundColor = "cornsilk";
		new Ajax.Request(contextPath + "/GIACUnidentifiedCollnsController?action=getSlListing" , {
			method: "GET",
			parameters: {
				slTypeCd: $F("ucHiddenSlTypeCd"),
				fundCd: objACGlobal.fundCd
			},
			asynchronous: true,
			evalScripts: true,
			onComplete: function (response) {
				objSlListingValues = null;
				objSlListingValues = JSON.parse(response.responseText);
				populateSlNameDtls(objSlListingValues);
			}
		});
	}
	Modalbox.hide();
});

function populateSlNameDtls(obj){
	$("ucSlName").update('<option value="" slCode="" slName=""></option>');
	var options = "";
	for(var i=0; i<obj.length; i++){						
		options+= '<option value="'+obj[i].slCd+'" slCode="'+obj[i].slCd+'" slName="'+obj[i].slName+'">'+obj[i].slName+'</option>';
	}
	//obj[i].rvLowValue
	$("ucSlName").insert({bottom: options}); 
	$("ucSlName").selectedIndex = 0;
}

$$("label[name='lblAcctName']").each(function(lbl){
	lbl.update(lbl.innerHTML.truncate(40, "..."));
});

function setObjectValues(div){
	objLblValues.glAcctCategory = div.down("label", 0).innerHTML; 
	objLblValues.glControlAcct = div.down("label", 1).innerHTML; 
	objLblValues.glSubAcct1 = div.down("label", 2).innerHTML; 
	objLblValues.glSubAcct2 = div.down("label", 3).innerHTML; 
	objLblValues.glSubAcct3 = div.down("label", 4).innerHTML; 
	objLblValues.glSubAcct4 = div.down("label", 5).innerHTML; 
	objLblValues.glSubAcct5 = div.down("label", 6).innerHTML; 
	objLblValues.glSubAcct6 = div.down("label", 7).innerHTML; 
	objLblValues.glSubAcct7 = div.down("label", 8).innerHTML; 
	objLblValues.glAcctName = div.down("label", 9).innerHTML; 
	objLblValues.gsltSlTypeCd = div.down("label", 10).innerHTML; 
	objLblValues.glAcctId = div.down("label", 11).innerHTML; 
	objLblValues.slCd = div.down("label", 12).innerHTML == "undefined" ? "" : div.down("label", 12).innerHTML; 
	objLblValues.guncTranId = div.down("label", 13).innerHTML == "undefined" ? "" : div.down("label", 13).innerHTML;
}

</script>