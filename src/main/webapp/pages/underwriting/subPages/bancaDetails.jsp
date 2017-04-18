<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="bancaDetailsDiv" changeTagAttr="true">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
		  	<label>Bancassurance Details</label>
		  	<span class="refreshers" style="margin-top: 0;">
		  		<label id="showBancaDetails" name="gro" style="margin-left: 5px;">Show</label>
		   	</span>
	  	</div>
	</div>
	
	<div id="bancaDetailsInfo" class="sectionDiv" style="display: none;">
		<div id="bancTypeDtlTableMainDiv" name="bancTypeDtlTableMainDiv" style="width: 921px;">
			<div id="searchResultbancTypeDtl" align="center" style="margin: 10px;">
				<div style="width: 810px; text-align: center;" id="bancTypeDtlTable" name="bancTypeDtlTable">
					<div class="tableHeader">
						<label style="width:  90px;font-size: 10px; text-align: center;">Intm. No.</label>
						<label style="width:  90px;font-size: 10px; text-align: center;">Item No.</label>
						<label style="width: 300px;font-size: 10px; text-align: center;">Intermediary Name</label>
						<label style="width: 280px;font-size: 10px; text-align: center;">Intermediary Type</label>
						<label style="width:  20px;font-size: 10px; text-align: center;">F</label>
					</div>
					<div class="tableContainer" id="bancTypeDtlTableContainer" name="tableContainer" style="display: inline"></div>
				</div>
			</div>
		</div>
	
		<div id="bankPaymentDetailsSecDiv" style="margin:10px auto;" align="center">
			<table width="630px">
				<tr>
					<td class="rightAligned" width="200px">Bancassurance Type</td>
					<td class="leftAligned"  width="400px" colspan=3>
						<input type="text" id="txtBancTypeCd" 	name="txtBancTypeCd" 	value="${banca.bancTypeCd }" 	readonly="readonly" style="width: 50px;"/>
						<input type="text" id="txtBancTypeDesc" name="txtBancTypeDesc" 	value="${banca.bancTypeDesc }" 	readonly="readonly" style="width:370px;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="200px">Rate</td>
					<td class="leftAligned"  width="400px" colspan=3>
						<input type="text" id="txtBancRate" 	name="txtBancRate" 	value="${banca.rate }" 	readonly="readonly" style="width:432px;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="200px">Intermediary No./Name</td>
					<td class="leftAligned"  width="400px" colspan=3>
						<input type="text"   id="txtBancaIntmNo"   				name="txtBancaIntmNo" 				value="" 	readonly="readonly" style="width: 50px; text-align: right"/>
						<input type="hidden" id="txtBancaIntmName" 				name="txtBancaIntmName" 			value=""/>
						<input type="hidden" id="isBancaIntmOkForValidation" 	name="isBancaIntmOkForValidation" 	value="N"/> <!-- used for checking if banca intm is ok for validation -->
						<div style="border: 1px solid gray; width: 376px; height: 21px; float: right; margin-top: 2px;">
							<input style="width: 346px; float: left; border: none; height: 14px; margin-top: 0;" id="txtBancaDrvIntmName" name="txtBancaDrvIntmName" readonly="readonly" type="text" value=""/>
					    	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmIntermediary" name="oscmIntermediary" alt="Go" style="float: right'"/>
					    </div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="200px">Item No</td>
					<td class="leftAligned"  width="55px">
						<input type="text" id="txtBancaItemNo" 	name="txtBancaItemNo" 	value="" 	readonly="readonly" style="width:  50px; text-align: right"/>
					</td>
					<td class="rightAligned" width="130px">Intermediary Type</td>
					<td class="leftAligned"  width="215px">
						<input type="hidden" id="txtBancaIntmType" 		name="txtBancaIntmType" 	value=""/>
						<input type="text" 	 id="txtBancaIntmTypeDesc"  name="txtBancaIntmTypeDesc" value=""   readonly="readonly" style="width: 231px;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="200px">Share Percentage</td>
					<td class="leftAligned"  width="400px" colspan=3>
						<input type="text" 		id="txtBancaSharePercentage" 	name="txtBancaSharePercentage" 	value=""  style="width:  50px; text-align: right" readonly="readonly" />
						<input type="checkbox" 	id="chkBancaFixedTag" 			name="chkBancaFixedTag" 		value="N" style="margin-left: 20px" disabled/> Fixed
					</td>
				</tr>
				<tr align="center">
					<td colspan=4>
						<input type="button" class="button" style="width: 80px;" id="btnBancaApply" 	name="btnBancaApply" 	value="Apply" />
						<input type="button" class="button" style="width: 80px;" id="btnBancaCancel" 	name="btnBancaCancel" 	value="Cancel" />
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>