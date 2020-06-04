#! /usr/bin/bash
# traverse() -r some folder (and its subfolders)
function traverse() {
staticdecomp=0
staticNotDecomp=0
for file in "$1"/*
do
# command file - return the file type
str=$(file $file)
    if [[ ! -d $file && $str == *"Zip"* ]] #zipfile
	then
	decomp=$(( decomp+1 ))
	unzip  -qqoj $file -d "$1"/
    elif [[ ! -d $file && $str == *"bzip2"* ]] # bz2 file
        then
	decomp=$(( decomp+1 ))
	bunzip2 -qqkf $file 
    elif [[ ! -d $file && $str == *"gzip"* ]] # gz file
	then 
	decomp=$(( decomp+1 ))
	gunzip  -kf $file 
    elif [[ ! -d $file && $str == *"compress'd"* ]] # comp file
	then 
	decomp=$(( decomp+1 ))
	mv $file $file".Z"
	uncompress -q $file #the file should not be keeped because it can only be extract once
    elif [[ -f $file ]]
	 then
	NotDecomp=$(( NotDecomp+1 ))
    elif [[ -d $file ]]
	then
        traverse "${file}"
    fi 

done
return $decomp
} 

# Directory() ->func check files and folders of currently folder withour going into subfolders
function Directory()
{
fail=0
decompp=0
directory=$PWD"/"$1"/"
for file in ls $directory*
do
# command file - return the file type
str=$(file $file)
	if [[ ! -d $file && $str == *"Zip"* ]] # zip file
		then
		decompp=$(( decompp+1 ))
		unzip -qqoj $file -d "$directory"/
		echo "Unpacking:$file"
	elif [[ ! -d $file && $str == *"bzip2"* ]] # bz2 file
		then 
		decompp=$(( decompp+1 ))
		bunzip2 -qqkf $file 
		echo "Unpacking:$file" 
	elif [[ ! -d $file && $str == *"gzip"* ]] # gz file
		then 
		decompp=$(( decompp+1 ))
		gunzip  -kf $file 
		echo "Unpacking:$file"  
	elif [[ ! -d $file && $str == *"compress'd"* ]] # comp file
		then 
		decompp=$(( decompp+1 ))
		mv $file $file".Z"
		uncompress -q $file #the file should not be keeped because it can only be extract once
		echo "Unpacking:$file" 
	else
		fail=$(( fail+1 ))	
	fi

done
echo "Decompressed:$decompp archive(s)" 
}
#checkFile -> if one of the arguments  is a file then it's sent to this function
function checkFile()
{
staticSuccessdeomp=0
# command file - return the file type
str=$(file $1)
	if [[ ! -d $1 && $str == *"Zip"* ]] # zip file
		then
		Successdeomp=$(( Successdeomp+1 ))
		unzip -qqoj $1 
	elif [[ ! -d $1 && $str == *"bzip2"* ]] # bz2 file
		then 
		Successdeomp=$(( Successdeomp+1 ))
		bunzip2 -qqkf $1
	elif [[ ! -d $1 && $str == *"gzip"* ]] # gz file
		then 
		Successdeomp=$(( Successdeomp+1 ))
		gunzip  -kf $1 
	elif [[ ! -d $1 && $str == *"compress'd"* ]] # comp file
		then 
		Successdeomp=$(( Successdeomp+1 ))
		mv $1 $1".Z"
		uncompress -q $1 #the file should not be keeped because it can only be extract once
	fi
}
##main()
r=0
v=0
for args in "$@"; do
if [ -f $args ]; then
	checkFile $args
elif [ $r == 1 ] && [ $args != "-r" ] && [ "$args" != "-v" ]; then 
	r=$((r-1))
	v=0
	traverse $args
	echo "Decompress:$decomp Archive(s) "
	echo "failure : $NotDecomp "
elif [ $v == 1 ] && [ $args != "-r" ] && [ $args != "-v" ]; then 
	v=$(( v-1 ))
	r=0
	Directory $args
elif [ $r == 0 ] && [ $v == 0 ] && [ $args != "-r" ] && [ $args != "-v" ]; then
	Directory $args
elif [ $args == "-r" ]; then
	r=1
elif [ $args == "-v" ]; then
	v=1 
fi 
done

if [ $Successdeomp > 0 ]; then
echo "Decompress : $Successdeomp -there were some file (s) name in args"
fi
