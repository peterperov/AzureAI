<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>


	<xsl:template match ="XsltPagerInfo">

		<xsl:variable name="currentPage">
			<xsl:value-of select="number(CurrentPage/text())"/>
		</xsl:variable>
		<xsl:variable name="maxPage">
			<xsl:value-of select="number(MaxPages/text())"/>
		</xsl:variable>

		<xsl:variable name="prevPage">
			<xsl:value-of select="number(CurrentPage/text()) - 1"/>
		</xsl:variable>
		<xsl:variable name="nextPage">
			<xsl:value-of select="number(CurrentPage/text()) + 1"/>
		</xsl:variable>

		<!--
		current page: <xsl:value-of select="$currentPage" />
		max page: <xsl:value-of select="$maxPage" />
		prevPage: <xsl:value-of select="$prevPage" />
		nextPage: <xsl:value-of select="$nextPage" />
		<br />
-->

		<div>
		<!-- Prev -->
		<xsl:if test="$currentPage &gt; 0">
			
			<xsl:apply-templates select="Pages/XsltPager[PageId/text() = $prevPage]" mode="prev" >
				<xsl:with-param name="currentPage" select="$currentPage"/>
			</xsl:apply-templates>
		</xsl:if>
		<!--  CurrentPage/text() -->
		<xsl:apply-templates select="Pages/XsltPager" mode="td" >
			<xsl:with-param name="currentPage" select="$currentPage"/>
		</xsl:apply-templates>

		<!-- Next -->
			<xsl:if test="$currentPage &lt; $maxPage">

				<xsl:apply-templates select="Pages/XsltPager[PageId/text() = $nextPage]" mode="next">
					<xsl:with-param name="currentPage" select="$currentPage" />
				</xsl:apply-templates>
					
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="XsltPager" mode="td">

		<xsl:param name="currentPage" />

		<xsl:variable name="page">
			<xsl:value-of select="PageId/text()"/>
		</xsl:variable>
			<xsl:choose>
				<xsl:when test="$currentPage = $page">
					<font size="+1">
						<b>
							<xsl:value-of select="PageId"/>
						</b>
					</font>
				</xsl:when>
				<xsl:otherwise>
					&#160;
					<a>
						<xsl:attribute name="href">
							file:///<xsl:value-of select="FileName/text()"/>
						</xsl:attribute>
						<xsl:attribute name="onclick">btnClickAction('page <xsl:value-of select="PageId" />');</xsl:attribute>
						<xsl:value-of select="PageId"/>
					</a>
					&#160;
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>

	<xsl:template match="XsltPager" mode="prev">
		<xsl:param name="currentPage" />
			<a>
				<xsl:attribute name="href">
					file:///<xsl:value-of select="FileName/text()"/>
				</xsl:attribute>
				<xsl:attribute name="onclick">btnClickAction('page <xsl:value-of select="PageId" />');</xsl:attribute>
				&lt; Prev
			</a>
	</xsl:template>

	<xsl:template match="XsltPager" mode="next">
		<xsl:param name="currentPage" />
			<a>
				<xsl:attribute name="href">
					file:///<xsl:value-of select="FileName/text()"/>
				</xsl:attribute>
				<xsl:attribute name="onclick">btnClickAction('page <xsl:value-of select="PageId" />');</xsl:attribute>
				Next &gt;
			</a>
	</xsl:template>


</xsl:stylesheet>
