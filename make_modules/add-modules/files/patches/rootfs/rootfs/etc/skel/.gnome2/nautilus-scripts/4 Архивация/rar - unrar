#!/bin/bash -x 
#
#
# Nautilus script -> 	Ultimate Archive Tool for Nautilus
#			Compress and decompress dynamic 
#			Multilang
#
# Owner 	: Largey Patrick Switzerland
# 	    	patrick.largey@nazeman.org
#	  	 www.nazeman.org
# Co-Owner  : David Westlund
#	      daw@wlug.westbo.se
# 
# Licence : GNU GPL 
# 
# Copyright (C) Nazeman
#
# Dependency : zenity
#			: tar, bzip2, gzip, zip
#			: gunzip, bunzip2, unzip, unrar
#			: Nautilus
#			: unace -> http://www.winace.com/
#			: and Gnu tools -> grep, sed, which, etc...
#
# Encoding UTF-8
#
# Ver: 1.40 Date 24.03.2004
# Remove gdialog and add support for zenity
#
# Ver: 1.30 Date: 04.04.2003
# Add compatibilty with Nautilus 2.x
#
# Ver: 1.21 Date 06.01.2002
# Add compatibility with Xdialog + some improvemenz in code thanks to shellscript-fr(at)debianworld.org
#
# Ver: 1.20 Date 04.01.2002
# Add decompress file witout extension or with a false extension !!yeah!!
# + some small fixes + better scripting
#
# Ver: 1.15 Date 20.10.2002
# Add check and recover action for parchive (http://parchive.sourceforge.net)
# + make a .par 
#
# Ver: 1.13 Date 13.06.2002
# Add Italian from Gianluca Romito <romito(at)intercomp.it>
#
# Ver: 1.12 Date 10.5.2002
# Fix Bug with "ace" format from Boris de Laage de Meux (emak(at)free.fr)
#
# Ver: 1.11 Date 22.03.2002
# Add please wait dialog in decompress mode
#
# Ver: 1.10 Date 11.03.2002
# Add possibilty default config (archiver-config script)
# Add Estonian from Tõivo Leedjärv (toivo(at)linux.ee)
#
# Ver: 1.01 Date 28.02.2002
# Bug fix (thanks Shane) Add Portuguese from Rafael Rigues (rigues(at)conectiva.com.br)
#
# Ver: 1.00 Date 27.02.2002
# Yeah ! version 1.00 (I hope is no BUG)
# Add translation in "Esperanto" from Eric (eclesh(at)pacbell.net)
# Bugfix with Unzip (space file) + German update
#
# Ver : 0.9.9-6 Date 7.2.2002
# Add idea from David (check if programm is available)
# Add rar format 
#
# Ver : 0.9.9-5 Date 31.01.2002
# Bugfix with : zip a directory , is recursive yet
# Add no case sensitiv (tgz, TGZ, TgZ,...)
#
# Ver : 0.9.9-4 Date 22.01.2002
# me: Add dialog for unarchive "yes or no"
# Please test all possibility to find bug to ver 1.00
#
# Ver: 0.9.9-2 Date 21.01.2002
# me: Add .Z Format compress and uncompress
# Add .ace format to decompress 
# Add Dialog for decompress to overwrite file by David
# Some correction in force to decompress 
# better recognise file if archive or not
#
# Ver: 0.9.9-1 Date 20.01.2002
# me: Add script uncompress_all, please wait ....
# Add some correction by David Westlund
# make a check to find what is for file
# if file is an archive -> decompress else compress
#
# Ver: 0.9.8 Date 12.01.2002
# me: Add Dialog with compressor choice
# tar.gz, tar.bz2, zip, gz, bz2
# Please update with rar and unrar (I don't have)
#
# Ver: 0.9.4 Date: 11.05.2001
# Support for swedish
# Don't create files with names like archive.tar.gz.tar.gz or archive.tgz.tar.gz
# If the input is just one file, the archive will be called <filename>.tar.gz as default
# Added by David Westlund
# 
# Ver: 0.9.3 Date: 10.09.2001
# me: added file mit space !!!
#
# Ver: 0.9.2 Date: Sept 9, 2001
# me: added confirm windows + German Support
#
# Ver: 0.9.1 Date: Sept 5, 2001
# Shane Mueller added patch from Manuel Clos to add Spanish support
#
# Ver : 0.9 Date : 11.08.2001
#
curpath=`echo $NAUTILUS_SCRIPT_CURRENT_URI | sed 's/file\:\/\///'`
if [ ! -z $curpath ]
then
	cd $curpath
