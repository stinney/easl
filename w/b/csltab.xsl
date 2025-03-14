<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	       xmlns="http://www.w3.org/1999/xhtml"
	       xmlns:esp="http://oracc.org/ns/esp/1.0">

  <xsl:template match="csltabs">
    <esp:page>
      <esp:name>CSL Tables</esp:name>
      <esp:title>Corpus Sign List Tables</esp:title>
      <html>
	<head/>
	<body>
	  <div>
	    <xsl:apply-templates/>
	  </div>
	</body>
      </html>
    </esp:page>
  </xsl:template>

  <xsl:template match="csltab">
    <div>
      <esp:h>Table of <xsl:value-of select="@n"/></esp:h>
      <table class="csltab">
	<thead>
	  <tr>
	    <th scope="col">Sign</th>
	    <th scope="col">#</th>
	    <th scope="col">Char</th>
	    <th scope="col">Site</th>
	    <th scope="col">IV/pub</th>
	    <th scope="col">IV/unp</th>
	    <th scope="col">IV/all</th>
	    <th scope="col">III/pub</th>
	    <th scope="col">III/unp</th>
	    <th scope="col">III/all</th>
	  </tr>
	</thead>
	<xsl:apply-templates/>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="o">
    <tbody>
      <xsl:apply-templates/>
    </tbody>
  </xsl:template>

  <xsl:template match="b[c/@t]">
    <tr>
      <xsl:choose>
	<xsl:when test="count(preceding-sibling::b[c/@t])=0">
	  <th rowspan="5" scope="rowgroup">
	    <xsl:value-of select="ancestor::o/@n"/>
	  </th>
	  <th rowspan="5" scope="rowgroup">
	    <xsl:value-of select="ancestor::o/@c"/>
	  </th>
	  <th rowspan="5" scope="rowgroup"><xsl:value-of select="ancestor::o/@u"/></th>
	</xsl:when>
	<xsl:otherwise>
	  <!--<th/><th/>-->
	</xsl:otherwise>
      </xsl:choose>
      <th scope="row"><xsl:value-of select="@n"/></th>
      <xsl:apply-templates mode="emit"/>
    </tr>
  </xsl:template>

  <xsl:template mode="emit" match="c">
    <td><xsl:value-of select="@c"/></td>
  </xsl:template>

  <xsl:template match="text()"/>
  
</xsl:transform>
