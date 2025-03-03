<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	       xmlns:xh="http://www.w3.org/1999/xhtml"
	       version="1.0">

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:apply-templates select=".//xh:body/xh:p[contains(.,'signs')]" mode="ok"/>
  </xsl:template>
  
  <xsl:template mode="ok" match="xh:body/xh:p">
    <xsl:variable name="t">
      <xsl:choose>
	<xsl:when test="contains(.,'Non')">I</xsl:when>
	<xsl:otherwise>N</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:apply-templates select="following-sibling::xh:table[1]/xh:tr[.//xh:img]">
      <xsl:with-param name="t" select="$t"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="xh:tr">
    <xsl:param name="t"/>
    <xsl:value-of select="$t"/><xsl:text>&#x9;</xsl:text>
    <xsl:value-of select="xh:td[2]/text()"/><xsl:text>&#x9;</xsl:text>
    <xsl:value-of select="xh:td[1]/xh:img/@src"/><xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="*"/>
  
  <xsl:template match="text()"/>
</xsl:transform>