else 
	cd `pwd`
fi
#
# Default language
#
		filename="File name?"
		fileexist="File exists. Overwrite?"
		title="Archiver-Unarchiver"
		archive="archive"
		compressor="extension:  archive: "
		decompressor="Do you want to uncompress: "
		valid="available"
		notvalid="not available"
		pleasewait="Please wait...."
		warning="Warning!"
		beuh="Unknown format."
		ncompr="could not be uncompressed."
		compr="has been uncompressed."		
		rec="was created successfully."
		overwrite="The following files will be overwritten: "
		proceed="Do you want to proceed?" 
		parchive="Parchive : "
		parmiss="Cannot recover, too many file missing"
		parok="parity archive valid"
		parnotok=" lacking, recover ?"
		format="format"
		info="information"
		choix="choice"
case $LANG in
	fr* )
		filename="Nom du Fichier ?"
		fileexist="Fichier existant, écraser ?"
		title="Archiveur-Desarchiveur"
		archive="archive"
		decompressor="Voulez vous désarchiver : "
		compressor="Extension de l'archive : "
		valid="disponible"
		notvalid="non disponible"
		pleasewait="Veuillez patientez ....."
		warning="! Attention !"
		beuh="format inconnu."
		ncompr="ne peut être décompressé."
		compr="est décompressé."		
		rec="est enregistré." 
		overwrite="les fichiers suivant seront écrasé: "
		proceed="Voulez-vous poursuirvre ?" 
		parchive="Parchive : "
		parmiss="Impossible de reconstruire, trop de fichier manquant."
		parok="archive de parité valide."
		parnotok=" manquant, reparez ?"
		format="extension"
		info="information"
		choix="choice";;
 	es* )
		filename="¿Nombre del archivo?"
		fileexist="El archivo ya existe, ¿sobreescribir?"
		title="Archivar" 
		archive="archivo"
		compressor="¿extensión del archivo?"
		decompressor="¿ Quiere descomprimir "
		valid="disponible"
		notvalid="no disponible"
		pleasewait="Por favor, espere..."
		warning="¡ Cuidado !"
		beuh="Formato desconocido"
		ncompr="no se puede descomprimir"
		compr="se descomprimió correctamente."	
		rec="se creó correctamente" 
		overwrite="los archivos suiguientes serán sobreescritos: "
		proceed="¿ Quiere continuar ?" ;;
	de* )
		filename="Dateiname ?"
		fileexist="Datei existiert bereits, überschreiben ?"
		title="Archiver-Desarchiver"
		archive="archiv"
		compressor="Extension von Archiv : "
		decompressor="wollen Sie dekomprimieren : "
		valid="Gültig"
		notvalid="Nicht gültig"
		pleasewait="Bitte warten ...."
		warning="! Warnung !"
		beuh="unbekanntes Format"
		ncompr="kann nicht dekomprimieren"
		compr="ist komprimiert"		
		rec="ist gespeichert" 
		overwrite="soll(en) diese Datei(en) überschriebenerden: "
		proceed="Wollen Sie weitermachen ?" ;;
	eo* )
		filename="Dosiera nomo?"
		fileexist="Dosiero ekzistas.  Æu superskribu?"
		title="Ar¶igilo-Malar¶ivigilo"
		archive="ar¶ivo"
		compressor="Fina¼o de la ar¶ivo?"
		decompressor="Æu vi volas malar¶ivigi: "
		valid="havebla"
		notvalid="nehavebla"
		pleasewait="Bonvolu atendi..."
		warning="Avertu!"
		beuh="Nekonata formato"
		ncompr="Ne povis kompresigi"
		compr="estas kompresigita"
		rec="øuste kreita"
		overwrite="La sekvantaj dosieroj superskribiøos: "
		proceed="Æu vi volas procedi?";;
	pt* )	
		filename="Nome do arquivo?"
		fileexist="O arquivo já existe. Sobrescrever?"
		title="Compactador-Descompactador"
		archive="arquivo"
		compressor="extensão:  arquivo: "
		decompressor="Você quer descompactar: "
		valid="disponível"
		notvalid="não disponível"
		pleasewait="Aguarde...."
		warning="Aviso!"
		beuh="Formato desconhecido."
		ncompr="não pôde ser descompactado."
		compr="foi descompactado."              
		rec="foi criado com sucesso."
		overwrite="Os seguintes arquivos serão sobrescritos: "
		proceed="Deseja continuar?" ;;
	sv* )
		filename="Filnamn?"
		fileexist="Filen existerar, vill du skriva över?"
		title="tar.gz-arkiverare"
		compressor="Filändelse arkiv :"
		decompressor="Vill du packa upp : "
		archive="arkiv"
		#valid="????"
		#notvalid="????"
		pleasewait="Var god vänta..."
		warning="! Varning !"
		beuh="Okänt format"
		ncompr="kunde inte packas upp korrekt"
		compr="är uppackad"             
		rec="är sparad" 
		overwrite="Följande filer kommer skrivas över: "
		proceed="Vill du fortsätta?" ;;
	et* )
		filename="Faili nimi?"
		fileexist="Fail on juba olemas. Kas kirjutada üle?"
		title="Arhivaator"
		archive="arhiiv"
		compressor="laiend:    arhiiv: "
		decompressor="Kas sa tahad lahti pakkida: "
		valid="võimalik"
		notvalid="ei ole võimalik"
		pleasewait="Palun oota...."
		warning="Hoiatus!"
		beuh="Tundmatu vorming."
		ncompr=": ei saa lahti pakkida."
		compr="lahti pakitud."
		rec="edukalt loodud."
		overwrite="Järgnevad failid kirjutatakse üle: "
		proceed="Kas tahad jätkata?" ;;
	it* )		
		filename="Nome File?"
		fileexist="Il file esiste. Sovrascriverlo?"
		title="Compressore Decompressore"
		archive="archivio"
		compressor="estensione:  archivio: "
		decompressor="Vuoi decomprimere: "
		valid="disponibile"
		notvalid="non disponivile"
		pleasewait="Attendere per favore...."
		warning="Attenzione!"
		beuh="Formato sconosciuto."
		ncompr="non puo' essere decompresso."
		compr="e' stato decompresso."		
		rec="e' stato creato con successo."
		overwrite="I seguenti files saranno sovrascritti: "
		proceed="Vuoi procedere?" ;;	
