#!/bin/sh
00bin/tag-adds.plx '\+' 00etc/do-add.lst
00bin/tag-adds.plx '\-' 00etc/do-remove.lst
00bin/tag-adds.plx 'c' 00etc/do-newglyph.lst
00bin/tag-adds.plx 'd' 00etc/do-delete.lst
00bin/tag-adds.plx 'i' 00etc/do-ignore.lst
00bin/tag-adds.plx 'n' 00etc/do-rename.lst
