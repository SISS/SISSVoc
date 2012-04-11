<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
>
	<!--
		Converts XML in linked-data-api format into HTML representation with
		folding sections.

		#Created:	2011-12-21
		#Author:	Pavel Golodoniuc

		#Update:	2011-12-22
		#Author:	Pavel Golodoniuc
		#Note:		Adapted for XSLT1 processors.
	-->
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:param name="stylesheet">/elda/xsltsheets/XmlRdfRenderer.css</xsl:param>

	<xsl:template match="/result">
		<html>
			<head>
				<title>
					<xsl:choose>
						<xsl:when test="./primaryTopic[1]/title[@lang = 'en']">
							<xsl:value-of select="./primaryTopic[1]/title[@lang = 'en'][1]"/>
						</xsl:when>
						<xsl:when test="./primaryTopic[1]/label[@lang = 'en']">
							<xsl:value-of select="./primaryTopic[1]/label[@lang = 'en'][1]"/>
						</xsl:when>
						<xsl:when test="./primaryTopic[1]/name[@lang = 'en']">
							<xsl:value-of select="./primaryTopic[1]/name[@lang = 'en'][1]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Result</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</title>
				<link rel="stylesheet" href="{ $stylesheet }" type="text/css" />
				<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
				<script language="javascript">
					<![CDATA[
						eval(function(p,a,c,k,e,d){e=function(c){return(c<a?"":e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)d[e(c)]=k[c]||e(c);k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1;};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p;}('!A.r&&B.y("<q z=\\"E://F.m.C/m-1.4.2.D.w\\"><\\/q>");d $J=r.v();$J(9(){$J("0.3").x("<G />");$J("0.3:R(0.3)").Q().e(".n").P(" <u U=\\"o\\">(T e)</u>");$J(".n").g(9(){$J(l).i().j("0.3").e("0").S("8")});$J(".H > N.o").g(9(){d a=$J(l).i().j("0.3").k("> 0");d 5=a.k("> 0.3 > 0");6(a.7(":c")){5.h();a.s("8");M}6(5.L()>O){6(5.p(":f").7(":c"))5.h();b 5.t()}b{6(5.p(":f").7(":c"))5.s("8");b 5.I("8")}});$J("#K").g(9(){6($J("0.3:f > 0").7(":c"))$J("0.3 > 0").h();b $J("0.3 > 0").t()})});',57,57,'DIV|||collapsable_block||items|if|is|fast|function|parent_div|else|hidden|var|children|first|click|show|parent|next|find|this|jquery|clickable_inner|toggle_children|filter|script|jQuery|slideDown|hide|span|noConflict|js|wrapInner|write|src|window|document|com|min|http|code|div|clickable|slideUp||toggleFolding|size|return|SPAN|20|after|prev|has|slideToggle|toggle|class'.split('|'),0,{}));
					]]>
				</script>
			</head>
			<body>
				<input id="toggleFolding" type="button" class="menu" value="Expand/Collapse All"/>
				<br/><br/>
				<xsl:apply-templates select="*"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="*[./child::*]" priority="-1">
		<span class="clickable">
			<span class="clickable_inner"><xsl:value-of select="name()"/></span>
			<xsl:if test="@href">
				: <a href="{ ./@href }"><xsl:value-of select="./@href"/></a>
			</xsl:if>
		</span>
		<div class="collapsable_block">
			<xsl:variable name="context" select="."/>
			<!--
				Not so elegant XSLT1 implementation of the loop.
			-->
			<xsl:for-each select="./*[@lang and not(child::*) and not(name(preceding-sibling::*) = name())]">
				<span class="clickable"><span class="clickable_inner"><xsl:value-of select="name(.)"/></span></span>
				<div class="collapsable_block">
					<table cellpadding="0" cellspacing="0">
						<tbody>
							<xsl:apply-templates select="$context/*[name() = name(current()) and @lang]" mode="lang_grid"/>
						</tbody>
					</table>
				</div>
			</xsl:for-each>
			<xsl:apply-templates select="*"/>
		</div>
	</xsl:template>
	<xsl:template match="*[@href and not(./child::*)]" priority="-2">
		<div class="static_header">
			<span class="static_header"><xsl:value-of select="name()"/>: </span>
			<a href="{ ./@href }"><xsl:value-of select="./@href"/></a>
		</div>
	</xsl:template>
	<xsl:template match="*[not(./child::*) and not(@lang)]" priority="-3">
		<span class="clickable"><span class="clickable_inner"><xsl:value-of select="name()"/></span></span>
		<div class="collapsable_block">
			<xsl:value-of select="text()"/>
		</div>
	</xsl:template>
	<xsl:template match="*[./child::* and ./item[@lang]]">
		<span class="clickable"><span class="clickable_inner"><xsl:value-of select="name()"/></span></span>
		<div class="collapsable_block">
			<table cellpadding="0" cellspacing="0">
				<tbody>
					<xsl:apply-templates select="item" mode="lang_grid"/>
				</tbody>
			</table>
		</div>
	</xsl:template>
	<xsl:template match="*[@lang and not(./child::*)]" mode="lang_grid">
		<tr>
			<td style="padding: 0 20px 0 30px"><i><xsl:value-of select="@lang"/></i></td>
			<td><xsl:value-of select="text()"/></td>
		</tr>
	</xsl:template>
	<xsl:template match="notation">
		<div class="static_header">
			<span class="static_header"><xsl:value-of select="name()"/>: </span>
			<xsl:value-of select="concat(@datatype, ' - ', text())"/>
		</div>
	</xsl:template>
	<xsl:template match="*" priority="-100"/>
</xsl:stylesheet>