esac
#
# check the config file
#
if [ ! -f ~/.archiver.conf ]
then echo "" > ~/.archiver.conf
fi
#
# Fonction
#
pleasewait() {
zenity --title "$title" --info --text "$pleasewait" --width 200 --height 25&
dialogpid=$!
}
#
# Fonction decompress
#
tardec() {
fto=`ls -d --color=never \`tar -tf "$1" | sed 's/ /\?/g'\` 2>&1 | grep -v "^ls"`
if [ ! -z "$fto" ]
then
	if zenity --title "$title" --question --text "$overwrite \n$fto\n$proceed" --width 200 --height 25
	then
		pleasewait
		tar -xf "$1" || error=1
	else
		exit 0
	fi
else
	pleasewait
	tar -xf "$1" || error=1
fi
}
targzdec() {
fto=`ls -d --color=never \`tar -ztf "$1" | sed 's/ /\?/g'\` 2>&1 | grep -v "^ls"`
if [ ! -z "$fto" ]
then
	if zenity --title "$title" --question --text "$overwrite \n$fto\n$proceed" --width 200 --height 25
	then
		pleasewait
		tar -xzf "$1" || error=1
	else
		exit 0
	fi
else
	pleasewait
	tar -xzf "$1" || error=1
fi
}
tarbzip2dec() {
fto=`ls -d --color=never \`tar -jtf "$1" | sed 's/ /\?/g'\` 2>&1 | grep -v "^ls"`
if [ ! -z "$fto" ]
then
		if zenity --title "$title" --question --text "$overwrite \n$fto\n$proceed" --width 200 --height 25
	then
		pleasewait
		tar -jxf "$1" || error=1
	else
		exit 0
	fi
else
	pleasewait
	tar -jxf "$1" || error=1
fi
}
gzdec() {
fto=`ls -d --color=never \`echo "$1" | sed 's/.gz//'\` 2>&1 | grep -v -e "^ls"`
if [ ! -z "$fto" ]
then
	if zenity --title "$title" --question --text "$overwrite \n$fto\n$proceed" --width 200 --height 25
	then
		pleasewait
		gunzip -fN "$1" || error=1
	else
		exit 0
	fi
else
	pleasewait
	gunzip -N "$1" || error=1
fi
}
bzip2dec() {
fto=`ls -d --color=never \`echo "$1" | sed 's/.bz2//'\` 2>&1 | grep -v -e "^ls"`
if [ ! -z "$fto" ]
then
	if zenity --title "$title" --question --text"$overwrite \n$fto\n$proceed" --width 200 --height 25
	then
		pleasewait
		bunzip2 -fk "$1" || error=1
	else
		exit 0
	fi
else
		pleasewait
		bunzip2 -k "$1"  || error=1
fi
}
zipdec() {
fto=`ls -d --color=never \`zipinfo -1 "$1" | sed 's/ /\?/g'\` 2>&1 | grep -v -e "^ls"`
if [ ! -z "$fto" ]
then
	if zenity --title "$title" --question --text "$overwrite \n$fto\n$proceed" --width 200 --height 25
	then
		pleasewait
		unzip -o "$1" || error=1
	else
		exit 0
	fi
else
	pleasewait
	unzip -o "$1" || error=1
fi 
}
rardec() {
fto=`ls -d --color=never \`rar l "$1" | gawk '/2.0$/{ print $1 }'\` 2>&1 | grep -v -e "^ls"`
if [ ! -z "$fto" ]
then 
	if zenity --title "$title" --question --text "$overwrite \n$fto\n$proceed" --width 200 --height 25
	then
		pleasewait
		unrar x -kb -o+ "$1" || error=1
	else
		exit 0
	fi
else
	pleasewait
	unrar x -kb -o+ "$1" || error=1
fi
}
zdec() {
fto=`ls -d --color=never \`zcat -l "$1" | gawk '/%/{ print $4 }'\` 2>&1 | grep -v -e "^ls"`
if [ ! -z "$fto" ]
then 
	if zenity --title "$title" --question --text "$overwrite \n$fto\n$proceed" --width 200 --height 25
	then
		pleasewait
		uncompress -f "$1" || error=1
	else
		exit 0
	fi
else
	pleasewait
	uncompress "$1" || error=1
fi
}
acedec() {
pleasewait
unace x "$1" || error=1		
}				
#
# test archive or not
#
test_parity=`echo "$1" | grep [.][pP][aA][rR]$`
test_arch1=`file -b "$1" | grep -v 'PARity' | grep 'archive'`
test_arch2=`file -b "$1" | grep 'compress'`
test_arch3=`echo "$1" | grep [.][aA][cC][eE]$`
test_arch="$test_arch1$test_arch2$test_arch3"
if [ ! -z "$test_arch" ] 
then
#
# is one archive -> decompress
#
	allfiles=`echo $@ | sed 's/\ /\\n/g'`
	decompressed=""
	error=0
	if zenity --title "$title" --question --text "$decompressor \n\n$allfiles ?\n" --width 200 --height 25
	then
		while [ $# -gt 0 ]
			do
			if 
				echo "$1" | grep -i '\.tar\.gz$' 2>&1
			then
				targzdec "$1"
			elif 
				echo "$1" | grep -i '\.tgz$' 2>&1
			then
				targzdec "$1"
			elif 
				echo "$1" | grep -i '\.tar$' 2>&1
			then
				tardec "$1"
			elif 
				echo "$1" | grep -i '\.gz$' 2>&1
			then
				gzdec "$1"
			elif
				echo "$1" | grep -i '\.tar\.bz2$' 2>&1
			then
				tarbzip2dec "$1"
			elif 
				echo "$1" | grep -i '\.bz2$' 2>&1
			then
				bzip2dec "$1"
			elif	
				echo "$1" | grep -i '\.zip$' 2>&1
			then
				zipdec "$1"
			elif 
				echo "$1" | grep -i '\.rar$' 2>&1
			then	
				rardec "$1"
			elif 
				echo "$1" | grep -i '\.z$' 2>&1
			then 
				zdec "$1"
			elif
				echo "$1" | grep -i '\.ace$' 2>&1
			then 
				acedec "$1"
#
# Decompress if file is an archive with no extension and test what is for archive type
#
			else
				ifnoextension=`file -b "$1" | gawk '/compress/{ print $1 }'`
				ifnoextensiona=`file -b "$1" | gawk '/archive/{ print $1 }'`
				if [ "$ifnoextension" = "bzip2" ]
				then
					if tar -tjf "$1" 2>/dev/null
					then tarbzip2dec "$1" 
					else bzip2dec "$1"
					fi 
				elif [ "$ifnoextension" = "gzip" ]	
				then
					if tar -tzf "$1" 2>/dev/null
					then targzdec "$1" 
					else gzdec "$1"
					fi
				elif [ "$ifnoextension" = 'compress'\''d' ]
				then
					zdec "$1"
				elif [ "$ifnoextensiona" = "GNU" ]
				then
					tardec "$1"	
				elif [ "$ifnoextensiona" = "Zip" ]
				then
					zipdec "$1"
				elif [ "$ifnoextensiona" = "RAR" ]
				then
					rardec "$1"				
				else
				zenity --title "$title" --warning --text "$1 $beuh $noextension" --width 200 --height 25
				fi
			fi	
#
# End script for decompression
#
			if [ $error = 0 ]
			then
				decompressed="$decompressed $1\n"
			fi
			if [ $error = 1 ]
			then
				zenity --title "$title" --warning --text "$1 $beuh $noextension" --width 200 --height 25
			fi
			kill $dialogpid
			shift
		done
	else 
		exit 0
	fi
	if [ ! -z "$decompressed" ]
	then
		zenity --title "$title" --info --text "$decompressed $compr" --width 200 --height 25
	fi	
#
# parity test or recovery
#
elif [ ! -z "$test_parity" ] 
then 
	parbinary=`which par || which parchive` 
	testpar=`$parbinary c "$1" 2>&1 | gawk '/NOT FOUND/{ print $1 }'`
	testrecover=`$parbinary c "$1" 2>&1 | grep "Too many missing files:"`
	if [ -z "$testpar" ]
	then zenity --title "$title" --info --text "$parchive$parok" --width 200 --height 25
	else 
		if zenity --title "$title" --question --text "$parchive$testpar$parnotok" --width 200 --height 25
		then
			if [ -z "$testrecover" ]
			then
				pleasewait
				$parbinary r "$1"
				kill $dialogpid
			else
				zenity --title "$title" --warning --text "$parmiss" --width 200 --height 25
			fi	
		else 
			exit 0
		fi
	fi
else 
#
# test if programm are availlable
#
	listcompprg="tar zip gzip bzip2 rar compress"
	for u in $listcompprg
	do
		if which $u 2>/dev/null
		then
			eval a$u="$valid"
		else
			eval a$u="$notvalid"
		fi
	done
	if which par 2> /dev/null || which parchive 2> /dev/null
	then 
		apar="$valid"
	else
		apar="$notvalid"
	fi
#
# is not one archive -> compress
#
	if [ $# = 1 ] 
	then
		archive="$1"
	fi
	if
		nom=`zenity --title "$title" --entry --text "$filename" --entry-text "$archive" --width 200 --height 25 2>&1`
	then
		if [ ! -d "$1" -a $# = 1 ]
		then
			configsingle=`cat ~/.archiver.conf | gawk '/single/{ print $2 }'`
			if [ -z "$configsingle" ]
			then 
				compres=`zenity --title "$title" --list --radiolist --column "$choix" --column "$format" --column "$info" --text "$compressor" FALSE ".zip" "$azip" TRUE ".gz" "$agzip" FALSE ".bz2" "$abzip2" FALSE ".Z" "$acompress" FALSE ".rar" "$arar" FALSE ".par" "$apar"  --width 200 --height 220 2>&1`
			else
				compres="$configsingle"
			fi	
		else
			configmulti=`cat ~/.archiver.conf | gawk '/multi/{ print $2}'`
			if [ -z "$configmulti" ]
			then
				compres=`zenity --title "$title" --list --radiolist --column "$choix" --column "$format" --column "$info" TRUE ".tar.gz" "$agzip" FALSE ".tar.bz2" "$abzip2" FALSE ".zip" "$azip" FALSE ".tar" "$atar" FALSE ".rar" "$arar" FALSE ".par" "$apar" --width 200 --height 220 2>&1`
			else
				compres="$configmulti"
			fi

		fi
		compres=`echo $compres | sed 's/\"//g'`
		nom="${nom%$compres}"
		if [ ! -z "$compres" ]
		then
			while [ -f ./"$nom"$compres ]
			do
				if zenity --title "$title" --question --text "$fileexist" --width 200 --height 25
				then
					rm -f ./"$nom"$compres
				else 
					if zenity --title "$title" --entry --text "$filename" --entry-text "$archive" --width 200 --height 25
					then
						continue 
					else
						exit 0
					fi 
				fi
			done
		else
		exit 0
		fi
		pleasewait
	case $compres 
		in 
			.tar.gz )
				while [ $# -gt 0 ]
				do
					if [ -f ./"$nom".tar ]
					then 
						tar -rf ./"$nom".tar "$1"
					else
						tar -cf ./"$nom".tar "$1"
					fi
					shift
				done 
				gzip -f -9 ./"$nom".tar ;;
			.tar.bz2 ) 
				while [ $# -gt 0 ]
				do
					if [ -f ./"$nom".tar ]
					then 
						tar -rf ./"$nom".tar "$1"
					else
						tar -cf ./"$nom".tar "$1"
					fi
					shift
				done
				bzip2 -f -9 ./"$nom".tar ;;
			.zip )
				while [ $# -gt 0 ]
				do
					if [ -f ./"$nom".zip ]
					then 
	 	   			zip -r -9 ./"$nom".zip "$1"
					else
						zip -r -u -9  ./"$nom".zip "$1"
					fi
					shift
				done ;;
			.tar )
				while [ $# -gt 0 ]
				do
					if [ -f ./"$nom".tar ]
					then 
  		              tar -rf ./"$nom".tar "$1"
					else
						tar -cf ./"$nom".tar "$1"
					fi
					shift
				done ;;
			.gz )
				while [ $# -gt 0 ]
				do
					gzip -cN -9 "$1" >> ./"$nom".gz
					shift
				done ;;
			.rar )
				while [ $# -gt 0 ]
				do
					rar a -r0 "$nom".rar "$1" 
					shift
				done ;;	
			.bz2 )
				bzip2 -c -9 "$1" >> ./"$nom".bz2 ;;
			.Z )
				compress -c "$1" >> ./"$nom".Z ;;
			.par )
				parbinary=`which par || which parchive`
				rm "$nom".p[0-9][0-9]
				$parbinary a "$nom".par "$@";;
			* ) 
				echo "error" ;;	
		esac	
		kill $dialogpid
		sleep 1
		zenity --title "$title" --info --text "$PWD/$nom$compres $rec" --width 200 --height 25
	else
		exit 0
	fi	
fi
