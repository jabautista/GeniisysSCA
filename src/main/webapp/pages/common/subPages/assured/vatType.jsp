<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>VAT Type</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" id="lblHideVatType" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>

<div id="vatType" class="sectionDiv">
	<div style="margin: 10px; margin-left: 230px; display: block; height: 20px;">
		<span style="float: left; width: 120px; text-align: left;"><input type="radio" value="3" id="rateVat" name="vatType" tabindex="4" checked="checked" /> <label for="rateVat" style="float: none;">VAT Rate</label></span>
		<span style="float: left; width: 120px; text-align: left;"><input type="radio" value="1" id="exemptVat" name="vatType" tabindex="5" /> <label for="exemptVat" style="float: none;">VAT Exempt</label></span>
		<span style="float: left; width: 120px; text-align: left;"><input type="radio" value="2" id="zeroVat" name="vatType" tabindex="6" /> <label for="zeroVat" style="float: none;">Zero VAT</label></span>
	</div>
</div>
<script>
	<c:if test="${assured.vatTag eq '3'}">
		$("rateVat").checked = true;
	</c:if>
	<c:if test="${assured.vatTag eq '1'}">
		$("exemptVat").checked = true;
	</c:if>
	<c:if test="${assured.vatTag eq '2'}">
		$("zeroVat").checked = true;
	</c:if>
</script>