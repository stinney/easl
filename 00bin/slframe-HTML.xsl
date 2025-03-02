<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	       xmlns="http://www.w3.org/1999/xhtml">
  <xsl:template match="/">
    <html>
      <head>
	<meta charset="utf-8"/>
	<title><xsl:value-of select="@n"/>Font and List</title>
	<link media="screen,projection" href="/edur/css/projcss.css" type="text/css" rel="stylesheet"/>
      </head>
      <body>
	<table class="sltab borders">
	  <thead>
	    <tr>
	      <th class="lname" colspan="2">Entry</th>
	      <th class="names">Names</th>
	      <th class="glyph">Glyph</th>
	      <th class="image">Row</th>
	    </tr>
	  </thead>
	  <xsl:apply-templates/>
	</table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="sign">
    <tbody>
      <xsl:for-each select="s">
	<tr>
	  <xsl:if test="count(preceding-sibling::*)=0">
	    <th class="lname" rowspan="{count(../*)}">
	      <xsl:value-of select="../@n"/>
	    </th>
	  </xsl:if>
	  <xsl:choose>
	    <xsl:when test="count(../*) > 1">
	      <th class="lname"><xsl:value-of select="@xml:id"/></th>
	    </xsl:when>
	    <xsl:otherwise>
	      <td/>
	    </xsl:otherwise>
	  </xsl:choose>
	  <td>
	    <div class="names">
	      <div class="sname"><xsl:value-of select="@sn"/></div>
	      <div class="uname"><xsl:value-of select="@u"/></div>
	      <div class="notes"><p><xsl:value-of select="n"/></p></div>
	    </div>
	  </td>
	  <td class="ofs-pc ofs-300">
	    <div>
	      <div>
		<span class="{@class}">
		  <xsl:value-of select="@c"/>
		</span>
	      </div>
	      <xsl:for-each select="f">
		<div>
		  <span class="{@class}"><xsl:value-of select="@c"/></span>
		</div>
	      </xsl:for-each>
	    </div>
	  </td>
	  
	  <xsl:if test="count(preceding-sibling::*)=0">
	    <td rowspan="{count(../*)}">
	      <xsl:choose>
		<xsl:when test="starts-with(../@row,'/')">
		  <img class="lrow" src="{../@row}"/>
		</xsl:when>
		<xsl:otherwise>
		  <img class="lrow" width="600px" src="/osl/{../@row}"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </td>
	  </xsl:if>
	</tr>
      </xsl:for-each>
    </tbody>
  </xsl:template>

  <xsl:template name="chr">
    <xsl:param name="c"/>
    <xsl:text disable-output-escaping="yes">&amp;#</xsl:text>
    <xsl:value-of select="$c"/>
    <xsl:text>;</xsl:text>
  </xsl:template>
  
</xsl:transform>
